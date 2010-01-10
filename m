Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229Ab0AJBJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0AJBJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 20:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246Ab0AJBJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 20:09:54 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:42379 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280Ab0AJBJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 20:09:54 -0500
Date: Sat, 9 Jan 2010 20:04:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100110010451.GC25790@Krystal>
References: <1262900140.28171.3773.camel@gandalf.stny.rr.com> <20100108235338.GA18050@Krystal> <20100109002043.GD6816@linux.vnet.ibm.com> <20100109010231.GA25368@Krystal> <20100109012128.GF6816@linux.vnet.ibm.com> <20100109023842.GA1696@Krystal> <20100109054215.GB9044@linux.vnet.ibm.com> <20100109192006.GA23672@Krystal> <1263078327.28171.3792.camel@gandalf.stny.rr.com> <1263079000.28171.3795.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1263079000.28171.3795.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 20:01:18 up 24 days,  9:19,  5 users,  load average: 1.34, 0.41,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Sat, 2010-01-09 at 18:05 -0500, Steven Rostedt wrote:
> 
> > Then we should have O(tasks) for spinlocks taken, and 
> > O(min(tasks, CPUS)) for IPIs.
> > 
> 
> And for nr tasks >> CPUS, this may help too:
> 
> > cpumask = 0;
> > foreach task {
> 
> 	if (cpumask == online_cpus)
> 		break;

This is not required with for_each_cpu(cpu, mm_cpumask(current->mm)),
because it only iterates on active cpus on which the current process
threads are scheduled.

Thanks,

Mathieu

> 
> > 	spin_lock(task_rq(task)->rq->lock);
> > 	if (task_rq(task)->curr == task)
> > 		cpu_set(task_cpu(task), cpumask);
> > 	spin_unlock(task_rq(task)->rq->lock);
> > }
> > send_ipi(cpumask);
> > 
> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
