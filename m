Return-Path: <linux-kernel-owner+w=401wt.eu-S1751843AbYFSUMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbYFSUMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 16:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYFSUMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 16:12:38 -0400
Received: from in.cluded.net ([195.159.98.120]:33036 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbYFSUMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 16:12:37 -0400
Message-ID: <485ABD3A.9090704@uw.no>
Date: Thu, 19 Jun 2008 20:10:34 +0000
From: "Daniel K." <dk@uw.no>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20060307 SeaMonkey/1.5a
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 10/10] sched: rt: dont stop the period timer when there
 are tasks wanting to run
References: <20080619122218.971447669@chello.nl> <20080619123314.398446193@chello.nl>
In-Reply-To: <20080619123314.398446193@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> When a runnable group failed to get any runtime within a period it would be
> found idle and the period timer would be stopped.
> 
> So if the group ever gets throttled, it will never wake up again.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Reported-by: "Daniel K." <dk@uw.no>
Tested-by: Daniel K. <dk@uw.no>

I think this should go into .26 as well, due to the non-intuitiveness
of the knobs that cause this if they are fiddled with in the wrong way.


Daniel K.

> ---
>  kernel/sched_rt.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/sched_rt.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_rt.c
> +++ linux-2.6/kernel/sched_rt.c
> @@ -408,7 +408,8 @@ static int do_sched_rt_period_timer(stru
>  			if (rt_rq->rt_time || rt_rq->rt_nr_running)
>  				idle = 0;
>  			spin_unlock(&rt_rq->rt_runtime_lock);
> -		}
> +		} else if (rt_rq->rt_nr_running)
> +			idle = 0;
>  
>  		if (enqueue)
>  			sched_rt_rq_enqueue(rt_rq);
> 

