Return-Path: <linux-kernel-owner+w=401wt.eu-S1751383AbZLRFXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbZLRFXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 00:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZLRFXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 00:23:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46387 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbZLRFXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 00:23:52 -0500
Date: Fri, 18 Dec 2009 06:23:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jason Garrett-Glaser <darkshikari@gmail.com>
Cc: Kasper Sandberg <lkml@metanurb.dk>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x264 benchmarks BFS vs CFS
Message-ID: <20091218052344.GD417@elte.hu>
References: <1261042383.14314.0.camel@localhost>
 <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
 <20091217105316.GB26010@elte.hu>
 <1261047618.14314.6.camel@localhost>
 <28f2fcbc0912171718x271520b4k5da3376b5182d88a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28f2fcbc0912171718x271520b4k5da3376b5182d88a@mail.gmail.com>
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


* Jason Garrett-Glaser <darkshikari@gmail.com> wrote:

> On Thu, Dec 17, 2009 at 3:00 AM, Kasper Sandberg <lkml@metanurb.dk> wrote:
> > On Thu, 2009-12-17 at 11:53 +0100, Ingo Molnar wrote:
> >> * Jason Garrett-Glaser <darkshikari@gmail.com> wrote:
> >>
> >> > On Thu, Dec 17, 2009 at 1:33 AM, Kasper Sandberg <lkml@metanurb.dk> wrote:
> >> > > well well :) nothing quite speaks out like graphs..
> >> > >
> >> > > http://doom10.org/index.php?topic=78.0
> >> > >
> >> > >
> >> > >
> >> > > regards,
> >> > > Kasper Sandberg
> >> >
> >> > Yeah, I sent this to Mike a bit ago. ?Seems that .32 has basically tied
> >> > it--and given the strict thread-ordering expectations of x264, you basically
> >> > can't expect it to do any better, though I'm curious what's responsible for
> >> > the gap in "veryslow", even with SCHED_BATCH enabled.
> >> >
> >> > The most odd case is that of "ultrafast", in which CFS immediately ties BFS
> >> > when we enable SCHED_BATCH. ?We're doing some further testing to see exactly
> >
> > Thats kinda besides the point.
> >
> > all these tunables and weirdness is _NEVER_ going to work for people.
> 
> Can't individually applications request SCHED_BATCH?  Our plan was to have 
> x264 simply detect if it was necessary (once we figure out what encoding 
> settings result in the large gap situation) and automatically enable it for 
> the current application.

Yeah, SCHED_BATCH can be requested at will by an app. It's an unprivileged 
operation. It gets passed down to child tasks. (You can just do it 
unconditionally - older kernels will ignore it and give you an error code for 
setscheduler call.)

Having said that, we generally try to make things perform well without apps 
having to switch themselves to SCHED_BATCH. Mike, do you think we can make 
x264 perform as well (or nearly as well) under SCHED_OTHER as under 
SCHED_BATCH?

	Ingo
