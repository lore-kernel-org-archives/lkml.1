Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbZKRIJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbZKRIJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 03:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbZKRIJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 03:09:21 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:33557 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbZKRIJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 03:09:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ZUTs85imcH+FmSsIrJKBrcjSx6a91gRZkO7CsCbfov9jom0Z3bR9iAZQlENNSUk0tI
         3I8khptDt2hvliFwUNJqpp0mXgZK3W4IvLuOk3UcyyY2NrrXiHmhqMwLdTTAZtrnbtcn
         yjxdYgB1al/u/MNOa65e6vGVZUmCJ/0yrbP8U=
MIME-Version: 1.0
Date: Wed, 18 Nov 2009 16:09:25 +0800
Message-ID: <804dabb00911180009r4d1d4cc1tfee88dfac9ebd9ad@mail.gmail.com>
Subject: swapper generated call trace in 2.6.32-rc7
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From dmesg:

swapper: page allocation failure. order:1, mode:0x4020
Pid: 0, comm: swapper Not tainted 2.6.32-rc7-00029-ga9366e6 #5
Call Trace:
 <IRQ>  [<ffffffff810fb239>] __alloc_pages_nodemask+0x644/0x6bb
 [<ffffffff81097f93>] ? cpu_clock+0x2d/0x3f
 [<ffffffff81121280>] alloc_pages_current+0xb3/0xbc
 [<ffffffff81127718>] alloc_slab_page+0x1c/0x5c
 [<ffffffff811277cc>] new_slab+0x74/0x1ff
 [<ffffffff81127e46>] __slab_alloc+0x1e2/0x3ba
 [<ffffffff81bb5b03>] ? dev_alloc_skb+0x1b/0x31
 [<ffffffff810e2740>] ? time_hardirqs_off+0x19/0x1b
 [<ffffffff81129208>] __kmalloc_node_track_caller+0xcb/0x13a
 [<ffffffff810a35d3>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81bb5b03>] ? dev_alloc_skb+0x1b/0x31
 [<ffffffff81bb4ef8>] __alloc_skb+0x74/0x16d
 [<ffffffff810a35d3>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81bb5b03>] dev_alloc_skb+0x1b/0x31
 [<ffffffff81765d0f>] nv_alloc_rx_optimized+0x49/0x18a
 [<ffffffff81768523>] nv_nic_irq_optimized+0xb4/0x28b
 [<ffffffff810cd51e>] handle_IRQ_event+0x59/0x132
 [<ffffffff810cf1af>] handle_fasteoi_irq+0x90/0xd0
 [<ffffffff81038852>] handle_irq+0x8e/0x98
 [<ffffffff81037e8f>] do_IRQ+0x5f/0xbf
 [<ffffffff81036ad3>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff81d9defa>] ? __atomic_notifier_call_chain+0x0/0x8c
 [<ffffffff8103cdc6>] ? default_idle+0x3b/0x55
 [<ffffffff8103cdc4>] ? default_idle+0x39/0x55
 [<ffffffff8103544e>] ? cpu_idle+0xd7/0x115
 [<ffffffff81d964f9>] ? setup_APIC_timer+0x83/0x85
 [<ffffffff81d95bf0>] ? start_secondary+0x20d/0x258
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 167
CPU    1: hi:  186, btch:  31 usd:  42
active_anon:214900 inactive_anon:53611 isolated_anon:0
 active_file:101227 inactive_file:108408 isolated_file:0
 unevictable:0 dirty:237 writeback:0 unstable:0
 free:4655 slab_reclaimable:208678 slab_unreclaimable:33713
 mapped:20390 shmem:1740 pagetables:6994 bounce:0
Node 0 DMA free:9588kB min:20kB low:24kB high:28kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:9012kB mlocked:0kB
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB
slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2946 2946 2946
Node 0 DMA32 free:9032kB min:6932kB low:8664kB high:10396kB
active_anon:859600kB inactive_anon:214444kB active_file:404908kB
inactive_file:433632kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:3017640kB mlocked:0kB dirty:948kB
writeback:0kB mapped:81560kB shmem:6960kB slab_reclaimable:834712kB
slab_unreclaimable:134852kB kernel_stack:2304kB pagetables:27976kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 1*4kB 2*8kB 2*16kB 4*32kB 1*64kB 1*128kB 0*256kB 0*512kB
1*1024kB 0*2048kB 2*4096kB = 9588kB
Node 0 DMA32: 2042*4kB 0*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 9032kB
211410 total pagecache pages
29 pages in swap cache
Swap cache stats: add 1470, delete 1441, find 0/1
Free swap  = 7906128kB
Total swap = 7911972kB
778144 pages RAM
33837 pages reserved
221787 pages shared
575577 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=0x20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  kmalloc-4096 debugging increased min order, use slub_debug=O to disable.
  node 0: slabs: 119, objs: 833, free: 0
swapper: page allocation failure. order:1, mode:0x4020
Pid: 0, comm: swapper Not tainted 2.6.32-rc7-00029-ga9366e6 #5
Call Trace:
 <IRQ>  [<ffffffff810fb239>] __alloc_pages_nodemask+0x644/0x6bb
 [<ffffffff81097f93>] ? cpu_clock+0x2d/0x3f
 [<ffffffff81d9b2f2>] ? _spin_unlock_irqrestore+0x3d/0x4c
 [<ffffffff81121280>] alloc_pages_current+0xb3/0xbc
 [<ffffffff81127718>] alloc_slab_page+0x1c/0x5c
 [<ffffffff811277cc>] new_slab+0x74/0x1ff
 [<ffffffff81127e46>] __slab_alloc+0x1e2/0x3ba
 [<ffffffff81bb5b03>] ? dev_alloc_skb+0x1b/0x31
 [<ffffffff810e2740>] ? time_hardirqs_off+0x19/0x1b
 [<ffffffff81129208>] __kmalloc_node_track_caller+0xcb/0x13a
 [<ffffffff810a35d3>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81bb5b03>] ? dev_alloc_skb+0x1b/0x31
 [<ffffffff81bb4ef8>] __alloc_skb+0x74/0x16d
 [<ffffffff810a35d3>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81bb5b03>] dev_alloc_skb+0x1b/0x31
 [<ffffffff81765d0f>] nv_alloc_rx_optimized+0x49/0x18a
 [<ffffffff81768523>] nv_nic_irq_optimized+0xb4/0x28b
 [<ffffffff810cd51e>] handle_IRQ_event+0x59/0x132
 [<ffffffff810cf1af>] handle_fasteoi_irq+0x90/0xd0
 [<ffffffff81038852>] handle_irq+0x8e/0x98
 [<ffffffff81037e8f>] do_IRQ+0x5f/0xbf
 [<ffffffff81036ad3>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff81d9defa>] ? __atomic_notifier_call_chain+0x0/0x8c
 [<ffffffff8103cdc6>] ? default_idle+0x3b/0x55
 [<ffffffff8103cdc4>] ? default_idle+0x39/0x55
 [<ffffffff8103544e>] ? cpu_idle+0xd7/0x115
 [<ffffffff81d964f9>] ? setup_APIC_timer+0x83/0x85
 [<ffffffff81d95bf0>] ? start_secondary+0x20d/0x258
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 167
CPU    1: hi:  186, btch:  31 usd:  42
active_anon:214900 inactive_anon:53611 isolated_anon:0
 active_file:101227 inactive_file:108408 isolated_file:0
 unevictable:0 dirty:237 writeback:0 unstable:0
 free:4655 slab_reclaimable:208678 slab_unreclaimable:33713
 mapped:20390 shmem:1740 pagetables:6994 bounce:0
Node 0 DMA free:9588kB min:20kB low:24kB high:28kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:9012kB mlocked:0kB
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB
slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2946 2946 2946
Node 0 DMA32 free:9032kB min:6932kB low:8664kB high:10396kB
active_anon:859600kB inactive_anon:214444kB active_file:404908kB
inactive_file:433632kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:3017640kB mlocked:0kB dirty:948kB
writeback:0kB mapped:81560kB shmem:6960kB slab_reclaimable:834712kB
slab_unreclaimable:134852kB kernel_stack:2304kB pagetables:27976kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 1*4kB 2*8kB 2*16kB 4*32kB 1*64kB 1*128kB 0*256kB 0*512kB
1*1024kB 0*2048kB 2*4096kB = 9588kB
Node 0 DMA32: 2042*4kB 0*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 9032kB
211410 total pagecache pages
29 pages in swap cache
Swap cache stats: add 1470, delete 1441, find 0/1
Free swap  = 7906128kB
Total swap = 7911972kB
778144 pages RAM
33837 pages reserved
221787 pages shared
575577 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=0x20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  kmalloc-4096 debugging increased min order, use slub_debug=O to disable.
  node 0: slabs: 119, objs: 833, free: 0
swapper: page allocation failure. order:1, mode:0x4020
Pid: 0, comm: swapper Not tainted 2.6.32-rc7-00029-ga9366e6 #5
Call Trace:
 <IRQ>  [<ffffffff810fb239>] __alloc_pages_nodemask+0x644/0x6bb
 [<ffffffff81097f93>] ? cpu_clock+0x2d/0x3f
 [<ffffffff81d9b2f2>] ? _spin_unlock_irqrestore+0x3d/0x4c
 [<ffffffff81121280>] alloc_pages_current+0xb3/0xbc
 [<ffffffff81127718>] alloc_slab_page+0x1c/0x5c
 [<ffffffff811277cc>] new_slab+0x74/0x1ff
 [<ffffffff81127e46>] __slab_alloc+0x1e2/0x3ba
 [<ffffffff81bb5b03>] ? dev_alloc_skb+0x1b/0x31
 [<ffffffff810e2740>] ? time_hardirqs_off+0x19/0x1b
 [<ffffffff81129208>] __kmalloc_node_track_caller+0xcb/0x13a
 [<ffffffff810a35d3>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81bb5b03>] ? dev_alloc_skb+0x1b/0x31
 [<ffffffff81bb4ef8>] __alloc_skb+0x74/0x16d
 [<ffffffff810a35d3>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81bb5b03>] dev_alloc_skb+0x1b/0x31
 [<ffffffff81765d0f>] nv_alloc_rx_optimized+0x49/0x18a
 [<ffffffff81768523>] nv_nic_irq_optimized+0xb4/0x28b
 [<ffffffff810cd51e>] handle_IRQ_event+0x59/0x132
 [<ffffffff810cf1af>] handle_fasteoi_irq+0x90/0xd0
 [<ffffffff81038852>] handle_irq+0x8e/0x98
 [<ffffffff81037e8f>] do_IRQ+0x5f/0xbf
 [<ffffffff81036ad3>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff81d9defa>] ? __atomic_notifier_call_chain+0x0/0x8c
 [<ffffffff8103cdc6>] ? default_idle+0x3b/0x55
 [<ffffffff8103cdc4>] ? default_idle+0x39/0x55
 [<ffffffff8103544e>] ? cpu_idle+0xd7/0x115
 [<ffffffff81d964f9>] ? setup_APIC_timer+0x83/0x85
 [<ffffffff81d95bf0>] ? start_secondary+0x20d/0x258
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 167
CPU    1: hi:  186, btch:  31 usd:  42
active_anon:214900 inactive_anon:53611 isolated_anon:0
 active_file:101227 inactive_file:108408 isolated_file:0
 unevictable:0 dirty:237 writeback:0 unstable:0
 free:4655 slab_reclaimable:208678 slab_unreclaimable:33713
 mapped:20390 shmem:1740 pagetables:6994 bounce:0
Node 0 DMA free:9588kB min:20kB low:24kB high:28kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:9012kB mlocked:0kB
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB
slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2946 2946 2946
Node 0 DMA32 free:9032kB min:6932kB low:8664kB high:10396kB
active_anon:859600kB inactive_anon:214444kB active_file:404908kB
inactive_file:433632kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:3017640kB mlocked:0kB dirty:948kB
writeback:0kB mapped:81560kB shmem:6960kB slab_reclaimable:834712kB
slab_unreclaimable:134852kB kernel_stack:2304kB pagetables:27976kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 1*4kB 2*8kB 2*16kB 4*32kB 1*64kB 1*128kB 0*256kB 0*512kB
1*1024kB 0*2048kB 2*4096kB = 9588kB
Node 0 DMA32: 2042*4kB 0*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 9032kB
211410 total pagecache pages
29 pages in swap cache
Swap cache stats: add 1470, delete 1441, find 0/1
Free swap  = 7906128kB
Total swap = 7911972kB
778144 pages RAM
33837 pages reserved
221787 pages shared
575577 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=0x20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  kmalloc-4096 debugging increased min order, use slub_debug=O to disable.
  node 0: slabs: 119, objs: 833, free: 0
swapper: page allocation failure. order:1, mode:0x4020
Pid: 0, comm: swapper Not tainted 2.6.32-rc7-00029-ga9366e6 #5
Call Trace:
 <IRQ>  [<ffffffff810fb239>] __alloc_pages_nodemask+0x644/0x6bb
 [<ffffffff81097f93>] ? cpu_clock+0x2d/0x3f
 [<ffffffff81d9b2f2>] ? _spin_unlock_irqrestore+0x3d/0x4c
 [<ffffffff81121280>] alloc_pages_current+0xb3/0xbc
 [<ffffffff81127718>] alloc_slab_page+0x1c/0x5c
 [<ffffffff811277cc>] new_slab+0x74/0x1ff
 [<ffffffff81127e46>] __slab_alloc+0x1e2/0x3ba
 [<ffffffff81bb5b03>] ? dev_alloc_skb+0x1b/0x31
 [<ffffffff810e2740>] ? time_hardirqs_off+0x19/0x1b
 [<ffffffff81129208>] __kmalloc_node_track_caller+0xcb/0x13a
 [<ffffffff810a35d3>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81bb5b03>] ? dev_alloc_skb+0x1b/0x31
 [<ffffffff81bb4ef8>] __alloc_skb+0x74/0x16d
 [<ffffffff810a35d3>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81bb5b03>] dev_alloc_skb+0x1b/0x31
 [<ffffffff81765d0f>] nv_alloc_rx_optimized+0x49/0x18a
 [<ffffffff81768523>] nv_nic_irq_optimized+0xb4/0x28b
 [<ffffffff810cd51e>] handle_IRQ_event+0x59/0x132
 [<ffffffff810cf1af>] handle_fasteoi_irq+0x90/0xd0
 [<ffffffff81038852>] handle_irq+0x8e/0x98
 [<ffffffff81037e8f>] do_IRQ+0x5f/0xbf
 [<ffffffff81036ad3>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff81d9defa>] ? __atomic_notifier_call_chain+0x0/0x8c
 [<ffffffff8103cdc6>] ? default_idle+0x3b/0x55
 [<ffffffff8103cdc4>] ? default_idle+0x39/0x55
 [<ffffffff8103544e>] ? cpu_idle+0xd7/0x115
 [<ffffffff81d964f9>] ? setup_APIC_timer+0x83/0x85
 [<ffffffff81d95bf0>] ? start_secondary+0x20d/0x258
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 167
CPU    1: hi:  186, btch:  31 usd:  42
active_anon:214900 inactive_anon:53611 isolated_anon:0
 active_file:101227 inactive_file:108408 isolated_file:0
 unevictable:0 dirty:237 writeback:0 unstable:0
 free:4655 slab_reclaimable:208678 slab_unreclaimable:33713
 mapped:20390 shmem:1740 pagetables:6994 bounce:0
Node 0 DMA free:9588kB min:20kB low:24kB high:28kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:9012kB mlocked:0kB
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB
slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2946 2946 2946
Node 0 DMA32 free:9032kB min:6932kB low:8664kB high:10396kB
active_anon:859600kB inactive_anon:214444kB active_file:404908kB
inactive_file:433632kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:3017640kB mlocked:0kB dirty:948kB
writeback:0kB mapped:81560kB shmem:6960kB slab_reclaimable:834712kB
slab_unreclaimable:134852kB kernel_stack:2304kB pagetables:27976kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 1*4kB 2*8kB 2*16kB 4*32kB 1*64kB 1*128kB 0*256kB 0*512kB
1*1024kB 0*2048kB 2*4096kB = 9588kB
Node 0 DMA32: 2042*4kB 0*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 9032kB
211410 total pagecache pages
29 pages in swap cache
Swap cache stats: add 1470, delete 1441, find 0/1
Free swap  = 7906128kB
Total swap = 7911972kB
778144 pages RAM
33837 pages reserved
221787 pages shared
575577 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=0x20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  kmalloc-4096 debugging increased min order, use slub_debug=O to disable.
  node 0: slabs: 119, objs: 833, free: 0
swapper: page allocation failure. order:1, mode:0x4020
Pid: 0, comm: swapper Not tainted 2.6.32-rc7-00029-ga9366e6 #5
Call Trace:
 <IRQ>  [<ffffffff810fb239>] __alloc_pages_nodemask+0x644/0x6bb
 [<ffffffff81097f93>] ? cpu_clock+0x2d/0x3f
 [<ffffffff81d9b2f2>] ? _spin_unlock_irqrestore+0x3d/0x4c
 [<ffffffff81121280>] alloc_pages_current+0xb3/0xbc
 [<ffffffff81127718>] alloc_slab_page+0x1c/0x5c
 [<ffffffff811277cc>] new_slab+0x74/0x1ff
 [<ffffffff81127e46>] __slab_alloc+0x1e2/0x3ba
 [<ffffffff81bb5b03>] ? dev_alloc_skb+0x1b/0x31
 [<ffffffff810e2740>] ? time_hardirqs_off+0x19/0x1b
 [<ffffffff81129208>] __kmalloc_node_track_caller+0xcb/0x13a
 [<ffffffff810a35d3>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81bb5b03>] ? dev_alloc_skb+0x1b/0x31
 [<ffffffff81bb4ef8>] __alloc_skb+0x74/0x16d
 [<ffffffff810a35d3>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81bb5b03>] dev_alloc_skb+0x1b/0x31
 [<ffffffff81765d0f>] nv_alloc_rx_optimized+0x49/0x18a
 [<ffffffff81768523>] nv_nic_irq_optimized+0xb4/0x28b
 [<ffffffff810cd51e>] handle_IRQ_event+0x59/0x132
 [<ffffffff810cf1af>] handle_fasteoi_irq+0x90/0xd0
 [<ffffffff81038852>] handle_irq+0x8e/0x98
 [<ffffffff81037e8f>] do_IRQ+0x5f/0xbf
 [<ffffffff81036ad3>] ret_from_intr+0x0/0xf
 [<ffffffff8107aa64>] ? __do_softirq+0x80/0x1b8
 [<ffffffff810372bc>] ? call_softirq+0x1c/0x28
 [<ffffffff81038601>] ? do_softirq+0x3d/0x88
 [<ffffffff8107a399>] ? irq_exit+0x4a/0x4c
 [<ffffffff81037ed8>] ? do_IRQ+0xa8/0xbf
 [<ffffffff81036ad3>] ? ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff81d9defa>] ? __atomic_notifier_call_chain+0x0/0x8c
 [<ffffffff8103cdc6>] ? default_idle+0x3b/0x55
 [<ffffffff8103cdc4>] ? default_idle+0x39/0x55
 [<ffffffff8103544e>] ? cpu_idle+0xd7/0x115
 [<ffffffff81d964f9>] ? setup_APIC_timer+0x83/0x85
 [<ffffffff81d95bf0>] ? start_secondary+0x20d/0x258
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 167
CPU    1: hi:  186, btch:  31 usd:  42
active_anon:214900 inactive_anon:53611 isolated_anon:0
 active_file:101227 inactive_file:108408 isolated_file:0
 unevictable:0 dirty:237 writeback:0 unstable:0
 free:4655 slab_reclaimable:208678 slab_unreclaimable:33713
 mapped:20390 shmem:1740 pagetables:6994 bounce:0
Node 0 DMA free:9588kB min:20kB low:24kB high:28kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:9012kB mlocked:0kB
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB
slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2946 2946 2946
Node 0 DMA32 free:9032kB min:6932kB low:8664kB high:10396kB
active_anon:859600kB inactive_anon:214444kB active_file:404908kB
inactive_file:433632kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:3017640kB mlocked:0kB dirty:948kB
writeback:0kB mapped:81560kB shmem:6960kB slab_reclaimable:834712kB
slab_unreclaimable:134852kB kernel_stack:2304kB pagetables:27976kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 1*4kB 2*8kB 2*16kB 4*32kB 1*64kB 1*128kB 0*256kB 0*512kB
1*1024kB 0*2048kB 2*4096kB = 9588kB
Node 0 DMA32: 2042*4kB 0*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 9032kB
211410 total pagecache pages
29 pages in swap cache
Swap cache stats: add 1470, delete 1441, find 0/1
Free swap  = 7906128kB
Total swap = 7911972kB
778144 pages RAM
33837 pages reserved
221786 pages shared
575584 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=0x20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  kmalloc-4096 debugging increased min order, use slub_debug=O to disable.
  node 0: slabs: 119, objs: 833, free: 0
firefox used greatest stack depth: 3408 bytes left


And the .config file for compilation is here:

http://pastebin.com/f41e41b0c

(the kernel is compiled from linus git-tree 2.6.32-rc7).


-- 
Regards,
Peter Teoh
