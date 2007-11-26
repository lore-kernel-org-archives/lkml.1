Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbXKZU26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbXKZU26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 15:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbXKZU2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 15:28:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34556 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbXKZU2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 15:28:50 -0500
Date: Mon, 26 Nov 2007 21:28:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       Dipankar <dipankar@in.ibm.com>
Subject: Re: [Patch 4/4] sched: Improve fairness of cpu bandwidth
	allocation for task groups
Message-ID: <20071126202836.GA17012@elte.hu>
References: <20071119122713.GA28777@linux.vnet.ibm.com> <20071119123051.GC28777@linux.vnet.ibm.com> <20071119131201.GB31491@elte.hu> <20071119150312.GA2365@linux.vnet.ibm.com> <20071119152258.GB31426@elte.hu> <20071119160647.GV3359@linux.vnet.ibm.com> <20071119190057.GA12650@elte.hu> <20071126050044.GA5304@linux.vnet.ibm.com> <20071126050905.GF5304@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126050905.GF5304@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> +	/* we don't want this thread's execution to be limited by the shares
> +	 * assigned to default group (init_task_group). Hence make it run
> +	 * as a RT task.
> +	 */
> +	schedparm.sched_priority = 0; /* run at the lowest RT prio */
> +	ret = sched_setscheduler(current, SCHED_RR, &schedparm);
> +	if (ret)
> +		printk(KERN_ERR "Couldn't set SCHED_RR policy for load balance"
> +				"monitor thread (error = %d) \n", ret);

the first SCHED_RR priority is 1, not 0 - so this call will always fail.

> +		lock_cpu_hotplug(); /* Prevent cpus going down or coming up */
> +		lock_doms_cur();    /* lockout changes to doms_cur[] array */

please put comments in front of the line like we do in most of sched.c.

> +		rcu_read_lock();  /* to walk rq->sd chain on various cpus and to
> +				   * walk task group list in rebalance_shares().
> +				   */

the proper comment format is in front of the line and in:

	/*
	 * Comment.
	 */

	Ingo
