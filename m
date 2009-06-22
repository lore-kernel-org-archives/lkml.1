Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbZFVQIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbZFVQIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbZFVQIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:08:45 -0400
Received: from lucidpixels.com ([75.144.35.66]:49693 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbZFVQIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:08:43 -0400
Date: Mon, 22 Jun 2009 12:08:45 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.30: nfsd: page allocation failure - nfsd or kernel problem?
 (again with 2.6.30)
In-Reply-To: <alpine.DEB.2.00.0906161203160.27742@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0906221206050.6191@p34.internal.lan>
References: <alpine.DEB.2.00.0906161203160.27742@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Package: nfs-kernel-server
Version: 1.1.6-1
Distribution: Debian Testing
Architecture: 64-bit

This time with 2.6.30 (and 16384 in min_free_kbytes).
echo 16384 > /proc/sys/vm/min_free_kbytes

[415964.022306] nfsd: page allocation failure. order:0, mode:0x20
[415964.022311] Pid: 2680, comm: nfsd Not tainted 2.6.30 #2
[415964.022313] Call Trace:
[415964.022315]  <IRQ>  [<ffffffff802849ed>] ? __alloc_pages_internal+0x3dd/0x4e0
[415964.022326]  [<ffffffff802a6c77>] ? cache_alloc_refill+0x2d7/0x570
[415964.022328]  [<ffffffff802a6feb>] ? __kmalloc+0xdb/0xe0
[415964.022332]  [<ffffffff805a612d>] ? __alloc_skb+0x6d/0x160
[415964.022334]  [<ffffffff805a6ed7>] ? __netdev_alloc_skb+0x17/0x40
[415964.022338]  [<ffffffff80509d73>] ? e1000_alloc_rx_buffers+0x2b3/0x360
[415964.022340]  [<ffffffff8050a173>] ? e1000_clean_rx_irq+0x2d3/0x3a0
[415964.022342]  [<ffffffff8050bd9f>] ? e1000_clean+0x7f/0x2b0
[415964.022346]  [<ffffffff8026ff2b>] ? getnstimeofday+0x5b/0xe0
[415964.022349]  [<ffffffff805aaf33>] ? net_rx_action+0x83/0x120
[415964.022353]  [<ffffffff8025897b>] ? __do_softirq+0x7b/0x110
[415964.022356]  [<ffffffff8022d6bc>] ? call_softirq+0x1c/0x30
[415964.022359]  [<ffffffff8022f3a5>] ? do_softirq+0x35/0x70
[415964.022361]  [<ffffffff8022eb65>] ? do_IRQ+0x85/0xf0
[415964.022363]  [<ffffffff8022cf93>] ? ret_from_intr+0x0/0xa
[415964.022364]  <EOI>  [<ffffffff8063e670>] ? _spin_lock+0x10/0x20
[415964.022370]  [<ffffffff802bbf4c>] ? d_find_alias+0x1c/0x40
[415964.022373]  [<ffffffff802be59d>] ? d_obtain_alias+0x4d/0x140
[415964.022375]  [<ffffffff80341fa3>] ? exportfs_decode_fh+0x63/0x2a0
[415964.022375]  [<ffffffff803459c0>] ? nfsd_acceptable+0x0/0x110
[415964.022375]  [<ffffffff8062a4aa>] ? cache_check+0x4a/0x4d0
[415964.022375]  [<ffffffff8034b4e7>] ? exp_find_key+0x57/0xe0
[415964.022375]  [<ffffffff8059f740>] ? sock_common_recvmsg+0x30/0x50
[415964.022375]  [<ffffffff8034b602>] ? exp_find+0x92/0xa0
[415964.022375]  [<ffffffff80345ea9>] ? fh_verify+0x369/0x680
[415964.022375]  [<ffffffff8024876e>] ? wakeup_preempt_entity+0x9e/0xb0
[415964.022375]  [<ffffffff8024c8ff>] ? try_to_wake_up+0xaf/0x200
[415964.022375]  [<ffffffff803480fe>] ? nfsd_open+0x2e/0x180
[415964.022375]  [<ffffffff803485e4>] ? nfsd_write+0xc4/0x110
[415964.022375]  [<ffffffff8034fb36>] ? nfsd3_proc_write+0xb6/0x160
[415964.022375]  [<ffffffff8034246a>] ? nfsd_dispatch+0xba/0x270
[415964.022375]  [<ffffffff80621667>] ? svc_process+0x4a7/0x800
[415964.022375]  [<ffffffff8024ca50>] ? default_wake_function+0x0/0x10
[415964.022375]  [<ffffffff8063e4b7>] ? __down_read+0x17/0xae
[415964.022375]  [<ffffffff80342b85>] ? nfsd+0xd5/0x160
[415964.022375]  [<ffffffff80342ab0>] ? nfsd+0x0/0x160
[415964.022375]  [<ffffffff80268304>] ? kthread+0x54/0x90
[415964.022375]  [<ffffffff8022d5ba>] ? child_rip+0xa/0x20
[415964.022375]  [<ffffffff802682b0>] ? kthread+0x0/0x90
[415964.022375]  [<ffffffff8022d5b0>] ? child_rip+0x0/0x20
[415964.022375] Mem-Info:
[415964.022375] DMA per-cpu:
[415964.022375] CPU    0: hi:    0, btch:   1 usd:   0
[415964.022375] CPU    1: hi:    0, btch:   1 usd:   0
[415964.022375] CPU    2: hi:    0, btch:   1 usd:   0
[415964.022375] CPU    3: hi:    0, btch:   1 usd:   0
[415964.022375] DMA32 per-cpu:
[415964.022375] CPU    0: hi:  186, btch:  31 usd: 179
[415964.022375] CPU    1: hi:  186, btch:  31 usd: 156
[415964.022375] CPU    2: hi:  186, btch:  31 usd: 225
[415964.022375] CPU    3: hi:  186, btch:  31 usd: 198
[415964.022375] Normal per-cpu:
[415964.022375] CPU    0: hi:  186, btch:  31 usd: 183
[415964.022375] CPU    1: hi:  186, btch:  31 usd: 176
[415964.022375] CPU    2: hi:  186, btch:  31 usd: 178
[415964.022375] CPU    3: hi:  186, btch:  31 usd: 215
[415964.022375] Active_anon:154810 active_file:131162 inactive_anon:33447
[415964.022375]  inactive_file:690987 unevictable:0 dirty:112116 writeback:0 unstable:0
[415964.022375]  free:8662 slab:965366 mapped:9316 pagetables:4618 bounce:0
[415964.022375] DMA free:9692kB min:16kB low:20kB high:24kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:8668kB pages_scanned:0 all_unreclaimable? yes
[415964.022375] lowmem_reserve[]: 0 3246 7980 7980
[415964.022375] DMA32 free:21312kB min:6656kB low:8320kB high:9984kB active_anon:118464kB inactive_anon:23908kB active_file:174708kB inactive_file:1206812kB unevictable:0kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[415964.022375] lowmem_reserve[]: 0 0 4734 4734
[415964.022375] Normal free:3644kB min:9708kB low:12132kB high:14560kB active_anon:500776kB inactive_anon:109880kB active_file:349940kB inactive_file:1557136kB unevictable:0kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[415964.022375] lowmem_reserve[]: 0 0 0 0
[415964.022375] DMA: 3*4kB 4*8kB 3*16kB 4*32kB 0*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9692kB
[415964.022375] DMA32: 3289*4kB 0*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 21332kB
[415964.022375] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3816kB
[415964.022375] 827035 total pagecache pages
[415964.022375] 4728 pages in swap cache
[415964.022375] Swap cache stats: add 12746, delete 8018, find 16878/17480
[415964.022375] Free swap  = 16756356kB
[415964.022375] Total swap = 16787768kB
[415964.022375] 2277376 pages RAM
[415964.022375] 252254 pages reserved
[415964.022375] 546309 pages shared
[415964.022375] 1520221 pages non-shared
[415964.060817] nfsd: page allocation failure. order:0, mode:0x20
[415964.060822] Pid: 2680, comm: nfsd Not tainted 2.6.30 #2
[415964.060823] Call Trace:
[415964.060825]  <IRQ>  [<ffffffff802849ed>] ? __alloc_pages_internal+0x3dd/0x4e0
[415964.060835]  [<ffffffff802a6c77>] ? cache_alloc_refill+0x2d7/0x570
[415964.060837]  [<ffffffff802a6feb>] ? __kmalloc+0xdb/0xe0
[415964.060840]  [<ffffffff805a612d>] ? __alloc_skb+0x6d/0x160
[415964.060842]  [<ffffffff805a6ed7>] ? __netdev_alloc_skb+0x17/0x40
[415964.060846]  [<ffffffff80509d73>] ? e1000_alloc_rx_buffers+0x2b3/0x360
[415964.060848]  [<ffffffff8050a100>] ? e1000_clean_rx_irq+0x260/0x3a0
[415964.060851]  [<ffffffff8050bd9f>] ? e1000_clean+0x7f/0x2b0
[415964.060853]  [<ffffffff805aaf33>] ? net_rx_action+0x83/0x120
[415964.060857]  [<ffffffff8025897b>] ? __do_softirq+0x7b/0x110
[415964.060860]  [<ffffffff8022d6bc>] ? call_softirq+0x1c/0x30
[415964.060863]  [<ffffffff8022f3a5>] ? do_softirq+0x35/0x70
[415964.060865]  [<ffffffff8022eb65>] ? do_IRQ+0x85/0xf0
[415964.060867]  [<ffffffff8022cf93>] ? ret_from_intr+0x0/0xa
[415964.060869]  <EOI>  [<ffffffff8063e66c>] ? _spin_lock+0xc/0x20
[415964.060874]  [<ffffffff802bbf4c>] ? d_find_alias+0x1c/0x40
[415964.060877]  [<ffffffff802be59d>] ? d_obtain_alias+0x4d/0x140
[415964.060880]  [<ffffffff80341fa3>] ? exportfs_decode_fh+0x63/0x2a0
[415964.060883]  [<ffffffff803459c0>] ? nfsd_acceptable+0x0/0x110
[415964.060887]  [<ffffffff8062a4aa>] ? cache_check+0x4a/0x4d0
[415964.060889]  [<ffffffff8034b4e7>] ? exp_find_key+0x57/0xe0
[415964.060893]  [<ffffffff8059f740>] ? sock_common_recvmsg+0x30/0x50
[415964.060895]  [<ffffffff8034b602>] ? exp_find+0x92/0xa0
[415964.060898]  [<ffffffff80345ea9>] ? fh_verify+0x369/0x680
[415964.060901]  [<ffffffff8024876e>] ? wakeup_preempt_entity+0x9e/0xb0
[415964.060904]  [<ffffffff8024c8ff>] ? try_to_wake_up+0xaf/0x200
[415964.060906]  [<ffffffff803480fe>] ? nfsd_open+0x2e/0x180
[415964.060908]  [<ffffffff803485e4>] ? nfsd_write+0xc4/0x110
[415964.060912]  [<ffffffff8034fb36>] ? nfsd3_proc_write+0xb6/0x160
[415964.060914]  [<ffffffff8034246a>] ? nfsd_dispatch+0xba/0x270
[415964.060916]  [<ffffffff80621667>] ? svc_process+0x4a7/0x800
[415964.060919]  [<ffffffff8024ca50>] ? default_wake_function+0x0/0x10
[415964.060922]  [<ffffffff8063e4b7>] ? __down_read+0x17/0xae
[415964.060924]  [<ffffffff80342b85>] ? nfsd+0xd5/0x160
[415964.060926]  [<ffffffff80342ab0>] ? nfsd+0x0/0x160
[415964.060929]  [<ffffffff80268304>] ? kthread+0x54/0x90
[415964.060932]  [<ffffffff8022d5ba>] ? child_rip+0xa/0x20
[415964.060934]  [<ffffffff802682b0>] ? kthread+0x0/0x90
[415964.060936]  [<ffffffff8022d5b0>] ? child_rip+0x0/0x20
[415964.060937] Mem-Info:
[415964.060939] DMA per-cpu:
[415964.060941] CPU    0: hi:    0, btch:   1 usd:   0
[415964.060942] CPU    1: hi:    0, btch:   1 usd:   0
[415964.060944] CPU    2: hi:    0, btch:   1 usd:   0
[415964.060945] CPU    3: hi:    0, btch:   1 usd:   0
[415964.060947] DMA32 per-cpu:
[415964.060948] CPU    0: hi:  186, btch:  31 usd: 179
[415964.060950] CPU    1: hi:  186, btch:  31 usd: 156
[415964.060952] CPU    2: hi:  186, btch:  31 usd: 225
[415964.060953] CPU    3: hi:  186, btch:  31 usd: 198
[415964.060954] Normal per-cpu:
[415964.060956] CPU    0: hi:  186, btch:  31 usd: 183
[415964.060957] CPU    1: hi:  186, btch:  31 usd: 176
[415964.060959] CPU    2: hi:  186, btch:  31 usd: 178
[415964.060960] CPU    3: hi:  186, btch:  31 usd: 215
[415964.060964] Active_anon:154810 active_file:131162 inactive_anon:33447
[415964.060964]  inactive_file:690987 unevictable:0 dirty:112116 writeback:0 unstable:0
[415964.060965]  free:8662 slab:965366 mapped:9316 pagetables:4618 bounce:0
[415964.060969] DMA free:9692kB min:16kB low:20kB high:24kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:8668kB pages_scanned:0 all_unreclaimable? yes
[415964.060971] lowmem_reserve[]: 0 3246 7980 7980
[415964.060976] DMA32 free:21312kB min:6656kB low:8320kB high:9984kB active_anon:118464kB inactive_anon:23908kB active_file:174708kB inactive_file:1206812kB unevictable:0kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[415964.060978] lowmem_reserve[]: 0 0 4734 4734
[415964.060983] Normal free:3644kB min:9708kB low:12132kB high:14560kB active_anon:500776kB inactive_anon:109880kB active_file:349940kB inactive_file:1557136kB unevictable:0kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[415964.060985] lowmem_reserve[]: 0 0 0 0
[415964.060988] DMA: 3*4kB 4*8kB 3*16kB 4*32kB 0*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9692kB
[415964.060996] DMA32: 3289*4kB 0*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 21332kB
[415964.061003] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3816kB
[415964.061010] 827035 total pagecache pages
[415964.061012] 4728 pages in swap cache
[415964.061013] Swap cache stats: add 12746, delete 8018, find 16878/17480
[415964.061015] Free swap  = 16756356kB
[415964.061016] Total swap = 16787768kB
[415964.061653] 2277376 pages RAM
[415964.061653] 252254 pages reserved
[415964.061653] 546309 pages shared
[415964.061653] 1520221 pages non-shared
[415964.097454] nfsd: page allocation failure. order:0, mode:0x20
[415964.097458] Pid: 2680, comm: nfsd Not tainted 2.6.30 #2
[415964.097460] Call Trace:
[415964.097462]  <IRQ>  [<ffffffff802849ed>] ? __alloc_pages_internal+0x3dd/0x4e0
[415964.097471]  [<ffffffff802a6c77>] ? cache_alloc_refill+0x2d7/0x570
[415964.097473]  [<ffffffff802a6feb>] ? __kmalloc+0xdb/0xe0
[415964.097477]  [<ffffffff805a612d>] ? __alloc_skb+0x6d/0x160
[415964.097479]  [<ffffffff805a6ed7>] ? __netdev_alloc_skb+0x17/0x40
[415964.097482]  [<ffffffff80509d73>] ? e1000_alloc_rx_buffers+0x2b3/0x360
[415964.097485]  [<ffffffff8050a100>] ? e1000_clean_rx_irq+0x260/0x3a0
[415964.097487]  [<ffffffff8050bd9f>] ? e1000_clean+0x7f/0x2b0
[415964.097490]  [<ffffffff805aaf33>] ? net_rx_action+0x83/0x120
[415964.097494]  [<ffffffff8025897b>] ? __do_softirq+0x7b/0x110
[415964.097497]  [<ffffffff8022d6bc>] ? call_softirq+0x1c/0x30
[415964.097499]  [<ffffffff8022f3a5>] ? do_softirq+0x35/0x70
[415964.097502]  [<ffffffff8022eb65>] ? do_IRQ+0x85/0xf0
[415964.097504]  [<ffffffff8022cf93>] ? ret_from_intr+0x0/0xa
[415964.097505]  <EOI>  [<ffffffff8063e66c>] ? _spin_lock+0xc/0x20
[415964.097511]  [<ffffffff802bbf4c>] ? d_find_alias+0x1c/0x40
[415964.097514]  [<ffffffff802be59d>] ? d_obtain_alias+0x4d/0x140
[415964.097517]  [<ffffffff80341fa3>] ? exportfs_decode_fh+0x63/0x2a0
[415964.097520]  [<ffffffff803459c0>] ? nfsd_acceptable+0x0/0x110
[415964.097523]  [<ffffffff8062a4aa>] ? cache_check+0x4a/0x4d0
[415964.097526]  [<ffffffff8034b4e7>] ? exp_find_key+0x57/0xe0
[415964.097530]  [<ffffffff8059f740>] ? sock_common_recvmsg+0x30/0x50
[415964.097532]  [<ffffffff8034b602>] ? exp_find+0x92/0xa0
[415964.097534]  [<ffffffff80345ea9>] ? fh_verify+0x369/0x680
[415964.097539]  [<ffffffff8024876e>] ? wakeup_preempt_entity+0x9e/0xb0
[415964.097541]  [<ffffffff8024c8ff>] ? try_to_wake_up+0xaf/0x200
[415964.097543]  [<ffffffff803480fe>] ? nfsd_open+0x2e/0x180
[415964.097546]  [<ffffffff803485e4>] ? nfsd_write+0xc4/0x110
[415964.097549]  [<ffffffff8034fb36>] ? nfsd3_proc_write+0xb6/0x160
[415964.097551]  [<ffffffff8034246a>] ? nfsd_dispatch+0xba/0x270
[415964.097554]  [<ffffffff80621667>] ? svc_process+0x4a7/0x800
[415964.097556]  [<ffffffff8024ca50>] ? default_wake_function+0x0/0x10
[415964.097559]  [<ffffffff8063e4b7>] ? __down_read+0x17/0xae
[415964.097561]  [<ffffffff80342b85>] ? nfsd+0xd5/0x160
[415964.097563]  [<ffffffff80342ab0>] ? nfsd+0x0/0x160
[415964.097566]  [<ffffffff80268304>] ? kthread+0x54/0x90
[415964.097568]  [<ffffffff8022d5ba>] ? child_rip+0xa/0x20
[415964.097571]  [<ffffffff802682b0>] ? kthread+0x0/0x90
[415964.097573]  [<ffffffff8022d5b0>] ? child_rip+0x0/0x20
[415964.097574] Mem-Info:
[415964.097575] DMA per-cpu:
[415964.097577] CPU    0: hi:    0, btch:   1 usd:   0
[415964.097579] CPU    1: hi:    0, btch:   1 usd:   0
[415964.097581] CPU    2: hi:    0, btch:   1 usd:   0
[415964.097582] CPU    3: hi:    0, btch:   1 usd:   0
[415964.097583] DMA32 per-cpu:
[415964.097585] CPU    0: hi:  186, btch:  31 usd: 179
[415964.097586] CPU    1: hi:  186, btch:  31 usd: 156
[415964.097588] CPU    2: hi:  186, btch:  31 usd: 225
[415964.097590] CPU    3: hi:  186, btch:  31 usd: 198
[415964.097591] Normal per-cpu:
[415964.097592] CPU    0: hi:  186, btch:  31 usd: 183
[415964.097594] CPU    1: hi:  186, btch:  31 usd: 176
[415964.097595] CPU    2: hi:  186, btch:  31 usd: 178
[415964.097597] CPU    3: hi:  186, btch:  31 usd: 215
[415964.097600] Active_anon:154810 active_file:131162 inactive_anon:33447
[415964.097601]  inactive_file:690987 unevictable:0 dirty:112116 writeback:0 unstable:0
[415964.097602]  free:8662 slab:965366 mapped:9316 pagetables:4618 bounce:0
[415964.097605] DMA free:9692kB min:16kB low:20kB high:24kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:8668kB pages_scanned:0 all_unreclaimable? yes
[415964.097607] lowmem_reserve[]: 0 3246 7980 7980
[415964.097612] DMA32 free:21312kB min:6656kB low:8320kB high:9984kB active_anon:118464kB inactive_anon:23908kB active_file:174708kB inactive_file:1206812kB unevictable:0kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[415964.097615] lowmem_reserve[]: 0 0 4734 4734
[415964.097619] Normal free:3644kB min:9708kB low:12132kB high:14560kB active_anon:500776kB inactive_anon:109880kB active_file:349940kB inactive_file:1557136kB unevictable:0kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[415964.097622] lowmem_reserve[]: 0 0 0 0
[415964.097624] DMA: 3*4kB 4*8kB 3*16kB 4*32kB 0*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9692kB
[415964.097632] DMA32: 3289*4kB 0*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 21332kB
[415964.097639] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3816kB
[415964.097646] 827035 total pagecache pages
[415964.097647] 4728 pages in swap cache
[415964.097649] Swap cache stats: add 12746, delete 8018, find 16878/17480
[415964.097651] Free swap  = 16756356kB
[415964.097652] Total swap = 16787768kB
[415964.098375] 2277376 pages RAM
[415964.098375] 252254 pages reserved
[415964.098375] 546309 pages shared
[415964.098375] 1520221 pages non-shared
[415964.134117] nfsd: page allocation failure. order:0, mode:0x20
[415964.134121] Pid: 2680, comm: nfsd Not tainted 2.6.30 #2
[415964.134123] Call Trace:
[415964.134125]  <IRQ>  [<ffffffff802849ed>] ? __alloc_pages_internal+0x3dd/0x4e0
[415964.134134]  [<ffffffff802a6c77>] ? cache_alloc_refill+0x2d7/0x570
[415964.134136]  [<ffffffff802a707d>] ? kmem_cache_alloc+0x8d/0xa0
[415964.134140]  [<ffffffff805a6109>] ? __alloc_skb+0x49/0x160
[415964.134144]  [<ffffffff805ea846>] ? tcp_send_ack+0x26/0x120
[415964.134146]  [<ffffffff805e867d>] ? tcp_rcv_established+0x7bd/0x940
[415964.134149]  [<ffffffff805efb1d>] ? tcp_v4_do_rcv+0xdd/0x210
[415964.134151]  [<ffffffff805f02d6>] ? tcp_v4_rcv+0x686/0x750
[415964.134154]  [<ffffffff805d235c>] ? ip_local_deliver_finish+0x8c/0x170
[415964.134156]  [<ffffffff805d1e51>] ? ip_rcv_finish+0x191/0x330
[415964.134158]  [<ffffffff805d2237>] ? ip_rcv+0x247/0x2e0
[415964.134162]  [<ffffffff80509fb4>] ? e1000_clean_rx_irq+0x114/0x3a0
[415964.134164]  [<ffffffff8050bd9f>] ? e1000_clean+0x7f/0x2b0
[415964.134167]  [<ffffffff805aaf33>] ? net_rx_action+0x83/0x120
[415964.134170]  [<ffffffff8025897b>] ? __do_softirq+0x7b/0x110
[415964.134174]  [<ffffffff8022d6bc>] ? call_softirq+0x1c/0x30
[415964.134176]  [<ffffffff8022f3a5>] ? do_softirq+0x35/0x70
[415964.134178]  [<ffffffff8022eb65>] ? do_IRQ+0x85/0xf0
[415964.134180]  [<ffffffff8022cf93>] ? ret_from_intr+0x0/0xa
[415964.134182]  <EOI>  [<ffffffff8063e66c>] ? _spin_lock+0xc/0x20
[415964.134188]  [<ffffffff802bbf4c>] ? d_find_alias+0x1c/0x40
[415964.134190]  [<ffffffff802be59d>] ? d_obtain_alias+0x4d/0x140
[415964.134194]  [<ffffffff80341fa3>] ? exportfs_decode_fh+0x63/0x2a0
[415964.134197]  [<ffffffff803459c0>] ? nfsd_acceptable+0x0/0x110
[415964.134200]  [<ffffffff8062a4aa>] ? cache_check+0x4a/0x4d0
[415964.134203]  [<ffffffff8034b4e7>] ? exp_find_key+0x57/0xe0
[415964.134206]  [<ffffffff8059f740>] ? sock_common_recvmsg+0x30/0x50
[415964.134209]  [<ffffffff8034b602>] ? exp_find+0x92/0xa0
[415964.134211]  [<ffffffff80345ea9>] ? fh_verify+0x369/0x680
[415964.134215]  [<ffffffff8024876e>] ? wakeup_preempt_entity+0x9e/0xb0
[415964.134217]  [<ffffffff8024c8ff>] ? try_to_wake_up+0xaf/0x200
[415964.134220]  [<ffffffff803480fe>] ? nfsd_open+0x2e/0x180
[415964.134222]  [<ffffffff803485e4>] ? nfsd_write+0xc4/0x110
[415964.134225]  [<ffffffff8034fb36>] ? nfsd3_proc_write+0xb6/0x160
[415964.134228]  [<ffffffff8034246a>] ? nfsd_dispatch+0xba/0x270
[415964.134230]  [<ffffffff80621667>] ? svc_process+0x4a7/0x800
[415964.134232]  [<ffffffff8024ca50>] ? default_wake_function+0x0/0x10
[415964.134236]  [<ffffffff8063e4b7>] ? __down_read+0x17/0xae
[415964.134238]  [<ffffffff80342b85>] ? nfsd+0xd5/0x160
[415964.134240]  [<ffffffff80342ab0>] ? nfsd+0x0/0x160
[415964.134243]  [<ffffffff80268304>] ? kthread+0x54/0x90
[415964.134245]  [<ffffffff8022d5ba>] ? child_rip+0xa/0x20
[415964.134247]  [<ffffffff802682b0>] ? kthread+0x0/0x90
[415964.134249]  [<ffffffff8022d5b0>] ? child_rip+0x0/0x20
[415964.134251] Mem-Info:
[415964.134252] DMA per-cpu:
[415964.134254] CPU    0: hi:    0, btch:   1 usd:   0
[415964.134256] CPU    1: hi:    0, btch:   1 usd:   0
[415964.134258] CPU    2: hi:    0, btch:   1 usd:   0
[415964.134260] CPU    3: hi:    0, btch:   1 usd:   0
[415964.134261] DMA32 per-cpu:
[415964.134263] CPU    0: hi:  186, btch:  31 usd: 179
[415964.134265] CPU    1: hi:  186, btch:  31 usd: 156
[415964.134266] CPU    2: hi:  186, btch:  31 usd: 225
[415964.134268] CPU    3: hi:  186, btch:  31 usd: 198
[415964.134269] Normal per-cpu:
[415964.134271] CPU    0: hi:  186, btch:  31 usd: 183
[415964.134273] CPU    1: hi:  186, btch:  31 usd: 176
[415964.134275] CPU    2: hi:  186, btch:  31 usd: 178
[415964.134276] CPU    3: hi:  186, btch:  31 usd: 215
[415964.134280] Active_anon:154810 active_file:131162 inactive_anon:33447
[415964.134281]  inactive_file:690987 unevictable:0 dirty:112116 writeback:0 unstable:0
[415964.134282]  free:8662 slab:965366 mapped:9316 pagetables:4618 bounce:0
[415964.134285] DMA free:9692kB min:16kB low:20kB high:24kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:8668kB pages_scanned:0 all_unreclaimable? yes
[415964.134288] lowmem_reserve[]: 0 3246 7980 7980
[415964.134293] DMA32 free:21312kB min:6656kB low:8320kB high:9984kB active_anon:118464kB inactive_anon:23908kB active_file:174708kB inactive_file:1206812kB unevictable:0kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[415964.134297] lowmem_reserve[]: 0 0 4734 4734
[415964.134301] Normal free:3644kB min:9708kB low:12132kB high:14560kB active_anon:500776kB inactive_anon:109880kB active_file:349940kB inactive_file:1557136kB unevictable:0kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[415964.134304] lowmem_reserve[]: 0 0 0 0
[415964.134307] DMA: 3*4kB 4*8kB 3*16kB 4*32kB 0*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9692kB
[415964.134315] DMA32: 3289*4kB 0*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 21332kB
[415964.134323] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3816kB
[415964.134330] 827035 total pagecache pages
[415964.134332] 4728 pages in swap cache
[415964.134334] Swap cache stats: add 12746, delete 8018, find 16878/17480
[415964.134335] Free swap  = 16756356kB
[415964.134336] Total swap = 16787768kB
[415964.154129] 2277376 pages RAM
[415964.154129] 252254 pages reserved
[415964.154129] 546309 pages shared
[415964.154129] 1520221 pages non-shared
[415964.164297] nfsd: page allocation failure. order:0, mode:0x20
[415964.164301] Pid: 2680, comm: nfsd Not tainted 2.6.30 #2
[415964.164303] Call Trace:
[415964.164305]  <IRQ>  [<ffffffff802849ed>] ? __alloc_pages_internal+0x3dd/0x4e0
[415964.164315]  [<ffffffff802a6c77>] ? cache_alloc_refill+0x2d7/0x570
[415964.164317]  [<ffffffff802a707d>] ? kmem_cache_alloc+0x8d/0xa0
[415964.164320]  [<ffffffff805a6109>] ? __alloc_skb+0x49/0x160
[415964.164323]  [<ffffffff805a6ed7>] ? __netdev_alloc_skb+0x17/0x40
[415964.164326]  [<ffffffff80509d73>] ? e1000_alloc_rx_buffers+0x2b3/0x360
[415964.164329]  [<ffffffff8050a100>] ? e1000_clean_rx_irq+0x260/0x3a0
[415964.164331]  [<ffffffff8050bd9f>] ? e1000_clean+0x7f/0x2b0
[415964.164334]  [<ffffffff805aaf33>] ? net_rx_action+0x83/0x120
[415964.164337]  [<ffffffff8025897b>] ? __do_softirq+0x7b/0x110
[415964.164340]  [<ffffffff8022d6bc>] ? call_softirq+0x1c/0x30
[415964.164343]  [<ffffffff8022f3a5>] ? do_softirq+0x35/0x70
[415964.164345]  [<ffffffff8022eb65>] ? do_IRQ+0x85/0xf0
[415964.164347]  [<ffffffff8022cf93>] ? ret_from_intr+0x0/0xa
[415964.164348]  <EOI>  [<ffffffff8063e66c>] ? _spin_lock+0xc/0x20
[415964.164354]  [<ffffffff802bbf4c>] ? d_find_alias+0x1c/0x40
[415964.164356]  [<ffffffff802be59d>] ? d_obtain_alias+0x4d/0x140
[415964.164360]  [<ffffffff80341fa3>] ? exportfs_decode_fh+0x63/0x2a0
[415964.164363]  [<ffffffff803459c0>] ? nfsd_acceptable+0x0/0x110
[415964.164366]  [<ffffffff8062a4aa>] ? cache_check+0x4a/0x4d0
[415964.164368]  [<ffffffff8034b4e7>] ? exp_find_key+0x57/0xe0
[415964.164372]  [<ffffffff8059f740>] ? sock_common_recvmsg+0x30/0x50
[415964.164374]  [<ffffffff8034b602>] ? exp_find+0x92/0xa0
[415964.164376]  [<ffffffff80345ea9>] ? fh_verify+0x369/0x680
[415964.164380]  [<ffffffff8024876e>] ? wakeup_preempt_entity+0x9e/0xb0
[415964.164382]  [<ffffffff8024c8ff>] ? try_to_wake_up+0xaf/0x200
[415964.164384]  [<ffffffff803480fe>] ? nfsd_open+0x2e/0x180
[415964.164387]  [<ffffffff803485e4>] ? nfsd_write+0xc4/0x110
[415964.164390]  [<ffffffff8034fb36>] ? nfsd3_proc_write+0xb6/0x160
[415964.164392]  [<ffffffff8034246a>] ? nfsd_dispatch+0xba/0x270
[415964.164394]  [<ffffffff80621667>] ? svc_process+0x4a7/0x800
[415964.164397]  [<ffffffff8024ca50>] ? default_wake_function+0x0/0x10
[415964.164400]  [<ffffffff8063e4b7>] ? __down_read+0x17/0xae
[415964.164402]  [<ffffffff80342b85>] ? nfsd+0xd5/0x160
[415964.164404]  [<ffffffff80342ab0>] ? nfsd+0x0/0x160
[415964.164407]  [<ffffffff80268304>] ? kthread+0x54/0x90
[415964.164409]  [<ffffffff8022d5ba>] ? child_rip+0xa/0x20
[415964.164411]  [<ffffffff802682b0>] ? kthread+0x0/0x90
[415964.164413]  [<ffffffff8022d5b0>] ? child_rip+0x0/0x20
[415964.164414] Mem-Info:
[415964.164416] DMA per-cpu:
[415964.164418] CPU    0: hi:    0, btch:   1 usd:   0
[415964.164419] CPU    1: hi:    0, btch:   1 usd:   0
[415964.164421] CPU    2: hi:    0, btch:   1 usd:   0
[415964.164422] CPU    3: hi:    0, btch:   1 usd:   0
[415964.164424] DMA32 per-cpu:
[415964.164425] CPU    0: hi:  186, btch:  31 usd: 179
[415964.164427] CPU    1: hi:  186, btch:  31 usd: 156
[415964.164429] CPU    2: hi:  186, btch:  31 usd: 225
[415964.164430] CPU    3: hi:  186, btch:  31 usd: 198
[415964.164431] Normal per-cpu:
[415964.164433] CPU    0: hi:  186, btch:  31 usd: 183
[415964.164434] CPU    1: hi:  186, btch:  31 usd: 176
[415964.164436] CPU    2: hi:  186, btch:  31 usd: 178
[415964.164437] CPU    3: hi:  186, btch:  31 usd: 215
[415964.164440] Active_anon:154810 active_file:131162 inactive_anon:33447
[415964.164441]  inactive_file:690987 unevictable:0 dirty:112116 writeback:0 unstable:0
[415964.164442]  free:8662 slab:965366 mapped:9316 pagetables:4618 bounce:0
[415964.164445] DMA free:9692kB min:16kB low:20kB high:24kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:8668kB pages_scanned:0 all_unreclaimable? yes
[415964.164448] lowmem_reserve[]: 0 3246 7980 7980
[415964.164452] DMA32 free:21312kB min:6656kB low:8320kB high:9984kB active_anon:118464kB inactive_anon:23908kB active_file:174708kB inactive_file:1206812kB unevictable:0kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[415964.164455] lowmem_reserve[]: 0 0 4734 4734
[415964.164459] Normal free:3644kB min:9708kB low:12132kB high:14560kB active_anon:500776kB inactive_anon:109880kB active_file:349940kB inactive_file:1557136kB unevictable:0kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[415964.164462] lowmem_reserve[]: 0 0 0 0
[415964.164465] DMA: 3*4kB 4*8kB 3*16kB 4*32kB 0*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9692kB
[415964.164472] DMA32: 3289*4kB 0*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 21332kB
[415964.164479] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3816kB
[415964.164486] 827035 total pagecache pages
[415964.164488] 4728 pages in swap cache
[415964.164489] Swap cache stats: add 12746, delete 8018, find 16878/17480
[415964.164491] Free swap  = 16756356kB
[415964.164492] Total swap = 16787768kB
[415964.165269] 2277376 pages RAM
[415964.165269] 252254 pages reserved
[415964.165269] 546309 pages shared
[415964.165269] 1520221 pages non-shared
[415964.193652] nfsd: page allocation failure. order:0, mode:0x20
[415964.193656] Pid: 2680, comm: nfsd Not tainted 2.6.30 #2
[415964.193657] Call Trace:
[415964.193659]  <IRQ>  [<ffffffff802849ed>] ? __alloc_pages_internal+0x3dd/0x4e0
[415964.193667]  [<ffffffff802a6c77>] ? cache_alloc_refill+0x2d7/0x570
[415964.193669]  [<ffffffff802a707d>] ? kmem_cache_alloc+0x8d/0xa0
[415964.193672]  [<ffffffff805a6109>] ? __alloc_skb+0x49/0x160
[415964.193676]  [<ffffffff805ea846>] ? tcp_send_ack+0x26/0x120
[415964.193678]  [<ffffffff805e867d>] ? tcp_rcv_established+0x7bd/0x940
[415964.193681]  [<ffffffff805efb1d>] ? tcp_v4_do_rcv+0xdd/0x210
[415964.193683]  [<ffffffff805f02d6>] ? tcp_v4_rcv+0x686/0x750
[415964.193686]  [<ffffffff805d235c>] ? ip_local_deliver_finish+0x8c/0x170
[415964.193688]  [<ffffffff805d1e51>] ? ip_rcv_finish+0x191/0x330
[415964.193690]  [<ffffffff805d2237>] ? ip_rcv+0x247/0x2e0
[415964.193693]  [<ffffffff80509fb4>] ? e1000_clean_rx_irq+0x114/0x3a0
[415964.193696]  [<ffffffff8050bd9f>] ? e1000_clean+0x7f/0x2b0
[415964.193698]  [<ffffffff805aaf33>] ? net_rx_action+0x83/0x120
[415964.193702]  [<ffffffff8025897b>] ? __do_softirq+0x7b/0x110
[415964.193705]  [<ffffffff8022d6bc>] ? call_softirq+0x1c/0x30
[415964.193707]  [<ffffffff8022f3a5>] ? do_softirq+0x35/0x70
[415964.193709]  [<ffffffff8022eb65>] ? do_IRQ+0x85/0xf0
[415964.193712]  [<ffffffff8022cf93>] ? ret_from_intr+0x0/0xa
[415964.193713]  <EOI>  [<ffffffff8063e66c>] ? _spin_lock+0xc/0x20
[415964.193718]  [<ffffffff802bbf4c>] ? d_find_alias+0x1c/0x40
[415964.193721]  [<ffffffff802be59d>] ? d_obtain_alias+0x4d/0x140
[415964.193724]  [<ffffffff80341fa3>] ? exportfs_decode_fh+0x63/0x2a0
[415964.193726]  [<ffffffff803459c0>] ? nfsd_acceptable+0x0/0x110
[415964.193730]  [<ffffffff8062a4aa>] ? cache_check+0x4a/0x4d0
[415964.193732]  [<ffffffff8034b4e7>] ? exp_find_key+0x57/0xe0
[415964.193735]  [<ffffffff8059f740>] ? sock_common_recvmsg+0x30/0x50
[415964.193738]  [<ffffffff8034b602>] ? exp_find+0x92/0xa0
[415964.193740]  [<ffffffff80345ea9>] ? fh_verify+0x369/0x680
[415964.193743]  [<ffffffff8024876e>] ? wakeup_preempt_entity+0x9e/0xb0
[415964.193746]  [<ffffffff8024c8ff>] ? try_to_wake_up+0xaf/0x200
[415964.193748]  [<ffffffff803480fe>] ? nfsd_open+0x2e/0x180
[415964.193751]  [<ffffffff803485e4>] ? nfsd_write+0xc4/0x110
[415964.193754]  [<ffffffff8034fb36>] ? nfsd3_proc_write+0xb6/0x160
[415964.193756]  [<ffffffff8034246a>] ? nfsd_dispatch+0xba/0x270
[415964.193758]  [<ffffffff80621667>] ? svc_process+0x4a7/0x800
[415964.193760]  [<ffffffff8024ca50>] ? default_wake_function+0x0/0x10
[415964.193764]  [<ffffffff8063e4b7>] ? __down_read+0x17/0xae
[415964.193766]  [<ffffffff80342b85>] ? nfsd+0xd5/0x160
[415964.193768]  [<ffffffff80342ab0>] ? nfsd+0x0/0x160
[415964.193771]  [<ffffffff80268304>] ? kthread+0x54/0x90
[415964.193773]  [<ffffffff8022d5ba>] ? child_rip+0xa/0x20
[415964.193775]  [<ffffffff802682b0>] ? kthread+0x0/0x90
[415964.193777]  [<ffffffff8022d5b0>] ? child_rip+0x0/0x20
[415964.193778] Mem-Info:
[415964.193780] DMA per-cpu:
[415964.193781] CPU    0: hi:    0, btch:   1 usd:   0
[415964.193783] CPU    1: hi:    0, btch:   1 usd:   0
[415964.193785] CPU    2: hi:    0, btch:   1 usd:   0
[415964.193787] CPU    3: hi:    0, btch:   1 usd:   0
[415964.193788] DMA32 per-cpu:
[415964.193790] CPU    0: hi:  186, btch:  31 usd: 179
[415964.193792] CPU    1: hi:  186, btch:  31 usd: 156
[415964.193794] CPU    2: hi:  186, btch:  31 usd: 225
[415964.193795] CPU    3: hi:  186, btch:  31 usd: 198
[415964.193797] Normal per-cpu:
[415964.193798] CPU    0: hi:  186, btch:  31 usd: 183
[415964.193800] CPU    1: hi:  186, btch:  31 usd: 176
[415964.193802] CPU    2: hi:  186, btch:  31 usd: 178
[415964.193803] CPU    3: hi:  186, btch:  31 usd: 215
[415964.193807] Active_anon:154810 active_file:131162 inactive_anon:33447
[415964.193808]  inactive_file:690987 unevictable:0 dirty:112116 writeback:0 unstable:0
[415964.193809]  free:8662 slab:965366 mapped:9316 pagetables:4618 bounce:0
[415964.193812] DMA free:9692kB min:16kB low:20kB high:24kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:8668kB pages_scanned:0 all_unreclaimable? yes
[415964.193815] lowmem_reserve[]: 0 3246 7980 7980
[415964.193820] DMA32 free:21312kB min:6656kB low:8320kB high:9984kB active_anon:118464kB inactive_anon:23908kB active_file:174708kB inactive_file:1206812kB unevictable:0kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[415964.193823] lowmem_reserve[]: 0 0 4734 4734
[415964.193828] Normal free:3644kB min:9708kB low:12132kB high:14560kB active_anon:500776kB inactive_anon:109880kB active_file:349940kB inactive_file:1557136kB unevictable:0kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[415964.193831] lowmem_reserve[]: 0 0 0 0
[415964.193834] DMA: 3*4kB 4*8kB 3*16kB 4*32kB 0*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9692kB
[415964.193842] DMA32: 3289*4kB 0*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 21332kB
[415964.193850] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3816kB
[415964.193857] 827035 total pagecache pages
[415964.193859] 4728 pages in swap cache
[415964.193860] Swap cache stats: add 12746, delete 8018, find 16878/17480
[415964.193862] Free swap  = 16756356kB
[415964.193863] Total swap = 16787768kB
[415964.194629] 2277376 pages RAM
[415964.194629] 252254 pages reserved
[415964.194629] 546309 pages shared
[415964.194629] 1520221 pages non-shared
[415964.223033] nfsd: page allocation failure. order:0, mode:0x20
[415964.223037] Pid: 2680, comm: nfsd Not tainted 2.6.30 #2
[415964.223038] Call Trace:
[415964.223040]  <IRQ>  [<ffffffff802849ed>] ? __alloc_pages_internal+0x3dd/0x4e0
[415964.223048]  [<ffffffff802a6c77>] ? cache_alloc_refill+0x2d7/0x570
[415964.223050]  [<ffffffff802a707d>] ? kmem_cache_alloc+0x8d/0xa0
[415964.223053]  [<ffffffff805a6109>] ? __alloc_skb+0x49/0x160
[415964.223057]  [<ffffffff805ea846>] ? tcp_send_ack+0x26/0x120
[415964.223059]  [<ffffffff805e82ad>] ? tcp_rcv_established+0x3ed/0x940
[415964.223062]  [<ffffffff805efb1d>] ? tcp_v4_do_rcv+0xdd/0x210
[415964.223064]  [<ffffffff805f02d6>] ? tcp_v4_rcv+0x686/0x750
[415964.223067]  [<ffffffff805d235c>] ? ip_local_deliver_finish+0x8c/0x170
[415964.223069]  [<ffffffff805d1e51>] ? ip_rcv_finish+0x191/0x330
[415964.223071]  [<ffffffff805d2237>] ? ip_rcv+0x247/0x2e0
[415964.223075]  [<ffffffff80509fb4>] ? e1000_clean_rx_irq+0x114/0x3a0
[415964.223077]  [<ffffffff8050bd9f>] ? e1000_clean+0x7f/0x2b0
[415964.223080]  [<ffffffff805aaf33>] ? net_rx_action+0x83/0x120
[415964.223083]  [<ffffffff8025897b>] ? __do_softirq+0x7b/0x110
[415964.223086]  [<ffffffff8022d6bc>] ? call_softirq+0x1c/0x30
[415964.223088]  [<ffffffff8022f3a5>] ? do_softirq+0x35/0x70
[415964.223091]  [<ffffffff8022eb65>] ? do_IRQ+0x85/0xf0
[415964.223093]  [<ffffffff8022cf93>] ? ret_from_intr+0x0/0xa
[415964.223094]  <EOI>  [<ffffffff8063e66c>] ? _spin_lock+0xc/0x20
[415964.223099]  [<ffffffff802bbf4c>] ? d_find_alias+0x1c/0x40
[415964.223102]  [<ffffffff802be59d>] ? d_obtain_alias+0x4d/0x140
[415964.223105]  [<ffffffff80341fa3>] ? exportfs_decode_fh+0x63/0x2a0
[415964.223108]  [<ffffffff803459c0>] ? nfsd_acceptable+0x0/0x110
[415964.223111]  [<ffffffff8062a4aa>] ? cache_check+0x4a/0x4d0
[415964.223113]  [<ffffffff8034b4e7>] ? exp_find_key+0x57/0xe0
[415964.223117]  [<ffffffff8059f740>] ? sock_common_recvmsg+0x30/0x50
[415964.223119]  [<ffffffff8034b602>] ? exp_find+0x92/0xa0
[415964.223121]  [<ffffffff80345ea9>] ? fh_verify+0x369/0x680
[415964.223125]  [<ffffffff8024876e>] ? wakeup_preempt_entity+0x9e/0xb0
[415964.223127]  [<ffffffff8024c8ff>] ? try_to_wake_up+0xaf/0x200
[415964.223130]  [<ffffffff803480fe>] ? nfsd_open+0x2e/0x180
[415964.223132]  [<ffffffff803485e4>] ? nfsd_write+0xc4/0x110
[415964.223135]  [<ffffffff8034fb36>] ? nfsd3_proc_write+0xb6/0x160
[415964.223137]  [<ffffffff8034246a>] ? nfsd_dispatch+0xba/0x270
[415964.223140]  [<ffffffff80621667>] ? svc_process+0x4a7/0x800
[415964.223142]  [<ffffffff8024ca50>] ? default_wake_function+0x0/0x10
[415964.223145]  [<ffffffff8063e4b7>] ? __down_read+0x17/0xae
[415964.223147]  [<ffffffff80342b85>] ? nfsd+0xd5/0x160
[415964.223149]  [<ffffffff80342ab0>] ? nfsd+0x0/0x160
[415964.223152]  [<ffffffff80268304>] ? kthread+0x54/0x90
[415964.223154]  [<ffffffff8022d5ba>] ? child_rip+0xa/0x20
[415964.223156]  [<ffffffff802682b0>] ? kthread+0x0/0x90
[415964.223158]  [<ffffffff8022d5b0>] ? child_rip+0x0/0x20
[415964.223160] Mem-Info:
[415964.223161] DMA per-cpu:
[415964.223163] CPU    0: hi:    0, btch:   1 usd:   0
[415964.223165] CPU    1: hi:    0, btch:   1 usd:   0
[415964.223166] CPU    2: hi:    0, btch:   1 usd:   0
[415964.223168] CPU    3: hi:    0, btch:   1 usd:   0
[415964.223170] DMA32 per-cpu:
[415964.223171] CPU    0: hi:  186, btch:  31 usd: 179
[415964.223173] CPU    1: hi:  186, btch:  31 usd: 156
[415964.223175] CPU    2: hi:  186, btch:  31 usd: 225
[415964.223177] CPU    3: hi:  186, btch:  31 usd: 198
[415964.223178] Normal per-cpu:
[415964.223179] CPU    0: hi:  186, btch:  31 usd: 183
[415964.223181] CPU    1: hi:  186, btch:  31 usd: 176
[415964.223183] CPU    2: hi:  186, btch:  31 usd: 178
[415964.223185] CPU    3: hi:  186, btch:  31 usd: 215
[415964.223188] Active_anon:154810 active_file:131162 inactive_anon:33447
[415964.223189]  inactive_file:690987 unevictable:0 dirty:112116 writeback:0 unstable:0
[415964.223190]  free:8662 slab:965366 mapped:9316 pagetables:4618 bounce:0
[415964.223194] DMA free:9692kB min:16kB low:20kB high:24kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:8668kB pages_scanned:0 all_unreclaimable? yes
[415964.223197] lowmem_reserve[]: 0 3246 7980 7980
[415964.223202] DMA32 free:21312kB min:6656kB low:8320kB high:9984kB active_anon:118464kB inactive_anon:23908kB active_file:174708kB inactive_file:1206812kB unevictable:0kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[415964.223205] lowmem_reserve[]: 0 0 4734 4734
[415964.223209] Normal free:3644kB min:9708kB low:12132kB high:14560kB active_anon:500776kB inactive_anon:109880kB active_file:349940kB inactive_file:1557136kB unevictable:0kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[415964.223213] lowmem_reserve[]: 0 0 0 0
[415964.223216] DMA: 3*4kB 4*8kB 3*16kB 4*32kB 0*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9692kB
[415964.223223] DMA32: 3289*4kB 0*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 21332kB
[415964.223231] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3816kB
[415964.223238] 827035 total pagecache pages
[415964.223240] 4728 pages in swap cache
[415964.223242] Swap cache stats: add 12746, delete 8018, find 16878/17480
[415964.223243] Free swap  = 16756356kB
[415964.223244] Total swap = 16787768kB
[415964.224005] 2277376 pages RAM
[415964.224005] 252254 pages reserved
[415964.224005] 546309 pages shared
[415964.224005] 1520221 pages non-shared
[415964.252424] nfsd: page allocation failure. order:0, mode:0x20
[415964.252427] Pid: 2680, comm: nfsd Not tainted 2.6.30 #2
[415964.252429] Call Trace:
[415964.252431]  <IRQ>  [<ffffffff802849ed>] ? __alloc_pages_internal+0x3dd/0x4e0
[415964.252439]  [<ffffffff802a6c77>] ? cache_alloc_refill+0x2d7/0x570
[415964.252441]  [<ffffffff802a707d>] ? kmem_cache_alloc+0x8d/0xa0
[415964.252444]  [<ffffffff805a6109>] ? __alloc_skb+0x49/0x160
[415964.252448]  [<ffffffff805ea846>] ? tcp_send_ack+0x26/0x120
[415964.252450]  [<ffffffff805e867d>] ? tcp_rcv_established+0x7bd/0x940
[415964.252453]  [<ffffffff805efb1d>] ? tcp_v4_do_rcv+0xdd/0x210
[415964.252455]  [<ffffffff805f02d6>] ? tcp_v4_rcv+0x686/0x750
[415964.252458]  [<ffffffff805d235c>] ? ip_local_deliver_finish+0x8c/0x170
[415964.252460]  [<ffffffff805d1e51>] ? ip_rcv_finish+0x191/0x330
[415964.252462]  [<ffffffff805d2237>] ? ip_rcv+0x247/0x2e0
[415964.252466]  [<ffffffff80509fb4>] ? e1000_clean_rx_irq+0x114/0x3a0
[415964.252468]  [<ffffffff8050bd9f>] ? e1000_clean+0x7f/0x2b0
[415964.252471]  [<ffffffff805aaf33>] ? net_rx_action+0x83/0x120
[415964.252474]  [<ffffffff8025897b>] ? __do_softirq+0x7b/0x110
[415964.252477]  [<ffffffff8022d6bc>] ? call_softirq+0x1c/0x30
[415964.252480]  [<ffffffff8022f3a5>] ? do_softirq+0x35/0x70
[415964.252482]  [<ffffffff8022eb65>] ? do_IRQ+0x85/0xf0
[415964.252484]  [<ffffffff8022cf93>] ? ret_from_intr+0x0/0xa
[415964.252485]  <EOI>  [<ffffffff8063e66c>] ? _spin_lock+0xc/0x20
[415964.252491]  [<ffffffff802bbf4c>] ? d_find_alias+0x1c/0x40
[415964.252493]  [<ffffffff802be59d>] ? d_obtain_alias+0x4d/0x140
[415964.252497]  [<ffffffff80341fa3>] ? exportfs_decode_fh+0x63/0x2a0
[415964.252499]  [<ffffffff803459c0>] ? nfsd_acceptable+0x0/0x110
[415964.252502]  [<ffffffff8062a4aa>] ? cache_check+0x4a/0x4d0
[415964.252505]  [<ffffffff8034b4e7>] ? exp_find_key+0x57/0xe0
[415964.252508]  [<ffffffff8059f740>] ? sock_common_recvmsg+0x30/0x50
[415964.252511]  [<ffffffff8034b602>] ? exp_find+0x92/0xa0
[415964.252513]  [<ffffffff80345ea9>] ? fh_verify+0x369/0x680
[415964.252516]  [<ffffffff8024876e>] ? wakeup_preempt_entity+0x9e/0xb0
[415964.252519]  [<ffffffff8024c8ff>] ? try_to_wake_up+0xaf/0x200
[415964.252521]  [<ffffffff803480fe>] ? nfsd_open+0x2e/0x180
[415964.252523]  [<ffffffff803485e4>] ? nfsd_write+0xc4/0x110
[415964.252526]  [<ffffffff8034fb36>] ? nfsd3_proc_write+0xb6/0x160
[415964.252529]  [<ffffffff8034246a>] ? nfsd_dispatch+0xba/0x270
[415964.252531]  [<ffffffff80621667>] ? svc_process+0x4a7/0x800
[415964.252533]  [<ffffffff8024ca50>] ? default_wake_function+0x0/0x10
[415964.252537]  [<ffffffff8063e4b7>] ? __down_read+0x17/0xae
[415964.252539]  [<ffffffff80342b85>] ? nfsd+0xd5/0x160
[415964.252541]  [<ffffffff80342ab0>] ? nfsd+0x0/0x160
[415964.252544]  [<ffffffff80268304>] ? kthread+0x54/0x90
[415964.252546]  [<ffffffff8022d5ba>] ? child_rip+0xa/0x20
[415964.252548]  [<ffffffff802682b0>] ? kthread+0x0/0x90
[415964.252550]  [<ffffffff8022d5b0>] ? child_rip+0x0/0x20
[415964.252551] Mem-Info:
[415964.252553] DMA per-cpu:
[415964.252555] CPU    0: hi:    0, btch:   1 usd:   0
[415964.252556] CPU    1: hi:    0, btch:   1 usd:   0
[415964.252558] CPU    2: hi:    0, btch:   1 usd:   0
[415964.252560] CPU    3: hi:    0, btch:   1 usd:   0
[415964.252562] DMA32 per-cpu:
[415964.252563] CPU    0: hi:  186, btch:  31 usd: 179
[415964.252565] CPU    1: hi:  186, btch:  31 usd: 156
[415964.252567] CPU    2: hi:  186, btch:  31 usd: 225
[415964.252569] CPU    3: hi:  186, btch:  31 usd: 198
[415964.252570] Normal per-cpu:
[415964.252571] CPU    0: hi:  186, btch:  31 usd: 183
[415964.252573] CPU    1: hi:  186, btch:  31 usd: 176
[415964.252575] CPU    2: hi:  186, btch:  31 usd: 178
[415964.252577] CPU    3: hi:  186, btch:  31 usd: 215
[415964.252580] Active_anon:154810 active_file:131162 inactive_anon:33447
[415964.252581]  inactive_file:690987 unevictable:0 dirty:112116 writeback:0 unstable:0
[415964.252582]  free:8662 slab:965366 mapped:9316 pagetables:4618 bounce:0
[415964.252586] DMA free:9692kB min:16kB low:20kB high:24kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:8668kB pages_scanned:0 all_unreclaimable? yes
[415964.252588] lowmem_reserve[]: 0 3246 7980 7980
[415964.252593] DMA32 free:21312kB min:6656kB low:8320kB high:9984kB active_anon:118464kB inactive_anon:23908kB active_file:174708kB inactive_file:1206812kB unevictable:0kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[415964.252597] lowmem_reserve[]: 0 0 4734 4734
[415964.252601] Normal free:3644kB min:9708kB low:12132kB high:14560kB active_anon:500776kB inactive_anon:109880kB active_file:349940kB inactive_file:1557136kB unevictable:0kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[415964.252604] lowmem_reserve[]: 0 0 0 0
[415964.252607] DMA: 3*4kB 4*8kB 3*16kB 4*32kB 0*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9692kB
[415964.252615] DMA32: 3289*4kB 0*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 21332kB
[415964.252622] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3816kB
[415964.252630] 827035 total pagecache pages
[415964.252631] 4728 pages in swap cache
[415964.252633] Swap cache stats: add 12746, delete 8018, find 16878/17480
[415964.252635] Free swap  = 16756356kB
[415964.252636] Total swap = 16787768kB
[415964.253399] 2277376 pages RAM
[415964.253399] 252254 pages reserved
[415964.253399] 546309 pages shared
[415964.253399] 1520221 pages non-shared
[415964.281793] nfsd: page allocation failure. order:0, mode:0x20
[415964.281797] Pid: 2680, comm: nfsd Not tainted 2.6.30 #2
[415964.281798] Call Trace:
[415964.281800]  <IRQ>  [<ffffffff802849ed>] ? __alloc_pages_internal+0x3dd/0x4e0
[415964.281808]  [<ffffffff802a6c77>] ? cache_alloc_refill+0x2d7/0x570
[415964.281810]  [<ffffffff802a707d>] ? kmem_cache_alloc+0x8d/0xa0
[415964.281813]  [<ffffffff805a6109>] ? __alloc_skb+0x49/0x160
[415964.281817]  [<ffffffff805ea846>] ? tcp_send_ack+0x26/0x120
[415964.281819]  [<ffffffff805e82ad>] ? tcp_rcv_established+0x3ed/0x940
[415964.281822]  [<ffffffff805efb1d>] ? tcp_v4_do_rcv+0xdd/0x210
[415964.281824]  [<ffffffff805f02d6>] ? tcp_v4_rcv+0x686/0x750
[415964.281827]  [<ffffffff805d235c>] ? ip_local_deliver_finish+0x8c/0x170
[415964.281829]  [<ffffffff805d1e51>] ? ip_rcv_finish+0x191/0x330
[415964.281831]  [<ffffffff805d2237>] ? ip_rcv+0x247/0x2e0
[415964.281835]  [<ffffffff80509fb4>] ? e1000_clean_rx_irq+0x114/0x3a0
[415964.281837]  [<ffffffff8050bd9f>] ? e1000_clean+0x7f/0x2b0
[415964.281840]  [<ffffffff805aaf33>] ? net_rx_action+0x83/0x120
[415964.281843]  [<ffffffff8025897b>] ? __do_softirq+0x7b/0x110
[415964.281846]  [<ffffffff8022d6bc>] ? call_softirq+0x1c/0x30
[415964.281849]  [<ffffffff8022f3a5>] ? do_softirq+0x35/0x70
[415964.281851]  [<ffffffff8022eb65>] ? do_IRQ+0x85/0xf0
[415964.281853]  [<ffffffff8022cf93>] ? ret_from_intr+0x0/0xa
[415964.281854]  <EOI>  [<ffffffff8063e66c>] ? _spin_lock+0xc/0x20
[415964.281859]  [<ffffffff802bbf4c>] ? d_find_alias+0x1c/0x40
[415964.281862]  [<ffffffff802be59d>] ? d_obtain_alias+0x4d/0x140
[415964.281865]  [<ffffffff80341fa3>] ? exportfs_decode_fh+0x63/0x2a0
[415964.281868]  [<ffffffff803459c0>] ? nfsd_acceptable+0x0/0x110
[415964.281871]  [<ffffffff8062a4aa>] ? cache_check+0x4a/0x4d0
[415964.281874]  [<ffffffff8034b4e7>] ? exp_find_key+0x57/0xe0
[415964.281877]  [<ffffffff8059f740>] ? sock_common_recvmsg+0x30/0x50
[415964.281879]  [<ffffffff8034b602>] ? exp_find+0x92/0xa0
[415964.281882]  [<ffffffff80345ea9>] ? fh_verify+0x369/0x680
[415964.281885]  [<ffffffff8024876e>] ? wakeup_preempt_entity+0x9e/0xb0
[415964.281888]  [<ffffffff8024c8ff>] ? try_to_wake_up+0xaf/0x200
[415964.281890]  [<ffffffff803480fe>] ? nfsd_open+0x2e/0x180
[415964.281892]  [<ffffffff803485e4>] ? nfsd_write+0xc4/0x110
[415964.281895]  [<ffffffff8034fb36>] ? nfsd3_proc_write+0xb6/0x160
[415964.281897]  [<ffffffff8034246a>] ? nfsd_dispatch+0xba/0x270
[415964.281900]  [<ffffffff80621667>] ? svc_process+0x4a7/0x800
[415964.281902]  [<ffffffff8024ca50>] ? default_wake_function+0x0/0x10
[415964.281906]  [<ffffffff8063e4b7>] ? __down_read+0x17/0xae
[415964.281908]  [<ffffffff80342b85>] ? nfsd+0xd5/0x160
[415964.281910]  [<ffffffff80342ab0>] ? nfsd+0x0/0x160
[415964.281912]  [<ffffffff80268304>] ? kthread+0x54/0x90
[415964.281915]  [<ffffffff8022d5ba>] ? child_rip+0xa/0x20
[415964.281917]  [<ffffffff802682b0>] ? kthread+0x0/0x90
[415964.281919]  [<ffffffff8022d5b0>] ? child_rip+0x0/0x20
[415964.281920] Mem-Info:
[415964.281922] DMA per-cpu:
[415964.281923] CPU    0: hi:    0, btch:   1 usd:   0
[415964.281925] CPU    1: hi:    0, btch:   1 usd:   0
[415964.281927] CPU    2: hi:    0, btch:   1 usd:   0
[415964.281929] CPU    3: hi:    0, btch:   1 usd:   0
[415964.281930] DMA32 per-cpu:
[415964.281932] CPU    0: hi:  186, btch:  31 usd: 179
[415964.281934] CPU    1: hi:  186, btch:  31 usd: 156
[415964.281936] CPU    2: hi:  186, btch:  31 usd: 225
[415964.281937] CPU    3: hi:  186, btch:  31 usd: 198
[415964.281939] Normal per-cpu:
[415964.281940] CPU    0: hi:  186, btch:  31 usd: 183
[415964.281942] CPU    1: hi:  186, btch:  31 usd: 176
[415964.281944] CPU    2: hi:  186, btch:  31 usd: 178
[415964.281945] CPU    3: hi:  186, btch:  31 usd: 215
[415964.281949] Active_anon:154810 active_file:131162 inactive_anon:33447
[415964.281950]  inactive_file:690987 unevictable:0 dirty:112116 writeback:0 unstable:0
[415964.281951]  free:8662 slab:965366 mapped:9316 pagetables:4618 bounce:0
[415964.281955] DMA free:9692kB min:16kB low:20kB high:24kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:8668kB pages_scanned:0 all_unreclaimable? yes
[415964.281957] lowmem_reserve[]: 0 3246 7980 7980
[415964.281962] DMA32 free:21312kB min:6656kB low:8320kB high:9984kB active_anon:118464kB inactive_anon:23908kB active_file:174708kB inactive_file:1206812kB unevictable:0kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[415964.281966] lowmem_reserve[]: 0 0 4734 4734
[415964.281970] Normal free:3644kB min:9708kB low:12132kB high:14560kB active_anon:500776kB inactive_anon:109880kB active_file:349940kB inactive_file:1557136kB unevictable:0kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[415964.281973] lowmem_reserve[]: 0 0 0 0
[415964.281976] DMA: 3*4kB 4*8kB 3*16kB 4*32kB 0*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9692kB
[415964.281984] DMA32: 3289*4kB 0*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 21332kB
[415964.281991] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3816kB
[415964.281999] 827035 total pagecache pages
[415964.282001] 4728 pages in swap cache
[415964.282002] Swap cache stats: add 12746, delete 8018, find 16878/17480
[415964.282004] Free swap  = 16756356kB
[415964.282005] Total swap = 16787768kB
[415964.282766] 2277376 pages RAM
[415964.282766] 252254 pages reserved
[415964.282766] 546309 pages shared
[415964.282766] 1520221 pages non-shared
[415964.311165] nfsd: page allocation failure. order:0, mode:0x20
[415964.311168] Pid: 2680, comm: nfsd Not tainted 2.6.30 #2
[415964.311170] Call Trace:
[415964.311171]  <IRQ>  [<ffffffff802849ed>] ? __alloc_pages_internal+0x3dd/0x4e0
[415964.311179]  [<ffffffff802a6c77>] ? cache_alloc_refill+0x2d7/0x570
[415964.311182]  [<ffffffff802a707d>] ? kmem_cache_alloc+0x8d/0xa0
[415964.311185]  [<ffffffff805a6109>] ? __alloc_skb+0x49/0x160
[415964.311188]  [<ffffffff805ea846>] ? tcp_send_ack+0x26/0x120
[415964.311191]  [<ffffffff805e867d>] ? tcp_rcv_established+0x7bd/0x940
[415964.311193]  [<ffffffff805efb1d>] ? tcp_v4_do_rcv+0xdd/0x210
[415964.311195]  [<ffffffff805f02d6>] ? tcp_v4_rcv+0x686/0x750
[415964.311198]  [<ffffffff805d235c>] ? ip_local_deliver_finish+0x8c/0x170
[415964.311200]  [<ffffffff805d1e51>] ? ip_rcv_finish+0x191/0x330
[415964.311202]  [<ffffffff805d2237>] ? ip_rcv+0x247/0x2e0
[415964.311206]  [<ffffffff80509fb4>] ? e1000_clean_rx_irq+0x114/0x3a0
[415964.311208]  [<ffffffff8050bd9f>] ? e1000_clean+0x7f/0x2b0
[415964.311211]  [<ffffffff805aaf33>] ? net_rx_action+0x83/0x120
[415964.311214]  [<ffffffff8025897b>] ? __do_softirq+0x7b/0x110
[415964.311217]  [<ffffffff8022d6bc>] ? call_softirq+0x1c/0x30
[415964.311219]  [<ffffffff8022f3a5>] ? do_softirq+0x35/0x70
[415964.311222]  [<ffffffff8022eb65>] ? do_IRQ+0x85/0xf0
[415964.311224]  [<ffffffff8022cf93>] ? ret_from_intr+0x0/0xa
[415964.311225]  <EOI>  [<ffffffff8063e66c>] ? _spin_lock+0xc/0x20
[415964.311230]  [<ffffffff802bbf4c>] ? d_find_alias+0x1c/0x40
[415964.311233]  [<ffffffff802be59d>] ? d_obtain_alias+0x4d/0x140
[415964.311236]  [<ffffffff80341fa3>] ? exportfs_decode_fh+0x63/0x2a0
[415964.311239]  [<ffffffff803459c0>] ? nfsd_acceptable+0x0/0x110
[415964.311242]  [<ffffffff8062a4aa>] ? cache_check+0x4a/0x4d0
[415964.311244]  [<ffffffff8034b4e7>] ? exp_find_key+0x57/0xe0
[415964.311248]  [<ffffffff8059f740>] ? sock_common_recvmsg+0x30/0x50
[415964.311250]  [<ffffffff8034b602>] ? exp_find+0x92/0xa0
[415964.311252]  [<ffffffff80345ea9>] ? fh_verify+0x369/0x680
[415964.311256]  [<ffffffff8024876e>] ? wakeup_preempt_entity+0x9e/0xb0
[415964.311258]  [<ffffffff8024c8ff>] ? try_to_wake_up+0xaf/0x200
[415964.311261]  [<ffffffff803480fe>] ? nfsd_open+0x2e/0x180
[415964.311263]  [<ffffffff803485e4>] ? nfsd_write+0xc4/0x110
[415964.311266]  [<ffffffff8034fb36>] ? nfsd3_proc_write+0xb6/0x160
[415964.311268]  [<ffffffff8034246a>] ? nfsd_dispatch+0xba/0x270
[415964.311271]  [<ffffffff80621667>] ? svc_process+0x4a7/0x800
[415964.311273]  [<ffffffff8024ca50>] ? default_wake_function+0x0/0x10
[415964.311276]  [<ffffffff8063e4b7>] ? __down_read+0x17/0xae
[415964.311278]  [<ffffffff80342b85>] ? nfsd+0xd5/0x160
[415964.311280]  [<ffffffff80342ab0>] ? nfsd+0x0/0x160
[415964.311283]  [<ffffffff80268304>] ? kthread+0x54/0x90
[415964.311285]  [<ffffffff8022d5ba>] ? child_rip+0xa/0x20
[415964.311287]  [<ffffffff802682b0>] ? kthread+0x0/0x90
[415964.311289]  [<ffffffff8022d5b0>] ? child_rip+0x0/0x20
[415964.311291] Mem-Info:
[415964.311292] DMA per-cpu:
[415964.311294] CPU    0: hi:    0, btch:   1 usd:   0
[415964.311296] CPU    1: hi:    0, btch:   1 usd:   0
[415964.311298] CPU    2: hi:    0, btch:   1 usd:   0
[415964.311299] CPU    3: hi:    0, btch:   1 usd:   0
[415964.311301] DMA32 per-cpu:
[415964.311302] CPU    0: hi:  186, btch:  31 usd: 179
[415964.311304] CPU    1: hi:  186, btch:  31 usd: 156
[415964.311306] CPU    2: hi:  186, btch:  31 usd: 225
[415964.311308] CPU    3: hi:  186, btch:  31 usd: 198
[415964.311309] Normal per-cpu:
[415964.311311] CPU    0: hi:  186, btch:  31 usd: 183
[415964.311312] CPU    1: hi:  186, btch:  31 usd: 176
[415964.311314] CPU    2: hi:  186, btch:  31 usd: 178
[415964.311316] CPU    3: hi:  186, btch:  31 usd: 215
[415964.311319] Active_anon:154810 active_file:131162 inactive_anon:33447
[415964.311320]  inactive_file:690987 unevictable:0 dirty:112116 writeback:0 unstable:0
[415964.311321]  free:8662 slab:965366 mapped:9316 pagetables:4618 bounce:0
[415964.311325] DMA free:9692kB min:16kB low:20kB high:24kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:8668kB pages_scanned:0 all_unreclaimable? yes
[415964.311328] lowmem_reserve[]: 0 3246 7980 7980
[415964.311333] DMA32 free:21312kB min:6656kB low:8320kB high:9984kB active_anon:118464kB inactive_anon:23908kB active_file:174708kB inactive_file:1206812kB unevictable:0kB present:3324312kB pages_scanned:0 all_unreclaimable? no
[415964.311336] lowmem_reserve[]: 0 0 4734 4734
[415964.311341] Normal free:3644kB min:9708kB low:12132kB high:14560kB active_anon:500776kB inactive_anon:109880kB active_file:349940kB inactive_file:1557136kB unevictable:0kB present:4848000kB pages_scanned:0 all_unreclaimable? no
[415964.311344] lowmem_reserve[]: 0 0 0 0
[415964.311347] DMA: 3*4kB 4*8kB 3*16kB 4*32kB 0*64kB 2*128kB 2*256kB 1*512kB 2*1024kB 1*2048kB 1*4096kB = 9692kB
[415964.311354] DMA32: 3289*4kB 0*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 21332kB
[415964.311362] Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3816kB
[415964.311369] 827035 total pagecache pages
[415964.311371] 4728 pages in swap cache
[415964.311373] Swap cache stats: add 12746, delete 8018, find 16878/17480
[415964.311374] Free swap  = 16756356kB
[415964.311375] Total swap = 16787768kB
[415964.312141] 2277376 pages RAM
[415964.312141] 252254 pages reserved
[415964.312141] 546309 pages shared
[415964.312141] 1520221 pages non-shared
