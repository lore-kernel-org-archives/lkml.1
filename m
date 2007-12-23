Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbXLWSiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbXLWSiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 13:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbXLWSiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 13:38:11 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40805 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbXLWSiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 13:38:10 -0500
X-Greylist: delayed 1377 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Dec 2007 13:38:09 EST
Message-Id: <1198433711.31341.1228016275@webmail.messagingengine.com>
X-Sasl-Enc: ivNes5AjdVNVZg2KJtFUj88DQzClXOLYvQZbXSJqeq3d 1198433711
From: "Clemens Ladisch" <clemens@ladisch.de>
To: "Bernhard Walle" <bwalle@suse.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20071220144009.GA29859@suse.de>
Subject: Re: [PATCH] Fix RTC_AIE with CONFIG_HPET_EMULATE_RTC
In-Reply-To: <20071220144009.GA29859@suse.de>
Date: Sun, 23 Dec 2007 19:15:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle wrote:
> In the current code, RTC_AIE doesn't work if the RTC relies on
> CONFIG_HPET_EMULATE_RTC because the code sets the RTC_AIE flag
> in hpet_set_rtc_irq_bit(). The interrupt handles does accidentally
> check for RTC_PIE and not RTC_AIE when comparing the time
> which was set in hpet_set_alarm_time().
> 
> This patch is against 2.6.24-rc5-mm1.
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>

Acked-by: Clemens Ladisch <clemens@ladisch.de>

> ---
>  arch/x86/kernel/hpet.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -657,7 +657,7 @@ irqreturn_t hpet_rtc_interrupt(int irq, 
>  		hpet_pie_count = 0;
>  	}
>  
> -	if (hpet_rtc_flags & RTC_PIE &&
> +	if (hpet_rtc_flags & RTC_AIE &&
>  	    (curr_time.tm_sec == hpet_alarm_time.tm_sec) &&
>  	    (curr_time.tm_min == hpet_alarm_time.tm_min) &&
>  	    (curr_time.tm_hour == hpet_alarm_time.tm_hour))
