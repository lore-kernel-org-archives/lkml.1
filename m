Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbZEAXh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbZEAXh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 19:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZEAXhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 19:37:50 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:39316 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbZEAXht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 19:37:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DjLXB+YxZbU2JXOmNKfmuytWzFoq/WSJkpC9G7U44t+x9iDjRM5vKTYnCXjTp0ud4B
         vJsfbX0aBFQZiWNYlI4TBN6Gd+EzQrho1jmVlK0ggIgr9YEa4DtC5UAaQIjzwNK5W8mM
         ey7GQvouYVsr9/W1xW0AKKFc5fNRBW1L3UZoc=
Date: Sat, 2 May 2009 01:37:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 1/2]  ftrace: add notrace to ARM sched_clock routines
Message-ID: <20090501233744.GF6404@nowhere>
References: <49FB77ED.3010800@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FB77ED.3010800@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 03:30:05PM -0700, Tim Bird wrote:
> Add notrace attribute to sched_clock, to avoid
> recursion with ftrace function_graph tracing.
> 
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> ---
>  arch/arm/mach-mmp/time.c       |    2 +-
>  arch/arm/mach-pxa/time.c       |    2 +-
>  arch/arm/mach-realview/core.c  |    2 +-
>  arch/arm/mach-sa1100/generic.c |    2 +-
>  arch/arm/mach-versatile/core.c |    2 +-
>  arch/arm/plat-omap/common.c    |    4 ++--
>  6 files changed, 7 insertions(+), 7 deletions(-)
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
> 
> -unsigned long long sched_clock(void)
> +unsigned long long notrace sched_clock(void)
>  {
>  	unsigned long long v = cnt32_to_63(OSCR);
>  	return (v * oscr2ns_scale) >> OSCR2NS_SCALE_FACTOR;
> --- a/arch/arm/mach-realview/core.c
> +++ b/arch/arm/mach-realview/core.c
> @@ -60,7 +60,7 @@ void __iomem *gic_cpu_base_addr;
>   * This is the RealView sched_clock implementation.  This has
>   * a resolution of 41.7ns, and a maximum value of about 179s.
>   */
> -unsigned long long sched_clock(void)
> +unsigned long long notrace sched_clock(void)
>  {
>  	unsigned long long v;
> 
> --- a/arch/arm/mach-sa1100/generic.c
> +++ b/arch/arm/mach-sa1100/generic.c
> @@ -131,7 +131,7 @@ EXPORT_SYMBOL(cpufreq_get);
>   *
>   *  ( * 1E9 / 3686400 => * 78125 / 288)
>   */
> -unsigned long long sched_clock(void)
> +unsigned long long notrace sched_clock(void)
>  {
>  	unsigned long long v = cnt32_to_63(OSCR);
> 
> --- a/arch/arm/mach-versatile/core.c
> +++ b/arch/arm/mach-versatile/core.c
> @@ -237,7 +237,7 @@ void __init versatile_map_io(void)
>   * long as there is always less than 89 seconds between successive
>   * calls to this function.
>   */
> -unsigned long long sched_clock(void)
> +unsigned long long notrace sched_clock(void)
>  {
>  	unsigned long long v = cnt32_to_63(readl(VERSATILE_REFCOUNTER));
> 
> --- a/arch/arm/plat-omap/common.c
> +++ b/arch/arm/plat-omap/common.c
> @@ -185,7 +185,7 @@ console_initcall(omap_add_serial_console
> 
>  #include <linux/clocksource.h>
> 
> -static cycle_t omap_32k_read(struct clocksource *cs)
> +static cycle_t notrace omap_32k_read(struct clocksource *cs)
>  {
>  	return omap_readl(TIMER_32K_SYNCHRONIZED);
>  }
> @@ -203,7 +203,7 @@ static struct clocksource clocksource_32
>   * Returns current time from boot in nsecs. It's OK for this to wrap
>   * around for now, as it's just a relative time stamp.
>   */
> -unsigned long long sched_clock(void)
> +unsigned long long notrace sched_clock(void)
>  {
>  	unsigned long long ret;


I've looked into all of these functions and they don't seem to call
anything that could be traced. I could have missed something though
but it looks good.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

