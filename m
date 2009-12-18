Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZLRK44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZLRK44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 05:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZLRK4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 05:56:53 -0500
Received: from fom01.emnet.dk ([89.249.14.84]:47396 "EHLO fom01.emnet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbZLRK4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 05:56:52 -0500
X-AuditID: 59f90e54-b7bd7ae000001243-e3-4b2b5ff2a26a
Subject: Re: x264 benchmarks BFS vs CFS
From: Kasper Sandberg <lkml@metanurb.dk>
To: Jason Garrett-Glaser <darkshikari@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <28f2fcbc0912171718x271520b4k5da3376b5182d88a@mail.gmail.com>
References: <1261042383.14314.0.camel@localhost>
	 <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
	 <20091217105316.GB26010@elte.hu> <1261047618.14314.6.camel@localhost>
	 <28f2fcbc0912171718x271520b4k5da3376b5182d88a@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 Dec 2009 11:56:46 +0100
Message-Id: <1261133806.14314.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAARIa7Dg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 17:18 -0800, Jason Garrett-Glaser wrote:
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
> >> > Yeah, I sent this to Mike a bit ago.  Seems that .32 has basically tied
> >> > it--and given the strict thread-ordering expectations of x264, you basically
> >> > can't expect it to do any better, though I'm curious what's responsible for
> >> > the gap in "veryslow", even with SCHED_BATCH enabled.
> >> >
> >> > The most odd case is that of "ultrafast", in which CFS immediately ties BFS
> >> > when we enable SCHED_BATCH.  We're doing some further testing to see exactly
> >
> > Thats kinda besides the point.
> >
> > all these tunables and weirdness is _NEVER_ going to work for people.
> 
> Can't individually applications request SCHED_BATCH?  Our plan was to
> have x264 simply detect if it was necessary (once we figure out what
> encoding settings result in the large gap situation) and automatically
> enable it for the current application.
that is an insane solution, especially considering better schedulers
outperform cfs SCHED_BATCH without doing ANYTHING special.

Do you not see what is happening here? it is simply grotesk
> 
> Jason

