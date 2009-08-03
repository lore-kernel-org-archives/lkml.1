Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbZHCNYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbZHCNYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 09:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbZHCNYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 09:24:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55006 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbZHCNYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 09:24:49 -0400
Date: Mon, 3 Aug 2009 15:24:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       arjan@linux.intel.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Add wait, sleep and iowait accounting
	tracepoints
Message-ID: <20090803132433.GA7118@elte.hu>
References: <tip-5f3e60fb2a0e05cdaf9b59acb0bb249bb1e96362@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-5f3e60fb2a0e05cdaf9b59acb0bb249bb1e96362@git.kernel.org>
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


* tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Commit-ID:  5f3e60fb2a0e05cdaf9b59acb0bb249bb1e96362
> Gitweb:     http://git.kernel.org/tip/5f3e60fb2a0e05cdaf9b59acb0bb249bb1e96362
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Thu, 23 Jul 2009 20:13:26 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 3 Aug 2009 14:35:37 +0200

> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -546,6 +546,11 @@ update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  	schedstat_set(se->wait_sum, se->wait_sum +
>  			rq_of(cfs_rq)->clock - se->wait_start);
>  	schedstat_set(se->wait_start, 0);
> +
> +	if (entity_is_task(se)) {
> +		trace_sched_stat_wait(task_of(se),
> +			rq_of(cfs_rq)->clock - se->wait_start);
> +	}

FYI, this doesnt build with !SCHEDSTATS. I suspect we shold maintain 
se->wait_start unconditionally.

	Ingo
