Return-Path: <linux-kernel-owner+w=401wt.eu-S936158AbXJST0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936158AbXJST0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764067AbXJSTZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:25:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48790 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758798AbXJSTZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:25:58 -0400
Subject: Re: [patch 6/8] pull RT tasks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <20071019184336.983272715@goodmis.org>
References: <20071019184254.456160632@goodmis.org>
	 <20071019184336.983272715@goodmis.org>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 21:24:53 +0200
Message-Id: <1192821893.9471.17.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-19 at 14:43 -0400, Steven Rostedt wrote:
> plain text document attachment (rt-balance-pull-tasks.patch)

> +static int pull_rt_task(struct rq *this_rq)
> +{
> +	struct task_struct *next;
> +	struct task_struct *p;
> +	struct rq *src_rq;
> +	int this_cpu = this_rq->cpu;
> +	int cpu;
> +	int ret = 0;
> +
> +	assert_spin_locked(&this_rq->lock);
> +
> +	if (likely(!atomic_read(&rt_overload)))
> +		return 0;

This seems to be the only usage of rt_overload. I'm not sure its worth
keeping it around for this.

> +	next = pick_next_task_rt(this_rq);
> +
> +	for_each_cpu_mask(cpu, rto_cpumask) {
> +		if (this_cpu == cpu)
> +			continue;

...

> +	}
> +
> +	return ret;
> +}


