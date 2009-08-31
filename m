Return-Path: <linux-kernel-owner+w=401wt.eu-S1751395AbZHaVWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbZHaVWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 17:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbZHaVWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 17:22:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50946
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829AbZHaVWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 17:22:01 -0400
Date: Mon, 31 Aug 2009 14:22:15 -0700 (PDT)
Message-Id: <20090831.142215.111904849.davem@davemloft.net>
To: mroos@linux.ee
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: boot panic after oops from sysfs_new_dirent
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.SOC.4.64.0908311646150.20934@math.ut.ee>
References: <Pine.SOC.4.64.0908311646150.20934@math.ut.ee>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Mon, 31 Aug 2009 16:51:45 +0300 (EEST)

[ CC:'ing Tejun Heo and lkml as Tejun recently made some changes which
  were meant to "fix" things in this area :-) ]

> I powered on my 6-CPU E3000 after a summer pause and tried todays 
> 2.6.31-rc8+git on it. It fails - first it spills lots of warnings about 
> percpu things, then oopses in sysfs_new_dirent and then panics.
> 
> The TOD failure is a known problem waiting for replacement clock board, 
> it does not seem to disturb other Linux versions (2.6.30 runs fine).
> 
> If it gives no ideas then I might find the time to bisect it but not 
> today.
> 
> 3,0>ERROR: TEST=NVRAM Devices,SUBTEST=M48T59 (TOD) Init ID=8.1
> 3,0>Component under test: Board 16 Firehose Bus
> 3,0>TODC battery is low bit set
> Detected failed TOD on clock board. Using backup TOD on board in slot 1 
> fhc ac simm-status environment sram flashprom SUNW,UltraSPARC-II SUNW,UltraSPARC-II 
> fhc ac simm-status environment sram flashprom SUNW,UltraSPARC-II SUNW,UltraSPARC-II 
> fhc ac simm-status environment sram flashprom SUNW,UltraSPARC-II SUNW,UltraSPARC-II 
> Probing UPA Slot at 2,0   sbus fhc ac environment flashprom eeprom sbus-speed counter-timer 
> Probing UPA Slot at 3,0   sbus counter-timer 
> Probing /sbus@2,0 at d,0  SUNW,soc 
> Probing /sbus@2,0 at 1,0  SUNW,socal sf ssd sf ssd 
> Probing /sbus@2,0 at 2,0  QLGC,isp sd st 
> Probing /sbus@3,0 at 3,0  SUNW,hme SUNW,fas sd st 
> Probing /sbus@3,0 at 0,0  SUNW,qfe SUNW,qfe SUNW,qfe SUNW,qfe 
> 4-slot Sun Enterprise 3000, No Keyboard
> OpenBoot 3.2.29, 3584 MB memory installed, Serial #8631214.
> Copyright 2001 Sun Microsystems, Inc.  All rights reserved
> Ethernet address 8:0:20:83:b3:ae, Host ID: 8083b3ae.
> 
> 
> 
> Boot device: disk  File and args: 
> SILO Version 1.4.13
> boot: 
> Linux                    LinuxOLD                 test                     
> hea                      
> boot: test console=ttyS0
> Allocated 8 Megs of memory at 0x40000000 for kernel
> Uncompressing image...
> Loaded kernel version 2.6.31
> 
> [    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 3.2.29 2001/06/18 17:28'
> [    0.000000] PROMLIB: Root node compatible: 
> [    0.000000] Linux version 2.6.31-rc8 (mroos@mandel) (gcc version 4.3.4 (Debian 4.3.4-2) ) #11 SMP Mon Aug 31 14:24:32 EEST 2009
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] console [earlyprom0] enabled
> [    0.000000] ARCH: SUN4U
> [    0.000000] Ethernet address: 08:00:20:83:b3:ae
> [    0.000000] Kernel: Using 4 locked TLB entries for main kernel image.
> [    0.000000] Remapping the kernel... done.
> [    0.000000] OF stdout device is: /central@1f,0/fhc@0,f8800000/zs@0,902000:a
> [    0.000000] PROM: Built device tree with 70462 bytes of memory.
> [    0.000000] Top of RAM: 0xdfd14000, Total RAM: 0xdf960000
> [    0.000000] Memory hole size: 3MB
> [    0.000000] [0000000200000000-fffff80001400000] page_structs=131072 node=0 entry=0/0
> [    0.000000] [0000000200000000-fffff80001800000] page_structs=131072 node=0 entry=1/0
> [    0.000000] [0000000200000000-fffff80001c00000] page_structs=131072 node=0 entry=2/0
> [    0.000000] [0000000200c00000-fffff80002000000] page_structs=131072 node=0 entry=3/0
> [    0.000000] [0000000200c00000-fffff80002400000] page_structs=131072 node=0 entry=4/0
> [    0.000000] [0000000200c00000-fffff80002800000] page_structs=131072 node=0 entry=5/0
> [    0.000000] [0000000201800000-fffff80002c00000] page_structs=131072 node=0 entry=6/0
> [    0.000000] [0000000201800000-fffff80003000000] page_structs=131072 node=0 entry=7/0
> [    0.000000] [0000000201800000-fffff80003400000] page_structs=131072 node=0 entry=8/0
> [    0.000000] [0000000202400000-fffff80003800000] page_structs=131072 node=0 entry=9/0
> [    0.000000] [0000000202400000-fffff80003c00000] page_structs=131072 node=0 entry=10/0
> [    0.000000] [0000000202400000-fffff80004000000] page_structs=131072 node=0 entry=11/0
> [    0.000000] Zone PFN ranges:
> [    0.000000]   Normal   0x00000000 -> 0x0006fe8a
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[3] active PFN ranges
> [    0.000000]     0: 0x00000000 -> 0x0006fc27
> [    0.000000]     0: 0x0006fe00 -> 0x0006fe7f
> [    0.000000]     0: 0x0006fe80 -> 0x0006fe8a
> [    0.000000] On node 0 totalpages: 457904
> [    0.000000]   Normal zone: 5372 pages used for memmap
> [    0.000000]   Normal zone: 0 pages reserved
> [    0.000000]   Normal zone: 452532 pages, LIFO batch:15
> [    0.000000] Booting Linux...
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 452532
> [    0.000000] Kernel command line: root=/dev/sda2 ro debug ignore_loglevel console=ttyS0
> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> [    0.000000] Dentry cache hash table entries: 524288 (order: 9, 4194304 bytes)
> [    0.000000] Inode-cache hash table entries: 262144 (order: 8, 2097152 bytes)
> [    0.000000] Memory: 3593384k available (2896k kernel code, 1392k data, 152k init) [fffff80000000000,00000000dfd14000]
> [    0.000000] SLUB: Genslabs=14, HWalign=32, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
> [    0.000000] RCU-based detection of stalled CPUs is enabled.
> [    0.000000] NR_IRQS:255
> [    0.000000] clocksource: mult[40842] shift[16]
> [    0.000000] clockevent: mult[3f7ced91] shift[32]
> [  126.197098] Console: colour dummy device 80x25
> [  126.250110] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [  126.342739] ... MAX_LOCKDEP_SUBCLASSES:  8
> [  126.391701] ... MAX_LOCK_DEPTH:          48
> [  126.441711] ... MAX_LOCKDEP_KEYS:        8191
> [  126.493801] ... CLASSHASH_SIZE:          4096
> [  126.545893] ... MAX_LOCKDEP_ENTRIES:     16384
> [  126.599026] ... MAX_LOCKDEP_CHAINS:      32768
> [  126.652159] ... CHAINHASH_SIZE:          16384
> [  126.705292]  memory used by lock dependency info: 5695 kB
> [  126.769885]  per task-struct memory footprint: 1920 bytes
> [  126.984803] Calibrating delay using timer specific routine.. 498.95 BogoMIPS (lpj=2494757)
> [  127.083344] ------------[ cut here ]------------
> [  127.138101] WARNING: at mm/percpu.c:651 pcpu_map+0xdc/0x100()
> [  127.206826] Modules linked in:
> [  127.243239] Call Trace:
> [  127.272498]  [000000000045eb70] warn_slowpath_common+0x50/0xa0
> [  127.342282]  [000000000045ebdc] warn_slowpath_null+0x1c/0x40
> [  127.409997]  [00000000004d493c] pcpu_map+0xdc/0x100
> [  127.468338]  [00000000004d59a4] pcpu_alloc+0x3e4/0x4e0
> [  127.529806]  [00000000004d5af8] __alloc_percpu+0x18/0x40
> [  127.593363]  [00000000005b112c] __percpu_counter_init+0x4c/0xc0
> [  127.664223]  [000000000084d6cc] mmap_init+0x14/0x24
> [  127.722547]  [000000000084910c] proc_caches_init+0xdc/0xec
> [  127.788179]  [0000000000842910] start_kernel+0x2b4/0x338
> [  127.851748]  [00000000006c5004] tlb_fixup_done+0xa0/0xbc
> [  127.915271]  [0000000000000000] (null)
> [  127.960244] ---[ end trace 139ce121c98e96c9 ]---
> [  128.015292] ------------[ cut here ]------------
> [  128.070525] WARNING: at mm/vmalloc.c:106 vmap_page_range_noflush+0x228/0x280()
> [  128.156969] Modules linked in:
> [  128.193383] Call Trace:
> [  128.222627]  [000000000045eb70] warn_slowpath_common+0x50/0xa0
> [  128.292429]  [000000000045ebdc] warn_slowpath_null+0x1c/0x40
> [  128.360144]  [00000000004c3ce8] vmap_page_range_noflush+0x228/0x280
> [  128.435155]  [00000000004c42fc] map_kernel_range_noflush+0x1c/0x40
> [  128.509122]  [00000000004d4908] pcpu_map+0xa8/0x100
> [  128.567466]  [00000000004d59a4] pcpu_alloc+0x3e4/0x4e0
> [  128.628932]  [00000000004d5af8] __alloc_percpu+0x18/0x40
> [  128.692485]  [00000000005b112c] __percpu_counter_init+0x4c/0xc0
> [  128.763336]  [000000000084d6cc] mmap_init+0x14/0x24
> [  128.821670]  [000000000084910c] proc_caches_init+0xdc/0xec
> [  128.887305]  [0000000000842910] start_kernel+0x2b4/0x338
> [  128.950861]  [00000000006c5004] tlb_fixup_done+0xa0/0xbc
> [  129.014396]  [0000000000000000] (null)
> [  129.059195] ---[ end trace 139ce121c98e96ca ]---
> [  129.114459] ------------[ cut here ]------------
> [  129.169644] WARNING: at mm/percpu.c:565 pcpu_depopulate_chunk+0x1e4/0x200()
> [  129.252971] Modules linked in:
> [  129.289383] Call Trace:
> [  129.318627]  [000000000045eb70] warn_slowpath_common+0x50/0xa0
> [  129.388429]  [000000000045ebdc] warn_slowpath_null+0x1c/0x40
> [  129.456143]  [00000000004d4b44] pcpu_depopulate_chunk+0x1e4/0x200
> [  129.529071]  [00000000004d5970] pcpu_alloc+0x3b0/0x4e0
> [  129.590535]  [00000000004d5af8] __alloc_percpu+0x18/0x40
> [  129.654088]  [00000000005b112c] __percpu_counter_init+0x4c/0xc0
> [  129.724940]  [000000000084d6cc] mmap_init+0x14/0x24
> [  129.783276]  [000000000084910c] proc_caches_init+0xdc/0xec
> [  129.848909]  [0000000000842910] start_kernel+0x2b4/0x338
> [  129.912466]  [00000000006c5004] tlb_fixup_done+0xa0/0xbc
> [  129.976002]  [0000000000000000] (null)
> [  130.020798] ---[ end trace 139ce121c98e96cb ]---
> [  130.076017] ------------[ cut here ]------------
> [  130.131247] WARNING: at mm/vmalloc.c:43 vunmap_page_range+0x104/0x160()
> [  130.210407] Modules linked in:
> [  130.246822] Call Trace:
> [  130.276062]  [000000000045eb70] warn_slowpath_common+0x50/0xa0
> [  130.345867]  [000000000045ebdc] warn_slowpath_null+0x1c/0x40
> [  130.413579]  [00000000004c2ae4] vunmap_page_range+0x104/0x160
> [  130.482342]  [00000000004c2b94] unmap_kernel_range_noflush+0x14/0x40
> [  130.558394]  [00000000004d4aa4] pcpu_depopulate_chunk+0x144/0x200
> [  130.631322]  [00000000004d5970] pcpu_alloc+0x3b0/0x4e0
> [  130.692788]  [00000000004d5af8] __alloc_percpu+0x18/0x40
> [  130.756343]  [00000000005b112c] __percpu_counter_init+0x4c/0xc0
> [  130.827190]  [000000000084d6cc] mmap_init+0x14/0x24
> [  130.885529]  [000000000084910c] proc_caches_init+0xdc/0xec
> [  130.951161]  [0000000000842910] start_kernel+0x2b4/0x338
> [  131.014717]  [00000000006c5004] tlb_fixup_done+0xa0/0xbc
> [  131.078252]  [0000000000000000] (null)
> [  131.123049] ---[ end trace 139ce121c98e96cc ]---
> [  131.178268] ------------[ cut here ]------------
> [  131.233497] WARNING: at mm/vmalloc.c:43 vunmap_page_range+0x104/0x160()
> [  131.312658] Modules linked in:
> [  131.349071] Call Trace:
> [  131.378316]  [000000000045eb70] warn_slowpath_common+0x50/0xa0
> [  131.448117]  [000000000045ebdc] warn_slowpath_null+0x1c/0x40
> [  131.515830]  [00000000004c2ae4] vunmap_page_range+0x104/0x160
> [  131.584593]  [00000000004c2b94] unmap_kernel_range_noflush+0x14/0x40
> [  131.660647]  [00000000004d4aa4] pcpu_depopulate_chunk+0x144/0x200
> [  131.733573]  [00000000004d5970] pcpu_alloc+0x3b0/0x4e0
> [  131.795040]  [00000000004d5af8] __alloc_percpu+0x18/0x40
> [  131.858591]  [00000000005b112c] __percpu_counter_init+0x4c/0xc0
> [  131.929440]  [000000000084d6cc] mmap_init+0x14/0x24
> [  131.987779]  [000000000084910c] proc_caches_init+0xdc/0xec
> [  132.053412]  [0000000000842910] start_kernel+0x2b4/0x338
> [  132.116967]  [00000000006c5004] tlb_fixup_done+0xa0/0xbc
> [  132.180504]  [0000000000000000] (null)
> [  132.225299] ---[ end trace 139ce121c98e96cd ]---
> [  132.280518] ------------[ cut here ]------------
> [  132.335748] WARNING: at mm/vmalloc.c:43 vunmap_page_range+0x104/0x160()
> [  132.414909] Modules linked in:
> [  132.451323] Call Trace:
> [  132.480566]  [000000000045eb70] warn_slowpath_common+0x50/0xa0
> [  132.550368]  [000000000045ebdc] warn_slowpath_null+0x1c/0x40
> [  132.618083]  [00000000004c2ae4] vunmap_page_range+0x104/0x160
> [  132.686844]  [00000000004c2b94] unmap_kernel_range_noflush+0x14/0x40
> [  132.762896]  [00000000004d4aa4] pcpu_depopulate_chunk+0x144/0x200
> [  132.835822]  [00000000004d5970] pcpu_alloc+0x3b0/0x4e0
> [  132.897291]  [00000000004d5af8] __alloc_percpu+0x18/0x40
> [  132.960844]  [00000000005b112c] __percpu_counter_init+0x4c/0xc0
> [  133.031691]  [000000000084d6cc] mmap_init+0x14/0x24
> [  133.090030]  [000000000084910c] proc_caches_init+0xdc/0xec
> [  133.155662]  [0000000000842910] start_kernel+0x2b4/0x338
> [  133.219219]  [00000000006c5004] tlb_fixup_done+0xa0/0xbc
> [  133.282756]  [0000000000000000] (null)
> [  133.327552] ---[ end trace 139ce121c98e96ce ]---
> [  133.382770] ------------[ cut here ]------------
> [  133.438001] WARNING: at mm/vmalloc.c:43 vunmap_page_range+0x104/0x160()
> [  133.517162] Modules linked in:
> [  133.553574] Call Trace:
> [  133.582818]  [000000000045eb70] warn_slowpath_common+0x50/0xa0
> [  133.652618]  [000000000045ebdc] warn_slowpath_null+0x1c/0x40
> [  133.720334]  [00000000004c2ae4] vunmap_page_range+0x104/0x160
> [  133.789096]  [00000000004c2b94] unmap_kernel_range_noflush+0x14/0x40
> [  133.865149]  [00000000004d4aa4] pcpu_depopulate_chunk+0x144/0x200
> [  133.938075]  [00000000004d5970] pcpu_alloc+0x3b0/0x4e0
> [  133.999544]  [00000000004d5af8] __alloc_percpu+0x18/0x40
> [  134.063095]  [00000000005b112c] __percpu_counter_init+0x4c/0xc0
> [  134.133943]  [000000000084d6cc] mmap_init+0x14/0x24
> [  134.192282]  [000000000084910c] proc_caches_init+0xdc/0xec
> [  134.257916]  [0000000000842910] start_kernel+0x2b4/0x338
> [  134.321471]  [00000000006c5004] tlb_fixup_done+0xa0/0xbc
> [  134.385006]  [0000000000000000] (null)
> [  134.429803] ---[ end trace 139ce121c98e96cf ]---
> [  134.485020] ------------[ cut here ]------------
> [  134.540252] WARNING: at mm/vmalloc.c:43 vunmap_page_range+0x104/0x160()
> [  134.619414] Modules linked in:
> [  134.655826] Call Trace:
> [  134.685068]  [000000000045eb70] warn_slowpath_common+0x50/0xa0
> [  134.754872]  [000000000045ebdc] warn_slowpath_null+0x1c/0x40
> [  134.822585]  [00000000004c2ae4] vunmap_page_range+0x104/0x160
> [  134.891346]  [00000000004c2b94] unmap_kernel_range_noflush+0x14/0x40
> [  134.967399]  [00000000004d4aa4] pcpu_depopulate_chunk+0x144/0x200
> [  135.040325]  [00000000004d5970] pcpu_alloc+0x3b0/0x4e0
> [  135.101794]  [00000000004d5af8] __alloc_percpu+0x18/0x40
> [  135.165347]  [00000000005b112c] __percpu_counter_init+0x4c/0xc0
> [  135.236197]  [000000000084d6cc] mmap_init+0x14/0x24
> [  135.294533]  [000000000084910c] proc_caches_init+0xdc/0xec
> [  135.360165]  [0000000000842910] start_kernel+0x2b4/0x338
> [  135.423723]  [00000000006c5004] tlb_fixup_done+0xa0/0xbc
> [  135.487257]  [0000000000000000] (null)
> [  135.532055] ---[ end trace 139ce121c98e96d0 ]---
> [  135.587271] ------------[ cut here ]------------
> [  135.642504] WARNING: at mm/vmalloc.c:43 vunmap_page_range+0x104/0x160()
> [  135.721665] Modules linked in:
> [  135.758077] Call Trace:
> [  135.787320]  [000000000045eb70] warn_slowpath_common+0x50/0xa0
> [  135.857123]  [000000000045ebdc] warn_slowpath_null+0x1c/0x40
> [  135.924836]  [00000000004c2ae4] vunmap_page_range+0x104/0x160
> [  135.993597]  [00000000004c2b94] unmap_kernel_range_noflush+0x14/0x40
> [  136.069651]  [00000000004d4aa4] pcpu_depopulate_chunk+0x144/0x200
> [  136.142576]  [00000000004d5970] pcpu_alloc+0x3b0/0x4e0
> [  136.204044]  [00000000004d5af8] __alloc_percpu+0x18/0x40
> [  136.267598]  [00000000005b112c] __percpu_counter_init+0x4c/0xc0
> [  136.338446]  [000000000084d6cc] mmap_init+0x14/0x24
> [  136.396784]  [000000000084910c] proc_caches_init+0xdc/0xec
> [  136.462418]  [0000000000842910] start_kernel+0x2b4/0x338
> [  136.525971]  [00000000006c5004] tlb_fixup_done+0xa0/0xbc
> [  136.589510]  [0000000000000000] (null)
> [  136.634308] ---[ end trace 139ce121c98e96d1 ]---
> [  136.691136] ------------[ cut here ]------------
> [  136.745488] WARNING: at mm/percpu.c:651 pcpu_map+0xdc/0x100()
> [  136.814227] Modules linked in:
> [  136.850641] Call Trace:
> [  136.879883]  [000000000045eb70] warn_slowpath_common+0x50/0xa0
> [  136.949683]  [000000000045ebdc] warn_slowpath_null+0x1c/0x40
> [  137.017398]  [00000000004d493c] pcpu_map+0xdc/0x100
> [  137.075741]  [00000000004d59a4] pcpu_alloc+0x3e4/0x4e0
> [  137.137209]  [00000000004d5af8] __alloc_percpu+0x18/0x40
> [  137.200760]  [00000000005b112c] __percpu_counter_init+0x4c/0xc0
> [  137.271601]  [000000000084f2b4] files_init+0x68/0x78
> [  137.330987]  [000000000084f450] vfs_caches_init+0xa0/0x150
> [  137.396620]  [0000000000842928] start_kernel+0x2cc/0x338
> [  137.460178]  [00000000006c5004] tlb_fixup_done+0xa0/0xbc
> [  137.523715]  [0000000000000000] (null)
> [  137.568512] ---[ end trace 139ce121c98e96d2 ]---
> [  137.623820] Mount-cache hash table entries: 512
> [  137.678029] ------------[ cut here ]------------
> [  137.733137] WARNING: at mm/percpu.c:651 pcpu_map+0xdc/0x100()
> [  137.801877] Modules linked in:
> [  137.838289] Call Trace:
> [  137.867534]  [000000000045eb70] warn_slowpath_common+0x50/0xa0
> [  137.937335]  [000000000045ebdc] warn_slowpath_null+0x1c/0x40
> [  138.005048]  [00000000004d493c] pcpu_map+0xdc/0x100
> [  138.063389]  [00000000004d59a4] pcpu_alloc+0x3e4/0x4e0
> [  138.124859]  [00000000004d5af8] __alloc_percpu+0x18/0x40
> [  138.188411]  [00000000005b112c] __percpu_counter_init+0x4c/0xc0
> [  138.259264]  [00000000004b5338] bdi_init+0x38/0xc0
> [  138.316559]  [00000000008508d0] sysfs_inode_init+0x8/0x1c
> [  138.381145]  [0000000000850914] sysfs_init+0x30/0xac
> [  138.440530]  [000000000084f9b0] mnt_init+0x90/0x1a4
> [  138.498873]  [000000000084f458] vfs_caches_init+0xa8/0x150
> [  138.564509]  [0000000000842928] start_kernel+0x2cc/0x338
> [  138.628065]  [00000000006c5004] tlb_fixup_done+0xa0/0xbc
> [  138.691601]  [0000000000000000] (null)
> [  138.736396] ---[ end trace 139ce121c98e96d3 ]---
> [  138.791615] ------------[ cut here ]------------
> [  138.846847] WARNING: at mm/vmalloc.c:106 vmap_page_range_noflush+0x228/0x280()
> [  138.933300] Modules linked in:
> [  138.969712] Call Trace:
> [  138.998957]  [000000000045eb70] warn_slowpath_common+0x50/0xa0
> [  139.068758]  [000000000045ebdc] warn_slowpath_null+0x1c/0x40
> [  139.136472]  [00000000004c3ce8] vmap_page_range_noflush+0x228/0x280
> [  139.211484]  [00000000004c42fc] map_kernel_range_noflush+0x1c/0x40
> [  139.285451]  [00000000004d4908] pcpu_map+0xa8/0x100
> [  139.343795]  [00000000004d59a4] pcpu_alloc+0x3e4/0x4e0
> [  139.405263]  [00000000004d5af8] __alloc_percpu+0x18/0x40
> [  139.468814]  [00000000005b112c] __percpu_counter_init+0x4c/0xc0
> [  139.539659]  [00000000004b5338] bdi_init+0x38/0xc0
> [  139.596959]  [00000000008508d0] sysfs_inode_init+0x8/0x1c
> [  139.661551]  [0000000000850914] sysfs_init+0x30/0xac
> [  139.720934]  [000000000084f9b0] mnt_init+0x90/0x1a4
> [  139.779276]  [000000000084f458] vfs_caches_init+0xa8/0x150
> [  139.844911]  [0000000000842928] start_kernel+0x2cc/0x338
> [  139.908469]  [00000000006c5004] tlb_fixup_done+0xa0/0xbc
> [  139.972005]  [0000000000000000] (null)
> [  140.016800] ---[ end trace 139ce121c98e96d4 ]---
> [  140.072067] ------------[ cut here ]------------
> [  140.127250] WARNING: at mm/percpu.c:565 pcpu_depopulate_chunk+0x1e4/0x200()
> [  140.210578] Modules linked in:
> [  140.246991] Call Trace:
> [  140.276235]  [000000000045eb70] warn_slowpath_common+0x50/0xa0
> [  140.346036]  [000000000045ebdc] warn_slowpath_null+0x1c/0x40
> [  140.413750]  [00000000004d4b44] pcpu_depopulate_chunk+0x1e4/0x200
> [  140.486675]  [00000000004d5970] pcpu_alloc+0x3b0/0x4e0
> [  140.548143]  [00000000004d5af8] __alloc_percpu+0x18/0x40
> [  140.611697]  [00000000005b112c] __percpu_counter_init+0x4c/0xc0
> [  140.682543]  [00000000004b5338] bdi_init+0x38/0xc0
> [  140.739842]  [00000000008508d0] sysfs_inode_init+0x8/0x1c
> [  140.804433]  [0000000000850914] sysfs_init+0x30/0xac
> [  140.863815]  [000000000084f9b0] mnt_init+0x90/0x1a4
> [  140.922159]  [000000000084f458] vfs_caches_init+0xa8/0x150
> [  140.987795]  [0000000000842928] start_kernel+0x2cc/0x338
> [  141.051351]  [00000000006c5004] tlb_fixup_done+0xa0/0xbc
> [  141.114887]  [0000000000000000] (null)
> [  141.159683] ---[ end trace 139ce121c98e96d5 ]---
> [  141.216152] ------------[ cut here ]------------
> [  141.270459] WARNING: at lib/kobject.c:595 kobject_put+0x40/0x60()
> [  141.343360] kobject: '<NULL>' (fffff800df022ad0): is not initialized, yet kobject_put() is being called.
> [  141.456910] Modules linked in:
> [  141.493327] Call Trace:
> [  141.522571]  [000000000045eb70] warn_slowpath_common+0x50/0xa0
> [  141.592368]  [000000000045ec34] warn_slowpath_fmt+0x34/0x60
> [  141.659045]  [0000000000598d60] kobject_put+0x40/0x60
> [  141.719469]  [00000000004d3ba0] kmem_cache_destroy+0x180/0x1e0
> [  141.789270]  [0000000000850940] sysfs_init+0x5c/0xac
> [  141.848650]  [000000000084f9b0] mnt_init+0x90/0x1a4
> [  141.906994]  [000000000084f458] vfs_caches_init+0xa8/0x150
> [  141.972628]  [0000000000842928] start_kernel+0x2cc/0x338
> [  142.036187]  [00000000006c5004] tlb_fixup_done+0xa0/0xbc
> [  142.099721]  [0000000000000000] (null)
> [  142.144518] ---[ end trace 139ce121c98e96d6 ]---
> [  142.199742] mnt_init: sysfs_init error: -12
> [  142.249979] Unable to handle kernel NULL pointer dereference
> [  142.317414] tsk->{mm,active_mm}->context = 0000000000000000
> [  142.384089] tsk->{mm,active_mm}->pgd = fffff8000086bb74
> [  142.446597]               \|/ ____ \|/
> [  142.446613]               "@'/ .. \`@"
> [  142.446627]               /_| \__/ |_\
> [  142.446640]                  \__U_/
> [  142.622671] swapper(0): Oops [#1]
> [  142.662298] TSTATE: 0000000080e01603 TPC: 00000000004d2198 TNPC: 00000000004d219c Y: 00000000    Tainted: G        W 
> [  142.789371] TPC: <kmem_cache_alloc+0x58/0x120>
> [  142.842497] g0: 0000000000000000 g1: 0000000000000140 g2: 0000000000000000 g3: 00000000007d6010
> [  142.946679] g4: 00000000007d6010 g5: 0000000100f9c000 g6: 0000000000834000 g7: 0000000000667300
> [  143.050861] o0: 000000000078d9f0 o1: 00000000000006a1 o2: 0000000000000000 o3: 0000000000000008
> [  143.155046] o4: fffff800df056008 o5: 0000000066730000 sp: 0000000000836e81 ret_pc: 00000000004d2184
> [  143.263397] RPC: <kmem_cache_alloc+0x44/0x120>
> [  143.316526] l0: 0000000000000000 l1: 00000000000080d0 l2: 00000000000012d0 l3: 000000000053c1b0
> [  143.420710] l4: 0000000000000000 l5: 0000000000000000 l6: 00000000000212d0 l7: 0000000000000010
> [  143.524891] i0: 0000000000000000 i1: 00000000000080d0 i2: 0000000000000001 i3: 0000000000000001
> [  143.629075] i4: 0000000000000000 i5: 0000000000000002 i6: 0000000000836f41 i7: 000000000053c1b0
> [  143.733265] I7: <sysfs_new_dirent+0x30/0x120>
> [  143.785344] Disabling lock debugging due to kernel taint
> [  143.848907] Caller[000000000053c1b0]: sysfs_new_dirent+0x30/0x120
> [  143.921834] Caller[000000000053c7a4]: create_dir+0x24/0xc0
> [  143.987469] Caller[000000000053c870]: sysfs_create_dir+0x30/0x80
> [  144.059361] Caller[00000000005990e8]: kobject_add_internal+0xc8/0x200
> [  144.136454] Caller[0000000000599354]: kobject_add_varg+0x34/0x60
> [  144.208341] Caller[0000000000599424]: kobject_add+0x44/0x80
> [  144.275018] Caller[0000000000599490]: kobject_create_and_add+0x30/0x80
> [  144.353148] Caller[000000000084f9cc]: mnt_init+0xac/0x1a4
> [  144.417742] Caller[000000000084f458]: vfs_caches_init+0xa8/0x150
> [  144.489628] Caller[0000000000842928]: start_kernel+0x2cc/0x338
> [  144.559437] Caller[00000000006c5004]: tlb_fixup_done+0xa0/0xbc
> [  144.629223] Caller[0000000000000000]: (null)
> [  144.680270] Instruction DUMP: c211a03e  82006022  83287003 <d85d0001> f05b0000  02c60026  e4032018  c2032014  83287003 
> [  144.809463] Kernel panic - not syncing: Attempted to kill the idle task!
> [  144.889675] Call Trace:
> [  144.918870]  [00000000006d3958] panic+0x5c/0x1a0
> [  144.974082]  [0000000000462d4c] do_exit+0x62c/0x6a0
> [  145.032424]  [0000000000427e54] die_if_kernel+0xf4/0x300
> [  145.095991]  [0000000000447bec] unhandled_fault+0x6c/0xc0
> [  145.160570]  [0000000000447d20] do_sparc64_fault+0xe0/0x680
> [  145.227247]  [0000000000407b04] sparc64_realfault_common+0x10/0x20
> [  145.301210]  [00000000004d2198] kmem_cache_alloc+0x58/0x120
> [  145.367886]  [000000000053c1b0] sysfs_new_dirent+0x30/0x120
> [  145.434564]  [000000000053c7a4] create_dir+0x24/0xc0
> [  145.493947]  [000000000053c870] sysfs_create_dir+0x30/0x80
> [  145.559589]  [00000000005990e8] kobject_add_internal+0xc8/0x200
> [  145.630432]  [0000000000599354] kobject_add_varg+0x34/0x60
> [  145.696067]  [0000000000599424] kobject_add+0x44/0x80
> [  145.756495]  [0000000000599490] kobject_create_and_add+0x30/0x80
> [  145.828373]  [000000000084f9cc] mnt_init+0xac/0x1a4
> [  145.886717]  [000000000084f458] vfs_caches_init+0xa8/0x150
> [  145.952344] Press Stop-A (L1-A) to return to the boot prom
> 
> -- 
> Meelis Roos (mroos@linux.ee)
> --
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
