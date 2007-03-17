Return-Path: <linux-kernel-owner+w=401wt.eu-S933651AbXCQJtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651AbXCQJtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 05:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933674AbXCQJtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 05:49:22 -0400
Received: from mail11.syd.optusnet.com.au ([211.29.132.192]:49482 "EHLO
	mail11.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933651AbXCQJtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 05:49:21 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org
Subject: Re: RSDL v0.31
Date: Sat, 17 Mar 2007 20:48:45 +1100
User-Agent: KMail/1.9.5
Cc: Serge Belyshev <belyshev@depni.sinp.msu.ru>, Ingo Molnar <mingo@elte.hu>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703042335.26785.a1426z@gawab.com> <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru>
In-Reply-To: <87fy84i7nn.fsf@depni.sinp.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703172048.46267.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2007 19:41, Serge Belyshev wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> > * Nicholas Miell <nmiell@comcast.net> wrote:
> >> The X people have plans for how to go about fixing this, [...]
> >
> > [...] Or will X regress forever once we switch to RSDL?)
> > We cannot regress the scheduling of a workload as important as "X mixed
> > with CPU-intense tasks". And "in theory this should be fixed if X is
> > fixed" does not cut it. X is pretty much _the_ most important thing to
> > optimize the interactive behavior of a Linux scheduler for. Also,
> > paradoxically, it is precisely the improvement of _X_ workloads that
> > RSDL argues with.
> >
> > this regression has to be fixed before RSDL can be merged, [...]
>
> Let me restate the fact, if it wasn't obvious enough, that most people
> who tried RSDL (and most of them use desktop systems, me including) never
> see any regressions compared to mainline. Quite contrary -- their
> impressions were that with RSDL desktop system runs more smoothly, even
> under fierce load, which was never possible with mainline scheduler.
>
> (see http://article.gmane.org/gmane.linux.kernel/504068 for a list
> of references.)

Well despite being in a drug induced stupor I find I have to reply on this 
thread. Hopefully I'm not doing my code a disservice by doing so. Who knows, 
maybe I make more sense?

The most frustrating part of a discussion of this nature on lkml is that 
earlier information in a thread seems to be long forgotten after a few days 
and all that is left is the one reporter having a problem. That's not to deny 
the one user is having a problem, but when you have a thousand downloads (no 
exaggeration) and only one person remains reporting badness it's frustrating 
that the problem actually comes down to one of semantics rather than a bug 
(will I nice or won't I).

So in an attempt to summarise the situation, what are the advantages of RSDL 
over mainline.

Fairness
Starvation free
Much lower and bound latencies
Deterministic
Better interactivity for the majority of cases.

Now concentrating on the very last aspect since that seems to be the sticking 
point.

I won't try and estimate what percentage is better, but overall it is _far_ 
more, _not_ less. The few scenarios that mainline remains better are 
unpredictable. This is where it gets interesting, because unlike mainline 
which does not have a good solution for the rest of the problems, all it 
takes is to renice X and then you have RSDL outperforming virtually always.

As for SCHED_BATCH on mainline, I think you'll find it is NOT as deterministic 
as you believe, leads to woeful interactivity, and still is starveable (just 
sleep just before your timeslice runs out). That is not a valid solution I'm 
sorry to say.

Despite the claims to the contrary, RSDL does not have _less_ heuristics, it 
does not have _any_. It's purely entitlement based. 

-- 
-ck
