Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbYGZNWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbYGZNWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYGZNWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:22:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58096 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbYGZNWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:22:13 -0400
Date: Sat, 26 Jul 2008 15:21:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ftrace: single CPU tracers use CPU clock
Message-ID: <20080726132118.GA30903@elte.hu>
References: <20080725220040.911370182@goodmis.org> <20080725220334.781928198@goodmis.org> <20080726124058.GD20713@elte.hu> <Pine.LNX.4.58.0807260905500.12953@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0807260905500.12953@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > this is not a good idea. We want to fix cpu_clock(), not work around 
> > any deficiencies it might have.
> 
> cpu_clock currently is "sched_clock" when the 
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK is not set. Which is done via 
> configuration, and I noticed is set on my boxes with a stable TSC??

define 'stable TSC' ;-)

> Perhaps we need to make cpu_clock change dynamically when an unstable 
> sched_clock is detected.
> 
> Even in this case, forcing the tracers that are single CPU to use a 
> clock source that modifies itself to try to look stable across CPUs 
> still seems wrong to me.  The goal of looking stable across CPUs will 
> always be at odds with the irqsoff tracer that does not care about 
> other CPUS but cares tremendously about accurate latencies.

other tracers care too - for example to have the right chronology of 
trace events. The scheduler cares too. What kind of worst-case cross-CPU 
effects have you observed?

	Ingo
