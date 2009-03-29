Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbZC2Izl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbZC2Izl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 04:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbZC2Izb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 04:55:31 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:42086 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZC2Iza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 04:55:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NVOPUWFJe7dDuIYsDvV01J9661TPfmW4LW1BFIX1Eo7JxicPUdegwtPMhX0He47UmT
         ZBgr+ayY1LqmW2NW6/lkQXqdjOJSIIuGp3KRD8kkioqJfVJHrkKQVcWQNPuM8sUPP76M
         Hsr44VL734swtDYTDIYbvfN15v5hXYSiwPDcY=
MIME-Version: 1.0
In-Reply-To: <1238268358-6068-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1238196439-16535-22-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1238268358-6068-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Sun, 29 Mar 2009 10:55:27 +0200
X-Google-Sender-Auth: 145ef7a83dcedcb0
Message-ID: <10f740e80903290155se064adan1fd07e0102b79c38@mail.gmail.com>
Subject: Re: [PATCH] move jazzsonic's probe function to .devinit.text
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       Jeff Garzik <jeff@garzik.org>, "David S. Miller" <davem@davemloft.net>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Finn Thain <fthain@telegraphics.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
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
> As noticed by Geert Uytterhoeven sonic_probe1 is called by
> jazz_sonic_probe, so the former has to move to .devinit.text, too.
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
> Hi Geert and Ralf,
>
> thanks for your feed-back.
>
> @Geert: Did you notice this, or your compiler?

I noticed this in macsonic, when I reviewed your patch.
As jazzsonic is very similar to macsonic, I suspected your patch had the
same issue there ;-)

Probably the compiler didn't tell you, because it inlined the other functions.
Still wondering why my compiler didn't tell me before. Maybe I just forgot to
build for Mac with CONFIG_DEBUG_SECTION_MISMATCH=y...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
