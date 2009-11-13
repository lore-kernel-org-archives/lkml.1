Return-Path: <linux-kernel-owner+w=401wt.eu-S932139AbZKMKvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbZKMKvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932088AbZKMKvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:51:20 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:31529 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbZKMKvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:51:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Qy4h+qPxLTkcMRztTaFOIQQUrsBuQ8WrZ7+tLAVjniB8SkI7isiSPm8E6CugUKIUU2
         FkTQoU4fE8i4D9mWaekEar6HcSn2C/ZXPrFNP0Z8EhyI7/CjGYO2WDmmjLmJ5XqIuVOx
         mA+RbV0QkkUSeXMNBG/zR8S+Di9csPDHSOWVY=
Date: Fri, 13 Nov 2009 11:51:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Measuring term of acquiring spinlock
Message-ID: <20091113105126.GC5243@nowhere>
References: <20091112.154353.680961628170545165.mitake@dcl.info.waseda.ac.jp> <20091112073909.GB31719@elte.hu> <20091113.132125.468378199533086916.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113.132125.468378199533086916.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 01:21:25PM +0900, Hitoshi Mitake wrote:
> > Might make sense to put it into 'perf lock' kind of tool. I think 
> > Frederic had such plans.
> 
> If you want a tester for 'perf lock', please call me, Frederic :)


Thanks :)
I haven't started it yet, because of some other things I need to finish.

Would you be interested in starting it?

The lock tracepoints are:

- lock_acquire: the lock is requested but not yet "acquired"
- lock_release
- lock_contended: we can't get the lock yet because someone already
  holds it.
- lock_acquired: we got the lock


So, the point would be to develop a state machine that is
able to give us statistics on a per lock granularity
basis:


- the total/average/maximum time a lock is contended,
  waited before being acquired (probably
  lock_acquired time - lock_acquire time)

- the ratio of contention versus immediate availability
  => Sequence acquire - acquired means immediate
     availability. If we have a contended event inside
     it means it had to wait because of the contention.

- the total/average/maximum time a lock is held.
  It would be very nice to also add an option to see the
  callsites sorted from max to min, if possible with a per
  boundary granularity: the couple (lock callsite, unlock callsite),
  still on a per lock basis.

- any idea you could have...


Such a tool would be very useful to profile the kernel locking.

It would be nice to use design close to what perf sched does:
having an lock event structure that provides callbacks for each
lock events so that we can easily plug various plugin inside.

It's just a suggestion in case you are interested and have time
for that. Otherwise I'll do it later.

Hm?

Thanks,
	Frederic.

