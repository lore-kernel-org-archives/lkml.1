Return-Path: <linux-kernel-owner+w=401wt.eu-S932993AbXCFIic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993AbXCFIic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 03:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbXCFIic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 03:38:32 -0500
Received: from smtp.ono.com ([62.42.230.12]:16262 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932993AbXCFIib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 03:38:31 -0500
Date: Tue, 6 Mar 2007 09:38:05 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: fix idle at tick
Message-ID: <20070306093805.6d8461ca@werewolf-wl>
In-Reply-To: <200703061841.08343.kernel@kolivas.org>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<200703061725.37365.kernel@kolivas.org>
	<20070305230240.9c2741d1.akpm@linux-foundation.org>
	<200703061841.08343.kernel@kolivas.org>
X-Mailer: Claws Mail 2.8.0cvs15 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007 18:41:08 +1100, Con Kolivas <kernel@kolivas.org> wrote:

> On Tuesday 06 March 2007 18:02, Andrew Morton wrote:
> > On Tue, 6 Mar 2007 17:25:36 +1100 Con Kolivas <kernel@kolivas.org> wrote:
> > > Signed-off-by: Con Kolivas <kernel@kolivas.org>
> > > ---
> > >  kernel/sched.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > Index: linux-2.6.21-rc2-mm1-base/kernel/sched.c
> > > ===================================================================
> > > --- linux-2.6.21-rc2-mm1-base.orig/kernel/sched.c	2007-03-06
> > > 17:19:17.000000000 +1100 +++
> > > linux-2.6.21-rc2-mm1-base/kernel/sched.c	2007-03-06 17:20:40.000000000
> > > +1100 @@ -3444,7 +3444,7 @@ void scheduler_tick(void)
> > >
> > >  	update_cpu_clock(p, rq, now);
> > >
> > > -	if (idle_at_tick)
> > > +	if (!idle_at_tick)
> > >  		task_running_tick(rq, p);
> > >  #ifdef CONFIG_SMP
> > >  	update_load(rq);
> >
> > Looks right, thanks.  The original patch had
> >
> > -	if (p == rq->idle)
> > +	if (idle_at_tick)
> >  		/* Task on the idle queue */
> >  		wake_priority_sleeper(rq);
> >  	else
> >  		task_running_tick(rq, p);
> >
> > but it got damaged by smt-nice removal.
> 
> I gathered something like that happened. If it wasn't clear this change caused 
> massive scheduler damage with no cpu accounting whatsoever occurring. I 
> recommend putting it in your hotfixes/ dir if you're not planning an -mm2 
> soon.
> 

Good! I can confirm this makes things going smoothly again....

(apart from the speed of the x11 nv driver at 1600x1200 ;) ).

hot-fixes candidate.

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam01 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #2 SMP PREEMPT
