Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZBZWyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZBZWyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbZBZWx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:53:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792AbZBZWxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:53:55 -0500
Date: Thu, 26 Feb 2009 14:53:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/fork.c: define reset_task_cputimes()
Message-Id: <20090226145346.8a778d98.akpm@linux-foundation.org>
In-Reply-To: <1235625475-21218-1-git-send-email-gustavo@las.ic.unicamp.br>
References: <1235625475-21218-1-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009 02:17:55 -0300
"Gustavo F. Padovan" <gustavo@las.ic.unicamp.br> wrote:

> Group all vars that receive cputime_zero in the same static function.
> This also cleans the code.
> 
> Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
> ---
>  include/linux/sched.h |   11 +++++++++++
>  kernel/fork.c         |    8 +-------
>  2 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 8981e52..1a64587 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1595,6 +1595,17 @@ extern cputime_t task_utime(struct task_struct *p);
>  extern cputime_t task_stime(struct task_struct *p);
>  extern cputime_t task_gtime(struct task_struct *p);
>  
> +static inline void reset_task_cputimes(struct task_struct *t)
> +{
> +	t->utime = cputime_zero;
> +	t->stime = cputime_zero;
> +	t->gtime = cputime_zero;
> +	t->utimescaled = cputime_zero;
> +	t->stimescaled = cputime_zero;
> +	t->prev_utime = cputime_zero;
> +	t->prev_stime = cputime_zero;
> +}
> +
>  /*
>   * Per process flags
>   */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index a66fbde..9856abe 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1031,13 +1031,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	clear_tsk_thread_flag(p, TIF_SIGPENDING);
>  	init_sigpending(&p->pending);
>  
> -	p->utime = cputime_zero;
> -	p->stime = cputime_zero;
> -	p->gtime = cputime_zero;
> -	p->utimescaled = cputime_zero;
> -	p->stimescaled = cputime_zero;
> -	p->prev_utime = cputime_zero;
> -	p->prev_stime = cputime_zero;
> +	reset_task_cputimes(p);
>  
>  	p->default_timer_slack_ns = current->timer_slack_ns;
>  

I cannot see much point in doing this, unless you have some other patch
which adds a second caller of reset_task_cputimes()?


