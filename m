Return-Path: <linux-kernel-owner+w=401wt.eu-S932439AbZGRIam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbZGRIam (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 04:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZGRIaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 04:30:39 -0400
Received: from www.tglx.de ([62.245.132.106]:55947 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbZGRIai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 04:30:38 -0400
Date: Sat, 18 Jul 2009 10:30:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@tglx.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       nikolag@ca.ibm.com, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC][PATCH] Introduce CLOCK_REALTIME_COARSE
In-Reply-To: <1247873945.8334.67.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0907181027510.11571@localhost.localdomain>
References: <1247873945.8334.67.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009, john stultz wrote:
> +static int posix_get_realtime_coarse(clockid_t which_clock, struct timespec *tp)
> +{
> +	*tp = current_kernel_time();
> +	return 0;
> +}
> +
> +static int posix_get_monotonic_coarse(clockid_t which_clock,
> +						struct timespec *tp)
> +{
> +	*tp = get_monotonic_coarse();
> +	return 0;
> +}
> +
> +int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp)
> +{
> +	*tp = ktime_to_timespec(KTIME_LOW_RES);
> +	return 0;
> +}
>  /*
>   * Initialize everything, well, just everything in Posix clocks/timers ;)
>   */
> @@ -255,10 +274,24 @@ static __init int init_posix_timers(void)
>  		.clock_set = do_posix_clock_nosettime,
>  		.timer_create = no_timer_create,
>  	};
> +	struct k_clock clock_realtime_coarse = {
> +		.clock_getres = hrtimer_get_res,

  shouldn't that be posix_get_coarse_res ?

> +		.clock_get = posix_get_realtime_coarse,
> +		.clock_set = do_posix_clock_nosettime,
> +		.timer_create = no_timer_create,
> +	};
> +	struct k_clock clock_monotonic_coarse = {
> +		.clock_getres = hrtimer_get_res,

  ditto

> +		.clock_get = posix_get_monotonic_coarse,
> +		.clock_set = do_posix_clock_nosettime,
> +		.timer_create = no_timer_create,
> +	};

Looks good otherwise.

      tglx
