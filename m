Return-Path: <linux-kernel-owner+w=401wt.eu-S932365Ab0A2KL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab0A2KL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 05:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932338Ab0A2KL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 05:11:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:9858 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab0A2KLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 05:11:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=VosjKkGVvWO6/9qySnKoehSOqV0fLW5d/DkromOCl1R+qxLh1xEzwJsnP1uSmJNDWh
         nrKRJDnI6pvauf7pdNmbaK3ieddodOhpZGl0xOXgvgPXci/1WFKoH7/RXWZzY2wqdBqP
         XgGK2o3oXHLbDNXECqix9CTyE3fOHyWolawwI=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] power_supply: Clean up wm97xx_battery warnings
Date: Fri, 29 Jan 2010 11:11:11 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31-1-amd64; KDE/4.3.4; x86_64; ; )
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, linux-kernel@vger.kernel.org
References: <1264625135-4075-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1264625135-4075-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201001291111.11133.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne St 27. ledna 2010 21:45:35 Mark Brown napsal(a):
> Staticise work_lock (nothing outside the driver has any reason to
> see it) and specify dev when requesting the charger IRQ (since that's
> what we pass in when we free it).
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Hi, thanks.

Acked-by: Marek Vasut <marek.vasut@gmail.com>

> ---
>  drivers/power/wm97xx_battery.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/wm97xx_battery.c
>  b/drivers/power/wm97xx_battery.c index 6ea3cb5..23eed35 100644
> --- a/drivers/power/wm97xx_battery.c
> +++ b/drivers/power/wm97xx_battery.c
> @@ -26,7 +26,7 @@
> 
>  static DEFINE_MUTEX(bat_lock);
>  static struct work_struct bat_work;
> -struct mutex work_lock;
> +static struct mutex work_lock;
>  static int bat_status = POWER_SUPPLY_STATUS_UNKNOWN;
>  static struct wm97xx_batt_info *gpdata;
>  static enum power_supply_property *prop;
> @@ -203,7 +203,7 @@ static int __devinit wm97xx_bat_probe(struct
>  platform_device *dev) goto err2;
>  		ret = request_irq(gpio_to_irq(pdata->charge_gpio),
>  				wm97xx_chrg_irq, IRQF_DISABLED,
> -				"AC Detect", 0);
> +				"AC Detect", dev);
>  		if (ret)
>  			goto err2;
>  		props++;	/* POWER_SUPPLY_PROP_STATUS */
> 
