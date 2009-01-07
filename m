Return-Path: <linux-kernel-owner+w=401wt.eu-S1763940AbZAGXhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763940AbZAGXhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759327AbZAGXhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:37:06 -0500
Received: from mx1.aecom.yu.edu ([129.98.1.51]:38738 "EHLO mx1.aecom.yu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758345AbZAGXhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:37:04 -0500
X-Greylist: delayed 1235 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Jan 2009 18:37:03 EST
X-AuditID: 816201a0-a8de3bb000001567-99-496537cb3671
Mime-Version: 1.0
Message-Id: <a06240403c58ae633aba5@[129.98.90.227]>
Date: Wed, 7 Jan 2009 18:15:17 -0500
To: linux-kernel@vger.kernel.org
From: Maurice Volaski <mvolaski@aecom.yu.edu>
Subject: swapper: page allocation failure. order:2, mode:0x4020 in 2.6.27
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just started with 2.6.27-gentoo-r7 (I think gentoo may have patches 
from 2.6.28) on an x64 system and during an apparently idle time, I 
saw this:

Jan  6 23:20:19 [kernel] [358105.255843] swapper: page allocation 
failure. order:2, mode:0x4020
Jan  6 23:20:19 [kernel] [358105.255851] Pid: 0, comm: swapper Not 
tainted 2.6.27-gentoo-r7 #3
Jan  6 23:20:19 [kernel] [358105.255854]
Jan  6 23:20:19 [kernel] [358105.255854] Call Trace:
Jan  6 23:20:19 [kernel] [358105.255857]  <IRQ>  [<ffffffff81076bbf>] 
__alloc_pages_internal+0x41a/0x439
Jan  6 23:20:19 [kernel] [358105.255872]  [<ffffffff8126575c>] ? 
__netdev_alloc_skb+0x1d/0x39
Jan  6 23:20:19 [kernel] [358105.255875]  [<ffffffff81076c4c>] 
__get_free_pages+0x17/0x56
Jan  6 23:20:19 [kernel] [358105.255879]  [<ffffffff8109632b>] 
__kmalloc_track_caller+0x3b/0xbb
Jan  6 23:20:19 [kernel] [358105.255882]  [<ffffffff81264d87>] 
__alloc_skb+0x66/0x12c
Jan  6 23:20:19 [kernel] [358105.255885]  [<ffffffff8126575c>] 
__netdev_alloc_skb+0x1d/0x39
Jan  6 23:20:19 [kernel] [358105.255899]  [<ffffffffa00d203c>] 
tg3_alloc_rx_skb+0xd1/0x195 [tg3]
Jan  6 23:20:19 [kernel] [358105.255906]  [<ffffffffa00d9eb2>] 
tg3_poll+0x563/0xa68 [tg3]
Jan  6 23:20:19 [kernel] [358105.255910]  [<ffffffff8104b567>] ? 
clockevents_program_event+0x73/0x7c
Jan  6 23:20:19 [kernel] [358105.255914]  [<ffffffff81268608>] 
net_rx_action+0xd3/0x1d0
Jan  6 23:20:19 [kernel] [358105.255917]  [<ffffffff81268597>] ? 
net_rx_action+0x62/0x1d0
Jan  6 23:20:19 [kernel] [358105.255921]  [<ffffffff81035222>] 
__do_softirq+0x6d/0xdd
Jan  6 23:20:19 [kernel] [358105.255925]  [<ffffffff8100d2cc>] 
call_softirq+0x1c/0x28
Jan  6 23:20:19 [kernel] [358105.255928]  [<ffffffff8100e405>] 
do_softirq+0x34/0x72
Jan  6 23:20:19 [kernel] [358105.255931]  [<ffffffff81034f54>] 
irq_exit+0x3f/0x82
Jan  6 23:20:19 [kernel] [358105.255933]  [<ffffffff8100e6ee>] 
do_IRQ+0x146/0x168
Jan  6 23:20:19 [kernel] [358105.255936]  [<ffffffff8100c541>] 
ret_from_intr+0x0/0xa
Jan  6 23:20:19 [kernel] [358105.255938]  <EOI>  [<ffffffff812dd3cc>] 
? __atomic_notifier_call_chain+0x0/0x87
Jan  6 23:20:19 [kernel] [358105.255947]  [<ffffffff81012593>] ? 
default_idle+0x2b/0x40
Jan  6 23:20:19 [kernel] [358105.255950]  [<ffffffff8100b041>] ? 
enter_idle+0x22/0x24
Jan  6 23:20:19 [kernel] [358105.255952]  [<ffffffff8100b0d3>] ? 
cpu_idle+0x90/0xd8
Jan  6 23:20:19 [kernel] [358105.255956]  [<ffffffff812d4ce7>] ? 
start_secondary+0x155/0x159
Jan  6 23:20:19 [kernel] [358105.255958]
Jan  6 23:20:19 [kernel] [358105.255959] Mem-Info:
Jan  6 23:20:19 [kernel] [358105.255961] DMA per-cpu:
Jan  6 23:20:19 [kernel] [358105.255963] CPU    0: hi:    0, btch:   1 usd:   0
Jan  6 23:20:19 [kernel] [358105.255965] CPU    1: hi:    0, btch:   1 usd:   0
Jan  6 23:20:19 [kernel] [358105.255967] DMA32 per-cpu:
Jan  6 23:20:19 [kernel] [358105.255968] CPU    0: hi:  186, btch:  31 usd: 126
Jan  6 23:20:19 [kernel] [358105.255970] CPU    1: hi:  186, btch:  31 usd: 148
Jan  6 23:20:19 [kernel] [358105.255972] Normal per-cpu:
Jan  6 23:20:19 [kernel] [358105.255973] CPU    0: hi:  186, btch:  31 usd: 181
Jan  6 23:20:19 [kernel] [358105.255975] CPU    1: hi:  186, btch:  31 usd: 183
Jan  6 23:20:19 [kernel] [358105.255978] Active:218402 
inactive:819867 dirty:27016 writeback:0 unstable:0
Jan  6 23:20:19 [kernel] [358105.255980]  free:44839 slab:151548 
mapped:5449 pagetables:2110 bounce:0
Jan  6 23:20:19 [kernel] [358105.255983] DMA free:5328kB min:4kB 
low:4kB high:4kB active:0kB inactive:0kB present:4256kB 
pages_scanned:0 all_unreclaimable? yes
Jan  6 23:20:19 [kernel] [358105.255986] lowmem_reserve[]: 0 3480 5484 5484
Jan  6 23:20:19 [kernel] [358105.255991] DMA32 free:169860kB 
min:6008kB low:7508kB high:9012kB active:433812kB inactive:1876764kB 
present:3563808kB pages_scanned:0 all_unreclaimable? no
Jan  6 23:20:19 [kernel] [358105.255993] lowmem_reserve[]: 0 0 2004 2004
Jan  6 23:20:19 [kernel] [358105.255998] Normal free:4168kB 
min:3460kB low:4324kB high:5188kB active:439796kB inactive:1402704kB 
present:2052096kB pages_scanned:0 all_unreclaimable? no
Jan  6 23:20:19 [kernel] [358105.256000] lowmem_reserve[]: 0 0 0 0
Jan  6 23:20:19 [kernel] [358105.256004] DMA: 2*4kB 3*8kB 5*16kB 
5*32kB 3*64kB 4*128kB 3*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 
5328kB
Jan  6 23:20:19 [kernel] [358105.256012] DMA32: 42208*4kB 0*8kB 
12*16kB 3*32kB 0*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 
0*4096kB = 169760kB
Jan  6 23:20:19 [kernel] [358105.256020] Normal: 914*4kB 1*8kB 2*16kB 
1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 
4176kB
Jan  6 23:20:19 [kernel] [358105.256029] 1015437 total pagecache pages
Jan  6 23:20:19 [kernel] [358105.256031] 0 pages in swap cache
Jan  6 23:20:19 [kernel] [358105.256032] Swap cache stats: add 0, 
delete 0, find 0/0
Jan  6 23:20:19 [kernel] [358105.256034] Free swap  = 0kB
Jan  6 23:20:19 [kernel] [358105.256035] Total swap = 0kB
Jan  6 23:20:19 [kernel] [358105.285015] 1572848 pages RAM
Jan  6 23:20:19 [kernel] [358105.285015] 170874 pages reserved
Jan  6 23:20:19 [kernel] [358105.285015] 986700 pages shared
Jan  6 23:20:19 [kernel] [358105.285015] 411152 pages non-shared
-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
