Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab0BRKdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 05:33:11 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:48854 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0BRKdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 05:33:09 -0500
Date: Thu, 18 Feb 2010 16:03:01 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Anton Blanchard <anton@samba.org>, tglx@linutronix.de, davem@davemloft.net,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       venkatesh.pallipadi@intel.com, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: NO_HZ migration of TCP ack timers
Message-ID: <20100218103301.GB26101@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20100218052820.GD24270@kryten>
 <87mxz755ks.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <87mxz755ks.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org> [2010-02-18 09:08:35]:

> Anton Blanchard <anton@samba.org> writes:
> 
> > echo 0 > /proc/sys/kernel/timer_migration
> >
> > makes the problem go away.
> >
> > I think the problem is the CPU is most likely to be idle when an rx networking
> > interrupt comes in. It seems the wrong thing to do to migrate any ack timers
> > off the current cpu taking the interrupt, and with enough networks we train
> > wreck transferring everyones ack timers to the nohz load balancer cpu. 
> 
> If the nohz balancer CPU is otherwise idle, shouldn't it have enough
> cycles to handle acks for everyone? Is the problem the cache line
> transfer time?
> 
> But yes if it's non idle the migration might need to spread out 
> to more CPUs.
> 
> >
> > What should we do? Should we use mod_timer_pinned here? Or is this an issue
> 
> Sounds like something that should be controlled by the cpufreq governour's
> idle predictor? Only migrate if predicted idle time is long enough.
> It's essentially the same problem as deciding how deeply idle to put
> a CPU. Heavy measures only pay off if the expected time is long enough.
> 

cpuidle infrastructure hs statistics about the idle times for
all the cpus. Maybe we can look to use this infrastructure to decide
whether to migrate timers or not?

arun

> > other areas might see (eg the block layer) and we should instead avoid
> > migrating timers created out of interrupts.
> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.
