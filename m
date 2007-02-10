Return-Path: <linux-kernel-owner+w=401wt.eu-S1752977AbXBJFkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbXBJFkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 00:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbXBJFkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 00:40:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:39504 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbXBJFkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 00:40:51 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Michael Hanselmann <linux-kernel@hansmi.ch>, linux-acpi@vger.kernel.org
Subject: Re: Fix null pointer dereference in appledisplay driver
Date: Sat, 10 Feb 2007 00:39:20 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cappaberra@gmail.com
References: <20070210001823.GA3557@hansmi.ch>
In-Reply-To: <20070210001823.GA3557@hansmi.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702100039.20956.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

thanks,
-Len

On Friday 09 February 2007 19:18, Michael Hanselmann wrote:
> Commit 40b20c257a13c5a526ac540bc5e43d0fdf29792a by Len Brown introduced
> a null pointer dereference in the appledisplay driver. This patch fixes
> it.
> 
> Signed-off-by: Michael Hanselmann <linux-kernel@hansmi.ch>
> 
> ---
> I suggest adding this to 2.6.20.1 because this bug causes the kernel to
> panic on boot when the driver is compiled in.
> 
> diff -Nrup --exclude-from linux-exclude-from linux-2.6.20.orig/drivers/usb/misc/appledisplay.c linux-2.6.20/drivers/usb/misc/appledisplay.c
> --- linux-2.6.20.orig/drivers/usb/misc/appledisplay.c	2007-02-09 22:35:56.000000000 +0100
> +++ linux-2.6.20/drivers/usb/misc/appledisplay.c	2007-02-10 01:00:28.000000000 +0100
> @@ -281,8 +281,8 @@ static int appledisplay_probe(struct usb
>  	/* Register backlight device */
>  	snprintf(bl_name, sizeof(bl_name), "appledisplay%d",
>  		atomic_inc_return(&count_displays) - 1);
> -	pdata->bd = backlight_device_register(bl_name, NULL, NULL,
> -						&appledisplay_bl_data);
> +	pdata->bd = backlight_device_register(bl_name, NULL,
> +		pdata, &appledisplay_bl_data);
>  	if (IS_ERR(pdata->bd)) {
>  		err("appledisplay: Backlight registration failed");
>  		goto error;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
