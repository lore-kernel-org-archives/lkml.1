Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbZLWPMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbZLWPMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 10:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbZLWPMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 10:12:48 -0500
Received: from lucidpixels.com ([75.144.35.66]:59520 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199AbZLWPMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 10:12:46 -0500
Date: Wed, 23 Dec 2009 10:12:45 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-net@vger.kernel.org
Subject: 2.6.31.6: (tg3) swapper: page allocation failure. order:0,
 mode:0x20
Message-ID: <alpine.DEB.2.00.0912231005530.18793@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Running 2.6.31.6 (never saw this issue with earlier kernels < 2.6.31):

Just upgraded to 2.6.32.2, not sure if this has been fixed yet, but FYI,
previously I had run ~2.6.26 for > 400 days without this occurring, as far 
as I can remember.

Is this a regression from 2.6.26?

[2407510.480755] udev: starting version 149
[2759231.946818] swapper: page allocation failure. order:0, mode:0x20
[2759231.946825] Pid: 0, comm: swapper Not tainted 2.6.31.6 #3
[2759231.946828] Call Trace:
[2759231.946840]  [<c1042d81>] ? __alloc_pages_nodemask+0x448/0x508
[2759231.946847]  [<c105b5e3>] ? cache_alloc_refill+0x244/0x472
[2759231.946851]  [<c105b8ab>] ? __kmalloc+0x9a/0x9e
[2759231.946858]  [<c12b037f>] ? __alloc_skb+0x46/0x112
[2759231.946861]  [<c12b0f25>] ? __netdev_alloc_skb+0x1c/0x37
[2759231.946867]  [<c122bb1f>] ? tg3_alloc_rx_skb+0x7d/0x16d
[2759231.946872]  [<c101158e>] ? ack_apic_level+0x3c/0x13c
[2759231.946876]  [<c12334ed>] ? tg3_poll+0x7db/0x9cb
[2759231.946882]  [<c12b600c>] ? net_rx_action+0x6c/0xe0
[2759231.946888]  [<c1020ba1>] ? __do_softirq+0x68/0xe1
[2759231.946891]  [<c1020c40>] ? do_softirq+0x26/0x28
[2759231.946896]  [<c10042b1>] ? do_IRQ+0x37/0x8c
[2759231.946900]  [<c1003f04>] ? do_nmi+0x140/0x299
[2759231.946903]  [<c1003029>] ? common_interrupt+0x29/0x30
[2759231.946908]  [<c1007ffa>] ? default_idle+0x36/0x42
[2759231.946911]  [<c1001c61>] ? cpu_idle+0x24/0x43
[2759231.946916]  [<c1449685>] ? start_kernel+0x219/0x252
[2759231.946919]  [<c1449242>] ? unknown_bootoption+0x0/0x1dc
[2759231.946922] Mem-Info:
[2759231.946924] DMA per-cpu:
[2759231.946926] CPU    0: hi:    0, btch:   1 usd:   0
[2759231.946928] Normal per-cpu:
[2759231.946930] CPU    0: hi:  186, btch:  31 usd: 191
[2759231.946932] HighMem per-cpu:
[2759231.946934] CPU    0: hi:   42, btch:   7 usd:   9
[2759231.946939] Active_anon:104889 active_file:12798 inactive_anon:105060
[2759231.946940]  inactive_file:14667 unevictable:0 dirty:5061 writeback:5028 unstable:0
[2759231.946942]  free:1280 slab:11596 mapped:5235 pagetables:2542 bounce:0
[2759231.946947] DMA free:3484kB min:64kB low:80kB high:96kB active_anon:3852kB inactive_anon:4216kB active_file:1768kB inactive_file:2056kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
[2759231.946951] lowmem_reserve[]: 0 865 992 992
[2759231.946957] Normal free:1384kB min:3728kB low:4660kB high:5592kB active_anon:361100kB inactive_anon:361072kB active_file:40744kB inactive_file:47380kB unevictable:0kB present:885944kB pages_scanned:64 all_unreclaimable? no
[2759231.946961] lowmem_reserve[]: 0 0 1015 1015
[2759231.946968] HighMem free:252kB min:128kB low:264kB high:400kB active_anon:54604kB inactive_anon:54952kB active_file:8680kB inactive_file:9232kB unevictable:0kB present:129992kB pages_scanned:0 all_unreclaimable? no
[2759231.946971] lowmem_reserve[]: 0 0 0 0
[2759231.946975] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3484kB
[2759231.946985] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1384kB
[2759231.946995] HighMem: 61*4kB 1*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 252kB
[2759231.947005] 34860 total pagecache pages
[2759231.947007] 1338 pages in swap cache
[2759231.947010] Swap cache stats: add 152965, delete 151627, find 13955964/13958438
[2759231.947012] Free swap  = 1691248kB
[2759231.947014] Total swap = 2192832kB
[2759231.947808] 260080 pages RAM
[2759231.947808] 32754 pages HighMem
[2759231.947808] 3509 pages reserved
[2759231.947808] 96118 pages shared
[2759231.947808] 220033 pages non-shared
[2759231.956819] swapper: page allocation failure. order:0, mode:0x20
[2759231.956824] Pid: 0, comm: swapper Not tainted 2.6.31.6 #3
[2759231.956827] Call Trace:
[2759231.956838]  [<c1042d81>] ? __alloc_pages_nodemask+0x448/0x508
[2759231.956844]  [<c102e576>] ? ktime_get_ts+0x21/0x44
[2759231.956851]  [<c105b5e3>] ? cache_alloc_refill+0x244/0x472
[2759231.956855]  [<c102f889>] ? sched_clock_tick+0x3c/0x111
[2759231.956859]  [<c105b8ab>] ? __kmalloc+0x9a/0x9e
[2759231.956865]  [<c12b037f>] ? __alloc_skb+0x46/0x112
[2759231.956868]  [<c12b0f25>] ? __netdev_alloc_skb+0x1c/0x37
[2759231.956874]  [<c122bb1f>] ? tg3_alloc_rx_skb+0x7d/0x16d
[2759231.956879]  [<c1004bdc>] ? timer_interrupt+0x24/0x38
[2759231.956883]  [<c103adb2>] ? handle_IRQ_event+0x2d/0xbb
[2759231.956887]  [<c12334ed>] ? tg3_poll+0x7db/0x9cb
[2759231.956892]  [<c12b600c>] ? net_rx_action+0x6c/0xe0
[2759231.956898]  [<c1020ba1>] ? __do_softirq+0x68/0xe1
[2759231.956901]  [<c103adcf>] ? handle_IRQ_event+0x4a/0xbb
[2759231.956904]  [<c102ed94>] ? notify_die+0x30/0x34
[2759231.956908]  [<c101158e>] ? ack_apic_level+0x3c/0x13c
[2759231.956912]  [<c1020c40>] ? do_softirq+0x26/0x28
[2759231.956915]  [<c10042b1>] ? do_IRQ+0x37/0x8c
[2759231.956918]  [<c1003f04>] ? do_nmi+0x140/0x299
[2759231.956922]  [<c1003029>] ? common_interrupt+0x29/0x30
[2759231.956926]  [<c1007ffa>] ? default_idle+0x36/0x42
[2759231.956929]  [<c1001c61>] ? cpu_idle+0x24/0x43
[2759231.956934]  [<c1449685>] ? start_kernel+0x219/0x252
[2759231.956937]  [<c1449242>] ? unknown_bootoption+0x0/0x1dc
[2759231.956939] Mem-Info:
[2759231.956941] DMA per-cpu:
[2759231.956943] CPU    0: hi:    0, btch:   1 usd:   0
[2759231.956945] Normal per-cpu:
[2759231.956947] CPU    0: hi:  186, btch:  31 usd: 191
[2759231.956949] HighMem per-cpu:
[2759231.956951] CPU    0: hi:   42, btch:   7 usd:   3
[2759231.956955] Active_anon:104889 active_file:12798 inactive_anon:105060
[2759231.956957]  inactive_file:14667 unevictable:0 dirty:5061 writeback:5028 unstable:0
[2759231.956958]  free:1280 slab:11596 mapped:5235 pagetables:2542 bounce:0
[2759231.956963] DMA free:3484kB min:64kB low:80kB high:96kB active_anon:3852kB inactive_anon:4216kB active_file:1768kB inactive_file:2056kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
[2759231.956967] lowmem_reserve[]: 0 865 992 992
[2759231.956973] Normal free:1384kB min:3728kB low:4660kB high:5592kB active_anon:361100kB inactive_anon:361072kB active_file:40744kB inactive_file:47380kB unevictable:0kB present:885944kB pages_scanned:64 all_unreclaimable? no
[2759231.956977] lowmem_reserve[]: 0 0 1015 1015
[2759231.956983] HighMem free:252kB min:128kB low:264kB high:400kB active_anon:54604kB inactive_anon:54952kB active_file:8680kB inactive_file:9232kB unevictable:0kB present:129992kB pages_scanned:0 all_unreclaimable? no
[2759231.956987] lowmem_reserve[]: 0 0 0 0
[2759231.956990] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3484kB
[2759231.957000] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1384kB
[2759231.957010] HighMem: 61*4kB 1*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 252kB
[2759231.957019] 34866 total pagecache pages
[2759231.957022] 1338 pages in swap cache
[2759231.957024] Swap cache stats: add 152965, delete 151627, find 13955964/13958438
[2759231.957027] Free swap  = 1691248kB
[2759231.957028] Total swap = 2192832kB
[2759231.957812] 260080 pages RAM
[2759231.957812] 32754 pages HighMem
[2759231.957812] 3509 pages reserved
[2759231.957812] 96125 pages shared
[2759231.957812] 220033 pages non-shared
[2759231.962356] swapper: page allocation failure. order:0, mode:0x20
[2759231.962361] Pid: 0, comm: swapper Not tainted 2.6.31.6 #3
[2759231.962364] Call Trace:
[2759231.962375]  [<c1042d81>] ? __alloc_pages_nodemask+0x448/0x508
[2759231.962380]  [<c10042b1>] ? do_IRQ+0x37/0x8c
[2759231.962386]  [<c105b5e3>] ? cache_alloc_refill+0x244/0x472
[2759231.962390]  [<c105b8ab>] ? __kmalloc+0x9a/0x9e
[2759231.962396]  [<c12b037f>] ? __alloc_skb+0x46/0x112
[2759231.962400]  [<c12b0f25>] ? __netdev_alloc_skb+0x1c/0x37
[2759231.962405]  [<c122bb1f>] ? tg3_alloc_rx_skb+0x7d/0x16d
[2759231.962409]  [<c1004bdc>] ? timer_interrupt+0x24/0x38
[2759231.962413]  [<c103adb2>] ? handle_IRQ_event+0x2d/0xbb
[2759231.962417]  [<c12334ed>] ? tg3_poll+0x7db/0x9cb
[2759231.962423]  [<c12b600c>] ? net_rx_action+0x6c/0xe0
[2759231.962428]  [<c1020ba1>] ? __do_softirq+0x68/0xe1
[2759231.962431]  [<c103adcf>] ? handle_IRQ_event+0x4a/0xbb
[2759231.962435]  [<c102ed94>] ? notify_die+0x30/0x34
[2759231.962440]  [<c101158e>] ? ack_apic_level+0x3c/0x13c
[2759231.962443]  [<c1020c40>] ? do_softirq+0x26/0x28
[2759231.962447]  [<c10042b1>] ? do_IRQ+0x37/0x8c
[2759231.962450]  [<c1003f04>] ? do_nmi+0x140/0x299
[2759231.962453]  [<c1003029>] ? common_interrupt+0x29/0x30
[2759231.962458]  [<c1007ffa>] ? default_idle+0x36/0x42
[2759231.962461]  [<c1001c61>] ? cpu_idle+0x24/0x43
[2759231.962465]  [<c1449685>] ? start_kernel+0x219/0x252
[2759231.962469]  [<c1449242>] ? unknown_bootoption+0x0/0x1dc
[2759231.962471] Mem-Info:
[2759231.962473] DMA per-cpu:
[2759231.962475] CPU    0: hi:    0, btch:   1 usd:   0
[2759231.962477] Normal per-cpu:
[2759231.962479] CPU    0: hi:  186, btch:  31 usd: 191
[2759231.962481] HighMem per-cpu:
[2759231.962483] CPU    0: hi:   42, btch:   7 usd:   3
[2759231.962487] Active_anon:104889 active_file:12798 inactive_anon:105060
[2759231.962489]  inactive_file:14667 unevictable:0 dirty:5061 writeback:5028 unstable:0
[2759231.962490]  free:1280 slab:11596 mapped:5235 pagetables:2542 bounce:0
[2759231.962495] DMA free:3484kB min:64kB low:80kB high:96kB active_anon:3852kB inactive_anon:4216kB active_file:1768kB inactive_file:2056kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
[2759231.962499] lowmem_reserve[]: 0 865 992 992
[2759231.962506] Normal free:1384kB min:3728kB low:4660kB high:5592kB active_anon:361100kB inactive_anon:361072kB active_file:40744kB inactive_file:47380kB unevictable:0kB present:885944kB pages_scanned:64 all_unreclaimable? no
[2759231.962509] lowmem_reserve[]: 0 0 1015 1015
[2759231.962515] HighMem free:252kB min:128kB low:264kB high:400kB active_anon:54604kB inactive_anon:54952kB active_file:8680kB inactive_file:9232kB unevictable:0kB present:129992kB pages_scanned:0 all_unreclaimable? no
[2759231.962519] lowmem_reserve[]: 0 0 0 0
[2759231.962523] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3484kB
[2759231.962533] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1384kB
[2759231.962542] HighMem: 61*4kB 1*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 252kB
[2759231.962552] 34866 total pagecache pages
[2759231.962554] 1338 pages in swap cache
[2759231.962557] Swap cache stats: add 152965, delete 151627, find 13955964/13958438
[2759231.962559] Free swap  = 1691248kB
[2759231.962561] Total swap = 2192832kB
[2759231.963335] 260080 pages RAM
[2759231.963335] 32754 pages HighMem
[2759231.963335] 3509 pages reserved
[2759231.963335] 96125 pages shared
[2759231.963335] 220033 pages non-shared
[2759231.967760] swapper: page allocation failure. order:0, mode:0x20
[2759231.967765] Pid: 0, comm: swapper Not tainted 2.6.31.6 #3
[2759231.967767] Call Trace:
[2759231.967777]  [<c1042d81>] ? __alloc_pages_nodemask+0x448/0x508
[2759231.967783]  [<c10042b1>] ? do_IRQ+0x37/0x8c
[2759231.967789]  [<c105b5e3>] ? cache_alloc_refill+0x244/0x472
[2759231.967793]  [<c105b8ab>] ? __kmalloc+0x9a/0x9e
[2759231.967800]  [<c12b037f>] ? __alloc_skb+0x46/0x112
[2759231.967803]  [<c12b0f25>] ? __netdev_alloc_skb+0x1c/0x37
[2759231.967811]  [<c122bb1f>] ? tg3_alloc_rx_skb+0x7d/0x16d
[2759231.967815]  [<c1004bdc>] ? timer_interrupt+0x24/0x38
[2759231.967819]  [<c103adb2>] ? handle_IRQ_event+0x2d/0xbb
[2759231.967823]  [<c12334ed>] ? tg3_poll+0x7db/0x9cb
[2759231.967828]  [<c12b600c>] ? net_rx_action+0x6c/0xe0
[2759231.967834]  [<c1020ba1>] ? __do_softirq+0x68/0xe1
[2759231.967837]  [<c103adcf>] ? handle_IRQ_event+0x4a/0xbb
[2759231.967841]  [<c102ed94>] ? notify_die+0x30/0x34
[2759231.967846]  [<c101158e>] ? ack_apic_level+0x3c/0x13c
[2759231.967849]  [<c1020c40>] ? do_softirq+0x26/0x28
[2759231.967853]  [<c10042b1>] ? do_IRQ+0x37/0x8c
[2759231.967856]  [<c1003f04>] ? do_nmi+0x140/0x299
[2759231.967859]  [<c1003029>] ? common_interrupt+0x29/0x30
[2759231.967864]  [<c1007ffa>] ? default_idle+0x36/0x42
[2759231.967867]  [<c1001c61>] ? cpu_idle+0x24/0x43
[2759231.967871]  [<c1449685>] ? start_kernel+0x219/0x252
[2759231.967875]  [<c1449242>] ? unknown_bootoption+0x0/0x1dc
[2759231.967877] Mem-Info:
[2759231.967879] DMA per-cpu:
[2759231.967881] CPU    0: hi:    0, btch:   1 usd:   0
[2759231.967883] Normal per-cpu:
[2759231.967885] CPU    0: hi:  186, btch:  31 usd: 191
[2759231.967887] HighMem per-cpu:
[2759231.967889] CPU    0: hi:   42, btch:   7 usd:   3
[2759231.967894] Active_anon:104889 active_file:12798 inactive_anon:105060
[2759231.967896]  inactive_file:14667 unevictable:0 dirty:5061 writeback:5028 unstable:0
[2759231.967897]  free:1280 slab:11596 mapped:5235 pagetables:2542 bounce:0
[2759231.967902] DMA free:3484kB min:64kB low:80kB high:96kB active_anon:3852kB inactive_anon:4216kB active_file:1768kB inactive_file:2056kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
[2759231.967906] lowmem_reserve[]: 0 865 992 992
[2759231.967913] Normal free:1384kB min:3728kB low:4660kB high:5592kB active_anon:361100kB inactive_anon:361072kB active_file:40744kB inactive_file:47380kB unevictable:0kB present:885944kB pages_scanned:64 all_unreclaimable? no
[2759231.967917] lowmem_reserve[]: 0 0 1015 1015
[2759231.967923] HighMem free:252kB min:128kB low:264kB high:400kB active_anon:54604kB inactive_anon:54952kB active_file:8680kB inactive_file:9232kB unevictable:0kB present:129992kB pages_scanned:0 all_unreclaimable? no
[2759231.967927] lowmem_reserve[]: 0 0 0 0
[2759231.967930] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3484kB
[2759231.967940] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1384kB
[2759231.967950] HighMem: 61*4kB 1*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 252kB
[2759231.967960] 34866 total pagecache pages
[2759231.967962] 1338 pages in swap cache
[2759231.967965] Swap cache stats: add 152965, delete 151627, find 13955964/13958438
[2759231.967967] Free swap  = 1691248kB
[2759231.967969] Total swap = 2192832kB
[2759231.968751] 260080 pages RAM
[2759231.968751] 32754 pages HighMem
[2759231.968751] 3509 pages reserved
[2759231.968751] 96125 pages shared
[2759231.968751] 220033 pages non-shared
[2759231.973170] swapper: page allocation failure. order:0, mode:0x20
[2759231.973175] Pid: 0, comm: swapper Not tainted 2.6.31.6 #3
[2759231.973177] Call Trace:
[2759231.973188]  [<c1042d81>] ? __alloc_pages_nodemask+0x448/0x508
[2759231.973193]  [<c10042b1>] ? do_IRQ+0x37/0x8c
[2759231.973199]  [<c105b5e3>] ? cache_alloc_refill+0x244/0x472
[2759231.973203]  [<c105b8ab>] ? __kmalloc+0x9a/0x9e
[2759231.973210]  [<c12b037f>] ? __alloc_skb+0x46/0x112
[2759231.973213]  [<c12b0f25>] ? __netdev_alloc_skb+0x1c/0x37
[2759231.973219]  [<c122bb1f>] ? tg3_alloc_rx_skb+0x7d/0x16d
[2759231.973223]  [<c1004bdc>] ? timer_interrupt+0x24/0x38
[2759231.973227]  [<c103adb2>] ? handle_IRQ_event+0x2d/0xbb
[2759231.973231]  [<c12334ed>] ? tg3_poll+0x7db/0x9cb
[2759231.973237]  [<c12b600c>] ? net_rx_action+0x6c/0xe0
[2759231.973242]  [<c1020ba1>] ? __do_softirq+0x68/0xe1
[2759231.973245]  [<c103adcf>] ? handle_IRQ_event+0x4a/0xbb
[2759231.973250]  [<c102ed94>] ? notify_die+0x30/0x34
[2759231.973254]  [<c101158e>] ? ack_apic_level+0x3c/0x13c
[2759231.973258]  [<c1020c40>] ? do_softirq+0x26/0x28
[2759231.973262]  [<c10042b1>] ? do_IRQ+0x37/0x8c
[2759231.973265]  [<c1003f04>] ? do_nmi+0x140/0x299
[2759231.973268]  [<c1003029>] ? common_interrupt+0x29/0x30
[2759231.973273]  [<c1007ffa>] ? default_idle+0x36/0x42
[2759231.973276]  [<c1001c61>] ? cpu_idle+0x24/0x43
[2759231.973281]  [<c1449685>] ? start_kernel+0x219/0x252
[2759231.973284]  [<c1449242>] ? unknown_bootoption+0x0/0x1dc
[2759231.973286] Mem-Info:
[2759231.973288] DMA per-cpu:
[2759231.973291] CPU    0: hi:    0, btch:   1 usd:   0
[2759231.973293] Normal per-cpu:
[2759231.973295] CPU    0: hi:  186, btch:  31 usd: 191
[2759231.973296] HighMem per-cpu:
[2759231.973299] CPU    0: hi:   42, btch:   7 usd:   3
[2759231.973303] Active_anon:104889 active_file:12798 inactive_anon:105060
[2759231.973305]  inactive_file:14667 unevictable:0 dirty:5061 writeback:5028 unstable:0
[2759231.973306]  free:1280 slab:11596 mapped:5235 pagetables:2542 bounce:0
[2759231.973312] DMA free:3484kB min:64kB low:80kB high:96kB active_anon:3852kB inactive_anon:4216kB active_file:1768kB inactive_file:2056kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
[2759231.973315] lowmem_reserve[]: 0 865 992 992
[2759231.973322] Normal free:1384kB min:3728kB low:4660kB high:5592kB active_anon:361100kB inactive_anon:361072kB active_file:40744kB inactive_file:47380kB unevictable:0kB present:885944kB pages_scanned:64 all_unreclaimable? no
[2759231.973326] lowmem_reserve[]: 0 0 1015 1015
[2759231.973332] HighMem free:252kB min:128kB low:264kB high:400kB active_anon:54604kB inactive_anon:54952kB active_file:8680kB inactive_file:9232kB unevictable:0kB present:129992kB pages_scanned:0 all_unreclaimable? no
[2759231.973336] lowmem_reserve[]: 0 0 0 0
[2759231.973340] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3484kB
[2759231.973350] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1384kB
[2759231.973359] HighMem: 61*4kB 1*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 252kB
[2759231.973369] 34866 total pagecache pages
[2759231.973371] 1338 pages in swap cache
[2759231.973374] Swap cache stats: add 152965, delete 151627, find 13955964/13958438
[2759231.973376] Free swap  = 1691248kB
[2759231.973378] Total swap = 2192832kB
[2759231.974161] 260080 pages RAM
[2759231.974161] 32754 pages HighMem
[2759231.974161] 3509 pages reserved
[2759231.974161] 96125 pages shared
[2759231.974161] 220033 pages non-shared
[2759231.978629] swapper: page allocation failure. order:0, mode:0x20
[2759231.978635] Pid: 0, comm: swapper Not tainted 2.6.31.6 #3
[2759231.978637] Call Trace:
[2759231.978648]  [<c1042d81>] ? __alloc_pages_nodemask+0x448/0x508
[2759231.978655]  [<c10042b1>] ? do_IRQ+0x37/0x8c
[2759231.978661]  [<c105b5e3>] ? cache_alloc_refill+0x244/0x472
[2759231.978665]  [<c105b8ab>] ? __kmalloc+0x9a/0x9e
[2759231.978671]  [<c12b037f>] ? __alloc_skb+0x46/0x112
[2759231.978674]  [<c12b0f25>] ? __netdev_alloc_skb+0x1c/0x37
[2759231.978680]  [<c122bb1f>] ? tg3_alloc_rx_skb+0x7d/0x16d
[2759231.978684]  [<c1004bdc>] ? timer_interrupt+0x24/0x38
[2759231.978688]  [<c103adb2>] ? handle_IRQ_event+0x2d/0xbb
[2759231.978692]  [<c12334ed>] ? tg3_poll+0x7db/0x9cb
[2759231.978697]  [<c12b600c>] ? net_rx_action+0x6c/0xe0
[2759231.978702]  [<c1020ba1>] ? __do_softirq+0x68/0xe1
[2759231.978706]  [<c103adcf>] ? handle_IRQ_event+0x4a/0xbb
[2759231.978710]  [<c102ed94>] ? notify_die+0x30/0x34
[2759231.978714]  [<c101158e>] ? ack_apic_level+0x3c/0x13c
[2759231.978717]  [<c1020c40>] ? do_softirq+0x26/0x28
[2759231.978721]  [<c10042b1>] ? do_IRQ+0x37/0x8c
[2759231.978724]  [<c1003f04>] ? do_nmi+0x140/0x299
[2759231.978727]  [<c1003029>] ? common_interrupt+0x29/0x30
[2759231.978732]  [<c1007ffa>] ? default_idle+0x36/0x42
[2759231.978735]  [<c1001c61>] ? cpu_idle+0x24/0x43
[2759231.978739]  [<c1449685>] ? start_kernel+0x219/0x252
[2759231.978742]  [<c1449242>] ? unknown_bootoption+0x0/0x1dc
[2759231.978744] Mem-Info:
[2759231.978746] DMA per-cpu:
[2759231.978748] CPU    0: hi:    0, btch:   1 usd:   0
[2759231.978750] Normal per-cpu:
[2759231.978752] CPU    0: hi:  186, btch:  31 usd: 191
[2759231.978754] HighMem per-cpu:
[2759231.978756] CPU    0: hi:   42, btch:   7 usd:   3
[2759231.978760] Active_anon:104889 active_file:12798 inactive_anon:105060
[2759231.978762]  inactive_file:14667 unevictable:0 dirty:5061 writeback:5028 unstable:0
[2759231.978763]  free:1280 slab:11596 mapped:5235 pagetables:2542 bounce:0
[2759231.978768] DMA free:3484kB min:64kB low:80kB high:96kB active_anon:3852kB inactive_anon:4216kB active_file:1768kB inactive_file:2056kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
[2759231.978771] lowmem_reserve[]: 0 865 992 992
[2759231.978778] Normal free:1384kB min:3728kB low:4660kB high:5592kB active_anon:361100kB inactive_anon:361072kB active_file:40744kB inactive_file:47380kB unevictable:0kB present:885944kB pages_scanned:64 all_unreclaimable? no
[2759231.978781] lowmem_reserve[]: 0 0 1015 1015
[2759231.978787] HighMem free:252kB min:128kB low:264kB high:400kB active_anon:54604kB inactive_anon:54952kB active_file:8680kB inactive_file:9232kB unevictable:0kB present:129992kB pages_scanned:0 all_unreclaimable? no
[2759231.978791] lowmem_reserve[]: 0 0 0 0
[2759231.978794] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3484kB
[2759231.978804] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1384kB
[2759231.978816] HighMem: 61*4kB 1*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 252kB
[2759231.978826] 34866 total pagecache pages
[2759231.978828] 1338 pages in swap cache
[2759231.978831] Swap cache stats: add 152965, delete 151627, find 13955964/13958438
[2759231.978833] Free swap  = 1691248kB
[2759231.978835] Total swap = 2192832kB
[2759231.979622] 260080 pages RAM
[2759231.979622] 32754 pages HighMem
[2759231.979622] 3509 pages reserved
[2759231.979622] 96125 pages shared
[2759231.979622] 220033 pages non-shared
[2759231.984021] swapper: page allocation failure. order:0, mode:0x20
[2759231.984026] Pid: 0, comm: swapper Not tainted 2.6.31.6 #3
[2759231.984029] Call Trace:
[2759231.984039]  [<c1042d81>] ? __alloc_pages_nodemask+0x448/0x508
[2759231.984044]  [<c10042b1>] ? do_IRQ+0x37/0x8c
[2759231.984050]  [<c105b5e3>] ? cache_alloc_refill+0x244/0x472
[2759231.984054]  [<c105b8ab>] ? __kmalloc+0x9a/0x9e
[2759231.984060]  [<c12b037f>] ? __alloc_skb+0x46/0x112
[2759231.984063]  [<c12b0f25>] ? __netdev_alloc_skb+0x1c/0x37
[2759231.984069]  [<c122bb1f>] ? tg3_alloc_rx_skb+0x7d/0x16d
[2759231.984073]  [<c1004bdc>] ? timer_interrupt+0x24/0x38
[2759231.984077]  [<c103adb2>] ? handle_IRQ_event+0x2d/0xbb
[2759231.984080]  [<c12334ed>] ? tg3_poll+0x7db/0x9cb
[2759231.984086]  [<c12b600c>] ? net_rx_action+0x6c/0xe0
[2759231.984091]  [<c1020ba1>] ? __do_softirq+0x68/0xe1
[2759231.984094]  [<c103adcf>] ? handle_IRQ_event+0x4a/0xbb
[2759231.984098]  [<c102ed94>] ? notify_die+0x30/0x34
[2759231.984102]  [<c101158e>] ? ack_apic_level+0x3c/0x13c
[2759231.984106]  [<c1020c40>] ? do_softirq+0x26/0x28
[2759231.984110]  [<c10042b1>] ? do_IRQ+0x37/0x8c
[2759231.984113]  [<c1003f04>] ? do_nmi+0x140/0x299
[2759231.984116]  [<c1003029>] ? common_interrupt+0x29/0x30
[2759231.984121]  [<c1007ffa>] ? default_idle+0x36/0x42
[2759231.984124]  [<c1001c61>] ? cpu_idle+0x24/0x43
[2759231.984128]  [<c1449685>] ? start_kernel+0x219/0x252
[2759231.984131]  [<c1449242>] ? unknown_bootoption+0x0/0x1dc
[2759231.984133] Mem-Info:
[2759231.984135] DMA per-cpu:
[2759231.984137] CPU    0: hi:    0, btch:   1 usd:   0
[2759231.984139] Normal per-cpu:
[2759231.984141] CPU    0: hi:  186, btch:  31 usd: 191
[2759231.984143] HighMem per-cpu:
[2759231.984145] CPU    0: hi:   42, btch:   7 usd:   3
[2759231.984149] Active_anon:104889 active_file:12798 inactive_anon:105060
[2759231.984151]  inactive_file:14667 unevictable:0 dirty:5061 writeback:5028 unstable:0
[2759231.984152]  free:1280 slab:11596 mapped:5235 pagetables:2542 bounce:0
[2759231.984157] DMA free:3484kB min:64kB low:80kB high:96kB active_anon:3852kB inactive_anon:4216kB active_file:1768kB inactive_file:2056kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
[2759231.984161] lowmem_reserve[]: 0 865 992 992
[2759231.984167] Normal free:1384kB min:3728kB low:4660kB high:5592kB active_anon:361100kB inactive_anon:361072kB active_file:40744kB inactive_file:47380kB unevictable:0kB present:885944kB pages_scanned:64 all_unreclaimable? no
[2759231.984171] lowmem_reserve[]: 0 0 1015 1015
[2759231.984176] HighMem free:252kB min:128kB low:264kB high:400kB active_anon:54604kB inactive_anon:54952kB active_file:8680kB inactive_file:9232kB unevictable:0kB present:129992kB pages_scanned:0 all_unreclaimable? no
[2759231.984180] lowmem_reserve[]: 0 0 0 0
[2759231.984183] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3484kB
[2759231.984193] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1384kB
[2759231.984203] HighMem: 61*4kB 1*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 252kB
[2759231.984212] 34866 total pagecache pages
[2759231.984214] 1338 pages in swap cache
[2759231.984217] Swap cache stats: add 152965, delete 151627, find 13955964/13958438
[2759231.984219] Free swap  = 1691248kB
[2759231.984220] Total swap = 2192832kB
[2759231.985010] 260080 pages RAM
[2759231.985010] 32754 pages HighMem
[2759231.985010] 3509 pages reserved
[2759231.985010] 96125 pages shared
[2759231.985010] 220033 pages non-shared
[2759231.989433] swapper: page allocation failure. order:0, mode:0x20
[2759231.989438] Pid: 0, comm: swapper Not tainted 2.6.31.6 #3
[2759231.989440] Call Trace:
[2759231.989450]  [<c1042d81>] ? __alloc_pages_nodemask+0x448/0x508
[2759231.989456]  [<c10042b1>] ? do_IRQ+0x37/0x8c
[2759231.989462]  [<c105b5e3>] ? cache_alloc_refill+0x244/0x472
[2759231.989466]  [<c105b8ab>] ? __kmalloc+0x9a/0x9e
[2759231.989472]  [<c12b037f>] ? __alloc_skb+0x46/0x112
[2759231.989475]  [<c12b0f25>] ? __netdev_alloc_skb+0x1c/0x37
[2759231.989481]  [<c122bb1f>] ? tg3_alloc_rx_skb+0x7d/0x16d
[2759231.989484]  [<c1004bdc>] ? timer_interrupt+0x24/0x38
[2759231.989488]  [<c103adb2>] ? handle_IRQ_event+0x2d/0xbb
[2759231.989492]  [<c12334ed>] ? tg3_poll+0x7db/0x9cb
[2759231.989497]  [<c12b600c>] ? net_rx_action+0x6c/0xe0
[2759231.989503]  [<c1020ba1>] ? __do_softirq+0x68/0xe1
[2759231.989506]  [<c103adcf>] ? handle_IRQ_event+0x4a/0xbb
[2759231.989510]  [<c102ed94>] ? notify_die+0x30/0x34
[2759231.989514]  [<c101158e>] ? ack_apic_level+0x3c/0x13c
[2759231.989517]  [<c1020c40>] ? do_softirq+0x26/0x28
[2759231.989521]  [<c10042b1>] ? do_IRQ+0x37/0x8c
[2759231.989524]  [<c1003f04>] ? do_nmi+0x140/0x299
[2759231.989527]  [<c1003029>] ? common_interrupt+0x29/0x30
[2759231.989532]  [<c1007ffa>] ? default_idle+0x36/0x42
[2759231.989535]  [<c1001c61>] ? cpu_idle+0x24/0x43
[2759231.989539]  [<c1449685>] ? start_kernel+0x219/0x252
[2759231.989542]  [<c1449242>] ? unknown_bootoption+0x0/0x1dc
[2759231.989544] Mem-Info:
[2759231.989546] DMA per-cpu:
[2759231.989548] CPU    0: hi:    0, btch:   1 usd:   0
[2759231.989550] Normal per-cpu:
[2759231.989552] CPU    0: hi:  186, btch:  31 usd: 191
[2759231.989554] HighMem per-cpu:
[2759231.989556] CPU    0: hi:   42, btch:   7 usd:   3
[2759231.989561] Active_anon:104889 active_file:12798 inactive_anon:105060
[2759231.989562]  inactive_file:14667 unevictable:0 dirty:5061 writeback:5028 unstable:0
[2759231.989564]  free:1280 slab:11596 mapped:5235 pagetables:2542 bounce:0
[2759231.989569] DMA free:3484kB min:64kB low:80kB high:96kB active_anon:3852kB inactive_anon:4216kB active_file:1768kB inactive_file:2056kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
[2759231.989572] lowmem_reserve[]: 0 865 992 992
[2759231.989579] Normal free:1384kB min:3728kB low:4660kB high:5592kB active_anon:361100kB inactive_anon:361072kB active_file:40744kB inactive_file:47380kB unevictable:0kB present:885944kB pages_scanned:64 all_unreclaimable? no
[2759231.989582] lowmem_reserve[]: 0 0 1015 1015
[2759231.989588] HighMem free:252kB min:128kB low:264kB high:400kB active_anon:54604kB inactive_anon:54952kB active_file:8680kB inactive_file:9232kB unevictable:0kB present:129992kB pages_scanned:0 all_unreclaimable? no
[2759231.989592] lowmem_reserve[]: 0 0 0 0
[2759231.989596] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3484kB
[2759231.989605] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1384kB
[2759231.989615] HighMem: 61*4kB 1*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 252kB
[2759231.989624] 34866 total pagecache pages
[2759231.989627] 1338 pages in swap cache
[2759231.989629] Swap cache stats: add 152965, delete 151627, find 13955964/13958438
[2759231.989632] Free swap  = 1691248kB
[2759231.989633] Total swap = 2192832kB
[2759231.990424] 260080 pages RAM
[2759231.990424] 32754 pages HighMem
[2759231.990424] 3509 pages reserved
[2759231.990424] 96125 pages shared
[2759231.990424] 220033 pages non-shared

