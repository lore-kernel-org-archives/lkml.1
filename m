Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZFCHjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZFCHjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 03:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZFCHjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 03:39:43 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:35816 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbZFCHjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 03:39:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=mSqlgW5PXQBVBfiFWhQB5aEiPanKh0xwrelzLEupxUFzIEueZzG2ljudeK3Ukdi6TW
         P8zk31OwBsKHNX9Qemv/VaFFr2W7n1UP9v9NCtv98K9VEsqW+Nu1onWAlksWgRgT+2gj
         Z49/MQ398u7Mf/h1k3N1egn8GrahP1eFkXIRE=
Date: Wed, 3 Jun 2009 09:39:39 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Message-ID: <20090603073939.GB2671@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
	lenb@kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <1240950704.3781.12.camel@maxim-laptop> <cone.1241299309.265715.3948.1000@mentalhome> <20090503184617.GA3555@liondog.tnic> <cone.1241648222.299676.7476.1000@mentalhome> <20090509171432.GA31126@liondog.tnic> <cone.1242065107.695268.13534.1000@onepiie> <20090512060231.GB26286@liondog.tnic> <cone.1242669880.118150.4276.1000@deskpiie> <20090524192219.GA30285@liondog.tnic> <cone.1243865900.580144.4368.1000@deskpiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cone.1243865900.580144.4368.1000@deskpiie>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 01, 2009 at 04:18:20PM +0200, Peter Feuerer wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 41c6605..bd7617e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -222,6 +222,13 @@ L:	linux-acenic@sunsite.dk
> S:	Maintained
> F:	drivers/net/acenic*
>
> +ACER ASPIRE ONE TEMPERATURE AND FAN DRIVER
> +P: Peter Feuerer
> +M: peter@piie.net
> +W: http://piie.net/?section=acerhdf
> +S: Maintained
> +F: drivers/platform/x86/acerhdf.c
> +
> ACER WMI LAPTOP EXTRAS
> P:	Carlos Corbacho
> M:	carlos@strangeworlds.co.uk
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 284ebac..fe14dfd 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -34,6 +34,23 @@ config ACER_WMI
> 	  If you have an ACPI-WMI compatible Acer/ Wistron laptop, say Y or M
> 	  here.
>
> +config ACERHDF
> +	tristate "Acer Aspire One temperature and fan driver"
> +	depends on THERMAL && THERMAL_HWMON
> +	---help---
> +	  This is a driver for Acer Aspire One netbooks. It allows to access
> +	  the temperature sensor and to control the fan.
> +
> +	  After loading this driver the BIOS is still in control of the fan.
> +	  To let the kernel handle the fan, do:
> +	  echo -n enabled > /sys/class/thermal/thermal_zone0/mode
> +
> +	  For more information about this driver see
> +	  <http://piie.net/files/acerhdf_README.txt>
> +
> +	  If you have an Acer Aspire One netbook, say Y or M
> +	  here.
> +
> config ASUS_LAPTOP
> 	tristate "Asus Laptop Extras (EXPERIMENTAL)"
> 	depends on ACPI
> diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
> index e40c7bd..641b8bf 100644
> --- a/drivers/platform/x86/Makefile
> +++ b/drivers/platform/x86/Makefile
> @@ -9,6 +9,7 @@ obj-$(CONFIG_COMPAL_LAPTOP)	+= compal-laptop.o
> obj-$(CONFIG_DELL_LAPTOP)	+= dell-laptop.o
> obj-$(CONFIG_DELL_WMI)		+= dell-wmi.o
> obj-$(CONFIG_ACER_WMI)		+= acer-wmi.o
> +obj-$(CONFIG_ACERHDF)		+= acerhdf.o
> obj-$(CONFIG_HP_WMI)		+= hp-wmi.o
> obj-$(CONFIG_TC1100_WMI)	+= tc1100-wmi.o
> obj-$(CONFIG_SONY_LAPTOP)	+= sony-laptop.o
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> new file mode 100644
> index 0000000..dcfb8b2
> --- /dev/null
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -0,0 +1,533 @@
> +/*
> + * acerhdf - A driver which monitors the temperature
> + *           of the aspire one netbook, turns on/off the fan
> + *           as soon as the upper/lower threshold is reached.
> + *
> + * (C) 2009 - Peter Feuerer     peter (a) piie.net
> + *                              http://piie.net
> + *
> + * Inspired by and many thanks to:
> + *  o acerfand   - Rachel Greenham
> + *  o acer_ec.pl - Michael Kurz     michi.kurz (at) googlemail.com
> + *               - Petr Tomasek     tomasek (#) etf,cuni,cz
> + *               - Carlos Corbacho  cathectic (at) gmail.com
> + *               - Matthew Garrett
> + *               - Borislav Petkov
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#define pr_fmt(fmt) "acerhdf: " fmt

This is new but it's not used anywhere. Maybe some debug leftovers?

> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <linux/dmi.h>
> +#include <acpi/acpi_drivers.h>
> +#include <linux/sched.h>

...

-- 
Regards/Gruss,
    Boris.
