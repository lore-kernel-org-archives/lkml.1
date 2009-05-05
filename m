Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZEEOcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZEEOcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 10:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbZEEOcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 10:32:14 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:39947 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751267AbZEEOcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 10:32:14 -0400
Date: Tue, 5 May 2009 16:32:12 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Roel Kluin <roel.kluin@gmail.com>
cc: Greg KH <gregkh@suse.de>, axboe@kernel.dk,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block/ps3: remove driver_data direct access of struct
 device
In-Reply-To: <49FFFBAF.4040808@gmail.com>
Message-ID: <alpine.LRH.2.00.0905051629060.21255@vixen.sonytel.be>
References: <49FFFBAF.4040808@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009, Roel Kluin wrote:
> In the near future, the driver core is going to not allow direct access
> to the driver_data pointer in struct device.  Instead, the functions
> dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> have been around since the beginning, so are backwards compatible with
> all older kernel versions.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Thanks, I'll add it to my list of ps3* patches for 2.6.31...

> diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
> index 8eddef3..8ecf1e0 100644
> --- a/drivers/block/ps3vram.c
> +++ b/drivers/block/ps3vram.c

> @@ -615,9 +615,9 @@ static int __devinit ps3vram_probe(struct ps3_system_bus_device *dev)
>  	}
>  
>  	mutex_init(&priv->lock);
> -	dev->core.driver_data = priv;
> +	dev_set_drvdata(&dev->core, priv);
>  
> -	priv = dev->core.driver_data;
> +	priv = dev_get_drvdata(&dev->core);
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This line can actually be removed, while we're at it...

>  	/* Allocate XDR buffer (1MiB aligned) */
>  	priv->xdr_buf = (void *)__get_free_pages(GFP_KERNEL,

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
