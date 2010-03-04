Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab0CDRcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:32:32 -0500
Received: from claw.goop.org ([74.207.240.146]:57322 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab0CDRca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:32:30 -0500
Message-ID: <4B8FEEAC.9070105@goop.org>
Date: Thu, 04 Mar 2010 09:32:28 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] time: Cleanup direct xtime usage in xen
References: <1267672280-21386-1-git-send-email-johnstul@us.ibm.com> <1267672280-21386-2-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1267672280-21386-2-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 07:11 PM, John Stultz wrote:
> Not critical, 2.6.35 material.
>
> Cleanup xen's direct use of internal timekeeping values.
>
> Cc: Jeremy Fitzhardinge<jeremy@xensource.com>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> Cc: Andrew Morton<akpm@linux-foundation.org>
> Signed-off-by: John Stultz<johnstul@us.ibm.com>
>    
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

> ---
>   arch/x86/xen/time.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index 0d3f07c..6365df9 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -475,6 +475,7 @@ void xen_timer_resume(void)
>   __init void xen_time_init(void)
>   {
>   	int cpu = smp_processor_id();
> +	struct timespec tp;
>
>   	clocksource_register(&xen_clocksource);
>
> @@ -486,9 +487,8 @@ __init void xen_time_init(void)
>   	}
>
>   	/* Set initial system time with full resolution */
> -	xen_read_wallclock(&xtime);
> -	set_normalized_timespec(&wall_to_monotonic,
> -				-xtime.tv_sec, -xtime.tv_nsec);
> +	xen_read_wallclock(&tp);
> +	do_settimeofday(&tp);
>
>   	setup_force_cpu_cap(X86_FEATURE_TSC);
>
>    

