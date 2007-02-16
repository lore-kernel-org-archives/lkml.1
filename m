Return-Path: <linux-kernel-owner+w=401wt.eu-S1422788AbXBPAKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422788AbXBPAKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422790AbXBPAKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:10:21 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:49513 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422788AbXBPAKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:10:20 -0500
Message-ID: <45D4F670.3020407@gmail.com>
Date: Fri, 16 Feb 2007 01:10:24 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 1/1] unify queue_delayed_work and queue_delayed_work_on
 fix
References: <25269175172137025681@wsc.cz>
In-Reply-To: <25269175172137025681@wsc.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby napsal(a):
[...]
> unify queue_delayed_work and queue_delayed_work_on fix

Oh sorry, the name should be
make queue_delayed_work() friendly to flush_fork() fix

> Since cwq->wq is unset for other than singlethread_cpu when singlethread
> workqueue was created, an oops occurs during bootup. Fix it by setting
> correct private value for workqueue.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> ---
> commit 7bc281be5811f9b1dd01c25eaf492f4765737fd0
> tree 7795008066bb89e7489384cde95e63260602d5af
> parent 61c2024a2dd044e32747542cfbf4b22251df3bc2
> author Jiri Slaby <jirislaby@gmail.com> Fri, 16 Feb 2007 00:49:15 +0100
> committer Jiri Slaby <jirislaby@gmail.com> Fri, 16 Feb 2007 00:49:15 +0100
> 
>  kernel/workqueue.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index f2089bf..af5e597 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -210,7 +210,8 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
>  
>  		/* This stores cwq for the moment, for the timer_fn */
>  		set_wq_data(work,
> -			per_cpu_ptr(wq->cpu_wq, raw_smp_processor_id()));
> +			per_cpu_ptr(wq->cpu_wq, wq->singlethread ?
> +				singlethread_cpu : raw_smp_processor_id()));
>  		timer->expires = jiffies + delay;
>  		timer->data = (unsigned long)dwork;
>  		timer->function = delayed_work_timer_fn;
> 

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
