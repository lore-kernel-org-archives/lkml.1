Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbZCCUCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbZCCUCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 15:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbZCCUCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 15:02:07 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:38699 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbZCCUCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 15:02:04 -0500
Subject: Re: [PATCH 6/6 v6] SGI RTC: add clocksource driver
From: john stultz <johnstul@us.ibm.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090303152206.GF20120@sgi.com>
References: <20090303151044.GA20016@sgi.com>
	 <20090303151357.GA20120@sgi.com> <20090303151524.GB20120@sgi.com>
	 <20090303151657.GC20120@sgi.com> <20090303151827.GD20120@sgi.com>
	 <20090303152016.GE20120@sgi.com>  <20090303152206.GF20120@sgi.com>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 12:01:32 -0800
Message-Id: <1236110492.6068.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 09:22 -0600, Dimitri Sivanich wrote:
> This patch provides a driver for SGI RTC clocks and timers.
> 
> This provides a high resolution clock and timer source using the SGI
> system-wide synchronized RTC clock/timer hardware.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> 
> ---
> 
> Implemented suggested changes and refreshed for latest -tip.
> 
>  drivers/clocksource/Makefile |    1 
>  drivers/clocksource/rtc_uv.c |  381 +++++++++++++++++++++++++++++++++++++++
>  drivers/misc/Kconfig         |    9 
>  3 files changed, 391 insertions(+)
[snip]
> +
> +static struct clocksource clocksource_uv = {
> +	.name		= RTC_NAME,
> +	.rating		= 400,
> +	.read		= uv_read_rtc,
> +	.mask		= (cycle_t)UVH_RTC_REAL_TIME_CLOCK_MASK,
> +	.shift		= 10,


What is the expected value for sn_rtc_cycles_per_second ? 

I ask because a shift value of 10 seems a bit low. It could very well be
appropriate, but I just wanted to check.

thanks
-john


