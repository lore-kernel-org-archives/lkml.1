Return-Path: <linux-kernel-owner+w=401wt.eu-S969561AbXFHP2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969561AbXFHP2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932790AbXFHP2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:28:09 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:60968 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934002AbXFHP2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:28:07 -0400
Subject: Re: [PATCH RT] convert RCU Preempt tasklet into softirq.
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       RT <linux-rt-users@vger.kernel.org>
In-Reply-To: <20070607210247.GA9390@linux.vnet.ibm.com>
References: <1181180051.18444.31.camel@localhost.localdomain>
	 <20070607041411.GB1783@linux.vnet.ibm.com>
	 <1181226138.18444.54.camel@localhost.localdomain>
	 <20070607161754.GA11941@linux.vnet.ibm.com>
	 <1181240819.10408.14.camel@localhost.localdomain>
	 <20070607210247.GA9390@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 11:27:08 -0400
Message-Id: <1181316428.10408.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 14:02 -0700, Paul E. McKenney wrote:

> Some nits below.
> 
> 						Thanx, Paul
> 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > Index: linux-2.6.21-rt9/include/linux/rcupreempt.h
> > ===================================================================
> > --- linux-2.6.21-rt9.orig/include/linux/rcupreempt.h
> > +++ linux-2.6.21-rt9/include/linux/rcupreempt.h
> > @@ -63,7 +63,9 @@ extern void rcu_check_callbacks(int cpu,
> >  extern void rcu_restart_cpu(int cpu);
> >  extern long rcu_batches_completed(void);
> > 
> > -extern void rcu_process_callbacks(unsigned long unused);
> > +struct softirq_action;
> > +
> > +extern void rcu_process_callbacks(struct softirq_action *unused);
> 
> I don't understand why the above is needed -- interrupt.h is included,
> and the use of rcu_process_callbacks() follows the definition.
> 
> >  #endif /* __KERNEL__ */
> >  #endif /* __LINUX_RCUPREEMPT_H */

The first time I compiled it, I forgot the ';' and got a warning there.
But the warning also included "declaring structure softirq_action in
prototype", so I fixed both the ';' and added the struct. I can try
compile without it. But I also know that adding #include <interrupt.h>
in rcupreempt.h caused issues too.

-- Steve

