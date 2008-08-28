Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbYH1Hp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbYH1Hp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYH1Hpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:45:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752957AbYH1Hpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:45:49 -0400
Date: Thu, 28 Aug 2008 00:45:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, jurriaan <thunder7@xs4all.nl>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: 2.6.27-rc4: lots of 'in_atomic():1, irqs_disabled():0' with
 software-raid1
Message-Id: <20080828004532.45d8b8c9.akpm@linux-foundation.org>
In-Reply-To: <20080828073324.GR20055@kernel.dk>
References: <20080827170538.GA24393@amd64.of.nowhere>
	<200808272347.43577.rjw@sisk.pl>
	<20080828073324.GR20055@kernel.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 09:33:24 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Aug 27 2008, Rafael J. Wysocki wrote:
> > [Adding CCs]
> > 
> > On Wednesday, 27 of August 2008, jurriaan wrote:
> > > After returning from my holidays, I proceeded to test 2.6.27-rc4. 2.6.26
> > > works fine, but 2.6.27-rc4 gives me lots of:
> > > 
> > > Aug 27 18:03:10 middle kernel: in_atomic():1, irqs_disabled():0
> > > Aug 27 18:03:10 middle kernel: Pid: 1185, comm: md2_raid1 Not tainted 2.6.27-rc4 #2
> > > Aug 27 18:03:10 middle kernel: 
> > > Aug 27 18:03:10 middle kernel: Call Trace:
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff802303fb>] __might_sleep+0xdb/0x100
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff802734a9>] mempool_alloc+0x89/0x140
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff802c8deb>] bio_alloc_bioset+0x2b/0xb0
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff802c8ed0>] bio_alloc+0x10/0x20
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff8061ecda>] md_super_write+0x3a/0xe0
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff80623e0e>] write_page+0x14e/0x310
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff803a30f1>] ? rb_insert_color+0x101/0x130
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff8022de7f>] ? update_curr+0x3f/0x60
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff8039e3e9>] ? __next_cpu+0x19/0x30
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff80231ecc>] ? find_busiest_group+0x1dc/0x960
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff806240ab>] bitmap_update_sb+0xdb/0x110
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff8061ef65>] md_update_sb+0x1e5/0x370
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff80620dc5>] md_check_recovery+0x355/0x640
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff80607665>] raid1d+0x35/0x10a0
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff802360db>] ? finish_task_switch+0x3b/0xc0
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff8070ec96>] ? thread_return+0xa3/0x63d
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff80247406>] ? lock_timer_base+0x36/0x70
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff8024749a>] ? try_to_del_timer_sync+0x5a/0x70
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff802474ca>] ? del_timer_sync+0x1a/0x30
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff80710e52>] ? _spin_lock_irqsave+0x22/0x50
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff807110c2>] ? _spin_unlock_irqrestore+0x12/0x40
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff8061e084>] md_thread+0x54/0x140
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff80253390>] ? autoremove_wake_function+0x0/0x40
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff8061e030>] ? md_thread+0x0/0x140
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff80252fc9>] kthread+0x49/0x80
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff8020ca09>] child_rip+0xa/0x11
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff80252f80>] ? kthread+0x0/0x80
> > > Aug 27 18:03:10 middle kernel:  [<ffffffff8020c9ff>] ? child_rip+0x0/0x11
> > > Aug 27 18:03:10 middle kernel: 
> > > 
> > > I was able to reboot into 2.6.26 without further trouble. I wasn't able
> > > to find this reported earlier on lkml.
> 
> Hmm, this just looks like a GFP_NOIO alloc inside rcu_read_lock(), I
> don't see anything wrong with that?
> 

Cant sleep inside rcu_read_lock(), with CONFIG_PREEMPT_RCU=n, at least.

Dunno if it's legal if CONFIG_PREEMPT_RCU=y.  Hopefully not - that
would be insane.  But I've failed to keep up with rcu goings-on
recently.

