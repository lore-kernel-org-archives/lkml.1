Return-Path: <linux-kernel-owner+w=401wt.eu-S967851AbXG3Sik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967851AbXG3Sik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935591AbXG3SiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:38:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33249 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966907AbXG3SiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:38:21 -0400
Date: Mon, 30 Jul 2007 20:38:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miguel Figueiredo <elmig@debianpt.org>
Cc: ck@vds.kolivas.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Message-ID: <20070730183804.GB20901@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com> <20070730114649.GB19186@elte.hu> <200707301704.29670.elmig@debianpt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707301704.29670.elmig@debianpt.org>
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

> in mainline (2.6.22): 
> /**
>  * sys_sched_yield - yield the current processor to other threads.
>  *
>  * This function yields the current CPU by moving the calling thread
>  * to the expired array. If there are no other threads running on this
>  * CPU then this function will return.
>  */
> 
> you changed it to something like:
> 
> if (unlikely(rq->nr_running == 1))
>                 schedstat_inc(rq, yld_act_empty);
>         else
>                 current->sched_class->yield_task(rq, current);
>
> wile mainline (2.6.22) and SD use:
> 
> dequeue_task(current, array);
> enqueue_task(current, target);

this is what CFS does:

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

	Ingo
