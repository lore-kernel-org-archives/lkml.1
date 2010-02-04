Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab0BDCCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 21:02:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58644 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755556Ab0BDCCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 21:02:52 -0500
Message-ID: <4B6A2A51.7050408@cn.fujitsu.com>
Date: Thu, 04 Feb 2010 10:00:49 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
CC: linux-kernel@vger.kernel.org, oleg@redhat.com, rusty@rustcorp.com.au,
       tj@kernel.org, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] core: workqueue: BUG_ON on workqueue recursion
References: <20100203122755.0fd4fb7e@marrow.netinsight.se>
In-Reply-To: <20100203122755.0fd4fb7e@marrow.netinsight.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Kagstrom wrote:
> When the workqueue is flushed from workqueue context (recursively), the
> system enters a strange state where things at random (dependent on the
> global workqueue) start misbehaving. For example, for us the console and
> logins locks up while the web server continues running.
> 
> Since the system becomes unstable, change this to a BUG_ON instead.

For design view, we should disallow this recursion when using workqueue.

I like BUG_ON. But it is not a fatal end usually when it happens,
most developers would like to let system go on.

Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>

> 
> Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
> ---
>  kernel/workqueue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index dee4865..e617d29 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -482,7 +482,7 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
>  	int active = 0;
>  	struct wq_barrier barr;
>  
> -	WARN_ON(cwq->thread == current);
> +	BUG_ON(cwq->thread == current);
>  
>  	spin_lock_irq(&cwq->lock);
>  	if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {

