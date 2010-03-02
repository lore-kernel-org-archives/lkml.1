Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab0CBWuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:50:05 -0500
Received: from www.tglx.de ([62.245.132.106]:59607 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737Ab0CBWuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:50:01 -0500
Date: Tue, 2 Mar 2010 23:49:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Chinner <david@fromorbit.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: BUG: spinlock lockup on task_rq_lock in 2.6.33
In-Reply-To: <20100302221729.GG18369@discord.disaster>
Message-ID: <alpine.LFD.2.00.1003022348120.4245@localhost.localdomain>
References: <20100302063132.GF18369@discord.disaster> <alpine.LFD.2.00.1003021106330.4245@localhost.localdomain> <20100302221729.GG18369@discord.disaster>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010, Dave Chinner wrote:
> On Tue, Mar 02, 2010 at 11:08:50AM +0100, Thomas Gleixner wrote:
> > Dave,
> > 
> > On Tue, 2 Mar 2010, Dave Chinner wrote:
> > 
> > > Hi Folks,
> > > 
> > > I just locked up a machine with the following trace:
> > > 
> > > [ 5247.149256] BUG: spinlock lockup on CPU#1, dd/7018, ffff8800059d4380
> > > [ 5247.150009] BUG: spinlock lockup on CPU#0, dd/6211, ffff8800059d4380
> > > [ 5247.150009] Pid: 6211, comm: dd Not tainted 2.6.33-dgc #86
> > > [ 5247.150009] Call Trace:
> > > [ 5247.150009]  [<ffffffff8140ad40>] do_raw_spin_lock+0x160/0x170
> > > [ 5247.150009]  [<ffffffff8170fec6>] _raw_spin_lock+0x56/0x70
> > > [ 5247.150009]  [<ffffffff8103d092>] ? task_rq_lock+0x52/0x90
> > > [ 5247.150009]  [<ffffffff8103d092>] task_rq_lock+0x52/0x90
> > > [ 5247.150009]  [<ffffffff81044a70>] try_to_wake_up+0x40/0x3d0
> > > [ 5247.150009]  [<ffffffff81044e55>] wake_up_process+0x15/0x20
> > 
> > I can't say it for sure, but that might be related to a problem with
> > TASK_WAKING which we discovered recently. The fix is in linus tree
> > (commit 0970d2992dfd7d5ec2c787417cf464f01eeaf42a) and on the way to stable.
> 
> Thanks Thomas - I'll pull that commit in and see if it has any
> effect on the problems I'm seeing.

I have a hard time to see how that might lead to a deadlock, but hell,
that load balancing code is a maze.

Thanks,

	tglx

