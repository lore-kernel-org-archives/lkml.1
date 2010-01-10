Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020Ab0AJBNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0AJBNA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 20:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520Ab0AJBNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 20:13:00 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:51352 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179Ab0AJBM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 20:12:59 -0500
Date: Sat, 9 Jan 2010 20:12:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100110011255.GE25790@Krystal>
References: <20100108235338.GA18050@Krystal> <20100109002043.GD6816@linux.vnet.ibm.com> <20100109010231.GA25368@Krystal> <20100109012128.GF6816@linux.vnet.ibm.com> <20100109023842.GA1696@Krystal> <20100109054215.GB9044@linux.vnet.ibm.com> <20100109192006.GA23672@Krystal> <1263078327.28171.3792.camel@gandalf.stny.rr.com> <1263079000.28171.3795.camel@gandalf.stny.rr.com> <20100110000318.GD9044@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100110000318.GD9044@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 20:11:55 up 24 days,  9:30,  5 users,  load average: 0.00, 0.07,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Sat, Jan 09, 2010 at 06:16:40PM -0500, Steven Rostedt wrote:
> > On Sat, 2010-01-09 at 18:05 -0500, Steven Rostedt wrote:
> > 
> > > Then we should have O(tasks) for spinlocks taken, and 
> > > O(min(tasks, CPUS)) for IPIs.
> > 
> > And for nr tasks >> CPUS, this may help too:
> > 
> > > cpumask = 0;
> > > foreach task {
> > 
> > 	if (cpumask == online_cpus)
> > 		break;
> > 
> > > 	spin_lock(task_rq(task)->rq->lock);
> > > 	if (task_rq(task)->curr == task)
> > > 		cpu_set(task_cpu(task), cpumask);
> > > 	spin_unlock(task_rq(task)->rq->lock);
> > > }
> > > send_ipi(cpumask);
> 
> Good point, erring on the side of sending too many IPIs is safe.  One
> might even be able to just send the full set if enough of the CPUs were
> running the current process and none of the remainder were running
> real-time threads.  And yes, it would then be necessary to throttle
> calls to sys_membarrier().
> 
> Quickly hiding behind a suitable boulder...  ;-)

:)

One quick counter-argument against IPI-to-all: that will wake up all
CPUs, including those which are asleep. Not really good for
energy-saving.

Mathieu

> 
> 							Thanx, Paul

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
