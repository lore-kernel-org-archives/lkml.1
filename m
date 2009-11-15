Return-Path: <linux-kernel-owner+w=401wt.eu-S1751643AbZKOBUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbZKOBUN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 20:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZKOBUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 20:20:12 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:56230 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbZKOBUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 20:20:11 -0500
Date: Sun, 15 Nov 2009 10:20:11 +0900 (JST)
Message-Id: <20091115.102011.227780670.mitake@dcl.info.waseda.ac.jp>
To: fweisbec@gmail.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Measuring term of acquiring spinlock
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091113105126.GC5243@nowhere>
References: <20091112073909.GB31719@elte.hu>
	<20091113.132125.468378199533086916.mitake@dcl.info.waseda.ac.jp>
	<20091113105126.GC5243@nowhere>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][RFC] Measuring term of acquiring spinlock
Date: Fri, 13 Nov 2009 11:51:27 +0100

> 
> On Fri, Nov 13, 2009 at 01:21:25PM +0900, Hitoshi Mitake wrote:
> > > Might make sense to put it into 'perf lock' kind of tool. I think 
> > > Frederic had such plans.
> > 
> > If you want a tester for 'perf lock', please call me, Frederic :)
> 
> 
> Thanks :)
> I haven't started it yet, because of some other things I need to finish.
> 
> Would you be interested in starting it?

Yes, I'm very interested in it!

> 
> The lock tracepoints are:
> 
> - lock_acquire: the lock is requested but not yet "acquired"
> - lock_release
> - lock_contended: we can't get the lock yet because someone already
>   holds it.
> - lock_acquired: we got the lock
> 
> 
> So, the point would be to develop a state machine that is
> able to give us statistics on a per lock granularity
> basis:
> 
> 
> - the total/average/maximum time a lock is contended,
>   waited before being acquired (probably
>   lock_acquired time - lock_acquire time)
> 
> - the ratio of contention versus immediate availability
>   => Sequence acquire - acquired means immediate
>      availability. If we have a contended event inside
>      it means it had to wait because of the contention.
> 
> - the total/average/maximum time a lock is held.
>   It would be very nice to also add an option to see the
>   callsites sorted from max to min, if possible with a per
>   boundary granularity: the couple (lock callsite, unlock callsite),
>   still on a per lock basis.
> 
> - any idea you could have...
> 
> 
> Such a tool would be very useful to profile the kernel locking.
> 
> It would be nice to use design close to what perf sched does:
> having an lock event structure that provides callbacks for each
> lock events so that we can easily plug various plugin inside.
> 
> It's just a suggestion in case you are interested and have time
> for that. Otherwise I'll do it later.
> 
> Hm?

I'd like to do that.
But I'm an only newbie, so it may take a week (or more).
So If you finish this work, please post and disregard me :)

   Hitoshi

