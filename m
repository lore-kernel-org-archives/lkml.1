Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbXJWC2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbXJWC2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 22:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbXJWC22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 22:28:28 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53112 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbXJWC21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 22:28:27 -0400
Date: Tue, 23 Oct 2007 08:10:36 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] CFS CGroup: Report usage
Message-ID: <20071023024036.GC3324@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <471D4523.4040509@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471D4523.4040509@google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 05:49:39PM -0700, Paul Menage wrote:
> +static u64 cpu_usage_read(struct cgroup *cgrp, struct cftype *cft)
> +{
> +	struct task_group *tg = cgroup_tg(cgrp);
> +	int i;
> +	u64 res = 0;
> +	for_each_possible_cpu(i) {
> +		unsigned long flags;
> +		spin_lock_irqsave(&tg->cfs_rq[i]->rq->lock, flags);

Is the lock absolutely required here?

Hmm .. I hope the cgroup code prevents a task group from being destroyed while 
we are still reading a task group's cpu usage. Is that so?

> +		res += tg->se[i]->sum_exec_runtime;
> +		spin_unlock_irqrestore(&tg->cfs_rq[i]->rq->lock, flags);
> +	}
> +	/* Convert from ns to ms */
> +	do_div(res, 1000000);
> +	return res;
> +}

-- 
Regards,
vatsa
