Return-Path: <linux-kernel-owner+w=401wt.eu-S1751300AbYAOPKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbYAOPKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 10:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYAOPJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 10:09:50 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:53597 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYAOPJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 10:09:49 -0500
Date: Tue, 15 Jan 2008 16:09:49 +0100
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: crash in kmem_cache_init
Message-ID: <20080115150949.GA14089@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Current linus tree crashes in kmem_cache_init, as shown below. The
system is a 8cpu 2.2GHz POWER5 system, model 9117-570, with 4GB ram.
Firmware is 240_332, 2.6.23 boots ok with the same config.

There is a series of mm related patches in 2.6.24-rc1:
commit 04231b3002ac53f8a64a7bd142fde3fa4b6808c6 seems to break it,

==> .git/BISECT_LOG <==
git-bisect start
# good: [0b8bc8b91cf6befea20fe78b90367ca7b61cfa0d] Linux 2.6.23
git-bisect good 0b8bc8b91cf6befea20fe78b90367ca7b61cfa0d
# bad: [cebdeed27b068dcc3e7c311d7ec0d9c33b5138c2] Linux 2.6.24-rc1
git-bisect bad cebdeed27b068dcc3e7c311d7ec0d9c33b5138c2
# good: [9ac52315d4cf5f561f36dabaf0720c00d3553162] sched: guest CPU accounting: add guest-CPU /proc/<pid>/stat fields
git-bisect good 9ac52315d4cf5f561f36dabaf0720c00d3553162
# bad: [b9ec0339d8e22cadf2d9d1b010b51dc53837dfb0] add consts where appropriate in fs/nls/Kconfig fs/nls/Makefile fs/nls/nls_ascii.c fs/nls/nls_base.c fs/nls/nls_cp1250.c fs/nls/nls_cp1251.c fs/nls/nls_cp1255.c fs/nls/nls_cp437.c fs/nls/nls_cp737.c fs/nls/nls_cp775.c fs/nls/nls_cp850.c fs/nls/nls_cp852.c fs/nls/nls_cp855.c fs/nls/nls_cp857.c fs/nls/nls_cp860.c fs/nls/nls_cp861.c fs/nls/nls_cp862.c fs/nls/nls_cp863.c fs/nls/nls_cp864.c fs/nls/nls_cp865.c fs/nls/nls_cp866.c fs/nls/nls_cp869.c fs/nls/nls_cp874.c fs/nls/nls_cp932.c fs/nls/nls_cp936.c fs/nls/nls_cp949.c fs/nls/nls_cp950.c fs/nls/nls_euc-jp.c fs/nls/nls_iso8859-1.c fs/nls/nls_iso8859-13.c fs/nls/nls_iso8859-14.c fs/nls/nls_iso8859-15.c fs/nls/nls_iso8859-2.c fs/nls/nls_iso8859-3.c fs/nls/nls_iso8859-4.c fs/nls/nls_iso8859-5.c fs/nls/nls_iso8859-6.c fs/nls/nls_iso8859-7.c fs/nls/nls_iso8859-9.c fs/nls/nls_koi8-r.c fs/nls/nls_koi8-ru.c fs/nls/nls_koi8-u.c fs/nls/nls_utf8.c
git-bisect bad b9ec0339d8e22cadf2d9d1b010b51dc53837dfb0
# bad: [78a26e25ce4837a03ac3b6c32cdae1958e547639] uml: separate timer initialization
git-bisect bad 78a26e25ce4837a03ac3b6c32cdae1958e547639
# good: [4acad72ded8e3f0211bd2a762e23c28229c61a51] [IPV6]: Consolidate the ip6_pol_route_(input|output) pair
git-bisect good 4acad72ded8e3f0211bd2a762e23c28229c61a51
# good: [64da82efae0d7b5f7c478021840fd329f76d965d] Add support for PCMCIA card Sierra WIreless AC850
git-bisect good 64da82efae0d7b5f7c478021840fd329f76d965d
# bad: [37b07e4163f7306aa735a6e250e8d22293e5b8de] memoryless nodes: fixup uses of node_online_map in generic code
git-bisect bad 37b07e4163f7306aa735a6e250e8d22293e5b8de
# good: [64649a58919e66ec21792dbb6c48cb3da22cbd7f] mm: trim more holes
git-bisect good 64649a58919e66ec21792dbb6c48cb3da22cbd7f
# good: [fb53b3094888be0cf8ddf052277654268904bdf5] smbfs: convert to new aops
git-bisect good fb53b3094888be0cf8ddf052277654268904bdf5
# good: [13808910713a98cc1159291e62cdfec92cc94d05] Memoryless nodes: Generic management of nodemasks for various purposes




 .............
Please wait, loading kernel...
Allocated 00a00000 bytes for kernel @ 00200000
   Elf64 kernel loaded...
OF stdout device is: /vdevice/vty@30000000
Hypertas detected, assuming LPAR !
command line: panic=1 debug xmon=on
memory layout at init:
  alloc_bottom : 0000000000ac1000
  alloc_top    : 0000000010000000
  alloc_top_hi : 00000000da000000
  rmo_top      : 0000000010000000
  ram_top      : 00000000da000000
Looking for displays
found display   : /pci@800000020000002/pci@2/pci@1/display@0, opening ... done
instantiating rtas at 0x000000000f6a1000 ... done
0000000000000000 : boot cpu     0000000000000000
0000000000000002 : starting cpu hw idx 0000000000000002... done
0000000000000004 : starting cpu hw idx 0000000000000004... done
0000000000000006 : starting cpu hw idx 0000000000000006... done
copying OF device tree ...
Building dt strings...
Building dt structure...
Device tree strings 0x0000000000cc2000 -> 0x0000000000cc34e4
Device tree struct  0x0000000000cc4000 -> 0x0000000000cd6000
Calling quiesce ...
returning from prom_init
Partition configured for 8 cpus.
Starting Linux PPC64 #2 SMP Tue Jan 15 14:23:02 CET 2008
-----------------------------------------------------
ppc64_pft_size                = 0x1c
physicalMemorySize            = 0xda000000
htab_hash_mask                = 0x1fffff
-----------------------------------------------------
Linux version 2.6.24-rc7-ppc64 (olaf@lingonberry) (gcc version 4.1.2 20070115 (prerelease) (SUSE Linux)) #2 SMP Tue Jan 15 14:23:02 CET 2008
[boot]0012 Setup Arch
EEH: PCI Enhanced I/O Error Handling Enabled
PPC64 nvram contains 8192 bytes
Zone PFN ranges:
  DMA             0 ->   892928
  Normal     892928 ->   892928
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    1:        0 ->   892928
Could not find start_pfn for node 0
[boot]0015 Setup Done
Built 2 zonelists in Node order, mobility grouping on.  Total pages: 880720
Policy zone: DMA
Kernel command line: panic=1 debug xmon=on
[boot]0020 XICS Init
xics: no ISA interrupt controller
[boot]0021 XICS Done
PID hash table entries: 4096 (order: 12, 32768 bytes)
time_init: decrementer frequency = 275.070000 MHz
time_init: processor frequency   = 2197.800000 MHz
clocksource: timebase mult[e8ab05] shift[22] registered
clockevent: decrementer mult[466a] shift[16] cpu[0]
Console: colour dummy device 80x25
console handover: boot [udbg-1] -> real [hvc0]
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
freeing bootmem node 1
Memory: 3496632k/3571712k available (6188k kernel code, 75080k reserved, 1324k data, 1220k bss, 304k init)
Unable to handle kernel paging request for data at address 0x00000040
Faulting instruction address: 0xc000000000437470
cpu 0x0: Vector: 300 (Data Access) at [c00000000075b830]
    pc: c000000000437470: ._spin_lock+0x20/0x88
    lr: c0000000000f78a8: .cache_grow+0x7c/0x338
    sp: c00000000075bab0
   msr: 8000000000009032
   dar: 40
 dsisr: 40000000
  current = 0xc000000000665a50
  paca    = 0xc000000000666380
    pid   = 0, comm = swapper
enter ? for help
[c00000000075bb30] c0000000000f78a8 .cache_grow+0x7c/0x338
[c00000000075bbf0] c0000000000f7d04 .fallback_alloc+0x1a0/0x1f4
[c00000000075bca0] c0000000000f8544 .kmem_cache_alloc+0xec/0x150
[c00000000075bd40] c0000000000fb1c0 .kmem_cache_create+0x208/0x478
[c00000000075be20] c0000000005e670c .kmem_cache_init+0x218/0x4f4
[c00000000075bee0] c0000000005bf8ec .start_kernel+0x2f8/0x3fc
[c00000000075bf90] c000000000008590 .start_here_common+0x60/0xd0
0:mon> 

