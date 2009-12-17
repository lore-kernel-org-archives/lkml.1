Return-Path: <linux-kernel-owner+w=401wt.eu-S1764579AbZLQMIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764579AbZLQMIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764584AbZLQMIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:08:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46279 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764562AbZLQMIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:08:36 -0500
Date: Thu, 17 Dec 2009 13:08:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Jason Garrett-Glaser <darkshikari@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x264 benchmarks BFS vs CFS
Message-ID: <20091217120826.GA32125@elte.hu>
References: <1261042383.14314.0.camel@localhost>
 <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
 <20091217105316.GB26010@elte.hu>
 <1261047618.14314.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261047618.14314.6.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kasper Sandberg <lkml@metanurb.dk> wrote:

> On Thu, 2009-12-17 at 11:53 +0100, Ingo Molnar wrote:
> > * Jason Garrett-Glaser <darkshikari@gmail.com> wrote:
> > 
> > > On Thu, Dec 17, 2009 at 1:33 AM, Kasper Sandberg <lkml@metanurb.dk> wrote:
> > > > well well :) nothing quite speaks out like graphs..
> > > >
> > > > http://doom10.org/index.php?topic=78.0
> > > >
> > > >
> > > >
> > > > regards,
> > > > Kasper Sandberg
> > > 
> > > Yeah, I sent this to Mike a bit ago.  Seems that .32 has basically tied 
> > > it--and given the strict thread-ordering expectations of x264, you basically 
> > > can't expect it to do any better, though I'm curious what's responsible for 
> > > the gap in "veryslow", even with SCHED_BATCH enabled.
> > > 
> > > The most odd case is that of "ultrafast", in which CFS immediately ties BFS 
> > > when we enable SCHED_BATCH.  We're doing some further testing to see exactly 
> 
> Thats kinda besides the point.
> 
> all these tunables and weirdness is _NEVER_ going to work for people.

v2.6.32 improved quite a bit on the x264 front so i dont think that's 
necessarily the case.

But yes, i'll subscribe to the view that we cannot satisfy everything all the 
time. There's tradeoffs in every scheduler design.

> now forgive me for being so blunt, but for a user, having to do
> echo x264 > /proc/cfs/gief_me_performance_on_app
> or
> echo some_benchmark > x264 > /proc/cfs/gief_me_performance_on_app
> 
> just isnt usable, bfs matches, even exceeds cfs on all accounts, with ZERO 
> user tuning, so while cfs may be able to nearly match up with a ton of 
> application specific stuff, that just doesnt work for a normal user.
> 
> not to mention that bfs does this whilst not loosing interactivity, 
> something which cfs certainly cannot boast.

What kind of latencies are those? Arent they just compiz induced due to 
different weighting of workloads in BFS and in the upstream scheduler?
Would you be willing to help us out pinning them down?

To move the discussion to the numeric front please send the 'perf sched 
latency' output of an affected workload.

Thanks,

	Ingo
