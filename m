Return-Path: <linux-kernel-owner+w=401wt.eu-S1757097AbZECXgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbZECXgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbZECXgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:36:08 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47487 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbZECXgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:36:07 -0400
Date: Sun, 3 May 2009 16:36:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] rcu_sched_grace_period: kill the bogus flush_signals()
Message-ID: <20090503233608.GG7141@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090503211118.GA22973@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503211118.GA22973@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 11:11:18PM +0200, Oleg Nesterov wrote:
> As a kernel thread, rcu_sched_grace_period() runs with all signals ignored.
> It can never receive a signal even if it sleeps in TASK_INTERRUPTIBLE, it
> needs the explicit allow_signal() to be visible for signals.

Good point!!!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> --- PTRACE/kernel/rcupreempt.c~	2009-04-09 00:39:10.000000000 +0200
> +++ PTRACE/kernel/rcupreempt.c	2009-05-03 02:17:11.000000000 +0200
> @@ -1356,17 +1356,11 @@ static int rcu_sched_grace_period(void *
> 
>  		rcu_ctrlblk.sched_sleep = rcu_sched_sleeping;
>  		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
> -		ret = 0;
> +		ret = 0; /* unused */
>  		__wait_event_interruptible(rcu_ctrlblk.sched_wq,
>  			rcu_ctrlblk.sched_sleep != rcu_sched_sleeping,
>  			ret);
> 
> -		/*
> -		 * Signals would prevent us from sleeping, and we cannot
> -		 * do much with them in any case.  So flush them.
> -		 */
> -		if (ret)
> -			flush_signals(current);
>  		couldsleepnext = 0;
> 
>  	} while (!kthread_should_stop());
> 
