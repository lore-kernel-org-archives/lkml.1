Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbYFRHsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbYFRHsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 03:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbYFRHs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 03:48:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:58090 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbYFRHs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 03:48:28 -0400
Subject: Re: NULL pointer dereference while setting sched_rt_period_us
From: Peter Zijlstra <peterz@infradead.org>
To: Dario Faggioli <raistlin@linux.it>
Cc: Michael Trimarchi <trimarchimichael@yahoo.it>, mingo@elte.hu,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1213773519.5371.8.camel@Palanthas.Krynn>
References: <1213773519.5371.8.camel@Palanthas.Krynn>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 09:48:31 +0200
Message-Id: <1213775311.16944.199.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-18 at 09:18 +0200, Dario Faggioli wrote:
> Hi all,

Thanks! I'll push it fwd with my other rt-group fixes

> We think the following patch solves the issue.
> 
> Hope this is of some help.
> 
> Regards,
> Dario Faggioli
> 
> Signed-off-by: Dario Faggioli <raistlin@linux.it>
> Signed-off-by: Michael Trimarchi <trimarchimichael@yahoo.it>
> ---
> diff --git a/kernel/sched.c b/kernel/sched.c
> index eaf6751..7205e25 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8348,7 +8348,7 @@ static unsigned long to_ratio(u64 period, u64
> runtime)
>  #ifdef CONFIG_CGROUP_SCHED
>  static int __rt_schedulable(struct task_group *tg, u64 period, u64
> runtime)
>  {
> -	struct task_group *tgi, *parent = tg->parent;
> +	struct task_group *tgi, *parent = tg ? tg->parent : NULL;
>  	unsigned long total = 0;
>  
>  	if (!parent) {
> 

