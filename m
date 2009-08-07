Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbZHGNRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbZHGNRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 09:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbZHGNRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 09:17:04 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:47551 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbZHGNRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 09:17:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=WUi7uVzQxXlZnbWYPB8B9YND0HJanfS+9mmxUnqDVCD0Ern4lD5Sgwafd2T8nDWuoi
         W6ndNfKtkRbT0FWN2b2z4nuft1SE9ZygpwZb3JxFxnsb/+y0zP1lXZvA2JIu6FcV9p4k
         7mNDfb1UOS+UwK5+FMFfTfgxY7VIkhB60AFno=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for August 6
Date: Fri, 7 Aug 2009 15:15:45 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5-00246-g90bc1a6; KDE/4.2.4; i686; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20090806192209.513abec7.sfr@canb.auug.org.au> <200908062250.51498.bzolnier@gmail.com>
In-Reply-To: <200908062250.51498.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908071515.45169.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 August 2009 22:50:50 Bartlomiej Zolnierkiewicz wrote:
> On Thursday 06 August 2009 11:22:09 Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090805:
> 
> At the moment -next is completely unusable for anything other than
> detecting merge conflicts..  Running -next was never a completely
> smooth experience but for a past year it was more-or-less doable.
> However the last two months have been an absolute horror and I've
> been hitting issues way faster than I was able to trace/report
> them properly..
> 
> Right now I still have following *outstanding* issues (on just *one*
> machine/distribution):
> 
> - Random (after some long hours) order:6 mode:0x8020 page allocation
>   failure (when ipw2200 driver reloads firmware on firmware error).
> 
>   [ I had first thought that it was caused by SLQB (which got enabled
>     as default somewhere along the way) but it also happens with SLUB
>     and I have good reasons to believe that is caused by heavy mm
>     changes first seen in next-20090618 (I've been testing next-20090617
>     for many days and it never happened there), the last confirmed
>     release with the problem is next-20090728. ]

If anyone is interested in the full log of the problem:

ipw2200: Firmware error detected.  Restarting.
ipw2200/0: page allocation failure. order:6, mode:0x8020
Pid: 1004, comm: ipw2200/0 Not tainted 2.6.31-rc4-next-20090728-04869-gdae50fe-dirty #51
Call Trace:
 [<c0396a2c>] ? printk+0xf/0x13
 [<c0169ec1>] __alloc_pages_nodemask+0x3dd/0x41f
 [<c0106907>] dma_generic_alloc_coherent+0x53/0xb8
 [<c01068b4>] ? dma_generic_alloc_coherent+0x0/0xb8
 [<e159d12f>] ipw_load_firmware+0x8c/0x4f8 [ipw2200]
 [<c01029fc>] ? restore_all_notrace+0x0/0x18
 [<e1599e4d>] ? ipw_stop_nic+0x2b/0x5d [ipw2200]
 [<e15a194e>] ipw_load+0x8b2/0xf94 [ipw2200]
 [<c0399680>] ? _spin_unlock_irqrestore+0x36/0x51
 [<e15a57be>] ipw_up+0xe1/0x5c6 [ipw2200]
 [<e15a3834>] ? ipw_down+0x1f7/0x1ff [ipw2200]
 [<e15a5cd5>] ipw_adapter_restart+0x32/0x46 [ipw2200]
 [<e15a5d0a>] ipw_bg_adapter_restart+0x21/0x2c [ipw2200]
 [<c0139aac>] worker_thread+0x15e/0x240
 [<c0139a6a>] ? worker_thread+0x11c/0x240
 [<e15a5ce9>] ? ipw_bg_adapter_restart+0x0/0x2c [ipw2200]
 [<c013ce99>] ? autoremove_wake_function+0x0/0x2f
 [<c013994e>] ? worker_thread+0x0/0x240
 [<c013cc5f>] kthread+0x66/0x6b
 [<c013cbf9>] ? kthread+0x0/0x6b
 [<c01034eb>] kernel_thread_helper+0x7/0x10
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 178
Active_anon:22467 active_file:10815 inactive_anon:22483
 inactive_file:28605 unevictable:2 dirty:626 writeback:190 unstable:0
 free:28497 slab:4190 mapped:5638 pagetables:895 bounce:0
DMA free:2084kB min:84kB low:104kB high:124kB active_anon:732kB inactive_anon:996kB active_file:652kB inactive_file:1980kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 492 492
Normal free:111904kB min:2792kB low:3488kB high:4188kB active_anon:89136kB inactive_anon:88936kB active_file:42608kB inactive_file:112440kB unevictable:8kB present:503872kB pages_scanned:53 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 9*4kB 4*8kB 6*16kB 2*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 2084kB
Normal: 12926*4kB 2437*8kB 1294*16kB 479*32kB 63*64kB 5*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 111904kB
40160 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 0kB
Total swap = 0kB
131056 pages RAM
3587 pages reserved
50606 pages shared
66006 pages non-shared
ipw2200: Unable to load firmware: -12
ipw2200: Unable to load firmware: -12
ipw2200: Failed to up device
