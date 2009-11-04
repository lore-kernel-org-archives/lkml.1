Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbZKDBSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbZKDBSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 20:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbZKDBSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 20:18:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41582 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbZKDBSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 20:18:08 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Justin Mattock <justinmattock@gmail.com>
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gcc@gcc.gnu.org
In-Reply-To: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>
Message-Id: <20091104101410.D43E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  4 Nov 2009 10:18:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello,
> I'm not sure how to handle this,
> while compiling firefox-3.6b1.source
> I get this with the default compiling options,
> as well as custom:
> 
> 
> [  532.942324] cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
> [  532.942330] Pid: 16002, comm: cc1plus Tainted: P
> 2.6.32-rc5-00083-g04ea458 #2
> [  532.942333] Call Trace:
> [  532.942342]  [<ffffffff810bce11>] T.417+0x7c/0x245
> [  532.942347]  [<ffffffff810bd11c>] __out_of_memory+0x142/0x159
> [  532.942352]  [<ffffffff810bd1a1>] out_of_memory+0x6e/0x9d
> [  532.942357]  [<ffffffff810c0086>] __alloc_pages_nodemask+0x47e/0x5cc
> [  532.942363]  [<ffffffff810d2115>] handle_mm_fault+0x25d/0x68e
> [  532.942369]  [<ffffffff813dfc1d>] do_page_fault+0x2bb/0x2d3
> [  532.942373]  [<ffffffff813ddb25>] page_fault+0x25/0x30
> [  532.942376] Mem-Info:
> [  532.942378] DMA per-cpu:
> [  532.942380] CPU    0: hi:    0, btch:   1 usd:   0
> [  532.942383] CPU    1: hi:    0, btch:   1 usd:   0
> [  532.942385] DMA32 per-cpu:
> [  532.942388] CPU    0: hi:  186, btch:  31 usd:  94
> [  532.942391] CPU    1: hi:  186, btch:  31 usd:  23
> [  532.942393] Normal per-cpu:
> [  532.942395] CPU    0: hi:  186, btch:  31 usd: 150
> [  532.942398] CPU    1: hi:  186, btch:  31 usd: 155
> [  532.942404] active_anon:707575 inactive_anon:264673 isolated_anon:0
> [  532.942406]  active_file:58 inactive_file:33 isolated_file:0

file cache (active_file + inactive_file) was very little. It indicate anyone waste too much memory.
I doubt you use buggy compiler.



> [  532.942407]  unevictable:0 dirty:0 writeback:0 unstable:0 buffer:71
> [  532.942408]  free:6998 slab_reclaimable:2697 slab_unreclaimable:16267
> [  532.942409]  mapped:136 shmem:64 pagetables:2761 bounce:0
> [  532.942418] DMA free:15944kB min:28kB low:32kB high:40kB
> active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
> unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15360kB
> mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
> slab_reclaimable:0kB slab_unreclaimable:8kB kernel_stack:0kB
> pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
> pages_scanned:0 all_unreclaimable? yes
> [  532.942425] lowmem_reserve[]: 0 2976 3986 3986
> [  532.942436] DMA32 free:10020kB min:6020kB low:7524kB high:9028kB
> active_anon:2360492kB inactive_anon:590196kB active_file:84kB
> inactive_file:68kB unevictable:0kB isolated(anon):0kB
> isolated(file):0kB present:3047792kB mlocked:0kB dirty:0kB
> writeback:0kB mapped:136kB shmem:80kB slab_reclaimable:0kB
> slab_unreclaimable:88kB kernel_stack:0kB pagetables:6100kB
> unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:448
> all_unreclaimable? yes
> [  532.942443] lowmem_reserve[]: 0 0 1010 1010
> [  532.942454] Normal free:2028kB min:2040kB low:2548kB high:3060kB
> active_anon:469808kB inactive_anon:468496kB active_file:148kB
> inactive_file:64kB unevictable:0kB isolated(anon):0kB
> isolated(file):0kB present:1034240kB mlocked:0kB dirty:0kB
> writeback:0kB mapped:408kB shmem:176kB slab_reclaimable:10788kB
> slab_unreclaimable:64972kB kernel_stack:800kB pagetables:4944kB
> unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:413
> all_unreclaimable? yes
> [  532.942461] lowmem_reserve[]: 0 0 0 0
> [  532.942465] DMA: 2*4kB 2*8kB 3*16kB 2*32kB 3*64kB 2*128kB 2*256kB
> 1*512kB 2*1024kB 2*2048kB 2*4096kB = 15944kB
> [  532.942478] DMA32: 7*4kB 7*8kB 5*16kB 4*32kB 2*64kB 1*128kB 1*256kB
> 4*512kB 3*1024kB 0*2048kB 1*4096kB = 10020kB
> [  532.942490] Normal: 507*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
> 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2028kB
> [  532.942501] 7974 total pagecache pages
> [  532.942503] 7778 pages in swap cache
> [  532.942506] Swap cache stats: add 112290, delete 104512, find 3595/4051
> [  532.942508] Free swap  = 0kB
> [  532.942510] Total swap = 431632kB
> [  532.957941] 1048576 pages RAM
> [  532.957943] 40518 pages reserved
> [  532.957945] 312 pages shared
> [  532.957947] 1000176 pages non-shared
> [  532.957951] Out of memory: kill process 16001 (c++) score 543727 or a child
> [  532.957955] Killed process 16002 (cc1plus)
> 
> I just compiled the latest gcc snapshot a few days
> ago.


