Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320AbXKJX3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbXKJX3q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 18:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbXKJX3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 18:29:37 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:4059 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbXKJX3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 18:29:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JwXtYlf3sBd6sptofTMkpadcel0MGFcRdIrHu0rAoR2QdcAy+6AuivUy/bfUBwPDlVonsWdPB4bt0zAzTyFTjNFv0DUCiol34DdYqh6ta4kWBpNs0tTYIdJe/N5JGjLy9qOkfM3LE3CWN2jodpw8mTsN8aYJThZmZKgUho1mBNk=
Message-ID: <d7b238da0711101529s3384cb6bx928c74cfef8fde0f@mail.gmail.com>
Date: Sun, 11 Nov 2007 07:29:35 +0800
From: "dave chung" <ponstrip@gmail.com>
To: "Stanislav Brabec" <utx@penguin.cz>
Subject: Re: [PATCH] drivers/video/s1d13xxxfb.c as module with dbg
Cc: linux-kernel@vger.kernel.org, "Thibaut VARENE" <varenet@parisc-linux.org>
In-Reply-To: <1194709875.4486.8.camel@utx.utx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1194709875.4486.8.camel@utx.utx.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/07, Stanislav Brabec <utx@penguin.cz> wrote:
> Attached patch fixes two compilation problems of s1d13xxxfb.c:
> - Fixes outdated dbg() message to fix compilation error with debugging enabled.
> - Do not read kernel command line options when compiled as module.
>
> Signed-off-by: Stanislav Brabec <utx@penguin.cz>
>
> --- linux-2.6.23/drivers/video/s1d13xxxfb.c     2007-10-09 22:31:38.000000000 +0200
> +++ linux-2.6.23/drivers/video/s1d13xxxfb.c     2007-11-02 16:48:34.000000000 +0100
> @@ -540,7 +540,7 @@
>         int ret = 0;
>         u8 revision;
>
> -       dbg("probe called: device is %p\n", dev);
> +       dbg("probe called: device is %p\n", pdev);
>
>         printk(KERN_INFO "Epson S1D13XXX FB Driver\n");
>
> @@ -753,8 +753,11 @@
>  static int __init
>  s1d13xxxfb_init(void)
>  {
> +
> +#ifndef MODULE
>         if (fb_get_options("s1d13xxxfb", NULL))
>                 return -ENODEV;
> +#endif
>
>         return platform_driver_register(&s1d13xxxfb_driver);
>  }
>
>
>________________________________________________________________________
> Stanislav Brabec
> http://www.penguin.cz/~utx
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

we also need to look at splitting out the "chip revision", which is
currently hard set, as I have had very good results with this driver
and  chip  S1D13506, which is functionally similar but without the
external clocking and without teh internal ram.
 We also have some build dependancies related to  "CONFIG_FB_S1D13XXX"
and  ics1523 , this chip is not used on the full range of S1D13XXX and
causes errors in the build , for chips such as S1D13506.
potentially we could re-use most of the code, but would need a way to
pass in S1D_CHIP_REV and one or 2 other chip specific data items.

Steve
