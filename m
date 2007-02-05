Return-Path: <linux-kernel-owner+w=401wt.eu-S1752252AbXBEJzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbXBEJzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 04:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbXBEJzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 04:55:04 -0500
Received: from serv04.lahn.de ([213.239.197.57]:57737 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbXBEJzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 04:55:00 -0500
X-Greylist: delayed 1143 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Feb 2007 04:54:59 EST
Date: Mon, 5 Feb 2007 10:35:21 +0100
From: Michael Leun <ml@newton.leun.net>
To: mitr@volny.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] wistron button support for fujitsu-siemens Amilo D88x0
Message-ID: <20070205103521.0f20779d@xenia.leun.net>
Organization: Not Organized
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

works just fine for me on a Amilo D8820.

--- wistron_btns.c.orig	2006-03-20 19:33:30.000000000 +0100
+++ wistron_btns.c	2006-03-20 19:00:23.000000000 +0100
@@ -306,6 +306,17 @@
 	{ KE_END, 0 }
 };
 
+static struct key_entry keymap_fs_amilo_d88x0[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x08, KEY_MUTE },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_PROG3 },
+	{ KE_END, 0 }
+};
+
 /*
  * If your machine is not here (which is currently rather likely), please send
  * a list of buttons and their key codes (reported when loading this module
@@ -339,6 +350,15 @@
 		},
 		.driver_data = keymap_acer_travelmate_240
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Fujitsu Siemens Amilo D88x0",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AMILO D"),
+		},
+		.driver_data = keymap_fs_amilo_d88x0
+	},
 	{ NULL, }
 };
 
# dmidecode 2.8
SMBIOS 2.31 present.
35 structures occupying 1157 bytes.
Table at 0x000E8E30.

Handle 0x0000, DMI type 0, 20 bytes
BIOS Information
	Vendor: Phoenix Technologies LTD
	Version: R01-A1F
	Release Date: 06/02/2003
	Address: 0xE29D0
	Runtime Size: 120368 bytes
	ROM Size: 512 kB
	Characteristics:
		ISA is supported
		PCI is supported
		PC Card (PCMCIA) is supported
		PNP is supported
		APM is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		ACPI is supported
		USB legacy is supported
		AGP is supported
		Smart battery is supported
		BIOS boot specification is supported

Handle 0x0001, DMI type 1, 25 bytes
System Information
	Manufacturer: FUJITSU SIEMENS
	Product Name: AMILO D        
	Version: -1             
	Serial Number: 1234567890                    
	UUID: EEB04FA0-09C4-11D8-B9F5-EE823498EF08
	Wake-up Type: Power Switch

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer: FUJITSU SIEMENS
	Product Name: AMILO D        
	Version: Rev.SB         
	Serial Number: None                          

Handle 0x0003, DMI type 3, 17 bytes
Chassis Information
	Manufacturer: FUJITSU SIEMENS
	Type: Notebook
	Lock: Not Present
	Version: N/A            
	Serial Number: 1234567890123                   
	Asset Tag: ABCDEFGHIJKLM                   
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00001234

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U1
	Type: Central Processor
	Family: Pentium 4
	Manufacturer: GenuineIntel
	ID: 27 0F 00 00 FF F9 EB BF
	Signature: Type 0, Family 15, Model 2, Stepping 7
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
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		DS (Debug store)
		ACPI (ACPI supported)
		MMX (MMX technology supported)
		FXSR (Fast floating-point save and restore)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		SS (Self-snoop)
		HTT (Hyper-threading technology)
		TM (Thermal monitor supported)
		PBE (Pending break enabled)
	Version: Intel(R) Pentium(
	Voltage: 1.3 V
	External Clock: Unknown
	Max Speed: 2400 MHz
	Current Speed: 2800 MHz
	Status: Populated, Enabled
	Upgrade: Slot 1
	L1 Cache Handle: 0x0008
	L2 Cache Handle: 0x0009
	L3 Cache Handle: Not Provided
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x0005, DMI type 5, 20 bytes
Memory Controller Information
	Error Detecting Method: None
	Error Correcting Capabilities:
		None
	Supported Interleave: One-way Interleave
	Current Interleave: One-way Interleave
	Maximum Memory Module Size: 512 MB
	Maximum Total Memory Size: 1024 MB
	Supported Speeds:
		70 ns
		60 ns
	Supported Memory Types:
		DIMM
		SDRAM
	Memory Module Voltage: 3.3 V
	Associated Memory Slots: 2
		0x0006
		0x0007
	Enabled Error Correcting Capabilities:
		Unknown

Handle 0x0006, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: M1
	Bank Connections: 0 1
	Current Speed: Unknown
	Type: DIMM SDRAM
	Installed Size: 1024 MB (Double-bank Connection)
	Enabled Size: 1024 MB (Double-bank Connection)
	Error Status: OK

Handle 0x0007, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: M2
	Bank Connections: 2 3
	Current Speed: Unknown
	Type: DIMM SDRAM
	Installed Size: 1024 MB (Double-bank Connection)
	Enabled Size: 1024 MB (Double-bank Connection)
	Error Status: OK

Handle 0x0008, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1 Cache
	Configuration: Enabled, Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 20 KB
	Maximum Size: 20 KB
	Supported SRAM Types:
		Burst
		Pipeline Burst
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: None
	System Type: Other
	Associativity: Other

Handle 0x0009, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2 Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 512 KB
	Maximum Size: 512 KB
	Supported SRAM Types:
		Burst
		Pipeline Burst
		Asynchronous
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: Other

Handle 0x000A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CN2
	Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
	External Reference Designator: Serial 1
	External Connector Type: DB-9 male
	Port Type: Serial Port 16550A Compatible

Handle 0x000B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CN3
	Internal Connector Type: 25 Pin Dual Inline (pin 26 cut)
	External Reference Designator: Parallel
	External Connector Type: DB-25 female
	Port Type: Parallel Port ECP/EPP

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CN1
	Internal Connector Type: None
	External Reference Designator: Keyboard
	External Connector Type: PS/2
	Port Type: Keyboard Port

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CN1
	Internal Connector Type: None
	External Reference Designator: Mouse
	External Connector Type: PS/2
	Port Type: Mouse Port

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CN5
	Internal Connector Type: None
	External Reference Designator: USB
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CN6
	Internal Connector Type: None
	External Reference Designator: USB
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CN26
	Internal Connector Type: None
	External Reference Designator: MODEM
	External Connector Type: RJ-11
	Port Type: Modem Port

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: U49
	Internal Connector Type: None
	External Reference Designator: LAN
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CN24
	Internal Connector Type: None
	External Reference Designator: LINE-IN JACK
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CN24
	Internal Connector Type: None
	External Reference Designator: HEADPHONE-OUT JACK
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CN2
	Internal Connector Type: None
	External Reference Designator: EXTERNAL DISPLAY
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CN2
	Internal Connector Type: None
	External Reference Designator: IEEE 1394
	External Connector Type: IEEE 1394
	Port Type: Firewire (IEEE P1394)

Handle 0x0016, DMI type 9, 13 bytes
System Slot Information
	Designation: CARDBUS A
	Type: 32-bit PC Card (PCMCIA)
	Current Usage: Available
	Length: Other
	ID: Adapter 0, Socket 1
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PC Card-16 is supported
		Cardbus is supported
		PME signal is supported

Handle 0x0017, DMI type 9, 13 bytes
System Slot Information
	Designation: CARDBUS B
	Type: 32-bit PC Card (PCMCIA)
	Current Usage: Available
	Length: Other
	ID: Adapter 0, Socket 2
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PC Card-16 is supported
		Cardbus is supported
		PME signal is supported

Handle 0x0018, DMI type 10, 8 bytes
On Board Device 1 Information
	Type: Video
	Status: Enabled
	Description: ATI M9000
On Board Device 2 Information
	Type: Sound
	Status: Enabled
	Description: SIS 7012

Handle 0x0019, DMI type 11, 5 bytes
OEM Strings
	String 1: 1
	String 2: 1234567890

Handle 0x001A, DMI type 12, 5 bytes
System Configuration Options
	Option 1: Jumper settings can be described here.

Handle 0x001B, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 1 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x001C, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x001B
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 2
	Locator: M1
	Bank Locator: Bank 0
	Type: SDRAM
	Type Detail: Synchronous
	Speed: Unknown
	Manufacturer: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x001D, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x001B
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 2
	Locator: M2
	Bank Locator: Bank 1
	Type: SDRAM
	Type Detail: Synchronous
	Speed: Unknown
	Manufacturer: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x001E, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Array Handle: 0x001B
	Partition Width: 0

Handle 0x001F, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x001C
	Memory Array Mapped Address Handle: 0x001E
	Partition Row Position: 1

Handle 0x0020, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00040000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x001D
	Memory Array Mapped Address Handle: 0x001E
	Partition Row Position: 1

Handle 0x0021, DMI type 32, 20 bytes
System Boot Information
	Status: <OUT OF SPEC>

Handle 0x0022, DMI type 127, 4 bytes
End Of Table



-- 
MfG,

Michael Leun

