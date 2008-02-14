Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbYBNPZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbYBNPZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbYBNPZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:25:30 -0500
Received: from mail29.messagelabs.com ([216.82.249.147]:22483 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754667AbYBNPZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:25:28 -0500
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-10.tower-29.messagelabs.com!1203002726!5980042!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Thu, 14 Feb 2008 16:25:22 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Raphael Assenat <raph@8d.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] call gpio_cansleep only after gpio_request succeeded
Message-ID: <20080214152522.GA20123@digi.com>
References: <1202999569-9022-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1202999569-9022-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 14 Feb 2008 15:25:23.0262 (UTC) FILETIME=[D1152DE0:01C86F1D]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15728.003
X-TM-AS-Result: No--16.299100-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Uwe Kleine-König wrote:
> diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
> index 6c0a9c4..76ddcf3 100644
> --- a/drivers/leds/leds-gpio.c
> +++ b/drivers/leds/leds-gpio.c
> @@ -79,6 +79,10 @@ static int gpio_led_probe(struct platform_device *pdev)
>  		cur_led = &pdata->leds[i];
>  		led_dat = &leds_data[i];
>  
> +		ret = gpio_request(led_dat->gpio, cur_led->name);

The line above must read:

		ret = gpio_request(led_dat->gpio, cur_led->name);

I managed to notice that the 2nd argument needs a change but I
overlooked the first somehow.

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
