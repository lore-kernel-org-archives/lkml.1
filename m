Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbXH0SDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbXH0SDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 14:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757724AbXH0SDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 14:03:08 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:55182 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759091AbXH0SDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 14:03:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=JqtukCbm3i3coB/wMGWxsUFHNEdU65KN3caX4MpDFZLd66eAPEbmWKjd64B7XgoTv1ztbzqLoZPnY4UQKjogFeK5aYtm+s2Gtuxc1RiVCFsmUUTVV7th9E4akpsXW5pNt/ehDgQBAwqF++KbQu/gT+6y1tO7TZiH7/o0NV8z4u8=
Message-ID: <23986fd90708271103r8f0ef68j86f85a6039be2f54@mail.gmail.com>
Date: Mon, 27 Aug 2007 11:03:02 -0700
From: "Patrick J. LoPresti" <lopresti@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: oom-killer with 27G free swap and overcommit_memory=2
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am using Linux 2.6.16.46-0.12-smp (SUSE 10 SP1 stock kernel).
I do intend to bother SUSE, but I am hoping some kind kernel savant
can help me interpret these log messages and/or give me some
suggestions for how to proceed.

My system is a SunFire x4100 (x86_64) with 16G of RAM and 32G of swap
in a single partition.  I have an application which consumes a lot of
memory, and after a few hours the oom-killer kills it.

This would not be surprising, except a) the machine still has 27G of
free swap at the time; and b) it happens even when I set
vm.overcommit_memory=2 (with overcommit_ratio=50).  It is
time-consuming to reproduce, but consistent.

Below is the first batch of messages from the oom-killer.  In this
case, overcommit_memory was set to 2, and the application
received no failures from malloc() or new.

9-10 more such batches appear in the log in rapid succession before
I get the "Kill process XXXX ... Killed process XXXX" pair of messages.

Here are my questions.  I realize these log messages may be insufficient
to answer them, and I am ready to provide more information upon
request.  (Unfortunately I cannot provide the application itself.  But
I can perform tests and provide logs.)

1) Does this behavior definitely indicate a kernel bug?  If not, what
could my application possibly be doing to cause it?

2) Is there any sysctl setting that might "avoid" this problem?  Or a
way to change my application to avoid it?

3) Should I attempt to reproduce this problem on the stock kernel.org
kernel?

Thank you for reading, and please CC me on any replies.

 - Pat

Aug 24 15:02:49 localhost kernel: oom-killer: gfp_mask=0x201d2, order=0
Aug 24 15:02:49 localhost kernel:
Aug 24 15:02:49 localhost kernel: Call Trace:
<ffffffff801613f5>{out_of_memory+93}
<ffffffff8016329c>{__alloc_pages+552}
Aug 24 15:02:49 localhost kernel:
<ffffffff8015e4e9>{page_cache_alloc_cold+13}
<ffffffff80164a9f>{__do_page_cache_readahead+149}
Aug 24 15:02:49 localhost kernel:
<ffffffff8015e31a>{sync_page+0} <ffffffff80136af1>{getnstimeofday+16}
Aug 24 15:02:49 localhost kernel:
<ffffffff80148129>{ktime_get_ts+26}
<ffffffff8015be29>{delayacct_end+93}
Aug 24 15:02:49 localhost kernel:
<ffffffff80164c6a>{blockable_page_cache_readahead+83}
Aug 24 15:02:49 localhost kernel:
<ffffffff80164d4b>{make_ahead_window+130}
<ffffffff80164eb8>{page_cache_readahead+337}
Aug 24 15:02:49 localhost kernel:
<ffffffff8016090d>{filemap_nopage+161}
<ffffffff8016b2eb>{__handle_mm_fault+511}
Aug 24 15:02:49 localhost kernel:
<ffffffff802dc44e>{do_page_fault+965}
<ffffffff8012aee7>{default_wake_function+0}
Aug 24 15:02:49 localhost kernel:        <ffffffff8010bc15>{error_exit+0}
Aug 24 15:02:49 localhost kernel: Mem-info:
Aug 24 15:02:49 localhost kernel: Node 1 DMA per-cpu: empty
Aug 24 15:02:50 localhost kernel: Node 1 DMA32 per-cpu: empty
Aug 24 15:02:50 localhost kernel: Node 1 Normal per-cpu:
Aug 24 15:02:50 localhost kernel: cpu 0 hot: high 186, batch 31 used:30
Aug 24 15:02:50 localhost kernel: cpu 0 cold: high 62, batch 15 used:27
Aug 24 15:02:50 localhost kernel: cpu 1 hot: high 186, batch 31 used:160
Aug 24 15:02:50 localhost kernel: cpu 1 cold: high 62, batch 15 used:16
Aug 24 15:02:50 localhost kernel: cpu 2 hot: high 186, batch 31 used:0
Aug 24 15:02:50 localhost kernel: cpu 2 cold: high 62, batch 15 used:45
Aug 24 15:02:50 localhost kernel: cpu 3 hot: high 186, batch 31 used:94
Aug 24 15:02:50 localhost kernel: cpu 3 cold: high 62, batch 15 used:60
Aug 24 15:02:50 localhost kernel: Node 1 HighMem per-cpu: empty
Aug 24 15:02:50 localhost kernel: Node 0 DMA per-cpu:
Aug 24 15:02:50 localhost kernel: cpu 0 hot: high 0, batch 1 used:0
Aug 24 15:02:50 localhost kernel: cpu 0 cold: high 0, batch 1 used:0
Aug 24 15:02:50 localhost kernel: cpu 1 hot: high 0, batch 1 used:0
Aug 24 15:02:50 localhost kernel: cpu 1 cold: high 0, batch 1 used:0
Aug 24 15:02:50 localhost rpc.mountd: export request from 192.146.3.6
Aug 24 15:02:50 localhost kernel: cpu 2 hot: high 0, batch 1 used:0
Aug 24 15:02:50 localhost rpc.mountd: export request from 192.146.3.6
Aug 24 15:02:50 localhost kernel: cpu 2 cold: high 0, batch 1 used:0
Aug 24 15:02:50 localhost rpc.mountd: export request from 192.146.3.6
Aug 24 15:02:50 localhost kernel: cpu 3 hot: high 0, batch 1 used:0
Aug 24 15:02:50 localhost kernel: cpu 3 cold: high 0, batch 1 used:0
Aug 24 15:02:51 localhost kernel: Node 0 DMA32 per-cpu:
Aug 24 15:02:51 localhost kernel: cpu 0 hot: high 186, batch 31 used:145
Aug 24 15:02:51 localhost rpc.mountd: authenticated mount request from
server:936 for /share (/share)
Aug 24 15:02:51 localhost kernel: cpu 0 cold: high 62, batch 15 used:42
Aug 24 15:02:51 localhost kernel: cpu 1 hot: high 186, batch 31 used:160
Aug 24 15:02:51 localhost kernel: cpu 1 cold: high 62, batch 15 used:14
Aug 24 15:02:51 localhost kernel: cpu 2 hot: high 186, batch 31 used:0
Aug 24 15:02:51 localhost kernel: cpu 2 cold: high 62, batch 15 used:0
Aug 24 15:02:51 localhost kernel: cpu 3 hot: high 186, batch 31 used:4
Aug 24 15:02:51 localhost kernel: cpu 3 cold: high 62, batch 15 used:0
Aug 24 15:02:51 localhost kernel: Node 0 Normal per-cpu:
Aug 24 15:02:51 localhost kernel: cpu 0 hot: high 186, batch 31 used:7
Aug 24 15:02:51 localhost kernel: cpu 0 cold: high 62, batch 15 used:58
Aug 24 15:02:51 localhost kernel: cpu 1 hot: high 186, batch 31 used:107
Aug 24 15:02:51 localhost kernel: cpu 1 cold: high 62, batch 15 used:60
Aug 24 15:02:51 localhost kernel: cpu 2 hot: high 186, batch 31 used:0
Aug 24 15:02:51 localhost kernel: cpu 2 cold: high 62, batch 15 used:0
Aug 24 15:02:51 localhost kernel: cpu 3 hot: high 186, batch 31 used:77
Aug 24 15:02:51 localhost kernel: cpu 3 cold: high 62, batch 15 used:0
Aug 24 15:02:51 localhost kernel: Node 0 HighMem per-cpu: empty
Aug 24 15:02:51 localhost kernel: Free pages:       44376kB (0kB HighMem)
Aug 24 15:02:51 localhost kernel: Active:571 inactive:1554 dirty:0
writeback:519 unstable:0 free:11094 slab:5144 mapped:905
pagetables:4527
Aug 24 15:02:51 localhost kernel: Node 1 DMA free:0kB min:0kB low:0kB
high:0kB active:0kB inactive:0kB present:0kB pages_scanned:0
all_unreclaimable? no
Aug 24 15:02:51 localhost kernel: lowmem_reserve[]: 0 0 8080 8080
Aug 24 15:02:51 localhost kernel: Node 1 DMA32 free:0kB min:0kB
low:0kB high:0kB active:0kB inactive:0kB present:0kB pages_scanned:0
all_unreclaimable? no
Aug 24 15:02:51 localhost kernel: lowmem_reserve[]: 0 0 8080 8080
Aug 24 15:02:51 localhost kernel: Node 1 Normal free:8060kB min:8168kB
low:10208kB high:12252kB active:320kB inactive:3984kB
present:8273920kB pages_scanned:6508 all_unreclaimable? yes
Aug 24 15:02:51 localhost kernel: lowmem_reserve[]: 0 0 0 0
Aug 24 15:02:51 localhost kernel: Node 1 HighMem free:0kB min:128kB
low:128kB high:128kB active:0kB inactive:0kB present:0kB
pages_scanned:0 all_unreclaimable? no
Aug 24 15:02:51 localhost kernel: lowmem_reserve[]: 0 0 0 0
Aug 24 15:02:51 localhost kernel: Node 0 DMA free:12256kB min:8kB
low:8kB high:12kB active:0kB inactive:0kB present:11856kB
pages_scanned:550 all_unreclaimable? yes
Aug 24 15:02:51 localhost kernel: lowmem_reserve[]: 0 3896 7936 7936
Aug 24 15:02:51 localhost kernel: Node 0 DMA32 free:20088kB min:3936kB
low:4920kB high:5904kB active:0kB inactive:0kB present:3989664kB
pages_scanned:312 all_unreclaimable? yes
Aug 24 15:02:51 localhost kernel: lowmem_reserve[]: 0 0 4040 4040
Aug 24 15:02:51 localhost kernel: Node 0 Normal free:3972kB min:4084kB
low:5104kB high:6124kB active:1964kB inactive:2232kB present:4136960kB
pages_scanned:6579 all_unreclaimable? yes
Aug 24 15:02:51 localhost kernel: lowmem_reserve[]: 0 0 0 0
Aug 24 15:02:51 localhost kernel: Node 0 HighMem free:0kB min:128kB
low:128kB high:128kB active:0kB inactive:0kB present:0kB
pages_scanned:0 all_unreclaimable? no
Aug 24 15:02:51 localhost kernel: lowmem_reserve[]: 0 0 0 0
Aug 24 15:02:51 localhost kernel: Node 1 DMA: empty
Aug 24 15:02:52 localhost kernel: Node 1 DMA32: empty
Aug 24 15:02:52 localhost kernel: Node 1 Normal: 1*4kB 1*8kB 13*16kB
1*32kB 2*64kB 12*128kB 2*256kB 1*512kB 1*1024kB 0*2048kB 1*4096kB =
8060kB
Aug 24 15:02:52 localhost kernel: Node 1 HighMem: empty
Aug 24 15:02:52 localhost kernel: Node 0 DMA: 4*4kB 4*8kB 1*16kB
3*32kB 1*64kB 2*128kB 2*256kB 0*512kB 1*1024kB 1*2048kB 2*4096kB =
12256kB
Aug 24 15:02:52 localhost kernel: Node 0 DMA32: 6*4kB 4*8kB 2*16kB
1*32kB 0*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 4*4096kB =
20088kB
Aug 24 15:02:52 localhost kernel: Node 0 Normal: 99*4kB 9*8kB 5*16kB
1*32kB 1*64kB 0*128kB 3*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB =
3972kB
Aug 24 15:02:52 localhost kernel: Node 0 HighMem: empty
Aug 24 15:02:52 localhost kernel: Swap cache: add 1296338, delete
1295527, find 318/572, race 0+0
Aug 24 15:02:52 localhost kernel: Free swap  = 27401720kB
Aug 24 15:02:52 localhost kernel: Total swap = 32579812kB
Aug 24 15:02:52 localhost kernel: Free swap:       27401720kB
