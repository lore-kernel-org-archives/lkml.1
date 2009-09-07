Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbZIGWEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbZIGWEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 18:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZIGWE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 18:04:29 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:50831 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZIGWE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 18:04:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k0TMFwlvAHaovYUyZCgejvK23ywZP+3+Gg+h9LRhfqL7BW7hYXKuO5pqjnZTernNA2
         w5c9vZQLBZatBtxefj0ZjftRXS67T8DinotDoNaB+awU7ZpLaTqJluhpnAJK1woZYP5Q
         7/XBsNK6oB+wLmqppmQl5Lv4V/vnIjP6Sf+rI=
Date: Tue, 8 Sep 2009 00:04:13 +0200
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       linux-kernel@vger.kernel.org, astarikovskiy@suse.de, lenb@kernel.org,
       linux-acpi@vger.kernel.org, rjwysocki@sisk.pl
Subject: Re: [PATCH] Fix ACPI's EC regression from 2.6.29: use usleep()
	instead of msleep()
Message-ID: <20090907220413.GA2593@bizet.domek.prywatny>
References: <20090907211423.GA2535@bizet.domek.prywatny> <20090907215712.GH16533@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907215712.GH16533@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 06:57:12PM -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 07 Sep 2009, Karol Lewandowski wrote:
> > Following patch reverts commit that changed usleep() to mleep()
> > in ACPI's EC driver. That change made hotkeys on my Thinkpad T21
> > unusable after resume.
> 
> Karol, can you send us the dmidecode information for your thinkpad?

Sure, here goes dmidecode output with UUID and SN grayed out (I guess
that isn't needed).


# dmidecode 2.9
SMBIOS 2.3 present.
45 structures occupying 1573 bytes.
Table at 0x000E0010.

Handle 0x0000, DMI type 0, 20 bytes
BIOS Information
	Vendor: IBM
	Version: KZET34WW (1.16 )
	Release Date: 04/28/2004
	Address: 0xE0000
	Runtime Size: 128 kB
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
		Selectable boot is supported
		Boot from PC Card (PCMCIA) is supported
		EDD is supported
		3.5"/720 KB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		AGP is supported
		LS-120 boot is supported
		BIOS boot specification is supported

Handle 0x0001, DMI type 1, 25 bytes
System Information
	Manufacturer: IBM
	Product Name: 26478AG
	Version: Not Available
	Serial Number: -------
	UUID: ------------------------------------
	Wake-up Type: Power Switch

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer: IBM
	Product Name: 26478AG
	Version: Not Available
	Serial Number: -----------

Handle 0x0003, DMI type 3, 17 bytes
Chassis Information
	Manufacturer: IBM
	Type: Notebook
	Lock: Not Present
	Version: Not Available
	Serial Number: Not Available
	Asset Tag: No Asset Information
	Boot-up State: Unknown
	Power Supply State: Unknown
	Thermal State: Unknown
	Security Status: Unknown
	OEM Information: 0x00000000

Handle 0x0004, DMI type 126, 17 bytes
Inactive

Handle 0x0005, DMI type 126, 17 bytes
Inactive

Handle 0x0006, DMI type 4, 32 bytes
Processor Information
	Socket Designation: None
	Type: Central Processor
	Family: Pentium III
	Manufacturer: GenuineIntel
	ID: 8A 06 00 00 FF F9 83 03
	Signature: Type 0, Family 6, Model 8, Stepping 10
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
		MMX (MMX technology supported)
		FXSR (Fast floating-point save and restore)
		SSE (Streaming SIMD extensions)
	Version: Pentium(R) III
	Voltage: 1.6 V
	External Clock: 100 MHz
	Max Speed: 800 MHz
	Current Speed: 800 MHz
	Status: Populated, Enabled
	Upgrade: None
	L1 Cache Handle: 0x000A
	L2 Cache Handle: 0x000B
	L3 Cache Handle: Not Provided

Handle 0x0007, DMI type 5, 20 bytes
Memory Controller Information
	Error Detecting Method: None
	Error Correcting Capabilities:
		None
	Supported Interleave: One-way Interleave
	Current Interleave: One-way Interleave
	Maximum Memory Module Size: 512 MB
	Maximum Total Memory Size: 1024 MB
	Supported Speeds:
		Other
	Supported Memory Types:
		DIMM
		SDRAM
	Memory Module Voltage: 3.3 V
	Associated Memory Slots: 2
		0x0008
		0x0009
	Enabled Error Correcting Capabilities:
		None

Handle 0x0008, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM Slot 1
	Bank Connections: 0 3
	Current Speed: Unknown
	Type: DIMM SDRAM
	Installed Size: 128 MB (Double-bank Connection)
	Enabled Size: 128 MB (Double-bank Connection)
	Error Status: OK

Handle 0x0009, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM Slot 2
	Bank Connections: 1 4
	Current Speed: Unknown
	Type: DIMM SDRAM
	Installed Size: 128 MB (Double-bank Connection)
	Enabled Size: 128 MB (Double-bank Connection)
	Error Status: OK

Handle 0x000A, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L1 Cache
	Configuration: Enabled, Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 KB
	Maximum Size: 32 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Other
	Associativity: 4-way Set-associative

Handle 0x000B, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L2 Cache
	Configuration: Enabled, Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 256 KB
	Maximum Size: 256 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: Other

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Serial
	External Connector Type: DB-9 male
	Port Type: Serial Port 16550A Compatible

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Infrared
	External Connector Type: Infrared
	Port Type: Other

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Parallel
	External Connector Type: DB-25 female
	Port Type: Parallel Port ECP/EPP

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: External Monitor
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: PS/2 Mouse
	External Connector Type: PS/2
	Port Type: Mouse Port

Handle 0x0011, DMI type 126, 9 bytes
Inactive

Handle 0x0012, DMI type 126, 9 bytes
Inactive

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Line-In Jack
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0014, DMI type 126, 9 bytes
Inactive

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Microphone Jack
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Headphone Jack
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: S-Video-Out
	External Connector Type: Other
	Port Type: Video Port

Handle 0x0018, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Modem
	External Connector Type: RJ-11
	Port Type: Modem Port

Handle 0x0019, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Ethernet
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: USB 1
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x001B, DMI type 126, 9 bytes
Inactive

Handle 0x001C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: UltraPort(TM)
	External Connector Type: Other
	Port Type: USB

Handle 0x001D, DMI type 9, 13 bytes
System Slot Information
	Designation: CardBus Slot 1
	Type: 32-bit PC Card (PCMCIA)
	Current Usage: Available
	Length: Other
	ID: Adapter 0, Socket 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PC Card-16 is supported
		Cardbus is supported
		Zoom Video is supported
		Modem ring resume is supported
		PME signal is supported
		Hot-plug devices are supported

Handle 0x001E, DMI type 9, 13 bytes
System Slot Information
	Designation: CardBus Slot 2
	Type: 32-bit PC Card (PCMCIA)
	Current Usage: Available
	Length: Other
	ID: Adapter 1, Socket 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PC Card-16 is supported
		Cardbus is supported
		Zoom Video is supported
		Modem ring resume is supported
		PME signal is supported
		Hot-plug devices are supported

Handle 0x001F, DMI type 126, 13 bytes
Inactive

Handle 0x0020, DMI type 126, 13 bytes
Inactive

Handle 0x0021, DMI type 9, 13 bytes
System Slot Information
	Designation: Mini-PCI Slot 1
	Type: 32-bit PCI
	Current Usage: Available
	Length: Other
	ID: 1
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PME signal is supported
		SMBus signal is supported

Handle 0x0022, DMI type 126, 13 bytes
Inactive

Handle 0x0023, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 1 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x0024, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0023
	Error Information Handle: No Error
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 128 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM 1
	Bank Locator: Bank 0/3
	Type: SDRAM
	Type Detail: Synchronous
	Speed: Unknown

Handle 0x0025, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0023
	Error Information Handle: No Error
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 128 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM 2
	Bank Locator: Bank 1/4
	Type: SDRAM
	Type Detail: Synchronous
	Speed: Unknown

Handle 0x0026, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0000FFFFFFF
	Range Size: 256 MB
	Physical Array Handle: 0x0023
	Partition Width: 0

Handle 0x0027, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x00007FFFFFF
	Range Size: 128 MB
	Physical Device Handle: 0x0024
	Memory Array Mapped Address Handle: 0x0026
	Partition Row Position: 1

Handle 0x0028, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00008000000
	Ending Address: 0x0000FFFFFFF
	Range Size: 128 MB
	Physical Device Handle: 0x0025
	Memory Array Mapped Address Handle: 0x0026
	Partition Row Position: 1

Handle 0x0029, DMI type 21, 7 bytes
Built-in Pointing Device
	Type: Track Point
	Interface: PS/2
	Buttons: 3

Handle 0x002A, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0x002B, DMI type 128, 12 bytes
OEM-specific Type
	Header and Data:
		80 0C 2B 00 01 01 02 00 01 00 18 01
	Strings:
		Alert on LAN
		IBM 0020

Handle 0x002C, DMI type 127, 4 bytes
End Of Table

