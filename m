Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbYKJVa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbYKJVa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 16:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbYKJVar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 16:30:47 -0500
Received: from nelson.telenet-ops.be ([195.130.133.66]:56947 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYKJVaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 16:30:46 -0500
Date: Mon, 10 Nov 2008 22:30:35 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jianjun Kong <jianjun@zeuux.org>
cc: spock@gentoo.org, linux-fbdev-devel@lists.sourceforge.net,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH] drivers: process failure of
 sysfs_create_group()
In-Reply-To: <20081110105332.GA19358@ubuntu>
Message-ID: <Pine.LNX.4.64.0811102229170.19341@anakin>
References: <20081110105332.GA19358@ubuntu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008, Jianjun Kong wrote:
> drivers: drivers/video/uvesafb.c:
> When fail to call sysfs_create_group(), it should recycle resources and return the error.
> This patch fix for processing failure of sysfs_create_group().

IIRC, the reasoning behind the current code is that a failure to create sysfs
entries is not critical, as it doesn't impact the correct functioning of the
core of the driver.

> Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
> ---
>  drivers/video/uvesafb.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
> index 6c2d37f..a78d4d9 100644
> --- a/drivers/video/uvesafb.c
> +++ b/drivers/video/uvesafb.c
> @@ -1811,12 +1811,16 @@ static int __devinit uvesafb_probe(struct platform_device *dev)
>  			info->fix.id);
>  
>  	err = sysfs_create_group(&dev->dev.kobj, &uvesafb_dev_attgrp);
> -	if (err != 0)
> +	if (err != 0) {
>  		printk(KERN_WARNING "fb%d: failed to register attributes\n",
>  			info->node);
> +		goto out_frame;
> +	}
>  
>  	return 0;
>  
> +our_frame:
> +	unregister_framebuffer(info);
>  out_reg:
>  	release_region(0x3c0, 32);
>  out_unmap:

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
