Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624Ab0AMExW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab0AMExW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 23:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615Ab0AMExV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 23:53:21 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:34798 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab0AMExU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 23:53:20 -0500
Date: Wed, 13 Jan 2010 10:23:11 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lcm@us.ibm.com
Subject: Re: [RFC PATCH 3/4] x86: using logical flat for amd cpu too.
Message-ID: <20100113045311.GB24940@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org> <1263264483-3959-2-git-send-email-yinghai@kernel.org> <20100112082706.GE28425@in.ibm.com> <4B4CFCD2.6000000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4CFCD2.6000000@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 02:50:58PM -0800, H. Peter Anvin wrote:
> On 01/12/2010 12:27 AM, Ananth N Mavinakayanahalli wrote:
> > On Mon, Jan 11, 2010 at 06:48:01PM -0800, Yinghai Lu wrote:
> > 
> >> not sure it works again, could be bios fix the irq routing dest ?
> > 
> > Nope, it doesn't. I applied this patchset.. no luck.

Hi Peter,

> Okay, I have been monitoring this discussion, but I would like to make
> sure I have understood all the relevant details:
> 
> 1. The original patch is already reverted in Linus' tree.
> 
> 2. The Intel/AMD thing is likely to be a red herring; specifically it's
>    a proxy for some other platform difference.
> 
> 3. There is at least one platform ("an IBM platform with two quad-core
>    Xeon X7350 CPUs" -- which platform?) for which the logical
>    destination mode fails even though it should have been supported.
>    Currently there is no known workaround for this platform other than
>    forcing physical mode on this machine, which is what the current
>    code does, for valid or invalid reasons.

The machine in question is has 2 quad-core Tigerton processors, with a
provision to upgrade to 4 processors.
 
> It would be good to clean up this code for .34, and I would really like
> to know *which* platform this is; furthermore, Ananth, if you could send
> as much technical information on this platform as possible including DMI
> and lspci dumps I would appreciate it.

As Suresh cited in another email,
http://www.redbooks.ibm.com/redbooks/pdfs/sg247630.pdf has more
information about the system. The one I have access to is a 7141-4RA.

[1] is the lspci output.
[2] is the dmidecode output.
 
Chris McDermott, on cc should be able to provide more information about
the platform, etc.

> Furthermore, is this a production or preproduction system?

This is a System x3850 M2 and is Generally Available.

Ananth

--------
[1] lspci output:

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 01) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	Memory behind bridge: f2000000-f5ffffff
	Capabilities: [40] Express Root Port (Slot-) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 Enable+
	Capabilities: [90] #0d [0000]
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Unknown (5)

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 01) (prog-if 00 [UHCI])
	Subsystem: IBM Unknown device 0381
	Flags: bus master, medium devsel, latency 0, IRQ 23
	I/O ports at 3000 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 01) (prog-if 00 [UHCI])
	Subsystem: IBM Unknown device 0381
	Flags: bus master, medium devsel, latency 0, IRQ 17
	I/O ports at 3100 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 01) (prog-if 00 [UHCI])
	Subsystem: IBM Unknown device 0381
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 3200 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 01) (prog-if 00 [UHCI])
	Subsystem: IBM Unknown device 0381
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at 3300 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 01) (prog-if 20 [EHCI])
	Subsystem: IBM Unknown device 0381
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at f6100000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: f6000000-f60fffff
	Prefetchable memory behind bridge: 00000000e8000000-00000000eff00000
	Capabilities: [50] #0d [0000]

00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface Bridge (rev 01)
	Subsystem: IBM Unknown device 0381
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 01) (prog-if 8a [Master SecP PriP])
	Subsystem: IBM Unknown device 0381
	Flags: bus master, medium devsel, latency 0
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at 0700 [size=16]

01:00.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02) (prog-if 00 [VGA controller])
	Subsystem: IBM Unknown device 0319
	Flags: bus master, stepping, medium devsel, latency 240, IRQ 3
	Memory at e8000000 (32-bit, prefetchable) [size=128M]
	I/O ports at 2000 [size=256]
	Memory at f6020000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at f6000000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2

02:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet (rev 01)
	Subsystem: IBM Unknown device 037c
	Flags: bus master, fast devsel, latency 0, IRQ 102
	Memory at f2000000 (64-bit, non-prefetchable) [size=32M]
	Capabilities: [48] Power Management version 3
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable+
	Capabilities: [a0] MSI-X: Enable- Mask- TabSize=8
	Capabilities: [ac] Express Endpoint IRQ 0
	Capabilities: [100] Device Serial Number b4-66-36-fe-ff-64-1a-00
	Capabilities: [110] Advanced Error Reporting
	Capabilities: [150] Power Budgeting
	Capabilities: [160] Virtual Channel

02:00.1 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet (rev 01)
	Subsystem: IBM Unknown device 037c
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at f4000000 (64-bit, non-prefetchable) [size=32M]
	Capabilities: [48] Power Management version 3
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable-
	Capabilities: [a0] MSI-X: Enable- Mask- TabSize=8
	Capabilities: [ac] Express Endpoint IRQ 0
	Capabilities: [100] Device Serial Number b6-66-36-fe-ff-64-1a-00
	Capabilities: [110] Advanced Error Reporting
	Capabilities: [150] Power Budgeting
	Capabilities: [160] Virtual Channel

03:00.0 PCI bridge: IBM CalIOC2 PCI-E Root Port (rev 01) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=03, secondary=04, subordinate=04, sec-latency=0
	Prefetchable memory behind bridge: 00000000e0000000-00000000e0000000
	Capabilities: [40] Power Management version 3
	Capabilities: [80] Express Root Port (Slot-) IRQ 0
	Capabilities: [100] Advanced Error Reporting

04:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078 (rev 03)
	Subsystem: IBM MegaRAID SAS PCI Express ROMB
	Flags: bus master, fast devsel, latency 0, IRQ 46
	Memory at f6200000 (64-bit, non-prefetchable) [size=256K]
	I/O ports at 3400 [size=256]
	Memory at f6240000 (64-bit, non-prefetchable) [size=256K]
	[virtual] Expansion ROM at e0000000 [disabled] [size=128K]
	Capabilities: [b0] Express Endpoint IRQ 0
	Capabilities: [c4] Message Signalled Interrupts: 64bit+ Queue=0/2 Enable-
	Capabilities: [d4] MSI-X: Enable- Mask- TabSize=4
	Capabilities: [e0] Power Management version 2
	Capabilities: [ec] Vital Product Data
	Capabilities: [100] Power Budgeting

05:00.0 PCI bridge: IBM CalIOC2 PCI-E Root Port (rev 01) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=05, secondary=06, subordinate=0a, sec-latency=0
	Capabilities: [40] Power Management version 3
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
	Capabilities: [100] Advanced Error Reporting

0b:00.0 PCI bridge: IBM CalIOC2 PCI-E Root Port (rev 01) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=0b, secondary=0c, subordinate=10, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: e0200000-e03fffff
	Prefetchable memory behind bridge: 00000000e0400000-00000000e0500000
	Capabilities: [40] Power Management version 3
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
	Capabilities: [100] Advanced Error Reporting

11:00.0 PCI bridge: IBM CalIOC2 PCI-E Root Port (rev 01) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=11, secondary=12, subordinate=16, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: e0600000-e07fffff
	Prefetchable memory behind bridge: 00000000e0800000-00000000e0900000
	Capabilities: [40] Power Management version 3
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
	Capabilities: [100] Advanced Error Reporting

17:00.0 PCI bridge: IBM CalIOC2 PCI-E Root Port (rev 01) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=17, secondary=18, subordinate=1c, sec-latency=0
	Capabilities: [40] Power Management version 3
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
	Capabilities: [100] Advanced Error Reporting

1d:00.0 PCI bridge: IBM CalIOC2 PCI-E Root Port (rev 01) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=1d, secondary=1e, subordinate=22, sec-latency=0
	Prefetchable memory behind bridge: 00000000e0100000-00000000e0100000
	Capabilities: [40] Power Management version 3
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
	Capabilities: [100] Advanced Error Reporting

1e:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
	Subsystem: Intel Corporation PRO/1000 PT Dual Port Server Adapter
	Flags: bus master, fast devsel, latency 0, IRQ 100
	Memory at f6320000 (32-bit, non-prefetchable) [size=128K]
	Memory at f6340000 (32-bit, non-prefetchable) [size=128K]
	I/O ports at 3500 [size=32]
	[virtual] Expansion ROM at e0100000 [disabled] [size=128K]
	Capabilities: [c8] Power Management version 2
	Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
	Capabilities: [e0] Express Endpoint IRQ 0
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number cc-3b-73-ff-ff-17-15-00

1e:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
	Subsystem: Intel Corporation PRO/1000 PT Dual Port Server Adapter
	Flags: bus master, fast devsel, latency 0, IRQ 101
	Memory at f6360000 (32-bit, non-prefetchable) [size=128K]
	Memory at f6380000 (32-bit, non-prefetchable) [size=128K]
	I/O ports at 3600 [size=32]
	Capabilities: [c8] Power Management version 2
	Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
	Capabilities: [e0] Express Endpoint IRQ 0
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number cc-3b-73-ff-ff-17-15-00

23:00.0 PCI bridge: IBM CalIOC2 PCI-E Root Port (rev 01) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=23, secondary=24, subordinate=28, sec-latency=0
	Capabilities: [40] Power Management version 3
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
	Capabilities: [100] Advanced Error Reporting

29:00.0 PCI bridge: IBM CalIOC2 PCI-E Root Port (rev 01) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=29, secondary=2a, subordinate=2e, sec-latency=0
	Capabilities: [40] Power Management version 3
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
	Capabilities: [100] Advanced Error Reporting


--------
[2] dmidecode output:

# dmidecode 2.9
SMBIOS 2.4 present.
82 structures occupying 4995 bytes.
Table at 0xBFF57B40.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: IBM
	Version: -[A3E148AUS-1.07]-
	Release Date: 11/05/2008
	Address: 0xF01E0
	Runtime Size: 65056 bytes
	ROM Size: 8192 kB
	Characteristics:
		PCI is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		Japanese floppy for NEC 9800 1.2 MB is supported (int 13h)
		Japanese floppy for Toshiba 1.2 MB is supported (int 13h)
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
		I2O boot is supported
		LS-120 boot is supported
		Function key-initiated network boot is supported
		Targeted content distribution is supported
	BIOS Revision: 1.7

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: IBM
	Product Name: IBM 3850 M2 / x3950 M2 -[71414RA]-
	Version: Not Specified
	Serial Number: 99B0888
	UUID: 40AA2C62-7B67-B601-759D-001A643666B4
	Wake-up Type: Power Switch
	SKU Number: Not Specified
	Family: Not Specified

Handle 0x0002, DMI type 2, 95 bytes
Base Board Information
	Manufacturer: IBM
	Product Name: Node1 Processor Card
	Version: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: Node1, Bottom Front
	Chassis Handle: 0x003A
	Type: Processor Module
	Contained Object Handles: 20
		0x0042
		0x0043
		0x0044
		0x0045
		0x0046
		0x0047
		0x0048
		0x0049
		0x004A
		0x004B
		0x004C
		0x004D
		0x00A2
		0x00A3
		0x00A4
		0x00A5
		0x00C2
		0x00C3
		0x00C4
		0x0274

Handle 0x0003, DMI type 2, 95 bytes
Base Board Information
	Manufacturer: IBM
	Product Name: Node1 PCI I/O Planar
	Version: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Features:
		Board is removable
		Board is replaceable
	Location In Chassis: Node1, Rear Center
	Chassis Handle: 0x003A
	Type: I/O Module
	Contained Object Handles: 19
		0x00C5
		0x00C6
		0x00C7
		0x00C8
		0x00C9
		0x00CA
		0x00CB
		0x00CC
		0x00CD
		0x00CE
		0x00CF
		0x012B
		0x012C
		0x012D
		0x012E
		0x012F
		0x0130
		0x0131
		0x0163

Handle 0x0005, DMI type 2, 31 bytes
Base Board Information
	Manufacturer: IBM
	Product Name: Node1 Memory Card1
	Version: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Features:
		Board requires at least one daughter board
		Board is removable
		Board is replaceable
		Board is hot swappable
	Location In Chassis: Node1, Rear Left 1st From Top
	Chassis Handle: 0x003A
	Type: Memory Module
	Contained Object Handles: 8
		0x0172
		0x0173
		0x0174
		0x0175
		0x0176
		0x0177
		0x0178
		0x0179

Handle 0x0006, DMI type 2, 31 bytes
Base Board Information
	Manufacturer: IBM
	Product Name: Node1 Memory Card2
	Version: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Features:
		Board requires at least one daughter board
		Board is removable
		Board is replaceable
		Board is hot swappable
	Location In Chassis: Node1, Rear Left 2nd From Top
	Chassis Handle: 0x003A
	Type: Memory Module
	Contained Object Handles: 8
		0x017A
		0x017B
		0x017C
		0x017D
		0x017E
		0x017F
		0x0180
		0x0181

Handle 0x0007, DMI type 2, 31 bytes
Base Board Information
	Manufacturer: IBM
	Product Name: Node1 Memory Card3
	Version: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Features:
		Board requires at least one daughter board
		Board is removable
		Board is replaceable
		Board is hot swappable
	Location In Chassis: Node1, Rear Left 3rd From Top
	Chassis Handle: 0x003A
	Type: Memory Module
	Contained Object Handles: 8
		0x0182
		0x0183
		0x0184
		0x0185
		0x0186
		0x0187
		0x0188
		0x0189

Handle 0x0008, DMI type 2, 31 bytes
Base Board Information
	Manufacturer: IBM
	Product Name: Node1 Memory Card4
	Version: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Features:
		Board requires at least one daughter board
		Board is removable
		Board is replaceable
		Board is hot swappable
	Location In Chassis: Node1, Rear Left 4th From Top
	Chassis Handle: 0x003A
	Type: Memory Module
	Contained Object Handles: 8
		0x018A
		0x018B
		0x018C
		0x018D
		0x018E
		0x018F
		0x0190
		0x0191

Handle 0x003A, DMI type 3, 13 bytes
Chassis Information
	Manufacturer: IBM
	Type: Main Server Chassis
	Lock: Not Present
	Version: Not Specified
	Serial Number: Not Specified
	Asset Tag:                                 
	Boot-up State: Safe
	Power Supply State: Unknown
	Thermal State: Unknown
	Security Status: Unknown

Handle 0x0046, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L2 Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 8192 KB
	Maximum Size: 4096 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x0049, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L2 Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 8192 KB
	Maximum Size: 4096 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x00A2, DMI type 4, 40 bytes
Processor Information
	Socket Designation: Node 1 CPU 3
	Type: Central Processor
	Family: Xeon MP
	Manufacturer: GenuineIntel
	ID: 00 00 00 00 00 00 00 00
	Signature: Type 0, Family 0, Model 0, Stepping 0
	Flags: None
	Version: Intel Xeon MP  Quad-Core
	Voltage: 1.5 V
	External Clock: Unknown
	Max Speed: 4000 MHz
	Current Speed: Unknown
	Status: Unpopulated
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x0042
	L2 Cache Handle: 0x0043
	L3 Cache Handle: 0x0044
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified
	Characteristics:
		64-bit capable

Handle 0x00A3, DMI type 4, 40 bytes
Processor Information
	Socket Designation: Node 1 CPU 1
	Type: Central Processor
	Family: Xeon MP
	Manufacturer: GenuineIntel
	ID: FB 06 00 00 00 00 00 00
	Signature: Type 0, Family 6, Model 15, Stepping 11
	Flags: None
	Version: Intel Xeon MP           
	Voltage: 1.5 V
	External Clock: 133 MHz
	Max Speed: 4000 MHz
	Current Speed: 2933 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x0045
	L2 Cache Handle: 0x0046
	L3 Cache Handle: 0x0047
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified
	Core Count: 4
	Core Enabled: 4
	Thread Count: 4
	Characteristics:
		64-bit capable

Handle 0x00A4, DMI type 4, 40 bytes
Processor Information
	Socket Designation: Node 1 CPU 2
	Type: Central Processor
	Family: Xeon MP
	Manufacturer: GenuineIntel
	ID: FB 06 00 00 00 00 00 00
	Signature: Type 0, Family 6, Model 15, Stepping 11
	Flags: None
	Version: Intel Xeon MP           
	Voltage: 1.5 V
	External Clock: 133 MHz
	Max Speed: 4000 MHz
	Current Speed: 2933 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x0048
	L2 Cache Handle: 0x0049
	L3 Cache Handle: 0x004A
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified
	Core Count: 4
	Core Enabled: 4
	Thread Count: 4
	Characteristics:
		64-bit capable

Handle 0x00A5, DMI type 4, 40 bytes
Processor Information
	Socket Designation: Node 1 CPU 4
	Type: Central Processor
	Family: Xeon MP
	Manufacturer: GenuineIntel
	ID: 00 00 00 00 00 00 00 00
	Signature: Type 0, Family 0, Model 0, Stepping 0
	Flags: None
	Version: Intel Xeon MP  Quad-Core
	Voltage: 1.5 V
	External Clock: Unknown
	Max Speed: 4000 MHz
	Current Speed: Unknown
	Status: Unpopulated
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x004B
	L2 Cache Handle: 0x004C
	L3 Cache Handle: 0x004D
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified
	Characteristics:
		64-bit capable

Handle 0x00C2, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Scalability 1
	External Connector Type: Proprietary
	Port Type: Other

Handle 0x00C3, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Scalability 2
	External Connector Type: Proprietary
	Port Type: Other

Handle 0x00C4, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Scalability 3
	External Connector Type: Proprietary
	Port Type: Other

Handle 0x00C5, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: 10/100/1000 Ethernet (port A)
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x00C6, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: 10/100/1000 Ethernet (port B)
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x00C7, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB 1
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x00C8, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB 2
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x00C9, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: USB 3
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x00CA, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Video
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x00CB, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Diskette/CDROM
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x00CC, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Internal SAS SCSI
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x00CD, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: External SAS SCSI
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x00CE, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Serial-A / System Management
	External Connector Type: DB-9 male
	Port Type: Serial Port 16550A Compatible

Handle 0x00CF, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: RSA Ethernet
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x00D0, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Scalability 1
	External Connector Type: Proprietary
	Port Type: Other

Handle 0x00D1, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Scalability 2
	External Connector Type: Proprietary
	Port Type: Other

Handle 0x00D2, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Specified
	Internal Connector Type: None
	External Reference Designator: Scalability 3
	External Connector Type: Proprietary
	Port Type: Other

Handle 0x012B, DMI type 9, 13 bytes
System Slot Information
	Designation: Node1 PCI-Express Slot 1
	Type: x8 PCI Express
	Current Usage: Available
	Length: Long
	ID: 1
	Characteristics:
		3.3 V is provided
		PME signal is supported

Handle 0x012C, DMI type 9, 13 bytes
System Slot Information
	Designation: Node1 PCI-Express Slot 2
	Type: x8 PCI Express
	Current Usage: In Use
	Length: Long
	ID: 2
	Characteristics:
		3.3 V is provided
		PME signal is supported

Handle 0x012D, DMI type 9, 13 bytes
System Slot Information
	Designation: Node1 PCI-Express Slot 3
	Type: x8 PCI Express
	Current Usage: Available
	Length: Long
	ID: 3
	Characteristics:
		3.3 V is provided
		PME signal is supported

Handle 0x012E, DMI type 9, 13 bytes
System Slot Information
	Designation: Node1 PCI-Express Slot 4
	Type: x8 PCI Express
	Current Usage: Available
	Length: Long
	ID: 4
	Characteristics:
		3.3 V is provided
		PME signal is supported

Handle 0x012F, DMI type 9, 13 bytes
System Slot Information
	Designation: Node1 PCI-Express Slot 5
	Type: x8 PCI Express
	Current Usage: Available
	Length: Long
	ID: 5
	Characteristics:
		3.3 V is provided
		PME signal is supported

Handle 0x0130, DMI type 9, 13 bytes
System Slot Information
	Designation: Node1 PCI-Express Slot 6
	Type: x8 PCI Express
	Current Usage: Available
	Length: Long
	ID: 6
	Characteristics:
		3.3 V is provided
		PME signal is supported
		Hot-plug devices are supported

Handle 0x0131, DMI type 9, 13 bytes
System Slot Information
	Designation: Node1 PCI-Express Slot 7
	Type: x8 PCI Express
	Current Usage: Available
	Length: Long
	ID: 7
	Characteristics:
		3.3 V is provided
		PME signal is supported
		Hot-plug devices are supported

Handle 0x016B, DMI type 11, 5 bytes
OEM Strings
	String 1: IBM Preboot Diagnostics (DSA) 1.00.55 -[A3YT55AUS-1.00.55]-
	String 2: IBM CRTM Code 1.00 -[A3CP08AUS-1.00]-
	String 3: IBM Backup CRTM Code 1.00 -[A3CP08AUS-1.00]-
	String 4: IBM BaseBoard Management Controller -[A3BT50A  ]-
	String 5: IBM Remote Supervisor Adapter -[A3EP29BUS]-
	String 6: IBM Processor Card FPGA Version 001.006
	String 7: IBM PCI I/O Planar FPGA Version 001.004

Handle 0x016C, DMI type 12, 5 bytes
System Configuration Options
	Option 1: J33-Power on Password Override jumper
	Option 2: Changing the position of this jumper bypasses the
	Option 3: power-on password checking on the next power-on. 
	Option 4: You do not need to move the jumper back to the 
	Option 5: default position after the password is overridden. 
	Option 6: Changing the position of this jumper does not affect 
	Option 7: the administrator password check if an administrator 
	Option 8: password is set.

Handle 0x016D, DMI type 12, 5 bytes
System Configuration Options
	Option 1: J17-Flash ROM page swap jumper
	Option 2: Primary-on pins 1-2, Backup-on pins 2-3
	Option 3: The Primary(default) position is a jumper installed 
	Option 4: on pins marked by a white block under the pins.
	Option 5: Changing the position of this jumper will change 
	Option 6: which of the two pages of flash ROM is used when 
	Option 7: the system is started.

Handle 0x016E, DMI type 12, 5 bytes
System Configuration Options
	Option 1: J16- Force Power On Jumper
	Option 2: Pin 1-2 Force Power On disabled
	Option 3: Pin 2-3 Force Power On enabled

Handle 0x016F, DMI type 12, 5 bytes
System Configuration Options
	Option 1: J21- BMC Disable Jumper
	Option 2: Pin 1-2 BMC Enabled
	Option 3: Pin 2-3 BMC Disabled

Handle 0x0170, DMI type 13, 22 bytes
BIOS Language Information
	Installable Languages: 1
		en|US|iso8859-1
	Currently Installed Language: en|US|iso8859-1

Handle 0x0171, DMI type 16, 15 bytes
Physical Memory Array
	Location: Proprietary Add-on Card
	Use: System Memory
	Error Correction Type: Multi-bit ECC
	Maximum Capacity: Unknown
	Error Information Handle: Not Provided
	Number Of Devices: 32

Handle 0x0172, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 1
	Locator: DIMM1
	Bank Locator: Node1/Bank1/MemCard1
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0173, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 1
	Locator: DIMM5
	Bank Locator: Node1/Bank1/MemCard1
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0174, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: 2
	Locator: DIMM2
	Bank Locator: Node1/Bank2/MemCard1
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0175, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: 2
	Locator: DIMM6
	Bank Locator: Node1/Bank2/MemCard1
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0176, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: 3
	Locator: DIMM3
	Bank Locator: Node1/Bank3/MemCard1
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0177, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: 3
	Locator: DIMM7
	Bank Locator: Node1/Bank3/MemCard1
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0178, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: 4
	Locator: DIMM4
	Bank Locator: Node1/Bank4/MemCard1
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0179, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: 4
	Locator: DIMM8
	Bank Locator: Node1/Bank4/MemCard1
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x017A, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 5
	Locator: DIMM1
	Bank Locator: Node1/Bank5/MemCard2
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x017B, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 5
	Locator: DIMM5
	Bank Locator: Node1/Bank5/MemCard2
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x017C, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: 6
	Locator: DIMM2
	Bank Locator: Node1/Bank6/MemCard2
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x017D, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: 6
	Locator: DIMM6
	Bank Locator: Node1/Bank6/MemCard2
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x017E, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: 7
	Locator: DIMM3
	Bank Locator: Node1/Bank7/MemCard2
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x017F, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: 7
	Locator: DIMM7
	Bank Locator: Node1/Bank7/MemCard2
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0180, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: 8
	Locator: DIMM4
	Bank Locator: Node1/Bank8/MemCard2
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0181, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: 8
	Locator: DIMM8
	Bank Locator: Node1/Bank8/MemCard2
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0182, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 9
	Locator: DIMM1
	Bank Locator: Node1/Bank9/MemCard3
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0183, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 9
	Locator: DIMM5
	Bank Locator: Node1/Bank9/MemCard3
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0184, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: 10
	Locator: DIMM2
	Bank Locator: Node1/Bank10/MemCard3
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0185, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: 10
	Locator: DIMM6
	Bank Locator: Node1/Bank10/MemCard3
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0186, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: 11
	Locator: DIMM3
	Bank Locator: Node1/Bank11/MemCard3
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0187, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: 11
	Locator: DIMM7
	Bank Locator: Node1/Bank11/MemCard3
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0188, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: 12
	Locator: DIMM4
	Bank Locator: Node1/Bank12/MemCard3
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0189, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: 12
	Locator: DIMM8
	Bank Locator: Node1/Bank12/MemCard3
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x018A, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 13
	Locator: DIMM1
	Bank Locator: Node1/Bank13/MemCard4
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x018B, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: 13
	Locator: DIMM5
	Bank Locator: Node1/Bank13/MemCard4
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x018C, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: 14
	Locator: DIMM2
	Bank Locator: Node1/Bank14/MemCard4
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x018D, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: 14
	Locator: DIMM6
	Bank Locator: Node1/Bank14/MemCard4
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x018E, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: 15
	Locator: DIMM3
	Bank Locator: Node1/Bank15/MemCard4
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x018F, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: 15
	Locator: DIMM7
	Bank Locator: Node1/Bank15/MemCard4
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0190, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: 16
	Locator: DIMM4
	Bank Locator: Node1/Bank16/MemCard4
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0191, DMI type 17, 23 bytes
Memory Device
	Array Handle: 0x0171
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: No Module Installed
	Form Factor: DIMM
	Set: 16
	Locator: DIMM8
	Bank Locator: Node1/Bank16/MemCard4
	Type: DDR2
	Type Detail: Synchronous
	Speed: 533 MHz (1.9 ns)

Handle 0x0272, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x007FFFFFFFF
	Range Size: 32 GB
	Physical Array Handle: 0x0171
	Partition Width: 0

Handle 0x0273, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0x0274, DMI type 38, 18 bytes
IPMI Device Information
	Interface Type: KCS (Keyboard Control Style)
	Specification Version: 2.0
	I2C Slave Address: 0x10
	NV Storage Device: Not Present
	Base Address: 0x0000000000000CA8 (I/O)
	Register Spacing: 32-bit Boundaries

Handle 0x027C, DMI type 127, 4 bytes
End Of Table

