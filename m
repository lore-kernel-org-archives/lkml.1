Return-Path: <linux-kernel-owner+w=401wt.eu-S1760487AbXEJSr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760487AbXEJSr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbXEJSrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:47:22 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43273 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbXEJSrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:47:22 -0400
Subject: Re: [PATCH] Use boot based time for uptime in /proc
From: john stultz <johnstul@us.ibm.com>
To: Tomas Janousek <tjanouse@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tsmetana@redhat.com, riel@redhat.com,
       Albert Cahalan <acahalan@gmail.com>
In-Reply-To: <5189f7a1983d01ddaef747b594f39dadf655baba.1178816485.git.tomi@nomi.cz>
References: <3108b4e2c91097ec9469420b3f0836f0499068a6.1178816485.git.tomi@nomi.cz>
	 <5189f7a1983d01ddaef747b594f39dadf655baba.1178816485.git.tomi@nomi.cz>
Content-Type: text/plain
Date: Thu, 10 May 2007 11:47:09 -0700
Message-Id: <1178822829.6011.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 19:10 +0200, Tomas Janousek wrote:
> Commit 411187fb05cd11676b0979d9fbf3291db69dbce2 caused uptime not to increase
> during suspend. This may cause confusion so I restore the old behaviour by
> using the boot based time instead of monotonic for uptime.
> 
> Signed-off-by: Tomas Janousek <tjanouse@redhat.com>

Acked-by: John Stultz <johnstul@us.ibm.com>

> ---
>  fs/proc/proc_misc.c |    1 +
>  kernel/timer.c      |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
> index 0782d34..d84956c 100644
> --- a/fs/proc/proc_misc.c
> +++ b/fs/proc/proc_misc.c
> @@ -107,6 +107,7 @@ static int uptime_read_proc(char *page, char **start, off_t off,
>  	cputime_t idletime = cputime_add(init_task.utime, init_task.stime);
> 
>  	do_posix_clock_monotonic_gettime(&uptime);
> +	monotonic_to_bootbased(&uptime);
>  	cputime_to_timespec(idletime, &idle);
>  	len = sprintf(page,"%lu.%02lu %lu.%02lu\n",
>  			(unsigned long) uptime.tv_sec,
> diff --git a/kernel/timer.c b/kernel/timer.c
> index d5e1d6f..3a8ba7d 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1106,6 +1106,7 @@ int do_sysinfo(struct sysinfo *info)
>  		getnstimeofday(&tp);
>  		tp.tv_sec += wall_to_monotonic.tv_sec;
>  		tp.tv_nsec += wall_to_monotonic.tv_nsec;
> +		monotonic_to_bootbased(&tp);
>  		if (tp.tv_nsec - NSEC_PER_SEC >= 0) {
>  			tp.tv_nsec = tp.tv_nsec - NSEC_PER_SEC;
>  			tp.tv_sec++;
> -- 
> 1.5.1.4
> 
> 

