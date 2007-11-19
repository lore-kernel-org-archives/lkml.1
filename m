Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbXKSNI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbXKSNI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 08:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbXKSNIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 08:08:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51147 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbXKSNIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 08:08:19 -0500
Date: Mon, 19 Nov 2007 14:08:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH 1/2] sched: Minor cleanups
Message-ID: <20071119130803.GA31491@elte.hu>
References: <20071119122713.GA28777@linux.vnet.ibm.com> <20071119122828.GB28777@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119122828.GB28777@linux.vnet.ibm.com>
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

> Minor scheduler cleanups:
> 
> - Fix coding style
> - remove obsolete comment
> - Use list_for_each_entry_rcu when walking task group list

>  #define for_each_leaf_cfs_rq(rq, cfs_rq) \
> -	list_for_each_entry(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
> +	list_for_each_entry_rcu(cfs_rq, &rq->leaf_cfs_rq_list, leaf_cfs_rq_list)
>  
>  /* Do the two (enqueued) entities belong to the same group ? */
>  static inline int
> @@ -1126,7 +1126,10 @@ static void print_cfs_stats(struct seq_f
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  	print_cfs_rq(m, cpu, &cpu_rq(cpu)->cfs);
>  #endif
> +
> +	rcu_read_lock();
>  	for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
>  		print_cfs_rq(m, cpu, cfs_rq);
> +	rcu_read_unlock();

hm, why is this a cleanup?

	Ingo
