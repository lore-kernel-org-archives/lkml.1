Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZK0EzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZK0EzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 23:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZK0EzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 23:55:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34294 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbZK0EzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 23:55:19 -0500
Date: Fri, 27 Nov 2009 05:54:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4 tip/sched/core] sched: rename preempt_notifier to
 sched_notifier and always enable it
Message-ID: <20091127045459.GB13914@elte.hu>
References: <20091126190018.88a6dd77.sfr@canb.auug.org.au>
 <20091126081237.GA31034@elte.hu>
 <4B0E4741.10509@kernel.org>
 <20091126092631.GA17253@elte.hu>
 <4B0E4EFB.2070705@kernel.org>
 <20091126095154.GE32275@elte.hu>
 <4B0E5458.30303@kernel.org>
 <20091126102936.GA1196@elte.hu>
 <19215.18562.408682.656799@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19215.18562.408682.656799@drongo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > The sched notifiers and the various event notifiers we have in the same 
> > codepaths should really be unified into a single callback framework.
> > 
> > We have these _5_ callbacks:
> > 
> > ...
> >         perf_event_task_sched_out(prev, next, cpu);
> > ...
> >         fire_sched_out_notifiers(prev, next);
> > ...
> >         trace_sched_switch(rq, prev, next);
> > ...
> >         perf_event_task_sched_in(current, cpu_of(rq));
> > 	fire_sched_in_notifiers(current);
> > ...
> > 
> > That could be done with just two callbacks - one for sched-out, one for 
> > sched-in.
> > 
> > The best way to do that would be to use two TRACE_EVENT() callbacks, 
> > make them unconditional and register to them. (with wrappers to make 
> > it all convenient to use)
> 
> I'd rather 5 explicit direct function calls than two direct calls and 
> five indirect function calls, actually...

Those five callbacks are typically disabled on a regular Linux system. 
So i'd rather have two sites with some NOPs in them. (no branches, no 
calls)

	Ingo
