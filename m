Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437Ab0AGSkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0AGSkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612Ab0AGSkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:40:22 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40944 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab0AGSkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:40:21 -0500
Date: Thu, 7 Jan 2010 10:40:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Josh Triplett <josh@joshtriplett.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107184016.GM6764@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1262842854.28171.3710.camel@gandalf.stny.rr.com> <20100107061955.GC25786@Krystal> <20100107063558.GC12939@feather> <1262853855.4049.86.camel@laptop> <20100107165249.GE6764@linux.vnet.ibm.com> <1262884716.4049.103.camel@laptop> <20100107173118.GG6764@linux.vnet.ibm.com> <1262886277.28171.3734.camel@gandalf.stny.rr.com> <20100107175637.GI6764@linux.vnet.ibm.com> <1262887447.28171.3736.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262887447.28171.3736.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 01:04:07PM -0500, Steven Rostedt wrote:
> On Thu, 2010-01-07 at 09:56 -0800, Paul E. McKenney wrote:
> > On Thu, Jan 07, 2010 at 12:44:37PM -0500, Steven Rostedt wrote:
> > > On Thu, 2010-01-07 at 09:31 -0800, Paul E. McKenney wrote:
> > > 
> > > > Something like the following for sys_membarrier(), then?
> > > > 
> > > >   smp_mb();
> > > >   for_each_cpu(cpu, current->mm->cpu_vm_mask) {
> > > >      if (cpu_curr(cpu)->mm == current->mm)
> > > >         smp_call_function_single(cpu, func, NULL, 1);
> > > >   }
> > > > 
> > > > Then the code changing ->mm on the other CPU also needs to have a
> > > > full smp_mb() somewhere after the change to ->mm, but before starting
> > > > user-space execution.  Which it might well just due to overhead, but
> > > > we need to make sure that someone doesn't optimize us out of existence.
> > > 
> > > To change the mm requires things like flushing the TLB. I'd be surprised
> > > if the change of the mm does not already do a smp_mb() somewhere.
> > 
> > Agreed, but "somewhere" does not fill me with warm fuzzies.  ;-)
> 
> Another question would be, does flushing the TLB imply a mb()?

I do not believe that it is guaranteed to on all architectures.

							Thanx, Paul
