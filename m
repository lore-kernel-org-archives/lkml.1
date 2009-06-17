Return-Path: <linux-kernel-owner+w=401wt.eu-S1760118AbZFQSfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118AbZFQSfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760056AbZFQSev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:34:51 -0400
Received: from mx.treblig.org ([80.68.94.177]:52516 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758627AbZFQSes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:48 -0400
Date: Wed, 17 Jun 2009 20:34:42 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
Message-ID: <20090617193442.GA31944@gallifrey>
References: <20090613230842.GA18347@gallifrey> <4A349B67.1070603@zytor.com> <20090614122734.GA1499@gallifrey> <alpine.LRH.2.00.0906161126330.31685@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0906161126330.31685@twin.jikos.cz>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.29.2-bytemark-kvm-tickless-2009-05-05 (i686)
X-Uptime: 20:28:33 up 22 days, 12:50,  2 users,  load average: 0.06, 0.04, 0.01
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Kosina (jkosina@suse.cz) wrote:
> On Sun, 14 Jun 2009, Dr. David Alan Gilbert wrote:
> 
> > > > [    3.147416] PNP: No PS/2 controller found. Probing ports directly.
> > > > [    3.174456] serio: i8042 KBD port at 0x60,0x64 irq 1
> > > > [    3.174961] serio: i8042 AUX port at 0x60,0x64 irq 12
> > > > [    3.186312] mice: PS/2 mouse device common for all mice
> > > It does, correctly, identify the keyboard and mode port, so it's
> > > somewhat odd that it doesn't get used...
> > Indeed. The only other observation in the older kernel that works
> > it detects the AUX port first.
> 
> Booting with 'i8042.debug' will spit some more output into dmesg, which 
> might help us to see if i8042 is really properly initialized, or something 
> strange is going on during initialization.

Please find below the new dmesg created by appending i8042.debug; this was
taken from a slightly newer build of the same source kernel that I reported; this
build just had a few more things configured out (parallel port) but exhibits
the same symptom.

No more debug is generated as I press any keys.

Dave

[    0.000000] Linux version 2.6.30-gort1 (dg@davros) (gcc version 4.4.0 (Ubuntu 4.4.0-5ubuntu1) ) #7 Sun Jun 14 17:36:35 BST 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-88: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-88: 0000000000100000 - 0000000004000000 (usable)
[    0.000000] DMI not present or invalid.
[    0.000000] last_pfn = 0x4000 max_arch_pfn = 0x100000
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f000 (usable)
[    0.000000]  modified: 0000000000100000 - 0000000004000000 (usable)
[    0.000000] init_memory_mapping: 0000000000000000-0000000004000000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0004000000 page 2M
[    0.000000] kernel direct mapping tables up to 4000000 @ 10000-14000
[    0.000000] 64MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 04000000
[    0.000000]   low ram: 0 - 04000000
[    0.000000]   node 0 low ram: 00000000 - 04000000
[    0.000000]   node 0 bootmap 00010000 - 00010800
[    0.000000] (5 early reservations) ==> bootmem [0000000000 - 0004000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000200000 - 00005ffd74]    TEXT DATA BSS ==> [0000200000 - 00005ffd74]
[    0.000000]   #2 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #3 [0000600000 - 0000602000]              BRK ==> [0000600000 - 0000602000]
[    0.000000]   #4 [0000010000 - 0000011000]          BOOTMAP ==> [0000010000 - 0000011000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00004000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00004000
[    0.000000] On node 0 totalpages: 16272
[    0.000000] free_area_init_node: node 0, pgdat c0569a04, node_mem_map c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3952 pages, LIFO batch:0
[    0.000000]   Normal zone: 96 pages used for memmap
[    0.000000]   Normal zone: 12192 pages, LIFO batch:1
[    0.000000] Allocating PCI resources starting at 10000000 (gap: 4000000:fc000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16144
[    0.000000] Kernel command line: root=/dev/hda3 ro i8042.debug
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:16
[    0.000000] PID hash table entries: 256 (order: 8, 1024 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 90.205 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.004000] Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.004000] Memory: 60392k/65536k available (2438k kernel code, 4672k reserved, 1115k data, 212k init, 0k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfffeb000 - 0xfffff000   (  80 kB)
[    0.004000]     vmalloc : 0xc4800000 - 0xfffe9000   ( 951 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xc4000000   (  64 MB)
[    0.004000]       .init : 0xc057c000 - 0xc05b1000   ( 212 kB)
[    0.004000]       .data : 0xc04618c0 - 0xc05787cc   (1115 kB)
[    0.004000]       .text : 0xc0200000 - 0xc04618c0   (2438 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.004000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.004099] Calibrating delay loop (skipped), value calculated using timer frequency.. 180.41 BogoMIPS (lpj=360820)
[    0.005240] Security Framework initialized
[    0.005637] SELinux:  Disabled at boot.
[    0.006096] Mount-cache hash table entries: 512
[    0.009925] Intel Pentium with F0 0F bug - workaround enabled.
[    0.010313] 
[    0.010875] CPU: Intel Pentium 75 - 200 stepping 04
[    0.011516] Checking 'hlt' instruction... OK.
[    0.032857] net_namespace: 560 bytes
[    0.040412] NET: Registered protocol family 16
[    0.051348] PCI: PCI BIOS revision 2.00 entry at 0xf3940, last bus=0
[    0.051754] PCI: Using configuration type 1 for base access
[    0.181104] bio: create slab <bio-0> at 0
[    0.197557] PCI: Probing PCI hardware
[    0.197933] PCI: Probing PCI hardware (bus 00)
[    0.199725] PCI: Scanning bus 0000:00
[    0.199964] pci 0000:00:00.0: found [8086:04a3] class 000600 header type 00
[    0.200562] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x15f
[    0.200727] pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x2c
[    0.200993] pci 0000:00:01.0: found [1042:1000] class 000101 header type 00
[    0.201140] pci 0000:00:01.0: reg 10 io port: [0x1f0-0x1f7]
[    0.201259] pci 0000:00:01.0: reg 14 io port: [0x3f4-0x3f7]
[    0.201492] pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x15f
[    0.201741] pci 0000:00:02.0: found [8086:0484] class 000000 header type 00
[    0.202018] pci 0000:00:02.0: calling quirk_resource_alignment+0x0/0x15f
[    0.202164] pci 0000:00:02.0: calling pci_fixup_transparent_bridge+0x0/0x2c
[    0.202426] pci 0000:00:06.0: found [10ec:8139] class 000200 header type 00
[    0.202572] pci 0000:00:06.0: reg 10 io port: [0xfc80-0xfcff]
[    0.202696] pci 0000:00:06.0: reg 14 32bit mmio: [0xffbfff80-0xffbfffff]
[    0.202925] pci 0000:00:06.0: calling quirk_resource_alignment+0x0/0x15f
[    0.203212] pci 0000:00:0c.0: found [8086:1229] class 000200 header type 00
[    0.203381] pci 0000:00:0c.0: reg 10 32bit mmio: [0xffbef000-0xffbeffff]
[    0.203507] pci 0000:00:0c.0: reg 14 io port: [0xfc40-0xfc7f]
[    0.203629] pci 0000:00:0c.0: reg 18 32bit mmio: [0xffa00000-0xffafffff]
[    0.203787] pci 0000:00:0c.0: reg 30 32bit mmio: [0xfe000000-0xfe0fffff]
[    0.204176] pci 0000:00:0c.0: calling quirk_resource_alignment+0x0/0x15f
[    0.204328] pci 0000:00:0c.0: calling pci_fixup_transparent_bridge+0x0/0x2c
[    0.204469] pci 0000:00:0c.0: supports D1 D2
[    0.204552] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot
[    0.204963] pci 0000:00:0c.0: PME# disabled
[    0.205476] pci 0000:00:0e.0: found [10b7:9200] class 000200 header type 00
[    0.205639] pci 0000:00:0e.0: reg 10 io port: [0xf880-0xf8ff]
[    0.205764] pci 0000:00:0e.0: reg 14 32bit mmio: [0xffbdff80-0xffbdffff]
[    0.205932] pci 0000:00:0e.0: reg 30 32bit mmio: [0xfe000000-0xfe01ffff]
[    0.206116] pci 0000:00:0e.0: calling quirk_resource_alignment+0x0/0x15f
[    0.206257] pci 0000:00:0e.0: supports D1 D2
[    0.206337] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot
[    0.206733] pci 0000:00:0e.0: PME# disabled
[    0.207183] PCI: Fixups for bus 0000:00
[    0.207269] PCI: Bus scan for 0000:00 returning with max=00
[    0.225534] NetLabel: Initializing
[    0.225890] NetLabel:  domain hash size = 128
[    0.226213] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.226979] NetLabel:  unlabeled traffic allowed by default
[    0.227791] Slow work thread pool: Starting up
[    0.229328] Slow work thread pool: Ready
[    0.229853] FS-Cache: Loaded
[    0.232330] CacheFiles: Loaded
[    0.250057] pci 0000:00:0e.0: BAR 6: got res [0x10000000-0x1001ffff] bus [0x10000000-0x1001ffff] flags 0x27200
[    0.250212] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.250310] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.251078] NET: Registered protocol family 2
[    0.253970] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.261776] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
[    0.262779] TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
[    0.263454] TCP: Hash tables configured (established 2048 bind 2048)
[    0.263950] TCP reno registered
[    0.265914] NET: Registered protocol family 1
[    0.274184] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.276349] Scanning for low memory corruption every 60 seconds
[    0.285314] audit: initializing netlink socket (disabled)
[    0.285920] type=2000 audit(1245262771.283:1): initialized
[    0.420817] NTFS driver 2.1.29 [Flags: R/O].
[    0.429045] msgmni has been set to 117
[    0.435408] alg: No test for cipher_null (cipher_null-generic)
[    0.436823] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    0.438080] alg: No test for digest_null (digest_null-generic)
[    0.439330] alg: No test for compress_null (compress_null-generic)
[    0.511551] alg: No test for stdrng (krng)
[    0.512927] alg: No test for stdrng (ansi_cprng)
[    0.513679] io scheduler noop registered
[    0.514028] io scheduler deadline registered (default)
[    0.514744] pci 0000:00:00.0: calling quirk_e100_interrupt+0x0/0x145
[    0.514892] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x21
[    0.515046] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x31e
[    0.515192] pci 0000:00:00.0: calling pci_fixup_video+0x0/0x93
[    0.515352] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x21
[    0.515496] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x31e
[    0.515633] pci 0000:00:01.0: calling pci_fixup_video+0x0/0x93
[    0.515804] pci 0000:00:02.0: calling quirk_e100_interrupt+0x0/0x145
[    0.516155] pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x21
[    0.516312] pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x31e
[    0.516454] pci 0000:00:02.0: calling pci_fixup_video+0x0/0x93
[    0.516618] pci 0000:00:06.0: calling quirk_cardbus_legacy+0x0/0x21
[    0.516764] pci 0000:00:06.0: calling quirk_usb_early_handoff+0x0/0x31e
[    0.516900] pci 0000:00:06.0: calling pci_fixup_video+0x0/0x93
[    0.517068] pci 0000:00:0c.0: calling quirk_e100_interrupt+0x0/0x145
[    0.517267] pci 0000:00:0c.0: Firmware left e100 interrupts enabled; disabling
[    0.517878] pci 0000:00:0c.0: calling quirk_cardbus_legacy+0x0/0x21
[    0.518033] pci 0000:00:0c.0: calling quirk_usb_early_handoff+0x0/0x31e
[    0.518169] pci 0000:00:0c.0: calling pci_fixup_video+0x0/0x93
[    0.518330] pci 0000:00:0e.0: calling quirk_cardbus_legacy+0x0/0x21
[    0.518477] pci 0000:00:0e.0: calling quirk_usb_early_handoff+0x0/0x31e
[    0.518615] pci 0000:00:0e.0: calling pci_fixup_video+0x0/0x93
[    0.519444] isapnp: Scanning for PnP cards...
[    0.876412] isapnp: No Plug & Play device found
[    1.008268] Non-volatile memory driver v1.3
[    1.008675] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    1.009225] Hangcheck: Using get_cycles().
[    1.009619] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.012838] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.015305] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.017964] serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
[    1.020719] serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
[    1.030480] Floppy drive(s): fd0 is 1.44M, fd1 is 1.2M
[    1.052161] FDC 0 is a post-1991 82077
[    1.095677] loop: module loaded
[    1.096161] Uniform Multi-Platform E-IDE driver
[    1.099667] 0000:00:01.0: disabled chipset read-ahead (buggy RZ1000/RZ1001)
[    1.100486] rz1000 0000:00:01.0: IDE controller (0x1042:0x1000 rev 0x01)
[    1.101290] rz1000 0000:00:01.0: not 100% native mode: will probe irqs later
[    1.101734] Probing IDE interface ide0...
[    1.388107] hda: IBM-DCAA-33610, ATA DISK drive
[    1.891960] hdb: GCD-R542B, ATAPI CD/DVD-ROM drive
[    1.894219] Probing IDE interface ide1...
[    2.462073] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    2.463108] ide1 at 0x170-0x177,0x376 on irq 15
[    2.469639] ide-gd driver 1.18
[    2.470490] hda: max request size: 128KiB
[    2.470864] hda: 7056000 sectors (3612 MB) w/96KiB Cache, CHS=7000/16/63
[    2.471457] hda: cache flushes not supported
[    2.472848]  hda: hda1 hda2 < hda5 > hda3
[    2.534310] ide-cd driver 5.00
[    2.540393] ide-cd: hdb: ATAPI 4X CD-ROM drive, 256kB Cache
[    2.541124] Uniform CD-ROM driver Revision: 3.20
[    2.559879] 3c59x: Donald Becker and others.
[    2.560505] 0000:00:0e.0: 3Com PCI 3c905C Tornado at c48f0f80.
[    2.593634] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    2.594041] e100: Copyright(c) 1999-2006 Intel Corporation
[    2.622291] e100 0000:00:0c.0: PME# disabled
[    2.630832] e100: eth1: e100_probe: addr 0xffbef000, irq 11, MAC addr 00:d0:b7:bf:81:57
[    2.685854] Fixed MDIO Bus: probed
[    2.720326] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[    2.720775] 8139cp 0000:00:06.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip, use 8139too
[    2.723122] 8139too Fast Ethernet driver 0.9.28
[    2.734478] eth2: RealTek RTL8139 at 0xfc80, 00:20:18:88:7a:c1, IRQ 11
[    2.734892] eth2:  Identified 8139 chip type 'RTL-8139 rev K'
[    2.736643] tun: Universal TUN/TAP device driver, 1.6
[    2.737011] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.739153] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    2.741330] winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[    2.741406]   http://www.scyld.com/network/drivers.html
[    2.748664] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    2.756565] PNP: No PS/2 controller found. Probing ports directly.
[    2.760232] drivers/input/serio/i8042.c: 20 -> i8042 (command) [3]
[    2.760496] drivers/input/serio/i8042.c: 65 <- i8042 (return) [3]
[    2.760586] drivers/input/serio/i8042.c: 60 -> i8042 (command) [3]
[    2.760725] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [3]
[    2.760821] drivers/input/serio/i8042.c: d3 -> i8042 (command) [3]
[    2.760960] drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [3]
[    2.763945] drivers/input/serio/i8042.c: fe <- i8042 (return) [3]
[    2.772060] drivers/input/serio/i8042.c: a9 -> i8042 (command) [5]
[    2.772360] drivers/input/serio/i8042.c: 00 <- i8042 (return) [5]
[    2.772449] drivers/input/serio/i8042.c: a7 -> i8042 (command) [5]
[    2.772588] drivers/input/serio/i8042.c: 20 -> i8042 (command) [5]
[    2.772781] drivers/input/serio/i8042.c: 74 <- i8042 (return) [5]
[    2.772870] drivers/input/serio/i8042.c: a8 -> i8042 (command) [5]
[    2.773008] drivers/input/serio/i8042.c: 20 -> i8042 (command) [5]
[    2.773252] drivers/input/serio/i8042.c: 54 <- i8042 (return) [5]
[    2.773340] drivers/input/serio/i8042.c: 60 -> i8042 (command) [5]
[    2.773478] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [5]
[    2.773572] drivers/input/serio/i8042.c: d3 -> i8042 (command) [5]
[    2.773712] drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [5]
[    2.775932] drivers/input/serio/i8042.c: fe <- i8042 (return) [5]
[    2.784650] drivers/input/serio/i8042.c: Interrupt 12, without any data [6]
[    2.784760] drivers/input/serio/i8042.c: 60 -> i8042 (command) [6]
[    2.784901] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [6]
[    2.785140] drivers/input/serio/i8042.c: Interrupt 1, without any data [6]
[    2.785247] drivers/input/serio/i8042.c: 60 -> i8042 (command) [6]
[    2.785387] drivers/input/serio/i8042.c: 47 -> i8042 (parameter) [6]
[    2.785485] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.785964] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.795217] mice: PS/2 mouse device common for all mice
[    2.798180] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [9]
[    2.800486] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [10]
[    2.801590] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [10]
[    2.802961] drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [10]
[    2.803174] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [10]
[    2.803363] input: PC Speaker as /devices/platform/pcspkr/input/input0
[    2.805812] evbug.c: Connected device: input0 (PC Speaker at isa0061/input0)
[    2.805957] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [11]
[    2.806619] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [11]
[    2.808965] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [12]
[    2.809244] drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [12]
[    2.812079] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [13]
[    2.812302] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [13]
[    2.812676] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    2.813249] rtc0: alarms up to one day, 114 bytes nvram
[    2.814610] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [13]
[    2.814817] drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [13]
[    2.817615] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [14]
[    2.823470] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    2.827716] evbug.c: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[    2.828278] drivers/input/serio/i8042.c: d4 -> i8042 (command) [17]
[    2.828427] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [17]
[    2.840965] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    2.845245] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    2.850682] NET: Registered protocol family 26
[    2.851071] GACT probability on
[    2.851380] Mirror/redirect action on
[    2.851709] Simple TC action Loaded
[    2.863147] netem: version 1.2
[    2.863493] u32 classifier
[    2.863789]     Actions configured 
[    2.864255] Netfilter messages via NETLINK v0.30.
[    2.869464] nf_conntrack version 0.5.0 (1024 buckets, 4096 max)
[    2.876510] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[    2.877063] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[    2.877592] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    2.884726] ctnetlink v0.93: registering with nfnetlink.
[    2.885367] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[    2.885767] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[    2.886906] xt_time: kernel timezone is -0000
[    2.890338] IPVS: Registered protocols (TCP, UDP, AH, ESP)
[    2.891202] IPVS: Connection hash table configured (size=4096, memory=32Kbytes)
[    2.893194] IPVS: ipvs loaded.
[    2.893530] IPVS: [rr] scheduler registered.
[    2.893866] IPVS: [wrr] scheduler registered.
[    2.894209] IPVS: [lc] scheduler registered.
[    2.894553] IPVS: [wlc] scheduler registered.
[    2.895386] IPVS: [lblc] scheduler registered.
[    2.896354] IPVS: [lblcr] scheduler registered.
[    2.896716] IPVS: [dh] scheduler registered.
[    2.897055] IPVS: [sh] scheduler registered.
[    2.897402] IPVS: [sed] scheduler registered.
[    2.897749] IPVS: [nq] scheduler registered.
[    2.898131] IPVS: ftp: loaded support on port[0] = 21
[    2.917272] IPv4 over IPv4 tunneling driver
[    2.947270] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.948510] ClusterIP Version 0.8 loaded successfully
[    2.949484] arp_tables: (C) 2002 David S. Miller
[    2.950860] TCP bic registered
[    2.951197] TCP cubic registered
[    2.951516] TCP westwood registered
[    2.951836] TCP highspeed registered
[    2.952299] TCP hybla registered
[    2.952620] TCP htcp registered
[    2.952936] TCP vegas registered
[    2.953256] TCP veno registered
[    2.953572] TCP scalable registered
[    2.953895] TCP lp registered
[    2.954205] TCP yeah registered
[    2.954522] TCP illinois registered
[    2.954857] NET: Registered protocol family 17
[    2.957328] Bridge firewalling registered
[    2.957755] Ebtables v2.0 registered
[    2.959008] ebt_ulog: out of memory trying to call netlink_kernel_create
[    2.963284] NET: Registered protocol family 33
[    2.965725] SCTP: Hash tables configured (established 2048 bind 4096)
[    2.982716] rtc_cmos rtc_cmos: setting system clock to 2009-06-17 18:19:35 UTC (1245262775)
[    3.028101] drivers/input/serio/i8042.c: d4 -> i8042 (command) [67]
[    3.028250] drivers/input/serio/i8042.c: ed -> i8042 (parameter) [67]
[    3.266898] EXT3-fs: INFO: recovery required on readonly filesystem.
[    3.267305] EXT3-fs: write access will be enabled during recovery.
[    6.765561] kjournald starting.  Commit interval 5 seconds
[    6.766178] EXT3-fs: recovery complete.
[    6.771396] EXT3-fs: mounted filesystem with writeback data mode.
[    6.772006] VFS: Mounted root (ext3 filesystem) readonly on device 3:3.
[    6.773487] Freeing unused kernel memory: 212k freed
[    6.782893] Write protecting the kernel text: 2440k
[    6.783611] Write protecting the kernel read-only data: 884k
[   43.454091] Adding 176672k swap on /dev/hda5.  Priority:-1 extents:1 across:176672k 
[   44.914582] EXT3 FS on hda3, internal journal
[   53.155385] kjournald starting.  Commit interval 5 seconds
[   53.157390] EXT3 FS on hda1, internal journal
[   53.157855] EXT3-fs: mounted filesystem with writeback data mode.
[   61.489031] e100 0000:00:0c.0: firmware: using built-in firmware e100/d101m_ucode.bin
[   61.891578] eth0: link down
[   63.831440] e100: eth1 NIC Link is Up 100 Mbps Full Duplex
[   72.023477] eth2:  setting full-duplex.
[  126.748847] warning: `ntpd' uses 32-bit capabilities (legacy support in use)
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
