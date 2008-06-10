Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbYFJRqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbYFJRqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYFJRpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:45:54 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:52083 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbYFJRpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:45:53 -0400
Date: Tue, 10 Jun 2008 21:47:50 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: prevent bound kthreads from changing cpus_allowed
Message-ID: <20080610174750.GA6064@tv-sign.ru>
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05, David Rientjes wrote:
>
> Kthreads that have called kthread_bind() are bound to specific cpus, so
> other tasks should not be able to change their cpus_allowed from under
> them.  Otherwise, it is possible to move kthreads, such as the migration
> or software watchdog threads, so they are not allowed access to the cpu
> they work on.

Imho, this is very good change, but...

> @@ -180,6 +180,7 @@ void kthread_bind(struct task_struct *k, unsigned int cpu)
>  	set_task_cpu(k, cpu);
>  	k->cpus_allowed = cpumask_of_cpu(cpu);
>  	k->rt.nr_cpus_allowed = 1;
> +	k->flags |= PF_THREAD_BOUND;

What if user-space moves this task right before "|= PF_THREAD_BOUND" ?

Oleg.

