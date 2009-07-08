Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbZGHNHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbZGHNHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 09:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZGHNHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 09:07:06 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:57335 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbZGHNGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 09:06:54 -0400
Message-ID: <4A5499B4.5050007@in.ibm.com>
Date: Wed, 08 Jul 2009 18:35:56 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: OOM with hackbench against next 0708
References: <20090708173104.d39108bb.sfr@canb.auug.org.au>
In-Reply-To: <20090708173104.d39108bb.sfr@canb.auug.org.au>
Content-Type: multipart/mixed;
 boundary="------------000502040002000200080803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000502040002000200080803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

While executing hackbench against today's next on a 4 way
power6 box (9117 MMA), the machine crawled within few seconds
with lots of OOM messages. I captured a Crash dump and was
able to extract the dmesg log which i have attached here.

This problem started with 0706 next release. 0703 worked fine.

Kernel is compiled with SLQB and 64K page size.

.config attached. Let me know what other information i can
provide to find a solution for this problem.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------000502040002000200080803
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.log"

<4>hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000075943630] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000759436e0] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000759437c0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c000000075943860] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000075943930] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c000000075943a70] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c000000075943b10] [c000000000130da0] .do_wp_page+0x4bc/0xa64
[c000000075943c00] [c0000000001332c0] .handle_mm_fault+0x90c/0x9e4
[c000000075943d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c000000075943e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   2
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   0
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   3
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   0
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:12042 active_file:14 inactive_anon:3658
 inactive_file:54 unevictable:0 dirty:0 writeback:11 unstable:0
 free:104 slab:33828 mapped:48 pagetables:10794 bounce:0
Node 0 DMA free:2240kB min:3264kB low:4032kB high:4864kB active_anon:530240kB inactive_anon:176576kB active_file:768kB inactive_file:1856kB unevictable:0kB present:1702464kB pages_scanned:96 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:4416kB min:4800kB low:5952kB high:7168kB active_anon:240448kB inactive_anon:57536kB active_file:128kB inactive_file:1600kB unevictable:0kB present:2486784kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 14*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 896kB
Node 1 DMA: 51*64kB 7*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4416kB
1078 total pagecache pages
1049 pages in swap cache
Swap cache stats: add 16515, delete 15466, find 33/52
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
64718 pages shared
84524 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9107 or a child
Killed process 2443 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000069223630] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000692236e0] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000692237c0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c000000069223860] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000069223930] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c000000069223a70] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c000000069223b10] [c000000000130da0] .do_wp_page+0x4bc/0xa64
[c000000069223c00] [c0000000001332c0] .handle_mm_fault+0x90c/0x9e4
[c000000069223d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c000000069223e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   1
CPU    1: hi:    6, btch:   1 usd:   4
CPU    2: hi:    6, btch:   1 usd:   0
CPU    3: hi:    6, btch:   1 usd:   0
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   3
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:11952 active_file:28 inactive_anon:3637
 inactive_file:23 unevictable:0 dirty:0 writeback:11 unstable:0
 free:104 slab:33859 mapped:48 pagetables:10794 bounce:0
Node 0 DMA free:2240kB min:3264kB low:4032kB high:4864kB active_anon:527936kB inactive_anon:172672kB active_file:1664kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:98 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:4416kB min:4800kB low:5952kB high:7168kB active_anon:236992kB inactive_anon:60096kB active_file:128kB inactive_file:1600kB unevictable:0kB present:2486784kB pages_scanned:54 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 64kB
Node 1 DMA: 53*64kB 2*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3904kB
1032 total pagecache pages
990 pages in swap cache
Swap cache stats: add 16550, delete 15560, find 35/57
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
64913 pages shared
84559 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9122 or a child
Killed process 2444 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000069223630] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000692236e0] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000692237c0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c000000069223860] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000069223930] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c000000069223a70] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c000000069223b10] [c000000000130da0] .do_wp_page+0x4bc/0xa64
[c000000069223c00] [c0000000001332c0] .handle_mm_fault+0x90c/0x9e4
[c000000069223d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c000000069223e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   1
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   4
CPU    3: hi:    6, btch:   1 usd:   0
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   3
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   2
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:11905 active_file:28 inactive_anon:3813
 inactive_file:23 unevictable:0 dirty:0 writeback:0 unstable:0
 free:104 slab:33859 mapped:48 pagetables:10794 bounce:0
Node 0 DMA free:2240kB min:3264kB low:4032kB high:4864kB active_anon:524928kB inactive_anon:180416kB active_file:1664kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:4416kB min:4800kB low:5952kB high:7168kB active_anon:236992kB inactive_anon:63616kB active_file:128kB inactive_file:1600kB unevictable:0kB present:2486784kB pages_scanned:55 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 128kB
Node 1 DMA: 47*64kB 2*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3520kB
1032 total pagecache pages
997 pages in swap cache
Swap cache stats: add 16568, delete 15571, find 36/59
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
64977 pages shared
84490 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9119 or a child
Killed process 2445 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000069223630] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000692236e0] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000692237c0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c000000069223860] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000069223930] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c000000069223a70] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c000000069223b10] [c000000000130da0] .do_wp_page+0x4bc/0xa64
[c000000069223c00] [c0000000001332c0] .handle_mm_fault+0x90c/0x9e4
[c000000069223d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c000000069223e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   0
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   3
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   3
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:11947 active_file:0 inactive_anon:3693
 inactive_file:24 unevictable:0 dirty:0 writeback:0 unstable:0
 free:104 slab:33859 mapped:48 pagetables:10794 bounce:0
Node 0 DMA free:2240kB min:3264kB low:4032kB high:4864kB active_anon:527616kB inactive_anon:172736kB active_file:0kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:4416kB min:4800kB low:5952kB high:7168kB active_anon:236992kB inactive_anon:63616kB active_file:128kB inactive_file:1600kB unevictable:0kB present:2486784kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 21*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 1472kB
Node 1 DMA: 68*64kB 4*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 5120kB
986 total pagecache pages
968 pages in swap cache
Swap cache stats: add 16583, delete 15615, find 36/60
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
50658 pages shared
84363 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9117 or a child
Killed process 2446 (hackbench)
klogd invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
klogd cpuset=/ mems_allowed=0-15
Call Trace:
[c00000006a423360] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c00000006a423410] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c00000006a4234f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c00000006a423590] [c000000000116848] .out_of_memory+0x1dc/0x240
[c00000006a423660] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c00000006a4237a0] [c00000000014c2c0] .alloc_pages_current+0xcc/0xf4
[c00000006a423840] [c000000000112c9c] .__page_cache_alloc+0x7c/0x98
[c00000006a4238c0] [c00000000011d7e0] .__do_page_cache_readahead+0xb8/0x278
[c00000006a4239b0] [c00000000011d9c8] .ra_submit+0x28/0x38
[c00000006a423a20] [c000000000113414] .filemap_fault+0x1e0/0x420
[c00000006a423af0] [c000000000130044] .__do_fault+0xa4/0x66c
[c00000006a423c00] [c000000000132dbc] .handle_mm_fault+0x408/0x9e4
[c00000006a423d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c00000006a423e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   0
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   0
CPU    3: hi:    6, btch:   1 usd:   0
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   4
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   4
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:11881 active_file:0 inactive_anon:3651
 inactive_file:24 unevictable:0 dirty:0 writeback:0 unstable:0
 free:135 slab:33859 mapped:48 pagetables:10794 bounce:0
Node 0 DMA free:4224kB min:3264kB low:4032kB high:4864kB active_anon:523392kB inactive_anon:173504kB active_file:0kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:128 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:4416kB min:4800kB low:5952kB high:7168kB active_anon:236992kB inactive_anon:60160kB active_file:128kB inactive_file:1600kB unevictable:0kB present:2486784kB pages_scanned:64 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 0kB
Node 1 DMA: 70*64kB 2*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4992kB
1032 total pagecache pages
925 pages in swap cache
Swap cache stats: add 16603, delete 15678, find 40/66
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
50872 pages shared
84277 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9127 or a child
Killed process 2447 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000069223630] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000692236e0] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000692237c0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c000000069223860] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000069223930] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c000000069223a70] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c000000069223b10] [c000000000130da0] .do_wp_page+0x4bc/0xa64
[c000000069223c00] [c0000000001332c0] .handle_mm_fault+0x90c/0x9e4
[c000000069223d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c000000069223e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   1
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   0
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   4
CPU    3: hi:    6, btch:   1 usd:   2
Active_anon:11881 active_file:0 inactive_anon:3661
 inactive_file:24 unevictable:0 dirty:0 writeback:0 unstable:0
 free:141 slab:33859 mapped:48 pagetables:10794 bounce:0
Node 0 DMA free:2240kB min:3264kB low:4032kB high:4864kB active_anon:519872kB inactive_anon:174144kB active_file:0kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:6784kB min:4800kB low:5952kB high:7168kB active_anon:240512kB inactive_anon:60160kB active_file:128kB inactive_file:1600kB unevictable:0kB present:2486784kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 10*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 768kB
Node 1 DMA: 86*64kB 6*128kB 3*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 7040kB
931 total pagecache pages
881 pages in swap cache
Swap cache stats: add 16625, delete 15744, find 41/69
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
50850 pages shared
84232 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9124 or a child
Killed process 2448 (hackbench)
hackbench invoked oom-killer: gfp_mask=0xd0, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000069223620] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000692236d0] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000692237b0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c000000069223850] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000069223920] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c000000069223a60] [c000000000150904] .__slab_alloc_page+0x110/0x470
[c000000069223b20] [c00000000015219c] .kmem_cache_alloc+0x14c/0x22c
[c000000069223be0] [c00000000008d408] .copy_process+0x674/0x1108
[c000000069223cd0] [c00000000008e024] .do_fork+0x188/0x414
[c000000069223dc0] [c000000000011228] .sys_clone+0x58/0x70
[c000000069223e30] [c000000000008770] .ppc_clone+0x8/0xc
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   1
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   0
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   2
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:11870 active_file:0 inactive_anon:3645
 inactive_file:24 unevictable:0 dirty:0 writeback:0 unstable:0
 free:104 slab:33859 mapped:48 pagetables:10794 bounce:0
Node 0 DMA free:2240kB min:3264kB low:4032kB high:4864kB active_anon:522816kB inactive_anon:176768kB active_file:0kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:4416kB min:4800kB low:5952kB high:7168kB active_anon:236864kB inactive_anon:56512kB active_file:128kB inactive_file:1600kB unevictable:0kB present:2486784kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 19*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 1344kB
Node 1 DMA: 39*64kB 7*128kB 4*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4416kB
931 total pagecache pages
860 pages in swap cache
Swap cache stats: add 16641, delete 15781, find 41/70
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
50836 pages shared
84322 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9132 or a child
Killed process 2449 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x4d0, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000069223320] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000692233d0] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000692234b0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c000000069223550] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000069223620] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c000000069223760] [c000000000150904] .__slab_alloc_page+0x110/0x470
[c000000069223820] [c00000000015219c] .kmem_cache_alloc+0x14c/0x22c
[c0000000692238e0] [c00000000012ff10] .__pmd_alloc+0x3c/0xcc
[c000000069223980] [c0000000001349ec] .copy_page_range+0x19c/0x6f8
[c000000069223af0] [c00000000008cbb4] .dup_mm+0x33c/0x4bc
[c000000069223be0] [c00000000008d664] .copy_process+0x8d0/0x1108
[c000000069223cd0] [c00000000008e024] .do_fork+0x188/0x414
[c000000069223dc0] [c000000000011228] .sys_clone+0x58/0x70
[c000000069223e30] [c000000000008770] .ppc_clone+0x8/0xc
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   2
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   3
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   1
CPU    1: hi:    6, btch:   1 usd:   4
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:11917 active_file:27 inactive_anon:3589
 inactive_file:11 unevictable:0 dirty:0 writeback:0 unstable:0
 free:70 slab:33945 mapped:37 pagetables:10811 bounce:0
Node 0 DMA free:1216kB min:3264kB low:4032kB high:4864kB active_anon:528320kB inactive_anon:174464kB active_file:448kB inactive_file:768kB unevictable:0kB present:1702464kB pages_scanned:54 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3264kB min:4800kB low:5952kB high:7168kB active_anon:234368kB inactive_anon:55232kB active_file:1280kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:53 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 21*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 1472kB
Node 1 DMA: 39*64kB 2*128kB 2*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3264kB
882 total pagecache pages
837 pages in swap cache
Swap cache stats: add 16657, delete 15820, find 41/71
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
50763 pages shared
84451 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9137 or a child
Killed process 2450 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9135 or a child
Killed process 2451 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9132 or a child
Killed process 2452 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9155 or a child
Killed process 2453 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9171 or a child
Killed process 2454 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9168 or a child
Killed process 2455 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9165 or a child
Killed process 2456 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9173 or a child
Killed process 2457 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9173 or a child
Killed process 2458 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9178 or a child
Killed process 2459 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9176 or a child
Killed process 2460 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9178 or a child
Killed process 2461 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9176 or a child
Killed process 2462 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9173 or a child
Killed process 2463 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9171 or a child
Killed process 2464 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9168 or a child
Killed process 2465 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9165 or a child
Killed process 2466 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9163 or a child
Killed process 2467 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9160 or a child
Killed process 2468 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9158 or a child
Killed process 2469 (hackbench)
__ratelimit: 19 callbacks suppressed
hackbench invoked oom-killer: gfp_mask=0x4d0, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000049d07160] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c000000049d07210] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c000000049d072f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c000000049d07390] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000049d07460] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c000000049d075a0] [c000000000150904] .__slab_alloc_page+0x110/0x470
[c000000049d07660] [c000000000151038] .__kmalloc_node_track_caller+0x140/0x224
[c000000049d07720] [c0000000004dc730] .__alloc_skb+0x90/0x198
[c000000049d077d0] [c0000000004d5da4] .sock_alloc_send_pskb+0x100/0x3d0
[c000000049d078f0] [c0000000005705d0] .unix_stream_sendmsg+0x1d8/0x430
[c000000049d07a10] [c0000000004d1504] .sock_aio_write+0x16c/0x19c
[c000000049d07b40] [c00000000015d1a4] .do_sync_write+0xcc/0x130
[c000000049d07ce0] [c00000000015df10] .vfs_write+0xec/0x1dc
[c000000049d07d80] [c00000000015e108] .SyS_write+0x58/0xa0
[c000000049d07e30] [c000000000008534] syscall_exit+0x0/0x40
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:8906 active_file:34 inactive_anon:3116
 inactive_file:0 unevictable:0 dirty:0 writeback:2 unstable:0
 free:74 slab:34056 mapped:14 pagetables:10874 bounce:0
Node 0 DMA free:3200kB min:3264kB low:4032kB high:4864kB active_anon:427136kB inactive_anon:167104kB active_file:1216kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:96 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:1536kB min:4800kB low:5952kB high:7168kB active_anon:142848kB inactive_anon:32320kB active_file:960kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 54*64kB 9*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4608kB
Node 1 DMA: 22*64kB 0*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 2432kB
648 total pagecache pages
586 pages in swap cache
Swap cache stats: add 17508, delete 16922, find 101/376
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
7625 pages shared
79278 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9155 or a child
Killed process 2470 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x4d0, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000049d07160] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c000000049d07210] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c000000049d072f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c000000049d07390] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000049d07460] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c000000049d075a0] [c000000000150904] .__slab_alloc_page+0x110/0x470
[c000000049d07660] [c000000000151038] .__kmalloc_node_track_caller+0x140/0x224
[c000000049d07720] [c0000000004dc730] .__alloc_skb+0x90/0x198
[c000000049d077d0] [c0000000004d5da4] .sock_alloc_send_pskb+0x100/0x3d0
[c000000049d078f0] [c0000000005705d0] .unix_stream_sendmsg+0x1d8/0x430
[c000000049d07a10] [c0000000004d1504] .sock_aio_write+0x16c/0x19c
[c000000049d07b40] [c00000000015d1a4] .do_sync_write+0xcc/0x130
[c000000049d07ce0] [c00000000015df10] .vfs_write+0xec/0x1dc
[c000000049d07d80] [c00000000015e108] .SyS_write+0x58/0xa0
[c000000049d07e30] [c000000000008534] syscall_exit+0x0/0x40
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:8665 active_file:34 inactive_anon:2990
 inactive_file:0 unevictable:0 dirty:0 writeback:2 unstable:0
 free:74 slab:34056 mapped:14 pagetables:10874 bounce:0
Node 0 DMA free:3200kB min:3264kB low:4032kB high:4864kB active_anon:427136kB inactive_anon:159040kB active_file:1216kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:128 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:1536kB min:4800kB low:5952kB high:7168kB active_anon:127424kB inactive_anon:32320kB active_file:960kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:288 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 53*64kB 9*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4544kB
Node 1 DMA: 22*64kB 0*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 2432kB
648 total pagecache pages
597 pages in swap cache
Swap cache stats: add 17522, delete 16925, find 101/377
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
8137 pages shared
78768 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9153 or a child
Killed process 2471 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x4d0, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000049d07160] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c000000049d07210] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c000000049d072f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c000000049d07390] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000049d07460] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c000000049d075a0] [c000000000150904] .__slab_alloc_page+0x110/0x470
[c000000049d07660] [c000000000151038] .__kmalloc_node_track_caller+0x140/0x224
[c000000049d07720] [c0000000004dc730] .__alloc_skb+0x90/0x198
[c000000049d077d0] [c0000000004d5da4] .sock_alloc_send_pskb+0x100/0x3d0
[c000000049d078f0] [c0000000005705d0] .unix_stream_sendmsg+0x1d8/0x430
[c000000049d07a10] [c0000000004d1504] .sock_aio_write+0x16c/0x19c
[c000000049d07b40] [c00000000015d1a4] .do_sync_write+0xcc/0x130
[c000000049d07ce0] [c00000000015df10] .vfs_write+0xec/0x1dc
[c000000049d07d80] [c00000000015e108] .SyS_write+0x58/0xa0
[c000000049d07e30] [c000000000008534] syscall_exit+0x0/0x40
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   3
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:8711 active_file:34 inactive_anon:2799
 inactive_file:0 unevictable:0 dirty:0 writeback:2 unstable:0
 free:74 slab:34056 mapped:14 pagetables:10874 bounce:0
Node 0 DMA free:3200kB min:3264kB low:4032kB high:4864kB active_anon:430080kB inactive_anon:146816kB active_file:1216kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:160 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:1536kB min:4800kB low:5952kB high:7168kB active_anon:127424kB inactive_anon:32320kB active_file:960kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:288 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 52*64kB 10*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4608kB
Node 1 DMA: 22*64kB 0*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 2432kB
648 total pagecache pages
600 pages in swap cache
Swap cache stats: add 17538, delete 16938, find 101/378
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
8375 pages shared
78514 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9150 or a child
Killed process 2472 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x4d0, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000049d07160] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c000000049d07210] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c000000049d072f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c000000049d07390] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000049d07460] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c000000049d075a0] [c000000000150904] .__slab_alloc_page+0x110/0x470
[c000000049d07660] [c000000000151038] .__kmalloc_node_track_caller+0x140/0x224
[c000000049d07720] [c0000000004dc730] .__alloc_skb+0x90/0x198
[c000000049d077d0] [c0000000004d5da4] .sock_alloc_send_pskb+0x100/0x3d0
[c000000049d078f0] [c0000000005705d0] .unix_stream_sendmsg+0x1d8/0x430
[c000000049d07a10] [c0000000004d1504] .sock_aio_write+0x16c/0x19c
[c000000049d07b40] [c00000000015d1a4] .do_sync_write+0xcc/0x130
[c000000049d07ce0] [c00000000015df10] .vfs_write+0xec/0x1dc
[c000000049d07d80] [c00000000015e108] .SyS_write+0x58/0xa0
[c000000049d07e30] [c000000000008534] syscall_exit+0x0/0x40
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   3
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:7122 active_file:24 inactive_anon:2174
 inactive_file:0 unevictable:0 dirty:0 writeback:0 unstable:0
 free:90 slab:34077 mapped:4 pagetables:10862 bounce:0
Node 0 DMA free:2688kB min:3264kB low:4032kB high:4864kB active_anon:338624kB inactive_anon:108864kB active_file:1216kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3072kB min:4800kB low:5952kB high:7168kB active_anon:117184kB inactive_anon:30272kB active_file:320kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:231 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 43*64kB 4*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3264kB
Node 1 DMA: 32*64kB 0*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3072kB
646 total pagecache pages
616 pages in swap cache
Swap cache stats: add 17887, delete 17271, find 111/438
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
11327 pages shared
74144 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9148 or a child
Killed process 2473 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x4d0, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000049633160] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c000000049633210] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000496332f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c000000049633390] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000049633460] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000496335a0] [c000000000150904] .__slab_alloc_page+0x110/0x470
[c000000049633660] [c000000000151ea0] .kmem_cache_alloc_node+0x12c/0x20c
[c000000049633720] [c0000000004dc708] .__alloc_skb+0x68/0x198
[c0000000496337d0] [c0000000004d5da4] .sock_alloc_send_pskb+0x100/0x3d0
[c0000000496338f0] [c0000000005705d0] .unix_stream_sendmsg+0x1d8/0x430
[c000000049633a10] [c0000000004d1504] .sock_aio_write+0x16c/0x19c
[c000000049633b40] [c00000000015d1a4] .do_sync_write+0xcc/0x130
[c000000049633ce0] [c00000000015df10] .vfs_write+0xec/0x1dc
[c000000049633d80] [c00000000015e108] .SyS_write+0x58/0xa0
[c000000049633e30] [c000000000008534] syscall_exit+0x0/0x40
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   3
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:6932 active_file:24 inactive_anon:2171
 inactive_file:1 unevictable:0 dirty:0 writeback:0 unstable:0
 free:81 slab:34078 mapped:5 pagetables:10859 bounce:0
Node 0 DMA free:2112kB min:3264kB low:4032kB high:4864kB active_anon:326464kB inactive_anon:108672kB active_file:1216kB inactive_file:64kB unevictable:0kB present:1702464kB pages_scanned:72 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3072kB min:4800kB low:5952kB high:7168kB active_anon:117184kB inactive_anon:30272kB active_file:320kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:231 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 50*64kB 4*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3712kB
Node 1 DMA: 32*64kB 0*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3072kB
654 total pagecache pages
622 pages in swap cache
Swap cache stats: add 17896, delete 17274, find 112/439
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
11649 pages shared
73810 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9145 or a child
Killed process 2474 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x4d0, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000049633160] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c000000049633210] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000496332f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c000000049633390] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000049633460] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000496335a0] [c000000000150904] .__slab_alloc_page+0x110/0x470
[c000000049633660] [c000000000151ea0] .kmem_cache_alloc_node+0x12c/0x20c
[c000000049633720] [c0000000004dc708] .__alloc_skb+0x68/0x198
[c0000000496337d0] [c0000000004d5da4] .sock_alloc_send_pskb+0x100/0x3d0
[c0000000496338f0] [c0000000005705d0] .unix_stream_sendmsg+0x1d8/0x430
[c000000049633a10] [c0000000004d1504] .sock_aio_write+0x16c/0x19c
[c000000049633b40] [c00000000015d1a4] .do_sync_write+0xcc/0x130
[c000000049633ce0] [c00000000015df10] .vfs_write+0xec/0x1dc
[c000000049633d80] [c00000000015e108] .SyS_write+0x58/0xa0
[c000000049633e30] [c000000000008534] syscall_exit+0x0/0x40
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   0
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:6825 active_file:19 inactive_anon:2045
 inactive_file:5 unevictable:0 dirty:0 writeback:6 unstable:0
 free:78 slab:34057 mapped:4 pagetables:10856 bounce:0
Node 0 DMA free:1920kB min:3264kB low:4032kB high:4864kB active_anon:323712kB inactive_anon:104704kB active_file:1216kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:185 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3072kB min:4800kB low:5952kB high:7168kB active_anon:113088kB inactive_anon:26176kB active_file:0kB inactive_file:320kB unevictable:0kB present:2486784kB pages_scanned:268 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 29*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 1856kB
Node 1 DMA: 32*64kB 0*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3072kB
699 total pagecache pages
664 pages in swap cache
Swap cache stats: add 17945, delete 17281, find 113/444
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
11936 pages shared
73584 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9142 or a child
Killed process 2475 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x4d0, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000049633160] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c000000049633210] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000496332f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c000000049633390] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000049633460] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000496335a0] [c000000000150904] .__slab_alloc_page+0x110/0x470
[c000000049633660] [c000000000151ea0] .kmem_cache_alloc_node+0x12c/0x20c
[c000000049633720] [c0000000004dc708] .__alloc_skb+0x68/0x198
[c0000000496337d0] [c0000000004d5da4] .sock_alloc_send_pskb+0x100/0x3d0
[c0000000496338f0] [c0000000005705d0] .unix_stream_sendmsg+0x1d8/0x430
[c000000049633a10] [c0000000004d1504] .sock_aio_write+0x16c/0x19c
[c000000049633b40] [c00000000015d1a4] .do_sync_write+0xcc/0x130
[c000000049633ce0] [c00000000015df10] .vfs_write+0xec/0x1dc
[c000000049633d80] [c00000000015e108] .SyS_write+0x58/0xa0
[c000000049633e30] [c000000000008534] syscall_exit+0x0/0x40
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:6418 active_file:19 inactive_anon:1953
 inactive_file:5 unevictable:0 dirty:0 writeback:6 unstable:0
 free:78 slab:34057 mapped:4 pagetables:10856 bounce:0
Node 0 DMA free:1920kB min:3264kB low:4032kB high:4864kB active_anon:309952kB inactive_anon:98816kB active_file:1216kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3072kB min:4800kB low:5952kB high:7168kB active_anon:100800kB inactive_anon:26176kB active_file:0kB inactive_file:320kB unevictable:0kB present:2486784kB pages_scanned:492 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 40*64kB 4*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3328kB
Node 1 DMA: 32*64kB 0*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3072kB
699 total pagecache pages
639 pages in swap cache
Swap cache stats: add 17962, delete 17323, find 113/446
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
12722 pages shared
72736 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9140 or a child
Killed process 2476 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x4d0, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000049633160] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c000000049633210] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000496332f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c000000049633390] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000049633460] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000496335a0] [c000000000150904] .__slab_alloc_page+0x110/0x470
[c000000049633660] [c000000000151ea0] .kmem_cache_alloc_node+0x12c/0x20c
[c000000049633720] [c0000000004dc708] .__alloc_skb+0x68/0x198
[c0000000496337d0] [c0000000004d5da4] .sock_alloc_send_pskb+0x100/0x3d0
[c0000000496338f0] [c0000000005705d0] .unix_stream_sendmsg+0x1d8/0x430
[c000000049633a10] [c0000000004d1504] .sock_aio_write+0x16c/0x19c
[c000000049633b40] [c00000000015d1a4] .do_sync_write+0xcc/0x130
[c000000049633ce0] [c00000000015df10] .vfs_write+0xec/0x1dc
[c000000049633d80] [c00000000015e108] .SyS_write+0x58/0xa0
[c000000049633e30] [c000000000008534] syscall_exit+0x0/0x40
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   3
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   0
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:6001 active_file:24 inactive_anon:1886
 inactive_file:0 unevictable:0 dirty:0 writeback:1 unstable:0
 free:62 slab:34061 mapped:4 pagetables:10850 bounce:0
Node 0 DMA free:896kB min:3264kB low:4032kB high:4864kB active_anon:285312kB inactive_anon:94528kB active_file:1216kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:160 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3072kB min:4800kB low:5952kB high:7168kB active_anon:98752kB inactive_anon:26176kB active_file:320kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:34 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 5*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 320kB
Node 1 DMA: 37*64kB 0*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3392kB
724 total pagecache pages
707 pages in swap cache
Swap cache stats: add 18080, delete 17373, find 116/459
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
13724 pages shared
71879 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9137 or a child
Killed process 2477 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000f6032c40] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000f6032cf0] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000f6032dd0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000f6032e70] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000f6032f40] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000f6033080] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c0000000f6033120] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c0000000f60331f0] [c000000000141148] .swapin_readahead+0x54/0xd4
[c0000000f60332b0] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c0000000f60333b0] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000f60334e0] [c0000000000055fc] handle_page_fault+0x20/0x5c
--- Exception: 301 at .__copy_tofrom_user+0x28c/0x580
    LR = .copy_from_user+0x3c/0x74
[c0000000f60337d0] [c0000000004d5da4] .sock_alloc_send_pskb+0x100/0x3d0 (unreliable)
[c0000000f6033850] [c0000000004ddd68] .memcpy_fromiovec+0x60/0xc4
[c0000000f60338f0] [c000000000570664] .unix_stream_sendmsg+0x26c/0x430
[c0000000f6033a10] [c0000000004d1504] .sock_aio_write+0x16c/0x19c
[c0000000f6033b40] [c00000000015d1a4] .do_sync_write+0xcc/0x130
[c0000000f6033ce0] [c00000000015df10] .vfs_write+0xec/0x1dc
[c0000000f6033d80] [c00000000015e108] .SyS_write+0x58/0xa0
[c0000000f6033e30] [c000000000008534] syscall_exit+0x0/0x40
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   3
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   0
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:5831 active_file:24 inactive_anon:1854
 inactive_file:0 unevictable:0 dirty:0 writeback:1 unstable:0
 free:62 slab:34061 mapped:4 pagetables:10850 bounce:0
Node 0 DMA free:896kB min:3264kB low:4032kB high:4864kB active_anon:274432kB inactive_anon:92480kB active_file:1216kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:192 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3072kB min:4800kB low:5952kB high:7168kB active_anon:98752kB inactive_anon:26176kB active_file:320kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:34 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 13*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 832kB
Node 1 DMA: 37*64kB 0*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3392kB
724 total pagecache pages
709 pages in swap cache
Swap cache stats: add 18094, delete 17385, find 119/464
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
14161 pages shared
71423 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9135 or a child
Killed process 2478 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000f6032c40] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000f6032cf0] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000f6032dd0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000f6032e70] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000f6032f40] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000f6033080] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c0000000f6033120] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c0000000f60331f0] [c000000000141148] .swapin_readahead+0x54/0xd4
[c0000000f60332b0] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c0000000f60333b0] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000f60334e0] [c0000000000055fc] handle_page_fault+0x20/0x5c
--- Exception: 301 at .__copy_tofrom_user+0x28c/0x580
    LR = .copy_from_user+0x3c/0x74
[c0000000f60337d0] [c0000000004d5da4] .sock_alloc_send_pskb+0x100/0x3d0 (unreliable)
[c0000000f6033850] [c0000000004ddd68] .memcpy_fromiovec+0x60/0xc4
[c0000000f60338f0] [c000000000570664] .unix_stream_sendmsg+0x26c/0x430
[c0000000f6033a10] [c0000000004d1504] .sock_aio_write+0x16c/0x19c
[c0000000f6033b40] [c00000000015d1a4] .do_sync_write+0xcc/0x130
[c0000000f6033ce0] [c00000000015df10] .vfs_write+0xec/0x1dc
[c0000000f6033d80] [c00000000015e108] .SyS_write+0x58/0xa0
[c0000000f6033e30] [c000000000008534] syscall_exit+0x0/0x40
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:6305 active_file:6 inactive_anon:2628
 inactive_file:0 unevictable:0 dirty:0 writeback:0 unstable:0
 free:90 slab:34037 mapped:6 pagetables:10844 bounce:0
Node 0 DMA free:2048kB min:3264kB low:4032kB high:4864kB active_anon:297216kB inactive_anon:95232kB active_file:64kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:33 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3712kB min:4800kB low:5952kB high:7168kB active_anon:106304kB inactive_anon:72960kB active_file:320kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:71 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 48*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3200kB
Node 1 DMA: 42*64kB 0*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3712kB
776 total pagecache pages
716 pages in swap cache
Swap cache stats: add 18199, delete 17483, find 120/474
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
12554 pages shared
73042 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9132 or a child
Killed process 2479 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9130 or a child
Killed process 2480 (hackbench)
__ratelimit: 1 callbacks suppressed
hackbench invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000ec173360] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000ec173410] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000ec1734f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000ec173590] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000ec173660] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000ec1737a0] [c00000000014c2c0] .alloc_pages_current+0xcc/0xf4
[c0000000ec173840] [c000000000112c9c] .__page_cache_alloc+0x7c/0x98
[c0000000ec1738c0] [c00000000011d7e0] .__do_page_cache_readahead+0xb8/0x278
[c0000000ec1739b0] [c00000000011d9c8] .ra_submit+0x28/0x38
[c0000000ec173a20] [c000000000113414] .filemap_fault+0x1e0/0x420
[c0000000ec173af0] [c000000000130044] .__do_fault+0xa4/0x66c
[c0000000ec173c00] [c000000000132dbc] .handle_mm_fault+0x408/0x9e4
[c0000000ec173d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000ec173e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   4
CPU    3: hi:    6, btch:   1 usd:   4
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   3
Active_anon:3888 active_file:5 inactive_anon:1876
 inactive_file:0 unevictable:0 dirty:0 writeback:1 unstable:0
 free:101 slab:34023 mapped:8 pagetables:10838 bounce:0
Node 0 DMA free:3200kB min:3264kB low:4032kB high:4864kB active_anon:191872kB inactive_anon:105792kB active_file:0kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3264kB min:4800kB low:5952kB high:7168kB active_anon:56960kB inactive_anon:14272kB active_file:320kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:352 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 80*64kB 6*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 5888kB
Node 1 DMA: 40*64kB 5*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4224kB
624 total pagecache pages
577 pages in swap cache
Swap cache stats: add 19046, delete 18469, find 165/745
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
18738 pages shared
68416 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9127 or a child
Killed process 2481 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000ec173360] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000ec173410] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000ec1734f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000ec173590] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000ec173660] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000ec1737a0] [c00000000014c2c0] .alloc_pages_current+0xcc/0xf4
[c0000000ec173840] [c000000000112c9c] .__page_cache_alloc+0x7c/0x98
[c0000000ec1738c0] [c00000000011d7e0] .__do_page_cache_readahead+0xb8/0x278
[c0000000ec1739b0] [c00000000011d9c8] .ra_submit+0x28/0x38
[c0000000ec173a20] [c000000000113414] .filemap_fault+0x1e0/0x420
[c0000000ec173af0] [c000000000130044] .__do_fault+0xa4/0x66c
[c0000000ec173c00] [c000000000132dbc] .handle_mm_fault+0x408/0x9e4
[c0000000ec173d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000ec173e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   2
CPU    3: hi:    6, btch:   1 usd:   0
Active_anon:877 active_file:0 inactive_anon:279
 inactive_file:5 unevictable:0 dirty:0 writeback:1 unstable:0
 free:81 slab:34106 mapped:11 pagetables:10835 bounce:0
Node 0 DMA free:1792kB min:3264kB low:4032kB high:4864kB active_anon:55680kB inactive_anon:13760kB active_file:0kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3392kB min:4800kB low:5952kB high:7168kB active_anon:448kB inactive_anon:4096kB active_file:0kB inactive_file:320kB unevictable:0kB present:2486784kB pages_scanned:12 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 71*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4928kB
Node 1 DMA: 31*64kB 3*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3392kB
568 total pagecache pages
503 pages in swap cache
Swap cache stats: add 20229, delete 19726, find 189/930
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
27064 pages shared
60266 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9124 or a child
Killed process 2482 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000ec173360] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000ec173410] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000ec1734f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000ec173590] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000ec173660] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000ec1737a0] [c00000000014c2c0] .alloc_pages_current+0xcc/0xf4
[c0000000ec173840] [c000000000112c9c] .__page_cache_alloc+0x7c/0x98
[c0000000ec1738c0] [c00000000011d7e0] .__do_page_cache_readahead+0xb8/0x278
[c0000000ec1739b0] [c00000000011d9c8] .ra_submit+0x28/0x38
[c0000000ec173a20] [c000000000113414] .filemap_fault+0x1e0/0x420
[c0000000ec173af0] [c000000000130044] .__do_fault+0xa4/0x66c
[c0000000ec173c00] [c000000000132dbc] .handle_mm_fault+0x408/0x9e4
[c0000000ec173d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000ec173e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   0
CPU    2: hi:    6, btch:   1 usd:   0
CPU    3: hi:    6, btch:   1 usd:   0
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:162 active_file:0 inactive_anon:109
 inactive_file:26 unevictable:0 dirty:0 writeback:1 unstable:0
 free:83 slab:34094 mapped:11 pagetables:10832 bounce:0
Node 0 DMA free:1920kB min:3264kB low:4032kB high:4864kB active_anon:8384kB inactive_anon:6912kB active_file:0kB inactive_file:1472kB unevictable:0kB present:1702464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3392kB min:4800kB low:5952kB high:7168kB active_anon:1984kB inactive_anon:64kB active_file:0kB inactive_file:192kB unevictable:0kB present:2486784kB pages_scanned:1614 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 8*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 512kB
Node 1 DMA: 33*64kB 2*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3392kB
685 total pagecache pages
627 pages in swap cache
Swap cache stats: add 21159, delete 20532, find 212/1055
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
27931 pages shared
58389 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9122 or a child
Killed process 2483 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000ec173360] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000ec173410] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000ec1734f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000ec173590] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000ec173660] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000ec1737a0] [c00000000014c2c0] .alloc_pages_current+0xcc/0xf4
[c0000000ec173840] [c000000000112c9c] .__page_cache_alloc+0x7c/0x98
[c0000000ec1738c0] [c00000000011d7e0] .__do_page_cache_readahead+0xb8/0x278
[c0000000ec1739b0] [c00000000011d9c8] .ra_submit+0x28/0x38
[c0000000ec173a20] [c000000000113414] .filemap_fault+0x1e0/0x420
[c0000000ec173af0] [c000000000130044] .__do_fault+0xa4/0x66c
[c0000000ec173c00] [c000000000132dbc] .handle_mm_fault+0x408/0x9e4
[c0000000ec173d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000ec173e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   1
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:229 active_file:9 inactive_anon:192
 inactive_file:2 unevictable:0 dirty:0 writeback:15 unstable:0
 free:79 slab:34083 mapped:14 pagetables:10829 bounce:0
Node 0 DMA free:1664kB min:3264kB low:4032kB high:4864kB active_anon:12672kB inactive_anon:8192kB active_file:384kB inactive_file:128kB unevictable:0kB present:1702464kB pages_scanned:143 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3392kB min:4800kB low:5952kB high:7168kB active_anon:1984kB inactive_anon:4096kB active_file:192kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:2102 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 40*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 2560kB
Node 1 DMA: 33*64kB 2*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3392kB
622 total pagecache pages
588 pages in swap cache
Swap cache stats: add 21495, delete 20907, find 228/1107
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
26518 pages shared
58693 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9119 or a child
Killed process 2484 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000ec173360] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000ec173410] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000ec1734f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000ec173590] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000ec173660] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000ec1737a0] [c00000000014c2c0] .alloc_pages_current+0xcc/0xf4
[c0000000ec173840] [c000000000112c9c] .__page_cache_alloc+0x7c/0x98
[c0000000ec1738c0] [c00000000011d7e0] .__do_page_cache_readahead+0xb8/0x278
[c0000000ec1739b0] [c00000000011d9c8] .ra_submit+0x28/0x38
[c0000000ec173a20] [c000000000113414] .filemap_fault+0x1e0/0x420
[c0000000ec173af0] [c000000000130044] .__do_fault+0xa4/0x66c
[c0000000ec173c00] [c000000000132dbc] .handle_mm_fault+0x408/0x9e4
[c0000000ec173d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000ec173e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   4
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   2
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:99 active_file:0 inactive_anon:156
 inactive_file:3 unevictable:0 dirty:0 writeback:1 unstable:0
 free:88 slab:34092 mapped:6 pagetables:10826 bounce:0
Node 0 DMA free:1856kB min:3264kB low:4032kB high:4864kB active_anon:1472kB inactive_anon:6016kB active_file:0kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:64 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3776kB min:4800kB low:5952kB high:7168kB active_anon:4864kB inactive_anon:3968kB active_file:0kB inactive_file:192kB unevictable:0kB present:2486784kB pages_scanned:159 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 44*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3072kB
Node 1 DMA: 64*64kB 2*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 5376kB
679 total pagecache pages
559 pages in swap cache
Swap cache stats: add 21988, delete 21429, find 241/1168
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
27082 pages shared
58307 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9117 or a child
Killed process 2485 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000ec173360] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000ec173410] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000ec1734f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000ec173590] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000ec173660] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000ec1737a0] [c00000000014c2c0] .alloc_pages_current+0xcc/0xf4
[c0000000ec173840] [c000000000112c9c] .__page_cache_alloc+0x7c/0x98
[c0000000ec1738c0] [c00000000011d7e0] .__do_page_cache_readahead+0xb8/0x278
[c0000000ec1739b0] [c00000000011d9c8] .ra_submit+0x28/0x38
[c0000000ec173a20] [c000000000113414] .filemap_fault+0x1e0/0x420
[c0000000ec173af0] [c000000000130044] .__do_fault+0xa4/0x66c
[c0000000ec173c00] [c000000000132dbc] .handle_mm_fault+0x408/0x9e4
[c0000000ec173d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000ec173e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   0
CPU    2: hi:    6, btch:   1 usd:   4
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   1
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   0
CPU    3: hi:    6, btch:   1 usd:   0
Active_anon:293 active_file:7 inactive_anon:94
 inactive_file:4 unevictable:0 dirty:0 writeback:2 unstable:0
 free:85 slab:34076 mapped:12 pagetables:10823 bounce:0
Node 0 DMA free:2432kB min:3264kB low:4032kB high:4864kB active_anon:9792kB inactive_anon:3648kB active_file:192kB inactive_file:256kB unevictable:0kB present:1702464kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3008kB min:4800kB low:5952kB high:7168kB active_anon:8960kB inactive_anon:2368kB active_file:256kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:55 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 40*64kB 4*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3072kB
Node 1 DMA: 22*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 1408kB
619 total pagecache pages
588 pages in swap cache
Swap cache stats: add 22529, delete 21941, find 251/1236
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
27364 pages shared
58528 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9114 or a child
Killed process 2486 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000ec173360] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000ec173410] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000ec1734f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000ec173590] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000ec173660] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000ec1737a0] [c00000000014c2c0] .alloc_pages_current+0xcc/0xf4
[c0000000ec173840] [c000000000112c9c] .__page_cache_alloc+0x7c/0x98
[c0000000ec1738c0] [c00000000011d7e0] .__do_page_cache_readahead+0xb8/0x278
[c0000000ec1739b0] [c00000000011d9c8] .ra_submit+0x28/0x38
[c0000000ec173a20] [c000000000113414] .filemap_fault+0x1e0/0x420
[c0000000ec173af0] [c000000000130044] .__do_fault+0xa4/0x66c
[c0000000ec173c00] [c000000000132dbc] .handle_mm_fault+0x408/0x9e4
[c0000000ec173d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000ec173e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   3
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:465 active_file:5 inactive_anon:72
 inactive_file:0 unevictable:0 dirty:0 writeback:0 unstable:0
 free:82 slab:34096 mapped:14 pagetables:10820 bounce:0
Node 0 DMA free:2368kB min:3264kB low:4032kB high:4864kB active_anon:21184kB inactive_anon:4608kB active_file:0kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:2880kB min:4800kB low:5952kB high:7168kB active_anon:8576kB inactive_anon:0kB active_file:320kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:6 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 53*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3392kB
Node 1 DMA: 41*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 2880kB
632 total pagecache pages
573 pages in swap cache
Swap cache stats: add 22746, delete 22173, find 255/1265
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
26763 pages shared
58979 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9112 or a child
Killed process 2487 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000ec173360] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000ec173410] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000ec1734f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000ec173590] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000ec173660] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000ec1737a0] [c00000000014c2c0] .alloc_pages_current+0xcc/0xf4
[c0000000ec173840] [c000000000112c9c] .__page_cache_alloc+0x7c/0x98
[c0000000ec1738c0] [c00000000011d7e0] .__do_page_cache_readahead+0xb8/0x278
[c0000000ec1739b0] [c00000000011d9c8] .ra_submit+0x28/0x38
[c0000000ec173a20] [c000000000113414] .filemap_fault+0x1e0/0x420
[c0000000ec173af0] [c000000000130044] .__do_fault+0xa4/0x66c
[c0000000ec173c00] [c000000000132dbc] .handle_mm_fault+0x408/0x9e4
[c0000000ec173d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000ec173e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   3
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:1038 active_file:5 inactive_anon:677
 inactive_file:0 unevictable:0 dirty:0 writeback:6 unstable:0
 free:95 slab:34093 mapped:14 pagetables:10820 bounce:0
Node 0 DMA free:1536kB min:3264kB low:4032kB high:4864kB active_anon:48448kB inactive_anon:35072kB active_file:0kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:4544kB min:4800kB low:5952kB high:7168kB active_anon:17984kB inactive_anon:8256kB active_file:320kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 76*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4992kB
Node 1 DMA: 74*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4992kB
652 total pagecache pages
544 pages in swap cache
Swap cache stats: add 22798, delete 22254, find 255/1271
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
24737 pages shared
60959 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9109 or a child
Killed process 2488 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000ec173360] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000ec173410] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000ec1734f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000ec173590] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000ec173660] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000ec1737a0] [c00000000014c2c0] .alloc_pages_current+0xcc/0xf4
[c0000000ec173840] [c000000000112c9c] .__page_cache_alloc+0x7c/0x98
[c0000000ec1738c0] [c00000000011d7e0] .__do_page_cache_readahead+0xb8/0x278
[c0000000ec1739b0] [c00000000011d9c8] .ra_submit+0x28/0x38
[c0000000ec173a20] [c000000000113414] .filemap_fault+0x1e0/0x420
[c0000000ec173af0] [c000000000130044] .__do_fault+0xa4/0x66c
[c0000000ec173c00] [c000000000132dbc] .handle_mm_fault+0x408/0x9e4
[c0000000ec173d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000ec173e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   2
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   3
CPU    3: hi:    6, btch:   1 usd:   4
Active_anon:569 active_file:4 inactive_anon:265
 inactive_file:4 unevictable:0 dirty:0 writeback:0 unstable:0
 free:95 slab:34101 mapped:13 pagetables:10814 bounce:0
Node 0 DMA free:1920kB min:3264kB low:4032kB high:4864kB active_anon:29440kB inactive_anon:16960kB active_file:256kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:96 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:4160kB min:4800kB low:5952kB high:7168kB active_anon:6976kB inactive_anon:0kB active_file:0kB inactive_file:256kB unevictable:0kB present:2486784kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 87*64kB 4*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 6080kB
Node 1 DMA: 66*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4480kB
607 total pagecache pages
526 pages in swap cache
Swap cache stats: add 23265, delete 22739, find 270/1349
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
26363 pages shared
59572 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9107 or a child
Killed process 2489 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000ec173360] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000ec173410] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000ec1734f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000ec173590] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000ec173660] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000ec1737a0] [c00000000014c2c0] .alloc_pages_current+0xcc/0xf4
[c0000000ec173840] [c000000000112c9c] .__page_cache_alloc+0x7c/0x98
[c0000000ec1738c0] [c00000000011d7e0] .__do_page_cache_readahead+0xb8/0x278
[c0000000ec1739b0] [c00000000011d9c8] .ra_submit+0x28/0x38
[c0000000ec173a20] [c000000000113414] .filemap_fault+0x1e0/0x420
[c0000000ec173af0] [c000000000130044] .__do_fault+0xa4/0x66c
[c0000000ec173c00] [c000000000132dbc] .handle_mm_fault+0x408/0x9e4
[c0000000ec173d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000ec173e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   0
CPU    3: hi:    6, btch:   1 usd:   2
Active_anon:310 active_file:32 inactive_anon:141
 inactive_file:0 unevictable:0 dirty:0 writeback:1 unstable:0
 free:48 slab:34123 mapped:16 pagetables:10811 bounce:0
Node 0 DMA free:3072kB min:3264kB low:4032kB high:4864kB active_anon:15232kB inactive_anon:7360kB active_file:1728kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:96 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:0kB min:4800kB low:5952kB high:7168kB active_anon:4608kB inactive_anon:1664kB active_file:320kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 62*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4352kB
Node 1 DMA: 8*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 512kB
673 total pagecache pages
635 pages in swap cache
Swap cache stats: add 23772, delete 23137, find 292/1542
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
29941 pages shared
58861 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9104 or a child
Killed process 2490 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000ec173360] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000ec173410] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000ec1734f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000ec173590] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000ec173660] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000ec1737a0] [c00000000014c2c0] .alloc_pages_current+0xcc/0xf4
[c0000000ec173840] [c000000000112c9c] .__page_cache_alloc+0x7c/0x98
[c0000000ec1738c0] [c00000000011d7e0] .__do_page_cache_readahead+0xb8/0x278
[c0000000ec1739b0] [c00000000011d9c8] .ra_submit+0x28/0x38
[c0000000ec173a20] [c000000000113414] .filemap_fault+0x1e0/0x420
[c0000000ec173af0] [c000000000130044] .__do_fault+0xa4/0x66c
[c0000000ec173c00] [c000000000132dbc] .handle_mm_fault+0x408/0x9e4
[c0000000ec173d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000ec173e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   1
CPU    1: hi:    6, btch:   1 usd:   0
CPU    2: hi:    6, btch:   1 usd:   0
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   0
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:810 active_file:25 inactive_anon:339
 inactive_file:0 unevictable:0 dirty:0 writeback:0 unstable:0
 free:44 slab:34116 mapped:16 pagetables:10808 bounce:0
Node 0 DMA free:1344kB min:3264kB low:4032kB high:4864kB active_anon:51840kB inactive_anon:20288kB active_file:1280kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:1472kB min:4800kB low:5952kB high:7168kB active_anon:0kB inactive_anon:1408kB active_file:320kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:307 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 20*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 1280kB
Node 1 DMA: 23*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 1472kB
724 total pagecache pages
691 pages in swap cache
Swap cache stats: add 23973, delete 23282, find 294/1558
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
28796 pages shared
60228 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9101 or a child
Killed process 2491 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000ec173360] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000ec173410] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000ec1734f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000ec173590] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000ec173660] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000ec1737a0] [c00000000014c2c0] .alloc_pages_current+0xcc/0xf4
[c0000000ec173840] [c000000000112c9c] .__page_cache_alloc+0x7c/0x98
[c0000000ec1738c0] [c00000000011d7e0] .__do_page_cache_readahead+0xb8/0x278
[c0000000ec1739b0] [c00000000011d9c8] .ra_submit+0x28/0x38
[c0000000ec173a20] [c000000000113414] .filemap_fault+0x1e0/0x420
[c0000000ec173af0] [c000000000130044] .__do_fault+0xa4/0x66c
[c0000000ec173c00] [c000000000132dbc] .handle_mm_fault+0x408/0x9e4
[c0000000ec173d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000ec173e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   3
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:830 active_file:0 inactive_anon:272
 inactive_file:5 unevictable:0 dirty:0 writeback:1 unstable:0
 free:58 slab:34118 mapped:15 pagetables:10805 bounce:0
Node 0 DMA free:1664kB min:3264kB low:4032kB high:4864kB active_anon:41152kB inactive_anon:15104kB active_file:0kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:2048kB min:4800kB low:5952kB high:7168kB active_anon:11968kB inactive_anon:2304kB active_file:0kB inactive_file:320kB unevictable:0kB present:2486784kB pages_scanned:64 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 59*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3904kB
Node 1 DMA: 61*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4160kB
661 total pagecache pages
591 pages in swap cache
Swap cache stats: add 24145, delete 23554, find 299/1576
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
28960 pages shared
59962 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9099 or a child
Killed process 2492 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000ec173360] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000ec173410] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000ec1734f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000ec173590] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000ec173660] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000ec1737a0] [c00000000014c2c0] .alloc_pages_current+0xcc/0xf4
[c0000000ec173840] [c000000000112c9c] .__page_cache_alloc+0x7c/0x98
[c0000000ec1738c0] [c00000000011d7e0] .__do_page_cache_readahead+0xb8/0x278
[c0000000ec1739b0] [c00000000011d9c8] .ra_submit+0x28/0x38
[c0000000ec173a20] [c000000000113414] .filemap_fault+0x1e0/0x420
[c0000000ec173af0] [c000000000130044] .__do_fault+0xa4/0x66c
[c0000000ec173c00] [c000000000132dbc] .handle_mm_fault+0x408/0x9e4
[c0000000ec173d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000ec173e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:22 active_file:10 inactive_anon:41
 inactive_file:3 unevictable:0 dirty:0 writeback:15 unstable:0
 free:92 slab:34122 mapped:13 pagetables:10802 bounce:0
Node 0 DMA free:1728kB min:3264kB low:4032kB high:4864kB active_anon:1408kB inactive_anon:3328kB active_file:640kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:4160kB min:4800kB low:5952kB high:7168kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:192kB unevictable:0kB present:2486784kB pages_scanned:799 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 59*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3904kB
Node 1 DMA: 61*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4160kB
576 total pagecache pages
575 pages in swap cache
Swap cache stats: add 24653, delete 24078, find 309/1635
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
31041 pages shared
58275 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9096 or a child
Killed process 2493 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x201da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000ec173360] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000ec173410] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000ec1734f0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000ec173590] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000ec173660] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000ec1737a0] [c00000000014c2c0] .alloc_pages_current+0xcc/0xf4
[c0000000ec173840] [c000000000112c9c] .__page_cache_alloc+0x7c/0x98
[c0000000ec1738c0] [c00000000011d7e0] .__do_page_cache_readahead+0xb8/0x278
[c0000000ec1739b0] [c00000000011d9c8] .ra_submit+0x28/0x38
[c0000000ec173a20] [c000000000113414] .filemap_fault+0x1e0/0x420
[c0000000ec173af0] [c000000000130044] .__do_fault+0xa4/0x66c
[c0000000ec173c00] [c000000000132dbc] .handle_mm_fault+0x408/0x9e4
[c0000000ec173d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000ec173e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   3
CPU    3: hi:    6, btch:   1 usd:   4
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   3
Active_anon:90 active_file:5 inactive_anon:96
 inactive_file:7 unevictable:0 dirty:0 writeback:5 unstable:0
 free:94 slab:34128 mapped:17 pagetables:10799 bounce:0
Node 0 DMA free:2944kB min:3264kB low:4032kB high:4864kB active_anon:1664kB inactive_anon:6144kB active_file:320kB inactive_file:256kB unevictable:0kB present:1702464kB pages_scanned:18 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3072kB min:4800kB low:5952kB high:7168kB active_anon:4096kB inactive_anon:0kB active_file:0kB inactive_file:192kB unevictable:0kB present:2486784kB pages_scanned:97 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 65*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4416kB
Node 1 DMA: 59*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 3776kB
580 total pagecache pages
572 pages in swap cache
Swap cache stats: add 25160, delete 24588, find 322/1704
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
31484 pages shared
58188 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9094 or a child
Killed process 2494 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000049633590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c000000049633640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c000000049633720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000496337c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000049633890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000496339d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c000000049633a70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c000000049633b40] [c000000000141148] .swapin_readahead+0x54/0xd4
[c000000049633c00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c000000049633d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c000000049633e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   0
CPU    1: hi:    6, btch:   1 usd:   0
CPU    2: hi:    6, btch:   1 usd:   0
CPU    3: hi:    6, btch:   1 usd:   0
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:64 active_file:4 inactive_anon:54
 inactive_file:0 unevictable:0 dirty:0 writeback:9 unstable:0
 free:113 slab:34143 mapped:10 pagetables:10796 bounce:0
Node 0 DMA free:4416kB min:3264kB low:4032kB high:4864kB active_anon:2880kB inactive_anon:3008kB active_file:64kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:2976 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:2816kB min:4800kB low:5952kB high:7168kB active_anon:1216kB inactive_anon:448kB active_file:192kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 0kB
Node 1 DMA: 71*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4800kB
652 total pagecache pages
634 pages in swap cache
Swap cache stats: add 25704, delete 25070, find 334/1762
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
30857 pages shared
58288 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9091 or a child
Killed process 2495 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000049633590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c000000049633640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c000000049633720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000496337c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000049633890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000496339d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c000000049633a70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c000000049633b40] [c000000000141148] .swapin_readahead+0x54/0xd4
[c000000049633c00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c000000049633d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c000000049633e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   0
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   0
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   4
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:186 active_file:4 inactive_anon:36
 inactive_file:0 unevictable:0 dirty:0 writeback:9 unstable:0
 free:82 slab:34143 mapped:10 pagetables:10796 bounce:0
Node 0 DMA free:2432kB min:3264kB low:4032kB high:4864kB active_anon:10688kB inactive_anon:1856kB active_file:64kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:102 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:2816kB min:4800kB low:5952kB high:7168kB active_anon:1216kB inactive_anon:448kB active_file:192kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:30 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 17*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 1472kB
Node 1 DMA: 71*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4800kB
652 total pagecache pages
608 pages in swap cache
Swap cache stats: add 25732, delete 25124, find 335/1772
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
30715 pages shared
58395 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9089 or a child
Killed process 2496 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000049633590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c000000049633640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c000000049633720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000496337c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000049633890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000496339d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c000000049633a70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c000000049633b40] [c000000000141148] .swapin_readahead+0x54/0xd4
[c000000049633c00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c000000049633d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c000000049633e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   3
CPU    3: hi:    6, btch:   1 usd:   5
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:594 active_file:29 inactive_anon:210
 inactive_file:0 unevictable:0 dirty:0 writeback:0 unstable:0
 free:89 slab:34136 mapped:11 pagetables:10790 bounce:0
Node 0 DMA free:1920kB min:3264kB low:4032kB high:4864kB active_anon:21504kB inactive_anon:7296kB active_file:1600kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:128 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3776kB min:4800kB low:5952kB high:7168kB active_anon:16512kB inactive_anon:6144kB active_file:256kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:69 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 35*64kB 5*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 2880kB
Node 1 DMA: 60*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4096kB
672 total pagecache pages
613 pages in swap cache
Swap cache stats: add 25841, delete 25228, find 340/1785
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
29981 pages shared
59157 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9086 or a child
Killed process 2497 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000049633590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c000000049633640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c000000049633720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000496337c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000049633890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000496339d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c000000049633a70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c000000049633b40] [c000000000141148] .swapin_readahead+0x54/0xd4
[c000000049633c00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c000000049633d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c000000049633e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:378 active_file:4 inactive_anon:103
 inactive_file:0 unevictable:0 dirty:0 writeback:3 unstable:0
 free:88 slab:34126 mapped:11 pagetables:10787 bounce:0
Node 0 DMA free:2624kB min:3264kB low:4032kB high:4864kB active_anon:18496kB inactive_anon:3264kB active_file:0kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:88 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3008kB min:4800kB low:5952kB high:7168kB active_anon:5696kB inactive_anon:3328kB active_file:256kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 80*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 5248kB
Node 1 DMA: 81*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 5440kB
674 total pagecache pages
590 pages in swap cache
Swap cache stats: add 26243, delete 25653, find 354/1842
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
30608 pages shared
58758 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9083 or a child
Killed process 2498 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000049633590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c000000049633640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c000000049633720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000496337c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000049633890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000496339d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c000000049633a70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c000000049633b40] [c000000000141148] .swapin_readahead+0x54/0xd4
[c000000049633c00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c000000049633d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c000000049633e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:276 active_file:1 inactive_anon:51
 inactive_file:6 unevictable:0 dirty:0 writeback:2 unstable:0
 free:98 slab:34125 mapped:14 pagetables:10784 bounce:0
Node 0 DMA free:1472kB min:3264kB low:4032kB high:4864kB active_anon:13696kB inactive_anon:2112kB active_file:64kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:6 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:4800kB min:4800kB low:5952kB high:7168kB active_anon:3968kB inactive_anon:1152kB active_file:0kB inactive_file:384kB unevictable:0kB present:2486784kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 44*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 2816kB
Node 1 DMA: 99*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 6720kB
706 total pagecache pages
654 pages in swap cache
Swap cache stats: add 26676, delete 26022, find 367/1896
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
31272 pages shared
58456 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9081 or a child
Killed process 2499 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c000000049633590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c000000049633640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c000000049633720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000496337c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c000000049633890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000496339d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c000000049633a70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c000000049633b40] [c000000000141148] .swapin_readahead+0x54/0xd4
[c000000049633c00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c000000049633d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c000000049633e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:101 active_file:8 inactive_anon:159
 inactive_file:0 unevictable:0 dirty:0 writeback:0 unstable:0
 free:104 slab:34129 mapped:10 pagetables:10781 bounce:0
Node 0 DMA free:2880kB min:3264kB low:4032kB high:4864kB active_anon:3072kB inactive_anon:9024kB active_file:320kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:6160 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3776kB min:4800kB low:5952kB high:7168kB active_anon:3392kB inactive_anon:1152kB active_file:192kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 123*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 8256kB
Node 1 DMA: 75*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 5056kB
659 total pagecache pages
587 pages in swap cache
Swap cache stats: add 27045, delete 26458, find 395/2302
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
33843 pages shared
58376 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9078 or a child
Killed process 2500 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000a3f52c40] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000a3f52cf0] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000a3f52dd0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000a3f52e70] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000a3f52f40] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000a3f53080] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c0000000a3f53120] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c0000000a3f531f0] [c000000000141148] .swapin_readahead+0x54/0xd4
[c0000000a3f532b0] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c0000000a3f533b0] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000a3f534e0] [c0000000000055fc] handle_page_fault+0x20/0x5c
--- Exception: 301 at .__copy_tofrom_user+0x28c/0x580
    LR = .copy_from_user+0x3c/0x74
[c0000000a3f537d0] [c0000000004d5da4] .sock_alloc_send_pskb+0x100/0x3d0 (unreliable)
[c0000000a3f53850] [c0000000004ddd68] .memcpy_fromiovec+0x60/0xc4
[c0000000a3f538f0] [c000000000570664] .unix_stream_sendmsg+0x26c/0x430
[c0000000a3f53a10] [c0000000004d1504] .sock_aio_write+0x16c/0x19c
[c0000000a3f53b40] [c00000000015d1a4] .do_sync_write+0xcc/0x130
[c0000000a3f53ce0] [c00000000015df10] .vfs_write+0xec/0x1dc
[c0000000a3f53d80] [c00000000015e108] .SyS_write+0x58/0xa0
[c0000000a3f53e30] [c000000000008534] syscall_exit+0x0/0x40
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:70 active_file:2 inactive_anon:102
 inactive_file:3 unevictable:0 dirty:0 writeback:0 unstable:0
 free:55 slab:34136 mapped:11 pagetables:10778 bounce:0
Node 0 DMA free:2816kB min:3264kB low:4032kB high:4864kB active_anon:2624kB inactive_anon:2752kB active_file:128kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:128 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:704kB min:4800kB low:5952kB high:7168kB active_anon:1856kB inactive_anon:3776kB active_file:0kB inactive_file:192kB unevictable:0kB present:2486784kB pages_scanned:21 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 99*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 6592kB
Node 1 DMA: 62*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4224kB
741 total pagecache pages
602 pages in swap cache
Swap cache stats: add 27797, delete 27195, find 401/2378
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
34555 pages shared
58115 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9076 or a child
Killed process 2501 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c00000006910b590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c00000006910b640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c00000006910b720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c00000006910b7c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c00000006910b890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c00000006910b9d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c00000006910ba70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c00000006910bb40] [c000000000141148] .swapin_readahead+0x54/0xd4
[c00000006910bc00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c00000006910bd00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c00000006910be30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   2
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:32 active_file:2 inactive_anon:50
 inactive_file:3 unevictable:0 dirty:0 writeback:0 unstable:0
 free:55 slab:34136 mapped:11 pagetables:10778 bounce:0
Node 0 DMA free:2816kB min:3264kB low:4032kB high:4864kB active_anon:192kB inactive_anon:0kB active_file:128kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:78 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:704kB min:4800kB low:5952kB high:7168kB active_anon:1856kB inactive_anon:3776kB active_file:0kB inactive_file:192kB unevictable:0kB present:2486784kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 63*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4288kB
Node 1 DMA: 77*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 5312kB
787 total pagecache pages
631 pages in swap cache
Swap cache stats: add 27914, delete 27283, find 403/2389
Free swap  = 512kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
34804 pages shared
58016 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9073 or a child
Killed process 2502 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000aef22c40] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000aef22cf0] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000aef22dd0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000aef22e70] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000aef22f40] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000aef23080] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c0000000aef23120] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c0000000aef231f0] [c000000000141148] .swapin_readahead+0x54/0xd4
[c0000000aef232b0] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c0000000aef233b0] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000aef234e0] [c0000000000055fc] handle_page_fault+0x20/0x5c
--- Exception: 301 at .__copy_tofrom_user+0x28c/0x580
    LR = .copy_from_user+0x3c/0x74
[c0000000aef237d0] [c0000000004d5da4] .sock_alloc_send_pskb+0x100/0x3d0 (unreliable)
[c0000000aef23850] [c0000000004ddd68] .memcpy_fromiovec+0x60/0xc4
[c0000000aef238f0] [c000000000570664] .unix_stream_sendmsg+0x26c/0x430
[c0000000aef23a10] [c0000000004d1504] .sock_aio_write+0x16c/0x19c
[c0000000aef23b40] [c00000000015d1a4] .do_sync_write+0xcc/0x130
[c0000000aef23ce0] [c00000000015df10] .vfs_write+0xec/0x1dc
[c0000000aef23d80] [c00000000015e108] .SyS_write+0x58/0xa0
[c0000000aef23e30] [c000000000008534] syscall_exit+0x0/0x40
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:32 active_file:2 inactive_anon:112
 inactive_file:3 unevictable:0 dirty:0 writeback:0 unstable:0
 free:55 slab:34136 mapped:11 pagetables:10778 bounce:0
Node 0 DMA free:2816kB min:3264kB low:4032kB high:4864kB active_anon:192kB inactive_anon:3392kB active_file:128kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:704kB min:4800kB low:5952kB high:7168kB active_anon:1856kB inactive_anon:3776kB active_file:0kB inactive_file:192kB unevictable:0kB present:2486784kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 62*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4224kB
Node 1 DMA: 77*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 5312kB
787 total pagecache pages
642 pages in swap cache
Swap cache stats: add 27939, delete 27297, find 404/2393
Free swap  = 192kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
34858 pages shared
57974 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9071 or a child
Killed process 2503 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c00000006284f590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c00000006284f640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c00000006284f720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c00000006284f7c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c00000006284f890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c00000006284f9d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c00000006284fa70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c00000006284fb40] [c000000000141148] .swapin_readahead+0x54/0xd4
[c00000006284fc00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c00000006284fd00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c00000006284fe30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   4
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:78 active_file:2 inactive_anon:122
 inactive_file:3 unevictable:0 dirty:0 writeback:0 unstable:0
 free:55 slab:34136 mapped:11 pagetables:10778 bounce:0
Node 0 DMA free:2816kB min:3264kB low:4032kB high:4864kB active_anon:3136kB inactive_anon:4032kB active_file:128kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:2819 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:704kB min:4800kB low:5952kB high:7168kB active_anon:1856kB inactive_anon:3776kB active_file:0kB inactive_file:192kB unevictable:0kB present:2486784kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 14*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 896kB
Node 1 DMA: 77*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 5312kB
787 total pagecache pages
707 pages in swap cache
Swap cache stats: add 28025, delete 27318, find 405/2397
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
34908 pages shared
58030 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9068 or a child
Killed process 2504 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c00000003c06f590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c00000003c06f640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c00000003c06f720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c00000003c06f7c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c00000003c06f890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c00000003c06f9d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c00000003c06fa70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c00000003c06fb40] [c000000000141148] .swapin_readahead+0x54/0xd4
[c00000003c06fc00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c00000003c06fd00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c00000003c06fe30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:55 active_file:2 inactive_anon:125
 inactive_file:3 unevictable:0 dirty:0 writeback:0 unstable:0
 free:55 slab:34136 mapped:11 pagetables:10778 bounce:0
Node 0 DMA free:2816kB min:3264kB low:4032kB high:4864kB active_anon:1664kB inactive_anon:4224kB active_file:128kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:24 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:704kB min:4800kB low:5952kB high:7168kB active_anon:1856kB inactive_anon:3776kB active_file:0kB inactive_file:192kB unevictable:0kB present:2486784kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 69*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4544kB
Node 1 DMA: 77*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 5312kB
787 total pagecache pages
651 pages in swap cache
Swap cache stats: add 28045, delete 27394, find 406/2403
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
34748 pages shared
58076 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9066 or a child
Killed process 2505 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c00000003c06f590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c00000003c06f640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c00000003c06f720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c00000003c06f7c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c00000003c06f890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c00000003c06f9d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c00000003c06fa70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c00000003c06fb40] [c000000000141148] .swapin_readahead+0x54/0xd4
[c00000003c06fc00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c00000003c06fd00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c00000003c06fe30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:55 active_file:2 inactive_anon:101
 inactive_file:3 unevictable:0 dirty:0 writeback:0 unstable:0
 free:92 slab:34136 mapped:11 pagetables:10778 bounce:0
Node 0 DMA free:2816kB min:3264kB low:4032kB high:4864kB active_anon:1664kB inactive_anon:2688kB active_file:128kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:16 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3072kB min:4800kB low:5952kB high:7168kB active_anon:1856kB inactive_anon:3776kB active_file:0kB inactive_file:192kB unevictable:0kB present:2486784kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 72*64kB 5*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 5248kB
Node 1 DMA: 104*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 7040kB
732 total pagecache pages
624 pages in swap cache
Swap cache stats: add 28062, delete 27438, find 406/2404
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
34644 pages shared
58129 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9063 or a child
Killed process 2506 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c00000003c06f590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c00000003c06f640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c00000003c06f720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c00000003c06f7c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c00000003c06f890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c00000003c06f9d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c00000003c06fa70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c00000003c06fb40] [c000000000141148] .swapin_readahead+0x54/0xd4
[c00000003c06fc00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c00000003c06fd00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c00000003c06fe30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   4
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:147 active_file:2 inactive_anon:101
 inactive_file:3 unevictable:0 dirty:0 writeback:0 unstable:0
 free:92 slab:34136 mapped:11 pagetables:10778 bounce:0
Node 0 DMA free:2816kB min:3264kB low:4032kB high:4864kB active_anon:7552kB inactive_anon:2688kB active_file:128kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:24 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3072kB min:4800kB low:5952kB high:7168kB active_anon:1856kB inactive_anon:3776kB active_file:0kB inactive_file:192kB unevictable:0kB present:2486784kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 59*64kB 5*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4416kB
Node 1 DMA: 104*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 7040kB
778 total pagecache pages
650 pages in swap cache
Swap cache stats: add 28103, delete 27453, find 406/2405
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
34497 pages shared
58284 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9060 or a child
Killed process 2507 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c00000003c06f590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c00000003c06f640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c00000003c06f720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c00000003c06f7c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c00000003c06f890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c00000003c06f9d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c00000003c06fa70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c00000003c06fb40] [c000000000141148] .swapin_readahead+0x54/0xd4
[c00000003c06fc00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c00000003c06fd00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c00000003c06fe30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   0
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:30 active_file:3 inactive_anon:7
 inactive_file:2 unevictable:0 dirty:0 writeback:0 unstable:0
 free:100 slab:34141 mapped:11 pagetables:10760 bounce:0
Node 0 DMA free:2560kB min:3264kB low:4032kB high:4864kB active_anon:0kB inactive_anon:1216kB active_file:0kB inactive_file:128kB unevictable:0kB present:1702464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3840kB min:4800kB low:5952kB high:7168kB active_anon:1920kB inactive_anon:0kB active_file:192kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:96 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 67*64kB 6*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 5056kB
Node 1 DMA: 72*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4992kB
779 total pagecache pages
684 pages in swap cache
Swap cache stats: add 28221, delete 27537, find 406/2413
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
34883 pages shared
58014 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9058 or a child
Killed process 2508 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000f7f13590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000f7f13640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000f7f13720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000f7f137c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000f7f13890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000f7f139d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c0000000f7f13a70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c0000000f7f13b40] [c000000000141148] .swapin_readahead+0x54/0xd4
[c0000000f7f13c00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c0000000f7f13d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000f7f13e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   0
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:76 active_file:3 inactive_anon:60
 inactive_file:2 unevictable:0 dirty:0 writeback:0 unstable:0
 free:100 slab:34141 mapped:11 pagetables:10760 bounce:0
Node 0 DMA free:2560kB min:3264kB low:4032kB high:4864kB active_anon:2944kB inactive_anon:4608kB active_file:0kB inactive_file:128kB unevictable:0kB present:1702464kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3840kB min:4800kB low:5952kB high:7168kB active_anon:1920kB inactive_anon:0kB active_file:192kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:96 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 75*64kB 5*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 5440kB
Node 1 DMA: 72*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4992kB
779 total pagecache pages
684 pages in swap cache
Swap cache stats: add 28239, delete 27555, find 407/2417
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
34804 pages shared
58083 pages non-shared
Out of memory: kill process 2440 (hackbench) score 9055 or a child
Killed process 2509 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9053 or a child
Killed process 2510 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9053 or a child
Killed process 2511 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9048 or a child
Killed process 2512 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9045 or a child
Killed process 2513 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9042 or a child
Killed process 2514 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9040 or a child
Killed process 2515 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9037 or a child
Killed process 2516 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9035 or a child
Killed process 2517 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9032 or a child
Killed process 2518 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9030 or a child
Killed process 2519 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9027 or a child
Killed process 2520 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9025 or a child
Killed process 2521 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9022 or a child
Killed process 2522 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9019 or a child
Killed process 2523 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9017 or a child
Killed process 2524 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9014 or a child
Killed process 2525 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9012 or a child
Killed process 2526 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9009 or a child
Killed process 2527 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9007 or a child
Killed process 2528 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9004 or a child
Killed process 2529 (hackbench)
Out of memory: kill process 2440 (hackbench) score 9001 or a child
Killed process 2530 (hackbench)
Out of memory: kill process 2440 (hackbench) score 8999 or a child
Killed process 2531 (hackbench)
Out of memory: kill process 2440 (hackbench) score 8996 or a child
Killed process 2532 (hackbench)
__ratelimit: 23 callbacks suppressed
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c00000005f49ec40] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c00000005f49ecf0] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c00000005f49edd0] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c00000005f49ee70] [c000000000116848] .out_of_memory+0x1dc/0x240
[c00000005f49ef40] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c00000005f49f080] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c00000005f49f120] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c00000005f49f1f0] [c000000000141148] .swapin_readahead+0x54/0xd4
[c00000005f49f2b0] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c00000005f49f3b0] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c00000005f49f4e0] [c0000000000055fc] handle_page_fault+0x20/0x5c
--- Exception: 301 at .__copy_tofrom_user+0x28c/0x580
    LR = .copy_from_user+0x3c/0x74
[c00000005f49f7d0] [c0000000004d5da4] .sock_alloc_send_pskb+0x100/0x3d0 (unreliable)
[c00000005f49f850] [c0000000004ddd68] .memcpy_fromiovec+0x60/0xc4
[c00000005f49f8f0] [c000000000570664] .unix_stream_sendmsg+0x26c/0x430
[c00000005f49fa10] [c0000000004d1504] .sock_aio_write+0x16c/0x19c
[c00000005f49fb40] [c00000000015d1a4] .do_sync_write+0xcc/0x130
[c00000005f49fce0] [c00000000015df10] .vfs_write+0xec/0x1dc
[c00000005f49fd80] [c00000000015e108] .SyS_write+0x58/0xa0
[c00000005f49fe30] [c000000000008534] syscall_exit+0x0/0x40
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   4
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   2
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:17 active_file:5 inactive_anon:115
 inactive_file:0 unevictable:0 dirty:0 writeback:3 unstable:0
 free:95 slab:34147 mapped:11 pagetables:10682 bounce:0
Node 0 DMA free:2752kB min:3264kB low:4032kB high:4864kB active_anon:832kB inactive_anon:2368kB active_file:128kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:6600 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3328kB min:4800kB low:5952kB high:7168kB active_anon:256kB inactive_anon:4992kB active_file:192kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:31 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 66*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4352kB
Node 1 DMA: 78*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 5248kB
962 total pagecache pages
896 pages in swap cache
Swap cache stats: add 30038, delete 29142, find 445/2617
Free swap  = 64kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
35625 pages shared
57972 pages non-shared
Out of memory: kill process 2440 (hackbench) score 8994 or a child
Killed process 2533 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c00000004b46f590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c00000004b46f640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c00000004b46f720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c00000004b46f7c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c00000004b46f890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c00000004b46f9d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c00000004b46fa70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c00000004b46fb40] [c000000000141148] .swapin_readahead+0x54/0xd4
[c00000004b46fc00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c00000004b46fd00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c00000004b46fe30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:24 active_file:7 inactive_anon:42
 inactive_file:0 unevictable:0 dirty:0 writeback:1 unstable:0
 free:78 slab:34133 mapped:13 pagetables:10679 bounce:0
Node 0 DMA free:1600kB min:3264kB low:4032kB high:4864kB active_anon:1472kB inactive_anon:1088kB active_file:256kB inactive_file:0kB unevictable:0kB present:1702464kB pages_scanned:1053 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3392kB min:4800kB low:5952kB high:7168kB active_anon:64kB inactive_anon:1600kB active_file:192kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 41*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 2752kB
Node 1 DMA: 88*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 6016kB
943 total pagecache pages
932 pages in swap cache
Swap cache stats: add 30757, delete 29825, find 452/2696
Free swap  = 384kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
36217 pages shared
57771 pages non-shared
Out of memory: kill process 2440 (hackbench) score 8991 or a child
Killed process 2534 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c00000004b46f590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c00000004b46f640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c00000004b46f720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c00000004b46f7c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c00000004b46f890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c00000004b46f9d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c00000004b46fa70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c00000004b46fb40] [c000000000141148] .swapin_readahead+0x54/0xd4
[c00000004b46fc00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c00000004b46fd00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c00000004b46fe30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   4
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:173 active_file:3 inactive_anon:39
 inactive_file:4 unevictable:0 dirty:0 writeback:0 unstable:0
 free:99 slab:34132 mapped:12 pagetables:10676 bounce:0
Node 0 DMA free:3136kB min:3264kB low:4032kB high:4864kB active_anon:9152kB inactive_anon:1536kB active_file:0kB inactive_file:256kB unevictable:0kB present:1702464kB pages_scanned:60 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3200kB min:4800kB low:5952kB high:7168kB active_anon:1920kB inactive_anon:960kB active_file:192kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:137 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 80*64kB 5*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 6016kB
Node 1 DMA: 57*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4032kB
981 total pagecache pages
949 pages in swap cache
Swap cache stats: add 32738, delete 31789, find 487/2908
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
36971 pages shared
57980 pages non-shared
Out of memory: kill process 2440 (hackbench) score 8989 or a child
Killed process 2535 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000ec523590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000ec523640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000ec523720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000ec5237c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000ec523890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000ec5239d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c0000000ec523a70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c0000000ec523b40] [c000000000141148] .swapin_readahead+0x54/0xd4
[C0000000ec523c00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c0000000ec523d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000ec523e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   4
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:116 active_file:3 inactive_anon:75
 inactive_file:17 unevictable:0 dirty:0 writeback:0 unstable:0
 free:80 slab:34139 mapped:23 pagetables:10673 bounce:0
Node 0 DMA free:1856kB min:3264kB low:4032kB high:4864kB active_anon:4160kB inactive_anon:1792kB active_file:0kB inactive_file:1088kB unevictable:0kB present:1702464kB pages_scanned:2698 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:3264kB min:4800kB low:5952kB high:7168kB active_anon:3264kB inactive_anon:3008kB active_file:192kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:98 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 66*64kB 2*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4736kB
Node 1 DMA: 58*64kB 3*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4096kB
986 total pagecache pages
970 pages in swap cache
Swap cache stats: add 33959, delete 32989, find 507/3040
Free swap  = 64kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
37699 pages shared
57901 pages non-shared
Out of memory: kill process 2440 (hackbench) score 8986 or a child
Killed process 2536 (hackbench)
hackbench invoked oom-killer: gfp_mask=0x200da, order=0, oom_adj=0
hackbench cpuset=/ mems_allowed=0-15
Call Trace:
[c0000000ec523590] [c000000000010f64] .show_stack+0x6c/0x16c (unreliable)
[c0000000ec523640] [c000000000115e98] .oom_kill_process+0xf4/0x358
[c0000000ec523720] [c000000000116644] .__out_of_memory+0xb8/0xe0
[c0000000ec5237c0] [c000000000116848] .out_of_memory+0x1dc/0x240
[c0000000ec523890] [c00000000011b680] .__alloc_pages_nodemask+0x524/0x650
[c0000000ec5239d0] [c00000000014c4bc] .alloc_page_vma+0x1d4/0x1e0
[c0000000ec523a70] [c000000000140fe4] .read_swap_cache_async+0x8c/0x19c
[c0000000ec523b40] [c000000000141148] .swapin_readahead+0x54/0xd4
[c0000000ec523c00] [c000000000132e5c] .handle_mm_fault+0x4a8/0x9e4
[c0000000ec523d00] [c000000000583a04] .do_page_fault+0x3fc/0x650
[c0000000ec523e30] [c0000000000055fc] handle_page_fault+0x20/0x5c
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   4
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   2
Node 1 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   5
CPU    2: hi:    6, btch:   1 usd:   5
CPU    3: hi:    6, btch:   1 usd:   5
Active_anon:118 active_file:0 inactive_anon:57
 inactive_file:7 unevictable:0 dirty:0 writeback:0 unstable:0
 free:108 slab:34140 mapped:13 pagetables:10670 bounce:0
Node 0 DMA free:2560kB min:3264kB low:4032kB high:4864kB active_anon:5440kB inactive_anon:2368kB active_file:0kB inactive_file:448kB unevictable:0kB present:1702464kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 1 DMA free:4352kB min:4800kB low:5952kB high:7168kB active_anon:2112kB inactive_anon:1280kB active_file:0kB inactive_file:0kB unevictable:0kB present:2486784kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 67*64kB 3*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 4928kB
Node 1 DMA: 76*64kB 5*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB 0*16384kB = 5504kB
1014 total pagecache pages
976 pages in swap cache
Swap cache stats: add 34731, delete 33755, find 517/3127
Free swap  = 0kB
Total swap = 1044096kB
92160 pages RAM
7291 pages reserved
38093 pages shared
57927 pages non-shared
Out of memory: kill process 2440 (hackbench) score 8984 or a child
Killed process 2537 (hackbench)

--------------000502040002000200080803
Content-Type: text/plain;
 name="config_next_0708"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="config_next_0708"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.31-rc2-autotest
# Wed Jul  8 16:54:16 2009
#
CONFIG_PPC64=y

#
# Processor support
#
CONFIG_PPC_BOOK3S_64=y
CONFIG_PPC_BOOK3S=y
CONFIG_POWER4_ONLY=y
CONFIG_POWER4=y
CONFIG_TUNE_CELL=y
CONFIG_PPC_FPU=y
CONFIG_ALTIVEC=y
CONFIG_VSX=y
CONFIG_PPC_STD_MMU=y
CONFIG_PPC_STD_MMU_64=y
CONFIG_PPC_MM_SLICES=y
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_PPC_HAVE_PMU_SUPPORT=y
CONFIG_PPC_PERF_CTRS=y
CONFIG_SMP=y
CONFIG_NR_CPUS=1024
CONFIG_64BIT=y
CONFIG_WORD_SIZE=64
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_MMU=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_HAVE_LEGACY_PER_CPU_AREA=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_IRQ_PER_CPU=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_ILOG2_U32=y
CONFIG_ARCH_HAS_ILOG2_U64=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_NO_VIRT_TO_BUS=y
CONFIG_PPC=y
CONFIG_EARLY_PRINTK=y
CONFIG_COMPAT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_PPC_OF=y
CONFIG_OF=y
CONFIG_PPC_UDBG_16550=y
CONFIG_GENERIC_TBSYNC=y
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_BUG=y
CONFIG_DTC=y
# CONFIG_DEFAULT_UIMAGE is not set
CONFIG_HIBERNATE_64=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_PPC_DCR_NATIVE is not set
CONFIG_PPC_DCR_MMIO=y
CONFIG_PPC_DCR=y
CONFIG_PPC_OF_PLATFORM_PCI=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION="-5-ppc64"
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=19
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
CONFIG_PERF_COUNTERS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB_ALLOCATOR is not set
# CONFIG_SLUB_ALLOCATOR is not set
CONFIG_SLQB_ALLOCATOR=y
CONFIG_SLQB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=m
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_SYSCALL_WRAPPERS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_SLOW_WORK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
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
CONFIG_FREEZER=y
CONFIG_PPC_MSI_BITMAP=y

#
# Platform support
#
CONFIG_PPC_PSERIES=y
CONFIG_PPC_SPLPAR=y
CONFIG_EEH=y
CONFIG_PSERIES_MSI=y
CONFIG_SCANLOG=m
CONFIG_LPARCFG=y
CONFIG_PPC_SMLPAR=y
CONFIG_CMM=y
# CONFIG_DTL is not set
# CONFIG_PPC_ISERIES is not set
CONFIG_PPC_PMAC=y
CONFIG_PPC_PMAC64=y
CONFIG_PPC_MAPLE=y
# CONFIG_PPC_PASEMI is not set
CONFIG_PPC_PS3=y

#
# PS3 Platform Options
#
CONFIG_PS3_ADVANCED=y
CONFIG_PS3_HTAB_SIZE=20
# CONFIG_PS3_DYNAMIC_DMA is not set
CONFIG_PS3_VUART=y
CONFIG_PS3_PS3AV=y
CONFIG_PS3_SYS_MANAGER=y
CONFIG_PS3_STORAGE=m
CONFIG_PS3_DISK=m
CONFIG_PS3_ROM=m
CONFIG_PS3_FLASH=m
# CONFIG_PS3_VRAM is not set
CONFIG_PS3_LPM=m
CONFIG_PPC_CELL=y
CONFIG_PPC_CELL_COMMON=y
CONFIG_PPC_CELL_NATIVE=y
CONFIG_PPC_IBM_CELL_BLADE=y
# CONFIG_PPC_CELLEB is not set
# CONFIG_PPC_CELL_QPACE is not set
CONFIG_AXON_MSI=y

#
# Cell Broadband Engine options
#
CONFIG_SPU_FS=m
CONFIG_SPU_TRACE=m
CONFIG_SPU_BASE=y
CONFIG_CBE_RAS=y
CONFIG_PPC_IBM_CELL_RESETBUTTON=y
CONFIG_PPC_IBM_CELL_POWERBUTTON=m
CONFIG_CBE_THERM=m
CONFIG_CBE_CPUFREQ=m
# CONFIG_CBE_CPUFREQ_PMI_ENABLE is not set
CONFIG_PPC_PMI=m
CONFIG_CBE_CPUFREQ_SPU_GOVERNOR=m
CONFIG_OPROFILE_CELL=y
# CONFIG_PQ2ADS is not set
CONFIG_PPC_NATIVE=y
CONFIG_PPC_OF_BOOT_TRAMPOLINE=y
CONFIG_UDBG_RTAS_CONSOLE=y
CONFIG_XICS=y
# CONFIG_IPIC is not set
CONFIG_MPIC=y
# CONFIG_MPIC_WEIRD is not set
CONFIG_PPC_I8259=y
CONFIG_U3_DART=y
CONFIG_PPC_RTAS=y
CONFIG_RTAS_ERROR_LOGGING=y
CONFIG_RTAS_PROC=y
CONFIG_RTAS_FLASH=y
CONFIG_MMIO_NVRAM=y
CONFIG_MPIC_U3_HT_IRQS=y
CONFIG_IBMVIO=y
CONFIG_IBMEBUS=y
# CONFIG_PPC_MPC106 is not set
CONFIG_PPC_970_NAP=y
CONFIG_PPC_INDIRECT_IO=y
CONFIG_GENERIC_IOMAP=y
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPU Frequency drivers
#
CONFIG_CPU_FREQ_PMAC64=y
CONFIG_AXON_RAM=m
# CONFIG_FSL_ULI1575 is not set
# CONFIG_SIMPLE_GPIO is not set

#
# Kernel options
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_HUGETLB_PAGE_SIZE_VARIABLE=y
CONFIG_IOMMU_VMERGE=y
CONFIG_IOMMU_HELPER=y
# CONFIG_SWIOTLB is not set
CONFIG_HOTPLUG_CPU=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_HAS_WALK_MEMORY=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYP_DUMP=y
CONFIG_IRQ_ALL_CPUS=y
CONFIG_NUMA=y
CONFIG_NODES_SHIFT=4
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_PPC_HAS_HASH_64K=y
# CONFIG_PPC_4K_PAGES is not set
# CONFIG_PPC_16K_PAGES is not set
CONFIG_PPC_64K_PAGES=y
# CONFIG_PPC_256K_PAGES is not set
CONFIG_FORCE_MAX_ZONEORDER=9
CONFIG_PPC_SUBPAGE_PROT=y
CONFIG_SCHED_SMT=y
CONFIG_PROC_DEVICETREE=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_EXTRA_TARGETS=""
CONFIG_ARCH_WANTS_FREEZER_CONTROL=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_SECCOMP=y
CONFIG_ISA_DMA_API=y

#
# Bus options
#
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
# CONFIG_PPC_INDIRECT_PCI is not set
CONFIG_PPC_PCI_CHOICE=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_SYSCALL=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
CONFIG_HOTPLUG_PCI_RPA=y
CONFIG_HOTPLUG_PCI_RPA_DLPAR=y
# CONFIG_HAS_RAPIDIO is not set
# CONFIG_RELOCATABLE is not set
CONFIG_PAGE_OFFSET=0xc000000000000000
CONFIG_KERNEL_START=0xc000000000000000
CONFIG_PHYSICAL_START=0x00000000
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=y
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
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
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
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
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
CONFIG_NF_CONNTRACK_SECMARK=y
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
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
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
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
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
CONFIG_IP_NF_SECURITY=m
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
CONFIG_IP6_NF_SECURITY=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_NET_DCCPPROBE is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_HMAC_NONE=y
# CONFIG_SCTP_HMAC_SHA1 is not set
# CONFIG_SCTP_HMAC_MD5 is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
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
# CONFIG_NET_CLS_CGROUP is not set
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
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEFAULT_PS_VALUE=1
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_WIRELESS_OLD_REGULATORY is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=m
# CONFIG_MTD_DEBUG is not set
# CONFIG_MTD_CONCAT is not set
# CONFIG_MTD_PARTITIONS is not set
# CONFIG_MTD_TESTS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_M25P80 is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set

#
# UBI - Unsorted block images
#
# CONFIG_MTD_UBI is not set
CONFIG_OF_DEVICE=y
CONFIG_OF_GPIO=y
CONFIG_OF_I2C=y
CONFIG_OF_SPI=y
CONFIG_OF_MDIO=m
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=123456
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=m
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
CONFIG_HWLAT_DETECTOR=m
CONFIG_PHANTOM=m
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_HP_ILO=m
# CONFIG_ISL29003 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_CB710_CORE is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SL82C105 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDE_PMAC=y
CONFIG_BLK_DEV_IDE_PMAC_ATA100FIRST=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
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
CONFIG_SCSI_CXGB3_ISCSI=m
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=m
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=m
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_ARCMSR=m
CONFIG_SCSI_ARCMSR_AER=y
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=m
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_IBMVSCSI=m
CONFIG_SCSI_IBMVSCSIS=m
CONFIG_SCSI_IBMVFC=m
CONFIG_SCSI_IBMVFC_TRACE=y
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=0
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=m
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_LPFC=m
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_SRP=m
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=m
CONFIG_ATA_NONSTANDARD=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=m
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=m
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
CONFIG_PATA_CMD640_PCI=m
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_MARVELL=m
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_SIL680=m
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
CONFIG_PATA_WINBOND=m
# CONFIG_PATA_PLATFORM is not set
CONFIG_PATA_SCH=m
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
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
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# See the help texts for more information.
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=m
CONFIG_IEEE1394_OHCI1394=m
# CONFIG_IEEE1394_PCILYNX is not set
CONFIG_IEEE1394_SBP2=m
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=m
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_DV1394=m
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_ADB_PMU=y
CONFIG_ADB_PMU_LED=y
CONFIG_ADB_PMU_LED_IDE=y
CONFIG_PMAC_SMU=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_THERM_PM72=y
CONFIG_WINDFARM=y
CONFIG_WINDFARM_PM81=y
CONFIG_WINDFARM_PM91=y
CONFIG_WINDFARM_PM112=y
CONFIG_WINDFARM_PM121=y
# CONFIG_PMAC_RACKMETER is not set
CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
CONFIG_MACVLAN=m
CONFIG_EQUALIZER=m
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_GPIO is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
# CONFIG_HAPPYMEAL is not set
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
CONFIG_ENC28J60=m
# CONFIG_ENC28J60_WRITEVERIFY is not set
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
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
CONFIG_IBMVETH=m
# CONFIG_IBM_NEW_EMAC is not set
CONFIG_IBM_NEW_EMAC_ZMII=y
CONFIG_IBM_NEW_EMAC_RGMII=y
CONFIG_IBM_NEW_EMAC_TAH=y
CONFIG_IBM_NEW_EMAC_EMAC4=y
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=m
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
CONFIG_E100=m
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R6040=m
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
CONFIG_TLAN=m
# CONFIG_KS8842 is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_NET_POCKET is not set
CONFIG_ATL2=m
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
CONFIG_ACENIC_OMIT_TIGON_I=y
# CONFIG_DL2K is not set
CONFIG_E1000=m
CONFIG_E1000E=m
CONFIG_IP1000=m
CONFIG_IGB=m
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
CONFIG_SIS190=m
# CONFIG_SKGE is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=m
CONFIG_BNX2=m
# CONFIG_CNIC is not set
CONFIG_SPIDER_NET=m
CONFIG_GELIC_NET=m
CONFIG_GELIC_WIRELESS=y
# CONFIG_GELIC_WIRELESS_OLD_PSK_INTERFACE is not set
CONFIG_QLA3XXX=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
CONFIG_MDIO=m
CONFIG_CHELSIO_T1=m
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3_DEPENDS=y
CONFIG_CHELSIO_T3=m
CONFIG_EHEA=m
# CONFIG_ENIC is not set
CONFIG_IXGBE=m
CONFIG_IXGB=m
CONFIG_S2IO=m
# CONFIG_VXGE is not set
CONFIG_MYRI10GE=m
CONFIG_NETXEN_NIC=m
CONFIG_NIU=m
# CONFIG_MLX4_EN is not set
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_TEHUTI=m
CONFIG_BNX2X=m
# CONFIG_QLGE is not set
CONFIG_SFC=m
CONFIG_SFC_MTD=y
# CONFIG_BE2NET is not set
CONFIG_TR=y
CONFIG_IBMOL=m
# CONFIG_3C359 is not set
# CONFIG_TMS380TR is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
# CONFIG_STRIP is not set
CONFIG_WLAN_80211=y
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
# CONFIG_LIBERTAS_SPI is not set
# CONFIG_LIBERTAS_DEBUG is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_RTL8180=m
CONFIG_RTL8187=m
CONFIG_RTL8187_LEDS=y
CONFIG_ADM8211=m
CONFIG_MAC80211_HWSIM=m
# CONFIG_MWL8K is not set
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
CONFIG_P54_PCI=m
# CONFIG_P54_SPI is not set
CONFIG_P54_LEDS=y
CONFIG_ATH_COMMON=m
CONFIG_ATH5K=m
# CONFIG_ATH5K_DEBUG is not set
CONFIG_ATH9K=m
# CONFIG_ATH9K_DEBUG is not set
# CONFIG_AR9170_USB is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLWIFI=m
CONFIG_IWLWIFI_LEDS=y
# CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT is not set
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLAGN=m
CONFIG_IWL4965=y
CONFIG_IWL5000=y
CONFIG_IWL3945=m
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
# CONFIG_HOSTAP is not set
CONFIG_B43=m
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
# CONFIG_B43_DEBUG is not set
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
# CONFIG_B43LEGACY_DEBUG is not set
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
# CONFIG_ZD1211RW is not set
CONFIG_RT2X00=m
CONFIG_RT2400PCI=m
CONFIG_RT2500PCI=m
CONFIG_RT61PCI=m
CONFIG_RT2500USB=m
CONFIG_RT73USB=m
# CONFIG_RT2800USB is not set
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_LIB_DEBUGFS is not set
# CONFIG_RT2X00_DEBUG is not set
# CONFIG_HERMES is not set
# CONFIG_WL12XX is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_HSO=m
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOL2TP=m
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=m
CONFIG_ISDN=y
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
# CONFIG_MISDN_HFCUSB is not set
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=m
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
CONFIG_ISDN_CAPI_CAPI20=m

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=m
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
CONFIG_CAPI_EICON=y
CONFIG_ISDN_DIVAS=m
CONFIG_ISDN_DIVAS_BRIPCI=y
CONFIG_ISDN_DIVAS_PRIPCI=y
CONFIG_ISDN_DIVAS_DIVACAPI=m
CONFIG_ISDN_DIVAS_USERIDI=m
CONFIG_ISDN_DIVAS_MAINT=m
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=m
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=m
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
# CONFIG_JOYSTICK_TURBOGRAFX is not set
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_JOYSTICK_WALKERA0701 is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=m
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=m
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_W90X900 is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_XILINX_XPS_PS2=m
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
CONFIG_SERIAL_PMACZILOG=y
# CONFIG_SERIAL_PMACZILOG_TTYS is not set
CONFIG_SERIAL_PMACZILOG_CONSOLE=y
CONFIG_SERIAL_ICOM=m
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_OF_PLATFORM is not set
# CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=0
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_CONSOLE=y
CONFIG_HVC_RTAS=y
# CONFIG_HVC_UDBG is not set
CONFIG_VIRTIO_CONSOLE=m
CONFIG_HVCS=m
CONFIG_IBM_BSR=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_GEN_RTC=y
# CONFIG_GEN_RTC_X is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=4096
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# Mac SMBus host controller drivers
#
CONFIG_I2C_POWERMAC=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_SIMTEC=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_STUB=m

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=m
CONFIG_SPI_BUTTERFLY=m
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_LM70_LLP=m

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=m

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO expanders:
#
# CONFIG_GPIO_XILINX is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=m
CONFIG_GPIO_MCP23S08=m
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=m
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=m
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
CONFIG_BATTERY_DS2760=m
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7473=m
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_LIS3_SPI is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_ALIM7101_WDT=m
CONFIG_WATCHDOG_RTAS=m

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
# CONFIG_MFD_SM501 is not set
CONFIG_HTC_PASIC3=m
# CONFIG_TPS65010 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_AB3100_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=m
CONFIG_AGP_UNINORTH=m
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_SVGALIB=m
CONFIG_FB_MACMODES=y
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_OF=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_MATROX_MULTIHEAD=y
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=m
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=m
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_IBM_GXT4500=y
CONFIG_FB_PS3=y
CONFIG_FB_PS3_DEFAULT_SIZE_M=9
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_LTV350QV=m
CONFIG_LCD_ILI9320=m
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
# CONFIG_VGA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
CONFIG_FB_LOGO_EXTRA=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
# CONFIG_SND_PCM_XRUN_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
CONFIG_SND_AW2=m
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
CONFIG_SND_HIFIER=m
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
CONFIG_SND_VIRTUOSO=m
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_PPC=y
CONFIG_SND_POWERMAC=m
CONFIG_SND_POWERMAC_AUTO_DRC=y
CONFIG_SND_PS3=m
CONFIG_SND_PS3_DEFAULT_START_DELAY=2000
CONFIG_SND_AOA=m
CONFIG_SND_AOA_FABRIC_LAYOUT=m
CONFIG_SND_AOA_ONYX=m
CONFIG_SND_AOA_TAS=m
CONFIG_SND_AOA_TOONIE=m
CONFIG_SND_AOA_SOUNDBUS=m
CONFIG_SND_AOA_SOUNDBUS_I2S=m
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=m
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_BIG_ENDIAN_MMIO=y
CONFIG_USB_EHCI_HCD_PPC_OF=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PPC_OF_BE=y
# CONFIG_USB_OHCI_HCD_PPC_OF_LE is not set
CONFIG_USB_OHCI_HCD_PPC_OF=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_BIG_ENDIAN_DESC=y
CONFIG_USB_OHCI_BIG_ENDIAN_MMIO=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=m
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
CONFIG_USB_SERIAL_KEYSPAN_USA28=y
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
# CONFIG_USB_SERIAL_OPTICON is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_BERRY_CHARGE=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_GPIO_PLATFORM=y
CONFIG_LEDS_GPIO_OF=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_BD2802 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPATH=m
CONFIG_INFINIBAND_EHCA=m
CONFIG_INFINIBAND_AMSO1100=m
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_CXGB3=m
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
CONFIG_MLX4_INFINIBAND=m
CONFIG_INFINIBAND_NES=m
# CONFIG_INFINIBAND_NES_DEBUG is not set
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_CELL=m
# CONFIG_EDAC_AMD8131 is not set
# CONFIG_EDAC_AMD8111 is not set
# CONFIG_EDAC_CPC925 is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_SMX=m
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set

#
# TI VLYNQ
#
# CONFIG_STAGING is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4DEV_COMPAT=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
# CONFIG_GFS2_FS_LOCKING_DLM is not set
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_OCFS2_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=y
# CONFIG_VFAT_FS_DUALNAMES is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

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
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=m
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
# CONFIG_NILFS2_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_EXPERIMENTAL=y
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=m

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
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_HAVE_LMB=y
CONFIG_NLATTR=y

#
# Kernel hacking
#
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLQB_DEBUG=y
# CONFIG_SLQB_DEBUG_ON is not set
# CONFIG_SLQB_SYSFS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_LKDTM=m
CONFIG_FAULT_INJECTION=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=m
# CONFIG_KGDB_TESTS is not set
# CONFIG_PPC_DISABLE_WERROR is not set
CONFIG_PPC_WERROR=y
CONFIG_PRINT_STACK_DEPTH=64
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_HCALL_STATS is not set
# CONFIG_PPC_EMULATED_STATS is not set
# CONFIG_CODE_PATCHING_SELFTEST is not set
# CONFIG_FTR_FIXUP_SELFTEST is not set
# CONFIG_MSI_BITMAP_SELFTEST is not set
CONFIG_XMON=y
CONFIG_XMON_DEFAULT=y
CONFIG_XMON_DISASSEMBLY=y
CONFIG_DEBUGGER=y
CONFIG_IRQSTACKS=y
# CONFIG_VIRQ_DEBUG is not set
CONFIG_BOOTX_TEXT=y
# CONFIG_PPC_EARLY_DEBUG is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
# CONFIG_SECURITY_PATH is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=0
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_KEYS_COMPAT=y
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
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
CONFIG_CRYPTO_MANAGER=y
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
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
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
# CONFIG_CRYPTO_TWOFISH is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
# CONFIG_PPC_CLOCK is not set
CONFIG_VIRTUALIZATION=y
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m

--------------000502040002000200080803--
