Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbXIASFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbXIASFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 14:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXIASFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 14:05:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:54558 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbXIASFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 14:05:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EuAA4SZGfJW1y3xthI28uedUSPiA9vLZBU3/pKC/2PZ/GRkbqQ0oDiGc8IY1dSXF5P7YXoI+3I4QHwUplRlIZYW+Y+ILjw8GRt2loUtK/PsX3IQRtDoM+6dH8KPzP/iAbfwxK7GAM710gosSlLOK+aYqBoXiIUiGAUKcNt9gAEc=
Message-ID: <41840b750709011105s6c434217t50d965a0b17df643@mail.gmail.com>
Date: Sat, 1 Sep 2007 14:05:03 -0400
From: "Shem Multinymous" <multinymous@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH] hwmon: Add power meters to Documentation/hwmon/sysfs-interface
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
In-Reply-To: <20070901171048.GA3883@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070827211446.GG32667@tree.beaverton.ibm.com>
	 <20070828015029.GA10107@khazad-dum.debian.net>
	 <20070828131942.18449886@hyperion.delvare>
	 <20070828164440.GL32667@tree.beaverton.ibm.com>
	 <20070901171048.GA3883@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/1/07, Pavel Machek <pavel@ucw.cz> wrote:
> > diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
> > index b3a9e1b..da546ce 100644
> > --- a/Documentation/hwmon/sysfs-interface
> > +++ b/Documentation/hwmon/sysfs-interface
> > @@ -304,6 +304,21 @@ curr[1-*]_input  Current input value
> >               Unit: milliampere
> >               RO
> >
> > +*********
> > +* Power *
> > +*********
> > +
> > +power[1-*]_input     Current power use
> > +                     Unit: milliWatt
> > +                     RO
> > +
> > +power[1-*]_max_input Historical maximum power use
> > +                     Unit: milliWatt
> > +                     RO
> > +
> > +power[1-*]_min_input Historical minimum power use
> > +                     Unit: milliWatt
> > +                     RO
>
> Should we add power?_10sec_avg_input? IIRC thinkpads export that,
> too.

Indeed, ThinkPads report both instantaneous power/current and a
rolling average (exponentially decaying, I think) over the last ~10
seconds. ACPI provides only the rolling average, and the out-of-tree
tp_smapi driver provides both.

More generally, linux/power_supply.h defines these attributes:

	POWER_SUPPLY_PROP_VOLTAGE_NOW,
	POWER_SUPPLY_PROP_VOLTAGE_AVG,
	POWER_SUPPLY_PROP_CURRENT_NOW,
	POWER_SUPPLY_PROP_CURRENT_AVG,

It would be nice if the power meter interface uses the same
conventions as the power supply interface, since the former is
essentially a subset of the latter. Userspace app that read power
meters via sysfs should work for power supplies too.

  Shem
