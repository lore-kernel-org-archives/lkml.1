Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbZLBE3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbZLBE3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbZLBE3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:29:30 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59428 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbZLBE33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:29:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: davidjon@xenontk.org
Subject: Re: OOM kernel behaviour
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jonathan Miles <jon@cybus.co.uk>,
       penberg@cs.helsinki.fi
In-Reply-To: <4B154E10.7050300@xenontk.org>
References: <alpine.DEB.2.00.0912011007360.8841@router.home> <4B154E10.7050300@xenontk.org>
Message-Id: <20091202132026.5C55.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  2 Dec 2009 13:29:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 12/01/2009 09:37 PM, Christoph Lameter wrote:
> > Post the kernel log output please.
> 
> Here are three logs from three days. Log3.txt is today's log and the OOM
> killer murdered Thunderbird as I was attempting to write this message.
> The kernel config is also attached.


> Nov 19 18:56:07 avalanche kernel: hald invoked oom-killer: gfp_mask=0x201da, order=0, oomkilladj=0
> Nov 19 18:56:08 avalanche kernel: hald cpuset=/ mems_allowed=0
> Nov 19 18:56:08 avalanche kernel: Pid: 1455, comm: hald Tainted: P           2.6.31 #6

Proprietary module is loaded.


> Nov 19 18:56:08 avalanche kernel: Call Trace:
> Nov 19 18:56:08 avalanche kernel: [<ffffffff81409fc3>] ? _spin_unlock+0x26/0x31
> Nov 19 18:56:08 avalanche kernel: [<ffffffff810a3396>] oom_kill_process+0x91/0x250
> Nov 19 18:56:08 avalanche kernel: [<ffffffff810a3808>] ? select_bad_process+0x9e/0xfd
> Nov 19 18:56:08 avalanche kernel: [<ffffffff810a38f3>] __out_of_memory+0x8c/0x9b
> Nov 19 18:56:08 avalanche kernel: [<ffffffff810a3a60>] out_of_memory+0x15e/0x195
> Nov 19 18:56:08 avalanche kernel: [<ffffffff810a700c>] __alloc_pages_nodemask+0x494/0x584
> Nov 19 18:56:08 avalanche kernel: [<ffffffff810c96e9>] alloc_pages_current+0x90/0x99
> Nov 19 18:56:08 avalanche kernel: [<ffffffff810a10e0>] __page_cache_alloc+0x5a/0x5c
> Nov 19 18:56:08 avalanche kernel: [<ffffffff810a0e37>] ? __lock_page+0x61/0x68
> Nov 19 18:56:08 avalanche kernel: [<ffffffff810a8c23>] __do_page_cache_readahead+0xcc/0x1ae
> Nov 19 18:56:08 avalanche kernel: [<ffffffff810a8d21>] ra_submit+0x1c/0x20
> Nov 19 18:56:08 avalanche kernel: [<ffffffff810a15d8>] filemap_fault+0x183/0x34b
> Nov 19 18:56:08 avalanche kernel: [<ffffffff810b57fa>] __do_fault+0x50/0x388
> Nov 19 18:56:08 avalanche kernel: [<ffffffff810b780e>] handle_mm_fault+0x2c6/0x6be
> Nov 19 18:56:08 avalanche kernel: [<ffffffff811d5f48>] ? __strncpy_from_user+0x27/0x51
> Nov 19 18:56:08 avalanche kernel: [<ffffffff8140a05c>] ? _spin_unlock_irqrestore+0x28/0x33
> Nov 19 18:56:08 avalanche kernel: [<ffffffff8140c3c0>] do_page_fault+0x210/0x225
> Nov 19 18:56:08 avalanche kernel: [<ffffffff8140a49f>] page_fault+0x1f/0x30
> Nov 19 18:56:08 avalanche kernel: Mem-Info:
> Nov 19 18:56:08 avalanche kernel: Node 0 DMA per-cpu:
> Nov 19 18:56:08 avalanche kernel: CPU    0: hi:    0, btch:   1 usd:   0
> Nov 19 18:56:08 avalanche kernel: CPU    1: hi:    0, btch:   1 usd:   0
> Nov 19 18:56:08 avalanche kernel: Node 0 DMA32 per-cpu:
> Nov 19 18:56:08 avalanche kernel: CPU    0: hi:  186, btch:  31 usd: 115
> Nov 19 18:56:08 avalanche kernel: CPU    1: hi:  186, btch:  31 usd:  57
> Nov 19 18:56:08 avalanche kernel: Active_anon:343191 active_file:191 inactive_anon:116407
> Nov 19 18:56:08 avalanche kernel: inactive_file:222 unevictable:10 dirty:0 writeback:0 unstable:0
> Nov 19 18:56:08 avalanche kernel: free:3453 slab:17391 mapped:5687 pagetables:5159 bounce:0
> Nov 19 18:56:08 avalanche kernel: Node 0 DMA free:7908kB min:40kB low:48kB high:60kB active_anon:4192kB inactive_anon:3480kB active_file:12kB inactive_file:0kB unevictable:0kB present:15364kB pages_scanned:3 all_unreclaimable? no
> Nov 19 18:56:08 avalanche kernel: lowmem_reserve[]: 0 1967 1967 1967

Lots anon and very few file.

> Nov 19 18:56:08 avalanche kernel: Node 0 DMA32 free:5904kB min:5652kB low:7064kB high:8476kB active_anon:1368572kB inactive_anon:462148kB active_file:752kB inactive_file:888kB unevictable:40kB present:2014692kB pages_scanned:2656 all_unreclaimable? no
> Nov 19 18:56:08 avalanche kernel: lowmem_reserve[]: 0 0 0 0
> Nov 19 18:56:08 avalanche kernel: Node 0 DMA: 3*4kB 3*8kB 8*16kB 2*32kB 2*64kB 1*128kB 3*256kB 3*512kB 3*1024kB 1*2048kB 0*4096kB = 7908kB
> Nov 19 18:56:08 avalanche kernel: Node 0 DMA32: 474*4kB 7*8kB 19*16kB 12*32kB 17*64kB 5*128kB 2*256kB 2*512kB 0*1024kB 0*2048kB 0*4096kB = 5904kB
> Nov 19 18:56:08 avalanche kernel: 380799 total pagecache pages
> Nov 19 18:56:08 avalanche kernel: 11432 pages in swap cache
>
> Nov 19 18:56:08 avalanche kernel: Swap cache stats: add 786520, delete 775088, find 78519/102287
> Nov 19 18:56:08 avalanche kernel: Free swap  = 0kB
> Nov 19 18:56:08 avalanche kernel: Total swap = 2048248kB

no free swap.

Probably, some program in your system leaked memory.


> Nov 19 18:56:08 avalanche kernel: 514751 pages RAM
> Nov 19 18:56:08 avalanche kernel: 9604 pages reserved
> Nov 19 18:56:08 avalanche kernel: 46363 pages shared
> Nov 19 18:56:08 avalanche kernel: 457311 pages non-shared
> Nov 19 18:56:08 avalanche kernel: Out of memory: kill process 2879 (run-mozilla.sh) score 547203 or a child
> Nov 19 18:56:08 avalanche kernel: Killed process 2936 (firefox)




