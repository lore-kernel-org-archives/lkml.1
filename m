Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501Ab0ALTBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab0ALTBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 14:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879Ab0ALTBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 14:01:46 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:43090 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab0ALTBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 14:01:46 -0500
Date: Tue, 12 Jan 2010 13:56:41 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v3b)
Message-ID: <20100112185641.GA26731@Krystal>
References: <20100110052508.GG9044@linux.vnet.ibm.com> <1263124209.28171.3798.camel@gandalf.stny.rr.com> <20100110174512.GH9044@linux.vnet.ibm.com> <20100110182423.GA22821@Krystal> <20100111011705.GJ9044@linux.vnet.ibm.com> <20100111042521.GB32213@Krystal> <20100111043016.GD32213@Krystal> <20100111224355.GH6632@linux.vnet.ibm.com> <20100112153854.GA8122@Krystal> <20100112181212.GC6812@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100112181212.GC6812@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:45:42 up 27 days,  3:04,  5 users,  load average: 0.24, 0.17,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Tue, Jan 12, 2010 at 10:38:54AM -0500, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Sun, Jan 10, 2010 at 11:30:16PM -0500, Mathieu Desnoyers wrote:
> > > > Here is an implementation of a new system call, sys_membarrier(), which
> > > > executes a memory barrier on all threads of the current process.
> > > > 
> > > > It aims at greatly simplifying and enhancing the current signal-based
> > > > liburcu userspace RCU synchronize_rcu() implementation.
> > > > (found at http://lttng.org/urcu)
> > > 
> > > I didn't expect quite this comprehensive of an implementation from the
> > > outset, but I guess I cannot complain.  ;-)
> > > 
> > > Overall, good stuff.
> > > 
> > > Interestingly enough, what you have implemented is analogous to
> > > synchronize_rcu_expedited() and friends that have recently been added
> > > to the in-kernel RCU API.  By this analogy, my earlier semi-suggestion
> > > of synchronize_rcu(0 would be a candidate non-expedited implementation.
> > > Long latency, but extremely low CPU consumption, full batching of
> > > concurrent requests (even unrelated ones), and so on.
> > 
> > Yes, the main different I think is that the sys_membarrier
> > infrastructure focuses on IPI-ing only the current process running
> > threads.
> 
> Which does indeed make sense for the expedited interface.  On the other
> hand, if you have a bunch of concurrent non-expedited requests from
> different processes, covering all CPUs efficiently satisfies all of
> the requests in one go.  And, if you use synchronize_sched() for the
> non-expedited case, there will be no IPIs in the common case.

So are you proposing we add a "int expedited" parameter to the
system call, and let the caller choose between the ipi and
synchronize_sched() schemes ?

[...]
> > > Also, is "top"
> > > accurate given that the IPI handler will have interrupts disabled?
> > 
> > Probably not. AFAIK. "top" does not really consider interrupts into its
> > accounting. So, better take this top output with a grain of salt or two.
> 
> Might need something like oprofile to get good info?

Could be. Although I just wanted to point out the kind of pattern we
should expect. I'm not convinced it's so useful to give the detailed
oprofile info. I'm rephrasing the above paragraph to state that top is
not super-accurate here.

[...]

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
