Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbZF2ELY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbZF2ELY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 00:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbZF2ELR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 00:11:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36587 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbZF2ELQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 00:11:16 -0400
Date: Mon, 29 Jun 2009 06:11:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Hide runqueues from direct refer at
	source code level
Message-ID: <20090629041104.GB13117@elte.hu>
References: <20090618.191448.886429908004553840.mitake@dcl.info.waseda.ac.jp> <20090622153522.GB18466@elte.hu> <20090623.132920.886429909279624487.mitake@dcl.info.waseda.ac.jp> <20090629.125902.886429909480974646.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629.125902.886429909480974646.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Subject: Re: [tip:sched/urgent] sched: Hide runqueues from direct refer at source code level
> Date: Tue, 23 Jun 2009 13:29:20 +0900 (JST)
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Subject: Re: [tip:sched/urgent] sched: Hide runqueues from direct refer at source code level
> > Date: Mon, 22 Jun 2009 17:35:22 +0200
> > 
> > > > 
> > > > Thanks for your fix, I didn't notice...
> > > > I wrote a patch to fix these two points.
> > > > 
> > > > After applying this patch,
> > > > all direct reference to runqueues is in macros. How is this?
> > > > 
> > > > Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> > > > 
> > > > diff --git a/kernel/sched.c b/kernel/sched.c
> > > > index 8ec9d13..e2ca8c1 100644
> > > > --- a/kernel/sched.c
> > > > +++ b/kernel/sched.c
> > > > @@ -692,6 +692,7 @@ static inline int cpu_of(struct rq *rq)
> > > >  #define this_rq()		(&__get_cpu_var(runqueues))
> > > >  #define task_rq(p)		cpu_rq(task_cpu(p))
> > > >  #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
> > > > +#define raw_rq()		(&__raw_get_cpu_var(runqueues))
> > > >  
> > > >  inline void update_rq_clock(struct rq *rq)
> > > >  {
> > > > @@ -6625,7 +6626,7 @@ EXPORT_SYMBOL(yield);
> > > >   */
> > > >  void __sched io_schedule(void)
> > > >  {
> > > > -	struct rq *rq = &__raw_get_cpu_var(runqueues);
> > > > +	struct rq *rq = raw_rq();
> > > >  
> > > >  	delayacct_blkio_start();
> > > >  	atomic_inc(&rq->nr_iowait);
> > > > @@ -6637,7 +6638,7 @@ EXPORT_SYMBOL(io_schedule);
> > > >  
> > > >  long __sched io_schedule_timeout(long timeout)
> > > >  {
> > > > -	struct rq *rq = &__raw_get_cpu_var(runqueues);
> > > > +	struct rq *rq = raw_rq();
> > > >  	long ret;
> > > >  
> > > >  	delayacct_blkio_start();
> > > 
> > > Looks good - mind submitting a separate patch with a changelog, etc?
> > > 
> > > 	Ingo
> > > 
> > 
> > No, I have no fix to post now. Thanks.
> > 
> 
> I felt that I misunderstood what you said.
> Are you requiring me a content for changelog?

Yes, please send a full patch with a new subject line and a 
changelog - as your previous patch has already been applied.

	Ingo
