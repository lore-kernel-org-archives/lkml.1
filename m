Return-Path: <linux-kernel-owner+w=401wt.eu-S933545AbXBXTvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933545AbXBXTvS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 14:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933548AbXBXTvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 14:51:18 -0500
Received: from mx1.aecom.yu.edu ([129.98.1.51]:58634 "EHLO mx1.aecom.yu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933545AbXBXTvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 14:51:16 -0500
X-Greylist: delayed 1488 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Feb 2007 14:51:15 EST
X-AuditID: 816201a0-a19c4bb0000034f6-2d-45e08e1df792 
Mime-Version: 1.0
Message-Id: <a062404fac2063cf08b36@[129.98.90.227]>
Date: Sat, 24 Feb 2007 14:27:49 -0500
To: linux-kernel@vger.kernel.org
From: Maurice Volaski <mvolaski@aecom.yu.edu>
Subject: swapper: page allocation failure in Gentoo kernel 2.6.20
Cc: drbd-user@linbit.com
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

64-bit based single processor AMD system running Gentoo kernel 2.6.20 
with drbd added and is running several drbd processes (as the target) 
at the time complains as follows.  System has 2 GB physical memory 
and 8 GB swap.

Feb 24 04:35:16 [kernel] [36186.533322] swapper: page allocation 
failure. order:2, mode:0x20
Feb 24 04:35:17 [kernel] [36186.533329]
Feb 24 04:35:17 [kernel] [36186.533331] Call Trace:
Feb 24 04:35:17 [kernel] [36186.533335]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:17 [kernel] [36186.533357]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.533364]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.533370]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:17 [kernel] [36186.533377]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:17 [kernel] [36186.533385]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:17 [kernel] [36186.533393]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:17 [kernel] [36186.533411]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:17 [kernel] [36186.533424]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:17 [kernel] [36186.533434]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:17 [kernel] [36186.533441]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:17 [kernel] [36186.533449]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:17 [kernel] [36186.533457]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:17 [kernel] [36186.533465]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:17 [kernel] [36186.533470]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:17 [kernel] [36186.533476]  [<ffffffff80162b34>] 
default_idle+0x0/0x3d
Feb 24 04:35:17 [kernel] [36186.533482]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:17 [kernel] [36186.533485]  <EOI>  [<ffffffff80162b5d>] 
default_idle+0x29/0x3d
Feb 24 04:35:17 [kernel] [36186.533498]  [<ffffffff801444dd>] 
cpu_idle+0x8b/0xae
Feb 24 04:35:17 [kernel] [36186.533505]  [<ffffffff804786dc>] 
start_kernel+0x218/0x21d
Feb 24 04:35:17 [kernel] [36186.533511]  [<ffffffff8047815c>] 
_sinittext+0x15c/0x160
Feb 24 04:35:17 [kernel] [36186.533515]
Feb 24 04:35:17 [kernel] [36186.533517] Mem-info:
Feb 24 04:35:17 [kernel] [36186.533520] Node 0 DMA per-cpu:
Feb 24 04:35:17 [kernel] [36186.533525] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:17 [kernel] [36186.533529] Node 0 DMA32 per-cpu:
Feb 24 04:35:17 [kernel] [36186.533533] CPU    0: Hot: hi:  186, 
btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  52
Feb 24 04:35:17 [kernel] [36186.533541] Active:12732 inactive:16626 
dirty:20 writeback:0 unstable:0 free:1377 slab:25974 mapped:1106 
pagetables:230
Feb 24 04:35:17 [kernel] [36186.533545] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? yes
Feb 24 04:35:17 [kernel] [36186.533553] lowmem_reserve[]: 0 993 993
Feb 24 04:35:17 [kernel] [36186.533557] Node 0 DMA32 free:1516kB 
min:4008kB low:5008kB high:6012kB active:50928kB inactive:66504kB 
present:1017452kB pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:17 [kernel] [36186.533565] lowmem_reserve[]: 0 0 0
Feb 24 04:35:17 [kernel] [36186.533568] Node 0 DMA: 0*4kB 1*8kB 
1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 3992kB
Feb 24 04:35:17 [kernel] [36186.533580] Node 0 DMA32: 1*4kB 1*8kB 
0*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 
0*4096kB = 1516kB
Feb 24 04:35:17 [kernel] [36186.533593] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:17 [kernel] [36186.533596] Free swap  = 8835648kB
Feb 24 04:35:17 [kernel] [36186.533599] Total swap = 8835740kB
Feb 24 04:35:17 [kernel] [36186.533602] Free swap:       8835648kB
Feb 24 04:35:17 [kernel] [36186.541647] 261984 pages of RAM
Feb 24 04:35:17 [kernel] [36186.541650] 70621 reserved pages
Feb 24 04:35:17 [kernel] [36186.541653] 31066 pages shared
Feb 24 04:35:17 [kernel] [36186.541655] 0 pages swap cached
Feb 24 04:35:17 [kernel] [36186.541670] swapper: page allocation 
failure. order:2, mode:0x20
Feb 24 04:35:17 [kernel] [36186.541673]
Feb 24 04:35:17 [kernel] [36186.541674] Call Trace:
Feb 24 04:35:17 [kernel] [36186.541677]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:17 [kernel] [36186.541693]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.541700]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.541706]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:17 [kernel] [36186.541714]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:17 [kernel] [36186.541721]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:17 [kernel] [36186.541730]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:17 [kernel] [36186.541742]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:17 [kernel] [36186.541754]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:17 [kernel] [36186.541763]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:17 [kernel] [36186.541770]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:17 [kernel] [36186.541777]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:17 [kernel] [36186.541785]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:17 [kernel] [36186.541792]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:17 [kernel] [36186.541798]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:17 [kernel] [36186.541824]  [<ffffffff801444dd>] 
cpu_idle+0x8b/0xae
Feb 24 04:35:17 [kernel] [36186.541831]  [<ffffffff804786dc>] 
start_kernel+0x218/0x21d
Feb 24 04:35:17 [kernel] [36186.541838]  [<ffffffff8047815c>] 
_sinittext+0x15c/0x160
Feb 24 04:35:17 [kernel] [36186.541842]
Feb 24 04:35:17 [kernel] [36186.541844] Mem-info:
Feb 24 04:35:17 [kernel] [36186.541846] Node 0 DMA per-cpu:
Feb 24 04:35:17 [kernel] [36186.541850] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:17 [kernel] [36186.541853] Node 0 DMA32 per-cpu:
Feb 24 04:35:17 [kernel] [36186.541858] CPU    0: Hot: hi:  186, 
btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  52
Feb 24 04:35:17 [kernel] [36186.541865] Active:12732 inactive:16626 
dirty:20 writeback:0 unstable:0 free:1377 slab:25974 mapped:1106 
pagetables:230
Feb 24 04:35:17 [kernel] [36186.541869] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? yes
Feb 24 04:35:17 [kernel] [36186.541876] lowmem_reserve[]: 0 993 993
Feb 24 04:35:17 [kernel] [36186.541880] Node 0 DMA32 free:1516kB 
min:4008kB low:5008kB high:6012kB active:50928kB inactive:66504kB 
present:1017452kB pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:17 [kernel] [36186.541888] lowmem_reserve[]: 0 0 0
Feb 24 04:35:17 [kernel] [36186.541892] Node 0 DMA: 0*4kB 1*8kB 
1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 3992kB
Feb 24 04:35:17 [kernel] [36186.541903] Node 0 DMA32: 1*4kB 1*8kB 
0*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 
0*4096kB = 1516kB
Feb 24 04:35:17 [kernel] [36186.541916] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:17 [kernel] [36186.541919] Free swap  = 8835648kB
Feb 24 04:35:17 [kernel] [36186.541922] Total swap = 8835740kB
Feb 24 04:35:17 [kernel] [36186.541924] Free swap:       8835648kB
Feb 24 04:35:17 [kernel] [36186.549453] 261984 pages of RAM
Feb 24 04:35:17 [kernel] [36186.549456] 70621 reserved pages
Feb 24 04:35:17 [kernel] [36186.549459] 31066 pages shared
Feb 24 04:35:17 [kernel] [36186.549461] 0 pages swap cached
Feb 24 04:35:17 [kernel] [36186.549474] swapper: page allocation 
failure. order:2, mode:0x20
Feb 24 04:35:17 [kernel] [36186.549477]
Feb 24 04:35:17 [kernel] [36186.549478] Call Trace:
Feb 24 04:35:17 [kernel] [36186.549480]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:17 [kernel] [36186.549496]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.549503]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.549509]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:17 [kernel] [36186.549516]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:17 [kernel] [36186.549524]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:17 [kernel] [36186.549533]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:17 [kernel] [36186.549544]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:17 [kernel] [36186.549556]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:17 [kernel] [36186.549566]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:17 [kernel] [36186.549573]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:17 [kernel] [36186.549580]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:17 [kernel] [36186.549587]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:17 [kernel] [36186.549594]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:17 [kernel] [36186.549600]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:17 [kernel] [36186.549605]  [<ffffffff80162b34>] 
default_idle+0x0/0x3d
Feb 24 04:35:17 [kernel] [36186.549611]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:17 [kernel] [36186.549614]  <EOI>  [<ffffffff80162b5d>] 
default_idle+0x29/0x3d
Feb 24 04:35:17 [kernel] [36186.549626]  [<ffffffff801444dd>] 
cpu_idle+0x8b/0xae
Feb 24 04:35:17 [kernel] [36186.549633]  [<ffffffff804786dc>] 
start_kernel+0x218/0x21d
Feb 24 04:35:17 [kernel] [36186.549640]  [<ffffffff8047815c>] 
_sinittext+0x15c/0x160
Feb 24 04:35:17 [kernel] [36186.549644]
Feb 24 04:35:17 [kernel] [36186.549645] Mem-info:
Feb 24 04:35:17 [kernel] [36186.549647] Node 0 DMA per-cpu:
Feb 24 04:35:17 [kernel] [36186.549652] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:17 [kernel] [36186.549655] Node 0 DMA32 per-cpu:
Feb 24 04:35:17 [kernel] [36186.549660] CPU    0: Hot: hi:  186, 
btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  52
Feb 24 04:35:17 [kernel] [36186.549667] Active:12732 inactive:16626 
dirty:20 writeback:0 unstable:0 free:1377 slab:25974 mapped:1106 
pagetables:230
Feb 24 04:35:17 [kernel] [36186.549671] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? yes
Feb 24 04:35:17 [kernel] [36186.549678] lowmem_reserve[]: 0 993 993
Feb 24 04:35:17 [kernel] [36186.549681] Node 0 DMA32 free:1516kB 
min:4008kB low:5008kB high:6012kB active:50928kB inactive:66504kB 
present:1017452kB pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:17 [kernel] [36186.549690] lowmem_reserve[]: 0 0 0
Feb 24 04:35:17 [kernel] [36186.541844] Mem-info:
Feb 24 04:35:17 [kernel] [36186.549717] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:17 [kernel] [36186.549723] Total swap = 8835740kB
Feb 24 04:35:17 [kernel] [36186.549726] Free swap:       8835648kB
Feb 24 04:35:17 [kernel] [36186.557252] 261984 pages of RAM
Feb 24 04:35:17 [kernel] [36186.557255] 70621 reserved pages
Feb 24 04:35:17 [kernel] [36186.557257] 31066 pages shared
Feb 24 04:35:17 [kernel] [36186.557260] 0 pages swap cached
Feb 24 04:35:17 [kernel] [36186.557272] swapper: page allocation 
failure. order:2, mode:0x20
Feb 24 04:35:17 [kernel] [36186.557274]
Feb 24 04:35:17 [kernel] [36186.557276] Call Trace:
Feb 24 04:35:17 [kernel] [36186.557278]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:17 [kernel] [36186.557294]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.557301]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.557307]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:17 [kernel] [36186.557314]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:17 [kernel] [36186.557321]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:17 [kernel] [36186.557330]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:17 [kernel] [36186.557342]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:17 [kernel] [36186.557354]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:17 [kernel] [36186.557363]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:17 [kernel] [36186.557370]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:17 [kernel] [36186.557378]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:17 [kernel] [36186.557385]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:17 [kernel] [36186.557392]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:17 [kernel] [36186.557398]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:17 [kernel] [36186.557403]  [<ffffffff80162b34>] 
default_idle+0x0/0x3d
Feb 24 04:35:17 [kernel] [36186.557409]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:17 [kernel] [36186.557412]  <EOI>  [<ffffffff80162b5d>] 
default_idle+0x29/0x3d
Feb 24 04:35:17 [kernel] [36186.557424]  [<ffffffff801444dd>] 
cpu_idle+0x8b/0xae
Feb 24 04:35:17 [kernel] [36186.557431]  [<ffffffff804786dc>] 
start_kernel+0x218/0x21d
Feb 24 04:35:17 [kernel] [36186.557437]  [<ffffffff8047815c>] 
_sinittext+0x15c/0x160
Feb 24 04:35:17 [kernel] [36186.557441]
Feb 24 04:35:17 [kernel] [36186.557443] Mem-info:
Feb 24 04:35:17 [kernel] [36186.557445] Node 0 DMA per-cpu:
Feb 24 04:35:17 [kernel] [36186.557449] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:17 [kernel] [36186.557453] Node 0 DMA32 per-cpu:
Feb 24 04:35:17 [kernel] [36186.557457] CPU    0: Hot: hi:  186, 
btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  52
Feb 24 04:35:17 [kernel] [36186.557464] Active:12732 inactive:16626 
dirty:20 writeback:0 unstable:0 free:1377 slab:25974 mapped:1106 
pagetables:230
Feb 24 04:35:17 [kernel] [36186.557468] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? yes
Feb 24 04:35:17 [kernel] [36186.557475] lowmem_reserve[]: 0 993 993
Feb 24 04:35:17 [kernel] [36186.557479] Node 0 DMA32 free:1516kB 
min:4008kB low:5008kB high:6012kB active:50928kB inactive:66504kB 
present:1017452kB pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:17 [kernel] [36186.557488] lowmem_reserve[]: 0 0 0
Feb 24 04:35:17 [kernel] [36186.557491] Node 0 DMA: 0*4kB 1*8kB 
1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 3992kB
Feb 24 04:35:17 [kernel] [36186.557502] Node 0 DMA32: 1*4kB 1*8kB 
0*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 
0*4096kB = 1516kB
Feb 24 04:35:17 [kernel] [36186.557515] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:17 [kernel] [36186.557518] Free swap  = 8835648kB
Feb 24 04:35:17 [kernel] [36186.557521] Total swap = 8835740kB
Feb 24 04:35:17 [kernel] [36186.557524] Free swap:       8835648kB
Feb 24 04:35:17 [kernel] [36186.565048] 261984 pages of RAM
Feb 24 04:35:17 [kernel] [36186.565051] 70621 reserved pages
Feb 24 04:35:17 [kernel] [36186.565053] 31066 pages shared
Feb 24 04:35:17 [kernel] [36186.565056] 0 pages swap cached
Feb 24 04:35:17 [kernel] [36186.565068] swapper: page allocation 
failure. order:2, mode:0x20
Feb 24 04:35:17 [kernel] [36186.565070]
Feb 24 04:35:17 [kernel] [36186.565072] Call Trace:
Feb 24 04:35:17 [kernel] [36186.565074]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:17 [kernel] [36186.565090]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.565097]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.565103]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:17 [kernel] [36186.565110]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:17 [kernel] [36186.565117]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:17 [kernel] [36186.565126]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:17 [kernel] [36186.565138]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:17 [kernel] [36186.565150]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:17 [kernel] [36186.565159]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:17 [kernel] [36186.565166]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:17 [kernel] [36186.565188]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:17 [kernel] [36186.565193]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:17 [kernel] [36186.565199]  [<ffffffff80162b34>] 
default_idle+0x0/0x3d
Feb 24 04:35:17 [kernel] [36186.565205]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:17 [kernel] [36186.565208]  <EOI>  [<ffffffff80162b5d>] 
default_idle+0x29/0x3d
Feb 24 04:35:17 [kernel] [36186.565220]  [<ffffffff801444dd>] 
cpu_idle+0x8b/0xae
Feb 24 04:35:17 [kernel] [36186.565227]  [<ffffffff804786dc>] 
start_kernel+0x218/0x21d
Feb 24 04:35:17 [kernel] [36186.565233]  [<ffffffff8047815c>] 
_sinittext+0x15c/0x160
Feb 24 04:35:17 [kernel] [36186.565237]
Feb 24 04:35:17 [kernel] [36186.565239] Mem-info:
Feb 24 04:35:17 [kernel] [36186.565241] Node 0 DMA per-cpu:
Feb 24 04:35:17 [kernel] [36186.565245] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:17 [kernel] [36186.565248] Node 0 DMA32 per-cpu:
Feb 24 04:35:17 [kernel] [36186.565253] CPU    0: Hot: hi:  186, 
btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  52
Feb 24 04:35:17 [kernel] [36186.565260] Active:12732 inactive:16626 
dirty:20 writeback:0 unstable:0 free:1377 slab:25974 mapped:1106 
pagetables:230
Feb 24 04:35:17 [kernel] [36186.565264] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? yes
Feb 24 04:35:17 [kernel] [36186.565271] lowmem_reserve[]: 0 993 993
Feb 24 04:35:17 [kernel] [36186.565275] Node 0 DMA32 free:1516kB 
min:4008kB low:5008kB high:6012kB active:50928kB inactive:66504kB 
present:1017452kB pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:17 [kernel] [36186.565283] lowmem_reserve[]: 0 0 0
Feb 24 04:35:17 [kernel] [36186.565286] Node 0 DMA: 0*4kB 1*8kB 
1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 3992kB
Feb 24 04:35:17 [kernel] [36186.565297] Node 0 DMA32: 1*4kB 1*8kB 
0*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 
0*4096kB = 1516kB
Feb 24 04:35:17 [kernel] [36186.565310] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:17 [kernel] [36186.565313] Free swap  = 8835648kB
Feb 24 04:35:17 [kernel] [36186.565316] Total swap = 8835740kB
Feb 24 04:35:17 [kernel] [36186.565319] Free swap:       8835648kB
Feb 24 04:35:17 [kernel] [36186.572843] 261984 pages of RAM
Feb 24 04:35:17 [kernel] [36186.572846] 70621 reserved pages
Feb 24 04:35:17 [kernel] [36186.572849] 31066 pages shared
Feb 24 04:35:17 [kernel] [36186.572851] 0 pages swap cached
Feb 24 04:35:17 [kernel] [36186.572863] swapper: page allocation 
failure. order:2, mode:0x20
Feb 24 04:35:17 [kernel] [36186.572866]
Feb 24 04:35:17 [kernel] [36186.572867] Call Trace:
Feb 24 04:35:17 [kernel] [36186.572869]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:17 [kernel] [36186.572885]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.572892]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.572898]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:17 [kernel] [36186.572905]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:17 [kernel] [36186.572913]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:17 [kernel] [36186.572921]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:17 [kernel] [36186.572933]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:17 [kernel] [36186.572945]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:17 [kernel] [36186.572955]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:17 [kernel] [36186.572962]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:17 [kernel] [36186.572969]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:17 [kernel] [36186.572976]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:17 [kernel] [36186.572983]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:17 [kernel] [36186.572989]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:17 [kernel] [36186.572995]  [<ffffffff80162b34>] 
default_idle+0x0/0x3d
Feb 24 04:35:17 [kernel] [36186.573000]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:17 [kernel] [36186.573003]  <EOI>  [<ffffffff80162b5d>] 
default_idle+0x29/0x3d
Feb 24 04:35:17 [kernel] [36186.573016]  [<ffffffff801444dd>] 
cpu_idle+0x8b/0xae
Feb 24 04:35:17 [kernel] [36186.573022]  [<ffffffff804786dc>] 
start_kernel+0x218/0x21d
Feb 24 04:35:17 [kernel] [36186.573029]  [<ffffffff8047815c>] 
_sinittext+0x15c/0x160
Feb 24 04:35:17 [kernel] [36186.573033]
Feb 24 04:35:17 [kernel] [36186.573034] Mem-info:
Feb 24 04:35:17 [kernel] [36186.573036] Node 0 DMA per-cpu:
Feb 24 04:35:17 [kernel] [36186.573041] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:17 [kernel] [36186.573044] Node 0 DMA32 per-cpu:
Feb 24 04:35:17 [kernel] [36186.573048] CPU    0: Hot: hi:  186, 
btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  52
Feb 24 04:35:17 [kernel] [36186.573056] Active:12732 inactive:16626 
dirty:20 writeback:0 unstable:0 free:1377 slab:25974 mapped:1106 
pagetables:230
Feb 24 04:35:17 [kernel] [36186.573059] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? yes
Feb 24 04:35:17 [kernel] [36186.573079] lowmem_reserve[]: 0 0 0
Feb 24 04:35:17 [kernel] [36186.573082] Node 0 DMA: 0*4kB 1*8kB 
1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 3992kB
Feb 24 04:35:17 [kernel] [36186.573093] Node 0 DMA32: 1*4kB 1*8kB 
0*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 
0*4096kB = 1516kB
Feb 24 04:35:17 [kernel] [36186.573105] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:17 [kernel] [36186.573109] Free swap  = 8835648kB
Feb 24 04:35:17 [kernel] [36186.573112] Total swap = 8835740kB
Feb 24 04:35:17 [kernel] [36186.573114] Free swap:       8835648kB
Feb 24 04:35:17 [kernel] [36186.580639] 261984 pages of RAM
Feb 24 04:35:17 [kernel] [36186.580642] 70621 reserved pages
Feb 24 04:35:17 [kernel] [36186.580644] 31066 pages shared
Feb 24 04:35:17 [kernel] [36186.580647] 0 pages swap cached
Feb 24 04:35:17 [kernel] [36186.580659] swapper: page allocation 
failure. order:2, mode:0x20
Feb 24 04:35:17 [kernel] [36186.580662]
Feb 24 04:35:17 [kernel] [36186.580663] Call Trace:
Feb 24 04:35:17 [kernel] [36186.580665]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:17 [kernel] [36186.580681]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.580687]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.580694]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:17 [kernel] [36186.580701]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:17 [kernel] [36186.580708]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:17 [kernel] [36186.580717]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:17 [kernel] [36186.580729]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:17 [kernel] [36186.580741]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:17 [kernel] [36186.580750]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:17 [kernel] [36186.580757]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:17 [kernel] [36186.580764]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:17 [kernel] [36186.580772]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:17 [kernel] [36186.580779]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:17 [kernel] [36186.580784]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:17 [kernel] [36186.580790]  [<ffffffff80162b34>] 
default_idle+0x0/0x3d
Feb 24 04:35:17 [kernel] [36186.580795]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:17 [kernel] [36186.580798]  <EOI>  [<ffffffff80162b5d>] 
default_idle+0x29/0x3d
Feb 24 04:35:17 [kernel] [36186.580811]  [<ffffffff801444dd>] 
cpu_idle+0x8b/0xae
Feb 24 04:35:17 [kernel] [36186.580817]  [<ffffffff804786dc>] 
start_kernel+0x218/0x21d
Feb 24 04:35:17 [kernel] [36186.580824]  [<ffffffff8047815c>] 
_sinittext+0x15c/0x160
Feb 24 04:35:17 [kernel] [36186.580828]
Feb 24 04:35:17 [kernel] [36186.580829] Mem-info:
Feb 24 04:35:17 [kernel] [36186.580831] Node 0 DMA per-cpu:
Feb 24 04:35:17 [kernel] [36186.580836] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:17 [kernel] [36186.580839] Node 0 DMA32 per-cpu:
Feb 24 04:35:17 [kernel] [36186.580843] CPU    0: Hot: hi:  186, 
btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  52
Feb 24 04:35:17 [kernel] [36186.580851] Active:12732 inactive:16626 
dirty:20 writeback:0 unstable:0 free:1377 slab:25974 mapped:1106 
pagetables:230
Feb 24 04:35:17 [kernel] [36186.580855] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? yes
Feb 24 04:35:17 [kernel] [36186.580862] lowmem_reserve[]: 0 993 993
Feb 24 04:35:17 [kernel] [36186.580866] Node 0 DMA32 free:1516kB 
min:4008kB low:5008kB high:6012kB active:50928kB inactive:66504kB 
present:1017452kB pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:17 [kernel] [36186.580874] lowmem_reserve[]: 0 0 0
Feb 24 04:35:17 [kernel] [36186.580877] Node 0 DMA: 0*4kB 1*8kB 
1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 3992kB
Feb 24 04:35:17 [kernel] [36186.580888] Node 0 DMA32: 1*4kB 1*8kB 
0*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 
0*4096kB = 1516kB
Feb 24 04:35:17 [kernel] [36186.580901] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:17 [kernel] [36186.580904] Free swap  = 8835648kB
Feb 24 04:35:17 [kernel] [36186.580907] Total swap = 8835740kB
Feb 24 04:35:17 [kernel] [36186.580910] Free swap:       8835648kB
Feb 24 04:35:17 [kernel] [36186.588434] 261984 pages of RAM
Feb 24 04:35:17 [kernel] [36186.588437] 70621 reserved pages
Feb 24 04:35:17 [kernel] [36186.588439] 31066 pages shared
Feb 24 04:35:17 [kernel] [36186.588442] 0 pages swap cached
Feb 24 04:35:17 [kernel] [36186.588453] swapper: page allocation 
failure. order:2, mode:0x20
Feb 24 04:35:17 [kernel] [36186.588456]
Feb 24 04:35:17 [kernel] [36186.588458] Call Trace:
Feb 24 04:35:17 [kernel] [36186.588460]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:17 [kernel] [36186.588475]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.588482]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.588503]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:17 [kernel] [36186.588512]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:17 [kernel] [36186.588524]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:17 [kernel] [36186.588536]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:17 [kernel] [36186.588545]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:17 [kernel] [36186.588552]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:17 [kernel] [36186.588559]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:17 [kernel] [36186.588566]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:17 [kernel] [36186.588574]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:17 [kernel] [36186.588579]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:17 [kernel] [36186.588585]  [<ffffffff80162b34>] 
default_idle+0x0/0x3d
Feb 24 04:35:17 [kernel] [36186.588590]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:17 [kernel] [36186.588593]  <EOI>  [<ffffffff80162b5d>] 
default_idle+0x29/0x3d
Feb 24 04:35:17 [kernel] [36186.588606]  [<ffffffff801444dd>] 
cpu_idle+0x8b/0xae
Feb 24 04:35:17 [kernel] [36186.588612]  [<ffffffff804786dc>] 
start_kernel+0x218/0x21d
Feb 24 04:35:17 [kernel] [36186.588619]  [<ffffffff8047815c>] 
_sinittext+0x15c/0x160
Feb 24 04:35:17 [kernel] [36186.588623]
Feb 24 04:35:17 [kernel] [36186.588624] Mem-info:
Feb 24 04:35:17 [kernel] [36186.588626] Node 0 DMA per-cpu:
Feb 24 04:35:17 [kernel] [36186.588631] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:17 [kernel] [36186.588634] Node 0 DMA32 per-cpu:
Feb 24 04:35:17 [kernel] [36186.588639] CPU    0: Hot: hi:  186, 
btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  52
Feb 24 04:35:17 [kernel] [36186.588646] Active:12732 inactive:16626 
dirty:20 writeback:0 unstable:0 free:1377 slab:25974 mapped:1106 
pagetables:230
Feb 24 04:35:17 [kernel] [36186.588649] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? yes
Feb 24 04:35:17 [kernel] [36186.588657] lowmem_reserve[]: 0 993 993
Feb 24 04:35:17 [kernel] [36186.588660] Node 0 DMA32 free:1516kB 
min:4008kB low:5008kB high:6012kB active:50928kB inactive:66504kB 
present:1017452kB pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:17 [kernel] [36186.588669] lowmem_reserve[]: 0 0 0
Feb 24 04:35:17 [kernel] [36186.588672] Node 0 DMA: 0*4kB 1*8kB 
1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 3992kB
Feb 24 04:35:17 [kernel] [36186.588683] Node 0 DMA32: 1*4kB 1*8kB 
0*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 
0*4096kB = 1516kB
Feb 24 04:35:17 [kernel] [36186.588696] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:17 [kernel] [36186.588699] Free swap  = 8835648kB
Feb 24 04:35:17 [kernel] [36186.588702] Total swap = 8835740kB
Feb 24 04:35:17 [kernel] [36186.588705] Free swap:       8835648kB
Feb 24 04:35:17 [kernel] [36186.596229] 261984 pages of RAM
Feb 24 04:35:17 [kernel] [36186.596232] 70621 reserved pages
Feb 24 04:35:17 [kernel] [36186.596234] 31066 pages shared
Feb 24 04:35:17 [kernel] [36186.596237] 0 pages swap cached
Feb 24 04:35:17 [kernel] [36186.596249] swapper: page allocation 
failure. order:2, mode:0x20
Feb 24 04:35:17 [kernel] [36186.596252]
Feb 24 04:35:17 [kernel] [36186.596253] Call Trace:
Feb 24 04:35:17 [kernel] [36186.596255]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:17 [kernel] [36186.596271]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.596278]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.596284]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:17 [kernel] [36186.596291]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:17 [kernel] [36186.596298]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:17 [kernel] [36186.596307]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:17 [kernel] [36186.596319]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:17 [kernel] [36186.596331]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:17 [kernel] [36186.596340]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:17 [kernel] [36186.596347]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:17 [kernel] [36186.596354]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:17 [kernel] [36186.596362]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:17 [kernel] [36186.596369]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:17 [kernel] [36186.596375]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:17 [kernel] [36186.596380]  [<ffffffff80162b34>] 
default_idle+0x0/0x3d
Feb 24 04:35:17 [kernel] [36186.596386]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:17 [kernel] [36186.596389]  <EOI>  [<ffffffff80162b5d>] 
default_idle+0x29/0x3d
Feb 24 04:35:17 [kernel] [36186.596401]  [<ffffffff801444dd>] 
cpu_idle+0x8b/0xae
Feb 24 04:35:17 [kernel] [36186.596408]  [<ffffffff804786dc>] 
start_kernel+0x218/0x21d
Feb 24 04:35:17 [kernel] [36186.596414]  [<ffffffff8047815c>] 
_sinittext+0x15c/0x160
Feb 24 04:35:17 [kernel] [36186.596418]
Feb 24 04:35:17 [kernel] [36186.596420] Mem-info:
Feb 24 04:35:17 [kernel] [36186.596422] Node 0 DMA per-cpu:
Feb 24 04:35:17 [kernel] [36186.596429] Node 0 DMA32 per-cpu:
Feb 24 04:35:17 [kernel] [36186.596434] CPU    0: Hot: hi:  186, 
btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  52
Feb 24 04:35:17 [kernel] [36186.596441] Active:12732 inactive:16626 
dirty:20 writeback:0 unstable:0 free:1377 slab:25974 mapped:1106 
pagetables:230
Feb 24 04:35:17 [kernel] [36186.596445] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? yes
Feb 24 04:35:17 [kernel] [36186.596452] lowmem_reserve[]: 0 993 993
Feb 24 04:35:17 [kernel] [36186.596456] Node 0 DMA32 free:1516kB 
min:4008kB low:5008kB high:6012kB active:50928kB inactive:66504kB 
present:1017452kB pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:17 [kernel] [36186.596464] lowmem_reserve[]: 0 0 0
Feb 24 04:35:17 [kernel] [36186.596467] Node 0 DMA: 0*4kB 1*8kB 
1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 3992kB
Feb 24 04:35:17 [kernel] [36186.596478] Node 0 DMA32: 1*4kB 1*8kB 
0*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 
0*4096kB = 1516kB
Feb 24 04:35:17 [kernel] [36186.596491] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:17 [kernel] [36186.596494] Free swap  = 8835648kB
Feb 24 04:35:17 [kernel] [36186.596497] Total swap = 8835740kB
Feb 24 04:35:17 [kernel] [36186.596500] Free swap:       8835648kB
Feb 24 04:35:17 [kernel] [36186.604025] 261984 pages of RAM
Feb 24 04:35:17 [kernel] [36186.604028] 70621 reserved pages
Feb 24 04:35:17 [kernel] [36186.604031] 31066 pages shared
Feb 24 04:35:17 [kernel] [36186.604033] 0 pages swap cached
Feb 24 04:35:17 [kernel] [36186.604045] swapper: page allocation 
failure. order:2, mode:0x20
Feb 24 04:35:17 [kernel] [36186.604048]
Feb 24 04:35:17 [kernel] [36186.604049] Call Trace:
Feb 24 04:35:17 [kernel] [36186.604051]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:17 [kernel] [36186.604066]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.604073]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:17 [kernel] [36186.604080]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:17 [kernel] [36186.604087]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:17 [kernel] [36186.604094]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:17 [kernel] [36186.604103]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:17 [kernel] [36186.604115]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:17 [kernel] [36186.604127]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:17 [kernel] [36186.604136]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:17 [kernel] [36186.604143]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:17 [kernel] [36186.604150]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:17 [kernel] [36186.604158]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:17 [kernel] [36186.604165]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:17 [kernel] [36186.604170]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:17 [kernel] [36186.604176]  [<ffffffff80162b34>] 
default_idle+0x0/0x3d
Feb 24 04:35:17 [kernel] [36186.604182]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:17 [kernel] [36186.604184]  <EOI>  [<ffffffff80162b5d>] 
default_idle+0x29/0x3d
Feb 24 04:35:17 [kernel] [36186.604197]  [<ffffffff801444dd>] 
cpu_idle+0x8b/0xae
Feb 24 04:35:17 [kernel] [36186.604204]  [<ffffffff804786dc>] 
start_kernel+0x218/0x21d
Feb 24 04:35:17 [kernel] [36186.604210]  [<ffffffff8047815c>] 
_sinittext+0x15c/0x160
Feb 24 04:35:17 [kernel] [36186.604214]
Feb 24 04:35:17 [kernel] [36186.604216] Mem-info:
Feb 24 04:35:17 [kernel] [36186.604218] Node 0 DMA per-cpu:
Feb 24 04:35:17 [kernel] [36186.604222] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:17 [kernel] [36186.604225] Node 0 DMA32 per-cpu:
Feb 24 04:35:17 [kernel] [36186.604230] CPU    0: Hot: hi:  186, 
btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  52
Feb 24 04:35:17 [kernel] [36186.604237] Active:12732 inactive:16626 
dirty:20 writeback:0 unstable:0 free:1377 slab:25974 mapped:1106 
pagetables:230
Feb 24 04:35:17 [kernel] [36186.604241] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? yes
Feb 24 04:35:17 [kernel] [36186.604248] lowmem_reserve[]: 0 993 993
Feb 24 04:35:17 [kernel] [36186.604252] Node 0 DMA32 free:1516kB 
min:4008kB low:5008kB high:6012kB active:50928kB inactive:66504kB 
present:1017452kB pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:17 [kernel] [36186.604260] lowmem_reserve[]: 0 0 0
Feb 24 04:35:17 [kernel] [36186.604263] Node 0 DMA: 0*4kB 1*8kB 
1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 3992kB
Feb 24 04:35:17 [kernel] [36186.604274] Node 0 DMA32: 1*4kB 1*8kB 
0*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 
0*4096kB = 1516kB
Feb 24 04:35:17 [kernel] [36186.604287] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:17 [kernel] [36186.604290] Free swap  = 8835648kB
Feb 24 04:35:17 [kernel] [36186.604293] Total swap = 8835740kB
Feb 24 04:35:17 [kernel] [36186.604296] Free swap:       8835648kB
Feb 24 04:35:17 [kernel] [36186.611822] 70621 reserved pages
Feb 24 04:35:17 [kernel] [36186.611825] 31066 pages shared
Feb 24 04:35:17 [kernel] [36186.611827] 0 pages swap cached
Feb 24 04:35:59 [kernel] [36229.235033] printk: 66 messages suppressed.
Feb 24 04:35:59 [kernel] [36229.235040] swapper: page allocation 
failure. order:2, mode:0x20
Feb 24 04:35:59 [kernel] [36229.235044]
Feb 24 04:35:59 [kernel] [36229.235046] Call Trace:
Feb 24 04:35:59 [kernel] [36229.235049]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:59 [kernel] [36229.235071]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:59 [kernel] [36229.235078]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:59 [kernel] [36229.235085]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:59 [kernel] [36229.235092]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:59 [kernel] [36229.235100]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:59 [kernel] [36229.235109]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:59 [kernel] [36229.235127]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:59 [kernel] [36229.235140]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:59 [kernel] [36229.235150]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:59 [kernel] [36229.235157]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:59 [kernel] [36229.235165]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:59 [kernel] [36229.235173]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:59 [kernel] [36229.235180]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:59 [kernel] [36229.235186]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:59 [kernel] [36229.235192]  [<ffffffff80162b34>] 
default_idle+0x0/0x3d
Feb 24 04:35:59 [kernel] [36229.235198]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:59 [kernel] [36229.235201]  <EOI>  [<ffffffff80162b5d>] 
default_idle+0x29/0x3d
Feb 24 04:35:59 [kernel] [36229.235214]  [<ffffffff801444dd>] 
cpu_idle+0x8b/0xae
Feb 24 04:35:59 [kernel] [36229.235222]  [<ffffffff804786dc>] 
start_kernel+0x218/0x21d
Feb 24 04:35:59 [kernel] [36229.235228]  [<ffffffff8047815c>] 
_sinittext+0x15c/0x160
Feb 24 04:35:59 [kernel] [36229.235232]
Feb 24 04:35:59 [kernel] [36229.235234] Mem-info:
Feb 24 04:35:59 [kernel] [36229.235237] Node 0 DMA per-cpu:
Feb 24 04:35:59 [kernel] [36229.235242] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:59 [kernel] [36229.235245] Node 0 DMA32 per-cpu:
Feb 24 04:35:59 [kernel] [36229.235250] CPU    0: Hot: hi:  186, 
btch:  31 usd: 104   Cold: hi:   62, btch:  15 usd:  51
Feb 24 04:35:59 [kernel] [36229.235258] Active:9442 inactive:14275 
dirty:0 writeback:0 unstable:0 free:1377 slab:19499 mapped:1106 
pagetables:230
Feb 24 04:35:59 [kernel] [36229.235262] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:59 [kernel] [36229.235269] lowmem_reserve[]: 0 993 993
Feb 24 04:35:59 [kernel] [36229.235273] Node 0 DMA32 free:1516kB 
min:4008kB low:5008kB high:6012kB active:37768kB inactive:57100kB 
present:1017452kB pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:59 [kernel] [36229.235282] lowmem_reserve[]: 0 0 0
Feb 24 04:35:59 [kernel] [36229.235285] Node 0 DMA: 0*4kB 1*8kB 
1*16kB 4*32kB 0*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 3992kB
Feb 24 04:35:59 [kernel] [36229.235297] Node 0 DMA32: 61*4kB 1*8kB 
1*16kB 1*32kB 1*64kB 1*128kB 0*256kB 2*512kB 0*1024kB 0*2048kB 
0*4096kB = 1516kB
Feb 24 04:35:59 [kernel] [36229.235310] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:59 [kernel] [36229.235313] Free swap  = 8835648kB
Feb 24 04:35:59 [kernel] [36229.235316] Total swap = 8835740kB
Feb 24 04:35:59 [kernel] [36229.235319] Free swap:       8835648kB
Feb 24 04:35:59 [kernel] [36229.243588] 261984 pages of RAM
Feb 24 04:35:59 [kernel] [36229.243592] 70621 reserved pages
Feb 24 04:35:59 [kernel] [36229.243594] 25468 pages shared
Feb 24 04:35:59 [kernel] [36229.243596] 0 pages swap cached
Feb 24 04:35:59 [kernel] [36229.243625] swapper: page allocation 
failure. order:2, mode:0x20
Feb 24 04:35:59 [kernel] [36229.243628]
Feb 24 04:35:59 [kernel] [36229.243629] Call Trace:
Feb 24 04:35:59 [kernel] [36229.243631]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:59 [kernel] [36229.243648]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:59 [kernel] [36229.243655]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:59 [kernel] [36229.243661]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:59 [kernel] [36229.243669]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:59 [kernel] [36229.243676]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:59 [kernel] [36229.243684]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:59 [kernel] [36229.243698]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:59 [kernel] [36229.243710]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:59 [kernel] [36229.243719]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:59 [kernel] [36229.243726]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:59 [kernel] [36229.243734]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:59 [kernel] [36229.243742]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:59 [kernel] [36229.243749]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:59 [kernel] [36229.243754]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:59 [kernel] [36229.243766]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:59 [kernel] [36229.243769]  <EOI>  [<ffffffff80162b5d>] 
default_idle+0x29/0x3d
Feb 24 04:35:59 [kernel] [36229.243782]  [<ffffffff801444dd>] 
cpu_idle+0x8b/0xae
Feb 24 04:35:59 [kernel] [36229.243789]  [<ffffffff804786dc>] 
start_kernel+0x218/0x21d
Feb 24 04:35:59 [kernel] [36229.243795]  [<ffffffff8047815c>] 
_sinittext+0x15c/0x160
Feb 24 04:35:59 [kernel] [36229.243799]
Feb 24 04:35:59 [kernel] [36229.243801] Mem-info:
Feb 24 04:35:59 [kernel] [36229.243803] Node 0 DMA per-cpu:
Feb 24 04:35:59 [kernel] [36229.243807] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:59 [kernel] [36229.243811] Node 0 DMA32 per-cpu:
Feb 24 04:35:59 [kernel] [36229.243815] CPU    0: Hot: hi:  186, 
btch:  31 usd: 104   Cold: hi:   62, btch:  15 usd:  51
Feb 24 04:35:59 [kernel] [36229.243822] Active:9442 inactive:14275 
dirty:0 writeback:0 unstable:0 free:1377 slab:19499 mapped:1106 
pagetables:230
Feb 24 04:35:59 [kernel] [36229.243826] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:59 [kernel] [36229.243833] lowmem_reserve[]: 0 993 993
Feb 24 04:35:59 [kernel] [36229.243837] Node 0 DMA32 free:1516kB 
min:4008kB low:5008kB high:6012kB active:37768kB inactive:57100kB 
present:1017452kB pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:59 [kernel] [36229.243845] lowmem_reserve[]: 0 0 0
Feb 24 04:35:59 [kernel] [36229.243849] Node 0 DMA: 0*4kB 1*8kB 
1*16kB 4*32kB 0*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 3992kB
Feb 24 04:35:59 [kernel] [36229.243860] Node 0 DMA32: 61*4kB 1*8kB 
1*16kB 1*32kB 1*64kB 1*128kB 0*256kB 2*512kB 0*1024kB 0*2048kB 
0*4096kB = 1516kB
Feb 24 04:35:59 [kernel] [36229.243873] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:59 [kernel] [36229.243876] Free swap  = 8835648kB
Feb 24 04:35:59 [kernel] [36229.243879] Total swap = 8835740kB
Feb 24 04:35:59 [kernel] [36229.243882] Free swap:       8835648kB
Feb 24 04:35:59 [kernel] [36229.251730] 261984 pages of RAM
Feb 24 04:35:59 [kernel] [36229.251733] 70621 reserved pages
Feb 24 04:35:59 [kernel] [36229.251735] 25468 pages shared
Feb 24 04:35:59 [kernel] [36229.251738] 0 pages swap cached
Feb 24 04:35:59 [kernel] [36229.251759] swapper: page allocation 
failure. order:2, mode:0x20
Feb 24 04:35:59 [kernel] [36229.251762]
Feb 24 04:35:59 [kernel] [36229.251763] Call Trace:
Feb 24 04:35:59 [kernel] [36229.251765]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:59 [kernel] [36229.251782]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:59 [kernel] [36229.251788]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:59 [kernel] [36229.251795]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:59 [kernel] [36229.251802]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:59 [kernel] [36229.251809]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:59 [kernel] [36229.251818]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:59 [kernel] [36229.251830]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:59 [kernel] [36229.251843]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:59 [kernel] [36229.251852]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:59 [kernel] [36229.251859]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:59 [kernel] [36229.251866]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:59 [kernel] [36229.251874]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:59 [kernel] [36229.251881]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:59 [kernel] [36229.251886]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:59 [kernel] [36229.251892]  [<ffffffff80162b34>] 
default_idle+0x0/0x3d
Feb 24 04:35:59 [kernel] [36229.251898]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:59 [kernel] [36229.251900]  <EOI>  [<ffffffff80162b5d>] 
default_idle+0x29/0x3d
Feb 24 04:35:59 [kernel] [36229.251913]  [<ffffffff801444dd>] 
cpu_idle+0x8b/0xae
Feb 24 04:35:59 [kernel] [36229.251920]  [<ffffffff804786dc>] 
start_kernel+0x218/0x21d
Feb 24 04:35:59 [kernel] [36229.251927]  [<ffffffff8047815c>] 
_sinittext+0x15c/0x160
Feb 24 04:35:59 [kernel] [36229.251931]
Feb 24 04:35:59 [kernel] [36229.251932] Mem-info:
Feb 24 04:35:59 [kernel] [36229.251934] Node 0 DMA per-cpu:
Feb 24 04:35:59 [kernel] [36229.251939] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:59 [kernel] [36229.251942] Node 0 DMA32 per-cpu:
Feb 24 04:35:59 [kernel] [36229.251947] CPU    0: Hot: hi:  186, 
btch:  31 usd: 104   Cold: hi:   62, btch:  15 usd:  51
Feb 24 04:35:59 [kernel] [36229.251954] Active:9442 inactive:14275 
dirty:0 writeback:0 unstable:0 free:1377 slab:19499 mapped:1106 
pagetables:230
Feb 24 04:35:59 [kernel] [36229.251958] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:59 [kernel] [36229.251965] lowmem_reserve[]: 0 993 993
Feb 24 04:35:59 [kernel] [36229.251977] lowmem_reserve[]: 0 0 0
Feb 24 04:35:59 [kernel] [36229.252007] Free swap  = 8835648kB
Feb 24 04:35:59 [kernel] [36229.252010] Total swap = 8835740kB
Feb 24 04:35:59 [kernel] [36229.252013] Free swap:       8835648kB
Feb 24 04:35:59 [kernel] [36229.259729] 261984 pages of RAM
Feb 24 04:35:59 [kernel] [36229.259732] 70621 reserved pages
Feb 24 04:35:59 [kernel] [36229.259735] 25468 pages shared
Feb 24 04:35:59 [kernel] [36229.259737] 0 pages swap cached
Feb 24 04:35:59 [kernel] [36229.260143] drbd3_asender: page 
allocation failure. order:2, mode:0x20
Feb 24 04:35:59 [kernel] [36229.260146]
Feb 24 04:35:59 [kernel] [36229.260147] Call Trace:
Feb 24 04:35:59 [kernel] [36229.260150]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:59 [kernel] [36229.260167]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:59 [kernel] [36229.260174]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:59 [kernel] [36229.260181]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:59 [kernel] [36229.260188]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:59 [kernel] [36229.260196]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:59 [kernel] [36229.260205]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:59 [kernel] [36229.260217]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:59 [kernel] [36229.260230]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:59 [kernel] [36229.260239]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:59 [kernel] [36229.260246]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:59 [kernel] [36229.260254]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:59 [kernel] [36229.260262]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:59 [kernel] [36229.260269]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:59 [kernel] [36229.260275]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:59 [kernel] [36229.260281]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:59 [kernel] [36229.260284]  <EOI>  [<ffffffff8015c71c>] 
_spin_lock_irqsave+0x2/0x24
Feb 24 04:35:59 [kernel] [36229.260297]  [<ffffffff8012ad65>] 
__wake_up+0x22/0x4f
Feb 24 04:35:59 [kernel] [36229.260320]  [<ffffffff880ae842>] 
:drbd:drbd_free_ee+0x69/0xbe
Feb 24 04:35:59 [kernel] [36229.260337]  [<ffffffff880af05f>] 
:drbd:drbd_process_done_ee+0xe0/0x11d
Feb 24 04:35:59 [kernel] [36229.260355]  [<ffffffff880b0dbd>] 
:drbd:drbd_asender+0xc9/0x541
Feb 24 04:35:59 [kernel] [36229.260374]  [<ffffffff880bd876>] 
:drbd:drbd_thread_setup+0x99/0xde
Feb 24 04:35:59 [kernel] [36229.260381]  [<ffffffff801589b8>] 
child_rip+0xa/0x12
Feb 24 04:35:59 [kernel] [36229.260400]  [<ffffffff880bd7dd>] 
:drbd:drbd_thread_setup+0x0/0xde
Feb 24 04:35:59 [kernel] [36229.260406]  [<ffffffff801589ae>] 
child_rip+0x0/0x12
Feb 24 04:35:59 [kernel] [36229.260410]
Feb 24 04:35:59 [kernel] [36229.260412] Mem-info:
Feb 24 04:35:59 [kernel] [36229.260414] Node 0 DMA per-cpu:
Feb 24 04:35:59 [kernel] [36229.260418] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:59 [kernel] [36229.260422] Node 0 DMA32 per-cpu:
Feb 24 04:35:59 [kernel] [36229.260427] CPU    0: Hot: hi:  186, 
btch:  31 usd: 104   Cold: hi:   62, btch:  15 usd:  51
Feb 24 04:35:59 [kernel] [36229.260434] Active:9442 inactive:14275 
dirty:0 writeback:0 unstable:0 free:1377 slab:19499 mapped:1106 
pagetables:230
Feb 24 04:35:59 [kernel] [36229.260438] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:59 [kernel] [36229.260445] lowmem_reserve[]: 0 993 993
Feb 24 04:35:59 [kernel] [36229.260449] Node 0 DMA32 free:1516kB 
min:4008kB low:5008kB high:6012kB active:37768kB inactive:57100kB 
present:1017452kB pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:59 [kernel] [36229.260458] lowmem_reserve[]: 0 0 0
Feb 24 04:35:59 [kernel] [36229.260461] Node 0 DMA: 0*4kB 1*8kB 
1*16kB 4*32kB 0*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 3992kB
Feb 24 04:35:59 [kernel] [36229.260473] Node 0 DMA32: 61*4kB 1*8kB 
1*16kB 1*32kB 1*64kB 1*128kB 0*256kB 2*512kB 0*1024kB 0*2048kB 
0*4096kB = 1516kB
Feb 24 04:35:59 [kernel] [36229.260487] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:59 [kernel] [36229.260490] Free swap  = 8835648kB
Feb 24 04:35:59 [kernel] [36229.260493] Total swap = 8835740kB
Feb 24 04:35:59 [kernel] [36229.260496] Free swap:       8835648kB
Feb 24 04:35:59 [kernel] [36229.268579] 261984 pages of RAM
Feb 24 04:35:59 [kernel] [36229.268582] 70621 reserved pages
Feb 24 04:35:59 [kernel] [36229.268585] 25468 pages shared
Feb 24 04:35:59 [kernel] [36229.268587] 0 pages swap cached
Feb 24 04:35:59 [kernel] [36229.268616] drbd3_asender: page 
allocation failure. order:2, mode:0x20
Feb 24 04:35:59 [kernel] [36229.268619]
Feb 24 04:35:59 [kernel] [36229.268620] Call Trace:
Feb 24 04:35:59 [kernel] [36229.268623]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:59 [kernel] [36229.268639]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:59 [kernel] [36229.268646]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:59 [kernel] [36229.268653]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:59 [kernel] [36229.268660]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:59 [kernel] [36229.268668]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:59 [kernel] [36229.268690]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:59 [kernel] [36229.268702]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:59 [kernel] [36229.268711]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:59 [kernel] [36229.268718]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:59 [kernel] [36229.268726]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:59 [kernel] [36229.268734]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:59 [kernel] [36229.268741]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:59 [kernel] [36229.268747]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:59 [kernel] [36229.268753]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:59 [kernel] [36229.268756]  <EOI>  [<ffffffff8015c71c>] 
_spin_lock_irqsave+0x2/0x24
Feb 24 04:35:59 [kernel] [36229.268769]  [<ffffffff8012ad65>] 
__wake_up+0x22/0x4f
Feb 24 04:35:59 [kernel] [36229.268790]  [<ffffffff880ae842>] 
:drbd:drbd_free_ee+0x69/0xbe
Feb 24 04:35:59 [kernel] [36229.268807]  [<ffffffff880af05f>] 
:drbd:drbd_process_done_ee+0xe0/0x11d
Feb 24 04:35:59 [kernel] [36229.268825]  [<ffffffff880b0dbd>] 
:drbd:drbd_asender+0xc9/0x541
Feb 24 04:35:59 [kernel] [36229.268844]  [<ffffffff880bd876>] 
:drbd:drbd_thread_setup+0x99/0xde
Feb 24 04:35:59 [kernel] [36229.268851]  [<ffffffff801589b8>] 
child_rip+0xa/0x12
Feb 24 04:35:59 [kernel] [36229.268870]  [<ffffffff880bd7dd>] 
:drbd:drbd_thread_setup+0x0/0xde
Feb 24 04:35:59 [kernel] [36229.268876]  [<ffffffff801589ae>] 
child_rip+0x0/0x12
Feb 24 04:35:59 [kernel] [36229.268880]
Feb 24 04:35:59 [kernel] [36229.268882] Mem-info:
Feb 24 04:35:59 [kernel] [36229.268884] Node 0 DMA per-cpu:
Feb 24 04:35:59 [kernel] [36229.268888] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:59 [kernel] [36229.268892] Node 0 DMA32 per-cpu:
Feb 24 04:35:59 [kernel] [36229.268897] CPU    0: Hot: hi:  186, 
btch:  31 usd: 104   Cold: hi:   62, btch:  15 usd:  51
Feb 24 04:35:59 [kernel] [36229.268904] Active:9442 inactive:14275 
dirty:0 writeback:0 unstable:0 free:1377 slab:19499 mapped:1106 
pagetables:230
Feb 24 04:35:59 [kernel] [36229.268908] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:59 [kernel] [36229.268915] lowmem_reserve[]: 0 993 993
Feb 24 04:35:59 [kernel] [36229.268919] Node 0 DMA32 free:1516kB 
min:4008kB low:5008kB high:6012kB active:37768kB inactive:57100kB 
present:1017452kB pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:59 [kernel] [36229.268928] lowmem_reserve[]: 0 0 0
Feb 24 04:35:59 [kernel] [36229.268931] Node 0 DMA: 0*4kB 1*8kB 
1*16kB 4*32kB 0*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 3992kB
Feb 24 04:35:59 [kernel] [36229.268944] Node 0 DMA32: 61*4kB 1*8kB 
1*16kB 1*32kB 1*64kB 1*128kB 0*256kB 2*512kB 0*1024kB 0*2048kB 
0*4096kB = 1516kB
Feb 24 04:35:59 [kernel] [36229.268957] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:59 [kernel] [36229.268961] Free swap  = 8835648kB
Feb 24 04:35:59 [kernel] [36229.268964] Total swap = 8835740kB
Feb 24 04:35:59 [kernel] [36229.268966] Free swap:       8835648kB
Feb 24 04:35:59 [kernel] [36229.276949] 261984 pages of RAM
Feb 24 04:35:59 [kernel] [36229.276953] 70621 reserved pages
Feb 24 04:35:59 [kernel] [36229.276955] 25468 pages shared
Feb 24 04:35:59 [kernel] [36229.276958] 0 pages swap cached
Feb 24 04:35:59 [kernel] [36229.276982] drbd3_asender: page 
allocation failure. order:2, mode:0x20
Feb 24 04:35:59 [kernel] [36229.276985]
Feb 24 04:35:59 [kernel] [36229.276986] Call Trace:
Feb 24 04:35:59 [kernel] [36229.276989]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:59 [kernel] [36229.277005]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:59 [kernel] [36229.277012]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:59 [kernel] [36229.277018]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:59 [kernel] [36229.277026]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:59 [kernel] [36229.277033]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:59 [kernel] [36229.277042]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:59 [kernel] [36229.277054]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:59 [kernel] [36229.277066]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:59 [kernel] [36229.277076]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:59 [kernel] [36229.277083]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:59 [kernel] [36229.277090]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:59 [kernel] [36229.277098]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:59 [kernel] [36229.277105]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:59 [kernel] [36229.277111]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:59 [kernel] [36229.277117]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:59 [kernel] [36229.277120]  <EOI>  [<ffffffff8015c71c>] 
_spin_lock_irqsave+0x2/0x24
Feb 24 04:35:59 [kernel] [36229.277133]  [<ffffffff8012ad65>] 
__wake_up+0x22/0x4f
Feb 24 04:35:59 [kernel] [36229.277154]  [<ffffffff880ae842>] 
:drbd:drbd_free_ee+0x69/0xbe
Feb 24 04:35:59 [kernel] [36229.277215]  [<ffffffff801589b8>] 
child_rip+0xa/0x12
Feb 24 04:35:59 [kernel] [36229.277234]  [<ffffffff880bd7dd>] 
:drbd:drbd_thread_setup+0x0/0xde
Feb 24 04:35:59 [kernel] [36229.277240]  [<ffffffff801589ae>] 
child_rip+0x0/0x12
Feb 24 04:35:59 [kernel] [36229.277244]
Feb 24 04:35:59 [kernel] [36229.277245] Mem-info:
Feb 24 04:35:59 [kernel] [36229.277248] Node 0 DMA per-cpu:
Feb 24 04:35:59 [kernel] [36229.277252] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:59 [kernel] [36229.277255] Node 0 DMA32 per-cpu:
Feb 24 04:35:59 [kernel] [36229.277260] CPU    0: Hot: hi:  186, 
btch:  31 usd: 104   Cold: hi:   62, btch:  15 usd:  51
Feb 24 04:35:59 [kernel] [36229.277267] Active:9442 inactive:14275 
dirty:0 writeback:0 unstable:0 free:1377 slab:19499 mapped:1106 
pagetables:230
Feb 24 04:35:59 [kernel] [36229.277271] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:59 [kernel] [36229.277279] lowmem_reserve[]: 0 993 993
Feb 24 04:35:59 [kernel] [36229.277283] Node 0 DMA32 free:1516kB 
min:4008kB low:5008kB high:6012kB active:37768kB inactive:57100kB 
present:1017452kB pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:59 [kernel] [36229.277291] lowmem_reserve[]: 0 0 0
Feb 24 04:35:59 [kernel] [36229.277295] Node 0 DMA: 0*4kB 1*8kB 
1*16kB 4*32kB 0*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 3992kB
Feb 24 04:35:59 [kernel] [36229.277307] Node 0 DMA32: 61*4kB 1*8kB 
1*16kB 1*32kB 1*64kB 1*128kB 0*256kB 2*512kB 0*1024kB 0*2048kB 
0*4096kB = 1516kB
Feb 24 04:35:59 [kernel] [36229.277321] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:59 [kernel] [36229.277324] Free swap  = 8835648kB
Feb 24 04:35:59 [kernel] [36229.277327] Total swap = 8835740kB
Feb 24 04:35:59 [kernel] [36229.277330] Free swap:       8835648kB
Feb 24 04:35:59 [kernel] [36229.285268] 261984 pages of RAM
Feb 24 04:35:59 [kernel] [36229.285271] 70621 reserved pages
Feb 24 04:35:59 [kernel] [36229.285274] 25468 pages shared
Feb 24 04:35:59 [kernel] [36229.285277] 0 pages swap cached
Feb 24 04:35:59 [kernel] [36229.285297] drbd3_asender: page 
allocation failure. order:2, mode:0x20
Feb 24 04:35:59 [kernel] [36229.285300]
Feb 24 04:35:59 [kernel] [36229.285301] Call Trace:
Feb 24 04:35:59 [kernel] [36229.285304]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:59 [kernel] [36229.285320]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:59 [kernel] [36229.285327]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:59 [kernel] [36229.285333]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:59 [kernel] [36229.285341]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:59 [kernel] [36229.285348]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:59 [kernel] [36229.285357]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:59 [kernel] [36229.285370]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:59 [kernel] [36229.285382]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:59 [kernel] [36229.285392]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:59 [kernel] [36229.285399]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:59 [kernel] [36229.285406]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:59 [kernel] [36229.285414]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:59 [kernel] [36229.285421]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:59 [kernel] [36229.285427]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:59 [kernel] [36229.285433]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:59 [kernel] [36229.285436]  <EOI>  [<ffffffff8015c71c>] 
_spin_lock_irqsave+0x2/0x24
Feb 24 04:35:59 [kernel] [36229.285449]  [<ffffffff8012ad65>] 
__wake_up+0x22/0x4f
Feb 24 04:35:59 [kernel] [36229.285470]  [<ffffffff880ae842>] 
:drbd:drbd_free_ee+0x69/0xbe
Feb 24 04:35:59 [kernel] [36229.285486]  [<ffffffff880af05f>] 
:drbd:drbd_process_done_ee+0xe0/0x11d
Feb 24 04:35:59 [kernel] [36229.285504]  [<ffffffff880b0dbd>] 
:drbd:drbd_asender+0xc9/0x541
Feb 24 04:35:59 [kernel] [36229.285524]  [<ffffffff880bd876>] 
:drbd:drbd_thread_setup+0x99/0xde
Feb 24 04:35:59 [kernel] [36229.285531]  [<ffffffff801589b8>] 
child_rip+0xa/0x12
Feb 24 04:35:59 [kernel] [36229.285550]  [<ffffffff880bd7dd>] 
:drbd:drbd_thread_setup+0x0/0xde
Feb 24 04:35:59 [kernel] [36229.285556]  [<ffffffff801589ae>] 
child_rip+0x0/0x12
Feb 24 04:35:59 [kernel] [36229.285560]
Feb 24 04:35:59 [kernel] [36229.285561] Mem-info:
Feb 24 04:35:59 [kernel] [36229.285564] Node 0 DMA per-cpu:
Feb 24 04:35:59 [kernel] [36229.285568] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:59 [kernel] [36229.285572] Node 0 DMA32 per-cpu:
Feb 24 04:35:59 [kernel] [36229.285576] CPU    0: Hot: hi:  186, 
btch:  31 usd: 104   Cold: hi:   62, btch:  15 usd:  51
Feb 24 04:35:59 [kernel] [36229.285584] Active:9442 inactive:14275 
dirty:0 writeback:0 unstable:0 free:1377 slab:19499 mapped:1106 
pagetables:230
Feb 24 04:35:59 [kernel] [36229.285587] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:59 [kernel] [36229.285607] lowmem_reserve[]: 0 0 0
Feb 24 04:35:59 [kernel] [36229.285611] Node 0 DMA: 0*4kB 1*8kB 
1*16kB 4*32kB 0*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 3992kB
Feb 24 04:35:59 [kernel] [36229.285623] Node 0 DMA32: 61*4kB 1*8kB 
1*16kB 1*32kB 1*64kB 1*128kB 0*256kB 2*512kB 0*1024kB 0*2048kB 
0*4096kB = 1516kB
Feb 24 04:35:59 [kernel] [36229.285637] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:59 [kernel] [36229.285640] Free swap  = 8835648kB
Feb 24 04:35:59 [kernel] [36229.285643] Total swap = 8835740kB
Feb 24 04:35:59 [kernel] [36229.285646] Free swap:       8835648kB
Feb 24 04:35:59 [kernel] [36229.293487] 261984 pages of RAM
Feb 24 04:35:59 [kernel] [36229.293490] 70621 reserved pages
Feb 24 04:35:59 [kernel] [36229.293493] 25468 pages shared
Feb 24 04:35:59 [kernel] [36229.293495] 0 pages swap cached
Feb 24 04:35:59 [kernel] [36229.293967] drbd3_asender: page 
allocation failure. order:2, mode:0x20
Feb 24 04:35:59 [kernel] [36229.293970]
Feb 24 04:35:59 [kernel] [36229.293971] Call Trace:
Feb 24 04:35:59 [kernel] [36229.293974]  <IRQ>  [<ffffffff8010e7c2>] 
__alloc_pages+0x295/0x2ae
Feb 24 04:35:59 [kernel] [36229.293990]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:59 [kernel] [36229.293997]  [<ffffffff801b30a5>] 
kmem_getpages+0x69/0x119
Feb 24 04:35:59 [kernel] [36229.294003]  [<ffffffff801b33cb>] 
fallback_alloc+0xf3/0x177
Feb 24 04:35:59 [kernel] [36229.294011]  [<ffffffff801b328a>] 
kmem_cache_alloc_node+0x84/0xa8
Feb 24 04:35:59 [kernel] [36229.294018]  [<ffffffff8012ac67>] 
__alloc_skb+0x63/0x13f
Feb 24 04:35:59 [kernel] [36229.294027]  [<ffffffff802f43b5>] 
__netdev_alloc_skb+0x29/0x44
Feb 24 04:35:59 [kernel] [36229.294040]  [<ffffffff880075c7>] 
:tg3:tg3_alloc_rx_skb+0xc4/0x14f
Feb 24 04:35:59 [kernel] [36229.294052]  [<ffffffff8800e55e>] 
:tg3:tg3_poll+0x403/0x832
Feb 24 04:35:59 [kernel] [36229.294061]  [<ffffffff8010ba9a>] 
net_rx_action+0xa8/0x166
Feb 24 04:35:59 [kernel] [36229.294068]  [<ffffffff8011100f>] 
__do_softirq+0x55/0xc3
Feb 24 04:35:59 [kernel] [36229.294076]  [<ffffffff8016f08e>] 
ack_apic_level+0x33/0x47
Feb 24 04:35:59 [kernel] [36229.294083]  [<ffffffff80158d2c>] 
call_softirq+0x1c/0x28
Feb 24 04:35:59 [kernel] [36229.294091]  [<ffffffff80164094>] 
do_softirq+0x2c/0x7d
Feb 24 04:35:59 [kernel] [36229.294096]  [<ffffffff80164196>] do_IRQ+0xb1/0xce
Feb 24 04:35:59 [kernel] [36229.294103]  [<ffffffff80158121>] 
ret_from_intr+0x0/0xa
Feb 24 04:35:59 [kernel] [36229.294106]  <EOI>  [<ffffffff8015c71c>] 
_spin_lock_irqsave+0x2/0x24
Feb 24 04:35:59 [kernel] [36229.294119]  [<ffffffff8012ad65>] 
__wake_up+0x22/0x4f
Feb 24 04:35:59 [kernel] [36229.294139]  [<ffffffff880ae842>] 
:drbd:drbd_free_ee+0x69/0xbe
Feb 24 04:35:59 [kernel] [36229.294156]  [<ffffffff880af05f>] 
:drbd:drbd_process_done_ee+0xe0/0x11d
Feb 24 04:35:59 [kernel] [36229.294174]  [<ffffffff880b0dbd>] 
:drbd:drbd_asender+0xc9/0x541
Feb 24 04:35:59 [kernel] [36229.294193]  [<ffffffff880bd876>] 
:drbd:drbd_thread_setup+0x99/0xde
Feb 24 04:35:59 [kernel] [36229.294200]  [<ffffffff801589b8>] 
child_rip+0xa/0x12
Feb 24 04:35:59 [kernel] [36229.294219]  [<ffffffff880bd7dd>] 
:drbd:drbd_thread_setup+0x0/0xde
Feb 24 04:35:59 [kernel] [36229.294225]  [<ffffffff801589ae>] 
child_rip+0x0/0x12
Feb 24 04:35:59 [kernel] [36229.294228]
Feb 24 04:35:59 [kernel] [36229.294230] Mem-info:
Feb 24 04:35:59 [kernel] [36229.294232] Node 0 DMA per-cpu:
Feb 24 04:35:59 [kernel] [36229.294237] CPU    0: Hot: hi:    0, 
btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Feb 24 04:35:59 [kernel] [36229.294240] Node 0 DMA32 per-cpu:
Feb 24 04:35:59 [kernel] [36229.294245] CPU    0: Hot: hi:  186, 
btch:  31 usd: 104   Cold: hi:   62, btch:  15 usd:  51
Feb 24 04:35:59 [kernel] [36229.294252] Active:9442 inactive:14275 
dirty:0 writeback:0 unstable:0 free:1377 slab:19499 mapped:1106 
pagetables:230
Feb 24 04:35:59 [kernel] [36229.294256] Node 0 DMA free:3992kB 
min:44kB low:52kB high:64kB active:0kB inactive:0kB present:11548kB 
pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:59 [kernel] [36229.294264] lowmem_reserve[]: 0 993 993
Feb 24 04:35:59 [kernel] [36229.294268] Node 0 DMA32 free:1516kB 
min:4008kB low:5008kB high:6012kB active:37768kB inactive:57100kB 
present:1017452kB pages_scanned:0 all_unreclaimable? no
Feb 24 04:35:59 [kernel] [36229.294276] lowmem_reserve[]: 0 0 0
Feb 24 04:35:59 [kernel] [36229.294280] Node 0 DMA: 0*4kB 1*8kB 
1*16kB 4*32kB 0*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 
0*4096kB = 3992kB
Feb 24 04:35:59 [kernel] [36229.294292] Node 0 DMA32: 61*4kB 1*8kB 
1*16kB 1*32kB 1*64kB 1*128kB 0*256kB 2*512kB 0*1024kB 0*2048kB 
0*4096kB = 1516kB
Feb 24 04:35:59 [kernel] [36229.294306] Swap cache: add 137, delete 
137, find 30/34, race 0+0
Feb 24 04:35:59 [kernel] [36229.294309] Free swap  = 8835648kB
Feb 24 04:35:59 [kernel] [36229.294312] Total swap = 8835740kB
Feb 24 04:35:59 [kernel] [36229.294315] Free swap:       8835648kB
Feb 24 04:35:59 [kernel] [36229.302264] 261984 pages of RAM
Feb 24 04:35:59 [kernel] [36229.302267] 70621 reserved pages
Feb 24 04:35:59 [kernel] [36229.302270] 25468 pages shared
Feb 24 04:35:59 [kernel] [36229.302272] 0 pages swap cached
-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
