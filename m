Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbZBYSl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbZBYSl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 13:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbZBYSlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 13:41:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54881 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbZBYSlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 13:41:50 -0500
Subject: Re: [PATCH RESEND] sched_rt: don't start timer when rt bandwidth
 disabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <49A586FE.8070604@ct.jp.nec.com>
References: <49A586FE.8070604@ct.jp.nec.com>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 19:41:41 +0100
Message-Id: <1235587301.4645.3786.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right, thanks for the reminder.

On Wed, 2009-02-25 at 09:59 -0800, Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Impact: fix incorrect condition check
> 
> No need to start rt bandwidth timer when rt bandwidth is disabled.
> If this timer starts, it may stop at sched_rt_period_timer() on the first time.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Yep, looks like a good catch, thanks!

> ---
>  kernel/sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 4484f9c..9e49ac8 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -223,7 +223,7 @@ static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
>  {
>  	ktime_t now;
>  
> -	if (rt_bandwidth_enabled() && rt_b->rt_runtime == RUNTIME_INF)
> +	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
>  		return;
>  
>  	if (hrtimer_active(&rt_b->rt_period_timer))

