Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab0CBWRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:17:51 -0500
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:48748 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752067Ab0CBWRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:17:49 -0500
Date: Wed, 3 Mar 2010 09:17:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: BUG: spinlock lockup on task_rq_lock in 2.6.33
Message-ID: <20100302221729.GG18369@discord.disaster>
References: <20100302063132.GF18369@discord.disaster> <alpine.LFD.2.00.1003021106330.4245@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003021106330.4245@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 11:08:50AM +0100, Thomas Gleixner wrote:
> Dave,
> 
> On Tue, 2 Mar 2010, Dave Chinner wrote:
> 
> > Hi Folks,
> > 
> > I just locked up a machine with the following trace:
> > 
> > [ 5247.149256] BUG: spinlock lockup on CPU#1, dd/7018, ffff8800059d4380
> > [ 5247.150009] BUG: spinlock lockup on CPU#0, dd/6211, ffff8800059d4380
> > [ 5247.150009] Pid: 6211, comm: dd Not tainted 2.6.33-dgc #86
> > [ 5247.150009] Call Trace:
> > [ 5247.150009]  [<ffffffff8140ad40>] do_raw_spin_lock+0x160/0x170
> > [ 5247.150009]  [<ffffffff8170fec6>] _raw_spin_lock+0x56/0x70
> > [ 5247.150009]  [<ffffffff8103d092>] ? task_rq_lock+0x52/0x90
> > [ 5247.150009]  [<ffffffff8103d092>] task_rq_lock+0x52/0x90
> > [ 5247.150009]  [<ffffffff81044a70>] try_to_wake_up+0x40/0x3d0
> > [ 5247.150009]  [<ffffffff81044e55>] wake_up_process+0x15/0x20
> 
> I can't say it for sure, but that might be related to a problem with
> TASK_WAKING which we discovered recently. The fix is in linus tree
> (commit 0970d2992dfd7d5ec2c787417cf464f01eeaf42a) and on the way to stable.

Thanks Thomas - I'll pull that commit in and see if it has any
effect on the problems I'm seeing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
