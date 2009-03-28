Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbZC1Ij0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbZC1Ij0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 04:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbZC1IjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 04:39:15 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:48323 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZC1IjN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 04:39:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Fidu2rBmuUl+5ldPnq99PpEVK47viAZ7WrzpDtg2bLk3eKlfufNwf7iebW9EPXv2TW
         OFtYylAwH7dx7wNGcfsLZ+8+UY+A7x4b5aG+iliEOlAJIM1NnEmc3Twd5ghjpc+csISH
         X5V8Sjx4yUHZeE/wnJ62cg5KgKzHmP/piZGWw=
MIME-Version: 1.0
In-Reply-To: <1238196439-16535-25-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de>
	 <1238196439-16535-25-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Sat, 28 Mar 2009 09:39:10 +0100
X-Google-Sender-Auth: 7ccaf7bc8326afea
Message-ID: <10f740e80903280139i4a6d4a54y1a40eb376d3b89fa@mail.gmail.com>
Subject: Re: [PATCH 25/58] move macsonic's probe function to .devinit.text
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Finn Thain <fthain@telegraphics.com.au>, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/28 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> A pointer to mac_sonic_probe is passed to the core via
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
> Cc: Jeff Garzik <jgarzik@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/net/macsonic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/macsonic.c b/drivers/net/macsonic.c
> index 527166e..d4f913b 100644
> --- a/drivers/net/macsonic.c
> +++ b/drivers/net/macsonic.c
> @@ -555,7 +555,7 @@ static int __init mac_nubus_sonic_probe(struct net_device *dev)
>        return macsonic_init(dev);
>  }
>
> -static int __init mac_sonic_probe(struct platform_device *pdev)
> +static int __devinit mac_sonic_probe(struct platform_device *pdev)
>  {
>        struct net_device *dev;
>        struct sonic_local *lp;

mac_{onboard,nubus}_sonic_probe() (called by mac_sonic_probe()) have the
same problem.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
