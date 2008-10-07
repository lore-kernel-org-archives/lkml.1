Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbYJGLQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbYJGLQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYJGLPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:15:50 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37646 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbYJGLPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:15:49 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Naohiro Ooiwa <nooiwa@miraclelinux.com>
Subject: Re: [PATCH] oom_kill: fix calculation of the cpu_time and the run_time
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <48EB3B44.3030202@miraclelinux.com>
References: <48EB3B44.3030202@miraclelinux.com>
Message-Id: <20081007201309.5A71.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue,  7 Oct 2008 20:15:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi all
> 
> The cpu-time is in tens of seconds
> and the run-time is in thousands of secounds.
> 
> but the source code doesn't follow it.

Have you seen any trouble?

> 
> I fixed it and also some white-spaces.
> Could you please check this patch.
> 
> 
> Signed-off-by: Naohiro Ooiwa <nooiwa@miraclelinux.com>
> ---
>  mm/oom_kill.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 64e5b4b..bddab74 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -100,14 +100,14 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
> 
>  	/*
>  	 * CPU time is in tens of seconds and run time is in thousands
> -         * of seconds. There is no particular reason for this other than
> -         * that it turned out to work very well in practice.
> +	 * of seconds. There is no particular reason for this other than
> +	 * that it turned out to work very well in practice.
>  	 */
> -	cpu_time = (cputime_to_jiffies(p->utime) + cputime_to_jiffies(p->stime))
> -		>> (SHIFT_HZ + 3);
> +	cpu_time = ((cputime_to_jiffies(p->utime) + cputime_to_jiffies(p->stime))
> +		>> SHIFT_HZ) / 10UL;
> 
>  	if (uptime >= p->start_time.tv_sec)
> -		run_time = (uptime - p->start_time.tv_sec) >> 10;
> +		run_time = (uptime - p->start_time.tv_sec) / 1000UL;
>  	else
>  		run_time = 0;

in some architecture, shift-op outperfom divide-op largely.
why do you need this change?



