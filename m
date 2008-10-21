Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbYJUTBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbYJUTBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYJUTB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:01:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:47483 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYJUTBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:01:25 -0400
Subject: Re: sched: add CONFIG_SMP consistency
From: Peter Zijlstra <peterz@infradead.org>
To: henrik@austad.us
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Henrik Austad <henrik.austad@gmail.com>
In-Reply-To: <1224614719-14452-1-git-send-email-henrik@austad.us>
References: <1224614719-14452-1-git-send-email-henrik@austad.us>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Oct 2008 21:01:21 +0200
Message-Id: <1224615681.661.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 20:45 +0200, henrik@austad.us wrote:
> From: Henrik Austad <henrik.austad@gmail.com>
> 
> Do not declare select_task_rq as part of sched_class when CONFIG_SMP is
> not set.

While a proper cleanup, could you do it by re-arranging the methods so
as to not create an additional ifdef?

Thanks

> Signed-off-by: Henrik Austad <henrik.austad@gmail.com>
> ---
>  include/linux/sched.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index c226c7b..9e0e33c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -898,8 +898,9 @@ struct sched_class {
>  	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
>  	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
>  	void (*yield_task) (struct rq *rq);
> +#ifdef CONFIG_SMP
>  	int  (*select_task_rq)(struct task_struct *p, int sync);
> -
> +#endif
>  	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int sync);
>  
>  	struct task_struct * (*pick_next_task) (struct rq *rq);
