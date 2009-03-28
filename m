Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbZC1SoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbZC1SoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 14:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZC1SoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 14:44:03 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:58634 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbZC1SoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 14:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KQa3H0crKn7kB7Nf2E3XVvbBSNqnj3TlOSf48oea5LVAFmsozhv1/9WbRr73h7QiV9
         w+Gc1kVY+xA2ukn19hNceo6oqVAX6hjpc3e7o4lIjhfgPI5EY2NDMpts99cGYCoNE+1t
         LjL0PqPEKwFc4HO0++j6iw8z6PStY2vTSSB50=
MIME-Version: 1.0
In-Reply-To: <1238196439-16535-7-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de>
	 <1238196439-16535-7-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Sat, 28 Mar 2009 18:43:57 +0000
Message-ID: <ca2dc2820903281143x70927d41w66be2dcca7acb73f@mail.gmail.com>
Subject: Re: [PATCH 07/58] move cfag12864bfb's probe function to .devinit.text
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Avuton Olrich <avuton@gmail.com>, Antonino Daplas <adaplas@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/27 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> A pointer to cfag12864bfb_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
>
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
>

ACK, thank you!

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Avuton Olrich <avuton@gmail.com>
> Cc: Antonino Daplas <adaplas@gmail.com>
> ---
>  drivers/auxdisplay/cfag12864bfb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/auxdisplay/cfag12864bfb.c b/drivers/auxdisplay/cfag12864bfb.c
> index fe3a865..b0ca5a4 100644
> --- a/drivers/auxdisplay/cfag12864bfb.c
> +++ b/drivers/auxdisplay/cfag12864bfb.c
> @@ -81,7 +81,7 @@ static struct fb_ops cfag12864bfb_ops = {
>        .fb_mmap = cfag12864bfb_mmap,
>  };
>
> -static int __init cfag12864bfb_probe(struct platform_device *device)
> +static int __devinit cfag12864bfb_probe(struct platform_device *device)
>  {
>        int ret = -EINVAL;
>        struct fb_info *info = framebuffer_alloc(0, &device->dev);
> --
> 1.6.2
>
>
