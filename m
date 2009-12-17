Return-Path: <linux-kernel-owner+w=401wt.eu-S1764735AbZLQNax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764735AbZLQNax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 08:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759810AbZLQNax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 08:30:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:45936 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757347AbZLQNaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 08:30:52 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ZlpdRcTtZdkZ94oSI16Lig/9x5JK7w6EZ0fgalx
	wRZUDDzRt1eQex
Subject: Re: x264 benchmarks BFS vs CFS
From: Mike Galbraith <efault@gmx.de>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Garrett-Glaser <darkshikari@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1261047618.14314.6.camel@localhost>
References: <1261042383.14314.0.camel@localhost>
	 <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
	 <20091217105316.GB26010@elte.hu>  <1261047618.14314.6.camel@localhost>
Content-Type: text/plain
Date: Thu, 17 Dec 2009 14:30:47 +0100
Message-Id: <1261056647.10838.26.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 12:00 +0100, Kasper Sandberg wrote:
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

Fact is, it is working for a great number of people, the vast majority
of whom don't even know where the knobs are, much less what they do. 

> now forgive me for being so blunt, but for a user, having to do
> echo x264 > /proc/cfs/gief_me_performance_on_app
> or
> echo some_benchmark > x264 > /proc/cfs/gief_me_performance_on_app

Theatrics noted.

> just isnt usable, bfs matches, even exceeds cfs on all accounts, with
> ZERO user tuning, so while cfs may be able to nearly match up with a ton
> of application specific stuff, that just doesnt work for a normal user.

Seems you haven't done much benchmarking.  BFS has strengths as well as
weaknesses, all schedulers do.

> not to mention that bfs does this whilst not loosing interactivity,
> something which cfs certainly cannot boast.

Not true.  I sent Con hard evidence of a severe problem area wrt
interactivity, and hard numbers showing other places where BFS needs
some work.  But hey, if BFS blows your skirt up, use it and be happy.

	-Mike

