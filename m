Return-Path: <linux-kernel-owner+w=401wt.eu-S936554AbZDIUSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936554AbZDIUSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936607AbZDIUSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:18:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936617AbZDIUS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:18:29 -0400
Date: Thu, 9 Apr 2009 13:15:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: david-b@pacbell.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix RTC-CMOS message, now with SOB
Message-Id: <20090409131556.07c8eed9.akpm@linux-foundation.org>
In-Reply-To: <m3bprcusdw.fsf@intrepid.localdomain>
References: <m3vdpnvvzt.fsf@intrepid.localdomain>
	<m3r60bvvrg.fsf@intrepid.localdomain>
	<200904041102.07751.david-b@pacbell.net>
	<m3bprcusdw.fsf@intrepid.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Apr 2009 21:32:27 +0200
Krzysztof Halasa <khc@pm.waw.pl> wrote:

> +		        (cmos_rtc.mon_alrm ? "alarms up to one year" :
> +		                cmos_rtc.day_alrm ? "alarms up to one month" :
> +		                        "alarms up to one day") :
> +		        "no alarms";
> 
> Feel free to use the following or your own version as long as the
> resulting message is correct.
> Thanks.
> 
> Signed-off-by: Krzysztof Ha__asa <khc@pm.waw.pl>

Please resend the full changelog (possibly with updates) with each
updated version of a patch.

> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -794,17 +794,15 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
>  		goto cleanup2;
>  	}
>  
> -	pr_info("%s: alarms up to one %s%s, %zd bytes nvram%s\n",
> -			cmos_rtc.rtc->dev.bus_id,
> -			is_valid_irq(rtc_irq)
> -				?  (cmos_rtc.mon_alrm
> -					? "year"
> -					: (cmos_rtc.day_alrm
> -						? "month" : "day"))
> -				: "no",
> -			cmos_rtc.century ? ", y3k" : "",
> -			nvram.size,
> -			is_hpet_enabled() ? ", hpet irqs" : "");
> +	pr_info("%s: %s%s, %zd bytes nvram%s\n",
> +		cmos_rtc.rtc->dev.bus_id,
> +		!is_valid_irq(rtc_irq) ? "no alarms" :
> +			cmos_rtc.mon_alrm ? "alarms up to one year" :
> +			cmos_rtc.day_alrm ? "alarms up to one month" :
> +			"alarms up to one day",
> +		cmos_rtc.century ? ", y3k" : "",
> +		nvram.size,
> +		is_hpet_enabled() ? ", hpet irqs" : "");
>  
>  	return 0;

The patch doesn't apply to current kernels (the driver core guys have
been running rampant again, methinks).  Please redo, retest, resend?

Thanks.

