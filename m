Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYJ3Mtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYJ3Mtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 08:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbYJ3Mtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 08:49:41 -0400
Received: from oceanus.site5.com ([67.43.13.2]:38809 "EHLO oceanus.site5.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbYJ3Mtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 08:49:41 -0400
X-Greylist: delayed 3345 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2008 08:49:41 EDT
Message-ID: <4909A04D.2090404@compulab.co.il>
Date: Thu, 30 Oct 2008 13:53:49 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
CC: eric miao <eric.y.miao@gmail.com>, rpurdie@rpsys.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [LED bug fix] leds-da903x (da9030 only) led brightness reversed.
References: <490994DC.7040409@gmail.com>
In-Reply-To: <490994DC.7040409@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - oceanus.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jonathan Cameron wrote:
> The brightness control register calculation (for the pwm) is
> effectively the reverse of what would be expected.
> 1 is maximum brightness, 255 minimum.
> 
> This patch inverts this.
> 
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

Acked-by: Mike Rapoport <mike@compulab.co.il>

> ---
> diff --git a/drivers/leds/leds-da903x.c b/drivers/leds/leds-da903x.c
> index f1fddb1..ab632e9 100644
> --- a/drivers/leds/leds-da903x.c
> +++ b/drivers/leds/leds-da903x.c
> @@ -57,7 +57,7 @@ static void da903x_led_work(struct work_struct *work)
>  		offset = DA9030_LED_OFFSET(led->id);
>  		val = led->flags & ~0x87;
>  		val |= (led->new_brightness) ? 0x80 : 0; /* EN bit */
> -		val |= (led->new_brightness >> 5) & 0x7; /* PWM<2:0> */
> +		val |= (0x7 - (led->new_brightness >> 5)) & 0x7; /* PWM<2:0> */
>  		da903x_write(led->master, DA9030_LED1_CONTROL + offset, val);
>  		break;
>  	case DA9030_ID_VIBRA:
> 

-- 
Sincerely yours,
Mike.

