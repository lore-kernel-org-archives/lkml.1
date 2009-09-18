Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbZIRRWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbZIRRWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbZIRRWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:22:53 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50313 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745AbZIRRWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:22:52 -0400
Date: Fri, 18 Sep 2009 10:22:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH tip/core/rcu 2/3] Apply results of code inspection of
	kernel/rcutree_plugin.h
Message-ID: <20090918172251.GC6767@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090918164955.GA22272@linux.vnet.ibm.com> <1253293100.7060.46.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253293100.7060.46.camel@desktop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 09:58:20AM -0700, Daniel Walker wrote:
> On Fri, 2009-09-18 at 09:50 -0700, Paul E. McKenney wrote:
> 
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index 2b996c3..a2d586c 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -117,9 +117,9 @@ static void rcu_preempt_note_context_switch(int cpu)
> >  		 * on line!
> >  		 */
> >  	    	WARN_ON_ONCE((rdp->grpmask & rnp->qsmaskinit) == 0);
> > -		phase = !(rnp->qsmask & rdp->grpmask) ^ (rnp->gpnum & 0x1);
> > +	    	WARN_ON_ONCE(!list_empty(&t->rcu_node_entry));
> > +		phase = (rnp->gpnum + !(rnp->qsmask & rdp->grpmask)) & 0x1;
> >  		list_add(&t->rcu_node_entry, &rnp->blocked_tasks[phase]);
> > -		smp_mb();  /* Ensure later ctxt swtch seen after above. */
> >  		spin_unlock_irqrestore(&rnp->lock, flags);
> >  	}
> 
> ERROR: code indent should use tabs where possible
> #149: FILE: kernel/rcutree_plugin.h:120:
> +^I    ^IWARN_ON_ONCE(!list_empty(&t->rcu_node_entry));$
> 
> One funny indent in the line above.. If your intending for Ingo to take
> this he might just fix it on apply ..

I will be submitting a patch shortly to clean up the whitespace errors
in the include/linux/rcu* and kernel/rcu* files.

							Thanx, Paul
