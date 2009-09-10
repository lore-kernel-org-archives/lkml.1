Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbZIJUnC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbZIJUnC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:43:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZIJUnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:43:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50279 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbZIJUnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:43:00 -0400
Date: Thu, 10 Sep 2009 22:42:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nikos Chantziaras <realnc@arcor.de>, Mike Galbraith <efault@gmx.de>,
       Jens Axboe <jens.axboe@oracle.com>, Con Kolivas <kernel@kolivas.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910204252.GA28230@elte.hu>
References: <20090906205952.GA6516@elte.hu> <200909102145.53332.Martin@lichtvoll.de> <20090910200636.GA13104@elte.hu> <200909102239.48750.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909102239.48750.Martin@lichtvoll.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Steigerwald <Martin@lichtvoll.de> wrote:

> Am Donnerstag 10 September 2009 schrieb Ingo Molnar:
> > * Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > > Am Mittwoch 09 September 2009 schrieb Peter Zijlstra:
> > > > On Wed, 2009-09-09 at 12:05 +0300, Nikos Chantziaras wrote:
> > > > > Thank you for mentioning min_granularity.  After:
> > > > >
> > > > >    echo 10000000 > /proc/sys/kernel/sched_latency_ns
> > > > >    echo 2000000 > /proc/sys/kernel/sched_min_granularity_ns
> > > >
> > > > You might also want to do:
> > > >
> > > >      echo 2000000 > /proc/sys/kernel/sched_wakeup_granularity_ns
> > > >
> > > > That affects when a newly woken task will preempt an already
> > > > running task.
> > >
> > > Heh that scheduler thing again... and unfortunately Col appearing
> > > to feel hurt while I am think that Ingo is honest on his offer on
> > > collaboration...
> > >
> > > While it makes fun playing with that numbers and indeed
> > > experiencing subjectively a more fluid deskopt how about just a
> > >
> > > echo "This is a f* desktop!" > /proc/sys/kernel/sched_workload
> > 
> > No need to do that, that's supposed to be the default :-) The knobs
> > are really just there to help us make it even more so - i.e. you
> > dont need to tune them. But it really relies on people helping us
> > out and tell us which combinations work best ...
> 
> Well currently I have:
> 
> shambhala:/proc/sys/kernel> grep "" sched_latency_ns 
> sched_min_granularity_ns sched_wakeup_granularity_ns
> sched_latency_ns:100000
> sched_min_granularity_ns:200000
> sched_wakeup_granularity_ns:0
> 
> And this give me *a completely different* desktop experience.

what is /debug/sched_features - is NO_NEW_FAIR_SLEEPERS set? If not 
set yet then try it:

  echo NO_NEW_FAIR_SLEEPERS > /debug/sched_features

that too might make things more fluid.

	Ingo
