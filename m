Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbXKZUaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbXKZUaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 15:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbXKZUaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 15:30:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34811 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbXKZUaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 15:30:11 -0500
Date: Mon, 26 Nov 2007 21:29:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       Dipankar <dipankar@in.ibm.com>
Subject: Re: [Patch 4/4] sched: Improve fairness of cpu bandwidth
	allocation for task groups
Message-ID: <20071126202939.GB17012@elte.hu>
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
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> +static inline void lock_doms_cur(void)
> +{
> +	mutex_lock(&doms_cur_mutex);
> +}
> +
> +static inline void unlock_doms_cur(void)
> +{
> +	mutex_unlock(&doms_cur_mutex);
> +}
> +
>  #else
>  
>  static inline void set_task_cfs_rq(struct task_struct *p, unsigned int cpu) { }
>  static inline void lock_task_group_list(void) { }
>  static inline void unlock_task_group_list(void) { }
> +static inline void lock_doms_cur(void) { }
> +static inline void unlock_doms_cur(void) { }
>  
>  #endif	/* CONFIG_FAIR_GROUP_SCHED */
>  
> @@ -6546,6 +6605,8 @@
>  {
>  	int i, j;
>  
> +	lock_doms_cur();
> +
>  	/* always unregister in case we don't destroy any domains */
>  	unregister_sched_domain_sysctl();
>  
> @@ -6586,6 +6647,8 @@
>  	ndoms_cur = ndoms_new;
>  
>  	register_sched_domain_sysctl();
> +
> +	unlock_doms_cur();
>  }

this API and locking should be introduced in a separate patch first, to 
reduce the size and impact of the 4/4 patch.

	Ingo
