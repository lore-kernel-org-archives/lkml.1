Return-Path: <linux-kernel-owner+w=401wt.eu-S1752272AbZL3Gvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbZL3Gvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 01:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbZL3Gvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 01:51:38 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:46478 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZL3Gvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 01:51:37 -0500
Date: Wed, 30 Dec 2009 01:51:18 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Zhang Rui <rui.zhang@intel.com>
Cc: Julia Lawall <julia@diku.dk>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 9/9] drivers/acpi: correct error-handling code
In-reply-to: <1248828809.2670.144.camel@rzhang-dt>
Message-id: <alpine.LFD.2.00.0912300151120.15839@localhost.localdomain>
References: <Pine.LNX.4.64.0907281756010.28189@ask.diku.dk>
 <1248828809.2670.144.camel@rzhang-dt>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-1632894692-1262155886=:15839"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1632894692-1262155886=:15839
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

applied

thanks,
Len Brown, Intel Open Source Technology Center

On Wed, 29 Jul 2009, Zhang Rui wrote:

> On Tue, 2009-07-28 at 23:56 +0800, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > backlight_device_register may return an ERR_PTR value rather than a valid
> > pointer.
> > 
> > A simplified version of the semantic match that finds this problem is as
> > follows: (http://coccinelle.lip6.fr/)
> 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> >  drivers/acpi/video.c                |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> > index 8851315..29788db 100644
> > --- a/drivers/acpi/video.c
> > +++ b/drivers/acpi/video.c
> > @@ -982,6 +982,8 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
> >  		sprintf(name, "acpi_video%d", count++);
> >  		device->backlight = backlight_device_register(name,
> >  			NULL, device, &acpi_backlight_ops);
> > +		if (IS_ERR(device->backlight))
> > +			return;
> 
> we should kfree(name) here.
> 
> >  		device->backlight->props.max_brightness = device->brightness->count-3;
> >  		kfree(name);
> 
> how about this one?
> 
> ﻿backlight_device_register may return an ERR_PTR value rather than a valid
> pointer.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/acpi/video.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/acpi/video.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/video.c
> +++ linux-2.6/drivers/acpi/video.c
> @@ -982,8 +982,10 @@ static void acpi_video_device_find_cap(s
>  		sprintf(name, "acpi_video%d", count++);
>  		device->backlight = backlight_device_register(name,
>  			NULL, device, &acpi_backlight_ops);
> -		device->backlight->props.max_brightness = device->brightness->count-3;
>  		kfree(name);
> +		if (IS_ERR(device->backlight))
> +			return;
> +		device->backlight->props.max_brightness = device->brightness->count-3;
>  
>  		result = sysfs_create_link(&device->backlight->dev.kobj,
>  					   &device->dev->dev.kobj, "device");
> 
> 
> 
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-1632894692-1262155886=:15839--
