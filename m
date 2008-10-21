Return-Path: <linux-kernel-owner+w=401wt.eu-S1752273AbYJUQSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbYJUQSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 12:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYJUQSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:18:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39555 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbYJUQSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:18:16 -0400
Date: Tue, 21 Oct 2008 09:18:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Lockup in tracepoint unregister in sched switch ftrace plugin
Message-ID: <20081021161812.GC6853@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.1.10.0810202336560.25193@gandalf.stny.rr.com> <alpine.DEB.1.10.0810210012440.25193@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810210012440.25193@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 12:14:03AM -0400, Steven Rostedt wrote:
> 
> 
> [ Paul, Thomas, wake up ]

I am awake, but fortunately for me, Ingo woke up before I did.  ;-)

(Sorry, couldn't resist...)

						Thanx, Paul

> On Mon, 20 Oct 2008, Steven Rostedt wrote:
> > 
> >   which calls unregister_trace_sched_switch define as macro to:
> > 
> > kernel/tracepoint.c: tracepoint_probe_unregister
> >    " "  : remove_tracepoint
> > kernel/rcupdate.c: rcu_barrier_sched
> >    " "  : _rcu_barrier
> > 
> > where it gets stuck at that "wait_for_completion".
> > 
> > I'm not sure if, because this is a scheduler trace point that we are 
> > hitting some kind of race that is preventing the wait_for_completion to 
> > finish, or what.
> 
> Note, I just booted this kernel with CONFIG_NOHZ=n and it booted fine.
> This looks like a bug somewhere in tracepoints/RCU/dynamic-ticks
> 
> -- Steve
> 
