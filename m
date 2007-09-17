Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbXIQOMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbXIQOMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbXIQOMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 10:12:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52006 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbXIQOMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:12:40 -0400
Date: Mon, 17 Sep 2007 16:12:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jos Poortvliet <jospoortvliet@gmail.com>
Cc: Rob Hussey <robjhussey@gmail.com>, ck@vds.kolivas.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ck] Re: Scheduler benchmarks - a follow-up
Message-ID: <20070917141217.GA25956@elte.hu>
References: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com> <20070917130524.GA10707@elte.hu> <5c77e14b0709170701q2835669fu4d18b6734bcc5119@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c77e14b0709170701q2835669fu4d18b6734bcc5119@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.1.7-deb
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0110]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jos Poortvliet <jospoortvliet@gmail.com> wrote:

> On 9/17/07, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Rob Hussey <robjhussey@gmail.com> wrote:
> >
> > > http://www.healthcarelinen.com/misc/benchmarks/BOUND_hackbench_benchmark2.png
> >
> > heh - am i the only one impressed by the consistency of the blue line in
> > this graph? :-) [ and the green line looks a bit like a .. staircase? ]
> 
> Looks lovely, though as long as lower is better, that staircase does a 
> nice job ;-)

lower is better, but you have to take the thing below into account:

> > i've meanwhile tested hackbench 90 and the performance difference
> > between -ck and -cfs-devel seems to be mostly down to the more precise
> > (but slower) sched_clock() introduced in v2.6.23 and to the startup
> > penalty of freshly created tasks.
> >
> > Putting back the 2.6.22 version and tweaking the startup penalty gives
> > this:
> >
> >                             [hackbench 90, smaller is better]
> >
> >            sched-devel.git      sched-devel.git+lowres-sched-clock+dsp
> >            ---------------      --------------------------------------
> >                      5.555                  5.149
> >                      5.641                  5.149
> >                      5.572                  5.171
> >                      5.583                  5.155
> >                      5.532                  5.111
> >                      5.540                  5.138
> >                      5.617                  5.176
> >                      5.542                  5.119
> >                      5.587                  5.159
> >                      5.553                  5.177
> >            --------------------------------------
> >                 avg: 5.572             avg: 5.150 (-8.1%)
> 
> Hmmm. So cfs was 0.8% slower compared to ck in the test by Rob, it 
> became 8% faster so... it should be faster than CK - provided these 
> results are valid over different tests.

on my box the TSC overhead has hit CFS quite hard, i'm not sure that's 
true on Rob's box. So i'd expect them to be in roughly the same area.

> But this is all microbenchmarks, which won't have much effect in real 
> life, right? [...]

yeah, it's much less pronounced in real life - a context-switch rate 
above 10,000/sec is already excessive - while for example the lat_ctx 
test generates close to a million context switches a second.

> [...] Besides, will the lowres sched clock patch get in?

i dont think so - we want precise/accurate scheduling before 
performance. (otherwise tasks working off the timer tick could steal 
away cycles without being accounted for them fairly, and could starve 
out all other tasks.) Unless the difference was really huge in real life 
- but it isnt.

	Ingo
