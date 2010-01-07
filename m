Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625Ab0AGR4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab0AGR4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218Ab0AGR4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:56:42 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45884 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab0AGR4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:56:41 -0500
Date: Thu, 7 Jan 2010 09:56:37 -0800
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
Message-ID: <20100107175637.GI6764@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100107044007.GA22863@Krystal> <1262842854.28171.3710.camel@gandalf.stny.rr.com> <20100107061955.GC25786@Krystal> <20100107063558.GC12939@feather> <1262853855.4049.86.camel@laptop> <20100107165249.GE6764@linux.vnet.ibm.com> <1262884716.4049.103.camel@laptop> <20100107173118.GG6764@linux.vnet.ibm.com> <1262886277.28171.3734.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262886277.28171.3734.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 12:44:37PM -0500, Steven Rostedt wrote:
> On Thu, 2010-01-07 at 09:31 -0800, Paul E. McKenney wrote:
> 
> > Something like the following for sys_membarrier(), then?
> > 
> >   smp_mb();
> >   for_each_cpu(cpu, current->mm->cpu_vm_mask) {
> >      if (cpu_curr(cpu)->mm == current->mm)
> >         smp_call_function_single(cpu, func, NULL, 1);
> >   }
> > 
> > Then the code changing ->mm on the other CPU also needs to have a
> > full smp_mb() somewhere after the change to ->mm, but before starting
> > user-space execution.  Which it might well just due to overhead, but
> > we need to make sure that someone doesn't optimize us out of existence.
> 
> To change the mm requires things like flushing the TLB. I'd be surprised
> if the change of the mm does not already do a smp_mb() somewhere.

Agreed, but "somewhere" does not fill me with warm fuzzies.  ;-)

							Thanx, Paul
