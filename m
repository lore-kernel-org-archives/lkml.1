Return-Path: <linux-kernel-owner+w=401wt.eu-S934172AbXHYJ4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934172AbXHYJ4U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 05:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932735AbXHYJ4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 05:56:06 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:57064 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498AbXHYJ4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 05:56:04 -0400
Date: Sat, 25 Aug 2007 13:58:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Cliff Wickman <cpw@sgi.com>
Cc: akpm@linux-foundation.org, ego@in.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       pj@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-ID: <20070825095856.GB106@tv-sign.ru>
References: <20070824221806.GA3602@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824221806.GA3602@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, Cliff Wickman wrote:
> --- linus.070821.orig/kernel/cpuset.c
> +++ linus.070821/kernel/cpuset.c
> @@ -2333,6 +2333,25 @@ cpumask_t cpuset_cpus_allowed(struct tas
>  	return mask;
>  }
>  
> +/**
> + * cpuset_cpus_allowed_lock - return cpus_allowed mask from a tasks cpuset.
> + * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
> + *
> + * Description: Same as cpuset_cpus_allowed, but called with callback_mutex
> + * already held.
> + **/
> +
> +cpumask_t cpuset_cpus_allowed_lock(struct task_struct *tsk)
> +{
> +	cpumask_t mask;
> +
> +	task_lock(tsk);
> +	guarantee_online_cpus(tsk->cpuset, &mask);
> +	task_unlock(tsk);
> +
> +	return mask;
> +}

Very minor nit, perhaps it makes sense to use this function in cpuset_cpus_allowed()
to avoid the code duplication. Its name is a bit confusing, imho. How about
cpuset_cpus_allowed_locked() or __cpuset_cpus_allowed() ?

Oleg.

