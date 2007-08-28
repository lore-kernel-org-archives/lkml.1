Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbXH1LW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbXH1LW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 07:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbXH1LWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 07:22:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34636 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbXH1LWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 07:22:21 -0400
Subject: Re: 2.6.22.5-cfs20.2 another page allication failure
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Mittendorfer <delist@gmx.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070828125553.9d640960.delist@gmx.net>
References: <20070828125553.9d640960.delist@gmx.net>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 13:22:17 +0200
Message-Id: <1188300137.6112.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-28 at 12:55 +0200, Richard Mittendorfer wrote:
> Hello,
> 
> The box was up for 9 days when this one showed up. Currently rebuilding
> w/ cfs lastest version.

I'm curious why you think this is related to the scheduler?

>  kernel: gs: page allocation failure. order:1, mode:0x4020
>  kernel:  [<c0150070>] __alloc_pages+0x2f0/0x340
>  kernel:  [<c0169edc>] __slab_alloc+0x1dc/0x860
>  kernel:  [<c03569ed>] ip_local_deliver+0xfd/0x250
>  kernel:  [<c0356160>] ip_local_deliver_finish+0x0/0x1b0
>  kernel:  [<c0326d52>] __netdev_alloc_skb+0x22/0x50
>  kernel:  [<c016ac7b>] __kmalloc_track_caller+0x6b/0x70
>  kernel:  [<c0326d52>] __netdev_alloc_skb+0x22/0x50
>  kernel:  [<c0326a07>] __alloc_skb+0x57/0x120
>  kernel:  [<c0326d52>] __netdev_alloc_skb+0x22/0x50
>  kernel:  [<c02a31f4>] e100_rx_alloc_skb+0x24/0xa0
>  kernel:  [<c02a59a0>] e100_poll+0x1b0/0x430
>  kernel:  [<c01274a0>] process_timeout+0x0/0x10
>  kernel:  [<c032d34c>] net_rx_action+0x6c/0x170
>  kernel:  [<c0123f62>] __do_softirq+0x42/0x90
>  kernel:  [<c010691c>] do_softirq+0x5c/0xb0
>  kernel:  [<c016f0a4>] vfs_read+0x154/0x1d0
>  kernel:  [<c0148460>] handle_edge_irq+0x0/0xf0
>  kernel:  [<c0123e9a>] irq_exit+0x5a/0x60
>  kernel:  [<c01069ec>] do_IRQ+0x7c/0xc0
>  kernel:  [<c016f1e1>] sys_read+0x41/0x70
>  kernel:  [<c0104b7f>] common_interrupt+0x23/0x28
>  kernel:  =======================
>  kernel: Mem-info:
>  kernel: DMA per-cpu:
>  kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
>  kernel: Normal per-cpu:
>  kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  17   Cold: hi:   62, btch:  15 usd:  57
>  kernel: Active:106252 inactive:15242 dirty:9376 writeback:0 unstable:0
>  kernel:  free:1508 slab:3818 mapped:6284 pagetables:453 bounce:0
>  kernel: DMA free:1988kB min:64kB low:80kB high:96kB active:9244kB inactive:128kB present:16256kB pages_scanned:33 all_unreclaimable? no
>  kernel: lowmem_reserve[]: 0 491
>  kernel: Normal free:4044kB min:1980kB low:2472kB high:2968kB active:415764kB inactive:60840kB present:502920kB pages_scanned:140 all_unreclaimable? no
>  kernel: lowmem_reserve[]: 0 0
>  kernel: DMA: 21*4kB 0*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 1988kB
>  kernel: Normal: 917*4kB 1*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4044kB
>  kernel: Swap cache: add 6475, delete 6087, find 125398/125927, race 0+0
>  kernel: Free swap  = 1171308kB
>  kernel: Total swap = 1179344kB
>  kernel: Free swap:       1171308kB
>  kernel: 130816 pages of RAM
>  kernel: 0 pages of HIGHMEM
>  kernel: 2224 reserved pages
>  kernel: 92116 pages shared
>  kernel: 388 pages swap cached
>  kernel: 9376 pages dirty
>  kernel: 0 pages writeback
>  kernel: 6284 pages mapped
>  kernel: 3818 pages slab
>  kernel: 453 pages pagetables

Also curious why it failed, looks like it just hit the watermarks.
Could you provide us with the content of /proc/zoneinfo of that kernel?
Also, do you use SLUB or SLAB?

Normally these errors occur because of jumbo frames, but e100 doesn't do
that, so it seems an order-1 page was used to back smaller objects.

