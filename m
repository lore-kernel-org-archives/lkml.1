Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbXI0H46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbXI0H46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 03:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXI0H4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 03:56:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40062 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbXI0H4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 03:56:50 -0400
Date: Thu, 27 Sep 2007 09:56:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20070927075638.GA13963@elte.hu>
References: <1190756127.18744.23.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190756127.18744.23.camel@earth>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0828]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> humm... I think, it'd be safer to have something like the following 
> change in place.
> 
> The thing is that __pick_next_entity() must never be called when 
> first_fair(cfs_rq) == NULL. It wouldn't be a problem, should 
> 'run_node' be the very first field of 'struct sched_entity' (and it's 
> the second).
> 
> The 'nr_running != 0' check is _not_ enough, due to the fact that 
> 'current' is not within the tree. Generic paths are ok (e.g. 
> schedule() as put_prev_task() is called previously)... I'm more 
> worried about e.g. migration_call() -> CPU_DEAD_FROZEN -> 
> migrate_dead_tasks()... if 'current' == rq->idle, no problems.. if 
> it's one of the SCHED_NORMAL tasks (or imagine, some other use-cases 
> in the future -- i.e. we should not make outer world dependent on 
> internal details of sched_fair class) -- it may be "Houston, we've got 
> a problem" case.
> 
> it's +16 bytes to the ".text". Another variant is to make 'run_node' 
> the first data member of 'struct sched_entity' but an additional check 
> (se ! = NULL) is still needed in pick_next_entity().

looks good to me - and we already have something similar in sched_rt.c. 
I've added your patch to the queue. (Can i add your SoB line too?)

	Ingo
