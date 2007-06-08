Return-Path: <linux-kernel-owner+w=401wt.eu-S939593AbXFHThL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939593AbXFHThL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbXFHTg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:36:59 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33348 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbXFHTg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:36:58 -0400
Date: Fri, 8 Jun 2007 12:36:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       RT <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH RT] convert RCU Preempt tasklet into softirq.
Message-ID: <20070608193655.GA18399@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1181180051.18444.31.camel@localhost.localdomain> <20070607041411.GB1783@linux.vnet.ibm.com> <1181226138.18444.54.camel@localhost.localdomain> <20070607161754.GA11941@linux.vnet.ibm.com> <1181240819.10408.14.camel@localhost.localdomain> <20070607210247.GA9390@linux.vnet.ibm.com> <1181316428.10408.30.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181316428.10408.30.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 11:27:08AM -0400, Steven Rostedt wrote:
> On Thu, 2007-06-07 at 14:02 -0700, Paul E. McKenney wrote:
> 
> > Some nits below.
> > 
> > 						Thanx, Paul
> > 
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > 
> > > Index: linux-2.6.21-rt9/include/linux/rcupreempt.h
> > > ===================================================================
> > > --- linux-2.6.21-rt9.orig/include/linux/rcupreempt.h
> > > +++ linux-2.6.21-rt9/include/linux/rcupreempt.h
> > > @@ -63,7 +63,9 @@ extern void rcu_check_callbacks(int cpu,
> > >  extern void rcu_restart_cpu(int cpu);
> > >  extern long rcu_batches_completed(void);
> > > 
> > > -extern void rcu_process_callbacks(unsigned long unused);
> > > +struct softirq_action;
> > > +
> > > +extern void rcu_process_callbacks(struct softirq_action *unused);
> > 
> > I don't understand why the above is needed -- interrupt.h is included,
> > and the use of rcu_process_callbacks() follows the definition.
> > 
> > >  #endif /* __KERNEL__ */
> > >  #endif /* __LINUX_RCUPREEMPT_H */
> 
> The first time I compiled it, I forgot the ';' and got a warning there.
> But the warning also included "declaring structure softirq_action in
> prototype", so I fixed both the ';' and added the struct. I can try
> compile without it. But I also know that adding #include <interrupt.h>
> in rcupreempt.h caused issues too.

If I leave out both the "struct softirq_action" and the
rcu_process_callbacks() declaration,, it compiles for me.

So I guess the rcu_process_callbacks() should be declared static...

						Thanx, Paul
