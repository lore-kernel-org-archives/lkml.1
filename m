Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbZGWNwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbZGWNwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 09:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZGWNwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 09:52:34 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:54296 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZGWNwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 09:52:33 -0400
Date: Thu, 23 Jul 2009 14:52:09 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ohad Ben-Cohen <ohad@bencohen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ian Molton <ian@mnementh.co.uk>,
       Pierre Ossman <pierre@ossman.eu>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-linux@rere.qmqm.pl,
       ppisa@pikron.com, jarkko.lavinen@nokia.com, ben@fluff.org,
       saschasommer@freenet.de, avorontsov@ru.mvista.com, oakad@yahoo.com,
       HaraldWelte@viatech.com, JosephChan@via.com.tw, adrian.hunter@nokia.com
Subject: Re: New MMC maintainer needed
Message-ID: <20090723135209.GD6570@console-pimps.org>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu> <20090722151744.fffd7bf5.akpm@linux-foundation.org> <4A67A9E8.5080002@mnementh.co.uk> <20090723055447.GA12211@console-pimps.org> <20090722232259.d0ff3495.akpm@linux-foundation.org> <bd5b16740907222350w54ca7b21w6b47ed94c1d7d16e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd5b16740907222350w54ca7b21w6b47ed94c1d7d16e@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 09:50:03AM +0300, Ohad Ben-Cohen wrote:
> Hi Andrew,
> 
> On Thu, Jul 23, 2009 at 9:22 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
> > I actually already have a little pile of MMC things queued:
> 
> Please also consider queuing up the attached patch as well.
> 
> The patch is removing the current SDIO cards 1.8V limit, which is
> needed for embedded
> SDIO devices like TI 127x WLAN devices (with 1.8V MMC controllers like we
> have on the ZOOM2 boards for example).
> 
> Thank you,
> Ohad.

> From f9ba45b537dd12fc09443ee29c48860665f8ac82 Mon Sep 17 00:00:00 2001
> From: Ohad Ben-Cohen <ohad@bencohen.org>
> Date: Wed, 15 Jul 2009 09:21:41 +0300
> Subject: [PATCH] sdio: do not ignore MMC_VDD_165_195
> 
> This is needed for 1.8V embedded SDIO devices and supporting host controllers
> (e.g. TI 127x and ZOOM2 boards)
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@bencohen.org>
> ---
>  drivers/mmc/core/sdio.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
> index fb99ccf..6f221dc 100644
> --- a/drivers/mmc/core/sdio.c
> +++ b/drivers/mmc/core/sdio.c
> @@ -275,13 +275,6 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
>  		ocr &= ~0x7F;
>  	}
>  
> -	if (ocr & MMC_VDD_165_195) {
> -		printk(KERN_WARNING "%s: SDIO card claims to support the "
> -		       "incompletely defined 'low voltage range'. This "
> -		       "will be ignored.\n", mmc_hostname(host));
> -		ocr &= ~MMC_VDD_165_195;
> -	}
> -
>  	host->ocr = mmc_select_voltage(host, ocr);
>  
>  	/*
> -- 
> 1.5.4.3
> 

Looks OK to me, I'm unaware of a reason to not allow a card to use
MMC_VDD_165_195 if that's what it wants.

Acked-by: Matt Fleming <matt@console-pimps.org>
