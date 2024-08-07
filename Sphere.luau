local RunService = game:GetService("RunService")

local noiseRate = 0.1
local yOffset = 80

local sphereFolder = Instance.new("Folder", workspace)
sphereFolder.Parent = workspace
sphereFolder.Name = "Sphere"

local function calculatePartColor(x: number, y: number, z: number, rate: number): Color3
	local red = math.noise(x * rate, y * rate, z * rate) * 0.5 + 0.5
	local green = math.noise(z * rate, x * rate, y * rate) * 0.5 + 0.5
	local blue = math.noise(y * rate, z * rate, x * rate) * 0.5 + 0.5
	return Color3.new(red, green, blue)
end

local function isWithinSphereShell(position: Vector3, radius: number): boolean
	return (position - Vector3.new(0,0,0)).Magnitude <= radius
		and (position - Vector3.new(0,0,0)).Magnitude >= radius-1
end

local function createPart()
	local part = Instance.new("Part")
	part.Parent = sphereFolder
	part.Anchored = true
	part.Material = Enum.Material.SmoothPlastic
	part.Size = Vector3.new(1, 1, 1)
	part.Locked = true
	return part
end

local function drawSphereLayer(radius)    
	local reusableParts = sphereFolder:GetChildren()

	for x = -radius, radius do
		for y = -radius, radius do
			for z = -radius, radius do
				if isWithinSphereShell(Vector3.new(x,y,z), radius) then
					local part
					if #reusableParts > 0 then
						part = table.remove(reusableParts)
					else
						part = createPart()
					end
					part.Color = calculatePartColor(x, y, z, noiseRate)
					part.Position = Vector3.new(x, y + yOffset, z)
				end
			end
		end
	end
end

for radius = 5, 40,0.1 do
	drawSphereLayer(radius)
	RunService.Stepped:Wait()
end
