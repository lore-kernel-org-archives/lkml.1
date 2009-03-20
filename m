Return-Path: <linux-kernel-owner+w=401wt.eu-S1759445AbZCTLnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445AbZCTLnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 07:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757515AbZCTLnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 07:43:24 -0400
Received: from www.tglx.de ([62.245.132.106]:50388 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349AbZCTLnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 07:43:24 -0400
Date: Fri, 20 Mar 2009 12:41:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Simek <monstr@monstr.eu>
cc: LKML <linux-kernel@vger.kernel.org>, john.williams@petalogix.com,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 08/57] microblaze_v7: Interrupt handling, timer support,
 selfmod code
In-Reply-To: <49C37DF1.30806@monstr.eu>
Message-ID: <alpine.LFD.2.00.0903201233460.29264@localhost.localdomain>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu> <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu> <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu> <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu> <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu> <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain> <49C2AB09.9040300@monstr.eu> <alpine.LFD.2.00.0903192219500.29264@localhost.localdomain> <49C36149.9000703@monstr.eu>
 <alpine.LFD.2.00.0903201052340.29264@localhost.localdomain> <49C371F5.5010100@monstr.eu> <alpine.LFD.2.00.0903201142300.29264@localhost.localdomain> <49C37DF1.30806@monstr.eu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Michal Simek wrote:
> > 2) a clock event device which has CLOCK_EVT_FEAT_PERIODIC flag set.
> 
> You meant ONESHOT feature, right?

Sure :)
 
> # cat /proc/timer_list
> Timer List Version: v0.4
> HRTIMER_MAX_CLOCK_BASES: 2
> now at 17205889582 nsecs
> 
> cpu: 0
>  clock 0:
>   .base:       9027a4d0
>   .index:      0
>   .resolution: 1 nsecs
>   .get_time:   ktime_get_real
>   .offset:     0 nsecs
> active timers:
>  clock 1:
>   .base:       9027a4fc
>   .index:      1
>   .resolution: 1 nsecs
>   .get_time:   ktime_get
>   .offset:     0 nsecs
> active timers:
>  #0: per_cpu__tick_cpu_sched, tick_sched_timer, S:01, <800005a6>, swapper/1
>  # expires at 17210000000-17210000000 nsecs [in 4110418 to 4110418 nsecs]
>  #1: <9f2d3a48>, hrtimer_wakeup, S:01, <9f2d3a48>, inetd/54
>  # expires at 17430563969-17431563926 nsecs [in 224674387 to 225674344 nsecs]
>  #2: <9e127a48>, hrtimer_wakeup, S:01, <9e127a48>, thttpd/50
>  # expires at 129748538823-129848538823 nsecs [in 112542649241 to 112642649241
> nsecs]
>   .expires_next   : 17210000000 nsecs
>   .hres_active    : 1

Looks good. Now you can enable CONFIG_NOHZ as well. :) That needs just
the following extras in your idle loop:

-->             tick_nohz_stop_sched_tick(1);
	        while (!need_resched())
		        idle();
-->	        tick_nohz_restart_sched_tick();

Thanks,

	tglx
