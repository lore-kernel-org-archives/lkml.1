Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZFWE3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZFWE3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 00:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbZFWE3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 00:29:25 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62764 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZFWE3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 00:29:24 -0400
Date: Tue, 23 Jun 2009 13:29:20 +0900 (JST)
Message-Id: <20090623.132920.886429909279624487.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Hide runqueues from direct refer at
 source code level
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20090622153522.GB18466@elte.hu>
References: <20090617163111.GA16128@elte.hu>
	<20090618.191448.886429908004553840.mitake@dcl.info.waseda.ac.jp>
	<20090622153522.GB18466@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [tip:sched/urgent] sched: Hide runqueues from direct refer at source code level
Date: Mon, 22 Jun 2009 17:35:22 +0200

> > 
> > Thanks for your fix, I didn't notice...
> > I wrote a patch to fix these two points.
> > 
> > After applying this patch,
> > all direct reference to runqueues is in macros. How is this?
> > 
> > Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 8ec9d13..e2ca8c1 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -692,6 +692,7 @@ static inline int cpu_of(struct rq *rq)
> >  #define this_rq()		(&__get_cpu_var(runqueues))
> >  #define task_rq(p)		cpu_rq(task_cpu(p))
> >  #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
> > +#define raw_rq()		(&__raw_get_cpu_var(runqueues))
> >  
> >  inline void update_rq_clock(struct rq *rq)
> >  {
> > @@ -6625,7 +6626,7 @@ EXPORT_SYMBOL(yield);
> >   */
> >  void __sched io_schedule(void)
> >  {
> > -	struct rq *rq = &__raw_get_cpu_var(runqueues);
> > +	struct rq *rq = raw_rq();
> >  
> >  	delayacct_blkio_start();
> >  	atomic_inc(&rq->nr_iowait);
> > @@ -6637,7 +6638,7 @@ EXPORT_SYMBOL(io_schedule);
> >  
> >  long __sched io_schedule_timeout(long timeout)
> >  {
> > -	struct rq *rq = &__raw_get_cpu_var(runqueues);
> > +	struct rq *rq = raw_rq();
> >  	long ret;
> >  
> >  	delayacct_blkio_start();
> 
> Looks good - mind submitting a separate patch with a changelog, etc?
> 
> 	Ingo
> 

No, I have no fix to post now. Thanks.

