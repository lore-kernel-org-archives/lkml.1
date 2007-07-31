Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbXGaQhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbXGaQhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764155AbXGaQhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:37:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55828 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763478AbXGaQhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:37:01 -0400
Date: Tue, 31 Jul 2007 18:36:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miguel Figueiredo <elmig@debianpt.org>
Cc: ck@vds.kolivas.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Message-ID: <20070731163646.GA15013@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <200707301704.29670.elmig@debianpt.org> <20070730183804.GB20901@elte.hu> <200707302205.15790.elmig@debianpt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707302205.15790.elmig@debianpt.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Miguel Figueiredo <elmig@debianpt.org> wrote:

> > this is what CFS does:
> >
> >   static void yield_task_fair(struct rq *rq, struct task_struct *p)
> >   {
> >           struct cfs_rq *cfs_rq = task_cfs_rq(p);
> >           u64 now = __rq_clock(rq);
> >
> >           /*
> >            * Dequeue and enqueue the task to update its
> >            * position within the tree:
> >            */
> >           dequeue_entity(cfs_rq, &p->se, 0, now);
> >           enqueue_entity(cfs_rq, &p->se, 0, now);
> >   }
> >
> > 	Ingo
> 
> So the difference from mainline (2.6.22) is that now you removed 
> requeue_task(), is that it?

No - I renamed requeue_task() to current->sched_class->yield_task(), 
which does this for SCHED_OTHER:

           /*
            * Dequeue and enqueue the task to update its
            * position within the tree:
            */
           dequeue_entity(cfs_rq, &p->se, 0, now);
           enqueue_entity(cfs_rq, &p->se, 0, now);

and this for RT tasks:

           static void
           yield_task_rt(struct rq *rq, struct task_struct *p)
           {
                   requeue_task_rt(rq, p);
           }

a dequeue+enqueue _is_ a requeue ...

	Ingo
