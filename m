Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbYC3QWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbYC3QWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 12:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYC3QWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 12:22:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:34606 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYC3QWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 12:22:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ge/9sOlUvvfUjUOOQaeo6zVkKvvJJJV6X5L4phZ8hg30Xwnvdoivm0mlPakFxIhpF7swdMBA44b61MdpmbqxbvpK/QOBWMsz6GupT2C4GShE9evnW7fq1dg8MiFUcs2Ytj7gZCg0BjvZJluAHwEtbt8p/Vq9KIJgBE2WvOVsflY=
Date: Sun, 30 Mar 2008 18:20:49 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: 2.6.25-rc regression: bttv: oops on radio access (bisected)
Message-ID: <20080330162006.GA6048@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
2.6.25-rc7 kernel oopses on exec of "radio -c /dev/radio0".
I bisected it down to:

402aa76aa5e57801b4db5ccf8c7beea9f580bb1b is first bad commit
commit 402aa76aa5e57801b4db5ccf8c7beea9f580bb1b
Author: Douglas Schilling Landgraf <dougsland@gmail.com>
Date:   Thu Dec 27 22:20:58 2007 -0300

    V4L/DVB (6911): Converted bttv to use video_ioctl2

    Signed-off-by: Douglas Schilling Landgraf <dougsland@gmail.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

:040000 040000 70d26579bba3af3251cde3cde91a1864b06b4948 cc7b2b3c4fc8e498ed3d0adbfcad88c405a4caae M      drivers

Full dmesg with oops below:

[    0.000000] Linux version 2.6.25-rc7 (marcin@joi) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #196 PREEMPT Sat Mar 29 09:55:25 CET 2008
[    0.000000] Command line: root=/dev/sda5 video=vesafb vga=794 nmi_watchdog=2
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ffb0000 (usable)
[    0.000000]  BIOS-e820: 000000003ffb0000 - 000000003ffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ffc0000 - 000000003fff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff0000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 262064) 1 entries of 256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FA810, 0021 (r2 ACPIAM)
[    0.000000] ACPI: XSDT 3FFB0100, 003C (r1 A M I  OEMXSDT  10000427 MSFT       97)
[    0.000000] ACPI: FACP 3FFB0290, 00F4 (r3 A M I  OEMFACP  10000427 MSFT       97)
[    0.000000] ACPI: DSDT 3FFB03E0, 38A1 (r1  A0036 A0036001        1 MSFT  100000D)
[    0.000000] ACPI: FACS 3FFC0000, 0040
[    0.000000] ACPI: APIC 3FFB0390, 004A (r1 A M I  OEMAPIC  10000427 MSFT       97)
[    0.000000] ACPI: OEMB 3FFC0040, 003F (r1 A M I  OEMBIOS  10000427 MSFT       97)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 262064) 1 entries of 256 used
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [200000-ad9cc7] TEXT DATA BSS
[    0.000000] early res: 2 [9fc00-a0bff] EBDA
[    0.000000] early res: 3 [8000-afff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   262064
[    0.000000] On node 0 totalpages: 261967
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2272 pages reserved
[    0.000000]   DMA zone: 1671 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3526 pages used for memmap
[    0.000000]   DMA32 zone: 254442 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bf780000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 256113
[    0.000000] Kernel command line: root=/dev/sda5 video=vesafb vga=794 nmi_watchdog=2
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000001] time.c: Detected 2002.560 MHz processor.
[    0.000030] Console: colour dummy device 80x25
[    0.000037] console [tty0] enabled
[    0.000643] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000651] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.000656] ... MAX_LOCK_DEPTH:          48
[    0.000661] ... MAX_LOCKDEP_KEYS:        2048
[    0.000666] ... CLASSHASH_SIZE:           1024
[    0.000670] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.000675] ... MAX_LOCKDEP_CHAINS:      16384
[    0.000680] ... CHAINHASH_SIZE:          8192
[    0.000685]  memory used by lock dependency info: 1648 kB
[    0.000691]  per task-struct memory footprint: 2688 bytes
[    0.000696] ------------------------
[    0.000701] | Locking API testsuite:
(...)
[    0.000999] -------------------------------------------------------
[    0.000999] Good, all 218 testcases passed! |
[    0.000999] ---------------------------------
[    0.000999] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000999] Checking aperture...
[    0.000999] Node 0: aperture @ e8000000 size 64 MB
[    0.000999] Memory: 1022024k/1048256k available (2959k kernel code, 25120k reserved, 1560k data, 240k init)
[    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
[    0.060994] Calibrating delay using timer specific routine.. 4009.09 BogoMIPS (lpj=2004549)
[    0.061089] Mount-cache hash table entries: 256
[    0.061655] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.061665] CPU: L2 Cache: 512K (64 bytes/line)
[    0.061677] CPU: AMD Athlon(tm) 64 Processor 3200+ stepping 00
[    0.061697] ACPI: Core revision 20070126
[    0.067079] Parsing all Control Methods:
[    0.067157] Table [DSDT](id 0001) - 543 Objects with 51 Devices 146 Methods 25 Regions
[    0.067168]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
[    0.067995] evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
[    0.078567] Using local APIC timer interrupts.
[    0.078990] APIC timer calibration result 12515991
[    0.078991] Detected 12.515 MHz APIC timer.
[    0.079013] Testing NMI watchdog ... OK.
[    0.099488] net_namespace: 968 bytes
[    0.099822] NET: Registered protocol family 16
[    0.100126] No dock devices found.
[    0.100324] ACPI: bus type pci registered
[    0.100490] PCI: Using configuration type 1
[    0.103104] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 0F [_GPE] 2 regs on int 0x9
[    0.105357] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 7 Wake, Enabled 0 Runtime GPEs in this block
[    0.105372] ACPI: EC: Look up EC in DSDT
[    0.108175] Completing Region/Field/Buffer/Package initialization:......................................................................................................................
[    0.111286] Initialized 21/25 Regions 44/44 Fields 41/41 Buffers 12/14 Packages (552 nodes)
[    0.111298] Initializing Device/Processor/Thermal objects by executing _INI methods:
[    0.111334] Executed 0 _INI methods requiring 0 _STA executions (examined 54 objects)
[    0.111371] ACPI: Interpreter enabled
[    0.111377] ACPI: (supports S0 S1 S3 S5)
[    0.111412] ACPI: Using IOAPIC for interrupt routing
[    0.120343] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.121690] pci 0000:00:11.0: Enabled onboard AC97/MC97 devices
[    0.122114] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.135002] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 14 15)
[    0.135156] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 11 14 15)
[    0.135288] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 7 10 11 14 15)
[    0.135419] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
[    0.135553] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
[    0.135687] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
[    0.135835] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
[    0.135972] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
[    0.136212] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.136275] pnp: PnP ACPI init
[    0.136301] ACPI: bus type pnp registered
[    0.140341] pnp: PnP ACPI: found 10 devices
[    0.140351] ACPI: ACPI bus type pnp unregistered
[    0.140662] SCSI subsystem initialized
[    0.140724] libata version 3.00 loaded.
[    0.141240] PCI: Using ACPI for IRQ routing
[    0.141248] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.141265] PCI: Cannot allocate resource region 0 of device 0000:00:00.0
[    0.145007] DMAR:parse DMAR table failure.
[    0.145007] agpgart: Detected AGP bridge 0
[    0.147237] agpgart: AGP aperture is 64M @ 0xe8000000
[    0.147460] ACPI: RTC can wake from S4
[    0.151025] system 00:06: ioport range 0x680-0x6ff has been reserved
[    0.151025] system 00:06: ioport range 0x290-0x297 has been reserved
[    0.151025] system 00:07: ioport range 0x3e1-0x3e7 has been reserved
[    0.151025] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.151025] system 00:07: ioport range 0x800-0x87f has been reserved
[    0.151025] system 00:07: ioport range 0x400-0x41f has been reserved
[    0.151025] system 00:08: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.151025] system 00:08: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.151025] system 00:08: iomem range 0xfff80000-0xffffffff could not be reserved
[    0.151025] system 00:09: iomem range 0x0-0x9ffff could not be reserved
[    0.151025] system 00:09: iomem range 0xc0000-0xdffff has been reserved
[    0.151025] system 00:09: iomem range 0xe0000-0xfffff could not be reserved
[    0.151025] system 00:09: iomem range 0x100000-0x3ffeffff could not be reserved
[    0.151025] system 00:09: iomem range 0x0-0x0 could not be reserved
[    0.151077] PCI: Bridge: 0000:00:01.0
[    0.151083]   IO window: disabled.
[    0.151091]   MEM window: 0xfaf00000-0xfbffffff
[    0.151098]   PREFETCH window: 0x00000000f0000000-0x00000000f9ffffff
[    0.151128] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.151164] NET: Registered protocol family 2
[    0.162048] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.162048] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    0.163303] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    0.168262] TCP: Hash tables configured (established 131072 bind 65536)
[    0.168300] TCP reno registered
[    0.173278] Initializing RT-Tester: OK
[    0.173485] Total HugeTLB memory allocated, 0
[    0.174336] io scheduler noop registered
[    0.174354] io scheduler cfq registered (default)
[    0.174372] PCI: VIA PCI bridge detected. Disabling DAC.
[    0.174494] pci 0000:01:00.0: Boot video device
[    0.174713] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.175416] nvidiafb: Device ID: 10de0322 
[    0.180047] nvidiafb: CRTC0 analog found
[    0.184054] nvidiafb: CRTC1 analog not found
[    0.398031] nvidiafb: EDID found from BUS1
[    0.473816] i2c-adapter i2c-1: unable to read EDID block.
[    0.592798] i2c-adapter i2c-1: unable to read EDID block.
[    0.652026] Switched to high resolution mode on CPU 0
[    0.711858] i2c-adapter i2c-1: unable to read EDID block.
[    0.754272] nvidiafb: CRTC 0 appears to have a CRT attached
[    0.754272] nvidiafb: Using CRT on CRTC 0
[    0.756281] nvidiafb: MTRR set to ON
[    0.818206] Console: switching to colour frame buffer device 160x64
[    0.821230] nvidiafb: PCI nVidia NV32 framebuffer (64MB @ 0xF0000000)
[    0.821557] input: Power Button (FF) as /class/input/input0
[    0.821617] ACPI: Power Button (FF) [PWRF]
[    0.821761] input: Power Button (CM) as /class/input/input1
[    0.821796] ACPI: Power Button (CM) [PWRB]
[    0.821929] input: Sleep Button (CM) as /class/input/input2
[    0.821963] ACPI: Sleep Button (CM) [SLPB]
[    0.822588] ACPI: ACPI0007:00 is registered as cooling_device0
[    0.875224] Real Time Clock Driver v1.12ac
[    0.875463] Linux agpgart interface v0.103
[    0.875550] isa bounce pool size: 16 pages
[    0.876773] brd: module loaded
[    0.877564] loop: module loaded
[    0.877609] ne2k-pci.c:v1.03 9/22/2003 D. Becker/P. Gortmaker
[    0.877654] ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 17 (level, low) -> IRQ 17
[    0.878274] eth0: Compex RL2000 found at 0xb000, IRQ 17, 00:80:48:de:5e:89.
[    0.878388] ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 17 (level, low) -> IRQ 17
[    0.878442] PCI: Disallowing DAC for device 0000:00:0a.0
[    0.878501] skge 1.13 addr 0xfab00000 irq 17 chip Yukon-Lite rev 9
[    0.879082] skge eth1: addr 00:11:d8:60:74:55
[    0.879204] console [netcon0] enabled
[    0.879294] netconsole: network logging started
[    0.880378] Driver 'sd' needs updating - please use bus_type methods
[    0.881334] Driver 'sr' needs updating - please use bus_type methods
[    0.882404] sata_via 0000:00:0f.0: version 2.3
[    0.882423] ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 20
[    0.883334] sata_via 0000:00:0f.0: routed to hard irq line 10
[    0.884411] scsi0 : sata_via
[    0.885422] scsi1 : sata_via
[    0.887375] ata1: SATA max UDMA/133 cmd 0xd000 ctl 0xc800 bmdma 0xb800 irq 20
[    0.888282] ata2: SATA max UDMA/133 cmd 0xc400 ctl 0xc000 bmdma 0xb808 irq 20
[    1.091268] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.246893] ata1.00: ATA-6: WDC WD1600JD-00HBB0, 08.02D08, max UDMA/133
[    1.246896] ata1.00: 312581808 sectors, multi 16: LBA48 
[    1.255627] ata1.00: configured for UDMA/133
[    1.456696] ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
[    1.458082] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JD-00H 08.0 PQ: 0 ANSI: 5
[    1.460110] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    1.460720] sd 0:0:0:0: [sda] Write Protect is off
[    1.461698] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.461737] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.463757] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    1.464715] sd 0:0:0:0: [sda] Write Protect is off
[    1.465697] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.465731] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.466732]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
[    1.540734] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.541216] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.543055] pata_via 0000:00:0f.1: version 0.3.3
[    1.543098] ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level, low) -> IRQ 20
[    1.544130] scsi2 : pata_via
[    1.545111] scsi3 : pata_via
[    1.548858] ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
[    1.548986] ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
[    1.871628] ata3.00: ATAPI: HL-DT-ST DVDRAM GSA-4163B, A102, max UDMA/33
[    2.044360] ata3.00: configured for UDMA/33
[    2.200094] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4163B A102 PQ: 0 ANSI: 5
[    2.207013] sr0: scsi3-mmc drive: 62x/62x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.207016] Uniform CD-ROM driver Revision: 3.20
[    2.208231] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    2.208360] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    2.209246] PNP: PS/2 Controller [PNP0f03:PS2M] at 0x60,0x64 irq 12
[    2.210015] PNP: PS/2 controller doesn't have KBD irq; using default 1
[    2.212045] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.213041] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.214346] mice: PS/2 mouse device common for all mice
[    2.257606] rtc_cmos: probe of 00:02 failed with error -16
[    2.257908] EDAC MC: Ver: 2.1.0 Mar 29 2008
[    2.258945] oprofile: using NMI interrupt.
[    2.260692] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.261687] TCP cubic registered
[    2.262629] Initializing XFRM netlink socket
[    2.263631] NET: Registered protocol family 1
[    2.264676] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3200+ processors (1 cpu cores) (version 2.20.00)
[    2.265760] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x6
[    2.266640] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x8
[    2.267606] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
[    2.268830] powernow-k8: ph2 null fid transition 0xc
[    2.270642] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    2.830863] input: ImPS/2 Generic Wheel Mouse as /class/input/input3
[    3.007723] kjournald starting.  Commit interval 5 seconds
[    3.007860] EXT3-fs: mounted filesystem with ordered data mode.
[    3.008784] VFS: Mounted root (ext3 filesystem) readonly.
[    3.009745] Freeing unused kernel memory: 240k freed
[    3.010848] Write protecting the kernel read-only data: 1236k
[    7.483006] usbcore: registered new interface driver usbfs
[    7.486102] usbcore: registered new interface driver hub
[    7.489193] usbcore: registered new device driver usb
[    7.494018] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 21
[    7.494869] ehci_hcd 0000:00:10.4: EHCI Host Controller
[    7.498497] ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
[    7.498935] ehci_hcd 0000:00:10.4: irq 21, io mem 0xfae00000
[    7.506861] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    7.507970] usb usb1: configuration #1 chosen from 1 choice
[    7.509033] hub 1-0:1.0: USB hub found
[    7.509923] hub 1-0:1.0: 8 ports detected
[    7.613393] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    7.613462] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.614456] usb usb1: Product: EHCI Host Controller
[    7.615455] usb usb1: Manufacturer: Linux 2.6.25-rc7 ehci_hcd
[    7.616454] usb usb1: SerialNumber: 0000:00:10.4
[    8.137006] USB Universal Host Controller Interface driver v3.0
[    8.137561] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 21
[    8.139496] uhci_hcd 0000:00:10.0: UHCI Host Controller
[    8.150344] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
[    8.150516] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000d400
[    8.151763] usb usb2: configuration #1 chosen from 1 choice
[    8.158030] Linux video capture interface: v2.00
[    8.159536] hub 2-0:1.0: USB hub found
[    8.161734] hub 2-0:1.0: 2 ports detected
[    8.183031] bttv: driver version 0.9.17 loaded
[    8.183482] bttv: using 8 buffers with 2080k (520 pages) each for capture
[    8.263885] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    8.264354] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.265352] usb usb2: Product: UHCI Host Controller
[    8.266347] usb usb2: Manufacturer: Linux 2.6.25-rc7 uhci_hcd
[    8.267350] usb usb2: SerialNumber: 0000:00:10.0
[    8.268462] ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 21
[    8.269360] uhci_hcd 0000:00:10.1: UHCI Host Controller
[    8.270397] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
[    8.271375] uhci_hcd 0000:00:10.1: irq 21, io base 0x0000d800
[    8.272679] usb usb3: configuration #1 chosen from 1 choice
[    8.273460] hub 3-0:1.0: USB hub found
[    8.275300] hub 3-0:1.0: 2 ports detected
[    8.379931] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    8.379998] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.380936] usb usb3: Product: UHCI Host Controller
[    8.381933] usb usb3: Manufacturer: Linux 2.6.25-rc7 uhci_hcd
[    8.382933] usb usb3: SerialNumber: 0000:00:10.1
[    8.383988] ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 21
[    8.384942] uhci_hcd 0000:00:10.2: UHCI Host Controller
[    8.385981] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
[    8.387018] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e000
[    8.388148] usb usb4: configuration #1 chosen from 1 choice
[    8.388978] hub 4-0:1.0: USB hub found
[    8.389944] hub 4-0:1.0: 2 ports detected
[    8.493499] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    8.493517] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.494518] usb usb4: Product: UHCI Host Controller
[    8.495578] usb usb4: Manufacturer: Linux 2.6.25-rc7 uhci_hcd
[    8.496515] usb usb4: SerialNumber: 0000:00:10.2
[    8.497630] ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 21
[    8.498585] uhci_hcd 0000:00:10.3: UHCI Host Controller
[    8.499565] uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
[    8.500542] uhci_hcd 0000:00:10.3: irq 21, io base 0x0000e400
[    8.502636] usb usb5: configuration #1 chosen from 1 choice
[    8.503562] hub 5-0:1.0: USB hub found
[    8.504589] hub 5-0:1.0: 2 ports detected
[    8.610377] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    8.611277] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.612274] usb usb5: Product: UHCI Host Controller
[    8.613272] usb usb5: Manufacturer: Linux 2.6.25-rc7 uhci_hcd
[    8.614271] usb usb5: SerialNumber: 0000:00:10.3
[    8.618297] bttv: Bt8xx card found (0).
[    8.619322] ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 18 (level, low) -> IRQ 18
[    8.620230] bttv0: Bt878 (rev 17) at 0000:00:0d.0, irq: 18, latency: 64, mmio: 0xefe00000
[    8.621287] bttv0: using: Lifeview FlyVideo 2000 /FlyVideo A2/ Lifetec LT 9415 TV [LR90] [card=54,insmod option]
[    8.622308] bttv0: gpio: en=00000000, out=00000000 in=00d4dfe0 [init]
[    8.624396] usb 2-2: new low speed USB device using uhci_hcd and address 2
[    8.627128] bttv0: FlyVideo Radio=yes RemoteControl=yes Tuner=5 gpio=0xd4dfe0
[    8.627211] bttv0: FlyVideo  LR90=yes tda9821/tda9820=no  capture_only=no 
[    8.628210] bttv0: tuner type=5
[    8.629212] bttv0: i2c: checking for MSP34xx @ 0x80... not found
[    8.632272] bttv0: i2c: checking for TDA9875 @ 0xb0... found
[    8.661822] tda9875: no such chip at 0xb0 (dic=0x7 rev=0x7)
[    8.662255] i2c-adapter i2c-4: Client creation failed at 0x58 (1)
[    8.664288] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[    8.943512] usb 2-2: configuration #1 chosen from 1 choice
[    8.956271] usb 2-2: New USB device found, idVendor=046d, idProduct=c30e
[    8.956338] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.957341] usb 2-2: Product: HID compliant keyboard
[    8.958337] usb 2-2: Manufacturer: Logitech
[    8.976851] tuner' 4-0061: chip found @ 0xc2 (bt878 #0 [sw])
[    8.977601] tuner-simple 4-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
[    8.991433] bttv0: registered device video0
[    8.992412] bttv0: registered device vbi0
[    8.993406] bttv0: registered device radio0
[    8.994395] bttv0: PLL: 28636363 => 35468950 .. ok
[   10.420943] input: Logitech HID compliant keyboard as /class/input/input4
[   10.427946] input: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:10.0-2
[   10.545939] input: Logitech HID compliant keyboard as /class/input/input5
[   10.553852] input: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:10.0-2
[   10.553881] usbcore: registered new interface driver usbhid
[   10.554856] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   11.952909] EXT3 FS on sda5, internal journal
[   12.241973] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 22
[   12.244030] PCI: Setting latency timer of device 0000:00:11.5 to 64
[   13.522350] kjournald starting.  Commit interval 5 seconds
[   13.523626] EXT3 FS on sda6, internal journal
[   13.523635] EXT3-fs: mounted filesystem with ordered data mode.
[   13.527373] kjournald starting.  Commit interval 5 seconds
[   13.528404] EXT3 FS on sda8, internal journal
[   13.528755] EXT3-fs: mounted filesystem with ordered data mode.
[   13.547062] kjournald starting.  Commit interval 5 seconds
[   13.548618] EXT3 FS on sda10, internal journal
[   13.549069] EXT3-fs: mounted filesystem with ordered data mode.
[   13.561481] kjournald starting.  Commit interval 5 seconds
[   13.562343] EXT3 FS on sda7, internal journal
[   13.562488] EXT3-fs: mounted filesystem with ordered data mode.
[   13.671948] Adding 1020112k swap on /dev/sda2.  Priority:-1 extents:1 across:1020112k
[   23.785490] skge eth1: enabling interface
[   24.142640] NET: Registered protocol family 17
[   25.410165] skge eth1: Link is up at 100 Mbps, full duplex, flow control both
[   27.096262] Marking TSC unstable due to cpufreq changes
[   27.401694] Clocksource tsc unstable (delta = -158384329 ns)
[   54.265252] ------------[ cut here ]------------
[   54.265292] WARNING: at kernel/mutex.c:134 mutex_lock_nested+0x27a/0x2c0()
[   54.265322] Modules linked in: af_packet snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq snd_via82xx snd_ac97_codec ac97_bus snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device snd soundcore usbhid tuner tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx tea5761 tda9875 bttv firmware_class ir_common compat_ioctl32 videodev v4l1_compat v4l2_common videobuf_dma_sg videobuf_core btcx_risc tveeprom uhci_hcd ehci_hcd usbcore i2c_viapro
[   54.265684] Pid: 5887, comm: radio Not tainted 2.6.25-rc7 #196
[   54.265709] 
[   54.265710] Call Trace:
[   54.265742]  [<ffffffff8022ed7f>] warn_on_slowpath+0x5f/0x80
[   54.265779]  [<ffffffff804db37a>] mutex_lock_nested+0x27a/0x2c0
[   54.265820]  [<ffffffff8807979a>] :bttv:radio_g_tuner+0x5a/0xc0
[   54.265851]  [<ffffffff8805d388>] :videodev:__video_do_ioctl+0x17f8/0x33c0
[   54.265890]  [<ffffffff88056444>] :v4l1_compat:v4l_compat_translate_ioctl+0x214/0x20cc
[   54.265925]  [<ffffffff8805bb90>] ? :videodev:__video_do_ioctl+0x0/0x33c0
[   54.265958]  [<ffffffff802a3922>] ? __d_lookup+0xf2/0x1d0
[   54.265986]  [<ffffffff8025294a>] ? __lock_acquire+0x39a/0x1080
[   54.265986]  [<ffffffff80251ebe>] ? mark_held_locks+0x3e/0x80
[   54.265986]  [<ffffffff804dc790>] ? trace_hardirqs_on_thunk+0x35/0x3a
[   54.265986]  [<ffffffff80252079>] ? trace_hardirqs_on+0xd9/0x170
[   54.265986]  [<ffffffff804dc790>] ? trace_hardirqs_on_thunk+0x35/0x3a
[   54.265986]  [<ffffffff8020bba3>] ? restore_args+0x0/0x30
[   54.265986]  [<ffffffff8021132f>] ? native_read_tsc+0xf/0x20
[   54.265986]  [<ffffffff8035b9b8>] ? __delay+0x38/0x60
[   54.265986]  [<ffffffff8035b9b8>] ? __delay+0x38/0x60
[   54.265986]  [<ffffffff8035b9b8>] ? __delay+0x38/0x60
[   54.265986]  [<ffffffff80251ebe>] ? mark_held_locks+0x3e/0x80
[   54.265986]  [<ffffffff804db04b>] ? __mutex_unlock_slowpath+0xdb/0x180
[   54.265986]  [<ffffffff80252079>] ? trace_hardirqs_on+0xd9/0x170
[   54.265986]  [<ffffffff804db0f9>] ? mutex_unlock+0x9/0x10
[   54.265986]  [<ffffffff8025294a>] ? __lock_acquire+0x39a/0x1080
[   54.265986]  [<ffffffff804d164f>] ? klist_next+0x2f/0xc0
[   54.265986]  [<ffffffff804d168f>] ? klist_next+0x6f/0xc0
[   54.265986]  [<ffffffff8025294a>] ? __lock_acquire+0x39a/0x1080
[   54.265986]  [<ffffffff8805c062>] :videodev:__video_do_ioctl+0x4d2/0x33c0
[   54.265986]  [<ffffffff80275efd>] ? __do_fault+0x16d/0x480
[   54.265986]  [<ffffffff80275f7c>] ? __do_fault+0x1ec/0x480
[   54.265986]  [<ffffffff8805f4dc>] :videodev:video_ioctl2+0xec/0x260
[   54.265986]  [<ffffffff80252079>] ? trace_hardirqs_on+0xd9/0x170
[   54.265986]  [<ffffffff804dd402>] ? _spin_unlock_irqrestore+0x42/0x80
[   54.265986]  [<ffffffff8029d8aa>] vfs_ioctl+0x7a/0x90
[   54.265986]  [<ffffffff8029d933>] do_vfs_ioctl+0x73/0x2d0
[   54.265986]  [<ffffffff8029dbda>] sys_ioctl+0x4a/0x80
[   54.265986]  [<ffffffff8020b53b>] system_call_after_swapgs+0x7b/0x80
[   54.265986] 
[   54.265986] ---[ end trace ae288c92d6fd79ce ]---
[   54.265986] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[   54.265986] IP: [<ffffffff804db1b1>] mutex_lock_nested+0xb1/0x2c0
[   54.265986] PGD 3d956067 PUD 3c879067 PMD 0 
[   54.265986] Oops: 0002 [1] PREEMPT 
[   54.265986] CPU 0 
[   54.265986] Modules linked in: af_packet snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq snd_via82xx snd_ac97_codec ac97_bus snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device snd soundcore usbhid tuner tea5767 tda8290 tuner_xc2028 tda9887 tuner_simple mt20xx tea5761 tda9875 bttv firmware_class ir_common compat_ioctl32 videodev v4l1_compat v4l2_common videobuf_dma_sg videobuf_core btcx_risc tveeprom uhci_hcd ehci_hcd usbcore i2c_viapro
[   54.265986] Pid: 5887, comm: radio Not tainted 2.6.25-rc7 #196
[   54.265986] RIP: 0010:[<ffffffff804db1b1>]  [<ffffffff804db1b1>] mutex_lock_nested+0xb1/0x2c0
[   54.265986] RSP: 0018:ffff81003c86f5f8  EFLAGS: 00010046
[   54.265986] RAX: 0000000000000000 RBX: ffff81003f898298 RCX: 0000000000000000
[   54.265986] RDX: ffff81003c86e000 RSI: ffff81003c86f608 RDI: ffff81003f898298
[   54.265986] RBP: ffff81003c86f668 R08: 0000000000000002 R09: 0000000000000001
[   54.265986] R10: ffff81003c86f06f R11: ffff81003c86f06e R12: 0000000000000246
[   54.265986] R13: ffff81003d10ce40 R14: ffff81003f8982d0 R15: ffff81003c86f608
[   54.265986] FS:  00007f66620b66f0(0000) GS:ffffffff8066a000(0000) knlGS:0000000000000000
[   54.265986] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   54.265986] CR2: 0000000000000000 CR3: 000000003d0b4000 CR4: 00000000000006e0
[   54.265986] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   54.265986] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   54.265986] Process radio (pid: 5887, threadinfo ffff81003c86e000, task ffff81003d10ce40)
[   54.265986] Stack:  0000000000000000 0000000000000000 ffff81003f8982d0 ffff81003c86f608
[   54.265986]  1111111111111111 ffff81003f898298 ffff81003c86f608 0000000000000000
[   54.265986]  0000000000000000 ffff81003f897800 ffff81003c86fab8 ffff81003f898298
[   54.265986] Call Trace:
[   54.265986]  [<ffffffff8807979a>] :bttv:radio_g_tuner+0x5a/0xc0
[   54.265986]  [<ffffffff8805d388>] :videodev:__video_do_ioctl+0x17f8/0x33c0
[   54.265986]  [<ffffffff88056444>] :v4l1_compat:v4l_compat_translate_ioctl+0x214/0x20cc
[   54.265986]  [<ffffffff8805bb90>] ? :videodev:__video_do_ioctl+0x0/0x33c0
[   54.265986]  [<ffffffff802a3922>] ? __d_lookup+0xf2/0x1d0
[   54.265986]  [<ffffffff8025294a>] ? __lock_acquire+0x39a/0x1080
[   54.265986]  [<ffffffff80251ebe>] ? mark_held_locks+0x3e/0x80
[   54.265986]  [<ffffffff804dc790>] ? trace_hardirqs_on_thunk+0x35/0x3a
[   54.265986]  [<ffffffff80252079>] ? trace_hardirqs_on+0xd9/0x170
[   54.265986]  [<ffffffff804dc790>] ? trace_hardirqs_on_thunk+0x35/0x3a
[   54.265986]  [<ffffffff8020bba3>] ? restore_args+0x0/0x30
[   54.265986]  [<ffffffff8021132f>] ? native_read_tsc+0xf/0x20
[   54.265986]  [<ffffffff8035b9b8>] ? __delay+0x38/0x60
[   54.265986]  [<ffffffff8035b9b8>] ? __delay+0x38/0x60
[   54.265986]  [<ffffffff8035b9b8>] ? __delay+0x38/0x60
[   54.265986]  [<ffffffff80251ebe>] ? mark_held_locks+0x3e/0x80
[   54.265986]  [<ffffffff804db04b>] ? __mutex_unlock_slowpath+0xdb/0x180
[   54.265986]  [<ffffffff80252079>] ? trace_hardirqs_on+0xd9/0x170
[   54.265986]  [<ffffffff804db0f9>] ? mutex_unlock+0x9/0x10
[   54.265986]  [<ffffffff8025294a>] ? __lock_acquire+0x39a/0x1080
[   54.265986]  [<ffffffff804d164f>] ? klist_next+0x2f/0xc0
[   54.265986]  [<ffffffff804d168f>] ? klist_next+0x6f/0xc0
[   54.265986]  [<ffffffff8025294a>] ? __lock_acquire+0x39a/0x1080
[   54.265986]  [<ffffffff8805c062>] :videodev:__video_do_ioctl+0x4d2/0x33c0
[   54.265986]  [<ffffffff80275efd>] ? __do_fault+0x16d/0x480
[   54.265986]  [<ffffffff80275f7c>] ? __do_fault+0x1ec/0x480
[   54.265986]  [<ffffffff8805f4dc>] :videodev:video_ioctl2+0xec/0x260
[   54.265986]  [<ffffffff80252079>] ? trace_hardirqs_on+0xd9/0x170
[   54.265986]  [<ffffffff804dd402>] ? _spin_unlock_irqrestore+0x42/0x80
[   54.265986]  [<ffffffff8029d8aa>] vfs_ioctl+0x7a/0x90
[   54.265986]  [<ffffffff8029d933>] do_vfs_ioctl+0x73/0x2d0
[   54.265986]  [<ffffffff8029dbda>] sys_ioctl+0x4a/0x80
[   54.265986]  [<ffffffff8020b53b>] system_call_after_swapgs+0x7b/0x80
[   54.265986] 
[   54.265986] 
[   54.265986] Code: 00 00 00 31 c9 31 d2 4c 8d 73 38 e8 9a 84 d7 ff 49 8b 55 08 4c 89 fe 48 89 df e8 cb 3f d7 ff 49 8b 46 08 4c 89 75 a0 4d 89 7e 08 <4c> 89 38 48 89 45 a8 48 c7 c0 ff ff ff ff 4c 89 6d b0 87 03 ff 
[   54.265986] RIP  [<ffffffff804db1b1>] mutex_lock_nested+0xb1/0x2c0
[   54.265986]  RSP <ffff81003c86f5f8>
[   54.265986] CR2: 0000000000000000
[   54.265986] ---[ end trace ae288c92d6fd79ce ]---
[   54.265986] BUG: sleeping function called from invalid context at kernel/rwsem.c:21
[   54.265986] in_atomic():0, irqs_disabled():1
[   54.265986] INFO: lockdep is turned off.
[   54.265986] irq event stamp: 3718
[   54.265986] hardirqs last  enabled at (3717): [<ffffffff804dc790>] trace_hardirqs_on_thunk+0x35/0x3a
[   54.265986] hardirqs last disabled at (3718): [<ffffffff804db159>] mutex_lock_nested+0x59/0x2c0
[   54.265986] softirqs last  enabled at (3690): [<ffffffff80234a96>] __do_softirq+0xb6/0xd0
[   54.265986] softirqs last disabled at (3685): [<ffffffff8020c35c>] call_softirq+0x1c/0x30
[   54.265986] Pid: 5887, comm: radio Tainted: G      D  2.6.25-rc7 #196
[   54.265986] 
[   54.265986] Call Trace:
[   54.265986]  [<ffffffff8024f900>] ? print_irqtrace_events+0x110/0x120
[   54.265986]  [<ffffffff80227df7>] __might_sleep+0xc7/0xe0
[   54.265986]  [<ffffffff804db8cd>] down_read+0x1d/0x50
[   54.265986]  [<ffffffff8025ee7c>] acct_collect+0x4c/0x1b0
[   54.265986]  [<ffffffff8023293a>] do_exit+0x16a/0x7b0
[   54.265986]  [<ffffffff803de6ed>] ? do_unblank_screen+0x1d/0x140
[   54.265986]  [<ffffffff804ddcc9>] oops_end+0x89/0x90
[   54.265986]  [<ffffffff804dfbb3>] do_page_fault+0x4d3/0x910
[   54.265986]  [<ffffffff804dd7ad>] error_exit+0x0/0xa9
[   54.265986]  [<ffffffff804db1b1>] ? mutex_lock_nested+0xb1/0x2c0
[   54.265986]  [<ffffffff804db1a5>] ? mutex_lock_nested+0xa5/0x2c0
[   54.265986]  [<ffffffff8807979a>] ? :bttv:radio_g_tuner+0x5a/0xc0
[   54.265986]  [<ffffffff8805d388>] ? :videodev:__video_do_ioctl+0x17f8/0x33c0
[   54.265986]  [<ffffffff88056444>] ? :v4l1_compat:v4l_compat_translate_ioctl+0x214/0x20cc
[   54.265986]  [<ffffffff8805bb90>] ? :videodev:__video_do_ioctl+0x0/0x33c0
[   54.265986]  [<ffffffff802a3922>] ? __d_lookup+0xf2/0x1d0
[   54.265986]  [<ffffffff8025294a>] ? __lock_acquire+0x39a/0x1080
[   54.265986]  [<ffffffff80251ebe>] ? mark_held_locks+0x3e/0x80
[   54.265986]  [<ffffffff804dc790>] ? trace_hardirqs_on_thunk+0x35/0x3a
[   54.265986]  [<ffffffff80252079>] ? trace_hardirqs_on+0xd9/0x170
[   54.265986]  [<ffffffff804dc790>] ? trace_hardirqs_on_thunk+0x35/0x3a
[   54.265986]  [<ffffffff8020bba3>] ? restore_args+0x0/0x30
[   54.265986]  [<ffffffff8021132f>] ? native_read_tsc+0xf/0x20
[   54.265986]  [<ffffffff8035b9b8>] ? __delay+0x38/0x60
[   54.265986]  [<ffffffff8035b9b8>] ? __delay+0x38/0x60
[   54.265986]  [<ffffffff8035b9b8>] ? __delay+0x38/0x60
[   54.265986]  [<ffffffff80251ebe>] ? mark_held_locks+0x3e/0x80
[   54.265986]  [<ffffffff804db04b>] ? __mutex_unlock_slowpath+0xdb/0x180
[   54.265986]  [<ffffffff80252079>] ? trace_hardirqs_on+0xd9/0x170
[   54.265986]  [<ffffffff804db0f9>] ? mutex_unlock+0x9/0x10
[   54.265986]  [<ffffffff8025294a>] ? __lock_acquire+0x39a/0x1080
[   54.265986]  [<ffffffff804d164f>] ? klist_next+0x2f/0xc0
[   54.265986]  [<ffffffff804d168f>] ? klist_next+0x6f/0xc0
[   54.265986]  [<ffffffff8025294a>] ? __lock_acquire+0x39a/0x1080
[   54.265986]  [<ffffffff8805c062>] ? :videodev:__video_do_ioctl+0x4d2/0x33c0
[   54.265986]  [<ffffffff80275efd>] ? __do_fault+0x16d/0x480
[   54.265986]  [<ffffffff80275f7c>] ? __do_fault+0x1ec/0x480
[   54.265986]  [<ffffffff8805f4dc>] ? :videodev:video_ioctl2+0xec/0x260
[   54.265986]  [<ffffffff80252079>] ? trace_hardirqs_on+0xd9/0x170
[   54.265986]  [<ffffffff804dd402>] ? _spin_unlock_irqrestore+0x42/0x80
[   54.265986]  [<ffffffff8029d8aa>] ? vfs_ioctl+0x7a/0x90
[   54.265986]  [<ffffffff8029d933>] ? do_vfs_ioctl+0x73/0x2d0
[   54.265986]  [<ffffffff8029dbda>] ? sys_ioctl+0x4a/0x80
[   54.265986]  [<ffffffff8020b53b>] ? system_call_after_swapgs+0x7b/0x80
[   54.265986] 

ps: note that offending patch introduced build breakage and the fix was
    commited 90 revisions later

ps2: i couldn't revert it on top of rc7 because there are many patches
     which depend on this one
