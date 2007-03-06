Return-Path: <linux-kernel-owner+w=401wt.eu-S933979AbXCFHl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933979AbXCFHl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 02:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933980AbXCFHl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 02:41:27 -0500
Received: from mail19.syd.optusnet.com.au ([211.29.132.200]:42750 "EHLO
	mail19.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933979AbXCFHl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 02:41:26 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: fix idle at tick
Date: Tue, 6 Mar 2007 18:41:08 +1100
User-Agent: KMail/1.9.5
Cc: "J.A. =?iso-8859-1?q?Magall=F3n?=" <jamagallon@ono.com>,
       linux-kernel@vger.kernel.org
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <200703061725.37365.kernel@kolivas.org> <20070305230240.9c2741d1.akpm@linux-foundation.org>
In-Reply-To: <20070305230240.9c2741d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703061841.08343.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2007 18:02, Andrew Morton wrote:
> On Tue, 6 Mar 2007 17:25:36 +1100 Con Kolivas <kernel@kolivas.org> wrote:
> > Signed-off-by: Con Kolivas <kernel@kolivas.org>
> > ---
> >  kernel/sched.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Index: linux-2.6.21-rc2-mm1-base/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.21-rc2-mm1-base.orig/kernel/sched.c	2007-03-06
> > 17:19:17.000000000 +1100 +++
> > linux-2.6.21-rc2-mm1-base/kernel/sched.c	2007-03-06 17:20:40.000000000
> > +1100 @@ -3444,7 +3444,7 @@ void scheduler_tick(void)
> >
> >  	update_cpu_clock(p, rq, now);
> >
> > -	if (idle_at_tick)
> > +	if (!idle_at_tick)
> >  		task_running_tick(rq, p);
> >  #ifdef CONFIG_SMP
> >  	update_load(rq);
>
> Looks right, thanks.  The original patch had
>
> -	if (p == rq->idle)
> +	if (idle_at_tick)
>  		/* Task on the idle queue */
>  		wake_priority_sleeper(rq);
>  	else
>  		task_running_tick(rq, p);
>
> but it got damaged by smt-nice removal.

I gathered something like that happened. If it wasn't clear this change caused 
massive scheduler damage with no cpu accounting whatsoever occurring. I 
recommend putting it in your hotfixes/ dir if you're not planning an -mm2 
soon.

-- 
-ck
