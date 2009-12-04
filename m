Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbZLDKpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbZLDKpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZLDKpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:45:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:42489 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbZLDKpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:45:17 -0500
Subject: Re: [PATCH 7/7] sched: implement try_to_wake_up_local()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <1259726212-30259-8-git-send-email-tj@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-8-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 11:44:47 +0100
Message-ID: <1259923487.3977.1940.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 12:56 +0900, Tejun Heo wrote:

> +++ b/kernel/sched.c
> @@ -2410,6 +2410,10 @@ static inline void ttwu_woken_up(struct task_struct *p, struct rq *rq,
>  		rq->idle_stamp = 0;
>  	}
>  #endif
> +	/*
> +	 * Wake up is complete, fire wake up notifier.  This allows
> +	 * try_to_wake_up_local() to be called from wake up notifiers.
> +	 */
>  	if (success)
>  		fire_sched_notifiers(p, wakeup);
>  }

> @@ -5437,6 +5488,11 @@ need_resched_nonpreemptible:
>  		if (unlikely(signal_pending_state(prev->state, prev))) {
>  			prev->state = TASK_RUNNING;
>  		} else {
> +			/*
> +			 * Fire sleep notifier before changing any scheduler
> +			 * state.  This allows try_to_wake_up_local() to be
> +			 * called from sleep notifiers.
> +			 */
>  			fire_sched_notifiers(prev, sleep);
>  			deactivate_task(rq, prev, 1);
>  		}

These two hunks seem to belong to patch 6

