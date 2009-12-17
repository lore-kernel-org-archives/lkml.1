Return-Path: <linux-kernel-owner+w=401wt.eu-S1761593AbZLQLAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593AbZLQLAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 06:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762292AbZLQLA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 06:00:28 -0500
Received: from fom01.emnet.dk ([89.249.14.84]:56968 "EHLO fom01.emnet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934016AbZLQLAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 06:00:25 -0500
X-AuditID: 59f90e54-b7bd7ae000001243-5b-4b2a0f46e736
Subject: Re: x264 benchmarks BFS vs CFS
From: Kasper Sandberg <lkml@metanurb.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Garrett-Glaser <darkshikari@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20091217105316.GB26010@elte.hu>
References: <1261042383.14314.0.camel@localhost>
	 <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
	 <20091217105316.GB26010@elte.hu>
Content-Type: text/plain
Date: Thu, 17 Dec 2009 12:00:18 +0100
Message-Id: <1261047618.14314.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAxIa7B4SGuw4EhrsOQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 11:53 +0100, Ingo Molnar wrote:
> * Jason Garrett-Glaser <darkshikari@gmail.com> wrote:
> 
> > On Thu, Dec 17, 2009 at 1:33 AM, Kasper Sandberg <lkml@metanurb.dk> wrote:
> > > well well :) nothing quite speaks out like graphs..
> > >
> > > http://doom10.org/index.php?topic=78.0
> > >
> > >
> > >
> > > regards,
> > > Kasper Sandberg
> > 
> > Yeah, I sent this to Mike a bit ago.  Seems that .32 has basically tied 
> > it--and given the strict thread-ordering expectations of x264, you basically 
> > can't expect it to do any better, though I'm curious what's responsible for 
> > the gap in "veryslow", even with SCHED_BATCH enabled.
> > 
> > The most odd case is that of "ultrafast", in which CFS immediately ties BFS 
> > when we enable SCHED_BATCH.  We're doing some further testing to see exactly 

Thats kinda besides the point.

all these tunables and weirdness is _NEVER_ going to work for people.

now forgive me for being so blunt, but for a user, having to do
echo x264 > /proc/cfs/gief_me_performance_on_app
or
echo some_benchmark > x264 > /proc/cfs/gief_me_performance_on_app

just isnt usable, bfs matches, even exceeds cfs on all accounts, with
ZERO user tuning, so while cfs may be able to nearly match up with a ton
of application specific stuff, that just doesnt work for a normal user.

not to mention that bfs does this whilst not loosing interactivity,
something which cfs certainly cannot boast.

<snip>


> Thanks,
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


