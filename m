Return-Path: <linux-kernel-owner+w=401wt.eu-S1764022AbZLQMfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764022AbZLQMfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758572AbZLQMfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:35:52 -0500
Received: from fom01.emnet.dk ([89.249.14.84]:44833 "EHLO fom01.emnet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058AbZLQMfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:35:52 -0500
X-AuditID: 59f90e54-b7bd7ae000001243-3c-4b2a25a61754
Subject: Re: x264 benchmarks BFS vs CFS
From: Kasper Sandberg <lkml@metanurb.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Garrett-Glaser <darkshikari@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20091217120826.GA32125@elte.hu>
References: <1261042383.14314.0.camel@localhost>
	 <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
	 <20091217105316.GB26010@elte.hu> <1261047618.14314.6.camel@localhost>
	 <20091217120826.GA32125@elte.hu>
Content-Type: text/plain
Date: Thu, 17 Dec 2009 13:35:46 +0100
Message-Id: <1261053346.14314.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAARIa7Dg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 13:08 +0100, Ingo Molnar wrote:
> * Kasper Sandberg <lkml@metanurb.dk> wrote:
> 
> > On Thu, 2009-12-17 at 11:53 +0100, Ingo Molnar wrote:
> > > * Jason Garrett-Glaser <darkshikari@gmail.com> wrote:
> > > 
> > > > On Thu, Dec 17, 2009 at 1:33 AM, Kasper Sandberg <lkml@metanurb.dk> wrote:
> > > > > well well :) nothing quite speaks out like graphs..
> > > > >
> > > > > http://doom10.org/index.php?topic=78.0
> > > > >
> > > > >
> > > > >
> > > > > regards,
> > > > > Kasper Sandberg
> > > > 
> > > > Yeah, I sent this to Mike a bit ago.  Seems that .32 has basically tied 
> > > > it--and given the strict thread-ordering expectations of x264, you basically 
> > > > can't expect it to do any better, though I'm curious what's responsible for 
> > > > the gap in "veryslow", even with SCHED_BATCH enabled.
> > > > 
> > > > The most odd case is that of "ultrafast", in which CFS immediately ties BFS 
> > > > when we enable SCHED_BATCH.  We're doing some further testing to see exactly 
> > 
> > Thats kinda besides the point.
> > 
> > all these tunables and weirdness is _NEVER_ going to work for people.
> 
> v2.6.32 improved quite a bit on the x264 front so i dont think that's 
> necessarily the case.

again, pretty much application specific, and furthermore, ONLY with
SCHED_BATCH is it near BFS. as you know, SCHED_BATCH isnt exactly what
you wanna do for desktop or other interactivity-hungry tasks? bfs
manages better performance than cfs with SCHED_BATCH, without
SCHED_BATCH

> 
> But yes, i'll subscribe to the view that we cannot satisfy everything all the 
> time. There's tradeoffs in every scheduler design.
yet getting not even as good on average performance from CFS as BFS,
requires tunables, swtiching scheduler policies etc

> 
> > now forgive me for being so blunt, but for a user, having to do
> > echo x264 > /proc/cfs/gief_me_performance_on_app
> > or
> > echo some_benchmark > x264 > /proc/cfs/gief_me_performance_on_app
> > 
> > just isnt usable, bfs matches, even exceeds cfs on all accounts, with ZERO 
> > user tuning, so while cfs may be able to nearly match up with a ton of 
> > application specific stuff, that just doesnt work for a normal user.

^^^^ This is also something you need to consider.

> > 
> > not to mention that bfs does this whilst not loosing interactivity, 
> > something which cfs certainly cannot boast.
> 
> What kind of latencies are those? Arent they just compiz induced due to 
> different weighting of workloads in BFS and in the upstream scheduler?
> Would you be willing to help us out pinning them down?

Theres not much i can do, i dont have time to switch kernels on my
systems, all i can give you is this simple information, on my systems,
ranging from embedded to dual core2 quad and core i7, BFS manages to
give lower latencies(aka jack doesnt skip with very low latency output,
everythings smoother, even measurably on the desktop), greater
performance(as evidenced by lots of benchmarks, including those i
posted), and that is without touching a single scheduler policy or
tunable at all.

Im well aware that CFS can be tweaked via tunables/policies to achieve a
single of these goals at a time, and im also well aware you cannot ever
do every single cornercase perfectly with one scheduler, however, and
consider this very thoroughly, bfs manages without any tunables, to do
the vast majority of the cases with an excellence CFS can not even 100%
match, even tunables and scheduler polices.. and that is with ALOT less
code aswell.. This ought to tell you that something can and should be
done.

> 
> To move the discussion to the numeric front please send the 'perf sched 
> latency' output of an affected workload.
> 
> Thanks,
> 
> 	Ingo

