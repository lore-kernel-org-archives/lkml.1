Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbYFNHrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbYFNHrZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 03:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYFNHrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 03:47:17 -0400
Received: from stinky.trash.net ([213.144.137.162]:63796 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbYFNHrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 03:47:12 -0400
Message-ID: <48537502.4090102@trash.net>
Date: Sat, 14 Jun 2008 09:36:34 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, x86@kernel.org
Subject: Re: 2.6.26-git: NULL pointer deref in __switch_to
References: <4852B19E.4010202@trash.net> <19f34abd0806131124w32133715o3ef8c27cb0a9f96e@mail.gmail.com> <20080613224711.GA15084@linux-os.sc.intel.com>
In-Reply-To: <20080613224711.GA15084@linux-os.sc.intel.com>
Content-Type: multipart/mixed;
 boundary="------------070001000902020007030604"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070001000902020007030604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Suresh Siddha wrote:
> On Fri, Jun 13, 2008 at 11:24:01AM -0700, Vegard Nossum wrote:
>   
>> On Fri, Jun 13, 2008 at 7:42 PM, Patrick McHardy <kaber@trash.net> wrote:
>>     
>>> [62060.043009] BUG: unable to handle kernel NULL pointer dereference at
>>> 000001ff
>>> [62060.043009] IP: [<c0102a9b>] __switch_to+0x2f/0x118
>>> [62060.043009] *pde = 00000000
>>> [62060.043009] Oops: 0002 [#1] PREEMPT
>>>       
>
> Patrick, Do you see any other error messages before this BUG stmt? Can you
> please provide the complete kernel log till the point of failure?
>   

The oops is usually the first message after the boot messages.
I've attached a log.

> I have a theory for your problem and have appended a patch to test it. Can
> you please check if the appended patch fixes your problem.
>   

Yes, thanks. It usually it takes a day to trigger though.



--------------070001000902020007030604
Content-Type: text/plain;
 name="log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="log"

[    0.000000] Linux version 2.6.26-rc5 (kaber@gw) (gcc version 4.1.3 20080420 (prerelease) (Debian 4.1.2-22)) #5 PREEMPT Thu Jun 12 13:06:02 CEST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000bffb0000 - 00000000bffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bffc0000 - 00000000bfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000] 2175MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 786352) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   786352
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   786352
[    0.000000] On node 0 totalpages: 786352
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 4352 pages used for memmap
[    0.000000]   HighMem zone: 552624 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FB470, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT BFFB0000, 0030 (r1 A M I  OEMRSDT   9000507 MSFT       97)
[    0.000000] ACPI: FACP BFFB0200, 0081 (r2 A M I  OEMFACP   9000507 MSFT       97)
[    0.000000] ACPI: DSDT BFFB03F0, 3391 (r1  A0149 A0149001        1 INTL  2002026)
[    0.000000] ACPI: FACS BFFC0000, 0040
[    0.000000] ACPI: APIC BFFB0390, 005C (r1 A M I  OEMAPIC   9000507 MSFT       97)
[    0.000000] ACPI: OEMB BFFC0040, 0040 (r1 A M I  AMI_OEM   9000507 MSFT       97)
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:3f780000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 780208
[    0.000000] Kernel command line: root=/dev/sda2 ro panic=30 
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c0470000 soft=c046f000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2667.561 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] Memory: 3115000k/3145408k available (2203k kernel code, 29216k reserved, 1067k data, 228k init, 2227904k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfffa7000 - 0xfffff000   ( 352 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.000999]       .init : 0xc0433000 - 0xc046c000   ( 228 kB)
[    0.000999]       .data : 0xc0326edb - 0xc0431b10   (1067 kB)
[    0.000999]       .text : 0xc0100000 - 0xc0326edb   (2203 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
[    0.000999] SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.060993] Calibrating delay using timer specific routine.. 5337.42 BogoMIPS (lpj=2668710)
[    0.061102] Mount-cache hash table entries: 512
[    0.061309] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.061390] CPU: L2 cache: 256K
[    0.061435] Intel machine check architecture supported.
[    0.061486] Intel machine check reporting enabled on CPU#0.
[    0.061533] CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
[    0.061582] CPU0: Thermal monitoring enabled
[    0.061628] using mwait in idle threads.
[    0.061681] CPU: Intel(R) Celeron(R) CPU 2.66GHz stepping 01
[    0.061797] Checking 'hlt' instruction... OK.
[    0.067503] Freeing SMP alternatives: 0k freed
[    0.067558] ACPI: Core revision 20080321
[    0.076674] ENABLING IO-APIC IRQs
[    0.076885] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.086986] net_namespace: 652 bytes
[    0.086986] Booting paravirtualized kernel on bare hardware
[    0.086986] NET: Registered protocol family 16
[    0.086986] No dock devices found.
[    0.086986] ACPI: bus type pci registered
[    0.088723] PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=1
[    0.088773] PCI: Using configuration type 1 for base access
[    0.088842] Setting up standard PCI resources
[    0.112047] ACPI: EC: Look up EC in DSDT
[    0.123062] ACPI: Interpreter enabled
[    0.123114] ACPI: (supports S0 S5)
[    0.123228] ACPI: Using IOAPIC for interrupt routing
[    0.134445] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.135668] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.146706] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 12 14 15)
[    0.147270] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 11 12 14 15)
[    0.147822] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 7 10 11 12 14 15)
[    0.148382] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 10 11 12 14 15)
[    0.148926] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 *11 12 14 15)
[    0.149476] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 7 10 11 12 14 15)
[    0.150036] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 7 10 11 12 14 15)
[    0.150583] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 7 10 11 12 14 15)
[    0.151239] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 87, should be 7A [20080321]
[    0.151371] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.151462] pnp: PnP ACPI init
[    0.151516] ACPI: bus type pnp registered
[    0.157735] pnp: PnP ACPI: found 12 devices
[    0.157787] ACPI: ACPI bus type pnp unregistered
[    0.158141] SCSI subsystem initialized
[    0.158225] libata version 3.00 loaded.
[    0.158448] PCI: Using ACPI for IRQ routing
[    0.158762] system 00:07: ioport range 0x680-0x6ff has been reserved
[    0.158816] system 00:07: ioport range 0x290-0x297 has been reserved
[    0.158870] system 00:08: ioport range 0x480-0x48f has been reserved
[    0.158918] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.158965] system 00:08: ioport range 0x800-0x8df has been reserved
[    0.159021] system 00:08: ioport range 0x8e0-0x8ff has been reserved
[    0.159072] system 00:08: iomem range 0xffe80000-0xffefffff could not be reserved
[    0.159134] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.159182] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.159230] system 00:09: iomem range 0xfff80000-0xffffffff could not be reserved
[    0.159292] system 00:0b: iomem range 0x0-0x9ffff could not be reserved
[    0.159339] system 00:0b: iomem range 0xc0000-0xdffff could not be reserved
[    0.159387] system 00:0b: iomem range 0xe0000-0xfffff could not be reserved
[    0.159434] system 00:0b: iomem range 0x100000-0xbffeffff could not be reserved
[    0.190036] PCI: Bridge: 0000:00:01.0
[    0.190088]   IO window: d000-dfff
[    0.190136]   MEM window: 0xff400000-0xff4fffff
[    0.190183]   PREFETCH window: 0x00000000e7f00000-0x00000000f7efffff
[    0.190256] NET: Registered protocol family 2
[    0.190407] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.190775] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.191617] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[    0.191841] TCP: Hash tables configured (established 131072 bind 65536)
[    0.191895] TCP reno registered
[    0.192385] Machine check exception polling timer started.
[    0.195382] highmem bounce pool size: 64 pages
[    0.197895] VFS: Disk quotas dquot_6.5.1
[    0.197988] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.198486] msgmni has been set to 1734
[    0.198667] io scheduler noop registered
[    0.198733] io scheduler cfq registered (default)
[    0.198836] pci 0000:01:00.0: Boot video device
[    0.199304] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.199359] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.241497] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[    0.241694] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.242957] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.243317] sis900.c: v1.08.10 Apr. 2 2006
[    0.243396] ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 19 (level, low) -> IRQ 19
[    0.244863] 0000:00:04.0: Realtek RTL8201 PHY transceiver found at address 1.
[    0.256055] 0000:00:04.0: Using transceiver found at address 1 as default
[    0.257126] eth0: SiS 900 PCI Fast Ethernet at 0xe400, IRQ 19, 00:13:d4:cb:7c:12
[    0.257272] r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
[    0.257347] ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 17
[    0.257769] eth1: RTL8110s at 0xf8810c00, 00:15:e9:f0:10:f8, XID 04000000 IRQ 17
[    0.261042] Loaded prism54 driver, version 1.2
[    0.261127] ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.261758] console [netcon0] enabled
[    0.261809] netconsole: network logging started
[    0.262088] Driver 'sd' needs updating - please use bus_type methods
[    0.262194] sata_sis 0000:00:05.0: version 1.0
[    0.262251] ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 17 (level, low) -> IRQ 17
[    0.262342] sata_sis 0000:00:05.0: Detected SiS 180/181/964 chipset in SATA mode
[    0.262495] scsi0 : sata_sis
[    0.262681] scsi1 : sata_sis
[    0.262806] ata1: SATA max UDMA/133 cmd 0xeff0 ctl 0xefe4 bmdma 0xef90 irq 17
[    0.262861] ata2: SATA max UDMA/133 cmd 0xefa8 ctl 0xefe0 bmdma 0xef98 irq 17
[    0.567877] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.571993] ata1.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133
[    0.572041] ata1.00: 490234752 sectors, multi 0: LBA48 NCQ (not used)
[    0.579008] ata1.00: configured for UDMA/133
[    0.690805] Switched to high resolution mode on CPU 0
[    0.884063] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.888017] ata2.00: ATA-7: Maxtor 6L250S0, BANC1G10, max UDMA/133
[    0.889441] ata2.00: 490234752 sectors, multi 0: LBA48 NCQ (not used)
[    0.896016] ata2.00: configured for UDMA/133
[    0.907139] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 ANSI: 5
[    0.907420] sd 0:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
[    0.907489] sd 0:0:0:0: [sda] Write Protect is off
[    0.907536] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.907569] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.907693] sd 0:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
[    0.907758] sd 0:0:0:0: [sda] Write Protect is off
[    0.907804] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.907835] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.907893]  sda: sda1 sda2 sda3
[    0.916024] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.916024] scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 ANSI: 5
[    0.916024] sd 1:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
[    0.917066] sd 1:0:0:0: [sdb] Write Protect is off
[    0.917113] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    0.917146] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.917270] sd 1:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
[    0.917335] sd 1:0:0:0: [sdb] Write Protect is off
[    0.917382] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    0.917413] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.917471]  sdb: unknown partition table
[    0.939003] sd 1:0:0:0: [sdb] Attached SCSI disk
[    0.940031] pata_sis 0000:00:02.5: version 0.5.2
[    0.940059] ACPI: PCI Interrupt 0000:00:02.5[A] -> GSI 16 (level, low) -> IRQ 16
[    0.940293] scsi2 : pata_sis
[    0.940457] scsi3 : pata_sis
[    0.941507] ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    0.941560] ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    1.262257] ata4.00: ATAPI: LITE-ON CD-ROM LTN-5291S, NS03, max UDMA/33
[    1.284261] ata4.00: configured for UDMA/33
[    1.296016] scsi 3:0:0:0: CD-ROM            LITE-ON  CD-ROM LTN-5291S NS03 PQ: 0 ANSI: 5
[    1.297333] PNP: No PS/2 controller found. Probing ports directly.
[    1.297726] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.297778] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.298112] mice: PS/2 mouse device common for all mice
[    1.298219] EDAC MC: Ver: 2.1.0 Jun 12 2008
[    1.298445] cpuidle: using governor ladder
[    1.298493] cpuidle: using governor menu
[    1.299238] TCP vegas registered
[    1.299328] NET: Registered protocol family 10
[    1.299895] lo: Disabled Privacy Extensions
[    1.301262] Mobile IPv6
[    1.301311] Using IPI Shortcut mode
[    1.512723] EXT3-fs: INFO: recovery required on readonly filesystem.
[    1.512777] EXT3-fs: write access will be enabled during recovery.
[    2.191481] kjournald starting.  Commit interval 5 seconds
[    2.191481] EXT3-fs: recovery complete.
[    2.191495] EXT3-fs: mounted filesystem with ordered data mode.
[    2.191495] VFS: Mounted root (ext3 filesystem) readonly.
[    2.191495] Freeing unused kernel memory: 228k freed
[    2.191495] Write protecting the kernel text: 2204k
[    2.191495] Write protecting the kernel read-only data: 900k
[    3.707047] NET: Registered protocol family 1
[    4.973396] udev: renamed network interface eth2 to wlan0
[    5.022261] udev: renamed network interface eth1_rename to eth2
[    6.504262] usbcore: registered new interface driver usbfs
[    6.504355] usbcore: registered new interface driver hub
[    6.504451] usbcore: registered new device driver usb
[    6.586241] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
[    6.586298] Copyright (c) 1999-2006 Intel Corporation.
[    6.586405] ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
[    6.632020] Real Time Clock Driver v1.12ac
[    6.683221] parport_pc 00:06: reported by Plug and Play ACPI
[    6.683320] parport0: PC-style at 0x378, irq 7 [PCSPP]
[    6.700866] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.901166] e1000: 0000:00:0a.0: e1000_probe: (PCI:33MHz:32-bit) 00:1b:21:04:7b:28
[    7.048091] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
[    7.048270] ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 20 (level, low) -> IRQ 20
[    7.048377] ohci_hcd 0000:00:03.0: OHCI Host Controller
[    7.048729] ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 1
[    7.048819] ohci_hcd 0000:00:03.0: irq 20, io mem 0xff6fc000
[    7.101351] usb usb1: configuration #1 chosen from 1 choice
[    7.101458] hub 1-0:1.0: USB hub found
[    7.101516] hub 1-0:1.0: 3 ports detected
[    7.203623] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    7.203679] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.203735] usb usb1: Product: OHCI Host Controller
[    7.203779] usb usb1: Manufacturer: Linux 2.6.26-rc5 ohci_hcd
[    7.203825] usb usb1: SerialNumber: 0000:00:03.0
[    7.204485] ACPI: PCI Interrupt 0000:00:03.1[B] -> GSI 21 (level, low) -> IRQ 21
[    7.204599] ohci_hcd 0000:00:03.1: OHCI Host Controller
[    7.204694] ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 2
[    7.204772] ohci_hcd 0000:00:03.1: irq 21, io mem 0xff6fd000
[    7.257422] usb usb2: configuration #1 chosen from 1 choice
[    7.257538] hub 2-0:1.0: USB hub found
[    7.257596] hub 2-0:1.0: 3 ports detected
[    7.358126] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    7.358182] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.358238] usb usb2: Product: OHCI Host Controller
[    7.358283] usb usb2: Manufacturer: Linux 2.6.26-rc5 ohci_hcd
[    7.358329] usb usb2: SerialNumber: 0000:00:03.1
[    7.358446] ACPI: PCI Interrupt 0000:00:03.3[D] -> GSI 23 (level, low) -> IRQ 23
[    7.358552] ehci_hcd 0000:00:03.3: EHCI Host Controller
[    7.358635] ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 3
[    7.358728] PCI: cache line size of 128 is not supported by device 0000:00:03.3
[    7.358745] ehci_hcd 0000:00:03.3: irq 23, io mem 0xff6ff000
[    7.463017] usb 1-2: new full speed USB device using ohci_hcd and address 2
[    7.469011] ehci_hcd 0000:00:03.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    7.469176] usb usb3: configuration #1 chosen from 1 choice
[    7.469261] hub 3-0:1.0: USB hub found
[    7.469316] hub 3-0:1.0: 8 ports detected
[    7.521030] hub 1-0:1.0: unable to enumerate USB device on port 2
[    7.570114] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    7.570165] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.570219] usb usb3: Product: EHCI Host Controller
[    7.570264] usb usb3: Manufacturer: Linux 2.6.26-rc5 ehci_hcd
[    7.570309] usb usb3: SerialNumber: 0000:00:03.3
[    7.570400] ACPI: PCI Interrupt 0000:00:03.2[C] -> GSI 22 (level, low) -> IRQ 22
[    7.570507] ohci_hcd 0000:00:03.2: OHCI Host Controller
[    7.570586] ohci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 4
[    7.570663] ohci_hcd 0000:00:03.2: irq 22, io mem 0xff6fe000
[    7.623130] usb usb4: configuration #1 chosen from 1 choice
[    7.623220] hub 4-0:1.0: USB hub found
[    7.623275] hub 4-0:1.0: 2 ports detected
[    7.724116] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    7.724172] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.724227] usb usb4: Product: OHCI Host Controller
[    7.724272] usb usb4: Manufacturer: Linux 2.6.26-rc5 ohci_hcd
[    7.724317] usb usb4: SerialNumber: 0000:00:03.2
[    7.724427] sata_promise 0000:00:0b.0: version 2.12
[    7.724457] ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 19
[    7.725197] scsi4 : sata_promise
[    7.725597] scsi5 : sata_promise
[    7.725979] scsi6 : sata_promise
[    7.726110] ata5: SATA max UDMA/133 mmio m4096@0xff6f6000 ata 0xff6f6200 irq 19
[    7.726168] ata6: SATA max UDMA/133 mmio m4096@0xff6f6000 ata 0xff6f6280 irq 19
[    7.726222] ata7: PATA max UDMA/133 mmio m4096@0xff6f6000 ata 0xff6f6300 irq 19
[    8.031033] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    8.050355] ata5.00: ATA-8: SAMSUNG HD501LJ, CR100-10, max UDMA7
[    8.050404] ata5.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    8.053354] ata5.00: configured for UDMA/133
[    8.092014] usb 1-2: new full speed USB device using ohci_hcd and address 3
[    8.282005] usb 1-2: configuration #1 chosen from 1 choice
[    8.287009] usb 1-2: New USB device found, idVendor=04e8, idProduct=3419
[    8.287009] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    8.288022] usb 1-2: Product: SCX-4x21 Series
[    8.288067] usb 1-2: Manufacturer: Samsung
[    8.288111] usb 1-2: SerialNumber: 8P31BABL907306W.
[    8.358037] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    8.361359] ata6.00: ATA-8: SAMSUNG HD501LJ, CR100-10, max UDMA7
[    8.361408] ata6.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    8.364357] ata6.00: configured for UDMA/133
[    8.515181] scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[    8.515384] sd 4:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
[    8.515451] sd 4:0:0:0: [sdc] Write Protect is off
[    8.515498] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    8.515531] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.515660] sd 4:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
[    8.515725] sd 4:0:0:0: [sdc] Write Protect is off
[    8.515772] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    8.515803] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.515861]  sdc: unknown partition table
[    8.551089] sd 4:0:0:0: [sdc] Attached SCSI disk
[    8.552513] scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[    8.552687] sd 5:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
[    8.552754] sd 5:0:0:0: [sdd] Write Protect is off
[    8.552800] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    8.552834] sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.552956] sd 5:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
[    8.553385] sd 5:0:0:0: [sdd] Write Protect is off
[    8.553431] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    8.553463] sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.553521]  sdd: unknown partition table
[    8.596997] sd 5:0:0:0: [sdd] Attached SCSI disk
[    8.911016] usblp0: USB Bidirectional printer dev 3 if 1 alt 0 proto 2 vid 0x04E8 pid 0x3419
[    8.911016] usbcore: registered new interface driver usblp
[   10.383025] EXT3 FS on sda2, internal journal
[   11.487931] p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
[   11.564635] lguest: mapped switcher at ffc00000
[   11.723362] device-mapper: uevent: version 1.0.3
[   11.723535] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[   19.120021] kjournald starting.  Commit interval 5 seconds
[   19.120021] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[   19.129138] EXT3 FS on dm-3, internal journal
[   19.129219] EXT3-fs: recovery complete.
[   19.129265] EXT3-fs: mounted filesystem with ordered data mode.
[   19.173006] Adding 979924k swap on /dev/mapper/cswap.  Priority:-1 extents:1 across:979924k
[   20.039891] NET: Registered protocol family 15
[   20.655914] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   20.741192] Netfilter messages via NETLINK v0.30.
[   20.994658] ip_tables: (C) 2000-2006 Netfilter Core Team
[   21.116318] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   23.323511] IPv4 FIB: Using LC-trie version 0.408
[   23.435962] r8169: eth2: link up
[   24.140759] wlan0: resetting device...
[   24.140775] wlan0: uploading firmware...
[   24.190827] firmware: requesting isl3890
[   24.298569] wlan0: firmware version: 1.0.4.3
[   24.298625] wlan0: firmware upload complete
[   24.524976] wlan0: interface reset complete
[   24.967895] NET: Registered protocol family 17
[   26.937004] eth0: Media Link On 100mbps full-duplex 
[   31.935261] IPv6 over IPv4 tunneling driver
[   31.935949] sit0: Disabled Privacy Extensions
[   31.954048] tun: Universal TUN/TAP device driver, 1.6
[   31.954103] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   35.487300] warning: `named' uses 32-bit capabilities (legacy support in use)
[   43.457087] RPC: Registered udp transport module.
[   43.457404] RPC: Registered tcp transport module.
[   43.626372] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   43.743255] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   43.753411] NFSD: starting 90-second grace period
[   56.585469] kjournald starting.  Commit interval 5 seconds
[   56.585817] EXT3-fs: mounted filesystem with ordered data mode.
[   59.698206] kjournald starting.  Commit interval 5 seconds
[   59.698555] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[   59.701210] EXT3 FS on dm-5, internal journal
[   59.701298] EXT3-fs: recovery complete.
[   59.704207] EXT3-fs: mounted filesystem with ordered data mode.
[   64.401954] sixxs: Disabled Privacy Extensions

--------------070001000902020007030604--
