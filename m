Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbYCTKE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbYCTKE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 06:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbYCTKEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 06:04:50 -0400
Received: from bowden.ucwb.org.au ([203.122.237.119]:47831 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbYCTKEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 06:04:49 -0400
Subject: Re: OOM (HighMem) on linux 2.6.24.2
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1206003275.8514.399.camel@twins>
References: <1205974089.4023.20.camel@kulgan.wumi.org.au>
	 <1206003275.8514.399.camel@twins>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Thu, 20 Mar 2008 20:34:45 +1030
Message-Id: <1206007485.5086.8.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-20 at 09:54 +0100, Peter Zijlstra wrote:
> Looks like you just ran out of memory, swap is filled up, memory is
> pretty much used up, except for !HIGHMEM which even though it has enough
> free memory does report all_unreclaimable=1. This suggests this is a
> second OOM not the first, are you sure this is the first OOM on that
> box?

Well, it's the first time since we rebooted on Feb 28th.

Ugh, looks like the reason we rebooted then was because of something
similar as well:

Feb 28 06:32:19 hermes kernel: postmaster invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
Feb 28 06:32:19 hermes kernel: Pid: 2505, comm: postmaster Not tainted 2.6.24.2 #1
Feb 28 06:32:19 hermes kernel:  [<c0139841>] oom_kill_process+0x54/0xf8
Feb 28 06:32:19 hermes kernel:  [<c0139c3b>] out_of_memory+0x15f/0x194
Feb 28 06:32:19 hermes kernel:  [<c013b85e>] __alloc_pages+0x239/0x2c7
Feb 28 06:32:19 hermes kernel:  [<c013d283>] __do_page_cache_readahead+0xd5/0x1be
Feb 28 06:32:19 hermes kernel:  [<c013d6b2>] do_page_cache_readahead+0x49/0x53
Feb 28 06:32:19 hermes kernel:  [<c0138f95>] filemap_fault+0x19a/0x3b4
Feb 28 06:32:19 hermes kernel:  [<c0141d80>] __do_fault+0x51/0x327
Feb 28 06:32:19 hermes kernel:  [<c0143c3e>] handle_mm_fault+0x2aa/0x5b6
Feb 28 06:32:19 hermes kernel:  [<c0110f15>] do_page_fault+0x18d/0x530
Feb 28 06:32:19 hermes kernel:  [<c0110d88>] do_page_fault+0x0/0x530
Feb 28 06:32:20 hermes kernel:  [<c03a1a72>] error_code+0x72/0x78
Feb 28 06:32:20 hermes kernel:  =======================
Feb 28 06:32:20 hermes kernel: Mem-info:
Feb 28 06:32:20 hermes kernel: DMA per-cpu:
Feb 28 06:32:20 hermes kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 28 06:32:20 hermes kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 28 06:32:20 hermes kernel: Normal per-cpu:
Feb 28 06:32:20 hermes kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 163   Cold: hi:   62, btch:  15 usd:  59
Feb 28 06:32:20 hermes kernel: CPU    1: Hot: hi:  186, btch:  31 usd: 152   Cold: hi:   62, btch:  15 usd:  61
Feb 28 06:32:20 hermes kernel: HighMem per-cpu:
Feb 28 06:32:20 hermes kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  47
Feb 28 06:32:20 hermes kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  15   Cold: hi:   62, btch:  15 usd:  56
Feb 28 06:32:20 hermes kernel: Active:247172 inactive:246700 dirty:0 writeback:0 unstable:0
Feb 28 06:32:20 hermes kernel:  free:12237 slab:5313 mapped:92 pagetables:2632 bounce:0
Feb 28 06:32:20 hermes kernel: DMA free:8128kB min:68kB low:84kB high:100kB active:1576kB inactive:1336kB present:16256kB pages_scanned:12856 all_unreclaimable? yes
Feb 28 06:32:20 hermes kernel: lowmem_reserve[]: 0 873 2016 2016
Feb 28 06:32:20 hermes kernel: Normal free:40316kB min:3744kB low:4680kB high:5616kB active:399640kB inactive:407172kB present:894080kB pages_scanned:4921459 all_unreclaimable? yes
Feb 28 06:32:20 hermes kernel: lowmem_reserve[]: 0 0 9143 9143
Feb 28 06:32:20 hermes kernel: HighMem free:504kB min:512kB low:1736kB high:2964kB active:587472kB inactive:578292kB present:1170372kB pages_scanned:4714529 all_unreclaimable? yes
Feb 28 06:32:20 hermes kernel: lowmem_reserve[]: 0 0 0 0
Feb 28 06:32:20 hermes kernel: DMA: 96*4kB 138*8kB 131*16kB 22*32kB 4*64kB 2*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 8128kB
Feb 28 06:32:20 hermes kernel: Normal: 9119*4kB 6*8kB 9*16kB 6*32kB 2*64kB 2*128kB 2*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 40316kB
Feb 28 06:32:20 hermes kernel: HighMem: 22*4kB 18*8kB 1*16kB 0*32kB 0*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 504kB
Feb 28 06:32:20 hermes kernel: Swap cache: add 304821, delete 304821, find 81588/89482, race 0+6
Feb 28 06:32:20 hermes kernel: Free swap  = 0kB
Feb 28 06:32:20 hermes kernel: Total swap = 899064kB
Feb 28 06:32:20 hermes kernel: Free swap:            0kB
Feb 28 06:32:20 hermes kernel: 524272 pages of RAM
Feb 28 06:32:20 hermes kernel: 294896 pages of HIGHMEM
Feb 28 06:32:20 hermes kernel: 5542 reserved pages
Feb 28 06:32:20 hermes kernel: 49663 pages shared
Feb 28 06:32:20 hermes kernel: 0 pages swap cached
Feb 28 06:32:20 hermes kernel: 0 pages dirty
Feb 28 06:32:20 hermes kernel: 0 pages writeback
Feb 28 06:32:20 hermes kernel: 92 pages mapped
Feb 28 06:32:20 hermes kernel: 5313 pages slab
Feb 28 06:32:20 hermes kernel: 2632 pages pagetables
Feb 28 06:32:20 hermes kernel: Out of memory: kill process 24013 (apache2) score 22257 or a child
Feb 28 06:32:20 hermes kernel: Killed process 1904 (ntlm_auth)
Feb 28 06:32:20 hermes kernel: postmaster invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
Feb 28 06:32:20 hermes kernel: Pid: 2505, comm: postmaster Not tainted 2.6.24.2 #1
Feb 28 06:32:20 hermes kernel:  [<c0139841>] oom_kill_process+0x54/0xf8
Feb 28 06:32:20 hermes kernel:  [<c0139c3b>] out_of_memory+0x15f/0x194
Feb 28 06:32:20 hermes kernel:  [<c013b85e>] __alloc_pages+0x239/0x2c7
Feb 28 06:32:20 hermes kernel:  [<c013d283>] __do_page_cache_readahead+0xd5/0x1be
Feb 28 06:32:20 hermes kernel:  [<c013d6b2>] do_page_cache_readahead+0x49/0x53
Feb 28 06:32:20 hermes kernel:  [<c0138f95>] filemap_fault+0x19a/0x3b4
Feb 28 06:32:20 hermes kernel:  [<c0141d80>] __do_fault+0x51/0x327
Feb 28 06:32:20 hermes kernel:  [<c0143c3e>] handle_mm_fault+0x2aa/0x5b6
Feb 28 06:32:20 hermes kernel:  [<c0110f15>] do_page_fault+0x18d/0x530
Feb 28 06:32:20 hermes kernel:  [<c0110d88>] do_page_fault+0x0/0x530
Feb 28 06:32:20 hermes kernel:  [<c03a1a72>] error_code+0x72/0x78
Feb 28 06:32:20 hermes kernel:  =======================
Feb 28 06:32:20 hermes kernel: Mem-info:
Feb 28 06:32:20 hermes kernel: DMA per-cpu:
Feb 28 06:32:20 hermes kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 28 06:32:20 hermes kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 28 06:32:20 hermes kernel: Normal per-cpu:
Feb 28 06:32:20 hermes kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 162   Cold: hi:   62, btch:  15 usd:  59
Feb 28 06:32:20 hermes kernel: CPU    1: Hot: hi:  186, btch:  31 usd: 149   Cold: hi:   62, btch:  15 usd:  61
Feb 28 06:32:20 hermes kernel: HighMem per-cpu:
Feb 28 06:32:20 hermes kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:  47
Feb 28 06:32:20 hermes kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  43   Cold: hi:   62, btch:  15 usd:  56
Feb 28 06:32:20 hermes kernel: Active:247230 inactive:246512 dirty:0 writeback:62 unstable:0
Feb 28 06:32:20 hermes kernel:  free:12237 slab:5313 mapped:92 pagetables:2632 bounce:0
Feb 28 06:32:20 hermes kernel: DMA free:8128kB min:68kB low:84kB high:100kB active:1576kB inactive:1336kB present:16256kB pages_scanned:12856 all_unreclaimable? yes
Feb 28 06:32:20 hermes kernel: lowmem_reserve[]: 0 873 2016 2016
Feb 28 06:32:20 hermes kernel: Normal free:40316kB min:3744kB low:4680kB high:5616kB active:399512kB inactive:407172kB present:894080kB pages_scanned:4921491 all_unreclaimable? yes
Feb 28 06:32:20 hermes kernel: lowmem_reserve[]: 0 0 9143 9143
Feb 28 06:32:20 hermes kernel: HighMem free:504kB min:512kB low:1736kB high:2964kB active:587956kB inactive:577412kB present:1170372kB pages_scanned:4717047 all_unreclaimable? yes
Feb 28 06:32:20 hermes kernel: lowmem_reserve[]: 0 0 0 0
Feb 28 06:32:20 hermes kernel: DMA: 96*4kB 138*8kB 131*16kB 22*32kB 4*64kB 2*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 8128kB
Feb 28 06:32:20 hermes kernel: Normal: 9119*4kB 6*8kB 9*16kB 6*32kB 2*64kB 2*128kB 2*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 40316kB
Feb 28 06:32:20 hermes kernel: HighMem: 22*4kB 18*8kB 1*16kB 0*32kB 0*64kB 2*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 504kB
Feb 28 06:32:20 hermes kernel: Swap cache: add 304901, delete 304821, find 81588/89483, race 0+6
Feb 28 06:32:20 hermes kernel: Free swap  = 0kB
Feb 28 06:32:20 hermes kernel: Total swap = 899064kB
Feb 28 06:32:20 hermes kernel: Free swap:            0kB
Feb 28 06:32:20 hermes kernel: 524272 pages of RAM
Feb 28 06:32:20 hermes kernel: 294896 pages of HIGHMEM
Feb 28 06:32:20 hermes kernel: 5542 reserved pages
Feb 28 06:32:20 hermes kernel: 49707 pages shared
Feb 28 06:32:20 hermes kernel: 80 pages swap cached
Feb 28 06:32:20 hermes kernel: 0 pages dirty
Feb 28 06:32:20 hermes kernel: 62 pages writeback
Feb 28 06:32:20 hermes kernel: 92 pages mapped
Feb 28 06:32:20 hermes kernel: 5313 pages slab
Feb 28 06:32:20 hermes kernel: 2632 pages pagetables
Feb 28 06:32:20 hermes kernel: Out of memory: kill process 24013 (apache2) score 22070 or a child
Feb 28 06:32:20 hermes kernel: Killed process 24013 (apache2)

Looks like the HighMem low watermark was hit again (though I've no idea
if that's actually significant).

Thanks,
Kevin.


