Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbXCPK4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbXCPK4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 06:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbXCPK4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 06:56:21 -0400
Received: from hermes.domdv.de ([193.102.202.1]:1314 "EHLO hermes.domdv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbXCPK4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 06:56:19 -0400
Message-ID: <45FA77D1.2060306@domdv.de>
Date: Fri, 16 Mar 2007 11:56:17 +0100
From: Andreas Steinmetz <ast@domdv.de>
User-Agent: Mail/News 1.5.0.7 (X11/20060915)
MIME-Version: 1.0
To: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: 2.6.20.3: kswapd page allocation failure
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Got the following from dmesg of one of my servers last night (happened
during nightly backup over network):

kswapd0: page allocation failure. order:3, mode:0x20
 [<c01394bc>] __alloc_pages+0x28e/0x29d
 [<c014a720>] kmem_getpages+0x34/0x9a
 [<c014b22d>] cache_grow+0x9d/0x12b
 [<c014b3f3>] cache_alloc_refill+0x138/0x170
 [<c014b6e9>] __kmalloc+0x62/0x70
 [<c036b638>] __alloc_skb+0x42/0xed
 [<c036b7cf>] __netdev_alloc_skb+0x1a/0x33
 [<f9039fd3>] e1000_alloc_rx_buffers+0xbb/0x299 [e1000]
 [<f9039a1d>] e1000_clean_rx_irq+0x407/0x425 [e1000]
 [<f90392f4>] e1000_intr+0xb9/0x109 [e1000]
 [<c013417d>] handle_IRQ_event+0x1a/0x3f
 [<c0134d3f>] handle_level_irq+0x66/0xa0
 [<c0105c1d>] do_IRQ+0x5d/0x74
 [<c0137f97>] mempool_free+0x48/0x4c
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c036c63a>] skb_copy_bits+0x51/0x243
 [<c01390c4>] buffered_rmqueue+0xbe/0xd7
 [<c036b9a3>] __kfree_skb+0x9b/0xc5
 [<c03a10a4>] tcp_collapse+0x268/0x2f4
 [<c03a124d>] tcp_prune_queue+0x96/0x144
 [<c03a098f>] tcp_data_queue+0x19e/0x64b
 [<c03a1bec>] tcp_rcv_established+0x51c/0x574
 [<c03a8379>] tcp_v4_do_rcv+0x22/0xb7
 [<c03a8832>] tcp_v4_rcv+0x424/0x6c9
 [<c03ab12c>] raw_rcv_skb+0x15/0x1e
 [<c0391809>] ip_local_deliver+0x14f/0x1d4
 [<c0391c80>] ip_local_deliver_finish+0x0/0x151
 [<c0391c4e>] ip_rcv+0x3c0/0x3f2
 [<c0391dd1>] ip_rcv_finish+0x0/0x1fb
 [<f9039a1d>] e1000_clean_rx_irq+0x407/0x425 [e1000]
 [<c0370cfc>] netif_receive_skb+0x1e5/0x1fb
 [<c0370d81>] process_backlog+0x6f/0xd2
 [<c0370e5a>] net_rx_action+0x76/0x106
 [<c011ea51>] __do_softirq+0x35/0x73
 [<c011eab1>] do_softirq+0x22/0x26
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c0129f49>] bit_waitqueue+0x20/0x47
 [<c0129f1e>] wake_up_bit+0xb/0x16
 [<c015c2ab>] dispose_list+0x88/0xa4
 [<c015c4fc>] prune_icache+0x136/0x148
 [<c015c522>] shrink_icache_memory+0x14/0x2b
 [<c013bdf4>] shrink_slab+0x135/0x18e
 [<c013cdcb>] balance_pgdat+0x1e6/0x2eb
 [<c013cfc5>] kswapd+0xf5/0xf7
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c011841f>] __wake_up_common+0x35/0x56
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c013ced0>] kswapd+0x0/0xf7
 [<c0129bcc>] kthread+0x72/0x97
 [<c0129b5a>] kthread+0x0/0x97
 [<c010467b>] kernel_thread_helper+0x7/0x10
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15
usd:   2
HighMem per-cpu:
CPU    0: Hot: hi:   42, btch:   7 usd:  40   Cold: hi:   14, btch:   3
usd:   2
Active:171834 inactive:59703 dirty:846 writeback:0 unstable:0 free:2311
slab:20911 mapped:4658 pagetables:765
DMA free:3536kB min:68kB low:84kB high:100kB active:5152kB
inactive:1232kB present:16256kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 873 1000
Normal free:5448kB min:3744kB low:4680kB high:5616kB active:569208kB
inactive:228308kB present:894080kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1015
HighMem free:260kB min:128kB low:264kB high:400kB active:112976kB
inactive:9272kB present:129988kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 40*4kB 36*8kB 15*16kB 1*32kB 0*64kB 0*128kB 1*256kB 1*512kB
0*1024kB 1*2048kB 0*4096kB = 3536kB
Normal: 152*4kB 491*8kB 45*16kB 0*32kB 1*64kB 1*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 5448kB
HighMem: 1*4kB 18*8kB 1*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 260kB
Swap cache: add 132, delete 132, find 0/0, race 0+0
Free swap  = 16064704kB
Total swap = 16064704kB
Free swap:       16064704kB
262128 pages of RAM
32752 pages of HIGHMEM
3672 reserved pages
82110 pages shared
0 pages swap cached
846 pages dirty
0 pages writeback
4658 pages mapped
20911 pages slab
765 pages pagetables
kswapd0: page allocation failure. order:3, mode:0x20
 [<c01394bc>] __alloc_pages+0x28e/0x29d
 [<c014a720>] kmem_getpages+0x34/0x9a
 [<c014b22d>] cache_grow+0x9d/0x12b
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c011bde4>] profile_tick+0x39/0x53
 [<c014b3f3>] cache_alloc_refill+0x138/0x170
 [<c014b6e9>] __kmalloc+0x62/0x70
 [<c036b638>] __alloc_skb+0x42/0xed
 [<c036b7cf>] __netdev_alloc_skb+0x1a/0x33
 [<f9039fd3>] e1000_alloc_rx_buffers+0xbb/0x299 [e1000]
 [<f90399a4>] e1000_clean_rx_irq+0x38e/0x425 [e1000]
 [<f90392f4>] e1000_intr+0xb9/0x109 [e1000]
 [<c013417d>] handle_IRQ_event+0x1a/0x3f
 [<c0134d3f>] handle_level_irq+0x66/0xa0
 [<c0105c1d>] do_IRQ+0x5d/0x74
 [<c0137f97>] mempool_free+0x48/0x4c
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c036c63a>] skb_copy_bits+0x51/0x243
 [<c01390c4>] buffered_rmqueue+0xbe/0xd7
 [<c036b9a3>] __kfree_skb+0x9b/0xc5
 [<c03a10a4>] tcp_collapse+0x268/0x2f4
 [<c03a124d>] tcp_prune_queue+0x96/0x144
 [<c03a098f>] tcp_data_queue+0x19e/0x64b
 [<c03a1bec>] tcp_rcv_established+0x51c/0x574
 [<c03a8379>] tcp_v4_do_rcv+0x22/0xb7
 [<c03a8832>] tcp_v4_rcv+0x424/0x6c9
 [<c03ab12c>] raw_rcv_skb+0x15/0x1e
 [<c0391809>] ip_local_deliver+0x14f/0x1d4
 [<c0391c80>] ip_local_deliver_finish+0x0/0x151
 [<c0391c4e>] ip_rcv+0x3c0/0x3f2
 [<c0391dd1>] ip_rcv_finish+0x0/0x1fb
 [<f9039a1d>] e1000_clean_rx_irq+0x407/0x425 [e1000]
 [<c0370cfc>] netif_receive_skb+0x1e5/0x1fb
 [<c0370d81>] process_backlog+0x6f/0xd2
 [<c0370e5a>] net_rx_action+0x76/0x106
 [<c011ea51>] __do_softirq+0x35/0x73
 [<c011eab1>] do_softirq+0x22/0x26
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c0129f49>] bit_waitqueue+0x20/0x47
 [<c0129f1e>] wake_up_bit+0xb/0x16
 [<c015c2ab>] dispose_list+0x88/0xa4
 [<c015c4fc>] prune_icache+0x136/0x148
 [<c015c522>] shrink_icache_memory+0x14/0x2b
 [<c013bdf4>] shrink_slab+0x135/0x18e
 [<c013cdcb>] balance_pgdat+0x1e6/0x2eb
 [<c013cfc5>] kswapd+0xf5/0xf7
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c011841f>] __wake_up_common+0x35/0x56
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c013ced0>] kswapd+0x0/0xf7
 [<c0129bcc>] kthread+0x72/0x97
 [<c0129b5a>] kthread+0x0/0x97
 [<c010467b>] kernel_thread_helper+0x7/0x10
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15
usd:   2
HighMem per-cpu:
CPU    0: Hot: hi:   42, btch:   7 usd:  40   Cold: hi:   14, btch:   3
usd:   2
Active:171834 inactive:59703 dirty:846 writeback:0 unstable:0 free:2311
slab:20911 mapped:4658 pagetables:765
DMA free:3536kB min:68kB low:84kB high:100kB active:5152kB
inactive:1232kB present:16256kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 873 1000
Normal free:5448kB min:3744kB low:4680kB high:5616kB active:569208kB
inactive:228308kB present:894080kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1015
HighMem free:260kB min:128kB low:264kB high:400kB active:112976kB
inactive:9272kB present:129988kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 40*4kB 36*8kB 15*16kB 1*32kB 0*64kB 0*128kB 1*256kB 1*512kB
0*1024kB 1*2048kB 0*4096kB = 3536kB
Normal: 152*4kB 491*8kB 45*16kB 0*32kB 1*64kB 1*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 5448kB
HighMem: 1*4kB 18*8kB 1*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 260kB
Swap cache: add 132, delete 132, find 0/0, race 0+0
Free swap  = 16064704kB
Total swap = 16064704kB
Free swap:       16064704kB
262128 pages of RAM
32752 pages of HIGHMEM
3672 reserved pages
82110 pages shared
0 pages swap cached
846 pages dirty
0 pages writeback
4658 pages mapped
20911 pages slab
765 pages pagetables
kswapd0: page allocation failure. order:3, mode:0x20
 [<c01394bc>] __alloc_pages+0x28e/0x29d
 [<c014a720>] kmem_getpages+0x34/0x9a
 [<c014b22d>] cache_grow+0x9d/0x12b
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c011bde4>] profile_tick+0x39/0x53
 [<c014b3f3>] cache_alloc_refill+0x138/0x170
 [<c014b6e9>] __kmalloc+0x62/0x70
 [<c036b638>] __alloc_skb+0x42/0xed
 [<c036b7cf>] __netdev_alloc_skb+0x1a/0x33
 [<f9039fd3>] e1000_alloc_rx_buffers+0xbb/0x299 [e1000]
 [<f90399a4>] e1000_clean_rx_irq+0x38e/0x425 [e1000]
 [<f90392f4>] e1000_intr+0xb9/0x109 [e1000]
 [<c013417d>] handle_IRQ_event+0x1a/0x3f
 [<c0134d3f>] handle_level_irq+0x66/0xa0
 [<c0105c1d>] do_IRQ+0x5d/0x74
 [<c0137f97>] mempool_free+0x48/0x4c
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c036c63a>] skb_copy_bits+0x51/0x243
 [<c01390c4>] buffered_rmqueue+0xbe/0xd7
 [<c036b9a3>] __kfree_skb+0x9b/0xc5
 [<c03a10a4>] tcp_collapse+0x268/0x2f4
 [<c03a124d>] tcp_prune_queue+0x96/0x144
 [<c03a098f>] tcp_data_queue+0x19e/0x64b
 [<c03a1bec>] tcp_rcv_established+0x51c/0x574
 [<c03a8379>] tcp_v4_do_rcv+0x22/0xb7
 [<c03a8832>] tcp_v4_rcv+0x424/0x6c9
 [<c03ab12c>] raw_rcv_skb+0x15/0x1e
 [<c0391809>] ip_local_deliver+0x14f/0x1d4
 [<c0391c80>] ip_local_deliver_finish+0x0/0x151
 [<c0391c4e>] ip_rcv+0x3c0/0x3f2
 [<c0391dd1>] ip_rcv_finish+0x0/0x1fb
 [<f9039a1d>] e1000_clean_rx_irq+0x407/0x425 [e1000]
 [<c0370cfc>] netif_receive_skb+0x1e5/0x1fb
 [<c0370d81>] process_backlog+0x6f/0xd2
 [<c0370e5a>] net_rx_action+0x76/0x106
 [<c011ea51>] __do_softirq+0x35/0x73
 [<c011eab1>] do_softirq+0x22/0x26
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c0129f49>] bit_waitqueue+0x20/0x47
 [<c0129f1e>] wake_up_bit+0xb/0x16
 [<c015c2ab>] dispose_list+0x88/0xa4
 [<c015c4fc>] prune_icache+0x136/0x148
 [<c015c522>] shrink_icache_memory+0x14/0x2b
 [<c013bdf4>] shrink_slab+0x135/0x18e
 [<c013cdcb>] balance_pgdat+0x1e6/0x2eb
 [<c013cfc5>] kswapd+0xf5/0xf7
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c011841f>] __wake_up_common+0x35/0x56
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c013ced0>] kswapd+0x0/0xf7
 [<c0129bcc>] kthread+0x72/0x97
 [<c0129b5a>] kthread+0x0/0x97
 [<c010467b>] kernel_thread_helper+0x7/0x10
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15
usd:   2
HighMem per-cpu:
CPU    0: Hot: hi:   42, btch:   7 usd:  40   Cold: hi:   14, btch:   3
usd:   2
Active:171834 inactive:59703 dirty:846 writeback:0 unstable:0 free:2311
slab:20911 mapped:4658 pagetables:765
DMA free:3536kB min:68kB low:84kB high:100kB active:5152kB
inactive:1232kB present:16256kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 873 1000
Normal free:5448kB min:3744kB low:4680kB high:5616kB active:569208kB
inactive:228308kB present:894080kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1015
HighMem free:260kB min:128kB low:264kB high:400kB active:112976kB
inactive:9272kB present:129988kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 40*4kB 36*8kB 15*16kB 1*32kB 0*64kB 0*128kB 1*256kB 1*512kB
0*1024kB 1*2048kB 0*4096kB = 3536kB
Normal: 152*4kB 491*8kB 45*16kB 0*32kB 1*64kB 1*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 5448kB
HighMem: 1*4kB 18*8kB 1*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 260kB
Swap cache: add 132, delete 132, find 0/0, race 0+0
Free swap  = 16064704kB
Total swap = 16064704kB
Free swap:       16064704kB
262128 pages of RAM
32752 pages of HIGHMEM
3672 reserved pages
82110 pages shared
0 pages swap cached
846 pages dirty
0 pages writeback
4658 pages mapped
20911 pages slab
765 pages pagetables
kswapd0: page allocation failure. order:3, mode:0x20
 [<c01394bc>] __alloc_pages+0x28e/0x29d
 [<c014a720>] kmem_getpages+0x34/0x9a
 [<c014b22d>] cache_grow+0x9d/0x12b
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c011bde4>] profile_tick+0x39/0x53
 [<c014b3f3>] cache_alloc_refill+0x138/0x170
 [<c014b6e9>] __kmalloc+0x62/0x70
 [<c036b638>] __alloc_skb+0x42/0xed
 [<c036b7cf>] __netdev_alloc_skb+0x1a/0x33
 [<f9039fd3>] e1000_alloc_rx_buffers+0xbb/0x299 [e1000]
 [<f90399a4>] e1000_clean_rx_irq+0x38e/0x425 [e1000]
 [<f90392f4>] e1000_intr+0xb9/0x109 [e1000]
 [<c013417d>] handle_IRQ_event+0x1a/0x3f
 [<c0134d3f>] handle_level_irq+0x66/0xa0
 [<c0105c1d>] do_IRQ+0x5d/0x74
 [<c0137f97>] mempool_free+0x48/0x4c
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c036c63a>] skb_copy_bits+0x51/0x243
 [<c01390c4>] buffered_rmqueue+0xbe/0xd7
 [<c036b9a3>] __kfree_skb+0x9b/0xc5
 [<c03a10a4>] tcp_collapse+0x268/0x2f4
 [<c03a124d>] tcp_prune_queue+0x96/0x144
 [<c03a098f>] tcp_data_queue+0x19e/0x64b
 [<c03a1bec>] tcp_rcv_established+0x51c/0x574
 [<c03a8379>] tcp_v4_do_rcv+0x22/0xb7
 [<c03a8832>] tcp_v4_rcv+0x424/0x6c9
 [<c03ab12c>] raw_rcv_skb+0x15/0x1e
 [<c0391809>] ip_local_deliver+0x14f/0x1d4
 [<c0391c80>] ip_local_deliver_finish+0x0/0x151
 [<c0391c4e>] ip_rcv+0x3c0/0x3f2
 [<c0391dd1>] ip_rcv_finish+0x0/0x1fb
 [<f9039a1d>] e1000_clean_rx_irq+0x407/0x425 [e1000]
 [<c0370cfc>] netif_receive_skb+0x1e5/0x1fb
 [<c0370d81>] process_backlog+0x6f/0xd2
 [<c0370e5a>] net_rx_action+0x76/0x106
 [<c011ea51>] __do_softirq+0x35/0x73
 [<c011eab1>] do_softirq+0x22/0x26
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c0129f49>] bit_waitqueue+0x20/0x47
 [<c0129f1e>] wake_up_bit+0xb/0x16
 [<c015c2ab>] dispose_list+0x88/0xa4
 [<c015c4fc>] prune_icache+0x136/0x148
 [<c015c522>] shrink_icache_memory+0x14/0x2b
 [<c013bdf4>] shrink_slab+0x135/0x18e
 [<c013cdcb>] balance_pgdat+0x1e6/0x2eb
 [<c013cfc5>] kswapd+0xf5/0xf7
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c011841f>] __wake_up_common+0x35/0x56
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c013ced0>] kswapd+0x0/0xf7
 [<c0129bcc>] kthread+0x72/0x97
 [<c0129b5a>] kthread+0x0/0x97
 [<c010467b>] kernel_thread_helper+0x7/0x10
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15
usd:   2
HighMem per-cpu:
CPU    0: Hot: hi:   42, btch:   7 usd:  40   Cold: hi:   14, btch:   3
usd:   2
Active:171834 inactive:59703 dirty:846 writeback:0 unstable:0 free:2311
slab:20911 mapped:4658 pagetables:765
DMA free:3536kB min:68kB low:84kB high:100kB active:5152kB
inactive:1232kB present:16256kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 873 1000
Normal free:5448kB min:3744kB low:4680kB high:5616kB active:569208kB
inactive:228308kB present:894080kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1015
HighMem free:260kB min:128kB low:264kB high:400kB active:112976kB
inactive:9272kB present:129988kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 40*4kB 36*8kB 15*16kB 1*32kB 0*64kB 0*128kB 1*256kB 1*512kB
0*1024kB 1*2048kB 0*4096kB = 3536kB
Normal: 152*4kB 491*8kB 45*16kB 0*32kB 1*64kB 1*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 5448kB
HighMem: 1*4kB 18*8kB 1*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 260kB
Swap cache: add 132, delete 132, find 0/0, race 0+0
Free swap  = 16064704kB
Total swap = 16064704kB
Free swap:       16064704kB
262128 pages of RAM
32752 pages of HIGHMEM
3672 reserved pages
82110 pages shared
0 pages swap cached
846 pages dirty
0 pages writeback
4658 pages mapped
20911 pages slab
765 pages pagetables
kswapd0: page allocation failure. order:3, mode:0x20
 [<c01394bc>] __alloc_pages+0x28e/0x29d
 [<c014a720>] kmem_getpages+0x34/0x9a
 [<c014b22d>] cache_grow+0x9d/0x12b
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c011bde4>] profile_tick+0x39/0x53
 [<c014b3f3>] cache_alloc_refill+0x138/0x170
 [<c014b6e9>] __kmalloc+0x62/0x70
 [<c036b638>] __alloc_skb+0x42/0xed
 [<c036b7cf>] __netdev_alloc_skb+0x1a/0x33
 [<f9039fd3>] e1000_alloc_rx_buffers+0xbb/0x299 [e1000]
 [<f90399a4>] e1000_clean_rx_irq+0x38e/0x425 [e1000]
 [<f90392f4>] e1000_intr+0xb9/0x109 [e1000]
 [<c013417d>] handle_IRQ_event+0x1a/0x3f
 [<c0134d3f>] handle_level_irq+0x66/0xa0
 [<c0105c1d>] do_IRQ+0x5d/0x74
 [<c0137f97>] mempool_free+0x48/0x4c
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c036c63a>] skb_copy_bits+0x51/0x243
 [<c01390c4>] buffered_rmqueue+0xbe/0xd7
 [<c036b9a3>] __kfree_skb+0x9b/0xc5
 [<c03a10a4>] tcp_collapse+0x268/0x2f4
 [<c03a124d>] tcp_prune_queue+0x96/0x144
 [<c03a098f>] tcp_data_queue+0x19e/0x64b
 [<c03a1bec>] tcp_rcv_established+0x51c/0x574
 [<c03a8379>] tcp_v4_do_rcv+0x22/0xb7
 [<c03a8832>] tcp_v4_rcv+0x424/0x6c9
 [<c03ab12c>] raw_rcv_skb+0x15/0x1e
 [<c0391809>] ip_local_deliver+0x14f/0x1d4
 [<c0391c80>] ip_local_deliver_finish+0x0/0x151
 [<c0391c4e>] ip_rcv+0x3c0/0x3f2
 [<c0391dd1>] ip_rcv_finish+0x0/0x1fb
 [<f9039a1d>] e1000_clean_rx_irq+0x407/0x425 [e1000]
 [<c0370cfc>] netif_receive_skb+0x1e5/0x1fb
 [<c0370d81>] process_backlog+0x6f/0xd2
 [<c0370e5a>] net_rx_action+0x76/0x106
 [<c011ea51>] __do_softirq+0x35/0x73
 [<c011eab1>] do_softirq+0x22/0x26
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c0129f49>] bit_waitqueue+0x20/0x47
 [<c0129f1e>] wake_up_bit+0xb/0x16
 [<c015c2ab>] dispose_list+0x88/0xa4
 [<c015c4fc>] prune_icache+0x136/0x148
 [<c015c522>] shrink_icache_memory+0x14/0x2b
 [<c013bdf4>] shrink_slab+0x135/0x18e
 [<c013cdcb>] balance_pgdat+0x1e6/0x2eb
 [<c013cfc5>] kswapd+0xf5/0xf7
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c011841f>] __wake_up_common+0x35/0x56
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c013ced0>] kswapd+0x0/0xf7
 [<c0129bcc>] kthread+0x72/0x97
 [<c0129b5a>] kthread+0x0/0x97
 [<c010467b>] kernel_thread_helper+0x7/0x10
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15
usd:   2
HighMem per-cpu:
CPU    0: Hot: hi:   42, btch:   7 usd:  40   Cold: hi:   14, btch:   3
usd:   2
Active:171834 inactive:59703 dirty:846 writeback:0 unstable:0 free:2311
slab:20911 mapped:4658 pagetables:765
DMA free:3536kB min:68kB low:84kB high:100kB active:5152kB
inactive:1232kB present:16256kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 873 1000
Normal free:5448kB min:3744kB low:4680kB high:5616kB active:569208kB
inactive:228308kB present:894080kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1015
HighMem free:260kB min:128kB low:264kB high:400kB active:112976kB
inactive:9272kB present:129988kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 40*4kB 36*8kB 15*16kB 1*32kB 0*64kB 0*128kB 1*256kB 1*512kB
0*1024kB 1*2048kB 0*4096kB = 3536kB
Normal: 152*4kB 491*8kB 45*16kB 0*32kB 1*64kB 1*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 5448kB
HighMem: 1*4kB 18*8kB 1*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 260kB
Swap cache: add 132, delete 132, find 0/0, race 0+0
Free swap  = 16064704kB
Total swap = 16064704kB
Free swap:       16064704kB
262128 pages of RAM
32752 pages of HIGHMEM
3672 reserved pages
82110 pages shared
0 pages swap cached
846 pages dirty
0 pages writeback
4658 pages mapped
20911 pages slab
765 pages pagetables
kswapd0: page allocation failure. order:3, mode:0x20
 [<c01394bc>] __alloc_pages+0x28e/0x29d
 [<c014a720>] kmem_getpages+0x34/0x9a
 [<c014b22d>] cache_grow+0x9d/0x12b
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c011bde4>] profile_tick+0x39/0x53
 [<c014b3f3>] cache_alloc_refill+0x138/0x170
 [<c014b6e9>] __kmalloc+0x62/0x70
 [<c036b638>] __alloc_skb+0x42/0xed
 [<c036b7cf>] __netdev_alloc_skb+0x1a/0x33
 [<f9039fd3>] e1000_alloc_rx_buffers+0xbb/0x299 [e1000]
 [<f9039a1d>] e1000_clean_rx_irq+0x407/0x425 [e1000]
 [<f90392f4>] e1000_intr+0xb9/0x109 [e1000]
 [<c013417d>] handle_IRQ_event+0x1a/0x3f
 [<c0134d3f>] handle_level_irq+0x66/0xa0
 [<c0105c1d>] do_IRQ+0x5d/0x74
 [<c0137f97>] mempool_free+0x48/0x4c
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c036c63a>] skb_copy_bits+0x51/0x243
 [<c01390c4>] buffered_rmqueue+0xbe/0xd7
 [<c036b9a3>] __kfree_skb+0x9b/0xc5
 [<c03a10a4>] tcp_collapse+0x268/0x2f4
 [<c03a124d>] tcp_prune_queue+0x96/0x144
 [<c03a098f>] tcp_data_queue+0x19e/0x64b
 [<c03a1bec>] tcp_rcv_established+0x51c/0x574
 [<c03a8379>] tcp_v4_do_rcv+0x22/0xb7
 [<c03a8832>] tcp_v4_rcv+0x424/0x6c9
 [<c03ab12c>] raw_rcv_skb+0x15/0x1e
 [<c0391809>] ip_local_deliver+0x14f/0x1d4
 [<c0391c80>] ip_local_deliver_finish+0x0/0x151
 [<c0391c4e>] ip_rcv+0x3c0/0x3f2
 [<c0391dd1>] ip_rcv_finish+0x0/0x1fb
 [<f9039a1d>] e1000_clean_rx_irq+0x407/0x425 [e1000]
 [<c0370cfc>] netif_receive_skb+0x1e5/0x1fb
 [<c0370d81>] process_backlog+0x6f/0xd2
 [<c0370e5a>] net_rx_action+0x76/0x106
 [<c011ea51>] __do_softirq+0x35/0x73
 [<c011eab1>] do_softirq+0x22/0x26
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c0129f49>] bit_waitqueue+0x20/0x47
 [<c0129f1e>] wake_up_bit+0xb/0x16
 [<c015c2ab>] dispose_list+0x88/0xa4
 [<c015c4fc>] prune_icache+0x136/0x148
 [<c015c522>] shrink_icache_memory+0x14/0x2b
 [<c013bdf4>] shrink_slab+0x135/0x18e
 [<c013cdcb>] balance_pgdat+0x1e6/0x2eb
 [<c013cfc5>] kswapd+0xf5/0xf7
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c011841f>] __wake_up_common+0x35/0x56
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c013ced0>] kswapd+0x0/0xf7
 [<c0129bcc>] kthread+0x72/0x97
 [<c0129b5a>] kthread+0x0/0x97
 [<c010467b>] kernel_thread_helper+0x7/0x10
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15
usd:   2
HighMem per-cpu:
CPU    0: Hot: hi:   42, btch:   7 usd:  40   Cold: hi:   14, btch:   3
usd:   2
Active:171834 inactive:59703 dirty:846 writeback:0 unstable:0 free:2311
slab:20911 mapped:4658 pagetables:765
DMA free:3536kB min:68kB low:84kB high:100kB active:5152kB
inactive:1232kB present:16256kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 873 1000
Normal free:5448kB min:3744kB low:4680kB high:5616kB active:569208kB
inactive:228308kB present:894080kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1015
HighMem free:260kB min:128kB low:264kB high:400kB active:112976kB
inactive:9272kB present:129988kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 40*4kB 36*8kB 15*16kB 1*32kB 0*64kB 0*128kB 1*256kB 1*512kB
0*1024kB 1*2048kB 0*4096kB = 3536kB
Normal: 152*4kB 491*8kB 45*16kB 0*32kB 1*64kB 1*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 5448kB
HighMem: 1*4kB 18*8kB 1*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 260kB
Swap cache: add 132, delete 132, find 0/0, race 0+0
Free swap  = 16064704kB
Total swap = 16064704kB
Free swap:       16064704kB
262128 pages of RAM
32752 pages of HIGHMEM
3672 reserved pages
82110 pages shared
0 pages swap cached
846 pages dirty
0 pages writeback
4658 pages mapped
20911 pages slab
765 pages pagetables
kswapd0: page allocation failure. order:3, mode:0x20
 [<c01394bc>] __alloc_pages+0x28e/0x29d
 [<c014a720>] kmem_getpages+0x34/0x9a
 [<c014b22d>] cache_grow+0x9d/0x12b
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c011bde4>] profile_tick+0x39/0x53
 [<c014b3f3>] cache_alloc_refill+0x138/0x170
 [<c014b6e9>] __kmalloc+0x62/0x70
 [<c036b638>] __alloc_skb+0x42/0xed
 [<c036b7cf>] __netdev_alloc_skb+0x1a/0x33
 [<f9039fd3>] e1000_alloc_rx_buffers+0xbb/0x299 [e1000]
 [<f9039a1d>] e1000_clean_rx_irq+0x407/0x425 [e1000]
 [<f90392f4>] e1000_intr+0xb9/0x109 [e1000]
 [<c013417d>] handle_IRQ_event+0x1a/0x3f
 [<c0134d3f>] handle_level_irq+0x66/0xa0
 [<c0105c1d>] do_IRQ+0x5d/0x74
 [<c0137f97>] mempool_free+0x48/0x4c
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c036c63a>] skb_copy_bits+0x51/0x243
 [<c01390c4>] buffered_rmqueue+0xbe/0xd7
 [<c036b9a3>] __kfree_skb+0x9b/0xc5
 [<c03a10a4>] tcp_collapse+0x268/0x2f4
 [<c03a124d>] tcp_prune_queue+0x96/0x144
 [<c03a098f>] tcp_data_queue+0x19e/0x64b
 [<c03a1bec>] tcp_rcv_established+0x51c/0x574
 [<c03a8379>] tcp_v4_do_rcv+0x22/0xb7
 [<c03a8832>] tcp_v4_rcv+0x424/0x6c9
 [<c03ab12c>] raw_rcv_skb+0x15/0x1e
 [<c0391809>] ip_local_deliver+0x14f/0x1d4
 [<c0391c80>] ip_local_deliver_finish+0x0/0x151
 [<c0391c4e>] ip_rcv+0x3c0/0x3f2
 [<c0391dd1>] ip_rcv_finish+0x0/0x1fb
 [<f9039a1d>] e1000_clean_rx_irq+0x407/0x425 [e1000]
 [<c0370cfc>] netif_receive_skb+0x1e5/0x1fb
 [<c0370d81>] process_backlog+0x6f/0xd2
 [<c0370e5a>] net_rx_action+0x76/0x106
 [<c011ea51>] __do_softirq+0x35/0x73
 [<c011eab1>] do_softirq+0x22/0x26
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c0129f49>] bit_waitqueue+0x20/0x47
 [<c0129f1e>] wake_up_bit+0xb/0x16
 [<c015c2ab>] dispose_list+0x88/0xa4
 [<c015c4fc>] prune_icache+0x136/0x148
 [<c015c522>] shrink_icache_memory+0x14/0x2b
 [<c013bdf4>] shrink_slab+0x135/0x18e
 [<c013cdcb>] balance_pgdat+0x1e6/0x2eb
 [<c013cfc5>] kswapd+0xf5/0xf7
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c011841f>] __wake_up_common+0x35/0x56
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c013ced0>] kswapd+0x0/0xf7
 [<c0129bcc>] kthread+0x72/0x97
 [<c0129b5a>] kthread+0x0/0x97
 [<c010467b>] kernel_thread_helper+0x7/0x10
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15
usd:   2
HighMem per-cpu:
CPU    0: Hot: hi:   42, btch:   7 usd:  40   Cold: hi:   14, btch:   3
usd:   2
Active:171834 inactive:59703 dirty:846 writeback:0 unstable:0 free:2311
slab:20911 mapped:4658 pagetables:765
DMA free:3536kB min:68kB low:84kB high:100kB active:5152kB
inactive:1232kB present:16256kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 873 1000
Normal free:5448kB min:3744kB low:4680kB high:5616kB active:569208kB
inactive:228308kB present:894080kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1015
HighMem free:260kB min:128kB low:264kB high:400kB active:112976kB
inactive:9272kB present:129988kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 40*4kB 36*8kB 15*16kB 1*32kB 0*64kB 0*128kB 1*256kB 1*512kB
0*1024kB 1*2048kB 0*4096kB = 3536kB
Normal: 152*4kB 491*8kB 45*16kB 0*32kB 1*64kB 1*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 5448kB
HighMem: 1*4kB 18*8kB 1*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 260kB
Swap cache: add 132, delete 132, find 0/0, race 0+0
Free swap  = 16064704kB
Total swap = 16064704kB
Free swap:       16064704kB
262128 pages of RAM
32752 pages of HIGHMEM
3672 reserved pages
82110 pages shared
0 pages swap cached
846 pages dirty
0 pages writeback
4658 pages mapped
20911 pages slab
765 pages pagetables
kswapd0: page allocation failure. order:3, mode:0x20
 [<c01394bc>] __alloc_pages+0x28e/0x29d
 [<c014a720>] kmem_getpages+0x34/0x9a
 [<c014b22d>] cache_grow+0x9d/0x12b
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c011bde4>] profile_tick+0x39/0x53
 [<c014b3f3>] cache_alloc_refill+0x138/0x170
 [<c014b6e9>] __kmalloc+0x62/0x70
 [<c036b638>] __alloc_skb+0x42/0xed
 [<c036b7cf>] __netdev_alloc_skb+0x1a/0x33
 [<f9039fd3>] e1000_alloc_rx_buffers+0xbb/0x299 [e1000]
 [<f9039a1d>] e1000_clean_rx_irq+0x407/0x425 [e1000]
 [<f90392f4>] e1000_intr+0xb9/0x109 [e1000]
 [<c013417d>] handle_IRQ_event+0x1a/0x3f
 [<c0134d3f>] handle_level_irq+0x66/0xa0
 [<c0105c1d>] do_IRQ+0x5d/0x74
 [<c0137f97>] mempool_free+0x48/0x4c
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c036c63a>] skb_copy_bits+0x51/0x243
 [<c01390c4>] buffered_rmqueue+0xbe/0xd7
 [<c036b9a3>] __kfree_skb+0x9b/0xc5
 [<c03a10a4>] tcp_collapse+0x268/0x2f4
 [<c03a124d>] tcp_prune_queue+0x96/0x144
 [<c03a098f>] tcp_data_queue+0x19e/0x64b
 [<c03a1bec>] tcp_rcv_established+0x51c/0x574
 [<c03a8379>] tcp_v4_do_rcv+0x22/0xb7
 [<c03a8832>] tcp_v4_rcv+0x424/0x6c9
 [<c03ab12c>] raw_rcv_skb+0x15/0x1e
 [<c0391809>] ip_local_deliver+0x14f/0x1d4
 [<c0391c80>] ip_local_deliver_finish+0x0/0x151
 [<c0391c4e>] ip_rcv+0x3c0/0x3f2
 [<c0391dd1>] ip_rcv_finish+0x0/0x1fb
 [<f9039a1d>] e1000_clean_rx_irq+0x407/0x425 [e1000]
 [<c0370cfc>] netif_receive_skb+0x1e5/0x1fb
 [<c0370d81>] process_backlog+0x6f/0xd2
 [<c0370e5a>] net_rx_action+0x76/0x106
 [<c011ea51>] __do_softirq+0x35/0x73
 [<c011eab1>] do_softirq+0x22/0x26
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c0129f49>] bit_waitqueue+0x20/0x47
 [<c0129f1e>] wake_up_bit+0xb/0x16
 [<c015c2ab>] dispose_list+0x88/0xa4
 [<c015c4fc>] prune_icache+0x136/0x148
 [<c015c522>] shrink_icache_memory+0x14/0x2b
 [<c013bdf4>] shrink_slab+0x135/0x18e
 [<c013cdcb>] balance_pgdat+0x1e6/0x2eb
 [<c013cfc5>] kswapd+0xf5/0xf7
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c011841f>] __wake_up_common+0x35/0x56
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c013ced0>] kswapd+0x0/0xf7
 [<c0129bcc>] kthread+0x72/0x97
 [<c0129b5a>] kthread+0x0/0x97
 [<c010467b>] kernel_thread_helper+0x7/0x10
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15
usd:   2
HighMem per-cpu:
CPU    0: Hot: hi:   42, btch:   7 usd:  40   Cold: hi:   14, btch:   3
usd:   2
Active:171834 inactive:59703 dirty:846 writeback:0 unstable:0 free:2311
slab:20911 mapped:4658 pagetables:765
DMA free:3536kB min:68kB low:84kB high:100kB active:5152kB
inactive:1232kB present:16256kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 873 1000
Normal free:5448kB min:3744kB low:4680kB high:5616kB active:569208kB
inactive:228308kB present:894080kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1015
HighMem free:260kB min:128kB low:264kB high:400kB active:112976kB
inactive:9272kB present:129988kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 40*4kB 36*8kB 15*16kB 1*32kB 0*64kB 0*128kB 1*256kB 1*512kB
0*1024kB 1*2048kB 0*4096kB = 3536kB
Normal: 152*4kB 491*8kB 45*16kB 0*32kB 1*64kB 1*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 5448kB
HighMem: 1*4kB 18*8kB 1*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 260kB
Swap cache: add 132, delete 132, find 0/0, race 0+0
Free swap  = 16064704kB
Total swap = 16064704kB
Free swap:       16064704kB
262128 pages of RAM
32752 pages of HIGHMEM
3672 reserved pages
82110 pages shared
0 pages swap cached
846 pages dirty
0 pages writeback
4658 pages mapped
20911 pages slab
765 pages pagetables
kswapd0: page allocation failure. order:3, mode:0x20
 [<c01394bc>] __alloc_pages+0x28e/0x29d
 [<c014a720>] kmem_getpages+0x34/0x9a
 [<c014b22d>] cache_grow+0x9d/0x12b
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c011bde4>] profile_tick+0x39/0x53
 [<c014b3f3>] cache_alloc_refill+0x138/0x170
 [<c014b6e9>] __kmalloc+0x62/0x70
 [<c036b638>] __alloc_skb+0x42/0xed
 [<c036b7cf>] __netdev_alloc_skb+0x1a/0x33
 [<f9039fd3>] e1000_alloc_rx_buffers+0xbb/0x299 [e1000]
 [<f9039a1d>] e1000_clean_rx_irq+0x407/0x425 [e1000]
 [<f90392f4>] e1000_intr+0xb9/0x109 [e1000]
 [<c013417d>] handle_IRQ_event+0x1a/0x3f
 [<c0134d3f>] handle_level_irq+0x66/0xa0
 [<c0105c1d>] do_IRQ+0x5d/0x74
 [<c0137f97>] mempool_free+0x48/0x4c
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c036c63a>] skb_copy_bits+0x51/0x243
 [<c01390c4>] buffered_rmqueue+0xbe/0xd7
 [<c036b9a3>] __kfree_skb+0x9b/0xc5
 [<c03a10a4>] tcp_collapse+0x268/0x2f4
 [<c03a124d>] tcp_prune_queue+0x96/0x144
 [<c03a098f>] tcp_data_queue+0x19e/0x64b
 [<c03a1bec>] tcp_rcv_established+0x51c/0x574
 [<c03a8379>] tcp_v4_do_rcv+0x22/0xb7
 [<c03a8832>] tcp_v4_rcv+0x424/0x6c9
 [<c03ab12c>] raw_rcv_skb+0x15/0x1e
 [<c0391809>] ip_local_deliver+0x14f/0x1d4
 [<c0391c80>] ip_local_deliver_finish+0x0/0x151
 [<c0391c4e>] ip_rcv+0x3c0/0x3f2
 [<c0391dd1>] ip_rcv_finish+0x0/0x1fb
 [<f9039a1d>] e1000_clean_rx_irq+0x407/0x425 [e1000]
 [<c0370cfc>] netif_receive_skb+0x1e5/0x1fb
 [<c0370d81>] process_backlog+0x6f/0xd2
 [<c0370e5a>] net_rx_action+0x76/0x106
 [<c011ea51>] __do_softirq+0x35/0x73
 [<c011eab1>] do_softirq+0x22/0x26
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c0129f49>] bit_waitqueue+0x20/0x47
 [<c0129f1e>] wake_up_bit+0xb/0x16
 [<c015c2ab>] dispose_list+0x88/0xa4
 [<c015c4fc>] prune_icache+0x136/0x148
 [<c015c522>] shrink_icache_memory+0x14/0x2b
 [<c013bdf4>] shrink_slab+0x135/0x18e
 [<c013cdcb>] balance_pgdat+0x1e6/0x2eb
 [<c013cfc5>] kswapd+0xf5/0xf7
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c011841f>] __wake_up_common+0x35/0x56
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c013ced0>] kswapd+0x0/0xf7
 [<c0129bcc>] kthread+0x72/0x97
 [<c0129b5a>] kthread+0x0/0x97
 [<c010467b>] kernel_thread_helper+0x7/0x10
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15
usd:   2
HighMem per-cpu:
CPU    0: Hot: hi:   42, btch:   7 usd:  40   Cold: hi:   14, btch:   3
usd:   2
Active:171834 inactive:59703 dirty:846 writeback:0 unstable:0 free:2311
slab:20911 mapped:4658 pagetables:765
DMA free:3536kB min:68kB low:84kB high:100kB active:5152kB
inactive:1232kB present:16256kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 873 1000
Normal free:5448kB min:3744kB low:4680kB high:5616kB active:569208kB
inactive:228308kB present:894080kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1015
HighMem free:260kB min:128kB low:264kB high:400kB active:112976kB
inactive:9272kB present:129988kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 40*4kB 36*8kB 15*16kB 1*32kB 0*64kB 0*128kB 1*256kB 1*512kB
0*1024kB 1*2048kB 0*4096kB = 3536kB
Normal: 152*4kB 491*8kB 45*16kB 0*32kB 1*64kB 1*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 5448kB
HighMem: 1*4kB 18*8kB 1*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 260kB
Swap cache: add 132, delete 132, find 0/0, race 0+0
Free swap  = 16064704kB
Total swap = 16064704kB
Free swap:       16064704kB
262128 pages of RAM
32752 pages of HIGHMEM
3672 reserved pages
82110 pages shared
0 pages swap cached
846 pages dirty
0 pages writeback
4658 pages mapped
20911 pages slab
765 pages pagetables
kswapd0: page allocation failure. order:3, mode:0x20
 [<c01394bc>] __alloc_pages+0x28e/0x29d
 [<c014a720>] kmem_getpages+0x34/0x9a
 [<c014b22d>] cache_grow+0x9d/0x12b
 [<c014b3f3>] cache_alloc_refill+0x138/0x170
 [<c014b6e9>] __kmalloc+0x62/0x70
 [<c036b638>] __alloc_skb+0x42/0xed
 [<c036b7cf>] __netdev_alloc_skb+0x1a/0x33
 [<f9039fd3>] e1000_alloc_rx_buffers+0xbb/0x299 [e1000]
 [<f9039a1d>] e1000_clean_rx_irq+0x407/0x425 [e1000]
 [<f90392f4>] e1000_intr+0xb9/0x109 [e1000]
 [<c013417d>] handle_IRQ_event+0x1a/0x3f
 [<c0134d3f>] handle_level_irq+0x66/0xa0
 [<c0105c1d>] do_IRQ+0x5d/0x74
 [<c036c63a>] skb_copy_bits+0x51/0x243
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c03a10a6>] tcp_collapse+0x26a/0x2f4
 [<c03a124d>] tcp_prune_queue+0x96/0x144
 [<c03a098f>] tcp_data_queue+0x19e/0x64b
 [<c03a1bec>] tcp_rcv_established+0x51c/0x574
 [<c03a8379>] tcp_v4_do_rcv+0x22/0xb7
 [<c03a8832>] tcp_v4_rcv+0x424/0x6c9
 [<c03ab12c>] raw_rcv_skb+0x15/0x1e
 [<c0391809>] ip_local_deliver+0x14f/0x1d4
 [<c0391c80>] ip_local_deliver_finish+0x0/0x151
 [<c0391c4e>] ip_rcv+0x3c0/0x3f2
 [<c0391dd1>] ip_rcv_finish+0x0/0x1fb
 [<f9039a1d>] e1000_clean_rx_irq+0x407/0x425 [e1000]
 [<c0370cfc>] netif_receive_skb+0x1e5/0x1fb
 [<c0370d81>] process_backlog+0x6f/0xd2
 [<c0370e5a>] net_rx_action+0x76/0x106
 [<c011ea51>] __do_softirq+0x35/0x73
 [<c011eab1>] do_softirq+0x22/0x26
 [<c0105c22>] do_IRQ+0x62/0x74
 [<c01044fb>] common_interrupt+0x23/0x28
 [<c0129f49>] bit_waitqueue+0x20/0x47
 [<c0129f1e>] wake_up_bit+0xb/0x16
 [<c015c2ab>] dispose_list+0x88/0xa4
 [<c015c4fc>] prune_icache+0x136/0x148
 [<c015c522>] shrink_icache_memory+0x14/0x2b
 [<c013bdf4>] shrink_slab+0x135/0x18e
 [<c013cdcb>] balance_pgdat+0x1e6/0x2eb
 [<c013cfc5>] kswapd+0xf5/0xf7
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c011841f>] __wake_up_common+0x35/0x56
 [<c0129e75>] autoremove_wake_function+0x0/0x33
 [<c013ced0>] kswapd+0x0/0xf7
 [<c0129bcc>] kthread+0x72/0x97
 [<c0129b5a>] kthread+0x0/0x97
 [<c010467b>] kernel_thread_helper+0x7/0x10
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15
usd:   2
HighMem per-cpu:
CPU    0: Hot: hi:   42, btch:   7 usd:  40   Cold: hi:   14, btch:   3
usd:   2
Active:171834 inactive:59703 dirty:846 writeback:0 unstable:0 free:2311
slab:20911 mapped:4658 pagetables:765
DMA free:3536kB min:68kB low:84kB high:100kB active:5152kB
inactive:1232kB present:16256kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 873 1000
Normal free:5448kB min:3744kB low:4680kB high:5616kB active:569208kB
inactive:228308kB present:894080kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 1015
HighMem free:260kB min:128kB low:264kB high:400kB active:112976kB
inactive:9272kB present:129988kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 40*4kB 36*8kB 15*16kB 1*32kB 0*64kB 0*128kB 1*256kB 1*512kB
0*1024kB 1*2048kB 0*4096kB = 3536kB
Normal: 152*4kB 491*8kB 45*16kB 0*32kB 1*64kB 1*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 5448kB
HighMem: 1*4kB 18*8kB 1*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 260kB
Swap cache: add 132, delete 132, find 0/0, race 0+0
Free swap  = 16064704kB
Total swap = 16064704kB
Free swap:       16064704kB
262128 pages of RAM
32752 pages of HIGHMEM
3672 reserved pages
82110 pages shared
0 pages swap cached
846 pages dirty
0 pages writeback
4658 pages mapped
20911 pages slab
765 pages pagetables

-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
