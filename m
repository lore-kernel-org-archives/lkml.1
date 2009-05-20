Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbZETHkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbZETHkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbZETHk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:40:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42507 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345AbZETHk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:40:26 -0400
Date: Wed, 20 May 2009 09:40:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Langsdorf <mark.langsdorf@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Joerg Roedel <joerg.roedel@amd.com>, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][KVM][retry 3] Add support for Pause Filtering to AMD
	SVM
Message-ID: <20090520074014.GB14846@elte.hu>
References: <200905050909.58583.mark.langsdorf@amd.com> <200905071000.14038.mark.langsdorf@amd.com> <200905081203.55484.mark.langsdorf@amd.com> <200905191356.37071.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905191356.37071.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index b4c38bc..683bc65 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2283,6 +2283,9 @@ static inline unsigned int task_cpu(const struct task_struct *p)
>  	return task_thread_info(p)->cpu;
>  }
>  
> +extern void set_task_delay(struct task_struct *p, unsigned int delay);

> +++ b/kernel/sched.c
> @@ -1947,6 +1947,11 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
>  	return delta < (s64)sysctl_sched_migration_cost;
>  }
>  
> +void set_task_delay(struct task_struct *p, unsigned int delay)
> +{
> +	p->se.vruntime += delay;
> +}
> +EXPORT_SYMBOL(set_task_delay);

vruntime is nice level scaled, so this is broken. Please run this 
through the scheduler folks, we can get a facility into an isolated 
brach for Avi to pull, but it needs some thought.

	Ingo
