Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab0CFBJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 20:09:39 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:58301 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0CFBJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 20:09:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x5UQNrg327dr8ZdiS9zd/+mUiVJvVlKbPI4e7r/3zHN7eA3hcyckDT0rQSD82IOY/E
         BFY9c4GwOq9G46g+4JelK9XVOLvqAomqeOyEjhN5PtiSV16pDDgIGsqzRpQxxXCAPU/8
         tIhmFs+0zJBoF9BzC1SmS64PxEGSZpA+9ktX8=
Date: Sat, 6 Mar 2010 02:09:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ftrace - add notrace to sched_clock on various arm
	platforms
Message-ID: <20100306010929.GH5244@nowhere>
References: <4B91A1D1.2020208@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B91A1D1.2020208@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 04:29:05PM -0800, Tim Bird wrote:
> Add notrace attribute to sched_clock, and
> subsidiary clock routines, to avoid
> recursion within ftrace.
> 
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> ---
>  arch/arm/mach-mmp/time.c       |    2 +-
>  arch/arm/mach-pxa/time.c       |    2 +-
>  arch/arm/mach-realview/core.c  |    2 +-
>  arch/arm/mach-sa1100/generic.c |    2 +-
>  arch/arm/mach-versatile/core.c |    2 +-
>  arch/arm/plat-omap/common.c    |   14 +++++++-------
>  arch/arm/plat-omap/io.c        |    2 +-
>  7 files changed, 13 insertions(+), 13 deletions(-)
> 
> --- a/arch/arm/mach-mmp/time.c
> +++ b/arch/arm/mach-mmp/time.c
> @@ -72,7 +72,7 @@ static inline uint32_t timer_read(void)
>  	return __raw_readl(TIMERS_VIRT_BASE + TMR_CVWR(0));
>  }
> 
> -unsigned long long sched_clock(void)
> +unsigned long long notrace sched_clock(void)
>  {
>  	unsigned long long v = cnt32_to_63(timer_read());
>  	return (v * tcr2ns_scale) >> TCR2NS_SCALE_FACTOR;
> --- a/arch/arm/mach-pxa/time.c
> +++ b/arch/arm/mach-pxa/time.c
> @@ -51,7 +51,7 @@ static void __init set_oscr2ns_scale(uns
>  		oscr2ns_scale++;
>  }



sched_clock() already has notrace in its prototype in
sched.h

>  #ifdef CONFIG_ARCH_OMAP16XX
> -static cycle_t omap16xx_32k_read(struct clocksource *cs)
> +static cycle_t notrace omap16xx_32k_read(struct clocksource *cs)
>  {
>  	return omap_readl(OMAP16XX_TIMER_32K_SYNCHRONIZED);
>  }
> @@ -110,7 +110,7 @@ static cycle_t omap16xx_32k_read(struct
>  #endif



But for the things it calls yeah it's required.

Thanks.

