Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbYLPRBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbYLPRBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755779AbYLPRB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:01:27 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:36090 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754592AbYLPRB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:01:26 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EALtrR0lMROB9/2dsb2JhbACBbLxyV5Eggn8
Date: Tue, 16 Dec 2008 12:01:24 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: sched: trace: update trace_sched_wakeup()
Message-ID: <20081216170124.GA9900@Krystal>
References: <1229411223.14605.48.camel@twins> <1229414244.14605.50.camel@twins> <20081216154748.GC6231@Krystal> <1229444288.7025.35.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1229444288.7025.35.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:59:40 up 29 days, 17:40,  3 users,  load average: 1.34, 0.92,
	0.88
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2008-12-16 at 10:47 -0500, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > On Tue, 2008-12-16 at 08:07 +0100, Peter Zijlstra wrote:
> > > > Add the information needed to distinguish 'real' wakeups from 'false'
> > > > wakeups.
> > > 
> > > I don't seem to be doing so well this morning...
> > > 
> > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > 
> > > Thanks Dhaval!
> > > 
> > 
> > Applied a modified version into the 2.6.27.9 LTTng tree. Thanks!
> > (remembering that I should really move to 2.6.28-rc!)
> 
> Ingo pointed out that this generates build crap in ftrace which made me
> look at the thing again, and I just realized we don't need it.
> 
> trace_sched_wakeup() gets called before we set p->state = TASK_RUNNING,
> so by checking p->state in the callback we can see if its a real of
> false wakeup.
> 
> The scheduler tracer in ftrace already exploits this.
> 

We do something similar in LTTng : we save the state along with the
event in the trace stream and let the userspace analyzer see what was
the state of the process prior to the wakeup.

Thanks,

Mathieu

> > > > --- a/kernel/sched.c
> > > > +++ b/kernel/sched.c
> > > > @@ -2329,7 +2329,7 @@ out_activate:
> > > >  	success = 1;
> > > >  
> > > >  out_running:
> > > > -	trace_sched_wakeup(rq, p);
> > > > +	trace_sched_wakeup(rq, p, success);
> > > >  	check_preempt_curr(rq, p, sync);
> > > >  
> > > >  	p->state = TASK_RUNNING;
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
