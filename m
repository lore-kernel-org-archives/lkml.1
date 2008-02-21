Return-Path: <linux-kernel-owner+w=401wt.eu-S1760366AbYBUIn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbYBUIn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 03:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYBUInQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 03:43:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:44053 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757283AbYBUInK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 03:43:10 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/chuhcztDc8qefXBQDTMIw5q2mvOEWKl27NJ7C8d
	9Bb6HgYc2E2dZP
Subject: regression: CD burning (k3b) went broke
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <htejun@gmail.com>
Content-Type: multipart/mixed; boundary="=-G3RFvOt6cbBQAAzh0xSR"
Date: Thu, 21 Feb 2008 09:42:59 +0100
Message-Id: <1203583379.6244.27.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-G3RFvOt6cbBQAAzh0xSR
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Greetings,

K3b recently (9a4c854..5d9c4a7 pull) began terminally griping about
buffer underrun upon every attempt to burn a CD.  I can't fully bisect
the problem  because intervening kernels hang soft during boot.  Using
git bisect visualize, and converting to postable text:

bisect/bad   block: add request->raw_data_len (6b00769fe1502b4ad97bb327ef7ac971b208bfb5)
bisect           block: update bio according to DMA alignment padding (40b01b9bbdf51ae543a04744283bf2d56c4a6afa)
libata: update ATAPI overflow draining
bisect/good-e164094964e6e20fe7fce418e06a9dce952bb7a4

Serial console log of hung kernel 40b01b9bbdf51ae543a04744283bf2d56c4a6afa below

[    0.000000] Linux version 2.6.25-rc2-smp (root@homer) (gcc version 4.2.1 (SUSE Linux)) #14 SMP PREEMPT Thu Feb 21 08:49:51 CET 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 1023MB LOWMEM available.
[    0.000000] Scan SMP from b0000000 for 1024 bytes.
[    0.000000] Scan SMP from b009fc00 for 1024 bytes.
[    0.000000] Scan SMP from b00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [b00f5320] 000f5320
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   262128
[    0.000000]   HighMem    262128 ->   262128
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262128
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F6CC0, 0014 (r0 IntelR)
[    0.000000] ACPI: RSDT 3FFF3000, 002C (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP 3FFF3040, 0074 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: DSDT 3FFF30C0, 4139 (r1 INTELR AWRDACPI     1000 MSFT  100000E)
[    0.000000] ACPI: FACS 3FFF0000, 0040
[    0.000000] ACPI: APIC 3FFF7200, 0068 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:2 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:2 APIC version 20
[    0.000000] WARNING: maxcpus limit of 1 reached. Processor ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260081
[    0.000000] Kernel command line: root=/dev/sdb3 rootflags=data=writeback vga=0x314 resume=/dev/sdb2 console=ttyS0,115200n8 console=tty splash=silent PROFILE=default 1 maxcpus=1
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] CPU 0 irqstacks, hard=b0427000 soft=b0425000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2992.603 MHz processor.
[    0.000999] Console: colour dummy device 80x25
[    0.000999] console [tty0] enabled
[    0.000999] console [ttyS0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] Memory: 1028968k/1048512k available (1998k kernel code, 18904k reserved, 955k data, 236k init, 0k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xf0800000 - 0xff7fe000   ( 239 MB)
[    0.000999]     lowmem  : 0xb0000000 - 0xefff0000   (1023 MB)
[    0.000999]       .init : 0xb03e7000 - 0xb0422000   ( 236 kB)
[    0.000999]       .data : 0xb02f3b26 - 0xb03e29a8   ( 955 kB)
[    0.000999]       .text : 0xb0100000 - 0xb02f3b26   (1998 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.060993] Calibrating delay using timer specific routine.. 5987.55 BogoMIPS (lpj=2993775)
[    0.063022] Security Framework initialized
[    0.064010] Mount-cache hash table entries: 512
[    0.065129] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.066992] CPU: L2 cache: 512K
[    0.067992] CPU: Physical Processor ID: 0
[    0.068993] Intel machine check architecture supported.
[    0.069994] Intel machine check reporting enabled on CPU#0.
[    0.070991] CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
[    0.071992] CPU0: Thermal monitoring enabled
[    0.072993] Compat vDSO mapped to ffffe000.
[    0.073996] Checking 'hlt' instruction... OK.
[    0.079743] SMP alternatives: switching to UP code
[    0.079998] Freeing SMP alternatives: 9k freed
[    0.080991] ACPI: Core revision 20070126
[    0.091025] CPU0: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 09
[    0.094019] Total of 1 processors activated (5987.55 BogoMIPS).
[    0.095110] ENABLING IO-APIC IRQs
[    0.096152] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.107983] Brought up 1 CPUs
[    0.108208] net_namespace: 552 bytes
[    0.110058] NET: Registered protocol family 16
[    0.111195] ACPI: bus type pci registered
[    0.114122] PCI: PCI BIOS revision 2.10 entry at 0xfb980, last bus=2
[    0.114984] PCI: Using configuration type 1
[    0.115983] Setting up standard PCI resources
[    0.139635] ACPI: Interpreter enabled
[    0.139985] ACPI: (supports S0 S3 S4 S5)
[    0.142261] ACPI: Using IOAPIC for interrupt routing
[    0.148393] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.149406] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
[    0.149981] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH4 GPIO
[    0.151395] PCI: Transparent bridge - 0000:00:1e.0
[    0.160727] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.164091] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 7 9 10 11 12 14 15)
[    0.168383] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.171666] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 7 9 10 11 12 14 15)
[    0.175277] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.179656] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 *9 10 11 12 14 15)
[    0.183050] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.188275] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.192014] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.193005] pnp: PnP ACPI init
[    0.193979] ACPI: bus type pnp registered
[    0.199104] pnpacpi: exceeded the max number of mem resources: 12
[    0.200035] pnp: PnP ACPI: found 13 devices
[    0.200971] ACPI: ACPI bus type pnp unregistered
[    0.202306] PCI: Using ACPI for IRQ routing
[    0.202977] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.226967] NetLabel: Initializing
[    0.226969] NetLabel:  domain hash size = 128
[    0.227968] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.228981] NetLabel:  unlabeled traffic allowed by default
[    0.230055] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
[    0.232158] hpet0: 3 64-bit timers, 14318180 Hz
[    0.235002] ACPI: RTC can wake from S4
[    0.235966] Time: tsc clocksource has been installed.
[    0.243966] system 00:01: ioport range 0xb78-0xb7b has been reserved
[    0.243969] system 00:01: ioport range 0xf78-0xf7b has been reserved
[    0.244971] system 00:01: ioport range 0xa78-0xa7b has been reserved
[    0.245968] system 00:01: ioport range 0xe78-0xe7b has been reserved
[    0.246967] system 00:01: ioport range 0xbbc-0xbbf has been reserved
[    0.247967] system 00:01: ioport range 0xfbc-0xfbf has been reserved
[    0.248968] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.249967] system 00:01: ioport range 0x200-0x200 has been reserved
[    0.250967] system 00:01: ioport range 0x202-0x208 has been reserved
[    0.251967] system 00:01: ioport range 0x320-0x32f has been reserved
[    0.252966] system 00:01: ioport range 0x295-0x296 has been reserved
[    0.254970] system 00:0b: ioport range 0x400-0x4bf could not be reserved
[    0.255973] system 00:0c: iomem range 0xf0000-0xf3fff could not be reserved
[    0.256966] system 00:0c: iomem range 0xf4000-0xf7fff could not be reserved
[    0.257966] system 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
[    0.258966] system 00:0c: iomem range 0xfc000-0xfffff could not be reserved
[    0.259966] system 00:0c: iomem range 0x3fff0000-0x3fffffff could not be reserved
[    0.260965] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.261965] system 00:0c: iomem range 0x100000-0x3ffeffff could not be reserved
[    0.262965] system 00:0c: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.263965] system 00:0c: iomem range 0xfec01000-0xfed8ffff could not be reserved
[    0.264965] system 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.265965] system 00:0c: iomem range 0xffb00000-0xffbfffff could not be reserved
[    0.266964] system 00:0c: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.298911] PCI: Bridge: 0000:00:01.0
[    0.298960]   IO window: a000-afff
[    0.299963]   MEM window: 0xf8000000-0xf9ffffff
[    0.300961]   PREFETCH window: 0x00000000e8000000-0x00000000f7ffffff
[    0.301963] PCI: Bridge: 0000:00:1e.0
[    0.302959]   IO window: b000-bfff
[    0.303961]   MEM window: 0xfa000000-0xfa0fffff
[    0.304960]   PREFETCH window: disabled.
[    0.305994] NET: Registered protocol family 2
[    0.325957] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.326233] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.328385] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.329394] TCP: Hash tables configured (established 131072 bind 65536)
[    0.329963] TCP reno registered
[    0.337961] Unpacking initramfs... done
[    0.574326] Freeing initrd memory: 6128k freed
[    0.576000] Machine check exception polling timer started.
[    0.577268] audit: initializing netlink socket (disabled)
[    0.577937] type=2000 audit(1203584121.788:1): initialized
[    0.579060] Total HugeTLB memory allocated, 0
[    0.579988] VFS: Disk quotas dquot_6.5.1
[    0.580947] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.582937] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.583930] io scheduler noop registered
[    0.584925] io scheduler anticipatory registered
[    0.585924] io scheduler deadline registered
[    0.586932] io scheduler cfq registered (default)
[    0.589129] vesafb: framebuffer at 0xe8000000, mapped to 0xf0880000, using 1875k, total 16384k
[    0.589925] vesafb: mode is 800x600x16, linelength=1600, pages=16
[    0.590924] vesafb: protected mode interface info at c000:b544
[    0.591926] vesafb: pmi: set display start = b00cb5d2, set palette = b00cb612
[    0.592923] vesafb: scrolling: redraw
[    0.593924] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.612485] Console: switching to colour frame buffer device 100x37
[    0.627919] fb0: VESA VGA frame buffer device
[    0.638247] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    0.639029] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.641591] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.642200] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.642917] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.644280] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.645234] mice: PS/2 mouse device common for all mice
[    0.675685] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.687684] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.687709] rtc0: alarms up to one month
[    0.688747] cpuidle: using governor ladder
[    0.689689] cpuidle: using governor menu
[    0.690751] oprofile: using NMI interrupt.
[    0.693003] NET: Registered protocol family 1
[    0.693759] p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
[    0.694686] Using IPI No-Shortcut mode
[    0.695814] registered taskstats version 1
[    0.696813] rtc_cmos 00:03: setting system clock to 2008-02-21 08:55:23 UTC (1203584123)
[    0.698738] Freeing unused kernel memory: 236k freed
[    0.699701] Write protecting the kernel text: 2000k
[    0.700690] Write protecting the kernel read-only data: 792k
[    0.762206] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.768027] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    0.768870] ACPI: Thermal Zone [THRM] (40 C)
[    0.785027] SCSI subsystem initialized
[    0.806767] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
[    0.808835] scsi0 : ata_piix
[    0.809721] scsi1 : ata_piix
[    0.812130] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    0.812702] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    1.290553] ata1.00: ATA-6: ST3160021A, 3.04, max UDMA/100
[    1.290558] ata1.00: 312581808 sectors, multi 16: LBA48 
[    1.291580] ata1.01: ATAPI: BENQ    DVD DD DW1625, BBIA, max UDMA/33
[    1.314801] ata1.00: configured for UDMA/100
[    1.473512] ata1.01: configured for UDMA/33
[    3.788245] ata2.00: ATA-6: ST3120022A, 3.06, max UDMA/100
[    3.788248] ata2.00: 234441648 sectors, multi 16: LBA48 
[    3.811575] ata2.00: configured for UDMA/100
[    3.823087] scsi 0:0:0:0: Direct-Access     ATA      ST3160021A       3.04 PQ: 0 ANSI: 5
[    3.825453] scsi 0:0:1:0: CD-ROM            BENQ     DVD DD DW1625    BBIA PQ: 0 ANSI: 5
[    3.825587] scsi 1:0:0:0: Direct-Access     ATA      ST3120022A       3.06 PQ: 0 ANSI: 5
[    3.831138] ACPI: PNP0C0B:00 is registered as cooling_device1
[    3.831481] ACPI: Fan [FAN] (on)
[    3.856766] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    3.999333] Driver 'sd' needs updating - please use bus_type methods
[    3.999551] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    4.000464] sd 0:0:0:0: [sda] Write Protect is off
[    4.001459] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.002528] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    4.003475] sd 0:0:0:0: [sda] Write Protect is off
[    4.004458] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.005586]  sda: sda1 sda2 < sda5 sda6 >
[    4.048569] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.049519] sd 1:0:0:0: [sdb] 234441648 512-byte hardware sectors (120034 MB)
[    4.050439] sd 1:0:0:0: [sdb] Write Protect is off
[    4.051473] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.052505] sd 1:0:0:0: [sdb] 234441648 512-byte hardware sectors (120034 MB)
[    4.053436] sd 1:0:0:0: [sdb] Write Protect is off
[    4.054450] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.055498]  sdb: sdb1 sdb2 sdb3
[    4.063528] sd 1:0:0:0: [sdb] Attached SCSI disk
[   37.473476] SysRq : Show State
[   37.474338]   task                PC stack   pid father
[   37.474338] init          S ef836eac     0     1      0
[   37.474338]        ef836f00 00000082 ffffffff ef836eac b01224d3 00000000 00000000 00000001 
[   37.474338]        e80cb97b 00000000 b0421180 b0421180 b0421180 ef835020 ef83527c b180b180 
[   37.474338]        00000000 ef836000 ee6e0c80 b1031ae0 00000000 00000000 ee5b9148 ef836f14 
[   37.474338] Call Trace:
[   37.474338]  [<b01224d3>] ? hrtick_set+0x7f/0xf7
[   37.474338]  [<b016de52>] ? do_wp_page+0x2a0/0x3e5
[   37.474338]  [<b01d218e>] ? security_task_wait+0xf/0x11
[   37.474338]  [<b0129e1f>] do_wait+0x470/0xa1a
[   37.474338]  [<b01249e9>] ? wake_up_new_task+0x77/0x91
[   37.474338]  [<b011ece7>] ? default_wake_function+0x0/0xd
[   37.474338]  [<b012a431>] sys_wait4+0x68/0x9f
[   37.474338]  [<b012a48f>] sys_waitpid+0x27/0x29
[   37.474338]  [<b0104d52>] syscall_call+0x7/0xb
[   37.474338]  [<b02f0000>] ? relay_hotcpu_callback+0x51/0xb1
[   37.474338]  =======================
[   37.474338] kthreadd      S 00000000     0     2      0
[   37.474338]        ef83bfc8 00000046 ef8b50a0 00000000 00000092 ef83bf80 00000000 00000000 
[   37.474338]        ee5f776c 00000000 b0421180 b0421180 b0421180 ef83a0a0 ef83a2fc b180b180 
[   37.474338]        00000000 ef83b000 ee564d00 00000000 00000ae7 00000000 ee5f6e1c ee5f6e20 
[   37.474338] Call Trace:
[   37.474338]  [<b011d295>] ? complete+0x43/0x4b
[   37.474338]  [<b0139450>] kthreadd+0x13a/0x13f
[   37.474338]  [<b0139316>] ? kthreadd+0x0/0x13f
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] migration/0   S 0102c262     0     3      2
[   37.474338]        ef83df98 00000046 ef83c120 0102c262 00000246 ef83df4c 00000000 ef83df4c 
[   37.474338]        066fb2fc 00000000 b0421180 b0421180 b0421180 ef83c120 ef83c37c b180b180 
[   37.474338]        00000000 ef83d000 b03ba200 00000000 00000000 00000000 00000000 b0421180 
[   37.474338] Call Trace:
[   37.474338]  [<b0122f2a>] ? migration_thread+0x0/0x210
[   37.474338]  [<b012304e>] migration_thread+0x124/0x210
[   37.474338]  [<b0122f2a>] ? migration_thread+0x0/0x210
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] ksoftirqd/0   R running      0     4      2
[   37.474338]        f4744940 00000008 ef841f14 b01424d9 f4650f99 00000008 00000000 01808638 
[   37.474338]        b18086c0 b1808638 b1808600 ef841f50 b013ca83 b1808600 b1808604 f4744940 
[   37.474338]        00000008 f465092e 00000008 f465092e 00000046 b1807120 00000000 00000246 
[   37.474338] Call Trace:
[   37.474338]  [<b01424d9>] ? tick_program_event+0x3f/0x61
[   37.474338]  [<b013ca83>] ? hrtimer_interrupt+0x13f/0x164
[   37.474338]  [<b012c055>] ? irq_exit+0x3f/0x79
[   37.474338]  [<b0113103>] ? smp_apic_timer_interrupt+0x5c/0x89
[   37.474338]  [<b012c055>] ? irq_exit+0x3f/0x79
[   37.474338]  [<b01057bc>] ? apic_timer_interrupt+0x28/0x30
[   37.474338]  [<b01079d9>] ? do_softirq+0x35/0x8c
[   37.474338]  [<b012c515>] ? ksoftirqd+0xad/0x17f
[   37.474338]  [<b012c468>] ? ksoftirqd+0x0/0x17f
[   37.474338]  [<b01392f4>] ? kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] ? kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] events/0      R running      0     5      2
[   37.474338]        ef843fa0 00000046 ef8112c0 ef843f44 b0136d0e 00000a75 00000000 00000a75 
[   37.474338]        60e9afad 00000008 b0421180 b0421180 b0421180 ef8420a0 ef8422fc b180b180 
[   37.474338]        00000000 ef843000 ee6e0880 b18089e0 3399ec88 00000002 b0421180 b0421180 
[   37.474338] Call Trace:
[   37.474338]  [<b0136d0e>] ? queue_delayed_work+0x40/0x48
[   37.474338]  [<b0139711>] ? prepare_to_wait+0x48/0x4d
[   37.474338]  [<b0136df5>] worker_thread+0xb9/0xd7
[   37.474338]  [<b01395a9>] ? autoremove_wake_function+0x0/0x38
[   37.474338]  [<b0136d3c>] ? worker_thread+0x0/0xd7
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] khelper       S b02f12e5     0     6      2
[   37.474338]        ef845fa0 00000046 ef845f3c b02f12e5 ef836d40 ef836d44 00000000 ef845f44 
[   37.474338]        2a9ba799 00000000 b0421180 b0421180 b0421180 ef844120 ef84437c b180b180 
[   37.474338]        00000000 ef845000 ee6e0880 ef822480 00000000 00000000 b0421180 b0421180 
[   37.474338] Call Trace:
[   37.474338]  [<b02f12e5>] ? preempt_schedule+0x40/0x55
[   37.474338]  [<b0139711>] ? prepare_to_wait+0x48/0x4d
[   37.474338]  [<b0136df5>] worker_thread+0xb9/0xd7
[   37.474338]  [<b01395a9>] ? autoremove_wake_function+0x0/0x38
[   37.474338]  [<b0136d3c>] ? worker_thread+0x0/0xd7
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] kblockd/0     S ef887f4c     0    35      2
[   37.474338]        ef887fa0 00000046 00000246 ef887f4c b01224ed ef887f4c 00000000 00000000 
[   37.474338]        0800f107 00000000 b0421180 b0421180 b0421180 ef886120 ef88637c b180b180 
[   37.474338]        00000000 ef887000 b03ba200 08006f94 00000c39 00000000 b0421180 b0421180 
[   37.474338] Call Trace:
[   37.474338]  [<b01224ed>] ? hrtick_set+0x99/0xf7
[   37.474338]  [<b0139711>] ? prepare_to_wait+0x48/0x4d
[   37.474338]  [<b0136df5>] worker_thread+0xb9/0xd7
[   37.474338]  [<b01395a9>] ? autoremove_wake_function+0x0/0x38
[   37.474338]  [<b0136d3c>] ? worker_thread+0x0/0xd7
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] kacpid        S ef88cf4c     0    37      2
[   37.474338]        ef88cfa0 00000046 00000246 ef88cf4c b01224ed ef88cf4c 00000000 00000000 
[   37.474338]        0801a506 00000000 b0421180 b0421180 b0421180 ef88b0a0 ef88b2fc b180b180 
[   37.474338]        00000000 ef88c000 b03ba200 08018266 00000000 00000000 b0421180 b0421180 
[   37.474338] Call Trace:
[   37.474338]  [<b01224ed>] ? hrtick_set+0x99/0xf7
[   37.474338]  [<b0139711>] ? prepare_to_wait+0x48/0x4d
[   37.474338]  [<b0136df5>] worker_thread+0xb9/0xd7
[   37.474338]  [<b01395a9>] ? autoremove_wake_function+0x0/0x38
[   37.474338]  [<b0136d3c>] ? worker_thread+0x0/0xd7
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] kacpi_notify  S ef88ff4c     0    38      2
[   37.474338]        ef88ffa0 00000046 00000246 ef88ff4c b01224ed ef88ff4c 00000000 00000000 
[   37.474338]        0886f6cd 00000000 b0421180 b0421180 b0421180 ef88e120 ef88e37c b180b180 
[   37.474338]        00000000 ef88f000 b03ba200 0801c44e 00000000 00000000 b0421180 b0421180 
[   37.474338] Call Trace:
[   37.474338]  [<b01224ed>] ? hrtick_set+0x99/0xf7
[   37.474338]  [<b0139711>] ? prepare_to_wait+0x48/0x4d
[   37.474338]  [<b0136df5>] worker_thread+0xb9/0xd7
[   37.474338]  [<b01395a9>] ? autoremove_wake_function+0x0/0x38
[   37.474338]  [<b0136d3c>] ? worker_thread+0x0/0xd7
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] cqueue/0      S ef8e0f4c     0   111      2
[   37.474338]        ef8e0fa0 00000046 00000246 ef8e0f4c b01224ed ef8e0f4c 00000000 00000000 
[   37.474338]        0c0b0eaf 00000000 b0421180 b0421180 b0421180 ef8bd0a0 ef8bd2fc b180b180 
[   37.474338]        00000000 ef8e0000 b03ba200 0c0abebc 00000cf2 00000000 b0421180 b0421180 
[   37.474338] Call Trace:
[   37.474338]  [<b01224ed>] ? hrtick_set+0x99/0xf7
[   37.474338]  [<b0139711>] ? prepare_to_wait+0x48/0x4d
[   37.474338]  [<b0136df5>] worker_thread+0xb9/0xd7
[   37.474338]  [<b01395a9>] ? autoremove_wake_function+0x0/0x38
[   37.474338]  [<b0136d3c>] ? worker_thread+0x0/0xd7
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] kseriod       S b011d321     0   115      2
[   37.474338]        ef8e4f8c 00000046 ef8e4f34 b011d321 00000000 00000000 00000000 ef88d440 
[   37.474338]        28fd3c39 00000000 b0421180 b0421180 b0421180 ef874120 ef87437c b180b180 
[   37.474338]        00000000 ef8e4000 b03ba200 00000000 00000000 00000000 b03cc440 ef88d43c 
[   37.474338] Call Trace:
[   37.474338]  [<b011d321>] ? __wake_up+0x3a/0x42
[   37.474338]  [<b0139711>] ? prepare_to_wait+0x48/0x4d
[   37.474338]  [<b0255c33>] serio_thread+0xc2/0x32f
[   37.474338]  [<b01395a9>] ? autoremove_wake_function+0x0/0x38
[   37.474338]  [<b0255b71>] ? serio_thread+0x0/0x32f
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] pdflush       S 00000000     0   148      2
[   37.474338]        ee52cfa4 00000046 b180b180 00000000 ee52c000 ee52cf68 00000000 000001fa 
[   37.474338]        22833768 00000000 b0421180 b0421180 b0421180 ef864120 ef86437c b180b180 
[   37.474338]        00000000 ee52c000 b03ba200 b012229c 00000000 00000000 ef864120 b180b180 
[   37.474338] Call Trace:
[   37.474338]  [<b012229c>] ? set_cpus_allowed+0x50/0xb8
[   37.474338]  [<b02f2c57>] ? _spin_unlock_irqrestore+0x1f/0x21
[   37.474338]  [<b011eb19>] ? set_user_nice+0xcf/0xdf
[   37.474338]  [<b0167dd1>] ? pdflush+0x0/0x1b4
[   37.474338]  [<b0167e82>] pdflush+0xb1/0x1b4
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] pdflush       S 00000286     0   149      2
[   37.474338]        ee52dfa4 00000046 b03c16e0 00000286 ee52df54 b0130184 00000000 00000000 
[   37.474338]        60e9f95c 00000008 b0421180 b0421180 b0421180 ef8620a0 ef8622fc b180b180 
[   37.474338]        00000000 ee52d000 ee6e0680 00000000 00000000 00000000 00000000 00000000 
[   37.474338] Call Trace:
[   37.474338]  [<b0130184>] ? __mod_timer+0xa0/0xaf
[   37.474338]  [<b0167dd1>] ? pdflush+0x0/0x1b4
[   37.474338]  [<b0167e82>] pdflush+0xb1/0x1b4
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] kswapd0       S 00000000     0   150      2
[   37.474338]        ee52ef2c 00000046 00000000 00000000 00000000 00000000 00000000 000004fa 
[   37.474338]        22918b1f 00000000 b0421180 b0421180 b0421180 ef85e020 ef85e27c b180b180 
[   37.474338]        00000000 ee52e000 b03ba200 b012229c 00000000 00000000 b1807b00 b180b180 
[   37.474338] Call Trace:
[   37.474338]  [<b012229c>] ? set_cpus_allowed+0x50/0xb8
[   37.474338]  [<b011ab2c>] ? __dequeue_entity+0x31/0x35
[   37.474338]  [<b0139711>] ? prepare_to_wait+0x48/0x4d
[   37.474338]  [<b016aefe>] ? kswapd+0x0/0x4a2
[   37.474338]  [<b016b38e>] kswapd+0x490/0x4a2
[   37.474338]  [<b02f0d71>] ? schedule+0x34e/0x82e
[   37.474338]  [<b01395a9>] ? autoremove_wake_function+0x0/0x38
[   37.474338]  [<b011d295>] ? complete+0x43/0x4b
[   37.474338]  [<b016aefe>] ? kswapd+0x0/0x4a2
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] aio/0         S ee530f4c     0   151      2
[   37.474338]        ee530fa0 00000046 00000246 ee530f4c b01224ed ee530f4c 00000000 00000000 
[   37.474338]        22bec65c 00000000 b0421180 b0421180 b0421180 ef85c120 ef85c37c b180b180 
[   37.474338]        00000000 ee530000 b03ba200 2291af16 00000000 00000000 b0421180 b0421180 
[   37.474338] Call Trace:
[   37.474338]  [<b01224ed>] ? hrtick_set+0x99/0xf7
[   37.474338]  [<b0139711>] ? prepare_to_wait+0x48/0x4d
[   37.474338]  [<b0136df5>] worker_thread+0xb9/0xd7
[   37.474338]  [<b01395a9>] ? autoremove_wake_function+0x0/0x38
[   37.474338]  [<b0136d3c>] ? worker_thread+0x0/0xd7
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] kpsmoused     S ee653f4c     0   378      2
[   37.474338]        ee653fa0 00000046 00000246 ee653f4c b01224ed ee653f4c 00000000 00000000 
[   37.474338]        26811a10 00000000 b0421180 b0421180 b0421180 ee6ba020 ee6ba27c b180b180 
[   37.474338]        00000000 ee653000 b03ba200 2680eca0 00000000 00000000 b0421180 b0421180 
[   37.474338] Call Trace:
[   37.474338]  [<b01224ed>] ? hrtick_set+0x99/0xf7
[   37.474338]  [<b0139711>] ? prepare_to_wait+0x48/0x4d
[   37.474338]  [<b0136df5>] worker_thread+0xb9/0xd7
[   37.474338]  [<b01395a9>] ? autoremove_wake_function+0x0/0x38
[   37.474338]  [<b0136d3c>] ? worker_thread+0x0/0xd7
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] kondemand/0   S ee5b0f4c     0   384      2
[   37.474338]        ee5b0fa0 00000046 00000246 ee5b0f4c b01224ed ee5b0f4c 00000000 00000000 
[   37.474338]        292b36fc 00000000 b0421180 b0421180 b0421180 ee5cc120 ee5cc37c b180b180 
[   37.474338]        00000000 ee5b0000 b03ba200 290d4c43 00000b94 00000000 b0421180 b0421180 
[   37.474338] Call Trace:
[   37.474338]  [<b01224ed>] ? hrtick_set+0x99/0xf7
[   37.474338]  [<b0139711>] ? prepare_to_wait+0x48/0x4d
[   37.474338]  [<b0136df5>] worker_thread+0xb9/0xd7
[   37.474338]  [<b01395a9>] ? autoremove_wake_function+0x0/0x38
[   37.474338]  [<b0136d3c>] ? worker_thread+0x0/0xd7
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] blogd         S 00000000     0   423      1
[   37.474338]        ee6d0b10 00000082 000004b3 00000000 b1807120 15b2b2c0 00000000 ef8420a0 
[   37.474338]        60e9cf9d 00000008 b0421180 b0421180 b0421180 ee5e60a0 ee5e62fc b180b180 
[   37.474338]        00000000 ee6d0000 ee6e0680 b0130059 339a08bf 00000002 ee6d0b20 00000286 
[   37.474338] Call Trace:
[   37.474338]  [<b0130059>] ? lock_timer_base+0x1f/0x40
[   37.474338]  [<b0130184>] ? __mod_timer+0xa0/0xaf
[   37.474338]  [<b02f14ba>] schedule_timeout+0x44/0xa4
[   37.474338]  [<b01397ad>] ? add_wait_queue+0x2f/0x36
[   37.474338]  [<b012fcda>] ? process_timeout+0x0/0xa
[   37.474338]  [<b02f14b5>] ? schedule_timeout+0x3f/0xa4
[   37.474338]  [<b018dce0>] do_select+0x4b6/0x53c
[   37.474338]  [<b018e25a>] ? __pollwait+0x0/0xcb
[   37.474338]  [<b011ece7>] ? default_wake_function+0x0/0xd
[   37.474338]  [<b011ece7>] ? default_wake_function+0x0/0xd
[   37.474338]  [<b011ece7>] ? default_wake_function+0x0/0xd
[   37.474338]  [<b01224d3>] ? hrtick_set+0x7f/0xf7
[   37.474338]  [<b02f0d71>] ? schedule+0x34e/0x82e
[   37.474338]  [<b020e60c>] ? cfb_fillrect+0x138/0x2bd
[   37.474338]  [<b013c088>] ? enqueue_hrtimer+0x75/0xf3
[   37.474338]  [<b0109fbc>] ? read_tsc+0x8/0xa
[   37.474338]  [<b013e472>] ? getnstimeofday+0x34/0xdf
[   37.474338]  [<b013c90f>] ? ktime_get_ts+0x44/0x49
[   37.474338]  [<b013c925>] ? ktime_get+0x11/0x30
[   37.474338]  [<b011b82b>] ? hrtick_start_fair+0x10d/0x144
[   37.474338]  [<b011b900>] ? enqueue_task_fair+0x52/0x56
[   37.474338]  [<b011a3f1>] ? enqueue_task+0x4c/0x58
[   37.474338]  [<b011eb76>] ? try_to_wake_up+0x4d/0x1be
[   37.474338]  [<b018df10>] core_sys_select+0x1aa/0x2bb
[   37.474338]  [<b013c6ed>] ? hrtimer_start+0xc7/0x13c
[   37.474338]  [<b01224d3>] ? hrtick_set+0x7f/0xf7
[   37.474338]  [<b01042b4>] ? do_notify_resume+0x55/0x79e
[   37.474338]  [<b0127ad4>] ? release_console_sem+0x1c4/0x1d4
[   37.474338]  [<b011d321>] ? __wake_up+0x3a/0x42
[   37.474338]  [<b0232d6a>] ? tty_ldisc_deref+0x55/0x6e
[   37.474338]  [<b018e3fc>] sys_select+0xd7/0x1a2
[   37.474338]  [<b0104d52>] syscall_call+0x7/0xb
[   37.474338]  =======================
[   37.474338] blogd         R running      0   424      1
[   37.474338]        ee6cbdf8 00000082 b18086c0 ee6cbda0 b01e99b7 b1808640 00000000 b180b5f4 
[   37.474338]        60e8dd8e 00000008 b0421180 b0421180 b0421180 ee5d70a0 ee5d72fc b180b180 
[   37.474338]        00000000 ee6cb000 ee6e0680 ee6cbdf8 375f44e1 00000003 ee6cbdec b041e600 
[   37.474338] Call Trace:
[   37.474338]  [<b01e99b7>] ? rb_insert_color+0x77/0xd8
[   37.474338]  [<b0143bfe>] futex_wait+0x285/0x2d3
[   37.474338]  [<b013c31c>] ? hrtimer_wakeup+0x0/0x1c
[   37.474338]  [<b0143b3d>] ? futex_wait+0x1c4/0x2d3
[   37.474338]  [<b011ece7>] ? default_wake_function+0x0/0xd
[   37.474338]  [<b0144c2d>] do_futex+0x20d/0xa5f
[   37.474338]  [<b0168667>] ? pagevec_lookup_tag+0x25/0x2e
[   37.474338]  [<b016158a>] ? wait_on_page_writeback_range+0x5b/0xf0
[   37.474338]  [<b0109fbc>] ? read_tsc+0x8/0xa
[   37.474338]  [<b013e472>] ? getnstimeofday+0x34/0xdf
[   37.474338]  [<b013c90f>] ? ktime_get_ts+0x44/0x49
[   37.474338]  [<b013c925>] ? ktime_get+0x11/0x30
[   37.474338]  [<b0145502>] sys_futex+0x83/0xe8
[   37.474338]  [<b01ec504>] ? copy_to_user+0x2a/0x36
[   37.474338]  [<b0104d52>] syscall_call+0x7/0xb
[   37.474338]  =======================
[   37.474338] ata/0         S ee7b3f8c     0   438      2
[   37.474338]        ee7b3fa0 00000046 00000002 ee7b3f8c ee7b3f80 ee7b3f44 00000000 002dae6f 
[   37.474338]        e3f3f21f 00000000 b0421180 b0421180 b0421180 ee6be120 ee6be37c b180b180 
[   37.474338]        00000000 ee7b3000 ee6e0a80 ef906480 00000000 00000000 b0421180 b0421180 
[   37.474338] Call Trace:
[   37.474338]  [<b0139711>] ? prepare_to_wait+0x48/0x4d
[   37.474338]  [<b0136df5>] worker_thread+0xb9/0xd7
[   37.474338]  [<b01395a9>] ? autoremove_wake_function+0x0/0x38
[   37.474338]  [<b0136d3c>] ? worker_thread+0x0/0xd7
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] ata_aux       S ee7b2f4c     0   439      2
[   37.474338]        ee7b2fa0 00000046 ffffffff ee7b2f4c b01224d3 00000000 00000000 00000000 
[   37.474338]        2fc09ed2 00000000 b0421180 b0421180 b0421180 ee5dd020 ee5dd27c b180b180 
[   37.474338]        00000000 ee7b2000 ee6e0280 2f81ef36 00000000 00000000 b0421180 b0421180 
[   37.474338] Call Trace:
[   37.474338]  [<b01224d3>] ? hrtick_set+0x7f/0xf7
[   37.474338]  [<b0139711>] ? prepare_to_wait+0x48/0x4d
[   37.474338]  [<b0136df5>] worker_thread+0xb9/0xd7
[   37.474338]  [<b01395a9>] ? autoremove_wake_function+0x0/0x38
[   37.474338]  [<b0136d3c>] ? worker_thread+0x0/0xd7
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] scsi_eh_0     S ef906520     0   445      2
[   37.474338]        ee585f64 00000046 ef906524 ef906520 00000000 00000092 00000000 b011d321 
[   37.474338]        e4331293 00000000 b0421180 b0421180 b0421180 ee5e4020 ee5e427c b180b180 
[   37.474338]        00000000 ee585000 ee6e0480 ee702008 00108a29 00000000 f084c295 ee702000 
[   37.474338] Call Trace:
[   37.474338]  [<b011d321>] ? __wake_up+0x3a/0x42
[   37.474338]  [<f084c295>] ? __scsi_iterate_devices+0x5d/0x6b [scsi_mod]
[   37.474338]  [<f0850303>] ? scsi_error_handler+0x0/0x4eb [scsi_mod]
[   37.474338]  [<f0850303>] ? scsi_error_handler+0x0/0x4eb [scsi_mod]
[   37.474338]  [<f085033a>] scsi_error_handler+0x37/0x4eb [scsi_mod]
[   37.474338]  [<b011d295>] ? complete+0x43/0x4b
[   37.474338]  [<f0850303>] ? scsi_error_handler+0x0/0x4eb [scsi_mod]
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] scsi_eh_1     S ee622520     0   446      2
[   37.474338]        ee5acf64 00000046 ee622524 ee622520 00000000 00000092 00000000 b011d321 
[   37.474338]        e4333e8f 00000000 b0421180 b0421180 b0421180 ee5d10a0 ee5d12fc b180b180 
[   37.474338]        00000000 ee5ac000 ee6e0480 ee702808 00000000 00000000 f084c295 ee702800 
[   37.474338] Call Trace:
[   37.474338]  [<b011d321>] ? __wake_up+0x3a/0x42
[   37.474338]  [<f084c295>] ? __scsi_iterate_devices+0x5d/0x6b [scsi_mod]
[   37.474338]  [<f0850303>] ? scsi_error_handler+0x0/0x4eb [scsi_mod]
[   37.474338]  [<f0850303>] ? scsi_error_handler+0x0/0x4eb [scsi_mod]
[   37.474338]  [<f085033a>] scsi_error_handler+0x37/0x4eb [scsi_mod]
[   37.474338]  [<b011d295>] ? complete+0x43/0x4b
[   37.474338]  [<f0850303>] ? scsi_error_handler+0x0/0x4eb [scsi_mod]
[   37.474338]  [<b01392f4>] kthread+0x37/0x59
[   37.474338]  [<b01392bd>] ? kthread+0x0/0x59
[   37.474338]  [<b010593f>] kernel_thread_helper+0x7/0x18
[   37.474338]  =======================
[   37.474338] udevd         S 00000000     0   461      1
[   37.474338]        ee5d8b10 00000082 00000000 00000000 00000000 00000000 00000000 ee5d8ab4 
[   37.474338]        93a637c5 00000001 b0421180 b0421180 b0421180 ee6c20a0 ee6c22fc b180b180 
[   37.474338]        00000000 ee5d8000 ee6e0480 b1807980 00000000 00000000 000f41a9 00000000 
[   37.474338] Call Trace:
[   37.474338]  [<b011b920>] ? __update_rq_clock+0x1c/0x157
[   37.474338]  [<b02f14e0>] schedule_timeout+0x6a/0xa4
[   37.474338]  [<b01397ad>] ? add_wait_queue+0x2f/0x36
[   37.474338]  [<b018e2c1>] ? __pollwait+0x67/0xcb
[   37.474338]  [<b0186ef4>] ? pipe_poll+0x29/0x8f
[   37.474338]  [<b018dce0>] do_select+0x4b6/0x53c
[   37.474338]  [<b013fdbc>] ? clocksource_get_next+0x3d/0x44
[   37.474338]  [<b018e25a>] ? __pollwait+0x0/0xcb
[   37.474338]  [<b011ece7>] ? default_wake_function+0x0/0xd
[   37.474338]  [<b011ece7>] ? default_wake_function+0x0/0xd
[   37.474338]  [<b011ece7>] ? default_wake_function+0x0/0xd
[   37.474338]  [<b011ece7>] ? default_wake_function+0x0/0xd
[   37.474338]  [<b01414ad>] ? clockevents_program_event+0x93/0x108
[   37.474338]  [<b01424d9>] ? tick_program_event+0x3f/0x61
[   37.474338]  [<b01eab55>] ? number+0x2a3/0x2b5
[   37.474338]  [<b01057bc>] ? apic_timer_interrupt+0x28/0x30
[   37.474338]  [<b019007b>] ? fcntl_getlk64+0x4e/0x159
[   37.474338]  [<b01eb3a7>] ? vsnprintf+0x2e8/0x5ea
[   37.474338]  [<b0119234>] ? kmap_atomic_prot+0x47/0xa8
[   37.474338]  [<b0165eb1>] ? get_page_from_freelist+0x25f/0x443
[   37.474338]  [<b016625f>] ? __alloc_pages+0x57/0x32d
[   37.474338]  [<b016c409>] ? __inc_zone_page_state+0x18/0x1a
[   37.474338]  [<b018df10>] core_sys_select+0x1aa/0x2bb
[   37.474338]  [<b0165c04>] ? free_hot_page+0xa/0xc
[   37.474338]  [<b0168bf3>] ? put_page+0x2d/0xac
[   37.474338]  [<b0176340>] ? free_page_and_swap_cache+0x1e/0x3e
[   37.474338]  [<b016e44a>] ? unmap_vmas+0x317/0x54b
[   37.474338]  [<b0117410>] ? pgd_dtor+0x0/0x4a
[   37.474338]  [<b011740e>] ? check_pgt_cache+0x1e/0x20
[   37.474338]  [<b01711bf>] ? unmap_region+0xdc/0x12f
[   37.474338]  [<b018e35e>] sys_select+0x39/0x1a2
[   37.474338]  [<b0104d52>] syscall_call+0x7/0xb
[   37.474338]  =======================
[   37.474338] udevsettle    R running      0   465      1
[   37.474338]        ee524f1c 00000082 ee524ed4 00000000 00010542 b1808640 00000000 ee6cbe14 
[   37.474338]        60e8f831 00000008 b0421180 b0421180 b0421180 ee5ce020 ee5ce27c b180b180 
[   37.474338]        00000000 ee524000 ee6e0880 ee524f1c 33bd800d 00000003 00000008 b041e600 
[   37.474338] Call Trace:
[   37.474338]  [<b02f1a50>] do_nanosleep+0x70/0x9a
[   37.474338]  [<b013c7ae>] hrtimer_nanosleep+0x4c/0xaf
[   37.474338]  [<b013c31c>] ? hrtimer_wakeup+0x0/0x1c
[   37.474338]  [<b02f1a3d>] ? do_nanosleep+0x5d/0x9a
[   37.474338]  [<b013c868>] sys_nanosleep+0x57/0x5b
[   37.474338]  [<b0104d52>] syscall_call+0x7/0xb
[   37.474338]  [<b02f0000>] ? relay_hotcpu_callback+0x51/0xb1
[   37.474338]  =======================
[   37.474338] udevd         S 00000000     0   873    461
[   37.474338]        e7c7eb10 00000082 00000000 00000000 00000000 00000000 00000000 00000000 
[   37.474338]        9385214a 00000001 b0421180 b0421180 b0421180 ef8d40a0 ef8d42fc b180b180 
[   37.474338]        00000000 e7c7e000 ee6e0280 00000000 00000000 00000000 00000000 00000000 
[   37.474338] Call Trace:
[   37.474338]  [<b02f14e0>] schedule_timeout+0x6a/0xa4
[   37.474338]  [<b01397ad>] ? add_wait_queue+0x2f/0x36
[   37.474338]  [<b018e2c1>] ? __pollwait+0x67/0xcb
[   37.474338]  [<b0186ef4>] ? pipe_poll+0x29/0x8f
[   37.474338]  [<b018dce0>] do_select+0x4b6/0x53c
[   37.474338]  [<b018e25a>] ? __pollwait+0x0/0xcb
[   37.474338]  [<b011ece7>] ? default_wake_function+0x0/0xd
[   37.474338]  [<b01920af>] ? __d_lookup+0xba/0x124
[   37.474338]  [<b01920af>] ? __d_lookup+0xba/0x124
[   37.474338]  [<b0119234>] ? kmap_atomic_prot+0x47/0xa8
[   37.474338]  [<b0165eb1>] ? get_page_from_freelist+0x25f/0x443
[   37.474338]  [<b018df10>] core_sys_select+0x1aa/0x2bb
[   37.474338]  [<b013c088>] ? enqueue_hrtimer+0x75/0xf3
[   37.474338]  [<b013c6ed>] ? hrtimer_start+0xc7/0x13c
[   37.474338]  [<b01224d3>] ? hrtick_set+0x7f/0xf7
[   37.474338]  [<b02f0d71>] ? schedule+0x34e/0x82e
[   37.474338]  [<b016de52>] ? do_wp_page+0x2a0/0x3e5
[   37.474338]  [<b016f0e7>] ? handle_mm_fault+0x442/0x5d4
[   37.474338]  [<b02f12e5>] ? preempt_schedule+0x40/0x55
[   37.474338]  [<b018e35e>] sys_select+0x39/0x1a2
[   37.474338]  [<b017fc6f>] ? filp_close+0x43/0x69
[   37.474338]  [<b01ec504>] ? copy_to_user+0x2a/0x36
[   37.474338]  [<b0104d52>] syscall_call+0x7/0xb
[   37.474338]  =======================
[   37.474338] udevd         S 00000000     0   876    461
[   37.474338]        ee780b10 00000086 00000000 00000000 00000000 00000000 00000000 00000000 
[   37.474338]        93a2c2db 00000001 b0421180 b0421180 b0421180 ef8a1120 ef8a137c b180b180 
[   37.474338]        00000000 ee780000 ee564100 00000000 00000000 00000000 00000000 00000000 
[   37.474338] Call Trace:
[   37.474338]  [<b02f14e0>] schedule_timeout+0x6a/0xa4
[   37.474338]  [<b01397ad>] ? add_wait_queue+0x2f/0x36
[   37.474338]  [<b018e2c1>] ? __pollwait+0x67/0xcb
[   37.474338]  [<b0186ef4>] ? pipe_poll+0x29/0x8f
[   37.474338]  [<b018dce0>] do_select+0x4b6/0x53c
[   37.474338]  [<b018e25a>] ? __pollwait+0x0/0xcb
[   37.474338]  [<b011ece7>] ? default_wake_function+0x0/0xd
[   37.474338]  [<b011a8a0>] ? update_curr+0x12f/0x136
[   37.474338]  [<b012381e>] ? task_tick_fair+0x59/0x86
[   37.474338]  [<b01227b3>] ? scheduler_tick+0x268/0x3cc
[   37.474338]  [<b0109fbc>] ? read_tsc+0x8/0xa
[   37.474338]  [<b013e472>] ? getnstimeofday+0x34/0xdf
[   37.474338]  [<b01414ad>] ? clockevents_program_event+0x93/0x108
[   37.474338]  [<b01424d9>] ? tick_program_event+0x3f/0x61
[   37.474338]  [<b013ca83>] ? hrtimer_interrupt+0x13f/0x164
[   37.474338]  [<b012c055>] ? irq_exit+0x3f/0x79
[   37.474338]  [<b0113103>] ? smp_apic_timer_interrupt+0x5c/0x89
[   37.474338]  [<b01920af>] ? __d_lookup+0xba/0x124
[   37.474338]  [<b01920af>] ? __d_lookup+0xba/0x124
[   37.474338]  [<b0119234>] ? kmap_atomic_prot+0x47/0xa8
[   37.474338]  [<b0165eb1>] ? get_page_from_freelist+0x25f/0x443
[   37.474338]  [<b018df10>] core_sys_select+0x1aa/0x2bb
[   37.474338]  [<b013c088>] ? enqueue_hrtimer+0x75/0xf3
[   37.474338]  [<b013c6ed>] ? hrtimer_start+0xc7/0x13c
[   37.474338]  [<b01224d3>] ? hrtick_set+0x7f/0xf7
[   37.474338]  [<b02f0d71>] ? schedule+0x34e/0x82e
[   37.474338]  [<b016de52>] ? do_wp_page+0x2a0/0x3e5
[   37.474338]  [<b016f0e7>] ? handle_mm_fault+0x442/0x5d4
[   37.474338]  [<b02f12e5>] ? preempt_schedule+0x40/0x55
[   37.474338]  [<b018e35e>] sys_select+0x39/0x1a2
[   37.474338]  [<b017fc6f>] ? filp_close+0x43/0x69
[   37.474338]  [<b01ec504>] ? copy_to_user+0x2a/0x36
[   37.474338]  [<b0104d52>] syscall_call+0x7/0xb
[   37.474338]  =======================
[   37.474338] scsi_id       D 00000000     0   878    873
[   37.474338]        ee60bb7c 00000086 00000046 00000000 00000000 ef904000 00000000 ee66d910 
[   37.474338]        93796336 00000001 b0421180 b0421180 b0421180 ee5d3120 ee5d337c b180b180 
[   37.474338]        00000000 ee60b000 ee564700 ee5c2800 0000065a 00000000 ee60bb5c b024e1b8 
[   37.474338] Call Trace:
[   37.474338]  [<b024e1b8>] ? put_device+0xf/0x11
[   37.474338]  [<f0852878>] ? scsi_request_fn+0x218/0x345 [scsi_mod]
[   37.474338]  [<b02f14e0>] schedule_timeout+0x6a/0xa4
[   37.474338]  [<b01d8b08>] ? elv_insert+0xf3/0x20b
[   37.474338]  [<b01302da>] ? mod_timer+0x26/0x3d
[   37.474338]  [<b01db15b>] ? blk_plug_device+0x42/0x9a
[   37.474338]  [<b02f08e5>] wait_for_common+0x74/0x12e
[   37.474338]  [<b011ece7>] ? default_wake_function+0x0/0xd
[   37.474338]  [<b02f0a21>] wait_for_completion+0x12/0x14
[   37.474338]  [<b01dd237>] blk_execute_rq+0x5c/0x9c
[   37.474338]  [<b01dd277>] ? blk_end_sync_rq+0x0/0x29
[   37.474338]  [<b01a3fe2>] ? bio_add_pc_page+0x24/0x2a
[   37.474338]  [<b01d9672>] ? blk_rq_bio_prep+0x9e/0xb2
[   37.474338]  [<b01dceef>] ? blk_rq_append_bio+0x17/0x49
[   37.474338]  [<b01dd022>] ? blk_rq_map_user+0x101/0x1b4
[   37.474338]  [<b01e01f6>] sg_io+0x18c/0x2e1
[   37.474338]  [<b0165eb1>] ? get_page_from_freelist+0x25f/0x443
[   37.474338]  [<b01e05df>] scsi_cmd_ioctl+0x294/0x3d5
[   37.474338]  [<b01920af>] ? __d_lookup+0xba/0x124
[   37.474338]  [<b0188770>] ? do_lookup+0x5a/0x162
[   37.474338]  [<f08799b5>] sd_ioctl+0x82/0xc9 [sd_mod]
[   37.474338]  [<b01ddf93>] blkdev_driver_ioctl+0x55/0x5e
[   37.474338]  [<b01de1bf>] blkdev_ioctl+0x223/0x814
[   37.474338]  [<b01e7574>] ? kobject_get+0x12/0x17
[   37.474338]  [<b0160fc3>] ? find_lock_page+0x72/0x8d
[   37.474338]  [<b0163210>] ? filemap_fault+0x240/0x449
[   37.474338]  [<b01395a5>] ? wake_up_bit+0x17/0x1b
[   37.474338]  [<b0160e75>] ? unlock_page+0x25/0x28
[   37.474338]  [<b016d9b5>] ? __do_fault+0x17a/0x377
[   37.474338]  [<b01a57b6>] ? blkdev_open+0x28/0x58
[   37.474338]  [<b016eda8>] ? handle_mm_fault+0x103/0x5d4
[   37.474338]  [<b01a4c39>] block_ioctl+0x1b/0x21
[   37.474338]  [<b01a4c1e>] ? block_ioctl+0x0/0x21
[   37.474338]  [<b018cc12>] vfs_ioctl+0x22/0x71
[   37.474338]  [<b018cea9>] do_vfs_ioctl+0x248/0x290
[   37.474338]  [<b0117ba2>] ? do_page_fault+0x13d/0x5fb
[   37.474338]  [<b0189bfc>] ? putname+0x25/0x30
[   37.474338]  [<b01800e0>] ? do_sys_open+0xb1/0xc7
[   37.474338]  [<b018cf43>] sys_ioctl+0x52/0x63
[   37.474338]  [<b0104d52>] syscall_call+0x7/0xb
[   37.474338]  =======================
[   37.474338] scsi_id       D ee621bd4     0   879    876
[   37.474338]        ee636b7c 00000086 ee621bac ee621bd4 00000000 f084c4f9 00000000 ee66d0c8 
[   37.474338]        9394eaa1 00000001 b0421180 b0421180 b0421180 ef888020 ef88827c b180b180 
[   37.474338]        00000000 ee636000 ee564300 ee6e8c00 00000000 00000000 ee636b5c b024e1b8 
[   37.474338] Call Trace:
[   37.474338]  [<f084c4f9>] ? scsi_done+0x0/0x19 [scsi_mod]
[   37.474338]  [<b024e1b8>] ? put_device+0xf/0x11
[   37.474338]  [<f0852878>] ? scsi_request_fn+0x218/0x345 [scsi_mod]
[   37.474338]  [<b02f14e0>] schedule_timeout+0x6a/0xa4
[   37.474338]  [<b01d8b08>] ? elv_insert+0xf3/0x20b
[   37.474338]  [<b01302da>] ? mod_timer+0x26/0x3d
[   37.474338]  [<b01db15b>] ? blk_plug_device+0x42/0x9a
[   37.474338]  [<b02f08e5>] wait_for_common+0x74/0x12e
[   37.474338]  [<b011ece7>] ? default_wake_function+0x0/0xd
[   37.474338]  [<b02f0a21>] wait_for_completion+0x12/0x14
[   37.474338]  [<b01dd237>] blk_execute_rq+0x5c/0x9c
[   37.474338]  [<b01dd277>] ? blk_end_sync_rq+0x0/0x29
[   37.474338]  [<b01a3fe2>] ? bio_add_pc_page+0x24/0x2a
[   37.474338]  [<b01d9672>] ? blk_rq_bio_prep+0x9e/0xb2
[   37.474338]  [<b01dceef>] ? blk_rq_append_bio+0x17/0x49
[   37.474338]  [<b01dd022>] ? blk_rq_map_user+0x101/0x1b4
[   37.474338]  [<b01e01f6>] sg_io+0x18c/0x2e1
[   37.474338]  [<b0165eb1>] ? get_page_from_freelist+0x25f/0x443
[   37.474338]  [<b01e05df>] scsi_cmd_ioctl+0x294/0x3d5
[   37.474338]  [<b01920af>] ? __d_lookup+0xba/0x124
[   37.474338]  [<b0188770>] ? do_lookup+0x5a/0x162
[   37.474338]  [<f08799b5>] sd_ioctl+0x82/0xc9 [sd_mod]
[   37.474338]  [<b01ddf93>] blkdev_driver_ioctl+0x55/0x5e
[   37.474338]  [<b01de1bf>] blkdev_ioctl+0x223/0x814
[   37.474338]  [<b0168bbe>] ? activate_page+0xb1/0xb9
[   37.474338]  [<b0168cce>] ? mark_page_accessed+0x27/0x2e
[   37.474338]  [<b0163210>] ? filemap_fault+0x240/0x449
[   37.474338]  [<b01395a5>] ? wake_up_bit+0x17/0x1b
[   37.474338]  [<b0160e75>] ? unlock_page+0x25/0x28
[   37.474338]  [<b016d9b5>] ? __do_fault+0x17a/0x377
[   37.474338]  [<b01a57b6>] ? blkdev_open+0x28/0x58
[   37.474338]  [<b016eda8>] ? handle_mm_fault+0x103/0x5d4
[   37.474338]  [<b01a4c39>] block_ioctl+0x1b/0x21
[   37.474338]  [<b01a4c1e>] ? block_ioctl+0x0/0x21
[   37.474338]  [<b018cc12>] vfs_ioctl+0x22/0x71
[   37.474338]  [<b018cea9>] do_vfs_ioctl+0x248/0x290
[   37.474338]  [<b0117ba2>] ? do_page_fault+0x13d/0x5fb
[   37.474338]  [<b0189bfc>] ? putname+0x25/0x30
[   37.474338]  [<b01800e0>] ? do_sys_open+0xb1/0xc7
[   37.474338]  [<b018cf43>] sys_ioctl+0x52/0x63
[   37.474338]  [<b0104d52>] syscall_call+0x7/0xb
[   37.474338]  =======================
[   37.474338] Sched Debug Version: v0.07, 2.6.25-rc2-smp #14
[   37.474338] now at 44900.194289 msecs
[   37.474338]   .sysctl_sched_latency                    : 20.000000
[   37.474338]   .sysctl_sched_min_granularity            : 4.000000
[   37.474338]   .sysctl_sched_wakeup_granularity         : 10.000000
[   37.474338]   .sysctl_sched_batch_wakeup_granularity   : 10.000000
[   37.474338]   .sysctl_sched_child_runs_first           : 0.000001
[   37.474338]   .sysctl_sched_features                   : 39
[   37.474338] 
[   37.474338] cpu#0, 2992.603 MHz
[   37.474338]   .nr_running                    : 4
[   37.474338]   .load                          : 2048
[   37.474338]   .nr_switches                   : 3363
[   37.474338]   .nr_load_updates               : 34557
[   37.474338]   .nr_uninterruptible            : 2
[   37.474338]   .jiffies                       : 4294705811
[   37.474338]   .next_balance                  : 4294.705968
[   37.474338]   .curr->pid                     : 4
[   37.474338]   .clock                         : 37474.338672
[   37.474338]   .idle_clock                    : 3065.714769
[   37.474338]   .prev_clock_raw                : 78772.978492
[   37.474338]   .clock_warps                   : 0
[   37.474338]   .clock_overflows               : 3996
[   37.474338]   .clock_underflows              : 31781
[   37.474338]   .clock_deep_idle_events        : 1
[   37.474338]   .clock_max_delta               : 0.999848
[   37.474338]   .cpu_load[0]                   : 2048
[   37.474338]   .cpu_load[1]                   : 2048
[   37.474338]   .cpu_load[2]                   : 2048
[   37.474338]   .cpu_load[3]                   : 2048
[   37.474338]   .cpu_load[4]                   : 2048
[   37.474338] 
[   37.474338] cfs_rq
[   37.474338]   .exec_clock                    : 34293.783916
[   37.474338]   .MIN_vruntime                  : 0.000001
[   37.474338]   .min_vruntime                  : 17146.893105
[   37.474338]   .max_vruntime                  : 0.000001
[   37.474338]   .spread                        : 0.000000
[   37.474338]   .spread0                       : 0.000000
[   37.474338]   .nr_running                    : 1
[   37.474338]   .load                          : 2048
[   37.474338]   .bkl_count                     : 405
[   37.474338]   .nr_spread_over                : 0
[   37.474338] 
[   37.474338] cfs_rq
[   37.474338]   .exec_clock                    : 34293.783916
[   37.474338]   .MIN_vruntime                  : 13830.833996
[   37.474338]   .min_vruntime                  : 17146.893105
[   37.474338]   .max_vruntime                  : 13830.833996
[   37.474338]   .spread                        : 0.000000
[   37.474338]   .spread0                       : 0.000000
[   37.474338]   .nr_running                    : 4
[   37.474338]   .load                          : 8290
[   37.474338]   .bkl_count                     : 405
[   37.474338]   .nr_spread_over                : 6
[   37.474338] 
[   37.474338] runnable tasks:
[   37.474338]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[   37.474338] ----------------------------------------------------------------------------------------------------------
[   37.474338] R    ksoftirqd/0     4     14329.115724        37   115     14329.115724     33248.417353      4113.418770
[   37.474338]         events/0     5     13830.833996        35   115     13830.833996         0.284125      4265.748410
[   37.474338]            blogd   424     13830.833996       135   120     13830.833996         0.460905      1680.558420
[   37.474338]       udevsettle   465     13830.833996        17   120     13830.833996         0.838894       643.594622
[   37.474338] 





--=-G3RFvOt6cbBQAAzh0xSR
Content-Disposition: attachment; filename=config.gz
Content-Type: application/x-gzip; name=config.gz
Content-Transfer-Encoding: base64

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
+Q84nJnsas0AAO==


--=-G3RFvOt6cbBQAAzh0xSR--

