Return-Path: <linux-kernel-owner+w=401wt.eu-S1762832AbXHFTbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762832AbXHFTbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761372AbXHFTbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:31:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57577 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761229AbXHFTbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:31:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: Disk spin down issue on shut down/suspend to disk
Date: Mon, 6 Aug 2007 21:40:28 +0200
User-Agent: KMail/1.9.5
Cc: Michael Sedkowski <sedmich@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <838f88840708051428p3d65ff42w627af4bc38f57de3@mail.gmail.com> <1186424492.4355.1.camel@nx6310> <46B76BBC.9010107@gmail.com>
In-Reply-To: <46B76BBC.9010107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708062140.28994.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 6 August 2007 20:43, Tejun Heo wrote:
> Michael Sedkowski wrote:
> >> Hmmm... If the problem only shows up on nx6325, it might be that ACPI is
> >> pulling unnecessary stunt.  Please apply the attached patch and report
> >> when the disk spins down and up.
> > 
> > Disk spins down on "Pre-shutdown prepare" and then goes up and down on
> > "Power down".
> 
> Oh... crap, so acpi wants to sync cache on shutdown.  I wonder whether
> it spins down the disk correctly.  Does emergency unload count increase
> after each power down?

How to check that?

> Also, please post the result of 'dmidecode'. 

Here's mine, from nx6325 (Michael's is a different model):

# dmidecode 2.8
SMBIOS 2.4 present.
23 structures occupying 1029 bytes.
Table at 0x000F3FA3.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: Hewlett-Packard
	Version: 68TT2 Ver. F.02
	Release Date: 07/06/2006
	Address: 0xE0000
	Runtime Size: 128 kB
	ROM Size: 1024 kB
	Characteristics:
		PCI is supported
		PC Card (PCMCIA) is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		EDD is supported
		3.5"/720 KB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		ACPI is supported
		USB legacy is supported
		LS-120 boot is supported
		Smart battery is supported
		BIOS boot specification is supported
		Function key-initiated network boot is supported
		Targeted content distribution is supported
	BIOS Revision: 15.2
	Firmware Revision: 64.21

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: Hewlett-Packard
	Product Name: HP Compaq nx6325 (EY351EA#AKD)
	Version: F.02
	Serial Number: CNU63201YR
	UUID: CDF6EA3B-A5D7-DD11-0188-6D990C3F6129
	Wake-up Type: Power Switch
	SKU Number: EY351EA#AKD
	Family: 103C_5336AN

Handle 0x0040, DMI type 126, 33 bytes
Inactive

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer: Hewlett-Packard
	Product Name: 30B0
	Version: KBC Version 40.15
	Serial Number: Not Specified

Handle 0x0003, DMI type 3, 13 bytes
Chassis Information
	Manufacturer: Hewlett-Packard
	Type: Notebook
	Lock: Not Present
	Version: Not Specified
	Serial Number: CNU63201YR
	Asset Tag: CNU63201YR
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: External Interface Enabled

Handle 0x0041, DMI type 126, 32 bytes
Inactive

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U10
	Type: Central Processor
	Family: Athlon 64
	Manufacturer: AMD(R)
	ID: 82 0F 04 00 FF FB 8B 17
	Signature: Extended Family 0, Model 8, Stepping 2
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		MMX (MMX technology supported)
		FXSR (Fast floating-point save and restore)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		HTT (Hyper-threading technology)
	Version: AMD Turion(tm) 64 X2 Mobile TL-60              
	Voltage: 1.1 V
	External Clock: 200 MHz
	Max Speed: 2000 MHz
	Current Speed: 2000 MHz
	Status: Populated, Enabled
	Upgrade: None
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: Not Provided
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L1 Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 128 KB
	Maximum Size: 128 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L2 Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: External
	Installed Size: 512 KB
	Maximum Size: 512 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: None
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x0007, DMI type 9, 13 bytes
System Slot Information
	Designation: PC CARD-Slot 0
	Type: 32-bit PC Card (PCMCIA)
	Current Usage: Available
	Length: Short
	ID: Adapter 0, Socket 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PC Card-16 is supported
		Cardbus is supported
		PME signal is supported

Handle 0x0008, DMI type 10, 6 bytes
On Board Device Information
	Type: Video
	Status: Enabled
	Description: 128

Handle 0x0009, DMI type 11, 5 bytes
OEM Strings
	String 1: www.hp.com
	String 2: ABS 70/71 79 7A 7B 7C

Handle 0x000A, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 4 GB
	Error Information Handle: No Error
	Number Of Devices: 2

Handle 0x000B, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x000A
	Error Information Handle: No Error
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM #1
	Bank Locator: Not Specified
	Type: DDR2
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 7F7F7F7F7F510000
	Serial Number: 0213A826
	Asset Tag: Not Specified
	Part Number: 64T128021HDL3SB   

Handle 0x000C, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x000A
	Error Information Handle: No Error
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM #2
	Bank Locator: Not Specified
	Type: DDR2
	Type Detail: Synchronous
	Speed: 667 MHz (1.5 ns)
	Manufacturer: 7F98000000000000
	Serial Number: 670FA506
	Asset Tag: Not Specified
	Part Number:                   

Handle 0x000D, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Array Handle: 0x000A
	Partition Width: 0

Handle 0x000E, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x000B
	Memory Array Mapped Address Handle: 0x000D
	Partition Row Position: 1

Handle 0x000F, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00040000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x000C
	Memory Array Mapped Address Handle: 0x000D
	Partition Row Position: 2

Handle 0x0010, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0x0085, DMI type 133, 34 bytes
OEM-specific Type
	Header and Data:
		85 22 85 00 01 50 14 B9 08 9F 08 02 00 32 00 1C
		00 F5 2D 43 FB 30 2A 02 E0 40 00 00 49 0F 58 0F
		55 0F
	Strings:
		00185 0D/24/2006
		HP                

Handle 0x0086, DMI type 126, 34 bytes
Inactive

Handle 0x0011, DMI type 144, 26 bytes
OEM-specific Type
	Header and Data:
		90 1A 11 00 FD 00 65 00 11 00 80 02 06 02 31 00
		00 00 00 00 01 00 EB 07 00 00

Handle 0x0012, DMI type 127, 4 bytes
End Of Table
