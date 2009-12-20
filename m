Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbZLTWOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbZLTWOM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 17:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbZLTWOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 17:14:11 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45618 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbZLTWOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 17:14:06 -0500
Date: Sun, 20 Dec 2009 23:14:05 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sachin Sant <sachinp@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] sched: Fix hotplug
Message-ID: <20091220221405.GD4489@kernel.dk>
References: <4B2DF699.3090107@in.ibm.com> <1261315887.4314.8.camel@laptop> <20091220145151.GY4489@kernel.dk> <1261320896.4314.10.camel@laptop> <20091220145715.GZ4489@kernel.dk> <1261326987.4314.24.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261326987.4314.24.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20 2009, Peter Zijlstra wrote:
> The hot-unplug kstopmachine usage does a wakeup after deactivating the
> cpu, hence we cannot use cpu_active() here but must rely on the good
> olde online.

Yep, this works for me!

Tested-by: Jens Axboe <jens.axboe@oracle.com>

> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 720df10..0ac4fa5 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2348,7 +2348,7 @@ int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
>  	 *   not worry about this generic constraint ]
>  	 */
>  	if (unlikely(!cpumask_test_cpu(cpu, &p->cpus_allowed) ||
> -		     !cpu_active(cpu)))
> +		     !cpu_online(cpu)))
>  		cpu = select_fallback_rq(task_cpu(p), p);
>  
>  	return cpu;
> 
> 

-- 
Jens Axboe

