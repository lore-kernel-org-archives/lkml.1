Return-Path: <linux-kernel-owner+w=401wt.eu-S1762385AbXKIMmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762385AbXKIMmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 07:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbXKIMl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 07:41:57 -0500
Received: from main.gmane.org ([80.91.229.2]:44379 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbXKIMl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 07:41:56 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: DM <dm.n9107@gmail.com>
Subject: Re: [PATCH] sched: avoid large irq-latencies in smp-balancing
Date: Fri, 9 Nov 2007 12:41:28 +0000 (UTC)
Message-ID: <loom.20071109T123749-481@post.gmane.org>
References: <1194434956.6289.111.camel@twins> <1194437820.6289.114.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 62.168.138.60 (Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.30))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz <at> infradead.org> writes:
> @@ -2237,7 +2243,7 @@ balance_tasks(struct rq *this_rq, int th
>  	      enum cpu_idle_type idle, int *all_pinned,
>  	      int *this_best_prio, struct rq_iterator *iterator)
>  {
> -	int pulled = 0, pinned = 0, skip_for_load;
> +	int loops = 0, pulled = 0, pinned = 0, skip_for_load;
>  	struct task_struct *p;
>  	long rem_load_move = max_load_move;
> 
> @@ -2251,10 +2257,10 @@ balance_tasks(struct rq *this_rq, int th
>  	 */
>  	p = iterator->start(iterator->arg);
>  next:
> -	if (!p)
> +	if (!p || loops++ > sysctl_sched_nr_migrate)
>  		goto out;

Looks to me like an off-by-one thingy. If sysctl_sched_nr_migrate is zero we 
can still migrate one task. Feature or bug?

/dm


