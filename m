Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbYLPQS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbYLPQS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYLPQST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:18:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:55383 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYLPQST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:18:19 -0500
Subject: Re: sched: trace: update trace_sched_wakeup()
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20081216154748.GC6231@Krystal>
References: <1229411223.14605.48.camel@twins>
	 <1229414244.14605.50.camel@twins>  <20081216154748.GC6231@Krystal>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 16 Dec 2008 17:18:08 +0100
Message-Id: <1229444288.7025.35.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 10:47 -0500, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Tue, 2008-12-16 at 08:07 +0100, Peter Zijlstra wrote:
> > > Add the information needed to distinguish 'real' wakeups from 'false'
> > > wakeups.
> > 
> > I don't seem to be doing so well this morning...
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > 
> > Thanks Dhaval!
> > 
> 
> Applied a modified version into the 2.6.27.9 LTTng tree. Thanks!
> (remembering that I should really move to 2.6.28-rc!)

Ingo pointed out that this generates build crap in ftrace which made me
look at the thing again, and I just realized we don't need it.

trace_sched_wakeup() gets called before we set p->state = TASK_RUNNING,
so by checking p->state in the callback we can see if its a real of
false wakeup.

The scheduler tracer in ftrace already exploits this.

> > > --- a/kernel/sched.c
> > > +++ b/kernel/sched.c
> > > @@ -2329,7 +2329,7 @@ out_activate:
> > >  	success = 1;
> > >  
> > >  out_running:
> > > -	trace_sched_wakeup(rq, p);
> > > +	trace_sched_wakeup(rq, p, success);
> > >  	check_preempt_curr(rq, p, sync);
> > >  
> > >  	p->state = TASK_RUNNING;


