Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbZATINh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbZATINh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 03:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbZATIN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 03:13:28 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:42917 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbZATIN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 03:13:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BBSPfFo94coxKJrMpFTb/kKIqnDOVlO5Tpndc85pyptgBhOwQCrpj3AcNzS69qWSyz
         s5CDjat8loSBqebluNMKCFW2lW17XOZXITuhzEiLPN5g0+ip/SMiWji3Q9IbbWi7Bhos
         tlkKh1ZCxGcJ6DWQSNe8XBGE310ERRkka2LMY=
MIME-Version: 1.0
In-Reply-To: <1231799107-20136-8-git-send-email-u.kleine-koenig@pengutronix.de>
References: <S1757830AbZALWQu/20090112221650Z+1710@vger.kernel.org>
	 <1231799107-20136-8-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Tue, 20 Jan 2009 09:13:25 +0100
Message-ID: <ca2dc2820901200013y3723785cjb4ca4a0e223f7993@mail.gmail.com>
Subject: Re: [PATCH] move cfag12864bfb's probe function to .devinit.text
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 11:24 PM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> A pointer to cfag12864bfb_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.

Thank you for the patch!

>
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.

Is that solution better? What are the pros/cons?

>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/auxdisplay/cfag12864bfb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/auxdisplay/cfag12864bfb.c b/drivers/auxdisplay/cfag12864bfb.c
> index fe3a865..b0ca5a4 100644
> --- a/drivers/auxdisplay/cfag12864bfb.c
> +++ b/drivers/auxdisplay/cfag12864bfb.c
> @@ -81,7 +81,7 @@ static struct fb_ops cfag12864bfb_ops = {
>        .fb_mmap = cfag12864bfb_mmap,
>  };
>
> -static int __init cfag12864bfb_probe(struct platform_device *device)
> +static int __devinit cfag12864bfb_probe(struct platform_device *device)
>  {
>        int ret = -EINVAL;
>        struct fb_info *info = framebuffer_alloc(0, &device->dev);
> --
> 1.5.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
