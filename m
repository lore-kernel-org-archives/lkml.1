Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbZIAHFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbZIAHFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 03:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbZIAHFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 03:05:03 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:34137 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbZIAHFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 03:05:01 -0400
Date: Tue, 1 Sep 2009 10:05:02 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>, tj@kernel.org
Subject: Re: boot panic after oops from sysfs_new_dirent
In-Reply-To: <20090831.142215.111904849.davem@davemloft.net>
Message-ID: <Pine.SOC.4.64.0909011003460.10184@math.ut.ee>
References: <Pine.SOC.4.64.0908311646150.20934@math.ut.ee>
 <20090831.142215.111904849.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I powered on my 6-CPU E3000 after a summer pause and tried todays 
> > 2.6.31-rc8+git on it. It fails - first it spills lots of warnings about 
> > percpu things, then oopses in sysfs_new_dirent and then panics.

Bisecting shows that there may be different crashes, like in
56513ed50cc8a5c184a3f347e81d74c850cc14fa below:

3,0>ERROR: TEST=NVRAM Devices,SUBTEST=M48T59 (TOD) Init ID=8.1
3,0>Component under test: Board 16 Firehose Bus
3,0>TODC battery is low bit set
Detected failed TOD on clock board. Using backup TOD on board in slot 1 
fhc ac simm-status environment sram flashprom SUNW,UltraSPARC-II SUNW,UltraSPARC-II 
fhc ac simm-status environment sram flashprom SUNW,UltraSPARC-II SUNW,UltraSPARC-II 
fhc ac simm-status environment sram flashprom SUNW,UltraSPARC-II SUNW,UltraSPARC-II 
Probing UPA Slot at 2,0   sbus fhc ac environment flashprom eeprom sbus-speed counter-timer 
Probing UPA Slot at 3,0   sbus counter-timer 
Probing /sbus@2,0 at d,0  SUNW,soc 
Probing /sbus@2,0 at 1,0  SUNW,socal sf ssd sf ssd 
Probing /sbus@2,0 at 2,0  QLGC,isp sd st 
Probing /sbus@3,0 at 3,0  SUNW,hme SUNW,fas sd st 
Probing /sbus@3,0 at 0,0  SUNW,qfe SUNW,qfe SUNW,qfe SUNW,qfe 
4-slot Sun Enterprise 3000, No Keyboard
OpenBoot 3.2.29, 3584 MB memory installed, Serial #8631214.
Copyright 2001 Sun Microsystems, Inc.  All rights reserved
Ethernet address 8:0:20:83:b3:ae, Host ID: 8083b3ae.



Boot device: disk  File and args: 
SILO Version 1.4.13
boot: 
Linux                    LinuxOLD                 test                     
hea                      
boot: test console=ttyS0
Allocated 8 Megs of memory at 0x40000000 for kernel
Uncompressing image...
Loaded kernel version 2.6.30

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.29 2001/06/18 17:28'
[    0.000000] PROMLIB: Root node compatible: 
[    0.000000] Linux version 2.6.30 (mroos@mandel) (gcc version 4.3.4 (Debian 4.3.4-2) ) #12 SMP Mon Aug 31 18:04:20 EEST 2009
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] console [earlyprom0] enabled
[    0.000000] ARCH: SUN4U
[    0.000000] Ethernet address: 08:00:20:83:b3:ae
[    0.000000] Kernel: Using 4 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /central@1f,0/fhc@0,f8800000/zs@0,902000:a
[    0.000000] PROM: Built device tree with 70462 bytes of memory.
[    0.000000] Top of RAM: 0xdfd14000, Total RAM: 0xdf960000
[    0.000000] Memory hole size: 3MB
[    0.000000] [0000000200000000-fffff80001400000] page_structs=131072 node=0 entry=0/0
[    0.000000] [0000000200000000-fffff80001800000] page_structs=131072 node=0 entry=1/0
[    0.000000] [0000000200000000-fffff80001c00000] page_structs=131072 node=0 entry=2/0
[    0.000000] [0000000200c00000-fffff80002000000] page_structs=131072 node=0 entry=3/0
[    0.000000] [0000000200c00000-fffff80002400000] page_structs=131072 node=0 entry=4/0
[    0.000000] [0000000200c00000-fffff80002800000] page_structs=131072 node=0 entry=5/0
[    0.000000] [0000000201800000-fffff80002c00000] page_structs=131072 node=0 entry=6/0
[    0.000000] [0000000201800000-fffff80003000000] page_structs=131072 node=0 entry=7/0
[    0.000000] [0000000201800000-fffff80003400000] page_structs=131072 node=0 entry=8/0
[    0.000000] [0000000202400000-fffff80003800000] page_structs=131072 node=0 entry=9/0
[    0.000000] [0000000202400000-fffff80003c00000] page_structs=131072 node=0 entry=10/0
[    0.000000] [0000000202400000-fffff80004000000] page_structs=131072 node=0 entry=11/0
[    0.000000] Zone PFN ranges:
[    0.000000]   Normal   0x00000000 -> 0x0006fe8a
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0006fc27
[    0.000000]     0: 0x0006fe00 -> 0x0006fe7f
[    0.000000]     0: 0x0006fe80 -> 0x0006fe8a
[    0.000000] On node 0 totalpages: 457904
[    0.000000]   Normal zone: 5372 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 452532 pages, LIFO batch:15
[    0.000000] Booting Linux...
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 452532
[    0.000000] Kernel command line: root=/dev/sda2 ro debug ignore_loglevel console=ttyS0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 9, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 8, 2097152 bytes)
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at kernel/lockdep.c:2282 lockdep_trace_alloc+0xb8/0x100()
[    0.000000] Modules linked in:
[    0.000000] Call Trace:
[    0.000000]  [000000000045ec50] warn_slowpath_common+0x50/0xa0
[    0.000000]  [000000000045ecbc] warn_slowpath_null+0x1c/0x40
[    0.000000]  [0000000000488cb8] lockdep_trace_alloc+0xb8/0x100
[    0.000000]  [00000000004a7334] __alloc_pages_internal+0x34/0x4a0
[    0.000000]  [00000000008438bc] mem_init+0x244/0x32c
[    0.000000]  [000000000083e7b4] start_kernel+0x18c/0x334
[    0.000000]  [00000000006c2204] tlb_fixup_done+0xa0/0xbc
[    0.000000]  [0000000000000000] (null)
[    0.000000] ---[ end trace 139ce121c98e96c9 ]---
[    0.000000] Memory: 3593504k available (2888k kernel code, 1392k data, 152k init) [fffff80000000000,00000000dfd14000]
[    0.000000] SLUB: Genslabs=14, HWalign=32, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:255
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at mm/bootmem.c:535 alloc_arch_preferred_bootmem+0x48/0x5c()
[    0.000000] Modules linked in:
[    0.000000] Call Trace:
[    0.000000]  [000000000045ec50] warn_slowpath_common+0x50/0xa0
[    0.000000]  [000000000045ecbc] warn_slowpath_null+0x1c/0x40
[    0.000000]  [0000000000846ff0] alloc_arch_preferred_bootmem+0x48/0x5c
[    0.000000]  [000000000084781c] ___alloc_bootmem_nopanic+0x20/0xcc
[    0.000000]  [00000000008479ac] ___alloc_bootmem+0x10/0x44
[    0.000000]  [0000000000847b70] __alloc_bootmem+0x10/0x20
[    0.000000]  [000000000083f5bc] init_IRQ+0xc0/0x2b0
[    0.000000]  [000000000083e7f0] start_kernel+0x1c8/0x334
[    0.000000]  [00000000006c2204] tlb_fixup_done+0xa0/0xbc
[    0.000000]  [0000000000000000] (null)
[    0.000000] ---[ end trace 139ce121c98e96ca ]---
[    0.000000] clocksource: mult[40842] shift[16]
[    0.000000] clockevent: mult[3f7ced91] shift[32]
[  125.625114] Console: colour dummy device 80x25
[  125.678129] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[  125.770812] ... MAX_LOCKDEP_SUBCLASSES:  8
[  125.819774] ... MAX_LOCK_DEPTH:          48
[  125.869784] ... MAX_LOCKDEP_KEYS:        8191
[  125.921874] ... CLASSHASH_SIZE:          4096
[  125.973966] ... MAX_LOCKDEP_ENTRIES:     16384
[  126.027100] ... MAX_LOCKDEP_CHAINS:      32768
[  126.080233] ... CHAINHASH_SIZE:          16384
[  126.133367]  memory used by lock dependency info: 5695 kB
[  126.197958]  per task-struct memory footprint: 1920 bytes
[  126.412806] Calibrating delay using timer specific routine.. 498.27 BogoMIPS (lpj=2491393)
[  126.511769] ------------[ cut here ]------------
[  126.566062] WARNING: at mm/vmalloc.c:106 vmap_page_range_noflush+0x228/0x280()
[  126.652505] Modules linked in:
[  126.688929] Call Trace:
[  126.718168]  [000000000045ec50] warn_slowpath_common+0x50/0xa0
[  126.787961]  [000000000045ecbc] warn_slowpath_null+0x1c/0x40
[  126.855677]  [00000000004c3a08] vmap_page_range_noflush+0x228/0x280
[  126.930690]  [00000000004c401c] map_kernel_range_noflush+0x1c/0x40
[  127.004660]  [00000000004d3fbc] pcpu_map+0xbc/0x100
[  127.062999]  [00000000004d5064] pcpu_alloc+0x3e4/0x4e0
[  127.124467]  [00000000004d51b8] __alloc_percpu+0x18/0x40
[  127.188020]  [00000000005af40c] __percpu_counter_init+0x4c/0xc0
[  127.258870]  [000000000084b2d8] files_init+0x68/0x78
[  127.318247]  [000000000084b474] vfs_caches_init+0xa0/0x150
[  127.383888]  [000000000083e8f0] start_kernel+0x2c8/0x334
[  127.447436]  [00000000006c2204] tlb_fixup_done+0xa0/0xbc
[  127.510971]  [0000000000000000] (null)
[  127.555772] ---[ end trace 139ce121c98e96cb ]---
[  127.611597] Mount-cache hash table entries: 512
[  127.665366] ------------[ cut here ]------------
[  127.720400] WARNING: at mm/vmalloc.c:106 vmap_page_range_noflush+0x228/0x280()
[  127.806845] Modules linked in:
[  127.843271] Call Trace:
[  127.872505]  [000000000045ec50] warn_slowpath_common+0x50/0xa0
[  127.942305]  [000000000045ecbc] warn_slowpath_null+0x1c/0x40
[  128.010019]  [00000000004c3a08] vmap_page_range_noflush+0x228/0x280
[  128.085033]  [00000000004c401c] map_kernel_range_noflush+0x1c/0x40
[  128.158998]  [00000000004d3fbc] pcpu_map+0xbc/0x100
[  128.217341]  [00000000004d5064] pcpu_alloc+0x3e4/0x4e0
[  128.278809]  [00000000004d51b8] __alloc_percpu+0x18/0x40
[  128.342360]  [00000000005af40c] __percpu_counter_init+0x4c/0xc0
[  128.413215]  [00000000004b5170] bdi_init+0x50/0xc0
[  128.470512]  [000000000084c958] sysfs_inode_init+0x8/0x1c
[  128.535098]  [000000000084c99c] sysfs_init+0x30/0xac
[  128.594483]  [000000000084b9d4] mnt_init+0x90/0x1ec
[  128.652827]  [000000000084b47c] vfs_caches_init+0xa8/0x150
[  128.718464]  [000000000083e8f0] start_kernel+0x2c8/0x334
[  128.782012]  [00000000006c2204] tlb_fixup_done+0xa0/0xbc
[  128.845550]  [0000000000000000] (null)
[  128.890346] ---[ end trace 139ce121c98e96cc ]---
[  128.946007] Unable to handle kernel NULL pointer dereference
[  129.013245] tsk->{mm,active_mm}->context = 0000000000000000
[  129.079919] tsk->{mm,active_mm}->pgd = fffff80000867934
[  129.142432]               \|/ ____ \|/
[  129.142447]               "@'/ .. \`@"
[  129.142461]               /_| \__/ |_\
[  129.142474]                  \__U_/
[  129.318502] swapper(0): Oops [#1]
[  129.358101] TSTATE: 0000000080e01600 TPC: 00000000004d46b4 TNPC: 00000000004d46b8 Y: 00000000    Tainted: G        W 
[  129.485202] TPC: <free_percpu+0x74/0x180>
[  129.533120] g0: 0000000000000008 g1: e000000004402036 g2: 0000000000000000 g3: fffff80000000000
[  129.637301] g4: 00000000007d2458 g5: 0000000100fa0000 g6: 0000000000830000 g7: 0000000000200200
[  129.741483] o0: 0000000000000000 o1: 00000000008339a0 o2: 0000000000830000 o3: 0000000000000000
[  129.845666] o4: 0000000000000002 o5: 0000000000000000 sp: 0000000000833111 ret_pc: 00000000004d46ac
[  129.954021] RPC: <free_percpu+0x6c/0x180>
[  130.001942] l0: fffff800058181c0 l1: 0000000000000000 l2: 00000000007e2c00 l3: 0000000000784000
[  130.106121] l4: 00000000008339a0 l5: 000000000087eaa0 l6: 0000000000000000 l7: 0000000000000000
[  130.210306] i0: 0000000101802004 i1: 0000000000000000 i2: 000000000106b330 i3: 0000000000000000
[  130.314489] i4: 0000000000000066 i5: 00000000007fdad0 i6: 00000000008331d1 i7: 00000000005af394
[  130.418676] I7: <percpu_counter_destroy+0x54/0x80>
[  130.475979] Caller[00000000005af394]: percpu_counter_destroy+0x54/0x80
[  130.554119] Caller[00000000004b51bc]: bdi_init+0x9c/0xc0
[  130.617671] Caller[000000000084c958]: sysfs_inode_init+0x8/0x1c
[  130.688512] Caller[000000000084c99c]: sysfs_init+0x30/0xac
[  130.754147] Caller[000000000084b9d4]: mnt_init+0x90/0x1ec
[  130.818740] Caller[000000000084b47c]: vfs_caches_init+0xa8/0x150
[  130.890629] Caller[000000000083e8f0]: start_kernel+0x2c8/0x334
[  130.960430] Caller[00000000006c2204]: tlb_fixup_done+0xa0/0xbc
[  131.030219] Caller[0000000000000000]: (null)
[  131.081264] Instruction DUMP: 050041b0  7fffb605  90100018 <e05a2040> c25c2018  d0586008  92260008  90100010  7fffff4e 
[  131.210457] Kernel panic - not syncing: Attempted to kill the idle task!
[  131.290670] Call Trace:
[  131.319860]  [00000000006d0818] panic+0x5c/0x1a0
[  131.375075]  [0000000000462eac] do_exit+0x62c/0x6a0
[  131.433419]  [0000000000427e54] die_if_kernel+0xf4/0x300
[  131.496986]  [0000000000447c0c] unhandled_fault+0x6c/0xc0
[  131.561563]  [0000000000447d40] do_sparc64_fault+0xe0/0x6a0
[  131.628240]  [0000000000407ac4] sparc64_realfault_common+0x10/0x20
[  131.702207]  [00000000004d46b4] free_percpu+0x74/0x180
[  131.763673]  [00000000005af394] percpu_counter_destroy+0x54/0x80
[  131.835563]  [00000000004b51bc] bdi_init+0x9c/0xc0
[  131.892866]  [000000000084c958] sysfs_inode_init+0x8/0x1c
[  131.957456]  [000000000084c99c] sysfs_init+0x30/0xac
[  132.016837]  [000000000084b9d4] mnt_init+0x90/0x1ec
[  132.075182]  [000000000084b47c] vfs_caches_init+0xa8/0x150
[  132.140816]  [000000000083e8f0] start_kernel+0x2c8/0x334
[  132.204367]  [00000000006c2204] tlb_fixup_done+0xa0/0xbc
[  132.267905]  [0000000000000000] (null)
[  132.312705] Press Stop-A (L1-A) to return to the boot prom

-- 
Meelis Roos (mroos@linux.ee)
