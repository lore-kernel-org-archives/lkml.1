Return-Path: <linux-kernel-owner+w=401wt.eu-S1751381AbZDXHVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbZDXHVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbZDXHVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:21:20 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:41281 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbZDXHVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:21:17 -0400
Date: Fri, 24 Apr 2009 10:21:13 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: lockdep warning from firmware loader
Message-ID: <Pine.SOC.4.64.0904241017380.219@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This 2.6.30-rc3 running on SMP sparc64. Loading the qla1280 pci scsi 
driver causes a firmware load that in turn causes a lockdep warning like 
below. Firmware loading still seems to work fine.

Apr 23 22:20:39 korvits kernel: [    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.30 2002/10/25 14:03'
Apr 23 22:20:39 korvits kernel: [    0.000000] PROMLIB: Root node compatible: 
Apr 23 22:20:39 korvits kernel: [    0.000000] Linux version 2.6.30-rc3 (mroos@korvits) (gcc version 4.3.3 (Debian 4.3.3-4) ) #28 SMP Thu Apr 23 21:37:44 EEST 2009
Apr 23 22:20:39 korvits kernel: [    0.000000] console [earlyprom0] enabled
Apr 23 22:20:39 korvits kernel: [    0.000000] ARCH: SUN4U
Apr 23 22:20:39 korvits kernel: [    0.000000] Ethernet address: 08:00:20:b6:ee:e2
Apr 23 22:20:39 korvits kernel: [    0.000000] Kernel: Using 3 locked TLB entries for main kernel image.
Apr 23 22:20:39 korvits kernel: [    0.000000] Remapping the kernel... done.
Apr 23 22:20:39 korvits kernel: [    0.000000] OF stdout device is: /central@1f,0/fhc@0,f8800000/zs@0,902000:a
Apr 23 22:20:39 korvits kernel: [    0.000000] PROM: Built device tree with 118099 bytes of memory.
Apr 23 22:20:39 korvits kernel: [    0.000000] Top of RAM: 0x4fcea000, Total RAM: 0x4f8c6000
Apr 23 22:20:39 korvits kernel: [    0.000000] Memory hole size: 4MB
Apr 23 22:20:39 korvits kernel: [    0.000000] [0000000200000000-fffff80001000000] page_structs=131072 node=0 entry=0/0
Apr 23 22:20:39 korvits kernel: [    0.000000] [0000000200000000-fffff80001400000] page_structs=131072 node=0 entry=1/0
Apr 23 22:20:39 korvits kernel: [    0.000000] [0000000200000000-fffff80001800000] page_structs=131072 node=0 entry=2/0
Apr 23 22:20:39 korvits kernel: [    0.000000] [0000000200c00000-fffff80001c00000] page_structs=131072 node=0 entry=3/0
Apr 23 22:20:39 korvits kernel: [    0.000000] [0000000200c00000-fffff80002000000] page_structs=131072 node=0 entry=4/0
Apr 23 22:20:39 korvits kernel: [    0.000000] [0000000200c00000-fffff80002400000] page_structs=131072 node=0 entry=5/0
Apr 23 22:20:39 korvits kernel: [    0.000000] Zone PFN ranges:
Apr 23 22:20:39 korvits kernel: [    0.000000]   Normal   0x00000000 -> 0x00027e75
Apr 23 22:20:39 korvits kernel: [    0.000000] Movable zone start PFN for each node
Apr 23 22:20:39 korvits kernel: [    0.000000] early_node_map[3] active PFN ranges
Apr 23 22:20:39 korvits kernel: [    0.000000]     0: 0x00000000 -> 0x00027bef
Apr 23 22:20:39 korvits kernel: [    0.000000]     0: 0x00027e00 -> 0x00027e6a
Apr 23 22:20:39 korvits kernel: [    0.000000]     0: 0x00027e6b -> 0x00027e75
Apr 23 22:20:39 korvits kernel: [    0.000000] On node 0 totalpages: 162915
Apr 23 22:20:39 korvits kernel: [    0.000000]   Normal zone: 1916 pages used for memmap
Apr 23 22:20:39 korvits kernel: [    0.000000]   Normal zone: 0 pages reserved
Apr 23 22:20:39 korvits kernel: [    0.000000]   Normal zone: 160999 pages, LIFO batch:15
Apr 23 22:20:39 korvits kernel: [    0.000000] Booting Linux...
Apr 23 22:20:39 korvits kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 160999
Apr 23 22:20:39 korvits kernel: [    0.000000] Kernel command line: root=/dev/sda2 ro
Apr 23 22:20:39 korvits kernel: [    0.000000] RCU-based detection of stalled CPUs is enabled.
Apr 23 22:20:39 korvits kernel: [    0.000000] NR_IRQS:255
Apr 23 22:20:39 korvits kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
Apr 23 22:20:39 korvits kernel: [    0.000000] clocksource: mult[28000] shift[16]
Apr 23 22:20:39 korvits kernel: [    0.000000] clockevent: mult[66666666] shift[32]
Apr 23 22:20:39 korvits kernel: [  135.860445] Console: colour dummy device 80x25
Apr 23 22:20:39 korvits kernel: [  135.913523] console handover: boot [earlyprom0] -> real [tty0]
Apr 23 22:20:39 korvits kernel: [  135.983266] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
Apr 23 22:20:39 korvits kernel: [  135.983335] ... MAX_LOCKDEP_SUBCLASSES:  8
Apr 23 22:20:39 korvits kernel: [  135.983372] ... MAX_LOCK_DEPTH:          48
Apr 23 22:20:39 korvits kernel: [  135.983410] ... MAX_LOCKDEP_KEYS:        8191
Apr 23 22:20:39 korvits kernel: [  135.983447] ... CLASSHASH_SIZE:          4096
Apr 23 22:20:39 korvits kernel: [  135.983485] ... MAX_LOCKDEP_ENTRIES:     8192
Apr 23 22:20:39 korvits kernel: [  135.983522] ... MAX_LOCKDEP_CHAINS:      16384
Apr 23 22:20:39 korvits kernel: [  135.983560] ... CHAINHASH_SIZE:          8192
Apr 23 22:20:39 korvits kernel: [  135.983598]  memory used by lock dependency info: 4607 kB
Apr 23 22:20:39 korvits kernel: [  135.983640]  per task-struct memory footprint: 1920 bytes
Apr 23 22:20:39 korvits kernel: [  135.995004] Dentry cache hash table entries: 262144 (order: 8, 2097152 bytes)
Apr 23 22:20:39 korvits kernel: [  136.005375] Inode-cache hash table entries: 131072 (order: 7, 1048576 bytes)
Apr 23 22:20:39 korvits kernel: [  136.089691] Memory: 1262288k available (2992k kernel code, 1440k data, 160k init) [fffff80000000000,000000004fcea000]
Apr 23 22:20:39 korvits kernel: [  136.090141] SLUB: Genslabs=14, HWalign=32, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Apr 23 22:20:39 korvits kernel: [  136.233735] Calibrating delay using timer specific routine.. 803.17 BogoMIPS (lpj=4015891)
Apr 23 22:20:39 korvits kernel: [  136.234295] Mount-cache hash table entries: 512
Apr 23 22:20:39 korvits kernel: [  136.245486] CPU 7: synchronized TICK with master CPU (last diff -6 cycles, maxerr 679 cycles)
Apr 23 22:20:39 korvits kernel: [  136.245546] Brought up 2 CPUs
Apr 23 22:20:39 korvits kernel: [  136.249702] net_namespace: 2136 bytes
Apr 23 22:20:39 korvits kernel: [  136.251313] NET: Registered protocol family 16
Apr 23 22:20:39 korvits kernel: [  136.336256] fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] (Central)
Apr 23 22:20:39 korvits kernel: [  136.337076] fhc: Board #3, Version[1] PartID[fa0] Manuf[3e] (JTAG Master)
Apr 23 22:20:39 korvits kernel: [  136.337868] fhc: Board #1, Version[1] PartID[fa0] Manuf[3e] 
Apr 23 22:20:39 korvits kernel: [  136.338682] fhc: Board #5, Version[1] PartID[fa0] Manuf[3e] 
Apr 23 22:20:39 korvits kernel: [  136.339508] fhc: Board #7, Version[1] PartID[fa0] Manuf[3e] 
Apr 23 22:20:39 korvits kernel: [  136.340871] clock_board: Detected 5 slot Enterprise system.
Apr 23 22:20:39 korvits kernel: [  136.341806] SYSIO: UPA portID ffffffff, at 000001c400000000
Apr 23 22:20:39 korvits kernel: [  136.351020] SYSIO: UPA portID ffffffff, at 000001c600000000
Apr 23 22:20:39 korvits kernel: [  136.359670] SYSIO: UPA portID ffffffff, at 000001d400000000
Apr 23 22:20:39 korvits kernel: [  136.368621] SYSIO: UPA portID ffffffff, at 000001d600000000
Apr 23 22:20:39 korvits kernel: [  136.385336] /pci@e,4000: PCI IO[1dc02010000] MEM[1dd80000000]
Apr 23 22:20:39 korvits kernel: [  136.385435] /pci@e,4000: PSYCHO PCI Bus Module ver[4:0]
Apr 23 22:20:39 korvits kernel: [  136.385562] PCI: Scanning PBM /pci@e,4000
Apr 23 22:20:39 korvits kernel: [  136.389490] /pci@e,2000: PCI IO[1dc02000000] MEM[1dd00000000]
Apr 23 22:20:39 korvits kernel: [  136.389580] /pci@e,2000: PSYCHO PCI Bus Module ver[4:0]
Apr 23 22:20:39 korvits kernel: [  136.389647] PCI: Scanning PBM /pci@e,2000
Apr 23 22:20:39 korvits kernel: [  136.411094] /pci@f,4000: PCI IO[1de02010000] MEM[1df80000000]
Apr 23 22:20:39 korvits kernel: [  136.411192] /pci@f,4000: PSYCHO PCI Bus Module ver[4:0]
Apr 23 22:20:39 korvits kernel: [  136.411259] PCI: Scanning PBM /pci@f,4000
Apr 23 22:20:39 korvits kernel: [  136.414109] /pci@f,2000: PCI IO[1de02000000] MEM[1df00000000]
Apr 23 22:20:39 korvits kernel: [  136.414197] /pci@f,2000: PSYCHO PCI Bus Module ver[4:0]
Apr 23 22:20:39 korvits kernel: [  136.414308] PCI: Scanning PBM /pci@f,2000
Apr 23 22:20:39 korvits kernel: [  136.447308] bio: create slab <bio-0> at 0
Apr 23 22:20:39 korvits kernel: [  136.452479] SCSI subsystem initialized
Apr 23 22:20:39 korvits kernel: [  136.507705] /central/fhc@0,f8800000/eeprom@0,908000: Mostek regs at 0x1fff8908000
Apr 23 22:20:39 korvits kernel: [  136.514593] Switched to high resolution mode on CPU 6
Apr 23 22:20:39 korvits kernel: [  136.515110] Switched to high resolution mode on CPU 7
Apr 23 22:20:39 korvits kernel: [  136.521795] NET: Registered protocol family 2
Apr 23 22:20:39 korvits kernel: [  136.650031] IP route cache hash table entries: 65536 (order: 6, 524288 bytes)
Apr 23 22:20:39 korvits kernel: [  136.654024] TCP established hash table entries: 262144 (order: 9, 4194304 bytes)
Apr 23 22:20:39 korvits kernel: [  136.675021] TCP bind hash table entries: 65536 (order: 8, 3670016 bytes)
Apr 23 22:20:39 korvits kernel: [  136.732059] TCP: Hash tables configured (established 262144 bind 65536)
Apr 23 22:20:39 korvits kernel: [  136.732258] TCP reno registered
Apr 23 22:20:39 korvits kernel: [  136.760504] NET: Registered protocol family 1
Apr 23 22:20:39 korvits kernel: [  136.790159] HugeTLB registered 4 MB page size, pre-allocated 0 pages
Apr 23 22:20:39 korvits kernel: [  136.860238] msgmni has been set to 2466
Apr 23 22:20:39 korvits kernel: [  136.863826] alg: No test for stdrng (krng)
Apr 23 22:20:39 korvits kernel: [  136.865496] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Apr 23 22:20:39 korvits kernel: [  136.865652] io scheduler noop registered
Apr 23 22:20:39 korvits kernel: [  136.865712] io scheduler anticipatory registered
Apr 23 22:20:39 korvits kernel: [  136.865774] io scheduler deadline registered
Apr 23 22:20:39 korvits kernel: [  136.865987] io scheduler cfq registered (default)
Apr 23 22:20:39 korvits kernel: [  137.124333] f005de3c: ttyS0 at MMIO 0x1fff8902000 (irq = 2) is a zs (ESCC)
Apr 23 22:20:39 korvits kernel: [  137.124462] Console: ttyS0 (SunZilog zs0)
Apr 23 22:20:39 korvits kernel: [  137.124826] console [ttyS0] enabled
Apr 23 22:20:39 korvits kernel: [  143.465091] f005de3c: ttyS1 at MMIO 0x1fff8902004 (irq = 2) is a zs (ESCC)
Apr 23 22:20:39 korvits kernel: [  143.754783] f005df14: Keyboard at MMIO 0x1fff8904000 (irq = 2) is a zs
Apr 23 22:20:39 korvits kernel: [  143.830877] f005df14: Mouse at MMIO 0x1fff8904004 (irq = 2) is a zs
Apr 23 22:20:39 korvits kernel: [  143.912020] qla1280: QLA1040 found on PCI bus 0, dev 3
Apr 23 22:20:39 korvits kernel: [  143.971811] PCI: Enabling device: (0002:00:03.0), cmd 7
Apr 23 22:20:39 korvits kernel: [  143.972842] ------------[ cut here ]------------
Apr 23 22:20:39 korvits kernel: [  144.026699] WARNING: at kernel/lockdep.c:2280 lockdep_trace_alloc+0xbc/0x100()
Apr 23 22:20:39 korvits kernel: [  144.113197] Modules linked in:
Apr 23 22:20:39 korvits kernel: [  144.149622] Call Trace:
Apr 23 22:20:39 korvits kernel: [  144.178818]  [000000000045d7cc] warn_slowpath+0x6c/0xa0
Apr 23 22:20:39 korvits kernel: [  144.241329]  [00000000004886fc] lockdep_trace_alloc+0xbc/0x100
Apr 23 22:20:39 korvits kernel: [  144.311140]  [00000000004e67b8] kmem_cache_alloc+0x18/0x160
Apr 23 22:20:39 korvits kernel: [  144.377821]  [0000000000604d68] _request_firmware+0x28/0x520
Apr 23 22:20:39 korvits kernel: [  144.445533]  [000000000060531c] request_firmware+0x1c/0x40
Apr 23 22:20:39 korvits kernel: [  144.511180]  [000000000061ba98] qla1280_load_firmware+0x2f8/0x7e0
Apr 23 22:20:39 korvits kernel: [  144.584108]  [00000000006e1498] qla1280_probe_one+0x390/0x7a8
Apr 23 22:20:39 korvits kernel: [  144.652874]  [00000000005ce55c] local_pci_probe+0x1c/0x40
Apr 23 22:20:39 korvits kernel: [  144.717468]  [00000000005ce8e0] pci_device_probe+0x60/0xa0
Apr 23 22:20:39 korvits kernel: [  144.783106]  [00000000005fff78] driver_probe_device+0x78/0x1a0
Apr 23 22:20:39 korvits kernel: [  144.852911]  [000000000060012c] __driver_attach+0x8c/0xa0
Apr 23 22:20:39 korvits kernel: [  144.917505]  [00000000005ff6c8] bus_for_each_dev+0x68/0xa0
Apr 23 22:20:39 korvits kernel: [  144.983141]  [00000000005ffde0] driver_attach+0x20/0x40
Apr 23 22:20:39 korvits kernel: [  145.045657]  [00000000005fee64] bus_add_driver+0x104/0x280
Apr 23 22:20:39 korvits kernel: [  145.111292]  [0000000000600454] driver_register+0x74/0x180
Apr 23 22:20:39 korvits kernel: [  145.176928]  [00000000005cedb4] __pci_register_driver+0x54/0xe0
Apr 23 22:20:39 korvits kernel: [  145.247808] ---[ end trace 6edbdc497698d192 ]---
Apr 23 22:20:39 korvits kernel: [  145.302997] qla1280 0002:00:03.0: firmware: using built-in firmware qlogic/1040.bin
Apr 23 22:20:39 korvits kernel: [  146.350571] scsi(0:0): Resetting SCSI BUS
Apr 23 22:20:39 korvits kernel: [  149.404605] scsi0 : QLogic QLA1040 PCI to SCSI Host Adapter
Apr 23 22:20:39 korvits kernel: [  149.404619]        Firmware version:  7.65.06, Driver version 3.26
Apr 23 22:20:39 korvits kernel: [  149.880960] scsi 0:0:2:0: Direct-Access     IBM      DDYS-T18350M     S96H PQ: 0 ANSI: 3
Apr 23 22:20:39 korvits kernel: [  149.976584] scsi(0:0:2:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
Apr 23 22:20:39 korvits kernel: [  150.074129] scsi 0:0:3:0: Direct-Access     IBM      DDYS-T18350M     S93E PQ: 0 ANSI: 3
Apr 23 22:20:39 korvits kernel: [  150.169821] scsi(0:0:3:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
Apr 23 22:20:39 korvits kernel: [  150.434307] scsi 0:0:5:0: Direct-Access     IBM      DDYS-T18350M     S80D PQ: 0 ANSI: 3
Apr 23 22:20:39 korvits kernel: [  150.529991] scsi(0:0:5:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
Apr 23 22:20:39 korvits kernel: [  151.135652] scsi 0:0:10:0: Direct-Access     HP       9.10GB A 80-6331      PQ: 0 ANSI: 2
Apr 23 22:20:39 korvits kernel: [  151.232355] scsi(0:0:10:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
Apr 23 22:20:39 korvits kernel: [  151.335854] scsi 0:0:11:0: Direct-Access     IBM      DDRS-34560D      DC1B PQ: 0 ANSI: 2
Apr 23 22:20:39 korvits kernel: [  151.432481] scsi(0:0:11:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
Apr 23 22:20:39 korvits kernel: [  151.545009] scsi 0:0:12:0: Direct-Access     HP       4.26GB A 80-0430 0430 PQ: 0 ANSI: 2
Apr 23 22:20:39 korvits kernel: [  151.641697] scsi(0:0:12:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
Apr 23 22:20:39 korvits kernel: [  151.757666] scsi 0:0:13:0: Direct-Access     HP       2.13GB A 80-0430 0430 PQ: 0 ANSI: 2
Apr 23 22:20:39 korvits kernel: [  151.854369] scsi(0:0:13:0): Sync: period 10, offset 12, Wide, Tagged queuing: depth 31
Apr 23 22:20:39 korvits kernel: [  152.293832] esp: esp0, regs[1c738810000:1c738800000] irq[20]
Apr 23 22:20:39 korvits kernel: [  152.359573] esp: esp0 is a FASHME, 40 MHz (ccf=0), SCSI ID 7
Apr 23 22:20:39 korvits kernel: [  155.434625] scsi1 : esp
Apr 23 22:20:39 korvits kernel: [  156.873116] scsi 1:0:6:0: CD-ROM            TOSHIBA  XM6201TASUN32XCD 1103 PQ: 0 ANSI: 2
Apr 23 22:20:39 korvits kernel: [  156.968147] scsi target1:0:6: Beginning Domain Validation
Apr 23 22:20:39 korvits kernel: [  157.034401] scsi target1:0:6: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
Apr 23 22:20:39 korvits kernel: [  157.116992] scsi target1:0:6: Domain Validation skipping write tests
Apr 23 22:20:39 korvits kernel: [  157.192055] scsi target1:0:6: Ending Domain Validation
Apr 23 22:20:39 korvits kernel: [  159.131042] esp: esp1, regs[1d738810000:1d738800000] irq[38]
Apr 23 22:20:39 korvits kernel: [  159.196728] esp: esp1 is a FASHME, 40 MHz (ccf=0), SCSI ID 7
Apr 23 22:20:39 korvits kernel: [  162.264621] scsi2 : esp
Apr 23 22:20:39 korvits kernel: [  165.806218] Driver 'sd' needs updating - please use bus_type methods
Apr 23 22:20:39 korvits kernel: [  165.881855] sunhme.c:v3.10 August 26, 2008 David S. Miller (davem@davemloft.net)
Apr 23 22:20:39 korvits kernel: [  165.970936] eth0: HAPPY MEAL (SBUS) 10/100baseT Ethernet 08:00:20:b6:ee:e2
Apr 23 22:20:39 korvits kernel: [  166.052670] sd 0:0:3:0: [sdb] 35843670 512-byte hardware sectors: (18.3 GB/17.0 GiB)
Apr 23 22:20:39 korvits kernel: [  166.144762] eth1: Quattro HME slot 0 (SBUS) 10/100baseT Ethernet <5>sd 0:0:5:0: [sdc] 35843670 512-byte hardware sectors: (18.3 GB/17.0 GiB)
Apr 23 22:20:39 korvits kernel: [  166.215260] 08:00:20:93:79:94
Apr 23 22:20:39 korvits kernel: [  166.295728] sd 0:0:13:0: [sdg] 4165272 512-byte hardware sectors: (2.13 GB/1.98 GiB)
Apr 23 22:20:39 korvits kernel: [  166.295902] sd 0:0:12:0: [sdf] 8330543 512-byte hardware sectors: (4.26 GB/3.97 GiB)
Apr 23 22:20:39 korvits kernel: [  166.330686] sd 0:0:2:0: [sda] 35843670 512-byte hardware sectors: (18.3 GB/17.0 GiB)
Apr 23 22:20:39 korvits kernel: [  166.330781] sd 0:0:12:0: [sdf] Write Protect is off
Apr 23 22:20:39 korvits kernel: [  166.330805] sd 0:0:12:0: [sdf] Mode Sense: 9f 00 10 08
Apr 23 22:20:39 korvits kernel: [  166.330889] sd 0:0:13:0: [sdg] Write Protect is off
Apr 23 22:20:39 korvits kernel: [  166.330912] sd 0:0:13:0: [sdg] Mode Sense: 9f 00 10 08
Apr 23 22:20:39 korvits kernel: [  166.423399] sd 0:0:2:0: [sda] Write Protect is off
Apr 23 22:20:39 korvits kernel: [  166.423422] sd 0:0:2:0: [sda] Mode Sense: cb 00 00 08
Apr 23 22:20:39 korvits kernel: [  166.516194] sd 0:0:12:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
Apr 23 22:20:39 korvits kernel: [  166.516565] sd 0:0:13:0: [sdg] Write cache: disabled, read cache: enabled, supports DPO and FUA
Apr 23 22:20:39 korvits kernel: [  166.608830] sd 0:0:2:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr 23 22:20:39 korvits kernel: [  166.848512]  sdg:<6> sdf:<6> sda: unknown partition table
Apr 23 22:20:39 korvits kernel: [  167.347531]  unknown partition table
Apr 23 22:20:39 korvits kernel: [  167.347559] sd 0:0:10:0: [sdd] 17773524 512-byte hardware sectors: (9.10 GB/8.47 GiB)
Apr 23 22:20:39 korvits kernel: [  167.347676] sd 0:0:11:0: [sde] 8925000 512-byte hardware sectors: (4.56 GB/4.25 GiB)
Apr 23 22:20:39 korvits kernel: [  167.347781] sd 0:0:3:0: [sdb] Write Protect is off
Apr 23 22:20:39 korvits kernel: [  167.347806] sd 0:0:3:0: [sdb] Mode Sense: cb 00 00 08
Apr 23 22:20:39 korvits kernel: [  167.694499] sd 0:0:5:0: [sdc] Write Protect is off
Apr 23 22:20:39 korvits kernel: [  167.751623] sd 0:0:5:0: [sdc] Mode Sense: cb 00 00 08
Apr 23 22:20:39 korvits kernel: [  167.752114]  sda1 sda2 sda3 sda4
Apr 23 22:20:39 korvits kernel: [  167.850705] sd 0:0:11:0: [sde] Write Protect is off
Apr 23 22:20:39 korvits kernel: [  167.908942] sd 0:0:11:0: [sde] Mode Sense: b9 00 00 08
Apr 23 22:20:39 korvits kernel: [  167.970585] sd 0:0:10:0: [sdd] Write Protect is off
Apr 23 22:20:39 korvits kernel: [  167.970632] eth2: Quattro HME slot 1 (SBUS) 10/100baseT Ethernet 08:00:20:93:79:95
Apr 23 22:20:39 korvits kernel: [  168.119431] sd 0:0:10:0: [sdd] Mode Sense: 9f 00 10 08
Apr 23 22:20:39 korvits kernel: [  168.180959] sd 0:0:3:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Apr 23 22:20:39 korvits kernel: [  168.181267] eth3: Quattro HME slot 2 (SBUS) 10/100baseT Ethernet 08:00:20:93:79:96
Apr 23 22:20:39 korvits kernel: [  168.291052] sd 0:0:13:0: [sdg] Attached SCSI disk
Apr 23 22:20:39 korvits kernel: [  168.381033] sd 0:0:12:0: [sdf] Attached SCSI disk
Apr 23 22:20:39 korvits kernel: [  168.437426] sd 0:0:2:0: [sda] Attached SCSI disk
Apr 23 22:20:39 korvits kernel: [  168.437715] eth4: Quattro HME slot 3 (SBUS) 10/100baseT Ethernet 08:00:20:93:79:97
Apr 23 22:20:39 korvits kernel: [  168.494253] sd 0:0:5:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr 23 22:20:39 korvits kernel: [  168.548831] sd 0:0:10:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
Apr 23 22:20:39 korvits kernel: [  168.549561] eth5: HAPPY MEAL (SBUS) 10/100baseT Ethernet 08:00:20:b6:ee:e2
Apr 23 22:20:39 korvits kernel: [  168.747868] PCI: Enabling device: (0000:00:01.1), cmd 2
Apr 23 22:20:39 korvits kernel: [  168.934379] eth6: HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet 08:00:20:b6:ee:e2
Apr 23 22:20:39 korvits kernel: [  168.934474] PCI: Enabling device: (0001:81:00.1), cmd 2
Apr 23 22:20:39 korvits kernel: [  169.086471] eth7-10: Quattro HME (PCI/CheerIO) 10/100baseT Ethernet DEC 21153 PCI Bridge
Apr 23 22:20:39 korvits kernel: [  169.086497] eth7: Quattro HME slot 0 (PCI/CheerIO) 10/100baseT Ethernet 08:00:20:f4:5a:90
Apr 23 22:20:39 korvits kernel: [  169.086586] PCI: Enabling device: (0001:81:01.1), cmd 2
Apr 23 22:20:39 korvits kernel: [  169.149549]  sdc:<6>eth8: Quattro HME slot 1 (PCI/CheerIO) 10/100baseT Ethernet 08:00:20:f4:5a:91
Apr 23 22:20:39 korvits kernel: [  169.245988] PCI: Enabling device: (0001:81:02.1), cmd 2
Apr 23 22:20:39 korvits kernel: [  169.344498]  sdd: sdc3
Apr 23 22:20:39 korvits kernel: [  169.603853] eth9: Quattro HME slot 2 (PCI/CheerIO) 10/100baseT Ethernet <5>sd 0:0:11:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr 23 22:20:39 korvits kernel: [  169.681441] 08:00:20:f4:5a:92
Apr 23 22:20:39 korvits kernel: [  169.681526] PCI: Enabling device: (0001:81:03.1), cmd 2
Apr 23 22:20:39 korvits kernel: [  169.778639]  unknown partition table
Apr 23 22:20:39 korvits kernel: [  169.919613] eth10: Quattro HME slot 3 (PCI/CheerIO) 10/100baseT Ethernet 08:00:20:f4:5a:93
Apr 23 22:20:39 korvits kernel: [  170.018882] sd 0:0:5:0: [sdc] Attached SCSI disk
Apr 23 22:20:39 korvits kernel: [  170.073142] sd 0:0:10:0: [sdd] Attached SCSI disk
Apr 23 22:20:39 korvits kernel: [  170.129945] mice: PS/2 mouse device common for all mice
Apr 23 22:20:39 korvits kernel: [  170.192011]  sdb:<6>rtc-m48t59 rtc-m48t59.0: rtc core: registered m48t59 as rtc0
Apr 23 22:20:39 korvits kernel: [  170.283094]  sde: unknown partition table
Apr 23 22:20:39 korvits kernel: [  170.331348]  unknown partition table
Apr 23 22:20:39 korvits kernel: [  170.373733] sd 0:0:3:0: [sdb] Attached SCSI disk
Apr 23 22:20:39 korvits kernel: [  170.375024] sd 0:0:11:0: [sde] Attached SCSI disk
Apr 23 22:20:39 korvits kernel: [  170.486400] TCP cubic registered
Apr 23 22:20:39 korvits kernel: [  170.523100] NET: Registered protocol family 17
Apr 23 22:20:39 korvits kernel: [  170.577665] registered taskstats version 1
Apr 23 22:20:39 korvits kernel: [  170.626128] rtc-m48t59 rtc-m48t59.0: setting system clock to 2009-04-23 19:13:21 UTC (1240514001)
Apr 23 22:20:39 korvits kernel: [  171.224001] kjournald starting.  Commit interval 5 seconds
Apr 23 22:20:39 korvits kernel: [  171.287691] EXT3-fs: mounted filesystem with writeback data mode.
Apr 23 22:20:39 korvits kernel: [  171.360607] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
Apr 23 22:20:39 korvits kernel: [  174.169058] Driver 'sr' needs updating - please use bus_type methods
Apr 23 22:20:39 korvits kernel: [  174.365971] sr0: scsi-1 drive
Apr 23 22:20:39 korvits kernel: [  174.399641] Uniform CD-ROM driver Revision: 3.20
Apr 23 22:20:39 korvits kernel: [  174.455436] sr 1:0:6:0: Attached scsi CD-ROM sr0
Apr 23 22:20:39 korvits kernel: [  174.831844] PCI: Enabling device: (0003:80:02.0), cmd 3
Apr 23 22:20:39 korvits kernel: [  175.369282] sd 0:0:2:0: Attached scsi generic sg0 type 0
Apr 23 22:20:39 korvits kernel: [  175.431179] sd 0:0:3:0: Attached scsi generic sg1 type 0
Apr 23 22:20:39 korvits kernel: [  175.494837] sd 0:0:5:0: Attached scsi generic sg2 type 0
Apr 23 22:20:39 korvits kernel: [  175.558275] sd 0:0:10:0: Attached scsi generic sg3 type 0
Apr 23 22:20:39 korvits kernel: [  175.623753] sd 0:0:11:0: Attached scsi generic sg4 type 0
Apr 23 22:20:39 korvits kernel: [  175.688045] sd 0:0:12:0: Attached scsi generic sg5 type 0
Apr 23 22:20:39 korvits kernel: [  175.752637] sd 0:0:13:0: Attached scsi generic sg6 type 0
Apr 23 22:20:39 korvits kernel: [  175.817118] sr 1:0:6:0: Attached scsi generic sg7 type 5
Apr 23 22:20:39 korvits kernel: [  180.502110] scsi3 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
Apr 23 22:20:39 korvits kernel: [  180.502125]         <Adaptec 29320ALP PCIx Ultra320 SCSI adapter>
Apr 23 22:20:39 korvits kernel: [  180.502138]         aic7901: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66MHz, 512 SCBs
Apr 23 22:20:39 korvits kernel: [  266.387320] Adding 787168k swap on /dev/sda4.  Priority:-1 extents:1 across:787168k 
Apr 23 22:20:39 korvits kernel: [  266.830492] EXT3 FS on sda2, internal journal
Apr 23 22:20:39 korvits kernel: [  268.356655] kjournald starting.  Commit interval 5 seconds
Apr 23 22:20:39 korvits kernel: [  268.420896] EXT3 FS on sda1, internal journal
Apr 23 22:20:39 korvits kernel: [  268.472437] EXT3-fs: mounted filesystem with writeback data mode.

config:
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.30-rc3
# Thu Apr 23 20:31:01 2009
#
CONFIG_64BIT=y
CONFIG_SPARC=y
# CONFIG_SPARC32 is not set
CONFIG_SPARC64=y
CONFIG_ARCH_DEFCONFIG="arch/sparc/configs/sparc64_defconfig"
CONFIG_BITS=64
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_IOMMU_HELPER=y
CONFIG_QUICKLIST=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_AUDIT_ARCH=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_MMU=y
CONFIG_ARCH_NO_VIRT_TO_BUS=y
CONFIG_OF=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=16
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_STRIP_ASM_SYMS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=m
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_SYSCALL_WRAPPERS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
# CONFIG_SLOW_WORK is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_SMP=y
CONFIG_NR_CPUS=8
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_SPARC64_SMP=y
CONFIG_SPARC64_PAGE_SIZE_8KB=y
# CONFIG_SPARC64_PAGE_SIZE_64KB is not set
# CONFIG_SECCOMP is not set
CONFIG_HOTPLUG_CPU=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_CPU_FREQ is not set
# CONFIG_US3_MC is not set
CONFIG_HUGETLB_PAGE_SIZE_4MB=y
# CONFIG_HUGETLB_PAGE_SIZE_512K is not set
# CONFIG_HUGETLB_PAGE_SIZE_64K is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_NR_QUICK=1
CONFIG_UNEVICTABLE_LRU=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
# CONFIG_CMDLINE_BOOL is not set

#
# Bus options (PCI etc.)
#
CONFIG_SBUS=y
CONFIG_SBUSCHAR=y
# CONFIG_SUN_LDOMS is not set
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_SYSCALL=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_PCI_IOV=y
# CONFIG_PCCARD is not set
CONFIG_SUN_OPENPROMFS=m
CONFIG_SPARC64_PCI=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COMPAT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
# CONFIG_NETFILTER_XT_MATCH_PHYSDEV is not set
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
# CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_TCPPROBE=m
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
CONFIG_OF_DEVICE=y
CONFIG_PARPORT=m
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_SUNBPP=m
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_93CX6 is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=253
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=m
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_ARCMSR=m
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
# CONFIG_SCSI_MPT2SAS is not set
CONFIG_SCSI_HPTIOP=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
CONFIG_SCSI_DMX3191D=m
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_MVSAS=m
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=0
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLOGICPTI=m
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_LPFC=m
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=m
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_SUNESP=y
CONFIG_SCSI_SRP=m
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=m
CONFIG_ATA_PIIX=m
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SX4=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m
CONFIG_SATA_INIC162X=m
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_CMD640_PCI=m
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=m
CONFIG_PATA_CS5530=m
CONFIG_PATA_CYPRESS=m
CONFIG_PATA_EFAR=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
CONFIG_PATA_HPT3X3_DMA=y
CONFIG_PATA_IT821X=m
CONFIG_PATA_IT8213=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_TRIFLEX=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_MPIIX=m
CONFIG_PATA_OLDPIIX=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
CONFIG_PATA_NS87410=m
CONFIG_PATA_NS87415=m
CONFIG_PATA_OPTI=m
CONFIG_PATA_OPTIDMA=m
CONFIG_PATA_PDC_OLD=m
CONFIG_PATA_RADISYS=m
CONFIG_PATA_RZ1000=m
CONFIG_PATA_SC1200=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
CONFIG_PATA_VIA=m
CONFIG_PATA_WINBOND=m
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID6_PQ=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LAN=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
# CONFIG_IEEE1394 is not set
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
CONFIG_NETDEVICES=y
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_IFB=m
# CONFIG_DUMMY is not set
CONFIG_BONDING=m
CONFIG_MACVLAN=m
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
CONFIG_SUNLANCE=m
CONFIG_HAPPYMEAL=y
CONFIG_SUNBMAC=m
CONFIG_SUNQE=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_TULIP=m
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=m
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=m
CONFIG_FORCEDETH_NAPI=y
CONFIG_E100=m
CONFIG_FEALNX=m
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=m
CONFIG_8139CP=m
CONFIG_8139TOO=m
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R6040=m
CONFIG_SIS900=m
CONFIG_EPIC100=m
# CONFIG_SMSC9420 is not set
CONFIG_SUNDANCE=m
CONFIG_SUNDANCE_MMIO=y
CONFIG_TLAN=m
CONFIG_VIA_RHINE=m
CONFIG_VIA_RHINE_MMIO=y
CONFIG_SC92031=m
# CONFIG_NET_POCKET is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
# CONFIG_DL2K is not set
CONFIG_E1000=m
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_MYRI_SBUS is not set
CONFIG_NS83820=m
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
CONFIG_SIS190=m
CONFIG_SKGE=m
CONFIG_SKGE_DEBUG=y
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=m
CONFIG_BNX2=m
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
CONFIG_TR=m
CONFIG_IBMOL=m
CONFIG_3C359=m
CONFIG_TMS380TR=m
CONFIG_TMSPCI=m
CONFIG_ABYSS=m

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=m
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_IDT77252=m
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_IA=m
# CONFIG_ATM_IA_DEBUG is not set
CONFIG_ATM_FORE200E=m
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=m
CONFIG_ATM_HE_USE_SUNI=y
# CONFIG_ATM_SOLOS is not set
CONFIG_FDDI=m
CONFIG_DEFXX=m
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=m
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_NET_FC=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ATKBD is not set
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_SPARCSPKR=y
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=m
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_SUNCORE=y
CONFIG_SERIAL_SUNZILOG=y
CONFIG_SERIAL_SUNZILOG_CONSOLE=y
CONFIG_SERIAL_SUNSU=y
CONFIG_SERIAL_SUNSU_CONSOLE=y
CONFIG_SERIAL_SUNSAB=y
CONFIG_SERIAL_SUNSAB_CONSOLE=y
# CONFIG_SERIAL_SUNHV is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_TCG_TPM is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
# CONFIG_THERMAL is not set
# CONFIG_THERMAL_HWMON is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
# CONFIG_PROM_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_SUN4V=y
CONFIG_RTC_DRV_STARFIRE=y
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set

#
# Misc Linux/SPARC drivers
#
CONFIG_SUN_OPENPROMIO=m
CONFIG_OBP_FLASH=m
# CONFIG_TADPOLE_TS102_UCTRL is not set
# CONFIG_BBC_I2C is not set
# CONFIG_ENVCTRL is not set
# CONFIG_DISPLAY7SEG is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
# CONFIG_EXT4DEV_COMPAT is not set
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=775
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=m
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=m
# CONFIG_ROMFS_FS is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
CONFIG_EXOFS_FS=m
# CONFIG_EXOFS_DEBUG is not set
CONFIG_NILFS2_FS=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
# CONFIG_NFS_V4 is not set
# CONFIG_NFSD is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
# CONFIG_RPCSEC_GSS_KRB5 is not set
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-15"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_DETECTOR=y
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y

#
# Tracers
#
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_EVENT_TRACER is not set
# CONFIG_BOOT_TRACER is not set
# CONFIG_TRACE_BRANCH_PROFILING is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_KMEMTRACE is not set
# CONFIG_WORKQUEUE_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_DCFLUSH is not set
CONFIG_STACK_DEBUG=y
CONFIG_MCOUNT=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_HW is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_HAVE_LMB=y
CONFIG_NLATTR=y

-- 
Meelis Roos (mroos@linux.ee)
