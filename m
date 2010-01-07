Return-Path: <linux-kernel-owner+w=401wt.eu-S1753015Ab0AGSEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0AGSEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218Ab0AGSEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:04:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52441 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab0AGSEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:04:10 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=a6FQRHkQvOD4a6dl5WUA:9 a=4pT3euI2LGaNRkm8KinwXrSEv5YA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
       Josh Triplett <josh@joshtriplett.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
In-Reply-To: <20100107175637.GI6764@linux.vnet.ibm.com>
References: <20100107044007.GA22863@Krystal>
	 <1262842854.28171.3710.camel@gandalf.stny.rr.com>
	 <20100107061955.GC25786@Krystal> <20100107063558.GC12939@feather>
	 <1262853855.4049.86.camel@laptop>
	 <20100107165249.GE6764@linux.vnet.ibm.com>
	 <1262884716.4049.103.camel@laptop>
	 <20100107173118.GG6764@linux.vnet.ibm.com>
	 <1262886277.28171.3734.camel@gandalf.stny.rr.com>
	 <20100107175637.GI6764@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 07 Jan 2010 13:04:07 -0500
Message-ID: <1262887447.28171.3736.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 09:56 -0800, Paul E. McKenney wrote:
> On Thu, Jan 07, 2010 at 12:44:37PM -0500, Steven Rostedt wrote:
> > On Thu, 2010-01-07 at 09:31 -0800, Paul E. McKenney wrote:
> > 
> > > Something like the following for sys_membarrier(), then?
> > > 
> > >   smp_mb();
> > >   for_each_cpu(cpu, current->mm->cpu_vm_mask) {
> > >      if (cpu_curr(cpu)->mm == current->mm)
> > >         smp_call_function_single(cpu, func, NULL, 1);
> > >   }
> > > 
> > > Then the code changing ->mm on the other CPU also needs to have a
> > > full smp_mb() somewhere after the change to ->mm, but before starting
> > > user-space execution.  Which it might well just due to overhead, but
> > > we need to make sure that someone doesn't optimize us out of existence.
> > 
> > To change the mm requires things like flushing the TLB. I'd be surprised
> > if the change of the mm does not already do a smp_mb() somewhere.
> 
> Agreed, but "somewhere" does not fill me with warm fuzzies.  ;-)

Another question would be, does flushing the TLB imply a mb()?

-- Steve


