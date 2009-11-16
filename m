Return-Path: <linux-kernel-owner+w=401wt.eu-S1751667AbZKPBIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbZKPBIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 20:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbZKPBIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 20:08:18 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:18993 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750931AbZKPBIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 20:08:09 -0500
Date: Mon, 16 Nov 2009 04:08:14 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Paul Fertser <fercerpav@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       zaurus-devel@www.linuxtogo.org
Subject: Re: [RFC PATCH 1/2] power: implement platform battery driver
Message-ID: <20091116010814.GB4927@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1257820673-30801-1-git-send-email-fercerpav@gmail.com>
 <1257820673-30801-2-git-send-email-fercerpav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1257820673-30801-2-git-send-email-fercerpav@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tue, Nov 10, 2009 at 05:37:52AM +0300, Paul Fertser wrote:
[...]
> +static int platform_bat_get_property(struct power_supply *psy,
> +				       enum power_supply_property psp,
> +				       union power_supply_propval *val)
> +{
> +	struct platform_battery *bat =
> +				container_of(psy, struct platform_battery, psy);
> +	size_t i;
> +	int present = 1;
> +
> +	if (bat->pdata->is_present)
> +		present = bat->pdata->is_present();
> +
> +	if (psp != POWER_SUPPLY_PROP_PRESENT && !present)
> +		return -ENODEV;
> +
> +	for (i = 0; i < psy->num_properties; i++)
> +		if (psy->properties[i] == psp) {
> +			val->intval = bat->pdata->get_property[i]();
> +			return 0;
> +		}

I'm not sure I like this. Why don't you just pass the enum
to pdata hook? So platform devices would just use a single
get_property function and a 'switch', like the rest of the
power supply drivers.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
