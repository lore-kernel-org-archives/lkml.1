Return-Path: <linux-kernel-owner+w=401wt.eu-S935528AbXFFTao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935528AbXFFTao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759498AbXFFTaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:30:08 -0400
Received: from mx0.vr-web.de ([195.200.35.198]:30908 "EHLO mx0.vr-web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbXFFTaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:30:06 -0400
X-Greylist: delayed 781 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2007 15:30:05 EDT
From: Andreas Hartmann <andihartmann@01019freenet.de>
X-Newsgroups: linux.kernel
Subject: crash with linux 2.6.16 under high network traffic
Date: Wed, 06 Jun 2007 21:16:11 +0200
Organization: privat
Message-ID: <f4715r$4pu$1@p54A182E9.dip0.t-ipconnect.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Complaints-To: abuse@arcor.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2pre) Gecko/20070518 SeaMonkey/1.1.1
X-Enigmail-Version: 0.94.2.0
To: linux-kernel@vger.kernel.org
X-BitDefender-Scanner: Clean, Agent: BitDefender Courier MTA Agent
 1.6.2 on vrwebmail
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've got a "little" SUN V40Z database machine. It's a 4 way dual core AMD
Opteron with 20 GB of ram, 4 GB swap and a cassini network driver.

If I'm trying to do a "database restore" over the network, the machine
always crashes :-(.

Database restore means: there are 4 files, each having a size about 20 GB
(-> that's the size of the installed RAM!), which are fetched over the
network and written to the filesystem.

After the first of the files is closed and the second has been started,
the machine is getting slower and slower and tons of the following
messages can be found in messages (that's the last one - afterwards the
machine crashed silently).

...
Jun  6 13:15:36 pscudb01 kernel: printk: 12 messages suppressed.
Jun  6 13:15:36 pscudb01 kernel: The following is only an harmless
informational message.
Jun  6 13:15:36 pscudb01 kernel: Unless you get a _continuous_flood_ of
these messages it means
Jun  6 13:15:36 pscudb01 kernel: everything is working fine. Allocations
from irqs cannot be
Jun  6 13:15:36 pscudb01 kernel: perfectly reliable and the kernel is
designed to handle that.
Jun  6 13:15:36 pscudb01 kernel: events/4: page allocation failure.
order:1, mode:0x20
Jun  6 13:15:36 pscudb01 kernel:
Jun  6 13:15:36 pscudb01 kernel: Call Trace:
<ffffffff8015cd1c>{__alloc_pages+727}
<ffffffff80176c6c>{__cache_alloc_node+125}
Jun  6 13:15:36 pscudb01 kernel:
<ffffffff80170b6c>{alloc_page_interleave+56}
<ffffffff8817d24e>{:cassini:cas_page_alloc+83}
Jun  6 13:15:36 pscudb01 kernel:
<ffffffff8817d43f>{:cassini:cas_spare_recover+367}
<ffffffff88181398>{:cassini:cas_reset_task+165}
Jun  6 13:15:36 pscudb01 kernel:
<ffffffff881812f3>{:cassini:cas_reset_task+0}
<ffffffff80140177>{run_workqueue+153}
Jun  6 13:15:36 pscudb01 kernel:
<ffffffff8014081e>{worker_thread+0} <ffffffff80140927>{worker_thread+265}
Jun  6 13:15:36 pscudb01 kernel:
<ffffffff8012787f>{__wake_up_common+62}
<ffffffff8012905a>{default_wake_function+0}
Jun  6 13:15:36 pscudb01 kernel:        <ffffffff80143aca>{kthread+236}
<ffffffff8014081e>{worker_thread+0}
Jun  6 13:15:36 pscudb01 kernel:        <ffffffff8010b60a>{child_rip+8}
<ffffffff8014081e>{worker_thread+0}
Jun  6 13:15:36 pscudb01 kernel:        <ffffffff801439de>{kthread+0}
<ffffffff8010b602>{child_rip+0}
Jun  6 13:15:36 pscudb01 kernel: Mem-info:
Jun  6 13:15:36 pscudb01 kernel: Node 3 DMA per-cpu: empty
Jun  6 13:15:36 pscudb01 kernel: Node 3 DMA32 per-cpu: empty
Jun  6 13:15:36 pscudb01 kernel: Node 3 Normal per-cpu:
Jun  6 13:15:36 pscudb01 kernel: cpu 0 hot: high 186, batch 31 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 0 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 1 hot: high 186, batch 31 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 1 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 2 hot: high 186, batch 31 used:16
Jun  6 13:15:36 pscudb01 kernel: cpu 2 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 3 hot: high 186, batch 31 used:23
Jun  6 13:15:36 pscudb01 kernel: cpu 3 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 4 hot: high 186, batch 31 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 4 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 5 hot: high 186, batch 31 used:1
Jun  6 13:15:36 pscudb01 kernel: cpu 5 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 6 hot: high 186, batch 31 used:14
Jun  6 13:15:36 pscudb01 kernel: cpu 6 cold: high 62, batch 15 used:61
Jun  6 13:15:36 pscudb01 kernel: cpu 7 hot: high 186, batch 31 used:56
Jun  6 13:15:36 pscudb01 kernel: cpu 7 cold: high 62, batch 15 used:58
Jun  6 13:15:36 pscudb01 kernel: Node 3 HighMem per-cpu: empty
Jun  6 13:15:36 pscudb01 kernel: Node 2 DMA per-cpu: empty
Jun  6 13:15:36 pscudb01 kernel: Node 2 DMA32 per-cpu: empty
Jun  6 13:15:36 pscudb01 kernel: Node 2 Normal per-cpu:
Jun  6 13:15:36 pscudb01 kernel: cpu 0 hot: high 186, batch 31 used:1
Jun  6 13:15:36 pscudb01 kernel: cpu 0 cold: high 62, batch 15 used:48
Jun  6 13:15:36 pscudb01 kernel: cpu 1 hot: high 186, batch 31 used:32
Jun  6 13:15:36 pscudb01 kernel: cpu 1 cold: high 62, batch 15 used:51
Jun  6 13:15:36 pscudb01 kernel: cpu 2 hot: high 186, batch 31 used:4
Jun  6 13:15:36 pscudb01 kernel: cpu 2 cold: high 62, batch 15 used:47
Jun  6 13:15:36 pscudb01 kernel: cpu 3 hot: high 186, batch 31 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 3 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 4 hot: high 186, batch 31 used:10
Jun  6 13:15:36 pscudb01 kernel: cpu 4 cold: high 62, batch 15 used:55
Jun  6 13:15:36 pscudb01 kernel: cpu 5 hot: high 186, batch 31 used:28
Jun  6 13:15:36 pscudb01 kernel: cpu 5 cold: high 62, batch 15 used:47
Jun  6 13:15:36 pscudb01 kernel: cpu 6 hot: high 186, batch 31 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 6 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 7 hot: high 186, batch 31 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 7 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: Node 2 HighMem per-cpu: empty
Jun  6 13:15:36 pscudb01 kernel: Node 1 DMA per-cpu: empty
Jun  6 13:15:36 pscudb01 kernel: Node 1 DMA32 per-cpu: empty
Jun  6 13:15:36 pscudb01 kernel: Node 1 Normal per-cpu:
Jun  6 13:15:36 pscudb01 kernel: cpu 0 hot: high 186, batch 31 used:17
Jun  6 13:15:36 pscudb01 kernel: cpu 0 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 1 hot: high 186, batch 31 used:17
Jun  6 13:15:36 pscudb01 kernel: cpu 1 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 2 hot: high 186, batch 31 used:8
Jun  6 13:15:36 pscudb01 kernel: cpu 2 cold: high 62, batch 15 used:48
Jun  6 13:15:36 pscudb01 kernel: cpu 3 hot: high 186, batch 31 used:28
Jun  6 13:15:36 pscudb01 kernel: cpu 3 cold: high 62, batch 15 used:3
Jun  6 13:15:36 pscudb01 kernel: cpu 4 hot: high 186, batch 31 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 4 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 5 hot: high 186, batch 31 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 5 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 6 hot: high 186, batch 31 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 6 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 7 hot: high 186, batch 31 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 7 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: Node 1 HighMem per-cpu: empty
Jun  6 13:15:36 pscudb01 kernel: Node 0 DMA per-cpu:
Jun  6 13:15:36 pscudb01 kernel: cpu 0 hot: high 0, batch 1 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 0 cold: high 0, batch 1 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 1 hot: high 0, batch 1 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 1 cold: high 0, batch 1 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 2 hot: high 0, batch 1 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 2 cold: high 0, batch 1 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 3 hot: high 0, batch 1 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 3 cold: high 0, batch 1 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 4 hot: high 0, batch 1 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 4 cold: high 0, batch 1 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 5 hot: high 0, batch 1 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 5 cold: high 0, batch 1 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 6 hot: high 0, batch 1 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 6 cold: high 0, batch 1 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 7 hot: high 0, batch 1 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 7 cold: high 0, batch 1 used:0
Jun  6 13:15:36 pscudb01 kernel: Node 0 DMA32 per-cpu:
Jun  6 13:15:36 pscudb01 kernel: cpu 0 hot: high 186, batch 31 used:160
Jun  6 13:15:36 pscudb01 kernel: cpu 0 cold: high 62, batch 15 used:52
Jun  6 13:15:36 pscudb01 kernel: cpu 1 hot: high 186, batch 31 used:183
Jun  6 13:15:36 pscudb01 kernel: cpu 1 cold: high 62, batch 15 used:55
Jun  6 13:15:36 pscudb01 kernel: cpu 2 hot: high 186, batch 31 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 2 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 3 hot: high 186, batch 31 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 3 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 4 hot: high 186, batch 31 used:2
Jun  6 13:15:36 pscudb01 kernel: cpu 4 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 5 hot: high 186, batch 31 used:1
Jun  6 13:15:36 pscudb01 kernel: cpu 5 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 6 hot: high 186, batch 31 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 6 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 7 hot: high 186, batch 31 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 7 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: Node 0 Normal per-cpu:
Jun  6 13:15:36 pscudb01 kernel: cpu 0 hot: high 186, batch 31 used:28
Jun  6 13:15:36 pscudb01 kernel: cpu 0 cold: high 62, batch 15 used:12
Jun  6 13:15:36 pscudb01 kernel: cpu 1 hot: high 186, batch 31 used:22
Jun  6 13:15:36 pscudb01 kernel: cpu 1 cold: high 62, batch 15 used:58
Jun  6 13:15:36 pscudb01 kernel: cpu 2 hot: high 186, batch 31 used:45
Jun  6 13:15:36 pscudb01 kernel: cpu 2 cold: high 62, batch 15 used:59
Jun  6 13:15:36 pscudb01 kernel: cpu 3 hot: high 186, batch 31 used:28
Jun  6 13:15:36 pscudb01 kernel: cpu 3 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 4 hot: high 186, batch 31 used:18
Jun  6 13:15:36 pscudb01 kernel: cpu 4 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 5 hot: high 186, batch 31 used:30
Jun  6 13:15:36 pscudb01 kernel: cpu 5 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 6 hot: high 186, batch 31 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 6 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: cpu 7 hot: high 186, batch 31 used:1
Jun  6 13:15:36 pscudb01 kernel: cpu 7 cold: high 62, batch 15 used:0
Jun  6 13:15:36 pscudb01 kernel: Node 0 HighMem per-cpu: empty
Jun  6 13:15:36 pscudb01 kernel: Free pages:       91812kB (0kB HighMem)
Jun  6 13:15:36 pscudb01 kernel: Active:15263 inactive:11920 dirty:0
writeback:0 unstable:0 free:22953 slab:65215 mapped:5179 pagetables:487
Jun  6 13:15:36 pscudb01 kernel: Node 3 DMA free:0kB min:0kB low:0kB
high:0kB active:0kB inactive:0kB present:0kB pages_scanned:0
all_unreclaimable? no
Jun  6 13:15:36 pscudb01 kernel: lowmem_reserve[]: 0 0 4040 4040
Jun  6 13:15:36 pscudb01 kernel: Node 3 DMA32 free:0kB min:0kB low:0kB
high:0kB active:0kB inactive:0kB present:0kB pages_scanned:0
all_unreclaimable? no
Jun  6 13:15:36 pscudb01 kernel: lowmem_reserve[]: 0 0 4040 4040
Jun  6 13:15:36 pscudb01 kernel: Node 3 Normal free:7012kB min:3348kB
low:4184kB high:5020kB active:3688kB inactive:3136kB present:4136960kB
pages_scanned:490 all_unreclaimable? no
Jun  6 13:15:36 pscudb01 kernel: lowmem_reserve[]: 0 0 0 0
Jun  6 13:15:36 pscudb01 kernel: Node 3 HighMem free:0kB min:128kB
low:128kB high:128kB active:0kB inactive:0kB present:0kB pages_scanned:0
all_unreclaimable? no
Jun  6 13:15:36 pscudb01 kernel: lowmem_reserve[]: 0 0 0 0
Jun  6 13:15:36 pscudb01 kernel: Node 2 DMA free:0kB min:0kB low:0kB
high:0kB active:0kB inactive:0kB present:0kB pages_scanned:0
all_unreclaimable? no
Jun  6 13:15:36 pscudb01 kernel: lowmem_reserve[]: 0 0 4040 4040
Jun  6 13:15:36 pscudb01 kernel: Node 2 DMA32 free:0kB min:0kB low:0kB
high:0kB active:0kB inactive:0kB present:0kB pages_scanned:0
all_unreclaimable? no
Jun  6 13:15:36 pscudb01 kernel: lowmem_reserve[]: 0 0 4040 4040
Jun  6 13:15:36 pscudb01 kernel: Node 2 Normal free:26472kB min:3348kB
low:4184kB high:5020kB active:13868kB inactive:6220kB present:4136960kB
pages_scanned:74 all_unreclaimable? no
Jun  6 13:15:36 pscudb01 kernel: lowmem_reserve[]: 0 0 0 0
Jun  6 13:15:36 pscudb01 kernel: Node 2 HighMem free:0kB min:128kB
low:128kB high:128kB active:0kB inactive:0kB present:0kB pages_scanned:0
all_unreclaimable? no
Jun  6 13:15:36 pscudb01 kernel: lowmem_reserve[]: 0 0 0 0
Jun  6 13:15:36 pscudb01 kernel: Node 1 DMA free:0kB min:0kB low:0kB
high:0kB active:0kB inactive:0kB present:0kB pages_scanned:0
all_unreclaimable? no
Jun  6 13:15:36 pscudb01 kernel: lowmem_reserve[]: 0 0 8080 8080
Jun  6 13:15:36 pscudb01 kernel: Node 1 DMA32 free:0kB min:0kB low:0kB
high:0kB active:0kB inactive:0kB present:0kB pages_scanned:0
all_unreclaimable? no
Jun  6 13:15:36 pscudb01 kernel: lowmem_reserve[]: 0 0 8080 8080
Jun  6 13:15:36 pscudb01 kernel: Node 1 Normal free:11900kB min:6696kB
low:8368kB high:10044kB active:720kB inactive:496kB present:8273920kB
pages_scanned:1964 all_unreclaimable? yes
Jun  6 13:15:36 pscudb01 kernel: lowmem_reserve[]: 0 0 0 0
Jun  6 13:15:36 pscudb01 kernel: Node 1 HighMem free:0kB min:128kB
low:128kB high:128kB active:0kB inactive:0kB present:0kB pages_scanned:0
all_unreclaimable? no
Jun  6 13:15:36 pscudb01 kernel: lowmem_reserve[]: 0 0 0 0
Jun  6 13:15:36 pscudb01 kernel: Node 0 DMA free:12340kB min:8kB low:8kB
high:12kB active:0kB inactive:0kB present:11952kB pages_scanned:1116
all_unreclaimable? yes
Jun  6 13:15:36 pscudb01 kernel: lowmem_reserve[]: 0 3639 7679 7679
Jun  6 13:15:36 pscudb01 kernel: Node 0 DMA32 free:17292kB min:3016kB
low:3768kB high:4524kB active:880kB inactive:616kB present:3727008kB
pages_scanned:2356 all_unreclaimable? yes
Jun  6 13:15:36 pscudb01 kernel: lowmem_reserve[]: 0 0 4040 4040
Jun  6 13:15:36 pscudb01 kernel: Node 0 Normal free:16796kB min:3348kB
low:4184kB high:5020kB active:41896kB inactive:37212kB present:4136960kB
pages_scanned:0 all_unreclaimable? no
Jun  6 13:15:36 pscudb01 kernel: lowmem_reserve[]: 0 0 0 0
Jun  6 13:15:36 pscudb01 kernel: Node 0 HighMem free:0kB min:128kB
low:128kB high:128kB active:0kB inactive:0kB present:0kB pages_scanned:0
all_unreclaimable? no
Jun  6 13:15:36 pscudb01 kernel: lowmem_reserve[]: 0 0 0 0
Jun  6 13:15:36 pscudb01 kernel: Node 3 DMA: empty
Jun  6 13:15:36 pscudb01 kernel: Node 3 DMA32: empty
Jun  6 13:15:36 pscudb01 kernel: Node 3 Normal: 1595*4kB 1*8kB 1*16kB
1*32kB 1*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 7012kB
Jun  6 13:15:36 pscudb01 kernel: Node 3 HighMem: empty
Jun  6 13:15:36 pscudb01 kernel: Node 2 DMA: empty
Jun  6 13:15:36 pscudb01 kernel: Node 2 DMA32: empty
Jun  6 13:15:36 pscudb01 kernel: Node 2 Normal: 6460*4kB 1*8kB 1*16kB
1*32kB 1*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 26472kB
Jun  6 13:15:36 pscudb01 kernel: Node 2 HighMem: empty
Jun  6 13:15:36 pscudb01 kernel: Node 1 DMA: empty
Jun  6 13:15:36 pscudb01 kernel: Node 1 DMA32: empty
Jun  6 13:15:36 pscudb01 kernel: Node 1 Normal: 2661*4kB 1*8kB 0*16kB
1*32kB 1*64kB 1*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 11900kB
Jun  6 13:15:36 pscudb01 kernel: Node 1 HighMem: empty
Jun  6 13:15:36 pscudb01 kernel: Node 0 DMA: 3*4kB 3*8kB 1*16kB 4*32kB
2*64kB 2*128kB 2*256kB 0*512kB 1*1024kB 1*2048kB 2*4096kB = 12340kB
Jun  6 13:15:36 pscudb01 kernel: Node 0 DMA32: 4175*4kB 4*8kB 1*16kB
1*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 17292kB
Jun  6 13:15:36 pscudb01 kernel: Node 0 Normal: 4041*4kB 1*8kB 1*16kB
1*32kB 1*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 16796kB
Jun  6 13:15:36 pscudb01 kernel: Node 0 HighMem: empty
Jun  6 13:15:36 pscudb01 kernel: Swap cache: add 73569, delete 72373, find
23938/34427, race 0+2
Jun  6 13:15:36 pscudb01 kernel: Free swap  = 4170160kB
Jun  6 13:15:36 pscudb01 kernel: Total swap = 4200956kB
Jun  6 13:15:36 pscudb01 kernel: Free swap:       4170160kB
Jun  6 13:15:36 pscudb01 kernel: 6291456 pages of RAM
Jun  6 13:15:36 pscudb01 kernel: 214414 reserved pages
Jun  6 13:15:36 pscudb01 kernel: 28836 pages shared
Jun  6 13:15:36 pscudb01 kernel: 1209 pages swap cached


Sometimes, the oom-killer gets active too, before the machine crashes.


Does anybody has any idea, what to do to narrow down this problem? How can
I see how much memory the network driver module needs?

Background:
I'm suspecting the cassini driver to be the problem (memory leak?),
because I didn't have this problem without the cassini driver while using
another nic and driver.




Kind regards,
Andreas Hartmann
