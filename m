Return-Path: <linux-kernel-owner+w=401wt.eu-S1763318AbYGBJS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763318AbYGBJS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYGBJSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:18:03 -0400
Received: from mx-b.polytechnique.fr ([129.104.30.15]:58389 "EHLO
	mx-b.polytechnique.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763161AbYGBJRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:17:54 -0400
Message-ID: <486B4490.7080904@crans.org>
Date: Wed, 02 Jul 2008 11:04:16 +0200
From: =?ISO-8859-15?Q?Mathieu_B=E9rard?= <Mathieu.Berard@crans.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.25 to 2.6.26-rc8 regression  (related to ahci and acpi _GTF)
References: <4869FB3C.4060509@crans.org> <200807011614.21491.rjw@sisk.pl> <486AEE29.2010506@gmail.com>
In-Reply-To: <486AEE29.2010506@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------010604070005090608070009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010604070005090608070009
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

Tejun Heo a écrit :
> Rafael J. Wysocki wrote:
>   
>> [Adding CCs.]
>>
>> On Tuesday, 1 of July 2008, Mathieu Bérard wrote:
>>     
>>> Hi,
>>> I have a laptop with an ICH6M SATA Controller and a Hitachi hard drive.
>>> While it worked well using the ahci module and Linux 2.6.25, 
>>> it get randomly 'stuck' for several seconds to several minutes with 2.6.26-rc8.
>>> Successive errors progressively reduce the ATA link speed.
>>>
>>> Passing the libata.noacpi parameter is an effective workaround.
>>>
>>> Please note that it's not the first time i have this kind of issue, see:
>>> http://marc.info/?l=linux-ide&m=117305595312399&w=2
>>> This was found to be a bad interaction between my _GTF taskfile, which enable the
>>> "Enable Device-Initiated Interface Power State Transitions" feature, and NCQ.
>>> The driver was later NCQ blacklisted to correct the problem.
>>>       
>
> Can you please post the result of "hdparm -I /dev/sda" and full kernel
> boot log?  0xca is not a NCQ command so the it's not related to NCQ at
> all.  It seems we'll need to filter out DIPM commands from _GTF.
>
>   
Hi,
hdparm and dmesg output attached.

I was not expecting anything related to NCQ as my drive is blacklisted,
I was just mentioning previous issue with that hardware.

Do you know what has changed in this version that is now causing failure
with DIPM ?  I could bisect to try to find out, but this will be painful
as the
device hang may only appears after several minutes of disk activity.


-- 
Mathieu


--------------010604070005090608070009
Content-Type: text/plain;
 name="hdparm_2.6.26-rc8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hdparm_2.6.26-rc8"


/dev/sda:

ATA device, with non-removable media
	Model Number:       HTS541010G9SA00                         
	Serial Number:      MP2ZM4X0GSWJKR
	Firmware Revision:  MBZOC60D
Standards:
	Used: ATA/ATAPI-7 T13 1532D revision 1 
	Supported: 7 6 5 4 
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  195371568
	LBA48  user addressable sectors:  195371568
	device size with M = 1024*1024:       95396 MBytes
	device size with M = 1000*1000:      100030 MBytes (100 GB)
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Vendor, no device specific minimum
	R/W multiple sector transfer: Max = 16	Current = 0
	Advanced power management level: 128
	Recommended acoustic management value: 128, current value: 254
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5 
	     Cycle time: min=120ns recommended=120ns
	PIO: pio0 pio1 pio2 pio3 pio4 
	     Cycle time: no flow control=240ns  IORDY flow control=120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	NOP cmd
	   *	DOWNLOAD_MICROCODE
	   *	Advanced Power Management feature set
	    	Power-Up In Standby feature set
	   *	SET_FEATURES required to spinup after power up
	    	SET_MAX security extension
	    	Automatic Acoustic Management feature set
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	   *	General Purpose Logging feature set
	   *	WRITE_{DMA|MULTIPLE}_FUA_EXT
	   *	IDLE_IMMEDIATE with UNLOAD
	   *	SATA-I signaling speed (1.5Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Host-initiated interface power management
	    	Non-Zero buffer offsets in DMA Setup FIS
	    	DMA Setup Auto-Activate optimization
	    	Device-initiated interface power management
	    	In-order data delivery
	   *	Software settings preservation
Security: 
	Master password revision code = 65534
		supported
	not	enabled
	not	locked
	not	frozen
	not	expired: security count
	not	supported: enhanced erase
	64min for SECURITY ERASE UNIT. 
Checksum: correct

--------------010604070005090608070009
Content-Type: text/plain;
 name="dmesg_2.6.26-rc8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg_2.6.26-rc8"

[    0.000000] Linux version 2.6.26-rc8 (mathieu@manwe) (gcc version 4.3.1 (Ubuntu 4.3.1-3ubuntu1) ) #1 PREEMPT Mon Jun 30 01:12:00 CEST 2008
[    0.000000] PAT disabled. Not yet verified on this CPU type.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fee0000 (usable)
[    0.000000]  BIOS-e820: 000000003fee0000 - 000000003feea000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003feea000 - 000000003ff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0006000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0008000 - 00000000f000c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] 126MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Entering add_active_range(0, 0, 261856) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   261856
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   261856
[    0.000000] On node 0 totalpages: 261856
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 254 pages used for memmap
[    0.000000]   HighMem zone: 32226 pages, LIFO batch:7
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F6950, 0014 (r0 TOSCPL)
[    0.000000] ACPI: RSDT 3FEE1FCA, 0044 (r1 TOSCPL   RSDT    6040000  LTP        0)
[    0.000000] ACPI: APIC 3FEE9E88, 0068 (r1 INTEL  ALVISO    6040000 LOHR       5F)
[    0.000000] ACPI: FACP 3FEE9EF0, 0074 (r1 TOSCPL ALVISO    6040000 LOHR       32)
[    0.000000] ACPI: DSDT 3FEE2A72, 7416 (r1 TOSCPL ALVISO    6040000 MSFT  3000000)
[    0.000000] ACPI: FACS 3FEFAFC0, 0040
[    0.000000] ACPI: BOOT 3FEE9FD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
[    0.000000] ACPI: MCFG 3FEE9F9C, 003C (r1 INTEL  ALVISO    6040000 LOHR       5F)
[    0.000000] ACPI: SSDT 3FEE2840, 022E (r1 SataRe SataAhci     1000 INTL 20030224)
[    0.000000] ACPI: SSDT 3FEE2405, 022B (r1  PmRef  Cpu0Ist     3000 INTL 20030224)
[    0.000000] ACPI: SSDT 3FEE2227, 01DE (r1  PmRef  Cpu0Cst     3001 INTL 20030224)
[    0.000000] ACPI: SSDT 3FEE200E, 0219 (r1  PmRef    CpuPm     3000 INTL 20030224)
[    0.000000] ACPI: DMI detected: Toshiba
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259810
[    0.000000] Kernel command line: root=UUID=8aa84942-b9a7-4622-a512-c180ce3095db ro savedefault  single
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] CPU 0 irqstacks, hard=c03b8000 soft=c03b7000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1729.103 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] Memory: 1030072k/1047424k available (1773k kernel code, 16608k reserved, 799k data, 188k init, 129920k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfffa8000 - 0xfffff000   ( 348 kB)
[    0.000999]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000999]     vmalloc : 0xf8800000 - 0xff9fe000   ( 113 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.000999]       .init : 0xc0385000 - 0xc03b4000   ( 188 kB)
[    0.000999]       .data : 0xc02bb5f8 - 0xc0383538   ( 799 kB)
[    0.000999]       .text : 0xc0100000 - 0xc02bb5f8   (1773 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
[    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.061050] Calibrating delay using timer specific routine.. 3460.32 BogoMIPS (lpj=1730163)
[    0.061163] Mount-cache hash table entries: 512
[    0.061341] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.061427] CPU: L2 cache: 2048K
[    0.061476] Intel machine check architecture supported.
[    0.061529] Intel machine check reporting enabled on CPU#0.
[    0.061586] CPU: Intel(R) Pentium(R) M processor 1.73GHz stepping 08
[    0.061711] Checking 'hlt' instruction... OK.
[    0.065337] Freeing SMP alternatives: 0k freed
[    0.065387] ACPI: Core revision 20080321
[    0.077988] ENABLING IO-APIC IRQs
[    0.077988] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.087986] net_namespace: 480 bytes
[    0.087986] NET: Registered protocol family 16
[    0.087986] ACPI: bus type pci registered
[    0.087986] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.087986] PCI: MCFG area at e0000000 reserved in E820
[    0.087986] PCI: Using MMCONFIG for extended config space
[    0.087986] PCI: Using configuration type 1 for base access
[    0.087986] Setting up standard PCI resources
[    0.092423] ACPI: EC: Look up EC in DSDT
[    0.095508] ACPI: Interpreter enabled
[    0.095558] ACPI: (supports S0 S3 S4 S5)
[    0.095759] ACPI: Using IOAPIC for interrupt routing
[    0.140766] ACPI: EC: GPE = 0x1d, I/O: command/status = 0x66, data = 0x62
[    0.140822] ACPI: EC: driver started in poll mode
[    0.140891] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.141686] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.141693] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.141757] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
[    0.142803] PCI: Transparent bridge - 0000:00:1e.0
[    0.142908] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.143252] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.143413] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.143566] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.143730] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.150741] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.151338] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.151970] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.152604] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.153196] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.153830] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.154422] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.154976] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.155634] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.155696] pnp: PnP ACPI init
[    0.155747] ACPI: bus type pnp registered
[    0.178303] pnp: PnP ACPI: found 9 devices
[    0.178353] ACPI: ACPI bus type pnp unregistered
[    0.178449] PCI: Using ACPI for IRQ routing
[    0.182234] hpet clockevent registered
[    0.182241] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.182433] hpet0: 3 64-bit timers, 14318180 Hz
[    0.189107] system 00:01: ioport range 0xfe00-0xfe7f has been reserved
[    0.189163] system 00:01: ioport range 0xfe80-0xfeff has been reserved
[    0.189217] system 00:01: ioport range 0xff00-0xff7f has been reserved
[    0.189272] system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
[    0.189334] system 00:01: iomem range 0xf0000000-0xf0003fff could not be reserved
[    0.189395] system 00:01: iomem range 0xf0004000-0xf0004fff could not be reserved
[    0.189457] system 00:01: iomem range 0xf0005000-0xf0005fff could not be reserved
[    0.189519] system 00:01: iomem range 0xf0008000-0xf000bfff could not be reserved
[    0.189581] system 00:01: iomem range 0xfed20000-0xfed8ffff could not be reserved
[    0.189651] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.189705] system 00:05: ioport range 0x1000-0x107f has been reserved
[    0.189758] system 00:05: ioport range 0x1180-0x11bf has been reserved
[    0.189812] system 00:05: ioport range 0x1640-0x164f has been reserved
[    0.219963] PCI: region 0000:06:04.0/9 too large: 0x0000000000000000-0x0000000003ffffff
[    0.220032] PCI: Bridge: 0000:00:01.0
[    0.220080]   IO window: 3000-3fff
[    0.220129]   MEM window: 0xb8100000-0xb81fffff
[    0.220181]   PREFETCH window: 0x00000000c8000000-0x00000000cfffffff
[    0.220236] PCI: Bridge: 0000:00:1c.0
[    0.220285]   IO window: 4000-4fff
[    0.220336]   MEM window: 0xbc000000-0xbfffffff
[    0.220389]   PREFETCH window: 0x00000000d0000000-0x00000000d3ffffff
[    0.220447] PCI: Bridge: 0000:00:1c.1
[    0.220496]   IO window: 5000-5fff
[    0.220547]   MEM window: 0xc0000000-0xc3ffffff
[    0.220600]   PREFETCH window: 0x00000000d4000000-0x00000000d7ffffff
[    0.220661] PCI: Bus 7, cardbus bridge: 0000:06:04.0
[    0.220711]   IO window: 0x00006400-0x000064ff
[    0.220763]   IO window: 0x00006800-0x000068ff
[    0.220816]   MEM window: 0x50000000-0x53ffffff
[    0.220869] PCI: Bridge: 0000:00:1e.0
[    0.220918]   IO window: 6000-6fff
[    0.220970]   MEM window: 0xc4000000-0xc40fffff
[    0.221023]   PREFETCH window: disabled.
[    0.221086] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.221185] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.221205] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
[    0.221305] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.221326] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
[    0.221425] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.221438] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.221454] ACPI: PCI Interrupt 0000:06:04.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.221559] NET: Registered protocol family 2
[    0.239044] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.239958] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.240787] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[    0.241114] TCP: Hash tables configured (established 131072 bind 65536)
[    0.241169] TCP reno registered
[    0.247066] NET: Registered protocol family 1
[    0.247241] Unpacking initramfs... done
[    0.479151] Freeing initrd memory: 4484k freed
[    0.479252] Simple Boot Flag at 0x36 set to 0x1
[    0.479684] highmem bounce pool size: 64 pages
[    0.479743] Total HugeTLB memory allocated, 0
[    0.480987] msgmni has been set to 1767
[    0.481151] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.481214] io scheduler noop registered
[    0.481270] io scheduler cfq registered (default)
[    0.481425] pci 0000:01:00.0: Boot video device
[    0.481507] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.481535] assign_interrupt_mode Found MSI capability
[    0.481610] Allocate Port Service[0000:00:01.0:pcie00]
[    0.481628] Allocate Port Service[0000:00:01.0:pcie03]
[    0.481675] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.481716] assign_interrupt_mode Found MSI capability
[    0.481806] Allocate Port Service[0000:00:1c.0:pcie00]
[    0.481820] Allocate Port Service[0000:00:1c.0:pcie02]
[    0.481833] Allocate Port Service[0000:00:1c.0:pcie03]
[    0.481915] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.481956] assign_interrupt_mode Found MSI capability
[    0.482045] Allocate Port Service[0000:00:1c.1:pcie00]
[    0.482060] Allocate Port Service[0000:00:1c.1:pcie02]
[    0.482073] Allocate Port Service[0000:00:1c.1:pcie03]
[    0.483062] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.483403] i8042.c: Detected active multiplexing controller, rev 1.1.
[    0.483522] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.483575] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.483627] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.483678] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.483730] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.483796] mice: PS/2 mouse device common for all mice
[    0.483867] cpuidle: using governor ladder
[    0.483919] cpuidle: using governor menu
[    0.484282] TCP cubic registered
[    0.484331] Using IPI Shortcut mode
[    0.484418] registered taskstats version 1
[    0.484726] Freeing unused kernel memory: 188k freed
[    0.487357] input: AT Translated Set 2 keyboard as /class/input/input0
[    0.552083] No dock devices found.
[    0.558425] SCSI subsystem initialized
[    0.566002] libata version 3.00 loaded.
[    0.567684] ahci 0000:00:1f.2: version 3.0
[    0.567713] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[    0.682859] Switched to high resolution mode on CPU 0
[    1.568027] ahci 0000:00:1f.2: AHCI 0001.0000 32 slots 4 ports 1.5 Gbps 0x5 impl IDE mode
[    1.568091] ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part 
[    1.568146] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    1.568283] scsi0 : ahci
[    1.568398] scsi1 : ahci
[    1.568482] scsi2 : ahci
[    1.568568] scsi3 : ahci
[    1.568695] ata1: SATA max UDMA/133 abar m1024@0xb8000c00 port 0xb8000d00 irq 19
[    1.568756] ata2: DUMMY
[    1.568803] ata3: SATA max UDMA/133 abar m1024@0xb8000c00 port 0xb8000e00 irq 19
[    1.568864] ata4: DUMMY
[    1.873016] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.874045] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[    1.875000] ata1.00: ATA-7: HTS541010G9SA00, MBZOC60D, max UDMA/100
[    1.875000] ata1.00: 195371568 sectors, multi 0: LBA48 NCQ (not used)
[    1.875000] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[    1.875000] ata1.00: configured for UDMA/100
[    2.205015] ata3: SATA link down (SStatus 0 SControl 300)
[    2.227086] scsi 0:0:0:0: Direct-Access     ATA      HTS541010G9SA00  MBZO PQ: 0 ANSI: 5
[    2.233881] fuse init (API version 7.9)
[    2.252219] device-mapper: uevent: version 1.0.3
[    2.252347] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[    2.520087] usbcore: registered new interface driver usbfs
[    2.520163] usbcore: registered new interface driver hub
[    2.520470] usbcore: registered new device driver usb
[    2.521427] USB Universal Host Controller Interface driver v3.0
[    2.521525] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[    2.521630] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    2.521634] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.521771] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    2.521863] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001800
[    2.521984] usb usb1: configuration #1 chosen from 1 choice
[    2.522064] hub 1-0:1.0: USB hub found
[    2.522116] hub 1-0:1.0: 2 ports detected
[    2.562082] 8139too Fast Ethernet driver 0.9.28
[    2.623248] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[    2.623368] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    2.623372] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.623444] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.627410] ehci_hcd 0000:00:1d.7: debug port 1
[    2.627465] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    2.627472] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xb8000000
[    2.637010] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.637157] usb usb2: configuration #1 chosen from 1 choice
[    2.637237] hub 2-0:1.0: USB hub found
[    2.637291] hub 2-0:1.0: 8 ports detected
[    2.738128] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[    2.738240] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    2.738244] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.738317] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.738406] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001820
[    2.738536] usb usb3: configuration #1 chosen from 1 choice
[    2.738614] hub 3-0:1.0: USB hub found
[    2.738667] hub 3-0:1.0: 2 ports detected
[    2.815997] ata_piix 0000:00:1f.1: version 2.12
[    2.815997] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
[    2.815997] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    2.815997] scsi4 : ata_piix
[    2.815997] scsi5 : ata_piix
[    2.840100] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x18c0 irq 14
[    2.840157] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x18c8 irq 15
[    2.994584] ata5.00: ATAPI: MATSHITADVD-RAM UJ-841S, 1.50, max UDMA/33
[    3.000504] ata5.00: configured for UDMA/33
[    3.000582] ata6: port disabled. ignoring.
[    3.002000] scsi 4:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-841S  1.50 PQ: 0 ANSI: 5
[    3.002001] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    3.002001] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    3.002001] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.002001] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    3.002001] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
[    3.003055] usb usb4: configuration #1 chosen from 1 choice
[    3.003132] hub 4-0:1.0: USB hub found
[    3.003184] hub 4-0:1.0: 2 ports detected
[    3.103998] ACPI: PCI Interrupt 0000:06:04.2[C] -> GSI 18 (level, low) -> IRQ 18
[    3.103998] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
[    3.103998] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    3.103998] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    3.103998] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    3.103998] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001860
[    3.103998] usb usb5: configuration #1 chosen from 1 choice
[    3.105031] hub 5-0:1.0: USB hub found
[    3.105084] hub 5-0:1.0: 2 ports detected
[    3.160006] usb 1-1: new low speed USB device using uhci_hcd and address 2
[    3.161007] firewire_ohci: Added fw-ohci device 0000:06:04.2, OHCI version 1.10
[    3.161120] ACPI: PCI Interrupt 0000:06:01.0[A] -> GSI 21 (level, low) -> IRQ 21
[    3.161820] eth0: RealTek RTL8139 at 0xf88da000, 00:0f:b0:a5:9a:81, IRQ 21
[    3.161874] eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
[    3.211688] Driver 'sd' needs updating - please use bus_type methods
[    3.211834] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[    3.211901] sd 0:0:0:0: [sda] Write Protect is off
[    3.211952] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.211973] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.212086] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[    3.212154] sd 0:0:0:0: [sda] Write Protect is off
[    3.212206] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.212228] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.212295]  sda:<4>Driver 'sr' needs updating - please use bus_type methods
[    3.300999] usb 1-1: configuration #1 chosen from 1 choice
[    3.343274] usbcore: registered new interface driver hiddev
[    3.358385] input: Logitech USB Receiver as /class/input/input1
[    3.363033] input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1
[    3.393030] input: Logitech USB Receiver as /class/input/input2
[    3.398051] input,hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1
[    3.398339] usbcore: registered new interface driver usbhid
[    3.398392] usbhid: v2.6:USB HID core driver
[    3.591462]  sda1 sda2 < sda5 sda6 > sda3
[    3.608998] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.629031] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.629031] Uniform CD-ROM driver Revision: 3.20
[    3.629031] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    3.632962] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.633040] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    3.661086] firewire_core: created device fw0: GUID 00023f5b8140757f, S400
[    4.122469] PM: Starting manual resume from disk
[    4.130170] SGI XFS with ACLs, security attributes, realtime, no debug enabled
[    4.132481] Filesystem "dm-0": Disabling barriers, not supported by the underlying device
[    4.132729] XFS mounting filesystem dm-0
[    4.214681] Ending clean XFS mount for filesystem: dm-0
[    8.611728] Linux agpgart interface v0.103
[    8.626735] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[    8.626874] iTCO_wdt: Found a ICH6-M TCO device (Version=2, TCOBASE=0x1060)
[    8.626957] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    8.709000] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3] C4[C3])
[    8.709262] ACPI: ACPI0007:00 is registered as cooling_device0
[    8.709317] ACPI: Processor [CPU0] (supports 8 throttling states)
[    8.725918] input: Power Button (FF) as /class/input/input3
[    8.752060] ACPI: Power Button (FF) [PWRF]
[    8.752177] input: Lid Switch as /class/input/input4
[    8.764121] ACPI: Lid Switch [LID0]
[    8.764225] input: Power Button (CM) as /class/input/input5
[    8.788047] ACPI: Power Button (CM) [PWRB]
[    9.173654] ieee80211_crypt: registered algorithm 'NULL'
[    9.270000] Marking TSC unstable due to: TSC halts in idle.
[    9.414207] ACPI: AC Adapter [ACAD] (on-line)
[    9.667778] ACPI: Battery Slot [BAT1] (battery present)
[    9.689219] sdhci: Secure Digital Host Controller Interface driver
[    9.689279] sdhci: Copyright(c) Pierre Ossman
[    9.689359] sdhci: SDHCI controller found at 0000:06:04.4 [104c:8034] (rev 0)
[    9.689432] ACPI: PCI Interrupt 0000:06:04.4[D] -> GSI 19 (level, low) -> IRQ 19
[    9.689551] mmc0: Will use DMA mode even though HW doesn't fully claim to support it.
[    9.689712] mmc0: SDHCI at 0xc4009400 irq 19 DMA
[    9.689772] mmc1: Will use DMA mode even though HW doesn't fully claim to support it.
[    9.689862] mmc1: SDHCI at 0xc4009000 irq 19 DMA
[    9.689921] mmc2: Will use DMA mode even though HW doesn't fully claim to support it.
[    9.690021] mmc2: SDHCI at 0xc4006400 irq 19 DMA
[    9.744484] input: PC Speaker as /class/input/input6
[    9.751333] Real Time Clock Driver v1.12ac
[    9.769279] ACPI: PCI Interrupt 0000:06:04.3[B] -> GSI 17 (level, low) -> IRQ 17
[    9.782047] input: Video Bus as /class/input/input7
[    9.800258] Yenta: CardBus bridge found at 0000:06:04.0 [1179:ff00]
[    9.800339] PCI: Bus 7, cardbus bridge: 0000:06:04.0
[    9.800390]   IO window: 0x00006400-0x000064ff
[    9.800443]   IO window: 0x00006800-0x000068ff
[    9.800496]   PREFETCH window: 0x54000000-0x543fffff
[    9.800550]   MEM window: 0x50000000-0x53ffffff
[    9.800605] Yenta: Enabling burst memory read transactions
[    9.800660] Yenta: Using CSCINT to route CSC interrupts to PCI
[    9.800712] Yenta: Routing CardBus interrupts to PCI
[    9.800766] Yenta TI: socket 0000:06:04.0, mfunc 0x10aa1b22, devctl 0x66
[    9.805070] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    9.805445] input: Video Bus as /class/input/input8
[    9.816499] ieee80211: 802.11 data/management/control stack, git-1.1.13
[    9.816558] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[    9.829066] ACPI: Video Device [GFX0] (multi-head: yes  rom: yes  post: no)
[    9.840479] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
[    9.840547] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   10.023833] Yenta: ISA IRQ mask 0x0cf8, PCI irq 16
[   10.023892] Socket status: 30000006
[   10.023942] Yenta: Raising subordinate bus# of parent bus (#06) from #07 to #0a
[   10.024005] pcmcia: parent PCI bridge I/O window: 0x6000 - 0x6fff
[   10.024072] pcmcia: parent PCI bridge Memory window: 0xc4000000 - 0xc40fffff
[   10.031338] input: PS/2 Mouse as /class/input/input9
[   10.034886] ACPI: PCI Interrupt 0000:06:02.0[A] -> GSI 22 (level, low) -> IRQ 22
[   10.044815] ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
[   10.044913] firmware: requesting ipw2200-bss.fw
[   10.067714] input: AlpsPS/2 ALPS GlidePoint as /class/input/input10
[   10.534594] ipw2200: Radio Frequency Kill Switch is On:
[   10.534597] Kill switch must be turned off for wireless networking to work.
[   10.535092] ipw2200: Detected geography ZZM (11 802.11bg channels, 0 802.11a channels)
[   10.535210] ACPI: PCI Interrupt 0000:00:1e.2[A] -> GSI 17 (level, low) -> IRQ 17
[   10.535334] PCI: Setting latency timer of device 0000:00:1e.2 to 64
[   11.182157] Clocksource tsc unstable (delta = -77135590 ns)
[   11.350030] intel8x0_measure_ac97_clock: measured 50736 usecs
[   11.350082] intel8x0: clocking to 48000
[   12.172322] Non-volatile memory driver v1.2
[   12.185343] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   12.190783] firmware: requesting intel-ucode/06-0d-08
[   12.217045] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   12.229021] Machine check exception polling timer started.
[   12.286418] Adding 1461844k swap on /dev/sda5.  Priority:-1 extents:1 across:1461844k
[   12.523578] Filesystem "dm-0": Disabling barriers, not supported by the underlying device
[   12.939611] kjournald starting.  Commit interval 5 seconds
[   12.945052] EXT3 FS on sda1, internal journal
[   12.945052] EXT3-fs: mounted filesystem with ordered data mode.
[   12.977320] Filesystem "dm-3": Disabling barriers, not supported by the underlying device
[   12.997772] XFS mounting filesystem dm-3
[   13.098262] Ending clean XFS mount for filesystem: dm-3
[   13.143503] Filesystem "dm-1": Disabling barriers, not supported by the underlying device
[   13.163812] XFS mounting filesystem dm-1
[   13.237413] Ending clean XFS mount for filesystem: dm-1
[   13.238065] Filesystem "dm-2": Disabling barriers, not supported by the underlying device
[   13.238211] XFS mounting filesystem dm-2
[   13.452498] Ending clean XFS mount for filesystem: dm-2
[   17.686089] ip_tables: (C) 2000-2006 Netfilter Core Team
[   23.810166] usb 2-5: new high speed USB device using ehci_hcd and address 3
[   23.925029] usb 2-5: configuration #1 chosen from 1 choice
[   23.963473] Initializing USB Mass Storage driver...
[   23.964288] scsi6 : SCSI emulation for USB Mass Storage devices
[   23.964454] usbcore: registered new interface driver usb-storage
[   23.964457] USB Mass Storage support registered.
[   23.965619] usb-storage: device found at 3
[   23.965621] usb-storage: waiting for device to settle before scanning
[   24.565378] NET: Registered protocol family 17
[   26.130297] atkbd.c: Unknown key pressed (translated set 2, code 0x95 on isa0060/serio0).
[   26.130297] atkbd.c: Use 'setkeycodes e015 <keycode>' to make it known.
[   26.130462] atkbd.c: Unknown key released (translated set 2, code 0x95 on isa0060/serio0).
[   26.130462] atkbd.c: Use 'setkeycodes e015 <keycode>' to make it known.
[   26.247963] ACPI: EC: non-query interrupt received, switching to interrupt mode
[   28.965258] usb-storage: device scan complete
[   28.965597] scsi 6:0:0:0: Direct-Access     CBM      Flash Disk       5.00 PQ: 0 ANSI: 2
[   28.978447] sd 6:0:0:0: [sdb] 257792 512-byte hardware sectors (132 MB)
[   28.982239] sd 6:0:0:0: [sdb] Write Protect is off
[   28.982243] sd 6:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[   28.982245] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   28.984431] sd 6:0:0:0: [sdb] 257792 512-byte hardware sectors (132 MB)
[   28.985075] sd 6:0:0:0: [sdb] Write Protect is off
[   28.985075] sd 6:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[   28.985075] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   28.985075]  sdb: sdb1
[   28.985840] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[   28.985840] sd 6:0:0:0: Attached scsi generic sg2 type 0
[  105.379430] tun: Universal TUN/TAP device driver, 1.6
[  105.379435] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[  332.992622] warning: `ntpd' uses 32-bit capabilities (legacy support in use)
[  499.178040] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  499.178105] ata1.00: cmd ca/00:3e:76:45:81/00:00:00:00:00/e1 tag 0 dma 31744 out
[  499.178106]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  499.178168] ata1.00: status: { DRDY }
[  499.178220] ata1: hard resetting link
[  499.942034] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  499.943540] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[  499.946056] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[  499.947174] ata1.00: configured for UDMA/100
[  499.947174] ata1: EH complete
[  499.947443] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[  499.947443] sd 0:0:0:0: [sda] Write Protect is off
[  499.947443] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  499.947443] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  529.963038] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  529.963102] ata1.00: cmd ca/00:18:17:0b:94/00:00:00:00:00/e0 tag 0 dma 12288 out
[  529.963103]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  529.963166] ata1.00: status: { DRDY }
[  529.963217] ata1: hard resetting link
[  530.778173] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  530.779373] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[  530.781865] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[  530.782983] ata1.00: configured for UDMA/100
[  530.782983] ata1: EH complete
[  530.784112] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[  530.784232] sd 0:0:0:0: [sda] Write Protect is off
[  530.784235] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  530.784474] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  560.791039] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  560.791104] ata1.00: cmd ca/00:28:1f:7f:99/00:00:00:00:00/e0 tag 0 dma 20480 out
[  560.791106]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  560.791168] ata1.00: status: { DRDY }
[  560.791219] ata1: hard resetting link
[  561.606033] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  561.607234] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[  561.609720] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[  561.610838] ata1.00: configured for UDMA/100
[  561.610838] ata1: EH complete
[  561.611190] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[  561.611354] sd 0:0:0:0: [sda] Write Protect is off
[  561.611354] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  561.612087] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  682.780718] ieee80211_crypt: registered algorithm 'CCMP'
[  683.768096] ieee80211_crypt: registered algorithm 'TKIP'
[  814.838039] ata1: limiting SATA link speed to 1.5 Gbps
[  814.838046] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  814.838109] ata1.00: cmd ca/00:10:57:b6:17/00:00:00:00:00/e2 tag 0 dma 8192 out
[  814.838110]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  814.838172] ata1.00: status: { DRDY }
[  814.838224] ata1: hard resetting link
[  815.602032] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  815.603229] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[  815.606466] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[  815.607598] ata1.00: configured for UDMA/100
[  815.607598] ata1: EH complete
[  815.607806] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[  815.607887] sd 0:0:0:0: [sda] Write Protect is off
[  815.607887] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  815.608242] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  845.624027] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  845.624087] ata1.00: cmd ca/00:10:df:17:79/00:00:00:00:00/e0 tag 0 dma 8192 out
[  845.624089]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  845.624150] ata1.00: status: { DRDY }
[  845.624199] ata1: hard resetting link
[  846.439166] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  846.440368] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[  846.442863] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[  846.443980] ata1.00: configured for UDMA/100
[  846.443980] ata1: EH complete
[  846.444412] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[  846.444783] sd 0:0:0:0: [sda] Write Protect is off
[  846.444783] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  846.444977] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  876.459037] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  876.459103] ata1.00: cmd ca/00:01:87:08:71/00:00:00:00:00/e3 tag 0 dma 512 out
[  876.459105]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  876.459166] ata1.00: status: { DRDY }
[  876.459218] ata1: hard resetting link
[  877.325032] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  877.326233] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[  877.329234] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[  877.330350] ata1.00: configured for UDMA/100
[  877.330350] ata1: EH complete
[  877.334027] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[  877.334086] sd 0:0:0:0: [sda] Write Protect is off
[  877.334089] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  877.334125] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  970.438986] usb 2-5: USB disconnect, address 3
[ 1154.161035] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 1154.161100] ata1.00: cmd ca/00:30:2f:19:f6/00:00:00:00:00/e2 tag 0 dma 24576 out
[ 1154.161102]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 1154.161164] ata1.00: status: { DRDY }
[ 1154.161215] ata1: hard resetting link
[ 1154.772159] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 1154.773358] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1154.775851] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1154.776967] ata1.00: configured for UDMA/100
[ 1154.776967] ata1: EH complete
[ 1154.777379] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[ 1154.777571] sd 0:0:0:0: [sda] Write Protect is off
[ 1154.777571] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1154.777766] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1186.493044] ata1.00: limiting speed to UDMA/66:PIO4
[ 1186.493050] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 1186.493113] ata1.00: cmd ca/00:10:17:25:f6/00:00:00:00:00/e2 tag 0 dma 8192 out
[ 1186.493115]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 1186.493177] ata1.00: status: { DRDY }
[ 1186.493228] ata1: hard resetting link
[ 1187.155167] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 1187.156365] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1187.158855] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1187.159972] ata1.00: configured for UDMA/66
[ 1187.159972] ata1: EH complete
[ 1187.161154] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[ 1187.161283] sd 0:0:0:0: [sda] Write Protect is off
[ 1187.161286] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1187.161567] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1217.172036] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 1217.172098] ata1.00: cmd 35/00:00:47:01:f8/00:04:02:00:00/e0 tag 0 dma 524288 out
[ 1217.172100]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 1217.172162] ata1.00: status: { DRDY }
[ 1217.172212] ata1: hard resetting link
[ 1217.936036] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 1217.937237] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1217.940440] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1217.941572] ata1.00: configured for UDMA/66
[ 1217.941572] ata1: EH complete
[ 1217.949939] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[ 1217.954021] sd 0:0:0:0: [sda] Write Protect is off
[ 1217.954021] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1217.961634] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1315.895050] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 1315.895088] ata1.00: cmd ca/00:20:d7:23:f8/00:00:00:00:00/e2 tag 0 dma 16384 out
[ 1315.895090]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 1315.895119] ata1.00: status: { DRDY }
[ 1315.895138] ata1: hard resetting link
[ 1316.557036] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 1316.558237] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1316.561473] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1316.562606] ata1.00: configured for UDMA/66
[ 1316.562606] ata1: EH complete
[ 1316.562820] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[ 1316.562820] sd 0:0:0:0: [sda] Write Protect is off
[ 1316.562820] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1316.562820] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1346.570036] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 1346.570064] ata1.00: cmd ca/00:08:57:0a:49/00:00:00:00:00/e0 tag 0 dma 4096 out
[ 1346.570065]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 1346.570095] ata1.00: status: { DRDY }
[ 1346.570112] ata1: hard resetting link
[ 1347.334036] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 1347.335237] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1347.338409] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1347.339542] ata1.00: configured for UDMA/66
[ 1347.339542] ata1: EH complete
[ 1347.339715] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[ 1347.339793] sd 0:0:0:0: [sda] Write Protect is off
[ 1347.339793] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1347.339976] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1377.351032] ata1.00: limiting speed to UDMA/33:PIO4
[ 1377.351036] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 1377.351063] ata1.00: cmd ca/00:08:cf:09:cd/00:00:00:00:00/e0 tag 0 dma 4096 out
[ 1377.351064]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 1377.351093] ata1.00: status: { DRDY }
[ 1377.351111] ata1: hard resetting link
[ 1378.166173] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 1378.167377] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1378.170232] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1378.171349] ata1.00: configured for UDMA/33
[ 1378.171349] ata1: EH complete
[ 1378.171518] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[ 1378.171593] sd 0:0:0:0: [sda] Write Protect is off
[ 1378.171593] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1378.171656] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1408.178032] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 1408.178060] ata1.00: cmd ca/00:10:c7:94:f1/00:00:00:00:00/e2 tag 0 dma 8192 out
[ 1408.178061]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 1408.178090] ata1.00: status: { DRDY }
[ 1408.178108] ata1: hard resetting link
[ 1408.993173] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 1408.994375] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1408.996870] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1408.997988] ata1.00: configured for UDMA/33
[ 1408.997988] ata1: EH complete
[ 1408.998203] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[ 1408.998340] sd 0:0:0:0: [sda] Write Protect is off
[ 1408.998340] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1408.998523] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1439.006036] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 1439.006066] ata1.00: cmd ca/00:10:27:13:91/00:00:00:00:00/e2 tag 0 dma 8192 out
[ 1439.006067]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 1439.006097] ata1.00: status: { DRDY }
[ 1439.006116] ata1: hard resetting link
[ 1439.821174] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 1439.822375] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1439.824872] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1439.825988] ata1.00: configured for UDMA/33
[ 1439.825988] ata1: EH complete
[ 1439.826156] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[ 1439.826252] sd 0:0:0:0: [sda] Write Protect is off
[ 1439.826252] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1439.826488] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1469.836037] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 1469.836065] ata1.00: cmd ca/00:08:7f:4e:f8/00:00:00:00:00/e2 tag 0 dma 4096 out
[ 1469.836067]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 1469.836096] ata1.00: status: { DRDY }
[ 1469.836114] ata1: hard resetting link
[ 1470.651175] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 1470.652376] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1470.654877] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1470.655994] ata1.00: configured for UDMA/33
[ 1470.655994] ata1: EH complete
[ 1470.656164] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[ 1470.656240] sd 0:0:0:0: [sda] Write Protect is off
[ 1470.656240] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1470.656398] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1500.664044] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 1500.664071] ata1.00: cmd ca/00:10:2f:72:f8/00:00:00:00:00/e2 tag 0 dma 8192 out
[ 1500.664072]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 1500.664101] ata1.00: status: { DRDY }
[ 1500.664119] ata1: hard resetting link
[ 1501.428036] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 1501.429237] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1501.432423] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1501.433555] ata1.00: configured for UDMA/33
[ 1501.433555] ata1: EH complete
[ 1501.433855] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[ 1501.433951] sd 0:0:0:0: [sda] Write Protect is off
[ 1501.433951] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1501.434106] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1531.443037] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 1531.443064] ata1.00: cmd ca/00:08:e7:91:f8/00:00:00:00:00/e2 tag 0 dma 4096 out
[ 1531.443066]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 1531.443095] ata1.00: status: { DRDY }
[ 1531.443112] ata1: hard resetting link
[ 1532.207034] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 1532.208235] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1532.211421] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1532.212554] ata1.00: configured for UDMA/33
[ 1532.212554] ata1: EH complete
[ 1532.212758] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[ 1532.212867] sd 0:0:0:0: [sda] Write Protect is off
[ 1532.212867] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1532.213025] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1562.219036] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 1562.219064] ata1.00: cmd ca/00:08:2f:ac:f8/00:00:00:00:00/e2 tag 0 dma 4096 out
[ 1562.219066]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 1562.219095] ata1.00: status: { DRDY }
[ 1562.219113] ata1: hard resetting link
[ 1562.983062] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 1562.984249] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1562.987424] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1562.988556] ata1.00: configured for UDMA/33
[ 1562.988556] ata1: EH complete
[ 1562.988748] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[ 1562.988851] sd 0:0:0:0: [sda] Write Protect is off
[ 1562.988851] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1562.989049] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1592.996034] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 1592.996062] ata1.00: cmd ca/00:10:5f:c9:f8/00:00:00:00:00/e2 tag 0 dma 8192 out
[ 1592.996063]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[ 1592.996093] ata1.00: status: { DRDY }
[ 1592.996110] ata1: hard resetting link
[ 1593.760172] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[ 1593.761372] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1593.763862] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[ 1593.764977] ata1.00: configured for UDMA/33
[ 1593.764977] ata1: EH complete
[ 1593.765183] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[ 1593.765206] sd 0:0:0:0: [sda] Write Protect is off
[ 1593.765206] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 1593.765206] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1617.738192] usb 2-5: new high speed USB device using ehci_hcd and address 4
[ 1617.852903] usb 2-5: configuration #1 chosen from 1 choice
[ 1617.859032] scsi7 : SCSI emulation for USB Mass Storage devices
[ 1617.862832] usb-storage: device found at 4
[ 1617.862834] usb-storage: waiting for device to settle before scanning
[ 1622.862353] usb-storage: device scan complete
[ 1622.862703] scsi 7:0:0:0: Direct-Access     CBM      Flash Disk       5.00 PQ: 0 ANSI: 2
[ 1622.864004] sd 7:0:0:0: [sdb] 257792 512-byte hardware sectors (132 MB)
[ 1622.864615] sd 7:0:0:0: [sdb] Write Protect is off
[ 1622.864618] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[ 1622.864621] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[ 1622.866735] sd 7:0:0:0: [sdb] 257792 512-byte hardware sectors (132 MB)
[ 1622.867362] sd 7:0:0:0: [sdb] Write Protect is off
[ 1622.867365] sd 7:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[ 1622.867367] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[ 1622.867420]  sdb: sdb1
[ 1622.868538] sd 7:0:0:0: [sdb] Attached SCSI removable disk
[ 1622.868580] sd 7:0:0:0: Attached scsi generic sg2 type 0

--------------010604070005090608070009--
