Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYH1Hsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYH1Hsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYH1Hsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:48:33 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52502 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbYH1Hsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:48:33 -0400
Date: Thu, 28 Aug 2008 09:48:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, jurriaan <thunder7@xs4all.nl>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: 2.6.27-rc4: lots of 'in_atomic():1, irqs_disabled():0' with  software-raid1
Message-ID: <20080828074830.GV20055@kernel.dk>
References: <20080827170538.GA24393@amd64.of.nowhere> <200808272347.43577.rjw@sisk.pl> <20080828073324.GR20055@kernel.dk> <20080828004532.45d8b8c9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828004532.45d8b8c9.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28 2008, Andrew Morton wrote:
> On Thu, 28 Aug 2008 09:33:24 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Aug 27 2008, Rafael J. Wysocki wrote:
> > > [Adding CCs]
> > > 
> > > On Wednesday, 27 of August 2008, jurriaan wrote:
> > > > After returning from my holidays, I proceeded to test 2.6.27-rc4. 2.6.26
> > > > works fine, but 2.6.27-rc4 gives me lots of:
> > > > 
> > > > Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> > > > Aug 27 18:03:10 middle kernel: Pid: 1185, comm: md2_raid1 Not tainted 2.6.27-rc4 #2
> > > > Aug 27 18:03:10 middle kernel: 
> > > > Aug 27 18:03:10 middle kernel: Call Trace:
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff803a30f1>] ? rb_insert_color+0x101/0x130
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff8022de7f>] ? update_curr+0x3f/0x60
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff8039e3e9>] ? __next_cpu+0x19/0x30
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff80231ecc>] ? find_busiest_group+0x1dc/0x960
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff806240ab>] bitmap_update_sb+0xdb/0x110
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff8061ef65>] md_update_sb+0x1e5/0x370
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff80620dc5>] md_check_recovery+0x355/0x640
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> > > > Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> > > > Aug 27 18:03:10 middle kernel: 
> > > > 
> > > > I was able to reboot into 2.6.26 without further trouble. I wasn't able
> > > > to find this reported earlier on lkml.
> > 
> > Hmm, this just looks like a GFP_NOIO alloc inside rcu_read_lock(), I
> > don't see anything wrong with that?
> > 
> 
> Cant sleep inside rcu_read_lock(), with CONFIG_PREEMPT_RCU=n, at least.
> 
> Dunno if it's legal if CONFIG_PREEMPT_RCU=y.  Hopefully not - that
> would be insane.  But I've failed to keep up with rcu goings-on
> recently.

Doh right, we of course can't block inside a RCU section. Then
bitmap.c:write_sb_page() wants fixing:

        rcu_read_lock();
        rdev_for_each_rcu(...)
                md_super_write(...)
                        bio_alloc(GFP_NOIO, 1);

Neil?

-- 
Jens Axboe

