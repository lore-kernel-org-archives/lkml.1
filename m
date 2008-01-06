Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbYAFOWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbYAFOWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYAFOWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:22:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:57904 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbYAFOW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:22:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ode0sJ8wnt8L7uXLxzRwO4damZvYzQsZFiJ+7/5HmIodNh8QSa0weuq8eE8OasIHWLxY3S2ci1v0SlXqFuj1Y6gUZsP3kABOd2lLr/rb3IPmU6siFIBzWf+NA8k7Xzinx+X/u+JL+l5DPr9RKeKesq7OKNmdg2HC8TWwXYmGEpk=
Date: Sun, 6 Jan 2008 17:09:03 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Subject: Re: [PATCH 1/3] power_supply: add few more values and props
Message-ID: <20080106140903.GA23333@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080106122659.GA13106@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080106122659.GA13106@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 03:27:18PM +0300, Dmitry Baryshkov wrote:
> Add LiMn (one of the most common for small non-rechargable batteries)i
> battery technology and voltage_min/_max properties support.
> 
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>

Much thanks, all patches look good to me. Few questions about
this one though.

> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> index 249f61b..45d2f95 100644
> --- a/drivers/power/power_supply_sysfs.c
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -46,7 +46,8 @@ static ssize_t power_supply_show_property(struct device *dev,
>  		"Unspecified failure"
>  	};
>  	static char *technology_text[] = {
> -		"Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe", "NiCd"
> +		"Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe", "NiCd",
> +		"LiMn"
>  	};
>  	static char *capacity_level_text[] = {
>  		"Unknown", "Critical", "Low", "Normal", "High", "Full"
> @@ -88,6 +89,8 @@ static struct device_attribute power_supply_attrs[] = {
>  	POWER_SUPPLY_ATTR(present),
>  	POWER_SUPPLY_ATTR(online),
>  	POWER_SUPPLY_ATTR(technology),
> +	POWER_SUPPLY_ATTR(voltage_max),
> +	POWER_SUPPLY_ATTR(voltage_min),

I'd suggest keep Documentation/power_supply_class.txt in sync
wrt new properties, to distinct their meanings and usage.

I assume you're using these new properties for non-rechargeable
LiMn batteries. So, why new properties, aren't voltage_*_design
ones suits that purpose? If battery is non-rechargeable it is
having only design values, no?

>  	POWER_SUPPLY_ATTR(voltage_max_design),
>  	POWER_SUPPLY_ATTR(voltage_min_design),
>  	POWER_SUPPLY_ATTR(voltage_now),
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index 606c095..cdbc5b8 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -54,6 +54,7 @@ enum {
>  	POWER_SUPPLY_TECHNOLOGY_LIPO,
>  	POWER_SUPPLY_TECHNOLOGY_LiFe,
>  	POWER_SUPPLY_TECHNOLOGY_NiCd,
> +	POWER_SUPPLY_TECHNOLOGY_LiMn,
>  };
>  
>  enum {
> @@ -72,6 +73,8 @@ enum power_supply_property {
>  	POWER_SUPPLY_PROP_PRESENT,
>  	POWER_SUPPLY_PROP_ONLINE,
>  	POWER_SUPPLY_PROP_TECHNOLOGY,
> +	POWER_SUPPLY_PROP_VOLTAGE_MAX,
> +	POWER_SUPPLY_PROP_VOLTAGE_MIN,
>  	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
>  	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
>  	POWER_SUPPLY_PROP_VOLTAGE_NOW,


Thanks,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
