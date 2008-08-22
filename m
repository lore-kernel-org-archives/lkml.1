Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbYHVKLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbYHVKLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 06:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYHVKLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 06:11:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43279 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbYHVKLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 06:11:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: latest -git: suspend: unable to handle kernel paging request (was Re: no_console_suspend doesn't work?)
Date: Fri, 22 Aug 2008 12:15:09 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jens Axboe" <jens.axboe@oracle.com>
References: <19f34abd0808211028w7889587fke523ff244339e7c5@mail.gmail.com> <200808221134.39983.rjw@sisk.pl> <200808221201.54395.bzolnier@gmail.com>
In-Reply-To: <200808221201.54395.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808221215.09966.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 of August 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Friday 22 August 2008, Rafael J. Wysocki wrote:
> > On Friday, 22 of August 2008, Vegard Nossum wrote:
> > > On Fri, Aug 22, 2008 at 12:16 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > On Thursday, 21 of August 2008, Pekka Enberg wrote:
> > > >> > =============================================================================
> > > >> > BUG blkdev_ioc: Invalid object pointer 0xf5cdaca8
> > > >> > -----------------------------------------------------------------------------
> > > >>
> > > >> Ok, here we have the block layer passing a bad pointer to SLUB this
> > > >> time. And it's also from the suspend code (although it's the resume
> > > >> path this time). As we never see an oops from the block layer first,
> > > >> it's possible that someone else corrupted everything and it just shows
> > > >> up in the block layer. Maybe something worth investigating, though.
> > > >>
> > > >> > INFO: Slab 0xf789e318 objects=14 used=14 fp=0x00000000 flags=0x2082083
> > > >> > Pid: 3597, comm: bash Tainted: G      D   2.6.27-rc4-00003-ga798564-dirty #30
> > > >> >  [<c01b2576>] slab_err+0x46/0x50
> > > >> >  [<c01b2766>] ? check_slab+0xd6/0xf0
> > > >> >  [<c0181aef>] ? call_rcu+0x6f/0x80
> > > >> >  [<c015e91b>] ? trace_hardirqs_on+0xb/0x10
> > > >> >  [<c01b3c78>] __slab_free+0x238/0x360
> > > >> >  [<c01b4749>] kmem_cache_free+0xa9/0x120
> > > >> >  [<c036b773>] ? put_io_context+0x53/0x70
> > > >> >  [<c036b773>] ? put_io_context+0x53/0x70
> > > >> >  [<c036b773>] put_io_context+0x53/0x70
> > > >> >  [<c036b82e>] exit_io_context+0x6e/0x80
> > > >> >  [<c013de6e>] do_exit+0x84e/0x890
> > > >> >  [<c037b794>] ? trace_hardirqs_on_thunk+0xc/0x10
> > > >> >  [<c013b55b>] ? printk+0x1b/0x20
> > > >> >  [<c013a50a>] ? print_oops_end_marker+0x2a/0x30
> > > >> >  [<c01060f1>] oops_end+0xb1/0xc0
> > > >> >  [<c01067c0>] die+0x50/0x70
> > > >> >  [<c0106871>] do_trap+0x91/0xc0
> > > >> >  [<c0106940>] ? do_invalid_op+0x0/0xa0
> > > >> >  [<c01069c8>] do_invalid_op+0x88/0xa0
> > > >> >  [<c01a0f39>] ? page_remove_rmap+0x109/0x120
> > > >> >  [<c013b2d1>] ? vprintk+0x151/0x3c0
> > > >> >  [<c013b45b>] ? vprintk+0x2db/0x3c0
> > > >> >  [<c015c5ea>] ? print_lock_contention_bug+0x1a/0xe0
> > > >> >  [<c015c5ea>] ? print_lock_contention_bug+0x1a/0xe0
> > > >> >  [<c0687d3a>] error_code+0x72/0x78
> > > >> >  [<c013007b>] ? sched_rt_period_timer+0x21b/0x270
> > > >> >  [<c01a0f39>] ? page_remove_rmap+0x109/0x120
> > > >> >  [<c0198721>] unmap_vmas+0x4b1/0x8b0
> > > >> >  [<c015c5ea>] ? print_lock_contention_bug+0x1a/0xe0
> > > >> >  [<c019d504>] exit_mmap+0x84/0x120
> > > >> >  [<c0138538>] mmput+0x48/0xa0
> > > >> >  [<c013c3d7>] exit_mm+0xe7/0x110
> > > >> >  [<c013d7a4>] do_exit+0x184/0x890
> > > >> >  [<c013b55b>] ? printk+0x1b/0x20
> > > >> >  [<c013a50a>] ? print_oops_end_marker+0x2a/0x30
> > > >> >  [<c01060f1>] oops_end+0xb1/0xc0
> > > >> >  [<c01067c0>] die+0x50/0x70
> > > >> >  [<c0122b4f>] do_page_fault+0x1ef/0xa20
> > > >> >  [<c010b335>] ? native_sched_clock+0xb5/0x110
> > > >> >  [<c01600ea>] ? __lock_acquire+0x27a/0xa00
> > > >> >  [<c0122960>] ? do_page_fault+0x0/0xa20
> > > >> >  [<c0687d3a>] error_code+0x72/0x78
> > > >> >  [<c038ad65>] ? __list_add+0x15/0x90
> > > >> >  [<c0687133>] ? _spin_lock+0x63/0x70
> > > >> >  [<c018b954>] rmqueue_bulk+0x54/0x80
> > > >> >  [<c018d317>] get_page_from_freelist+0x5a7/0x720
> > > >> >  [<c01600ea>] ? __lock_acquire+0x27a/0xa00
> > > >> >  [<c018dd50>] __alloc_pages_internal+0xa0/0x450
> > > >> >  [<c01acd4b>] alloc_pages_current+0x7b/0xc0
> > > >> >  [<c01b37fb>] new_slab+0x1bb/0x2d0
> > > >> >  [<c0687877>] ? _spin_unlock+0x27/0x50
> > > >> >  [<c01b40ca>] __slab_alloc+0x32a/0x4e0
> > > >> >  [<c010b335>] ? native_sched_clock+0xb5/0x110
> > > >> >  [<c01b4424>] kmem_cache_alloc+0xb4/0xe0
> > > >> >  [<c018969e>] ? mempool_alloc_slab+0xe/0x10
> > > >> >  [<c018969e>] ? mempool_alloc_slab+0xe/0x10
> > > >> >  [<c018969e>] mempool_alloc_slab+0xe/0x10
> > > >> >  [<c01897a1>] mempool_alloc+0x31/0xf0
> > > >> >  [<c015e884>] ? trace_hardirqs_on_caller+0xd4/0x160
> > > >> >  [<c015e91b>] ? trace_hardirqs_on+0xb/0x10
> > > >> >  [<c0368c7e>] get_request+0xae/0x2c0
> > > >> >  [<c036935c>] get_request_wait+0x1c/0xd0
> > > >> >  [<c0687462>] ? _spin_lock_irq+0x72/0x80
> > > >> >  [<c0369442>] blk_get_request+0x32/0x70
> > > >> >  [<c0471c1c>] generic_ide_resume+0x5c/0xf0
> > > >
> > > > IDE again?
> 
> "again"?

There was another trace in which IDE was also involved.

Sorry for the confusion.

Rafael
