Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbXLMXmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbXLMXmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761208AbXLMXmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:42:03 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:42800 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759694AbXLMXmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:42:00 -0500
Date: Thu, 13 Dec 2007 15:41:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 0/6] RCU: Preemptible-RCU
Message-ID: <20071213234134.GH10307@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071213170348.GA25981@in.ibm.com> <20071213203804.GE25130@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213203804.GE25130@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 09:38:04PM +0100, Ingo Molnar wrote:
> 
> * Gautham R Shenoy <ego@in.ibm.com> wrote:
> 
> > Hello everyone,
> > 
> > This patchset is an updated version of the preemptible RCU patchset 
> > that Paul McKenney had posted it in September earlier this year that 
> > can be found here --> http://lkml.org/lkml/2007/9/10/213
> > 
> > This patchset incorporates the review comments from Oleg Nesterov and 
> > Steven Rostedt.
> > 
> > The testing report of the patchset is as follows:
> > ====================================================================
> > Patch-stack:  	2.6.23-rc3 + cpu-hotplug patches from 
> > 		http://lkml.org/lkml/2007/11/15/239 + Preempt-RCU
> > 		patches.
> > Test:		RCU-Torture running parallelly with CPU-Hotplug
> > 		operations.
> > Duration:	24 hours.
> > Architectures:	x86,x86_64, ppc64.
> > ====================================================================
> > 
> > 
> > Currently it is based against the latest linux-2.6-sched-devel.git
> > 
> > Awaiting your feedback!
> 
> thanks Gautham, the patchset from you and Paul looks good to me and i've 
> applied it to sched-devel.git to get it tested and reviewed some more.
> 
> from the Nitpicking Police, there are a couple of minor style 
> problems/warnings with the code, you can see it via:
> 
>   scripts/checkpatch.pl --file kernel/rcu*.c
> 
> nothing serious - RCU is still one of the cleanest subsystems in the 
> kernel:
> 
>                                       errors   lines of code   errors/KLOC
> kernel/rcuclassic.c                        0             575             0
> kernel/rcupdate.c                          1             138           7.2

This one is the exception to checkpatch.pl's rule against "volatile".  ;-)

The volatile declaration is within the ACCESS_ONCE() macro that is used
within rcu_read_lock() and rcu_read_unlock() to force the compiler to
maintain ordering with respect to interrupt handler running only on that
same CPU.

> kernel/rcupreempt.c                        0             953             0
> kernel/rcupreempt_trace.c                  0             330             0
> kernel/rcutorture.c                        8             995           8.0

Hmmm...  Definitely some old whitespace issues here...

> the eventual goal would be to match:
> 
>    scripts/checkpatch.pl --file kernel/sched*.[ch]
> 
> output ;-)

We should be able to make some progress in that direction.  ;-)

							Thanx, Paul
