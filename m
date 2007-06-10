Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbXFJGPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbXFJGPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 02:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625AbXFJGP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 02:15:26 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:55710 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbXFJGPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 02:15:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rI29ZATbHb33DyzU6nS1A8sCmtqGaMmjl8NsvE/PbdBMMmgKDYchGS3YmU18FrQyLyf4LJFA0bsl/CWwAv4QdMTFuqhQcXAR8JIzUDNwFX8QQGNbKOwNKA/p0q4YTeftJOGX2kp9xp1xi/OIBm2W8jkRgoxsxmd1d7LcdDK+i14=
Message-ID: <3aa654a40706092315g4b7dcce4ha22b4ee77ec00ccc@mail.gmail.com>
Date: Sat, 9 Jun 2007 23:15:23 -0700
From: "Avuton Olrich" <avuton@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.22-rc4
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeff Garzik" <jeff@garzik.org>, netdev@vger.kernel.org
In-Reply-To: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> So -rc4 is out there now, hopefully shrinking the regression list further.

(CCd net device MAINTAINERs, I'm not sure, but nv_alloc_rx is forcedeth)

This server has been up for about a day now and I'm starting to get
some bad looking messages when plenty gets transferred over NFS:

(please excuse the links, without them this message would certainly be
too large)
Linux version 2.6.22-rc4 (root@shapeshifter) (gcc version 4.2.0
(Gentoo 4.2.0)) #6 PREEMPT Fri Jun 8 18:54:00 PDT 2007
(it's actually with the latest rsdl patch)

http://avuton.googlepages.com/config
http://avuton.googlepages.com/lspci-vvv
http://avuton.googlepages.com/ioports
http://avuton.googlepages.com/iomem

 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  87   Cold: hi:   62, btch:  15 usd:  57
Active:43224 inactive:168748 dirty:2679 writeback:24182 unstable:0
 free:4334 slab:6997 mapped:6927 pagetables:286 bounce:0
DMA free:3520kB min:68kB low:84kB high:100kB active:1064kB
inactive:5492kB present:16256kB pages_sc
anned:0 all_unreclaimable? no
lowmem_reserve[]: 0 873
Normal free:13816kB min:3744kB low:4680kB high:5616kB active:171832kB
inactive:669500kB present:894
080kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0
DMA: 38*4kB 1*8kB 0*16kB 3*32kB 1*64kB 1*128kB 2*256kB 1*512kB
0*1024kB 1*2048kB 0*4096kB = 3520kB
Normal: 3278*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 0*256kB 1*512kB
0*1024kB 0*2048kB 0*4096kB = 13
816kB
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 498004kB
Total swap = 498004kB
Free swap:       498004kB
229376 pages of RAM
0 pages of HIGHMEM
3350 reserved pages
119197 pages shared
0 pages swap cached
2679 pages dirty
24182 pages writeback
6927 pages mapped
6997 pages slab
286 pages pagetables
swapper: page allocation failure. order:1, mode:0x4020
 [<c0149b09>] __alloc_pages+0x239/0x2f0
 [<c02f6046>] nv_alloc_rx+0xf6/0x1a0
 [<c0161622>] __slab_alloc+0x422/0x500
 [<c02f6046>] nv_alloc_rx+0xf6/0x1a0
 [<c0163055>] __kmalloc_track_caller+0x65/0x70
 [<c02f6046>] nv_alloc_rx+0xf6/0x1a0
 [<c03d0435>] __alloc_skb+0x55/0x120
 [<c02f6046>] nv_alloc_rx+0xf6/0x1a0
 [<c0133f1f>] getnstimeofday+0x2f/0xe0
 [<c02f7d78>] nv_nic_irq+0x2a8/0x590
 [<c02f7b09>] nv_nic_irq+0x39/0x590
 [<c0142005>] handle_IRQ_event+0x25/0x50
 [<c014386b>] handle_fasteoi_irq+0x5b/0xe0
 [<c010685a>] do_IRQ+0x4a/0x80
 [<c03d10a2>] __netdev_alloc_skb+0x22/0x50
 [<c03d10a2>] __netdev_alloc_skb+0x22/0x50
 [<c0104a53>] common_interrupt+0x23/0x28
 [<c03d10a2>] __netdev_alloc_skb+0x22/0x50
 [<c016302e>] __kmalloc_track_caller+0x3e/0x70
 [<c03d10a2>] __netdev_alloc_skb+0x22/0x50
 [<c03d0435>] __alloc_skb+0x55/0x120
 [<c03d10a2>] __netdev_alloc_skb+0x22/0x50
 [<c02f26f4>] skge_poll+0x2c4/0x600
 [<c01250f7>] get_next_timer_interrupt+0x1a7/0x230
 [<c02f2558>] skge_poll+0x128/0x600
 [<c03d6c21>] net_rx_action+0x61/0x170
 [<c01211d2>] __do_softirq+0x42/0x90
 [<c0121247>] do_softirq+0x27/0x30
 [<c01214b5>] irq_exit+0x65/0x70
 [<c010685f>] do_IRQ+0x4f/0x80
 [<c010685f>] do_IRQ+0x4f/0x80
 [<c0104a53>] common_interrupt+0x23/0x28
 [<c0102b30>] default_idle+0x0/0x40
 [<c0102b5a>] default_idle+0x2a/0x40
 [<c01023f0>] cpu_idle+0x50/0x70
 [<c0590b35>] start_kernel+0x215/0x260
 [<c0590450>] unknown_bootoption+0x0/0x260
 =======================
-- 
avuton
--
 Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
