Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbZGNKO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbZGNKO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 06:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbZGNKO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 06:14:28 -0400
Received: from mail-a04.ithnet.com ([217.64.83.99]:34212 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754365AbZGNKOZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 06:14:25 -0400
X-Sender-Authentication: net64
Date: Tue, 14 Jul 2009 12:14:18 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: What to do with this message (2.6.30.1) ?
Message-Id: <20090714121418.7f3c3608.skraw@ithnet.com>
In-Reply-To: <4807377b0907132240g6f74c9cbnf1302d354a0e0a72@mail.gmail.com>
References: <20090713134621.124aa18e.skraw@ithnet.com>
	<4807377b0907132240g6f74c9cbnf1302d354a0e0a72@mail.gmail.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 22:40:39 -0700
Jesse Brandeburg <jesse.brandeburg@gmail.com> wrote:

> On Mon, Jul 13, 2009 at 4:46 AM, Stephan von Krawczynski
> <skraw@ithnet.com> wrote:
> >
> > Hello all,
> >
> > first day of using 2.6.30.1 on a box that mostly accepts rsync connections
> > revealed this message. This is in fact not the only one of this type. Quite
> > a lot from other processes follow. What can I do to prevent that? Is that
> > a kind of a bug?
> > I did not experience that on a box with the same job using tg3 instead of
> > e1000e.
> >
> > Jul 13 01:10:57 backup kernel: swapper: page allocation failure. order:0, mode:0x20
> > Jul 13 01:10:57 backup kernel: Pid: 0, comm: swapper Not tainted 2.6.30.1 #3
> > Jul 13 01:10:57 backup kernel: Call Trace:
> > Jul 13 01:10:57 backup kernel:  <IRQ>  [<ffffffff80269182>] ? __alloc_pages_internal+0x3df/0x3ff
> > Jul 13 01:10:57 backup kernel:  [<ffffffff802876cf>] ? cache_alloc_refill+0x25e/0x4a0
> > Jul 13 01:10:57 backup kernel:  [<ffffffff803eb067>] ? sock_def_readable+0x10/0x62
> > Jul 13 01:10:57 backup kernel:  [<ffffffff8028798a>] ? __kmalloc+0x79/0xa1
> > Jul 13 01:10:57 backup kernel:  [<ffffffff803ef98a>] ? __alloc_skb+0x5c/0x12a
> > Jul 13 01:10:57 backup kernel:  [<ffffffff803f0558>] ? __netdev_alloc_skb+0x15/0x2f
> > Jul 13 01:10:57 backup kernel:  [<ffffffffa000cda0>] ? e1000_alloc_rx_buffers+0x8c/0x248 [e1000e]
> > Jul 13 01:10:57 backup kernel:  [<ffffffffa000d262>] ? e1000_clean_rx_irq+0x2a2/0x2db [e1000e]
> > Jul 13 01:10:57 backup kernel:  [<ffffffffa000e8dc>] ? e1000_clean+0x70/0x219 [e1000e]
> > Jul 13 01:10:57 backup kernel:  [<ffffffff803f3adf>] ? net_rx_action+0x69/0x11f
> > Jul 13 01:10:58 backup kernel:  [<ffffffff802373eb>] ? __do_softirq+0x66/0xf7
> > Jul 13 01:10:58 backup kernel:  [<ffffffff8020bebc>] ? call_softirq+0x1c/0x28
> > Jul 13 01:10:58 backup kernel:  [<ffffffff8020d680>] ? do_softirq+0x2c/0x68
> > Jul 13 01:10:58 backup kernel:  [<ffffffff8020cf62>] ? do_IRQ+0xa9/0xbf
> > Jul 13 01:10:58 backup kernel:  [<ffffffff8020b793>] ? ret_from_intr+0x0/0xa
> > Jul 13 01:10:58 backup kernel:  <EOI>  [<ffffffff802116d8>] ? mwait_idle+0x6e/0x73
> > Jul 13 01:10:58 backup kernel:  [<ffffffff802116d8>] ? mwait_idle+0x6e/0x73
> > Jul 13 01:10:58 backup kernel:  [<ffffffff8020a1cb>] ? cpu_idle+0x40/0x7c
> > Jul 13 01:10:58 backup kernel:  [<ffffffff805a7bb0>] ? start_kernel+0x31e/0x32a
> > Jul 13 01:10:58 backup kernel:  [<ffffffff805a737e>] ? x86_64_start_kernel+0xe5/0xeb
> > Jul 13 01:10:58 backup kernel: DMA per-cpu:
> > Jul 13 01:10:58 backup kernel: CPU    0: hi:    0, btch:   1 usd:   0
> > Jul 13 01:10:58 backup kernel: CPU    1: hi:    0, btch:   1 usd:   0
> > Jul 13 01:10:58 backup kernel: CPU    2: hi:    0, btch:   1 usd:   0
> > Jul 13 01:10:58 backup kernel: CPU    3: hi:    0, btch:   1 usd:   0
> > Jul 13 01:10:58 backup kernel: DMA32 per-cpu:
> > Jul 13 01:10:58 backup kernel: CPU    0: hi:  186, btch:  31 usd: 130
> > Jul 13 01:10:58 backup kernel: CPU    1: hi:  186, btch:  31 usd:  90
> > Jul 13 01:10:59 backup kernel: CPU    2: hi:  186, btch:  31 usd: 142
> > Jul 13 01:10:59 backup kernel: CPU    3: hi:  186, btch:  31 usd: 177
> > Jul 13 01:10:59 backup kernel: Normal per-cpu:
> > Jul 13 01:10:59 backup kernel: CPU    0: hi:  186, btch:  31 usd:  76
> > Jul 13 01:10:59 backup kernel: CPU    1: hi:  186, btch:  31 usd: 160
> > Jul 13 01:10:59 backup kernel: CPU    2: hi:  186, btch:  31 usd: 170
> > Jul 13 01:10:59 backup kernel: CPU    3: hi:  186, btch:  31 usd: 165
> > Jul 13 01:10:59 backup kernel: Active_anon:117688 active_file:169003 inactive_anon:22048
> > Jul 13 01:10:59 backup kernel:  inactive_file:1425813 unevictable:0 dirty:337125 writeback:4493 unstable:0
> > Jul 13 01:10:59 backup kernel:  free:8260 slab:297474 mapped:1475 pagetables:1685 bounce:0
> > Jul 13 01:11:00 backup kernel: DMA free:11712kB min:12kB low:12kB high:16kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:10756kB pages_scanned:0 all_unreclaimable? yes
> > Jul 13 01:11:00 backup kernel: lowmem_reserve[]: 0 3767 8059 8059
> > Jul 13 01:11:00 backup kernel: DMA32 free:19060kB min:5364kB low:6704kB high:8044kB active_anon:180632kB inactive_anon:38496kB active_file:318456kB inactive_file:2581460kB unevictable:0kB present:3857440kB pages_scanned:0 all_unreclaimable? no
> > Jul 13 01:11:00 backup kernel: lowmem_reserve[]: 0 0 4292 4292
> > Jul 13 01:11:00 backup kernel: Normal free:2268kB min:6112kB low:7640kB high:9168kB active_anon:290120kB inactive_anon:49696kB active_file:357556kB inactive_file:3121792kB unevictable:0kB present:4395520kB pages_scanned:0 all_unreclaimable? no
> > Jul 13 01:11:00 backup kernel: lowmem_reserve[]: 0 0 0 0
> > Jul 13 01:11:00 backup kernel: DMA: 6*4kB 3*8kB 3*16kB 3*32kB 4*64kB 2*128kB 1*256kB 1*512kB 2*1024kB 0*2048kB 2*4096kB = 11712kB
> > Jul 13 01:11:00 backup kernel: DMA32: 2720*4kB 2*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 19040kB
> > Jul 13 01:11:00 backup kernel: Normal: 1*4kB 1*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2236kB
> > Jul 13 01:11:00 backup kernel: 1594864 total pagecache pages
> > Jul 13 01:11:00 backup kernel: 9 pages in swap cache
> > Jul 13 01:11:00 backup kernel: Swap cache stats: add 1047, delete 1038, find 0/0
> > Jul 13 01:11:00 backup kernel: Free swap  = 2100300kB
> > Jul 13 01:11:00 backup kernel: Total swap = 2104488kB
> 
> Try increasing /proc/sys/vm/min_free_kbytes
> 
> can you show some more of the messages?

Sure, right after the above these followed:

Jul 13 01:11:00 backup kernel: klogd: page allocation failure. order:0, mode:0x20
Jul 13 01:11:00 backup kernel: Pid: 2701, comm: klogd Not tainted 2.6.30.1 #3
Jul 13 01:11:00 backup kernel: Call Trace:
Jul 13 01:11:00 backup kernel:  <IRQ>  [<ffffffff80269182>] ? __alloc_pages_internal+0x3df/0x3ff
Jul 13 01:11:00 backup kernel:  [<ffffffff802876cf>] ? cache_alloc_refill+0x25e/0x4a0
Jul 13 01:11:00 backup kernel:  [<ffffffff803eb067>] ? sock_def_readable+0x10/0x62   
Jul 13 01:11:00 backup kernel:  [<ffffffff8028798a>] ? __kmalloc+0x79/0xa1
Jul 13 01:11:00 backup kernel:  [<ffffffff803ef98a>] ? __alloc_skb+0x5c/0x12a
Jul 13 01:11:00 backup kernel:  [<ffffffff803f0558>] ? __netdev_alloc_skb+0x15/0x2f
Jul 13 01:11:00 backup kernel:  [<ffffffffa000cda0>] ? e1000_alloc_rx_buffers+0x8c/0x248 [e1000e]
Jul 13 01:11:00 backup kernel:  [<ffffffffa000d204>] ? e1000_clean_rx_irq+0x244/0x2db [e1000e]   
Jul 13 01:11:00 backup kernel:  [<ffffffffa000e8dc>] ? e1000_clean+0x70/0x219 [e1000e]
Jul 13 01:11:01 backup kernel:  [<ffffffff803f3adf>] ? net_rx_action+0x69/0x11f
Jul 13 01:11:01 backup kernel:  [<ffffffff802373eb>] ? __do_softirq+0x66/0xf7  
Jul 13 01:11:01 backup kernel:  [<ffffffff8020bebc>] ? call_softirq+0x1c/0x28  
Jul 13 01:11:01 backup kernel:  [<ffffffff8020d680>] ? do_softirq+0x2c/0x68    
Jul 13 01:11:01 backup kernel:  [<ffffffff8020cf62>] ? do_IRQ+0xa9/0xbf
Jul 13 01:11:01 backup kernel:  [<ffffffff8020b793>] ? ret_from_intr+0x0/0xa
Jul 13 01:11:01 backup kernel:  <EOI>  [<ffffffff80233b35>] ? do_syslog+0x15a/0x345
Jul 13 01:11:01 backup kernel:  [<ffffffff80233b4b>] ? do_syslog+0x170/0x345
Jul 13 01:11:01 backup kernel:  [<ffffffff80244490>] ? autoremove_wake_function+0x0/0x2e
Jul 13 01:11:01 backup kernel:  [<ffffffff802d1229>] ? kmsg_read+0x3a/0x45
Jul 13 01:11:01 backup kernel:  [<ffffffff802c9a6e>] ? proc_reg_read+0x6d/0x88
Jul 13 01:11:01 backup kernel:  [<ffffffff8028c15c>] ? vfs_read+0xaa/0x133
Jul 13 01:11:01 backup kernel:  [<ffffffff8028c2a1>] ? sys_read+0x45/0x6e 
Jul 13 01:11:01 backup kernel:  [<ffffffff8020adeb>] ? system_call_fastpath+0x16/0x1b
Jul 13 01:11:01 backup kernel: Mem-Info:
Jul 13 01:11:01 backup kernel: DMA per-cpu:
Jul 13 01:11:01 backup kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jul 13 01:11:01 backup kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jul 13 01:11:01 backup kernel: CPU    2: hi:    0, btch:   1 usd:   0
Jul 13 01:11:01 backup kernel: CPU    3: hi:    0, btch:   1 usd:   0
Jul 13 01:11:01 backup kernel: DMA32 per-cpu:
Jul 13 01:11:01 backup kernel: CPU    0: hi:  186, btch:  31 usd: 130
Jul 13 01:11:01 backup kernel: CPU    1: hi:  186, btch:  31 usd:  90
Jul 13 01:11:01 backup kernel: CPU    2: hi:  186, btch:  31 usd: 142
Jul 13 01:11:01 backup kernel: CPU    3: hi:  186, btch:  31 usd: 177
Jul 13 01:11:01 backup kernel: Normal per-cpu:
Jul 13 01:11:01 backup kernel: CPU    0: hi:  186, btch:  31 usd:  76
Jul 13 01:11:01 backup kernel: CPU    1: hi:  186, btch:  31 usd: 160
Jul 13 01:11:01 backup kernel: CPU    2: hi:  186, btch:  31 usd: 170
Jul 13 01:11:01 backup kernel: CPU    3: hi:  186, btch:  31 usd: 165
Jul 13 01:11:02 backup kernel: Active_anon:117688 active_file:169003 inactive_anon:22048
Jul 13 01:11:02 backup kernel:  inactive_file:1425813 unevictable:0 dirty:337125 writeback:4493 unstable:0
Jul 13 01:11:02 backup kernel:  free:8260 slab:297474 mapped:1475 pagetables:1685 bounce:0
Jul 13 01:11:02 backup kernel: DMA free:11712kB min:12kB low:12kB high:16kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:10756kB pages_scanned:0 all_unreclaimable? yes
Jul 13 01:11:02 backup kernel: lowmem_reserve[]: 0 3767 8059 8059
Jul 13 01:11:02 backup kernel: DMA32 free:19060kB min:5364kB low:6704kB high:8044kB active_anon:180632kB inactive_anon:38496kB active_file:318456kB inactive_file:2581460kB unevictable:0kB present:3857440kB pages_scanned:0 all_unreclaimable? no
Jul 13 01:11:02 backup kernel: lowmem_reserve[]: 0 0 4292 4292
Jul 13 01:11:02 backup kernel: Normal free:2268kB min:6112kB low:7640kB high:9168kB active_anon:290120kB inactive_anon:49696kB active_file:357556kB inactive_file:3121792kB unevictable:0kB present:4395520kB pages_scanned:0 all_unreclaimable? no
Jul 13 01:11:02 backup kernel: lowmem_reserve[]: 0 0 0 0
Jul 13 01:11:02 backup kernel: DMA: 6*4kB 3*8kB 3*16kB 3*32kB 4*64kB 2*128kB 1*256kB 1*512kB 2*1024kB 0*2048kB 2*4096kB = 11712kB
Jul 13 01:11:02 backup kernel: DMA32: 2720*4kB 2*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 19040kB
Jul 13 01:11:02 backup kernel: Normal: 1*4kB 1*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2236kB   
Jul 13 01:11:02 backup kernel: 1594864 total pagecache pages
Jul 13 01:11:02 backup kernel: 9 pages in swap cache
Jul 13 01:11:02 backup kernel: Swap cache stats: add 1047, delete 1038, find 0/0
Jul 13 01:11:02 backup kernel: Free swap  = 2100300kB
Jul 13 01:11:02 backup kernel: Total swap = 2104488kB
Jul 13 01:11:02 backup kernel: 2162672 pages RAM
Jul 13 01:11:02 backup kernel: 116410 pages reserved
Jul 13 01:11:02 backup kernel: 1512138 pages shared 
Jul 13 01:11:07 backup kernel: 529843 pages non-shared

And then:

Jul 13 01:11:07 backup kernel: klogd: page allocation failure. order:0, mode:0x20
Jul 13 01:11:07 backup kernel: Pid: 2701, comm: klogd Not tainted 2.6.30.1 #3
Jul 13 01:11:07 backup kernel: Call Trace:
Jul 13 01:11:07 backup kernel:  <IRQ>  [<ffffffff80269182>] ? __alloc_pages_internal+0x3df/0x3ff
Jul 13 01:11:07 backup kernel:  [<ffffffff802876cf>] ? cache_alloc_refill+0x25e/0x4a0
Jul 13 01:11:07 backup kernel:  [<ffffffff803eb067>] ? sock_def_readable+0x10/0x62   
Jul 13 01:11:07 backup kernel:  [<ffffffff8028798a>] ? __kmalloc+0x79/0xa1
Jul 13 01:11:07 backup kernel:  [<ffffffff803ef98a>] ? __alloc_skb+0x5c/0x12a
Jul 13 01:11:07 backup kernel:  [<ffffffff803f0558>] ? __netdev_alloc_skb+0x15/0x2f
Jul 13 01:11:08 backup kernel:  [<ffffffffa000cda0>] ? e1000_alloc_rx_buffers+0x8c/0x248 [e1000e]
Jul 13 01:11:08 backup kernel:  [<ffffffffa000d204>] ? e1000_clean_rx_irq+0x244/0x2db [e1000e]   
Jul 13 01:11:08 backup kernel:  [<ffffffffa000e8dc>] ? e1000_clean+0x70/0x219 [e1000e]
Jul 13 01:11:08 backup kernel:  [<ffffffff803f3adf>] ? net_rx_action+0x69/0x11f
Jul 13 01:11:08 backup kernel:  [<ffffffff802373eb>] ? __do_softirq+0x66/0xf7  
Jul 13 01:11:08 backup kernel:  [<ffffffff8020bebc>] ? call_softirq+0x1c/0x28  
Jul 13 01:11:08 backup kernel:  [<ffffffff8020d680>] ? do_softirq+0x2c/0x68    
Jul 13 01:11:08 backup kernel:  [<ffffffff8020cf62>] ? do_IRQ+0xa9/0xbf
Jul 13 01:11:08 backup kernel:  [<ffffffff8020b793>] ? ret_from_intr+0x0/0xa
Jul 13 01:11:08 backup kernel:  <EOI>  [<ffffffff80233b35>] ? do_syslog+0x15a/0x345
Jul 13 01:11:08 backup kernel:  [<ffffffff80233b4b>] ? do_syslog+0x170/0x345
Jul 13 01:11:08 backup kernel:  [<ffffffff80244490>] ? autoremove_wake_function+0x0/0x2e
Jul 13 01:11:08 backup kernel:  [<ffffffff802d1229>] ? kmsg_read+0x3a/0x45
Jul 13 01:11:08 backup kernel:  [<ffffffff802c9a6e>] ? proc_reg_read+0x6d/0x88
Jul 13 01:11:08 backup kernel:  [<ffffffff8028c15c>] ? vfs_read+0xaa/0x133
Jul 13 01:11:08 backup kernel:  [<ffffffff8028c2a1>] ? sys_read+0x45/0x6e 
Jul 13 01:11:08 backup kernel:  [<ffffffff8020adeb>] ? system_call_fastpath+0x16/0x1b
Jul 13 01:11:08 backup kernel: Mem-Info:
Jul 13 01:11:08 backup kernel: DMA per-cpu:
Jul 13 01:11:08 backup kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jul 13 01:11:08 backup kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jul 13 01:11:08 backup kernel: CPU    2: hi:    0, btch:   1 usd:   0
Jul 13 01:11:08 backup kernel: CPU    3: hi:    0, btch:   1 usd:   0
Jul 13 01:11:08 backup kernel: DMA32 per-cpu:
Jul 13 01:11:08 backup kernel: CPU    0: hi:  186, btch:  31 usd: 130
Jul 13 01:11:08 backup kernel: CPU    1: hi:  186, btch:  31 usd:  90
Jul 13 01:11:08 backup kernel: CPU    2: hi:  186, btch:  31 usd: 142
Jul 13 01:11:08 backup kernel: CPU    3: hi:  186, btch:  31 usd: 177
Jul 13 01:11:08 backup kernel: Normal per-cpu:
Jul 13 01:11:08 backup kernel: CPU    0: hi:  186, btch:  31 usd:  76
Jul 13 01:11:08 backup kernel: CPU    1: hi:  186, btch:  31 usd: 160
Jul 13 01:11:08 backup kernel: CPU    2: hi:  186, btch:  31 usd: 170
Jul 13 01:11:08 backup kernel: CPU    3: hi:  186, btch:  31 usd: 165
Jul 13 01:11:08 backup kernel: Active_anon:117688 active_file:169003 inactive_anon:22048
Jul 13 01:11:08 backup kernel:  inactive_file:1425813 unevictable:0 dirty:337125 writeback:4493 unstable:0
Jul 13 01:11:08 backup kernel:  free:8260 slab:297474 mapped:1475 pagetables:1685 bounce:0
Jul 13 01:11:08 backup kernel: DMA free:11712kB min:12kB low:12kB high:16kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:10756kB pages_scanned:0 all_unreclaimable? yes
Jul 13 01:11:08 backup kernel: lowmem_reserve[]: 0 3767 8059 8059
Jul 13 01:11:08 backup kernel: DMA32 free:19060kB min:5364kB low:6704kB high:8044kB active_anon:180632kB inactive_anon:38496kB active_file:318456kB inactive_file:2581460kB unevictable:0kB present:3857440kB pages_scanned:0 all_unreclaimable? no
Jul 13 01:11:08 backup kernel: lowmem_reserve[]: 0 0 4292 4292
Jul 13 01:11:09 backup kernel: Normal free:2268kB min:6112kB low:7640kB high:9168kB active_anon:290120kB inactive_anon:49696kB active_file:357556kB inactive_file:3121792kB unevictable:0kB present:4395520kB pages_scanned:0 all_unreclaimable? no
Jul 13 01:11:09 backup kernel: lowmem_reserve[]: 0 0 0 0
Jul 13 01:11:09 backup kernel: DMA: 6*4kB 3*8kB 3*16kB 3*32kB 4*64kB 2*128kB 1*256kB 1*512kB 2*1024kB 0*2048kB 2*4096kB = 11712kB
Jul 13 01:11:09 backup kernel: DMA32: 2720*4kB 2*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 19040kB
Jul 13 01:11:09 backup kernel: Normal: 1*4kB 1*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2236kB   
Jul 13 01:11:09 backup kernel: 1594864 total pagecache pages
Jul 13 01:11:09 backup kernel: 9 pages in swap cache
Jul 13 01:11:09 backup kernel: Swap cache stats: add 1047, delete 1038, find 0/0
Jul 13 01:11:09 backup kernel: Free swap  = 2100300kB
Jul 13 01:11:09 backup kernel: Total swap = 2104488kB
Jul 13 01:11:09 backup kernel: 2162672 pages RAM
Jul 13 01:11:09 backup kernel: 116410 pages reserved
Jul 13 01:11:09 backup kernel: 1512138 pages shared 
Jul 13 01:11:09 backup kernel: 529843 pages non-shared

And again klogd:

Jul 13 01:11:09 backup kernel: klogd: page allocation failure. order:0, mode:0x20
Jul 13 01:11:09 backup kernel: Pid: 2701, comm: klogd Not tainted 2.6.30.1 #3
Jul 13 01:11:09 backup kernel: Call Trace:
Jul 13 01:11:09 backup kernel:  <IRQ>  [<ffffffff80269182>] ? __alloc_pages_internal+0x3df/0x3ff
Jul 13 01:11:09 backup kernel:  [<ffffffff802876cf>] ? cache_alloc_refill+0x25e/0x4a0
Jul 13 01:11:09 backup kernel:  [<ffffffff803eb067>] ? sock_def_readable+0x10/0x62   
Jul 13 01:11:09 backup kernel:  [<ffffffff8028798a>] ? __kmalloc+0x79/0xa1
Jul 13 01:11:09 backup kernel:  [<ffffffff803ef98a>] ? __alloc_skb+0x5c/0x12a
Jul 13 01:11:09 backup kernel:  [<ffffffff803f0558>] ? __netdev_alloc_skb+0x15/0x2f
Jul 13 01:11:09 backup kernel:  [<ffffffffa000cda0>] ? e1000_alloc_rx_buffers+0x8c/0x248 [e1000e]
Jul 13 01:11:09 backup kernel:  [<ffffffffa000d204>] ? e1000_clean_rx_irq+0x244/0x2db [e1000e]   
Jul 13 01:11:09 backup kernel:  [<ffffffffa000e8dc>] ? e1000_clean+0x70/0x219 [e1000e]
Jul 13 01:11:09 backup kernel:  [<ffffffff803f3adf>] ? net_rx_action+0x69/0x11f
Jul 13 01:11:09 backup kernel:  [<ffffffff802373eb>] ? __do_softirq+0x66/0xf7  
Jul 13 01:11:09 backup kernel:  [<ffffffff8020bebc>] ? call_softirq+0x1c/0x28  
Jul 13 01:11:09 backup kernel:  [<ffffffff8020d680>] ? do_softirq+0x2c/0x68    
Jul 13 01:11:09 backup kernel:  [<ffffffff8020cf62>] ? do_IRQ+0xa9/0xbf
Jul 13 01:11:09 backup kernel:  [<ffffffff8020b793>] ? ret_from_intr+0x0/0xa
Jul 13 01:11:09 backup kernel:  <EOI>  [<ffffffff80233b35>] ? do_syslog+0x15a/0x345
Jul 13 01:11:09 backup kernel:  [<ffffffff80233b4b>] ? do_syslog+0x170/0x345
Jul 13 01:11:09 backup kernel:  [<ffffffff80244490>] ? autoremove_wake_function+0x0/0x2e
Jul 13 01:11:09 backup kernel:  [<ffffffff802d1229>] ? kmsg_read+0x3a/0x45
Jul 13 01:11:09 backup kernel:  [<ffffffff802c9a6e>] ? proc_reg_read+0x6d/0x88
Jul 13 01:11:09 backup kernel:  [<ffffffff8028c15c>] ? vfs_read+0xaa/0x133
Jul 13 01:11:09 backup kernel:  [<ffffffff8028c2a1>] ? sys_read+0x45/0x6e 
Jul 13 01:11:09 backup kernel:  [<ffffffff8020adeb>] ? system_call_fastpath+0x16/0x1b
Jul 13 01:11:09 backup kernel: Mem-Info:
Jul 13 01:11:09 backup kernel: DMA per-cpu:
Jul 13 01:11:09 backup kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jul 13 01:11:09 backup kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jul 13 01:11:09 backup kernel: CPU    2: hi:    0, btch:   1 usd:   0
Jul 13 01:11:09 backup kernel: CPU    3: hi:    0, btch:   1 usd:   0
Jul 13 01:11:09 backup kernel: DMA32 per-cpu:
Jul 13 01:11:09 backup kernel: CPU    0: hi:  186, btch:  31 usd: 130
Jul 13 01:11:09 backup kernel: CPU    1: hi:  186, btch:  31 usd:  90
Jul 13 01:11:09 backup kernel: CPU    2: hi:  186, btch:  31 usd: 142
Jul 13 01:11:10 backup kernel: CPU    3: hi:  186, btch:  31 usd: 177
Jul 13 01:11:10 backup kernel: Normal per-cpu:
Jul 13 01:11:10 backup kernel: CPU    0: hi:  186, btch:  31 usd:  76
Jul 13 01:11:10 backup kernel: CPU    1: hi:  186, btch:  31 usd: 160
Jul 13 01:11:10 backup kernel: CPU    2: hi:  186, btch:  31 usd: 170
Jul 13 01:11:10 backup kernel: CPU    3: hi:  186, btch:  31 usd: 165
Jul 13 01:11:10 backup kernel: Active_anon:117688 active_file:169003 inactive_anon:22048
Jul 13 01:11:10 backup kernel:  inactive_file:1425813 unevictable:0 dirty:337125 writeback:4493 unstable:0
Jul 13 01:11:10 backup kernel:  free:8260 slab:297474 mapped:1475 pagetables:1685 bounce:0
Jul 13 01:11:10 backup kernel: DMA free:11712kB min:12kB low:12kB high:16kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:10756kB pages_scanned:0 all_unreclaimable? yes
Jul 13 01:11:10 backup kernel: lowmem_reserve[]: 0 3767 8059 8059
Jul 13 01:11:10 backup kernel: DMA32 free:19060kB min:5364kB low:6704kB high:8044kB active_anon:180632kB inactive_anon:38496kB active_file:318456kB inactive_file:2581460kB unevictable:0kB present:3857440kB pages_scanned:0 all_unreclaimable? no
Jul 13 01:11:10 backup kernel: lowmem_reserve[]: 0 0 4292 4292
Jul 13 01:11:10 backup kernel: Normal free:2268kB min:6112kB low:7640kB high:9168kB active_anon:290120kB inactive_anon:49696kB active_file:357556kB inactive_file:3121792kB unevictable:0kB present:4395520kB pages_scanned:0 all_unreclaimable? no
Jul 13 01:11:10 backup kernel: lowmem_reserve[]: 0 0 0 0
Jul 13 01:11:10 backup kernel: DMA: 6*4kB 3*8kB 3*16kB 3*32kB 4*64kB 2*128kB 1*256kB 1*512kB 2*1024kB 0*2048kB 2*4096kB = 11712kB
Jul 13 01:11:10 backup kernel: DMA32: 2720*4kB 2*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 19040kB
Jul 13 01:11:10 backup kernel: Normal: 1*4kB 1*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2236kB   
Jul 13 01:11:10 backup kernel: 1594864 total pagecache pages
Jul 13 01:11:10 backup kernel: 9 pages in swap cache
Jul 13 01:11:10 backup kernel: Swap cache stats: add 1047, delete 1038, find 0/0
Jul 13 01:11:10 backup kernel: Free swap  = 2100300kB
Jul 13 01:11:10 backup kernel: Total swap = 2104488kB
Jul 13 01:11:10 backup kernel: 2162672 pages RAM
Jul 13 01:11:10 backup kernel: 116410 pages reserved
Jul 13 01:11:10 backup kernel: 1512138 pages shared 
Jul 13 01:11:10 backup kernel: 529843 pages non-shared

And the last one in row:

Jul 13 01:11:10 backup kernel: klogd: page allocation failure. order:0, mode:0x20
Jul 13 01:11:10 backup kernel: Pid: 2701, comm: klogd Not tainted 2.6.30.1 #3
Jul 13 01:11:10 backup kernel: Call Trace:
Jul 13 01:11:10 backup kernel:  <IRQ>  [<ffffffff80269182>] ? __alloc_pages_internal+0x3df/0x3ff
Jul 13 01:11:10 backup kernel:  [<ffffffff802876cf>] ? cache_alloc_refill+0x25e/0x4a0
Jul 13 01:11:10 backup kernel:  [<ffffffff803eb067>] ? sock_def_readable+0x10/0x62   
Jul 13 01:11:10 backup kernel:  [<ffffffff8028798a>] ? __kmalloc+0x79/0xa1
Jul 13 01:11:10 backup kernel:  [<ffffffff803ef98a>] ? __alloc_skb+0x5c/0x12a
Jul 13 01:11:10 backup kernel:  [<ffffffff803f0558>] ? __netdev_alloc_skb+0x15/0x2f
Jul 13 01:11:10 backup kernel:  [<ffffffffa000cda0>] ? e1000_alloc_rx_buffers+0x8c/0x248 [e1000e]
Jul 13 01:11:10 backup kernel:  [<ffffffffa000d262>] ? e1000_clean_rx_irq+0x2a2/0x2db [e1000e]   
Jul 13 01:11:10 backup kernel:  [<ffffffffa000e8dc>] ? e1000_clean+0x70/0x219 [e1000e]
Jul 13 01:11:10 backup kernel:  [<ffffffff803f3adf>] ? net_rx_action+0x69/0x11f
Jul 13 01:11:10 backup kernel:  [<ffffffff802373eb>] ? __do_softirq+0x66/0xf7  
Jul 13 01:11:10 backup kernel:  [<ffffffff8020bebc>] ? call_softirq+0x1c/0x28  
Jul 13 01:11:10 backup kernel:  [<ffffffff8020d680>] ? do_softirq+0x2c/0x68    
Jul 13 01:11:10 backup kernel:  [<ffffffff8020cf62>] ? do_IRQ+0xa9/0xbf
Jul 13 01:11:10 backup kernel:  [<ffffffff8020b793>] ? ret_from_intr+0x0/0xa
Jul 13 01:11:10 backup kernel:  <EOI>  [<ffffffff80233b35>] ? do_syslog+0x15a/0x345
Jul 13 01:11:10 backup kernel:  [<ffffffff80233b4b>] ? do_syslog+0x170/0x345
Jul 13 01:11:10 backup kernel:  [<ffffffff80244490>] ? autoremove_wake_function+0x0/0x2e
Jul 13 01:11:10 backup kernel:  [<ffffffff802d1229>] ? kmsg_read+0x3a/0x45
Jul 13 01:11:10 backup kernel:  [<ffffffff802c9a6e>] ? proc_reg_read+0x6d/0x88
Jul 13 01:11:11 backup kernel:  [<ffffffff8028c15c>] ? vfs_read+0xaa/0x133
Jul 13 01:11:11 backup kernel:  [<ffffffff8028c2a1>] ? sys_read+0x45/0x6e 
Jul 13 01:11:11 backup kernel:  [<ffffffff8020adeb>] ? system_call_fastpath+0x16/0x1b
Jul 13 01:11:11 backup kernel: Mem-Info:
Jul 13 01:11:11 backup kernel: DMA per-cpu:
Jul 13 01:11:11 backup kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jul 13 01:11:11 backup kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jul 13 01:11:11 backup kernel: CPU    2: hi:    0, btch:   1 usd:   0
Jul 13 01:11:11 backup kernel: CPU    3: hi:    0, btch:   1 usd:   0
Jul 13 01:11:11 backup kernel: DMA32 per-cpu:
Jul 13 01:11:11 backup kernel: CPU    0: hi:  186, btch:  31 usd: 130
Jul 13 01:11:11 backup kernel: CPU    1: hi:  186, btch:  31 usd:  90
Jul 13 01:11:11 backup kernel: CPU    2: hi:  186, btch:  31 usd: 142
Jul 13 01:11:11 backup kernel: CPU    3: hi:  186, btch:  31 usd: 177
Jul 13 01:11:11 backup kernel: Normal per-cpu:
Jul 13 01:11:11 backup kernel: CPU    0: hi:  186, btch:  31 usd:  76
Jul 13 01:11:11 backup kernel: CPU    1: hi:  186, btch:  31 usd: 160
Jul 13 01:11:11 backup kernel: CPU    2: hi:  186, btch:  31 usd: 170
Jul 13 01:11:11 backup kernel: CPU    3: hi:  186, btch:  31 usd: 165
Jul 13 01:11:11 backup kernel: Active_anon:117688 active_file:169003 inactive_anon:22048
Jul 13 01:11:11 backup kernel:  inactive_file:1425813 unevictable:0 dirty:337125 writeback:4365 unstable:0
Jul 13 01:11:11 backup kernel:  free:8260 slab:297474 mapped:1475 pagetables:1685 bounce:0
Jul 13 01:11:11 backup kernel: DMA free:11712kB min:12kB low:12kB high:16kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:10756kB pages_scanned:0 all_unreclaimable? yes
Jul 13 01:11:11 backup kernel: lowmem_reserve[]: 0 3767 8059 8059
Jul 13 01:11:11 backup kernel: DMA32 free:19060kB min:5364kB low:6704kB high:8044kB active_anon:180632kB inactive_anon:38496kB active_file:318456kB inactive_file:2581460kB unevictable:0kB present:3857440kB pages_scanned:0 all_unreclaimable? no
Jul 13 01:11:11 backup kernel: lowmem_reserve[]: 0 0 4292 4292
Jul 13 01:11:11 backup kernel: Normal free:2268kB min:6112kB low:7640kB high:9168kB active_anon:290120kB inactive_anon:49696kB active_file:357556kB inactive_file:3121792kB unevictable:0kB present:4395520kB pages_scanned:0 all_unreclaimable? no
Jul 13 01:11:11 backup kernel: lowmem_reserve[]: 0 0 0 0
Jul 13 01:11:11 backup kernel: DMA: 6*4kB 3*8kB 3*16kB 3*32kB 4*64kB 2*128kB 1*256kB 1*512kB 2*1024kB 0*2048kB 2*4096kB = 11712kB
Jul 13 01:11:11 backup kernel: DMA32: 2720*4kB 2*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 1*4096kB = 19040kB
Jul 13 01:11:11 backup kernel: Normal: 1*4kB 1*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2236kB   
Jul 13 01:11:11 backup kernel: 1594864 total pagecache pages
Jul 13 01:11:11 backup kernel: 9 pages in swap cache
Jul 13 01:11:11 backup kernel: Swap cache stats: add 1047, delete 1038, find 0/0
Jul 13 01:11:11 backup kernel: Free swap  = 2100300kB
Jul 13 01:11:11 backup kernel: Total swap = 2104488kB
Jul 13 01:11:11 backup kernel: 2162672 pages RAM
Jul 13 01:11:11 backup kernel: 116410 pages reserved
Jul 13 01:11:11 backup kernel: 1512138 pages shared 
Jul 13 01:11:11 backup kernel: 529843 pages non-shared

Then things went ok for some hours, but rsync returned:

Jul 13 03:03:44 backup kernel: rsyncd: page allocation failure. order:0, mode:0x20
Jul 13 03:03:44 backup kernel: Pid: 30898, comm: rsyncd Not tainted 2.6.30.1 #3
Jul 13 03:03:44 backup kernel: Call Trace:
Jul 13 03:03:44 backup kernel:  <IRQ>  [<ffffffff80269182>] ? __alloc_pages_internal+0x3df/0x3ff
Jul 13 03:03:44 backup kernel:  [<ffffffff802876cf>] ? cache_alloc_refill+0x25e/0x4a0
Jul 13 03:03:44 backup kernel:  [<ffffffff803eb08e>] ? sock_def_readable+0x37/0x62
Jul 13 03:03:44 backup kernel:  [<ffffffff8028798a>] ? __kmalloc+0x79/0xa1
Jul 13 03:03:44 backup kernel:  [<ffffffff803ef98a>] ? __alloc_skb+0x5c/0x12a
Jul 13 03:03:44 backup kernel:  [<ffffffff803f0558>] ? __netdev_alloc_skb+0x15/0x2f
Jul 13 03:03:44 backup kernel:  [<ffffffffa000cda0>] ? e1000_alloc_rx_buffers+0x8c/0x248 [e1000e]
Jul 13 03:03:44 backup kernel:  [<ffffffffa000d262>] ? e1000_clean_rx_irq+0x2a2/0x2db [e1000e]
Jul 13 03:03:44 backup kernel:  [<ffffffffa000e8dc>] ? e1000_clean+0x70/0x219 [e1000e]
Jul 13 03:03:44 backup kernel:  [<ffffffff803f3adf>] ? net_rx_action+0x69/0x11f
Jul 13 03:03:45 backup kernel:  [<ffffffff802373eb>] ? __do_softirq+0x66/0xf7
Jul 13 03:03:45 backup kernel:  [<ffffffff8020bebc>] ? call_softirq+0x1c/0x28
Jul 13 03:03:45 backup kernel:  [<ffffffff8020d680>] ? do_softirq+0x2c/0x68
Jul 13 03:03:45 backup kernel:  [<ffffffff8020cf62>] ? do_IRQ+0xa9/0xbf
Jul 13 03:03:45 backup kernel:  [<ffffffff8020b793>] ? ret_from_intr+0x0/0xa
Jul 13 03:03:45 backup kernel:  <EOI>  [<ffffffff8045ff6a>] ? _spin_lock+0x12/0x15
Jul 13 03:03:45 backup kernel:  [<ffffffff80299e95>] ? shrink_dcache_memory+0x40/0x16e
Jul 13 03:03:45 backup kernel:  [<ffffffff8026defd>] ? shrink_slab+0xe0/0x153
Jul 13 03:03:45 backup kernel:  [<ffffffff8026eb1f>] ? try_to_free_pages+0x22e/0x31b
Jul 13 03:03:45 backup kernel:  [<ffffffff8026c18a>] ? isolate_pages_global+0x0/0x231
Jul 13 03:03:45 backup kernel:  [<ffffffff80269002>] ? __alloc_pages_internal+0x25f/0x3ff
Jul 13 03:03:45 backup kernel:  [<ffffffff80264191>] ? grab_cache_page_write_begin+0x60/0xa1
Jul 13 03:03:45 backup kernel:  [<ffffffff80301de5>] ? ext3_write_begin+0x7e/0x1f5
Jul 13 03:03:45 backup kernel:  [<ffffffff80264a7a>] ? generic_file_buffered_write+0x12c/0x2e8
Jul 13 03:03:45 backup kernel:  [<ffffffff803f128e>] ? skb_copy_datagram_iovec+0x49/0x1c2
Jul 13 03:03:45 backup kernel:  [<ffffffff80265115>] ? __generic_file_aio_write_nolock+0x349/0x37d
Jul 13 03:03:45 backup kernel:  [<ffffffff802658fe>] ? generic_file_aio_write+0x64/0xc4
Jul 13 03:03:45 backup kernel:  [<ffffffff802fee37>] ? ext3_file_write+0x16/0x97
Jul 13 03:03:45 backup kernel:  [<ffffffff8028b60e>] ? do_sync_write+0xce/0x113
Jul 13 03:03:45 backup kernel:  [<ffffffff8020b78e>] ? common_interrupt+0xe/0x13
Jul 13 03:03:45 backup kernel:  [<ffffffff80244490>] ? autoremove_wake_function+0x0/0x2e
Jul 13 03:03:45 backup kernel:  [<ffffffff8045e325>] ? thread_return+0x3e/0xa6
Jul 13 03:03:45 backup kernel:  [<ffffffff80298207>] ? poll_select_copy_remaining+0xd0/0xf3
Jul 13 03:03:45 backup kernel:  [<ffffffff8028bf44>] ? vfs_write+0xad/0x136
Jul 13 03:03:45 backup kernel:  [<ffffffff8028c089>] ? sys_write+0x45/0x6e
Jul 13 03:03:45 backup kernel:  [<ffffffff8020adeb>] ? system_call_fastpath+0x16/0x1b
Jul 13 03:03:45 backup kernel: Mem-Info:
Jul 13 03:03:45 backup kernel: DMA per-cpu:
Jul 13 03:03:45 backup kernel: CPU    0: hi:    0, btch:   1 usd:   0
Jul 13 03:03:45 backup kernel: CPU    1: hi:    0, btch:   1 usd:   0
Jul 13 03:03:45 backup kernel: CPU    2: hi:    0, btch:   1 usd:   0
Jul 13 03:03:45 backup kernel: CPU    3: hi:    0, btch:   1 usd:   0
Jul 13 03:03:45 backup kernel: DMA32 per-cpu:
Jul 13 03:03:45 backup kernel: CPU    0: hi:  186, btch:  31 usd: 185
Jul 13 03:03:45 backup kernel: CPU    1: hi:  186, btch:  31 usd: 158
Jul 13 03:03:45 backup kernel: CPU    2: hi:  186, btch:  31 usd: 171
Jul 13 03:03:45 backup kernel: CPU    3: hi:  186, btch:  31 usd:  94
Jul 13 03:03:45 backup kernel: Normal per-cpu:
Jul 13 03:03:45 backup kernel: CPU    0: hi:  186, btch:  31 usd: 164
Jul 13 03:03:45 backup kernel: CPU    1: hi:  186, btch:  31 usd: 167
Jul 13 03:03:45 backup kernel: CPU    2: hi:  186, btch:  31 usd: 172
Jul 13 03:03:45 backup kernel: CPU    3: hi:  186, btch:  31 usd:  78
Jul 13 03:03:45 backup kernel: Active_anon:20237 active_file:199144 inactive_anon:10594
Jul 13 03:03:45 backup kernel:  inactive_file:788346 unevictable:0 dirty:70022 writeback:0 unstable:0
Jul 13 03:03:45 backup kernel:  free:8268 slab:1014566 mapped:1676 pagetables:985 bounce:0
Jul 13 03:03:45 backup kernel: DMA free:11712kB min:12kB low:12kB high:16kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:10756kB pages_scanned:0 all_unreclaimable? yes
Jul 13 03:03:45 backup kernel: lowmem_reserve[]: 0 3767 8059 8059
Jul 13 03:03:45 backup kernel: DMA32 free:19156kB min:5364kB low:6704kB high:8044kB active_anon:12036kB inactive_anon:4096kB active_file:311356kB inactive_file:1376616kB unevictable:0kB present:3857440kB pages_scanned:96 all_unreclaimable? no
Jul 13 03:03:45 backup kernel: lowmem_reserve[]: 0 0 4292 4292
Jul 13 03:03:45 backup kernel: Normal free:2204kB min:6112kB low:7640kB high:9168kB active_anon:68912kB inactive_anon:38280kB active_file:485220kB inactive_file:1776768kB unevictable:0kB present:4395520kB pages_scanned:0 all_unreclaimable? no
Jul 13 03:03:45 backup kernel: lowmem_reserve[]: 0 0 0 0
Jul 13 03:03:45 backup kernel: DMA: 6*4kB 3*8kB 3*16kB 3*32kB 4*64kB 2*128kB 1*256kB 1*512kB 2*1024kB 0*2048kB 2*4096kB = 11712kB
Jul 13 03:03:45 backup kernel: DMA32: 2771*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 2*4096kB = 19276kB
Jul 13 03:03:45 backup kernel: Normal: 1*4kB 1*8kB 0*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 2156kB
Jul 13 03:03:45 backup kernel: 987585 total pagecache pages
Jul 13 03:03:45 backup kernel: 59 pages in swap cache
Jul 13 03:03:45 backup kernel: Swap cache stats: add 2435, delete 2376, find 2/4
Jul 13 03:03:45 backup kernel: Free swap  = 2094888kB
Jul 13 03:03:45 backup kernel: Total swap = 2104488kB
Jul 13 03:03:45 backup kernel: 2162672 pages RAM
Jul 13 03:03:45 backup kernel: 116410 pages reserved
Jul 13 03:03:45 backup kernel: 989086 pages shared
Jul 13 03:03:45 backup kernel: 1050975 pages non-shared

And this went on for several times.



>  I'm guessing you should
> include linux-mm next time (I did this time)
> 
> are you running jumbo frames perhaps?

As already mentioned, no jumbo frames in the game.

-- 
Regards,
Stephan

