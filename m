Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbXKYX07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbXKYX07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 18:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbXKYX0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 18:26:52 -0500
Received: from mx38.mail.ru ([194.67.23.16]:64216 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbXKYX0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 18:26:52 -0500
Date: Mon, 26 Nov 2007 02:20:17 +0300
From: Anton Vorontsov <cbou@mail.ru>
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] power: use kasprintf
Message-ID: <20071125232017.GB19266@zarina>
Reply-To: cbou@mail.ru
References: <20071117105558.GA4861@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20071117105558.GA4861@APFDCB5C>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 07:55:58PM +0900, Akinobu Mita wrote:
> Use kasprintf instead of kmalloc()-strcpy()-strcat().

Applied to battery-2.6.git, thanks.

> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> 
> ---
>  drivers/power/power_supply_leds.c |   25 +++++++------------------
>  1 file changed, 7 insertions(+), 18 deletions(-)
> 
> Index: 2.6-mm/drivers/power/power_supply_leds.c
> ===================================================================
> --- 2.6-mm.orig/drivers/power/power_supply_leds.c
> +++ 2.6-mm/drivers/power/power_supply_leds.c
> @@ -10,6 +10,7 @@
>   *  You may use this code as per GPL version 2
>   */
>  
> +#include <linux/kernel.h>
>  #include <linux/power_supply.h>
>  
>  #include "power_supply.h"
> @@ -48,28 +49,20 @@ static int power_supply_create_bat_trigg
>  {
>  	int rc = 0;
>  
> -	psy->charging_full_trig_name = kmalloc(strlen(psy->name) +
> -				  sizeof("-charging-or-full"), GFP_KERNEL);
> +	psy->charging_full_trig_name = kasprintf(GFP_KERNEL,
> +					"%s-charging-or-full", psy->name);
>  	if (!psy->charging_full_trig_name)
>  		goto charging_full_failed;
>  
> -	psy->charging_trig_name = kmalloc(strlen(psy->name) +
> -					  sizeof("-charging"), GFP_KERNEL);
> +	psy->charging_trig_name = kasprintf(GFP_KERNEL,
> +					"%s-charging", psy->name);
>  	if (!psy->charging_trig_name)
>  		goto charging_failed;
>  
> -	psy->full_trig_name = kmalloc(strlen(psy->name) +
> -				      sizeof("-full"), GFP_KERNEL);
> +	psy->full_trig_name = kasprintf(GFP_KERNEL, "%s-full", psy->name);
>  	if (!psy->full_trig_name)
>  		goto full_failed;
>  
> -	strcpy(psy->charging_full_trig_name, psy->name);
> -	strcat(psy->charging_full_trig_name, "-charging-or-full");
> -	strcpy(psy->charging_trig_name, psy->name);
> -	strcat(psy->charging_trig_name, "-charging");
> -	strcpy(psy->full_trig_name, psy->name);
> -	strcat(psy->full_trig_name, "-full");
> -
>  	led_trigger_register_simple(psy->charging_full_trig_name,
>  				    &psy->charging_full_trig);
>  	led_trigger_register_simple(psy->charging_trig_name,
> @@ -120,14 +113,10 @@ static int power_supply_create_gen_trigg
>  {
>  	int rc = 0;
>  
> -	psy->online_trig_name = kmalloc(strlen(psy->name) + sizeof("-online"),
> -					GFP_KERNEL);
> +	psy->online_trig_name = kasprintf(GFP_KERNEL, "%s-online", psy->name);
>  	if (!psy->online_trig_name)
>  		goto online_failed;
>  
> -	strcpy(psy->online_trig_name, psy->name);
> -	strcat(psy->online_trig_name, "-online");
> -
>  	led_trigger_register_simple(psy->online_trig_name, &psy->online_trig);
>  
>  	goto success;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
