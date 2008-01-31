Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbYAaOg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbYAaOg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 09:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbYAaOgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 09:36:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54098 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbYAaOgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 09:36:49 -0500
Subject: Re: OOM-killer invoked but why ?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: r31dmaeu@pc0312b.rz.unibw-muenchen.de
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47A1C4B1.8020607@pc0312a.rz.unibw-muenchen.de>
References: <47A1C4B1.8020607@pc0312a.rz.unibw-muenchen.de>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 15:36:31 +0100
Message-Id: <1201790191.32654.7.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-31 at 13:53 +0100, Claude Frantz wrote:
> Hello !
> 
> I'm faced to a problem where the OOM-killer is invoked but I cannot find
> the reason why. The machine is rather powerfull, the load is very moderate,
> the disk swap space is nearly unused. The only strange observation which
> appears to me is the slow but progressive decreasing of kbbuffers during
> many hours.
> 
> Can you help me to diagnose the problem and to find a good solution ?
> 
> Thanks a lot !
> 
> Claude
> 
> 
> kernel: 2.6.22.14-72.fc6 (Fedora 6)
> 
> "sar -r" output:
> 
> 12:00:01 AM kbmemfree kbmemused  %memused kbbuffers  kbcached kbswpfree kbswpused  %swpused  kbswpcad
> 12:10:01 AM   1739920   1635056     48.45      9368    135620   8192960       148      0.00         0
> 12:20:01 AM   1691180   1683796     49.89      8644    162992   8192960       148      0.00         0
> 12:30:01 AM   1732076   1642900     48.68      8608    141168   8192960       148      0.00         0
> 12:40:01 AM   1766308   1608668     47.66      8128    134744   8192960       148      0.00         0
> 12:50:01 AM   1718156   1656820     49.09      6884    134288   8192960       148      0.00         0
> 01:00:01 AM   1728448   1646528     48.79      6476    137912   8192960       148      0.00         0
> 01:10:01 AM   1707652   1667324     49.40      5792    156572   8192960       148      0.00         0
> 01:20:01 AM   1736928   1638048     48.54      6368    138872   8192960       148      0.00         0
> 01:30:02 AM   1776288   1598688     47.37      5412    145136   8192960       148      0.00         0
> 01:40:01 AM   1780456   1594520     47.25      5464    150536   8192960       148      0.00         0
> 01:50:01 AM   1744856   1630120     48.30      4960    154732   8192960       148      0.00         0
> 02:00:02 AM   1687012   1687964     50.01      3996    171048   8192960       148      0.00         0
> 02:10:01 AM   1696020   1678956     49.75      3916    145424   8192960       148      0.00         0
> 02:20:02 AM   1740864   1634112     48.42      4340    142900   8192960       148      0.00         0
> 02:30:01 AM   1769460   1605516     47.57      3516    138056   8192960       148      0.00         0
> 02:40:02 AM   1764376   1610600     47.72      3184    138844   8192960       148      0.00         0
> 02:50:02 AM   1702100   1672876     49.57      3736    157448   8192960       148      0.00         0
> 03:00:01 AM   1750396   1624580     48.14      3556    141016   8192960       148      0.00         0
> 03:10:02 AM   1744168   1630808     48.32      1900    136612   8192960       148      0.00         0
> 03:20:01 AM   1749388   1625588     48.17      1012    136804   8192960       148      0.00         0
> 03:30:01 AM   1728028   1646948     48.80      1980    139104   8192960       148      0.00         0
> 03:40:01 AM   1718596   1656380     49.08      1136    156932   8192960       148      0.00         0
> 03:50:02 AM   1692684   1682292     49.85       768    140808   8192960       148      0.00         0
> ~~~~~~ OOM-killer in action. Then reboot.
> 07:30:01 AM   2134568   1240408     36.75    233624    506224   8193108         0      0.00         0
> 07:40:01 AM   2104412   1270564     37.65    252204    524220   8193108         0      0.00         0
> 07:50:01 AM   2049712   1325264     39.27    265368    527096   8193108         0      0.00         0
> 08:00:01 AM   1813652   1561324     46.26    281708    527296   8193108         0      0.00         0
> 
> The values in /proc/sys/vm :
> 
> /proc/sys/vm/overcommit_memory
> 0
> /proc/sys/vm/panic_on_oom
> 0
> /proc/sys/vm/overcommit_ratio
> 50
> /proc/sys/vm/page-cluster
> 3
> /proc/sys/vm/dirty_background_ratio
> 5
> /proc/sys/vm/dirty_ratio
> 10
> /proc/sys/vm/dirty_writeback_centisecs
> 499
> /proc/sys/vm/dirty_expire_centisecs
> 2999
> /proc/sys/vm/nr_pdflush_threads
> 2
> /proc/sys/vm/swappiness
> 60
> /proc/sys/vm/nr_hugepages
> 0
> /proc/sys/vm/hugetlb_shm_group
> 0
> /proc/sys/vm/lowmem_reserve_ratio
> 256     32
> /proc/sys/vm/drop_caches
> 0
> /proc/sys/vm/min_free_kbytes
> 3816
> /proc/sys/vm/percpu_pagelist_fraction
> 0
> /proc/sys/vm/max_map_count
> 65536
> /proc/sys/vm/laptop_mode
> 0
> /proc/sys/vm/block_dump
> 0
> /proc/sys/vm/vfs_cache_pressure
> 100
> /proc/sys/vm/legacy_va_layout
> 0
> /proc/sys/vm/stat_interval
> 1
> /proc/sys/vm/vdso_enabled
> 1
> 
> The syslog extract: 
> 
> Jan 28 03:50:24 toaster kernel: ps invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
> Jan 28 03:50:24 toaster kernel:  [<c045cf52>] out_of_memory+0x69/0x1a7
> Jan 28 03:50:24 toaster kernel:  [<c045e3bb>] __alloc_pages+0x216/0x2a0
> Jan 28 03:50:24 toaster kernel:  [<c04a6f1e>] proc_info_read+0x0/0x9d
> Jan 28 03:50:24 toaster kernel:  [<c045e471>] __get_free_pages+0x2c/0x3a
> Jan 28 03:50:24 toaster kernel:  [<c04a6f57>] proc_info_read+0x39/0x9d
> Jan 28 03:50:24 toaster kernel:  [<c04a6f1e>] proc_info_read+0x0/0x9d
> Jan 28 03:50:24 toaster kernel:  [<c0477dda>] vfs_read+0xa6/0x158
> Jan 28 03:50:24 toaster kernel:  [<c0478238>] sys_read+0x41/0x67
> Jan 28 03:50:24 toaster kernel:  [<c0404fa2>] syscall_call+0x7/0xb
> Jan 28 03:50:24 toaster kernel:  =======================
> Jan 28 03:50:24 toaster kernel: Mem-info:
> Jan 28 03:50:24 toaster kernel: DMA per-cpu:
> Jan 28 03:50:35 toaster xinetd[3182]: START: time-dgram pid=0 from=137.193.74.3
> Jan 28 03:50:48 toaster kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> Jan 28 03:50:48 toaster kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> Jan 28 03:50:48 toaster kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> Jan 28 03:50:48 toaster kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> Jan 28 03:50:48 toaster kernel: Normal per-cpu:
> Jan 28 03:50:48 toaster kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  58   Cold: hi:   62, btch:  15 usd:  60
> Jan 28 03:50:48 toaster kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  34   Cold: hi:   62, btch:  15 usd:  60
> Jan 28 03:50:49 toaster kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  42   Cold: hi:   62, btch:  15 usd:  52
> Jan 28 03:50:49 toaster kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  85   Cold: hi:   62, btch:  15 usd:  51
> Jan 28 03:50:49 toaster kernel: HighMem per-cpu:
> Jan 28 03:50:49 toaster kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 176   Cold: hi:   62, btch:  15 usd:   9
> Jan 28 03:50:49 toaster kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  57   Cold: hi:   62, btch:  15 usd:  14
> Jan 28 03:50:49 toaster kernel: CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  11
> Jan 28 03:50:49 toaster kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  55   Cold: hi:   62, btch:  15 usd:   0
> Jan 28 03:50:49 toaster kernel: Active:186294 inactive:2340 dirty:6 writeback:55 unstable:0
> Jan 28 03:50:49 toaster kernel:  free:431675 slab:177466 mapped:7100 pagetables:1915 bounce:0
> Jan 28 03:50:49 toaster kernel: DMA free:3544kB min:68kB low:84kB high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
> Jan 28 03:50:49 toaster kernel: lowmem_reserve[]: 0 873 3285
> Jan 28 03:50:49 toaster kernel: Normal free:3684kB min:3744kB low:4680kB high:5616kB active:212kB inactive:112kB present:894080kB pages_scanned:365 all_unreclaimable? yes
> Jan 28 03:50:49 toaster kernel: lowmem_reserve[]: 0 0 19300
> Jan 28 03:50:49 toaster kernel: HighMem free:1719472kB min:512kB low:3100kB high:5688kB active:744964kB inactive:9248kB present:2470404kB pages_scanned:0 all_unreclaimable? no
> Jan 28 03:50:49 toaster kernel: lowmem_reserve[]: 0 0 0
> Jan 28 03:50:49 toaster kernel: DMA: 3*4kB 4*8kB 3*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3548kB
> Jan 28 03:50:49 toaster kernel: Normal: 30*4kB 29*8kB 8*16kB 1*32kB 3*64kB 5*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 3904kB
> Jan 28 03:50:49 toaster kernel: HighMem: 5991*4kB 8849*8kB 18804*16kB 12622*32kB 7820*64kB 2500*128kB 354*256kB 15*512kB 1*1024kB 0*2048kB 0*4096kB = 1719332kB
> Jan 28 03:50:49 toaster kernel: Swap cache: add 37, delete 37, find 0/0, race 0+0
> Jan 28 03:50:49 toaster kernel: Free swap  = 8192960kB
> Jan 28 03:50:49 toaster kernel: Total swap = 8193108kB
> Jan 28 03:50:49 toaster kernel: Free swap:       8192960kB
> Jan 28 03:50:49 toaster kernel: 851840 pages of RAM
> Jan 28 03:50:49 toaster kernel: 622464 pages of HIGHMEM
> Jan 28 03:50:49 toaster kernel: 8096 reserved pages
> Jan 28 03:50:49 toaster kernel: 638310 pages shared
> Jan 28 03:50:49 toaster kernel: 0 pages swap cached
> Jan 28 03:50:49 toaster kernel: 6 pages dirty
> Jan 28 03:50:49 toaster kernel: 55 pages writeback
> Jan 28 03:50:49 toaster kernel: 7100 pages mapped
> Jan 28 03:50:49 toaster kernel: 177466 pages slab
> Jan 28 03:50:49 toaster kernel: 1915 pages pagetables
> Jan 28 03:50:49 toaster kernel: Out of memory: kill process 10859 (amavisd) score 36218 or a child
> Jan 28 03:50:49 toaster kernel: Killed process 19146 (amavisd)


You seem to have ran out of zone normal memory with all of it stuck in
kernel allocations. Would you have /proc/slabinfo available?

