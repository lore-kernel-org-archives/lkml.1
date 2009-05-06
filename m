Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbZEFIpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbZEFIpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbZEFIp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:45:27 -0400
Received: from www.tglx.de ([62.245.132.106]:48180 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbZEFIp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:45:26 -0400
Date: Wed, 6 May 2009 10:44:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frank Rowand <frank.rowand@am.sony.com>
cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] RT: calc_load() uses wrong variable to calculate RT
 load
In-Reply-To: <4A00D16A.3000908@am.sony.com>
Message-ID: <alpine.LFD.2.00.0905061044170.3388@localhost.localdomain>
References: <4A00D16A.3000908@am.sony.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009, Frank Rowand wrote:

> In calc_load() use RT tasks to calculate the RT load.
> 
> Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
> 
> ---
> 
> Ingo,
> 
> In calc_load():
> 
> #ifdef CONFIG_PREEMPT_RT
>                 active_rt_tasks = count_active_rt_tasks();
> #endif
> 
> but active_rt_tasks is then not used.  I have not read through enough code
> to verify my supposition, but the obvious use of this variable would be for
> the calculation of the RT load average.
> 
> If my supposition is correct, this patch fixes the problem.

Yep, that's correct. Though I ponder to get rid of avenrun_rt all
together.

Thanks,

	tglx

> The patch is compile tested only.
> 
> -Frank Rowand
> Sony Corporation of America
> 
> 
> Index: linux-2.6.29.2/kernel/timer.c
> ===================================================================
> --- linux-2.6.29.2.orig/kernel/timer.c
> +++ linux-2.6.29.2/kernel/timer.c
> @@ -1249,9 +1249,9 @@ static inline void calc_load(unsigned lo
>  			CALC_LOAD(avenrun[1], EXP_5, active_tasks);
>  			CALC_LOAD(avenrun[2], EXP_15, active_tasks);
>  #ifdef CONFIG_PREEMPT_RT
> -			CALC_LOAD(avenrun_rt[0], EXP_1, active_tasks);
> -			CALC_LOAD(avenrun_rt[1], EXP_5, active_tasks);
> -			CALC_LOAD(avenrun_rt[2], EXP_15, active_tasks);
> +			CALC_LOAD(avenrun_rt[0], EXP_1, active_rt_tasks);
> +			CALC_LOAD(avenrun_rt[1], EXP_5, active_rt_tasks);
> +			CALC_LOAD(avenrun_rt[2], EXP_15, active_rt_tasks);
>  #endif
>  			count += LOAD_FREQ;
>  
> 
