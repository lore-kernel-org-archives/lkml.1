Return-Path: <linux-kernel-owner+w=401wt.eu-S965211AbXBVKDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211AbXBVKDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965134AbXBVKDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:03:19 -0500
Received: from tim.rpsys.net ([194.106.48.114]:42334 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964832AbXBVKDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:03:18 -0500
Subject: Re: ACPI: ibm-acpi: fix initial status of backlight device
From: Richard Purdie <rpurdie@rpsys.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070222011643.GB8845@khazad-dum.debian.net>
References: <20070219044616.GC25659@washoe.onerussian.com>
	 <20070219000412.acad13de.akpm@linux-foundation.org>
	 <1171876788.6046.3.camel@localhost.localdomain>
	 <877iub9mu2.fsf@sycorax.lbl.gov>
	 <1172097718.5790.29.camel@localhost.localdomain>
	 <20070221231706.GA3336@khazad-dum.debian.net>
	 <1172103159.5790.45.camel@localhost.localdomain>
	 <20070222005122.GA7928@khazad-dum.debian.net>
	 <20070222011017.GA8845@khazad-dum.debian.net>
	 <20070222011643.GB8845@khazad-dum.debian.net>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 10:03:07 +0000
Message-Id: <1172138587.5837.37.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 23:16 -0200, Henrique de Moraes Holschuh wrote:
> NOTE: This patch needs an ACK from Richard Purdie before it can be merged,
> as he might want to change the backlight class code instead.

As mentioned elsewhere, we can't do this in the class itself.

> --- a/drivers/acpi/ibm_acpi.c
> +++ b/drivers/acpi/ibm_acpi.c
> @@ -1713,6 +1713,13 @@ static struct backlight_properties ibm_backlight_data = {
>  
>  static int brightness_init(void)
>  {
> +	int b;
> +
> +	b = brightness_get(NULL);
> +	if (b < 0)
> +		return b;
> +	ibm_backlight_data.brightness = b;
> +
>  	ibm_backlight_device = backlight_device_register("ibm", NULL, NULL,
>  							 &ibm_backlight_data);

This isn't against 2.6.21-rc1 which changed the backlight class a bit.
Basically, you need to set the brightness variable after
backlight_device_register(). It should be simple enough to do and fix
the problem the same way though.

Richard


