Return-Path: <linux-kernel-owner+w=401wt.eu-S1760826AbYCTBWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826AbYCTBWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 21:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYCTBVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 21:21:51 -0400
Received: from bowden.ucwb.org.au ([203.122.237.119]:36051 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbYCTBVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 21:21:49 -0400
X-Greylist: delayed 2008 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2008 21:21:49 EDT
Subject: OOM (HighMem) on linux 2.6.24.2
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Thu, 20 Mar 2008 11:18:09 +1030
Message-Id: <1205974089.4023.20.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running a vanilla 2.6.24.2 kernel on an x86 system with 2GB physical
RAM. We had a problem yesterday where Samba and Apache both "died" and
AFAIK, we weren't able to ssh into the system. One of our staff was able
to reboot from the console though.

So, I found the following information in the system log just before it
went down:

Mar 19 17:01:21 hermes kernel: smbd invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
Mar 19 17:01:21 hermes kernel: Pid: 2757, comm: smbd Not tainted 2.6.24.2 #1
Mar 19 17:01:21 hermes kernel:  [<c0139841>] oom_kill_process+0x54/0xf8
Mar 19 17:01:21 hermes kernel:  [<c0139c3b>] out_of_memory+0x15f/0x194
Mar 19 17:01:21 hermes kernel:  [<c013b85e>] __alloc_pages+0x239/0x2c7
Mar 19 17:01:21 hermes kernel:  [<c0136de7>] sync_page+0x0/0x40
Mar 19 17:01:21 hermes kernel:  [<c03a0430>] preempt_schedule+0x3a/0x55
Mar 19 17:01:21 hermes kernel:  [<c013d283>] __do_page_cache_readahead+0xd5/0x1be
Mar 19 17:01:21 hermes kernel:  [<c013d6b2>] do_page_cache_readahead+0x49/0x53
Mar 19 17:01:21 hermes kernel:  [<c0138f95>] filemap_fault+0x19a/0x3b4
Mar 19 17:01:21 hermes kernel:  [<c013ec4e>] wakeup_kswapd+0x2d/0x70
Mar 19 17:01:22 hermes kernel:  [<c0141d80>] __do_fault+0x51/0x327
Mar 19 17:01:22 hermes kernel:  [<c0142485>] do_wp_page+0x42f/0x43b
Mar 19 17:01:22 hermes kernel:  [<c0143c3e>] handle_mm_fault+0x2aa/0x5b6
Mar 19 17:01:22 hermes kernel:  [<c011861d>] wake_up_new_task+0x77/0x7b
Mar 19 17:01:22 hermes kernel:  [<c0110f15>] do_page_fault+0x18d/0x530
Mar 19 17:01:22 hermes kernel:  [<c0323142>] sys_socketcall+0xeb/0x242
Mar 19 17:01:22 hermes kernel:  [<c015b799>] do_fcntl+0x1f8/0x27e
Mar 19 17:01:22 hermes kernel:  [<c0100a20>] sys_clone+0x36/0x3b
Mar 19 17:01:22 hermes kernel:  [<c0110d88>] do_page_fault+0x0/0x530
Mar 19 17:01:22 hermes kernel:  [<c03a1a72>] error_code+0x72/0x78
Mar 19 17:01:22 hermes kernel:  =======================
Mar 19 17:01:23 hermes kernel: Mem-info:
Mar 19 17:01:23 hermes kernel: DMA per-cpu:
Mar 19 17:01:23 hermes kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Mar 19 17:01:23 hermes kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Mar 19 17:01:23 hermes kernel: Normal per-cpu:
Mar 19 17:01:23 hermes kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  93   Cold: hi:   62, btch:  15 usd:  55
Mar 19 17:01:23 hermes kernel: CPU    1: Hot: hi:  186, btch:  31 usd: 120   Cold: hi:   62, btch:  15 usd:  55
Mar 19 17:01:23 hermes kernel: HighMem per-cpu:
Mar 19 17:01:23 hermes kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  46   Cold: hi:   62, btch:  15 usd:  60
Mar 19 17:01:23 hermes kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  12   Cold: hi:   62, btch:  15 usd:  61
Mar 19 17:01:23 hermes kernel: Active:150615 inactive:339150 dirty:0 writeback:0 unstable:0
Mar 19 17:01:23 hermes kernel:  free:12180 slab:6561 mapped:78 pagetables:2862 bounce:0
Mar 19 17:01:23 hermes kernel: DMA free:8132kB min:68kB low:84kB high:100kB active:1872kB inactive:1256kB present:16256kB pages_scanned:5836 all_unreclaimable? yes
Mar 19 17:01:23 hermes kernel: lowmem_reserve[]: 0 873 2016 2016
Mar 19 17:01:23 hermes kernel: Normal free:40136kB min:3744kB low:4680kB high:5616kB active:400240kB inactive:398884kB present:894080kB pages_scanned:2546811 all_unreclaimable? yes
Mar 19 17:01:23 hermes kernel: lowmem_reserve[]: 0 0 9143 9143
Mar 19 17:01:23 hermes kernel: HighMem free:452kB min:512kB low:1736kB high:2964kB active:200720kB inactive:956076kB present:1170372kB pages_scanned:3284202 all_unreclaimable? yes
Mar 19 17:01:23 hermes kernel: lowmem_reserve[]: 0 0 0 0
Mar 19 17:01:23 hermes kernel: DMA: 49*4kB 44*8kB 40*16kB 37*32kB 22*64kB 6*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 8132kB
Mar 19 17:01:23 hermes kernel: Normal: 9168*4kB 1*8kB 0*16kB 2*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 40136kB
Mar 19 17:01:23 hermes kernel: HighMem: 11*4kB 5*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 452kB
Mar 19 17:01:23 hermes kernel: Swap cache: add 550090, delete 550089, find 1023187/1039769, race 0+22
Mar 19 17:01:23 hermes kernel: Free swap  = 0kB
Mar 19 17:01:23 hermes kernel: Total swap = 899064kB
Mar 19 17:01:23 hermes kernel: Free swap:            0kB
Mar 19 17:01:23 hermes kernel: 524272 pages of RAM
Mar 19 17:01:23 hermes kernel: 294896 pages of HIGHMEM
Mar 19 17:01:23 hermes kernel: 5542 reserved pages
Mar 19 17:01:23 hermes kernel: 55226 pages shared
Mar 19 17:01:23 hermes kernel: 1 pages swap cached
Mar 19 17:01:23 hermes kernel: 0 pages dirty
Mar 19 17:01:23 hermes kernel: 0 pages writeback
Mar 19 17:01:23 hermes kernel: 78 pages mapped
Mar 19 17:01:23 hermes kernel: 6561 pages slab
Mar 19 17:01:23 hermes kernel: 2862 pages pagetables
Mar 19 17:01:23 hermes kernel: Out of memory: kill process 5928 (apache2) score 40674 or a child
Mar 19 17:01:23 hermes kernel: Killed process 5928 (apache2)

Just wondering if anyone could help me with interpreting what is going
on here. Does it look there's anything weird going on in kernel space
based on this, or did something in userspace really just exhaust all
memory?

The best I can understand from the log, the problem the kernel detected
was that HighMem fell below the low watermark. Also very strange to see
that it says we have no free swap space - normally we only see a handful
of pages from the whole ~1GB of swap being used, even after weeks of
uptime.

TIA,
Kevin.


