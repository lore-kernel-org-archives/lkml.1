Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbXGGJYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbXGGJYs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 05:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXGGJYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 05:24:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36099 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbXGGJYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 05:24:38 -0400
Date: Sat, 7 Jul 2007 11:24:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Rui Nuno Capela <rncbc@rncbc.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "jcaceres@ccrma.Stanford.EDU" <jcaceres@ccrma.Stanford.EDU>,
       Carsten Emde <carsten.emde@osadl.org>
Subject: Re: v2.6.21.5-rt19
Message-ID: <20070707092401.GB21234@elte.hu>
References: <1183582155.3291.160.camel@chaos> <9609.194.65.103.1.1183731007.squirrel@www.rncbc.org> <1183758545.20747.34.camel@cmn3.stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183758545.20747.34.camel@cmn3.stanford.edu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:

> > > Changes since 2.6.21.5-rt18:
> > >
> > > - Fixed a nasty and hard to track down slowness / boot problem on SMP
> > > machines with CONFIG_NOHZ enabled. The problem was caused by the timer
> > > wheel base lock held during the get_next_timer_interrupt() call in the
> > > idle path, which eventually led to a bogus PI boosting of the idle task
> > > and in consequence a stale wrong scheduler selection for the affected idle
> > > task.
> > >
> > > Kudos to Carsten Emde, who patiently and meticulously isolated the
> > > problem and provided the traces, which allowed to identify the root cause.
> > >
> > > Problem solution: Prevent idle task boosting

> > Maybe someone remember me whining about troubles with 2.6.21-rt2..18 
> > on my Core2 T7200 laptop (fujitsu-siemens amilo i1520).
> > 
> > Althought I'm still with my fingers crossed, I can tell the good 
> > news are that 2.6.21.5-rt19 (and -rt20) does behave far better now 
> > on the very same box.
> 
> Yes, it works much better indeed...
> 
> Ingo: is there a place where I can read about the changes in different 
> rtxx releases? What is new/better/fixed in rt20? (I see scheduler 
> stuff in a diff from rt19 to rt20 but I don't really know what it 
> means).

and rt18 was a -rt-only NOHZ fix, that bug got introduced in rt11 when 
CFS was merged.

i _think_ Rui might have seen two separate problems. Perhaps by the time 
we fixed the first problem (which Rui saw since -rt2) we introduced the 
other one via -rt11 - which then got fixed in -rt19.

btw., we'd love to get more feedback regarding CFS. CFS is a completely 
new scheduler for Linux. It has a design centered around keeping 
application latencies down, so it is ultimately real-time friendly, and 
it should also make things work better for desktop-ish and audio-ish 
stuff as well. (even under SCHED_OTHER)

So it would be nice if you could keep an extra eye on any scheduling 
artifacts or regressions, and make sure your favorite workload is still 
handled by the Linux scheduler in the utmost best way. I'd like to hear 
about any sort of "scheduling behavior / interactivity" regression you 
might see, relative to the vanilla kernel. Or if you can see no such 
problems then a line of "it works as well as the previous scheduler" is 
important info to us too. Thanks!

	Ingo
