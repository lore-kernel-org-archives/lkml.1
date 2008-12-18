Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752325AbYLRNmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbYLRNmU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 08:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYLRNmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 08:42:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36757 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbYLRNmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 08:42:06 -0500
Date: Thu, 18 Dec 2008 14:42:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ken Chen <kenchen@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: fix uneven per-cpu task_group share distribution
Message-ID: <20081218134200.GC4624@elte.hu>
References: <b040c32a0812152337r4c708d59q7d71ebbcda8fe05a@mail.gmail.com> <1229503081.9487.51.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229503081.9487.51.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2008-12-15 at 23:37 -0800, Ken Chen wrote:
> > While testing CFS scheduler on linux-2.6-tip tree
> > git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
> > 
> > We found that task which is pinned to a CPU could be starved relative to its
> > allocated fair share.
> > 
> > The per-cpu sched_enetity load share calculation in tg_shares_up /
> > update_group_shares_cpu distributes total task_group's share among all CPUs
> > for a given SD domain, this would dilute task_group's per-cpu share because
> > it distributes share to CPU that even has no load.  The trapped share is now
> > un-consumable and it leads to fair share starvation on the runnable CPU.
> > Peter was right that it is still required for the low level function to make
> > distinction between a boosted share that don't have any load and actual tg
> > share that should be distributed among CPUs in which the tg is running.
> > 
> > Patch to add that boost and we think the scheduler should only boost one
> > times of tg shares over all empty CPU that don't have any load for the
> > specific task_group in order to bound maximum temporary boost that a given
> > task_group can have.
> 
> Yeah I was worried about you removing that boost, but since you seemed
> to be doing serious testing on the thing.. A well, this sounds good.
> 
> > Signed-off-by: Ken Chen <kenchen@google.com>
> 
> OK, patch looks good too, thanks!
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

applied to tip/cpus4096. [not in the tip/sched/core branch, because 
cpumask_t changes conflict with Ken's fix so this is the proper ordering.]

	Ingo
