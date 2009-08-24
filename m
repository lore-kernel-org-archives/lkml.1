Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZHXQED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZHXQED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:04:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZHXQEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:04:01 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47152 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbZHXQEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:04:00 -0400
Date: Mon, 24 Aug 2009 09:03:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josht@linux.vnet.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org
Subject: Re: [PATCH -tip] v3 Consolidate sparse and lockdep declarations in
	include/linux/rcupdate.h
Message-ID: <20090824160359.GG6677@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090727181401.GA14120@linux.vnet.ibm.com> <4A924296.3070308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A924296.3070308@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 03:34:46PM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---

[ . . . ]

> >   * rcu_read_lock_sched - mark the beginning of a RCU-classic critical section
> > @@ -160,10 +190,14 @@ extern int rcu_scheduler_active;
> >  static inline void rcu_read_lock_sched(void)
> >  {
> >  	preempt_disable();
> > +	__acquire(RCU_SCHED);
> > +	rcu_read_acquire();
> >  }
> >  static inline void rcu_read_lock_sched_notrace(void)
> 
> It need be marked "notrace" too.

I guess I just need to grep for "_notrace(" in my code.  ;-)

> >  {
> >  	preempt_disable_notrace();
> > +	__acquire(RCU_SCHED);
> > +	rcu_read_acquire();
> >  }
> 
> It may cause infinity recursion.
> rcu_read_acquire() calls rcu_read_lock_sched_notrace()
> before current->lockdep_recursion is set to 1 when tracing in on,
> thus infinity recursion occurs.

That might explain Ingo's test results.

Thank you again, good catch!!!

							Thanx, Paul
