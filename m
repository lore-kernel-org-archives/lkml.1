Return-Path: <linux-kernel-owner+w=401wt.eu-S1764088AbXFRPEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764088AbXFRPEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763341AbXFRPEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:04:24 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54855 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbXFRPEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:04:23 -0400
Date: Mon, 18 Jun 2007 20:42:15 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       suresh.b.siddha@intel.com, pwil3058@bigpond.net.au, clameter@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: v2.6.21.4-rt11
Message-ID: <20070618151215.GA9750@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070613180451.GA16628@elte.hu> <20070613184741.GC8125@linux.vnet.ibm.com> <20070613185522.GA27335@elte.hu> <20070613233910.GJ8125@linux.vnet.ibm.com> <20070615144535.GA12078@elte.hu> <20070615151452.GC9301@linux.vnet.ibm.com> <20070615195545.GA28872@elte.hu> <20070616011605.GH9301@linux.vnet.ibm.com> <20070616084434.GG2559@linux.vnet.ibm.com> <20070616161213.GA2994@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070616161213.GA2994@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 09:12:13AM -0700, Paul E. McKenney wrote:
> On Sat, Jun 16, 2007 at 02:14:34PM +0530, Srivatsa Vaddagiri wrote:
> > On Fri, Jun 15, 2007 at 06:16:05PM -0700, Paul E. McKenney wrote:
> > > On Fri, Jun 15, 2007 at 09:55:45PM +0200, Ingo Molnar wrote:
> > > > 
> > > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > > to make sure it's not some effect in -rt causing this. v17 has an 
> > > > > > updated load balancing code. (which might or might not affect the 
> > > > > > rcutorture problem.)
> > > > > 
> > > > > Good point!  I will try the following:
> > > > > 
> > > > > 1.	Stock 2.6.21.5.
> > > > > 
> > > > > 2.	2.6.21-rt14.
> > > > > 
> > > > > 3.	2.6.21.5 + sched-cfs-v2.6.21.5-v17.patch
> > > > > 
> > > > > And quickly, before everyone else jumps on the machines that show the 
> > > > > problem.  ;-)
> > > > 
> > > > thanks! It's enough to check whether modprobe rcutorture still produces 
> > > > that weird balancing problem. That clearly has to be fixed ...
> > > > 
> > > > And i've Cc:-ed Dmitry and Srivatsa, who are busy hacking this area of 
> > > > the CFS code as we speak :-)
> > > 
> > > Well, I am not sure that the info I was able to collect will be all
> > > that helpful, but it most certainly does confirm that the balancing
> > > problem that rcutorture produces is indeed weird...
> > 
> > Hi Paul, 
> > 	I tried on two machines in our lab and could not recreate your
> > problem.
> > 
> > On a 2way x86_64 AMD box and 2.6.21.5+cfsv17:
> > 
> > 
> >   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> > 12395 root      39  19     0    0    0 R 50.3  0.0   0:57.62 rcu_torture_rea
> > 12394 root      39  19     0    0    0 R 49.9  0.0   0:57.29 rcu_torture_rea
> > 12396 root      39  19     0    0    0 R 49.9  0.0   0:56.96 rcu_torture_rea
> > 12397 root      39  19     0    0    0 R 49.9  0.0   0:56.90 rcu_torture_rea
> > 
> > On a 4way x86_64 Intel Xeon box and 2.6.21.5+cfsv17:
> > 
> >   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
> >  6258 root      39  19     0    0    0 R   53  0.0  17:29.72 0 rcu_torture_rea
> >  6252 root      39  19     0    0    0 R   49  0.0  17:49.40 3 rcu_torture_rea
> >  6257 root      39  19     0    0    0 R   49  0.0  17:22.49 2 rcu_torture_rea
> >  6256 root      39  19     0    0    0 R   48  0.0  17:50.12 1 rcu_torture_rea
> >  6254 root      39  19     0    0    0 R   48  0.0  17:26.98 0 rcu_torture_rea
> >  6255 root      39  19     0    0    0 R   48  0.0  17:25.74 2 rcu_torture_rea
> >  6251 root      39  19     0    0    0 R   45  0.0  17:47.45 3 rcu_torture_rea
> >  6253 root      39  19     0    0    0 R   45  0.0  17:48.48 1 rcu_torture_rea
> > 
> > 
> > I will try this on few more boxes we have on Monday. If I can't recreate, then 
> > I may request you to provide me machine details (or even access to the problem 
> > box if it is in IBM labs and if I am allowed to login!)
> 
> elm3b6, ABAT job 95107.  There are others, this particular job uses
> 2.6.21.5-cfsv17.

Paul,
	I logged into elm3b6 and did some investigation. I think I have
a tentative patch to fix your load-balance problem.

First, an explanation of the problem:

This particular machine, elm3b6, is a 4-cpu, (gasp, yes!) 4-node box i.e 
each CPU is a node by itself. If you don't have CONFIG_NUMA enabled,
then we won't have cross-node (i.e cross-cpu) load balancing.
Fortunately in your case you had CONFIG_NUMA enabled, but still were
hitting the (gross) load imbalance.

The problem seems to be with idle_balance(). This particular routine,
invoked by schedule() on a idle cpu, walks up sched-domain hierarchy and
tries to balance in each domain that has SD_BALANCE_NEWIDLE flag set.
The nodes-level domain (SD_NODE_INIT) however doesn't set this flag,
which means idle cpu looks for (im)balance within its own node at most and
not beyond. Now, here's the problem, if the idle cpu doesn't find
imbalance within its node (pulled_tasks = 0), it resets this_rq->next_balance
so that next balancing activity is deferred for upto a minute
(next_balance = jiffies + 60 *  HZ). If a idle cpu calls idle_balance
again in the next minute and finds no imbalance within its node, it
-again- resets next_balance. In your case, I think this was happening
repetetively, which made other CPUs never look for cross-node
(im)balance.

I believe the patch below is correct. With the patch applied, I could
not recreate the imbalance with rcutorture. Let me know whether you
still see the problem with this patch applied on any other machine.

I have CCed others who have worked in this area and request them to review 
this patch.

Andrew,
	If there is no objection from anyone, request you to pick this
up for next -mm release. It has been tested against 2.6.22-rc4-mm2.


idle_balance() can erroneously cause system-wide imbalance to be overlooked
by reseting rq->next_balance. When called sufficient number of times, it
can forever defer system-wide load balance. Patch below modifies
idle_balance() not to mess with ->next_balance. If indeed it turns out
that there is no imbalance even system-wide, rebalance_domains() will
anyway set ->next_balance to happen after a minute.


Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>


Index: linux-2.6.22-rc4/kernel/sched.c
===================================================================
--- linux-2.6.22-rc4.orig/kernel/sched.c	2007-06-18 07:16:49.000000000 -0700
+++ linux-2.6.22-rc4/kernel/sched.c	2007-06-18 07:18:41.000000000 -0700
@@ -2490,27 +2490,16 @@
 {
 	struct sched_domain *sd;
 	int pulled_task = 0;
-	unsigned long next_balance = jiffies + 60 *  HZ;
 
 	for_each_domain(this_cpu, sd) {
 		if (sd->flags & SD_BALANCE_NEWIDLE) {
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance_newidle(this_cpu,
 							this_rq, sd);
-			if (time_after(next_balance,
-				  sd->last_balance + sd->balance_interval))
-				next_balance = sd->last_balance
-						+ sd->balance_interval;
 			if (pulled_task)
 				break;
 		}
 	}
-	if (!pulled_task)
-		/*
-		 * We are going idle. next_balance may be set based on
-		 * a busy processor. So reset next_balance.
-		 */
-		this_rq->next_balance = next_balance;
 }
 
 /*


-- 
Regards,
vatsa
