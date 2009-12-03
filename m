Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbZLCAU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbZLCAU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 19:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbZLCAU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 19:20:28 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43299 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616AbZLCAU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 19:20:27 -0500
Date: Wed, 2 Dec 2009 16:20:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 2/4] rcu: enable fourth level of TREE_RCU
	hierarchy
Message-ID: <20091203002030.GB6746@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091202200955.GA12950@linux.vnet.ibm.com> <20091202232541.GB5479@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202232541.GB5479@feather>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 03:25:42PM -0800, Josh Triplett wrote:
> On Wed, Dec 02, 2009 at 12:10:14PM -0800, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Enable a fourth level of rcu_node hierarchy for TREE_RCU and
> > TREE_PREEMPT_RCU.  This is for stress-testing and experiemental
> > purposes only, although in theory this would enable 16,777,216 CPUs
> > on 64-bit systems, though only 1,048,576 CPUs on 32-bit systems.
> > Normal experimental use of this fourth level will normally set
> > CONFIG_RCU_FANOUT=2, requiring a 16-CPU system, though the more
> > adventurous (and more fortunate) experimenters may wish to chose
> > CONFIG_RCU_FANOUT=3 for 81-CPU systems or even CONFIG_RCU_FANOUT=4 for
> > 256-CPU systems.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> I like this idea in general, but I have one suggestion on your boot-up
> message:
> 
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> [...]
> > @@ -1877,6 +1878,9 @@ void __init rcu_init(void)
> >  #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
> >  	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
> >  #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
> > +#if NUM_RCU_LVL_4 != 0
> > +	printk(KERN_INFO "Experimental four-level hierarchy is enabled.\n");
> > +#endif /* #if NUM_RCU_LVL_4 != 0 */
> 
> Rather than printing a message when people use the four-level hierarchy,
> how about just printing a message any time someone has set
> CONFIG_RCU_FANOUT manually rather than automatically, and including
> NR_CPUS in that message?  That should only occur when testing or when
> trying to do NUMA optimization, and either way it seems worth noting.

Good point!  I will keep this patch as is, but I like the idea of having
RCU note anything unusual at boot time, and so have added this to my
todo list.  Of course, if CONFIG_RCU_FANOUT starts getting set low as a
matter of course for any (good) reason, then the definition of "anything
unusual" would change, and hence the code would also change.

> Either way the change seems fine to me.  With or without that suggested
> change:
> 
> Acked-by: Josh Triplett <josh@joshtriplett.org>

Thank you!

							Thanx, Paul
