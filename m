Return-Path: <linux-kernel-owner+w=401wt.eu-S933873AbXIBH22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873AbXIBH22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 03:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932399AbXIBH2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 03:28:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45474 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933156AbXIBH2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 03:28:17 -0400
Date: Sun, 2 Sep 2007 09:28:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Track accurate idle time with tick_sched.idle_sleeptime
Message-ID: <20070902072806.GC5075@elte.hu>
References: <20070827215611.GA30396@linux-os.sc.intel.com> <p73bqcmvxc6.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73bqcmvxc6.fsf@bingen.suse.de>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Venki Pallipadi <venkatesh.pallipadi@intel.com> writes:
> >  
> > +void tick_nohz_stop_idle(int cpu)
> > +{
> > +	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> > +
> > +	if (ts->idle_active) {
> > +		ktime_t now, delta;
> > +		now = ktime_get();
> 
> That could be PM timer read costing thousands of cycles.
> 
> For going into idle it's probably not a real problem, but it could 
> seriously affect out of idle latencies.

at least the current out-of-idle code already does what amounts to a 
PM-timer read when exiting from C2 or C3 mode. The 
sched_clock_idle_sleep_event() and sched_clock_idle_wakeup_event() 
callbacks utilize this already existing time information.

> You would really need a cheaper per CPU timer that doesn't stop in 
> idle (which rules out sched_clock). It's all unfortunately quite 
> messy.

yep.

	Ingo
