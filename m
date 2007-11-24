Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbXKXIsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbXKXIsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 03:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbXKXIsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 03:48:10 -0500
Received: from smtp.mermit.fi ([194.100.131.6]:44659 "EHLO smtp.mermit.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbXKXIsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 03:48:09 -0500
X-Greylist: delayed 1721 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Nov 2007 03:48:09 EST
X-Spam-Flag: NO
X-Spam-Score: -0.804
Message-ID: <4747DE84.8040302@kolumbus.fi>
Date: Sat, 24 Nov 2007 10:19:16 +0200
From: =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] wait_task_stopped: remove unneeded delay_group_leader
 check
References: <20071123195941.GA163@tv-sign.ru>
In-Reply-To: <20071123195941.GA163@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> wait_task_stopped() doesn't need the "delay_group_leader" parameter. If the
> child is not traced it must be a group leader. With or without subthreads
>   
What do you mean "has to be a group leader"? It could be a stopped thread.

> ->group_stop_count == 0 when the whole task is stopped.
>
>   
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
>
> --- PT/kernel/exit.c~5_ck_group_stop	2007-11-22 19:08:43.000000000 +0300
> +++ PT/kernel/exit.c	2007-11-23 20:31:21.000000000 +0300
> @@ -1348,7 +1348,7 @@ static int wait_task_zombie(struct task_
>   * the lock and this task is uninteresting.  If we return nonzero, we have
>   * released the lock and the system call should return.
>   */
> -static int wait_task_stopped(struct task_struct *p, int delayed_group_leader,
> +static int wait_task_stopped(struct task_struct *p,
>  			     int noreap, struct siginfo __user *infop,
>  			     int __user *stat_addr, struct rusage __user *ru)
>  {
> @@ -1362,8 +1362,7 @@ static int wait_task_stopped(struct task
>  	if (unlikely(!is_task_stopped_or_traced(p)))
>  		goto unlock_sig;
>  
> -	if (delayed_group_leader && !(p->ptrace & PT_PTRACED) &&
> -	    p->signal->group_stop_count > 0)
> +	if (!(p->ptrace & PT_PTRACED) && p->signal->group_stop_count > 0)
>  		/*
>  		 * A group stop is in progress and this is the group leader.
>  		 * We won't report until all threads have stopped.
> @@ -1519,7 +1518,7 @@ repeat:
>  				    !(options & WUNTRACED))
>  					continue;
>  
> -				retval = wait_task_stopped(p, ret == 2,
> +				retval = wait_task_stopped(p,
>  						(options & WNOWAIT), infop,
>  						stat_addr, ru);
>  			} else if (p->exit_state == EXIT_ZOMBIE) {
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   

