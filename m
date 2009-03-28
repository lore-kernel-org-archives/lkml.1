Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbZC1Ikx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbZC1Ikx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 04:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZC1Iko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 04:40:44 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:21393 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbZC1Ikn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 04:40:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PVxnyLfK+z9JNLqak/Rt6Klw2PUhWZQpt0zSV1Mq/97VYHbZHmLLD23cKRVomN6H2o
         DKnyOrXFhHk77xhUT9ub75Fih3dKvfJQO+SbVJAKXYl92nl1WL3yvJ64r7QCYY3fi8n6
         TKFnRDGBZ7JlTshtFeWWmT1wPGtDILgoMzH+Q=
MIME-Version: 1.0
In-Reply-To: <1238196439-16535-22-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de>
	 <1238196439-16535-22-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Sat, 28 Mar 2009 09:40:40 +0100
X-Google-Sender-Auth: be316081067de752
Message-ID: <10f740e80903280140n6326dcct38c89c0454a9ac9@mail.gmail.com>
Subject: Re: [PATCH 22/58] move jazzsonic's probe function to .devinit.text
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>, Jeff Garzik <jeff@garzik.org>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Finn Thain <fthain@telegraphics.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/28 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> A pointer to jazz_sonic_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
>
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Jeff Garzik <jeff@garzik.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/net/jazzsonic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/jazzsonic.c b/drivers/net/jazzsonic.c
> index 14248cf..3695f2d 100644
> --- a/drivers/net/jazzsonic.c
> +++ b/drivers/net/jazzsonic.c
> @@ -204,7 +204,7 @@ out:
>  * Probe for a SONIC ethernet controller on a Mips Jazz board.
>  * Actually probing is superfluous but we're paranoid.
>  */
> -static int __init jazz_sonic_probe(struct platform_device *pdev)
> +static int __devinit jazz_sonic_probe(struct platform_device *pdev)
>  {
>        struct net_device *dev;
>        struct sonic_local *lp;

Same problem in sonic_probe1() (called from sonic_probe())

-Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
