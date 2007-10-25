Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbXJYFe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbXJYFe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 01:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbXJYFeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 01:34:20 -0400
Received: from brick.kernel.dk ([87.55.233.238]:29261 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbXJYFeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 01:34:18 -0400
Date: Thu, 25 Oct 2007 07:34:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <tomof@acm.org>
Cc: kamalesh@linux.vnet.ibm.com, fujita.tomonori@lab.ntt.co.jp,
       apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.23-git18 Kernel oops in sg helpers
Message-ID: <20071025053414.GI14671@kernel.dk>
References: <20071024115436.GT32058@shadowen.org> <20071024214014C.fujita.tomonori@lab.ntt.co.jp> <471F6DFE.3040304@linux.vnet.ibm.com> <20071025071043P.tomof@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025071043P.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25 2007, FUJITA Tomonori wrote:
> On Wed, 24 Oct 2007 21:38:30 +0530
> Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > FUJITA Tomonori wrote:
> > > On Wed, 24 Oct 2007 12:54:36 +0100
> > > Andy Whitcroft <apw@shadowen.org> wrote:
> > > 
> > >> On Tue, Oct 23, 2007 at 08:44:20PM +0200, Jens Axboe wrote:
> > >>> On Tue, Oct 23 2007, Kamalesh Babulal wrote:
> > >>>> Hi,
> > >>>>
> > >>>> Kernel oops is triggered while running fsx-linux test, followed by cpu softlock
> > >>>> over the AMD box
> > >>>>
> > >>>> Unable to handle kernel NULL pointer dereference at 0000000000000018 RIP: 
> > >>>>  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
> > >>>> PGD 10185b067 PUD 10075b067 PMD 0 
> > >>>> Oops: 0002 [1] SMP 
> > >>>> CPU 3 
> > >>>> Modules linked in:
> > >>>> Pid: 18676, comm: fsx-linux Not tainted 2.6.23-git18-autokern1 #1
> > >>>> RIP: 0010:[<ffffffff8021f2f6>]  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
> > >>>> RSP: 0000:ffff810181edf948  EFLAGS: 00010002
> > >>> Can you check where gart_map_sg+0x26c is at? Make sure you have
> > >>> CONFIG_DEBUG_INFO defined, then do:
> > >>>
> > >>> $ gdb vmlinux
> > >>> $ l *gart_map_sg+0x26c
> > >> Ok, this problem still seems to be about in 2.6.24-rc1.  Here is the gdb
> > >> output from that version, the panic (also below) seems the same:
> > >>
> > >> (gdb) l *gart_map_sg+0x26c
> > >> 0xffffffff8022011e is in gart_map_sg (arch/x86/kernel/pci-gart_64.c:433).
> > >> 428                     goto error;
> > >> 429             out++;
> > >> 430             flush_gart();
> > >> 431             if (out < nents) {
> > >> 432                     sgmap = sg_next(sgmap);
> > >> 433                     sgmap->dma_length = 0;
> > >> 434             }
> > >> 435             return out;
> > >> 436
> > >> 437     error:
> > >>
> > >> So it seems sg_next has returned 0.
> > > 
> > > Have you tried this?
> > > 
> > > http://marc.info/?l=linux-kernel&m=119317981406073&w=2
> > > -
> > Hi,
> > Thanks, this patch solves the kernel oops.
> 
> Thanks for testing!
> 
> Jens, here's the proper changelog.

Thanks, applied!

-- 
Jens Axboe

