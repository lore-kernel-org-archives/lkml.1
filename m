Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbZLRRGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbZLRRGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbZLRRGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:06:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33803 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbZLRRGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:06:39 -0500
Date: Fri, 18 Dec 2009 18:06:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: -tip: origin tree boot crash
Message-ID: <20091218170622.GA1354@elte.hu>
References: <20091218164509.GA14574@elte.hu>
 <1261155689.27372.1444.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261155689.27372.1444.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave@sr71.net> wrote:

> On Fri, 2009-12-18 at 17:45 +0100, Ingo Molnar wrote:
> > Today's -tip crashes during bootup (x86 allyesconfig, 64-bit), due to this 
> > commit from yesterday's upstream -git tree:
> > 
> >  commit a328e95b82c1b8483ae5ab2f809140664d7f6c92
> >  Author: Dave Hansen <dave@sr71.net>
> >  Date:   Thu Oct 1 15:43:32 2009 -0700
> > 
> >     leds: LED driver for Intel NAS SS4200 series (v5)
> > 
> > The crash serial log is attached below. I suspect this driver was not 
> > booted on hardware that does not have that LED interface?
> 
> I just double-checked it again on a couple of my systems and it seems to 
> deny loading the module correctly.
> 
> What kind of hardware is this?  Could you send me 'dmidecode' output?
> 
> I'm wondering if your hardware matched the "Intel" string somehow and the 
> dmi code didn't bother to check anything else.  I'll also go try and run on 
> a few more pieces of hardware and see if I can get it to trigger.

It's an Athlon64 whitebox PC - a pretty old one - and nothing special.

Also note the crash signature - it crashes in the DMI code. Note, this is a 
built-in-driver (not a modular driver) bootup. dmidecode is below.

	Ingo

-------------------------------->
# dmidecode 2.7
SMBIOS 2.3 present.
72 structures occupying 2055 bytes.
Table at 0x000F0000.

Handle 0x0000, DMI type 0, 20 bytes.
BIOS Information
	Vendor: Phoenix Technologies, LTD
	Version: ASUS A8N-E ACPI BIOS Revision 1008
	Release Date: 08/22/2005
	Address: 0xE0000
	Runtime Size: 128 kB
	ROM Size: 512 kB
	Characteristics:
		PCI is supported
		PNP is supported
		APM is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/360 KB floppy services are supported (int 13h)
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 KB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		LS-120 boot is supported
		ATAPI Zip drive boot is supported
		BIOS boot specification is supported

Handle 0x0001, DMI type 1, 25 bytes.
System Information
	Manufacturer: System manufacturer
	Product Name: System Product Name
	Version: System Version
	Serial Number: System Serial Number
	UUID: xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	Wake-up Type: Power Switch

Handle 0x0002, DMI type 2, 8 bytes.
Base Board Information
	Manufacturer: ASUSTeK Computer INC.
	Product Name: A8N-E
	Version: 2.XX    
	Serial Number: 123456789000

Handle 0x0003, DMI type 3, 17 bytes.
Chassis Information
	Manufacturer: Chassis Manufacture
	Type: Desktop
	Lock: Not Present
	Version: Chassis Version
	Serial Number: EVAL          
	Asset Tag: 123456789000
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00000001

Handle 0x0004, DMI type 4, 35 bytes.
Processor Information
	Socket Designation: Socket 939
	Type: Central Processor
	Family: Athlon 64
	Manufacturer: AMD
	ID: 32 0F 02 00 FF FB 8B 17
	Signature: Extended Family 0, Model 3, Stepping 2
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
	Version: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
	Voltage: 1.3 V
	External Clock: 200 MHz
	Max Speed: 3700 MHz
	Current Speed: 2000 MHz
	Status: Populated, Enabled
	Upgrade: <OUT OF SPEC>
	L1 Cache Handle: 0x000A
	L2 Cache Handle: 0x000B
	L3 Cache Handle: Not Provided
	Serial Number:  
	Asset Tag:  
	Part Number:  

Handle 0x0005, DMI type 5, 24 bytes.
Memory Controller Information
	Error Detecting Method: 64-bit ECC
	Error Correcting Capabilities:
		None
	Supported Interleave: One-way Interleave
	Current Interleave: One-way Interleave
	Maximum Memory Module Size: 1024 MB
	Maximum Total Memory Size: 4096 MB
	Supported Speeds:
		70 ns
		60 ns
		50 ns
	Supported Memory Types:
		Standard
		SDRAM
	Memory Module Voltage: 2.9 V
	Associated Memory Slots: 4
		0x0006
		0x0007
		0x0008
		0x0009
	Enabled Error Correcting Capabilities: None

Handle 0x0006, DMI type 6, 12 bytes.
Memory Module Information
	Socket Designation: A0
	Bank Connections: 0 1
	Current Speed: Unknown
	Type: DIMM
	Installed Size: 512 MB (Double-bank Connection)
	Enabled Size: 512 MB (Double-bank Connection)
	Error Status: OK

Handle 0x0007, DMI type 6, 12 bytes.
Memory Module Information
	Socket Designation: A1
	Bank Connections: None
	Current Speed: Unknown
	Type: DIMM
	Installed Size: Not Installed
	Enabled Size: Not Installed
	Error Status: OK

Handle 0x0008, DMI type 6, 12 bytes.
Memory Module Information
	Socket Designation: A2
	Bank Connections: 4 5
	Current Speed: 50 ns
	Type: DIMM
	Installed Size: 512 MB (Double-bank Connection)
	Enabled Size: 512 MB (Double-bank Connection)
	Error Status: OK

Handle 0x0009, DMI type 6, 12 bytes.
Memory Module Information
	Socket Designation: A3
	Bank Connections: None
	Current Speed: 50 ns
	Type: DIMM
	Installed Size: Not Installed
	Enabled Size: Not Installed
	Error Status: OK

Handle 0x000A, DMI type 7, 19 bytes.
Cache Information
	Socket Designation: L1 Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 128 KB
	Maximum Size: 128 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 4-way Set-associative

Handle 0x000B, DMI type 7, 19 bytes.
Cache Information
	Socket Designation: L2 Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 512 KB
	Maximum Size: 512 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x000C, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: PRIMARY IDE
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x000D, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: SECONDARY IDE
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x000E, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: FDD
	Internal Connector Type: On Board Floppy
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: 8251 FIFO Compatible

Handle 0x000F, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: COM1
	Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
	External Reference Designator:  
	External Connector Type: DB-9 male
	Port Type: Serial Port 16450 Compatible

Handle 0x0010, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: LPT1
	Internal Connector Type: DB-25 female
	External Reference Designator:  
	External Connector Type: DB-25 female
	Port Type: Parallel Port ECP/EPP

Handle 0x0011, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: PS/2 Keyboard
	Internal Connector Type: PS/2
	External Reference Designator:  
	External Connector Type: PS/2
	Port Type: Keyboard Port

Handle 0x0012, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: PS/2 Mouse
	Internal Connector Type: PS/2
	External Reference Designator:  
	External Connector Type: PS/2
	Port Type: Mouse Port

Handle 0x0013, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB1
	External Connector Type: Other
	Port Type: USB

Handle 0x0014, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB2
	External Connector Type: Other
	Port Type: USB

Handle 0x0015, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB3
	External Connector Type: Other
	Port Type: USB

Handle 0x0016, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB4
	External Connector Type: Other
	Port Type: USB

Handle 0x0017, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB5
	External Connector Type: Other
	Port Type: USB

Handle 0x0018, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB6
	External Connector Type: Other
	Port Type: USB

Handle 0x0019, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB7
	External Connector Type: Other
	Port Type: USB

Handle 0x001A, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB8
	External Connector Type: Other
	Port Type: USB

Handle 0x001B, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB9
	External Connector Type: Other
	Port Type: USB

Handle 0x001C, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB10
	External Connector Type: Other
	Port Type: USB

Handle 0x001D, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Line In
	External Connector Type: None
	Port Type: Audio Port

Handle 0x001E, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Line Out
	Internal Connector Type: None
	External Reference Designator: Line Out
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x001F, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Mic In
	Internal Connector Type: None
	External Reference Designator: Mic In
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0020, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Back Surround L/R
	Internal Connector Type: None
	External Reference Designator: Back Surround L/R
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0021, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Side Surround L/R
	Internal Connector Type: None
	External Reference Designator: Side Surround L/R
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0022, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Center/LFE
	Internal Connector Type: None
	External Reference Designator: Center/LFE
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0023, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: CD In
	Internal Connector Type: On Board Sound Input From CD-ROM
	External Reference Designator: CD In
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0024, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Aux In
	Internal Connector Type: On Board Sound Input From CD-ROM
	External Reference Designator: Aux In
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0025, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: SPDIF Out
	Internal Connector Type: None
	External Reference Designator: Audio SPDIF Out
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0026, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Front Panel
	Internal Connector Type: Other
	External Reference Designator: Front Panel
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0027, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: ETHERNET
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x0028, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Joystick
	External Connector Type: DB-15 female
	Port Type: Joystick Port

Handle 0x0029, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: SATA1
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x002A, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: SATA2
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x002B, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: SATA3
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x002C, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: SATA4
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x002D, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: MIDI
	External Connector Type: DB-15 female
	Port Type: MIDI Port

Handle 0x002E, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: CHASSIS
	External Connector Type: None
	Port Type: Other

Handle 0x002F, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: CPU_FAN1
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: None

Handle 0x0030, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: CHIPSET_FAN1
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: None

Handle 0x0031, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: PWR_FAN1
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: None

Handle 0x0032, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: CHA_FAN1
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: None

Handle 0x0033, DMI type 8, 9 bytes.
Port Connector Information
	Internal Reference Designator: CHA_FAN2
	Internal Connector Type: None
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: None

Handle 0x0034, DMI type 9, 13 bytes.
System Slot Information
	Designation: PCI1
	Type: 32-bit PCI
	Current Usage: Available
	Length: Short
	ID: 1
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x0035, DMI type 9, 13 bytes.
System Slot Information
	Designation: PCI2
	Type: 32-bit PCI
	Current Usage: In Use
	Length: Short
	ID: 2
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x0036, DMI type 9, 13 bytes.
System Slot Information
	Designation: PCI3
	Type: 32-bit PCI
	Current Usage: Available
	Length: Short
	ID: 3
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x0037, DMI type 9, 13 bytes.
System Slot Information
	Designation: PCIEX16_1
	Type: x16 PCI Express
	Current Usage: In Use
	Length: Short
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x0038, DMI type 9, 13 bytes.
System Slot Information
	Designation: PCIEX4_1
	Type: x4 PCI Express
	Current Usage: Available
	Length: Short
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x0039, DMI type 9, 13 bytes.
System Slot Information
	Designation: PCIEX1_1
	Type: x1 PCI Express
	Current Usage: Available
	Length: Short
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x003A, DMI type 9, 13 bytes.
System Slot Information
	Designation: PCIEX1_2
	Type: x1 PCI Express
	Current Usage: Available
	Length: Short
	Characteristics:
		5.0 V is provided
		PME signal is supported

Handle 0x003B, DMI type 13, 22 bytes.
BIOS Language Information
	Installable Languages: 3
		n|US|iso8859-1
		n|US|iso8859-1
		r|CA|iso8859-1
	Currently Installed Language: n|US|iso8859-1

Handle 0x003C, DMI type 16, 15 bytes.
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 4 GB
	Error Information Handle: Not Provided
	Number Of Devices: 4

Handle 0x003D, DMI type 17, 27 bytes.
Memory Device
	Array Handle: 0x003C
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 512 MB
	Form Factor: DIMM
	Set: None
	Locator: A0
	Bank Locator: Bank0/1
	Type: Unknown
	Type Detail: None
	Speed: 400 MHz (2.5 ns)
	Manufacturer: None
	Serial Number: None
	Asset Tag: None
	Part Number: None

Handle 0x003E, DMI type 17, 27 bytes.
Memory Device
	Array Handle: 0x003C
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: A1
	Bank Locator: Bank2/3
	Type: Unknown
	Type Detail: None
	Speed: Unknown
	Manufacturer: None
	Serial Number: None
	Asset Tag: None
	Part Number: None

Handle 0x003F, DMI type 17, 27 bytes.
Memory Device
	Array Handle: 0x003C
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 512 MB
	Form Factor: DIMM
	Set: None
	Locator: A2
	Bank Locator: Bank4/5
	Type: Unknown
	Type Detail: None
	Speed: 400 MHz (2.5 ns)
	Manufacturer: None
	Serial Number: None
	Asset Tag: None
	Part Number: None

Handle 0x0040, DMI type 17, 27 bytes.
Memory Device
	Array Handle: 0x003C
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: A3
	Bank Locator: Bank6/7
	Type: Unknown
	Type Detail: None
	Speed: Unknown
	Manufacturer: None
	Serial Number: None
	Asset Tag: None
	Part Number: None

Handle 0x0041, DMI type 19, 15 bytes.
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 1 GB
	Physical Array Handle: 0x003C
	Partition Width: 0

Handle 0x0042, DMI type 20, 19 bytes.
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0001FFFFFFF
	Range Size: 512 MB
	Physical Device Handle: 0x003D
	Memory Array Mapped Address Handle: 0x0041
	Partition Row Position: 1

Handle 0x0043, DMI type 20, 19 bytes.
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x003E
	Memory Array Mapped Address Handle: 0x0041
	Partition Row Position: 1

Handle 0x0044, DMI type 20, 19 bytes.
Memory Device Mapped Address
	Starting Address: 0x00020000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 512 MB
	Physical Device Handle: 0x003F
	Memory Array Mapped Address Handle: 0x0041
	Partition Row Position: 1

Handle 0x0045, DMI type 20, 19 bytes.
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000000003FF
	Range Size: 1 kB
	Physical Device Handle: 0x0040
	Memory Array Mapped Address Handle: 0x0041
	Partition Row Position: 1

Handle 0x0046, DMI type 32, 11 bytes.
System Boot Information
	Status: No errors detected

Handle 0x0047, DMI type 127, 4 bytes.
End Of Table

