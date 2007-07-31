Return-Path: <linux-kernel-owner+w=401wt.eu-S1762916AbXGaOJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762916AbXGaOJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbXGaOJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:09:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60839 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580AbXGaOJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:09:33 -0400
Date: Tue, 31 Jul 2007 16:09:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miguel Figueiredo <elmig@debianpt.org>
Cc: ck@vds.kolivas.org, Matthew Hawkins <darthmdh@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Message-ID: <20070731140911.GA22076@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070731094526.GA16300@elte.hu> <b21f8390707310616o1ac04f15r7f84023ca773008e@mail.gmail.com> <200707311432.45214.elmig@debianpt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707311432.45214.elmig@debianpt.org>
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

> CFS does not requeue_task() on SCHED_YIELD (used by graphic drivers) 
> as until 2.6.22 and -ck. [...]

as i pointed it out to you it does, the function's name changed:

 /*
  * sched_yield() support is very simple - we dequeue and enqueue
  */
 static void yield_task_fair(struct rq *rq, struct task_struct *p)
 {
         struct cfs_rq *cfs_rq = task_cfs_rq(p);
         u64 now = __rq_clock(rq);

         /*
          * Dequeue and enqueue the task to update its
          * position within the tree:
          */
         dequeue_entity(cfs_rq, &p->se, 0, now);
         enqueue_entity(cfs_rq, &p->se, 0, now);
 }

plus others have tried the SD NOP-yield hack-patch and while it slightly 
improved the SD numbers it did not change the "CFS is smoother" 
experience.

	Ingo
