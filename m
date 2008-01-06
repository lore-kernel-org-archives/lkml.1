Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYAFWPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYAFWPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 17:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbYAFWPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 17:15:35 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:6222 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbYAFWPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 17:15:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sBoqyitQxzQV3/nEYLNtNsyGfRI9EfdrzqwTos3gU4/c0WjYAl7d3/DwHGYgFA+ZOcQiTkawrclHON5NTNKphTBOS0cTu2amjU4CIlvuR28yPEGSIeSIfskLzQy9xi3NoSFnyDAb/49qUyedCPWohX5gz9wPX6BEKar4lTdNj4c=
Message-ID: <bc64b4640801061415m61c9fd9fr81d6ca03c2a5d626@mail.gmail.com>
Date: Mon, 7 Jan 2008 01:15:32 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: cbouatmailru@gmail.com
Subject: Re: [PATCH 1/3] power_supply: add few more values and props
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
In-Reply-To: <20080106140903.GA23333@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080106122659.GA13106@doriath.ww600.siemens.net>
	 <20080106140903.GA23333@zarina>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/1/6, Anton Vorontsov <cbouatmailru@gmail.com>:
> On Sun, Jan 06, 2008 at 03:27:18PM +0300, Dmitry Baryshkov wrote:
> > Add LiMn (one of the most common for small non-rechargable batteries)i
> > battery technology and voltage_min/_max properties support.
> >
> > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
>
> Much thanks, all patches look good to me. Few questions about
> this one though.
>
> > diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> > index 249f61b..45d2f95 100644
> > --- a/drivers/power/power_supply_sysfs.c
> > +++ b/drivers/power/power_supply_sysfs.c
> > @@ -46,7 +46,8 @@ static ssize_t power_supply_show_property(struct device *dev,
> >               "Unspecified failure"
> >       };
> >       static char *technology_text[] = {
> > -             "Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe", "NiCd"
> > +             "Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe", "NiCd",
> > +             "LiMn"
> >       };
> >       static char *capacity_level_text[] = {
> >               "Unknown", "Critical", "Low", "Normal", "High", "Full"
> > @@ -88,6 +89,8 @@ static struct device_attribute power_supply_attrs[] = {
> >       POWER_SUPPLY_ATTR(present),
> >       POWER_SUPPLY_ATTR(online),
> >       POWER_SUPPLY_ATTR(technology),
> > +     POWER_SUPPLY_ATTR(voltage_max),
> > +     POWER_SUPPLY_ATTR(voltage_min),
>
> I'd suggest keep Documentation/power_supply_class.txt in sync
> wrt new properties, to distinct their meanings and usage.
>
> I assume you're using these new properties for non-rechargeable
> LiMn batteries. So, why new properties, aren't voltage_*_design
> ones suits that purpose? If battery is non-rechargeable it is
> having only design values, no?

No, I used it for the battery driver for Sharp Zaurus SL-6000 (tosa).
It's connected via simple ADC so I can get only voltages. I don't know
max_design value for the battery, but I have 'FULL' signal which I use
to detect 'voltage_max' and use it for power estimations.

> >       POWER_SUPPLY_ATTR(voltage_max_design),
> >       POWER_SUPPLY_ATTR(voltage_min_design),
> >       POWER_SUPPLY_ATTR(voltage_now),
> > diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> > index 606c095..cdbc5b8 100644
> > --- a/include/linux/power_supply.h
> > +++ b/include/linux/power_supply.h
> > @@ -54,6 +54,7 @@ enum {
> >       POWER_SUPPLY_TECHNOLOGY_LIPO,
> >       POWER_SUPPLY_TECHNOLOGY_LiFe,
> >       POWER_SUPPLY_TECHNOLOGY_NiCd,
> > +     POWER_SUPPLY_TECHNOLOGY_LiMn,
> >  };
> >
> >  enum {
> > @@ -72,6 +73,8 @@ enum power_supply_property {
> >       POWER_SUPPLY_PROP_PRESENT,
> >       POWER_SUPPLY_PROP_ONLINE,
> >       POWER_SUPPLY_PROP_TECHNOLOGY,
> > +     POWER_SUPPLY_PROP_VOLTAGE_MAX,
> > +     POWER_SUPPLY_PROP_VOLTAGE_MIN,
> >       POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
> >       POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
> >       POWER_SUPPLY_PROP_VOLTAGE_NOW,
>
>
> Thanks,
>
> --
> Anton Vorontsov
> email: cbou@mail.ru
> backup email: ya-cbou@yandex.ru
> irc://irc.freenode.net/bd2
>


-- 
With best wishes
Dmitry
