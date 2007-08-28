Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXH1MGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXH1MGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 08:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbXH1MGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 08:06:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:40987 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750982AbXH1MGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 08:06:07 -0400
X-Authenticated: #27760234
X-Provags-ID: V01U2FsdGVkX19xbZQBe4xxHZjuAhDdZXGMEsgQrhtvwndk3pULQo
	vtFeLcsneCoL4E
Date: Tue, 28 Aug 2007 14:06:02 +0200
From: Richard Mittendorfer <delist@gmx.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.22.5-cfs20.2 another page allication failure
Message-Id: <20070828140602.9e2f5a26.delist@gmx.net>
In-Reply-To: <1188300137.6112.12.camel@twins>
References: <20070828125553.9d640960.delist@gmx.net>
	<1188300137.6112.12.camel@twins>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also sprach Peter Zijlstra <peterz@infradead.org> (Tue, 28 Aug 2007 13:22:17 +0200):
> On Tue, 2007-08-28 at 12:55 +0200, Richard Mittendorfer wrote:
> > Hello,
> > 
> > The box was up for 9 days when this one showed up. Currently rebuilding
> > w/ cfs lastest version.
> 
> I'm curious why you think this is related to the scheduler?

Oh, I'm not. At least I don't know and there' a new version out. 

I maybe had troubles witch ccache/distcc when I builded that one, so
I'll rebuild. I'll call in if it shows up with the rebuild.

> >  kernel: gs: page allocation failure. order:1, mode:0x4020
> >  kernel:  [<c0150070>] __alloc_pages+0x2f0/0x340
> >  kernel:  [<c0169edc>] __slab_alloc+0x1dc/0x860
> >  kernel:  [<c03569ed>] ip_local_deliver+0xfd/0x250
> >  kernel:  [<c0356160>] ip_local_deliver_finish+0x0/0x1b0
> >  kernel:  [<c0326d52>] __netdev_alloc_skb+0x22/0x50
> >  kernel:  [<c016ac7b>] __kmalloc_track_caller+0x6b/0x70
> >  kernel:  [<c0326d52>] __netdev_alloc_skb+0x22/0x50
> >  kernel:  [<c0326a07>] __alloc_skb+0x57/0x120
> >  kernel:  [<c0326d52>] __netdev_alloc_skb+0x22/0x50
> >  kernel:  [<c02a31f4>] e100_rx_alloc_skb+0x24/0xa0
> >  kernel:  [<c02a59a0>] e100_poll+0x1b0/0x430
> >  kernel:  [<c01274a0>] process_timeout+0x0/0x10
> >  kernel:  [<c032d34c>] net_rx_action+0x6c/0x170
> >  kernel:  [<c0123f62>] __do_softirq+0x42/0x90
> >  kernel:  [<c010691c>] do_softirq+0x5c/0xb0
> >  kernel:  [<c016f0a4>] vfs_read+0x154/0x1d0
> >  kernel:  [<c0148460>] handle_edge_irq+0x0/0xf0
> >  kernel:  [<c0123e9a>] irq_exit+0x5a/0x60
> >  kernel:  [<c01069ec>] do_IRQ+0x7c/0xc0
> >  kernel:  [<c016f1e1>] sys_read+0x41/0x70
> >  kernel:  [<c0104b7f>] common_interrupt+0x23/0x28
> >  kernel:  =======================
> >  kernel: Mem-info:
> >  kernel: DMA per-cpu:
> >  kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> >  kernel: Normal per-cpu:
> >  kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  17   Cold: hi:   62, btch:  15 usd:  57
> >  kernel: Active:106252 inactive:15242 dirty:9376 writeback:0 unstable:0
> >  kernel:  free:1508 slab:3818 mapped:6284 pagetables:453 bounce:0
> >  kernel: DMA free:1988kB min:64kB low:80kB high:96kB active:9244kB inactive:128kB present:16256kB pages_scanned:33 all_unreclaimable? no
> >  kernel: lowmem_reserve[]: 0 491
> >  kernel: Normal free:4044kB min:1980kB low:2472kB high:2968kB active:415764kB inactive:60840kB present:502920kB pages_scanned:140 all_unreclaimable? no
> >  kernel: lowmem_reserve[]: 0 0
> >  kernel: DMA: 21*4kB 0*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 1988kB
> >  kernel: Normal: 917*4kB 1*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4044kB
> >  kernel: Swap cache: add 6475, delete 6087, find 125398/125927, race 0+0
> >  kernel: Free swap  = 1171308kB
> >  kernel: Total swap = 1179344kB
> >  kernel: Free swap:       1171308kB
> >  kernel: 130816 pages of RAM
> >  kernel: 0 pages of HIGHMEM
> >  kernel: 2224 reserved pages
> >  kernel: 92116 pages shared
> >  kernel: 388 pages swap cached
> >  kernel: 9376 pages dirty
> >  kernel: 0 pages writeback
> >  kernel: 6284 pages mapped
> >  kernel: 3818 pages slab
> >  kernel: 453 pages pagetables
> 
> Also curious why it failed, looks like it just hit the watermarks.
> Could you provide us with the content of /proc/zoneinfo of that kernel?
> Also, do you use SLUB or SLAB?

I'm using SLUB, .config & dmesg is at 
http://www.mittendorfer.com/rm/temp/config-2.6.22-cfs-v2.20.txt
http://www.mittendorfer.com/rm/temp/dmesg-2.6.22.5-cfs-20.2.txt

(note, this is after I did reboot the machine.)
booze:~# cat /proc/zoneinfo 
Node 0, zone      DMA
  pages free     597
        min      16
        low      20
        high     24
        scanned  0 (a: 20 i: 18)
        spanned  4096
        present  4064
    nr_free_pages 597
    nr_inactive  6
    nr_active    2382
    nr_anon_pages 2278
    nr_mapped    7
    nr_file_pages 110
    nr_dirty     1
    nr_writeback 0
    nr_slab_reclaimable 33
    nr_slab_unreclaimable 8
    nr_page_table_pages 2
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 896
        protection: (0, 491)
  pagesets
    cpu: 0 pcp: 0
              count: 0
              high:  0
              batch: 1
    cpu: 0 pcp: 1
              count: 0
              high:  0
              batch: 1
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         0
Node 0, zone   Normal
  pages free     1533
        min      495
        low      618
        high     742
        scanned  0 (a: 0 i: 0)
        spanned  126720
        present  125730
    nr_free_pages 1533
    nr_inactive  17430
    nr_active    100789
    nr_anon_pages 76649
    nr_mapped    6785
    nr_file_pages 41575
    nr_dirty     2068
    nr_writeback 0
    nr_slab_reclaimable 2424
    nr_slab_unreclaimable 1686
    nr_page_table_pages 460
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 2633
        protection: (0, 0)
  pagesets
    cpu: 0 pcp: 0
              count: 12
              high:  186
              batch: 31
    cpu: 0 pcp: 1
              count: 6
              high:  62
              batch: 15
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         409

> Normally these errors occur because of jumbo frames, but e100 doesn't do
> that, so it seems an order-1 page was used to back smaller objects.

It's a 100Mbps switched network, MTU 1500. One e100 and one 8139too a
multihomed SOHO server. I think it showed up after a printjob came in
from LAN..., log's confirm that.

?likely unrelated - there's wondershaper on eth1 (not the one to the LAN):

qdisc cbq 1: rate 10000Kbit (bounded,isolated) prio no-transmit
 Sent 22103227 bytes 255795 pkt (dropped 0, overlimits 30959 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
  borrowed 0 overactions 0 avgidle 781 undertime 0
qdisc sfq 10: parent 1:10 limit 128p quantum 1514b perturb 10sec 
 Sent 12179947 bytes 187593 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
qdisc sfq 20: parent 1:20 limit 128p quantum 1514b perturb 10sec 
 Sent 9857424 bytes 66634 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
qdisc sfq 30: parent 1:30 limit 128p quantum 1514b perturb 10sec 
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
qdisc ingress ffff: ---------------- 
 Sent 218286672 bytes 310103 pkt (dropped 1679, overlimits 0 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
class cbq 1: root rate 10000Kbit (bounded,isolated) prio no-transmit
 Sent 65814 bytes 1567 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
  borrowed 0 overactions 0 avgidle 781 undertime 0
class cbq 1:10 parent 1:1 leaf 10: rate 240000bit prio 1
 Sent 12179947 bytes 187593 pkt (dropped 0, overlimits 12976 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
  borrowed 0 overactions 9967 avgidle 781 undertime 0
class cbq 1:1 parent 1: rate 240000bit (bounded,isolated) prio 5
 Sent 22037371 bytes 254227 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
  borrowed 7874 overactions 0 avgidle 781 undertime 0
class cbq 1:20 parent 1:1 leaf 20: rate 216000bit prio 2
 Sent 9857424 bytes 66634 pkt (dropped 0, overlimits 20637 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
  borrowed 7874 overactions 7229 avgidle 781 undertime 0
class cbq 1:30 parent 1:1 leaf 30: rate 192000bit prio 2
 Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0) 
 rate 0bit 0pps backlog 0b 0p requeues 0 
  borrowed 0 overactions 0 avgidle 781 undertime 0

Thanks & Regards,
ritch
