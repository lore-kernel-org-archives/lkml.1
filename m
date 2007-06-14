Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbXFNGYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbXFNGYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 02:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbXFNGYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 02:24:13 -0400
Received: from smtp-104-thursday.nerim.net ([62.4.16.104]:55216 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751495AbXFNGYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 02:24:12 -0400
Date: Thu, 14 Jun 2007 08:24:17 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org
Subject: Re: [PATCH] i2c-gpio: Add support for new-style clients
Message-ID: <20070614082417.4be74afc@hyperion.delvare>
In-Reply-To: <20070613.004316.128619812.anemo@mba.ocn.ne.jp>
References: <20070613.004316.128619812.anemo@mba.ocn.ne.jp>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Atsushi,

On Wed, 13 Jun 2007 00:43:16 +0900 (JST), Atsushi Nemoto wrote:
> Use i2c_bit_add_numbered_bus() if device id specified, so that the
> i2c-gpio adapter works well with new-style pre-declared devices.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
> diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
> index a7dd546..8a62c26 100644
> --- a/drivers/i2c/busses/i2c-gpio.c
> +++ b/drivers/i2c/busses/i2c-gpio.c
> @@ -142,7 +142,10 @@ static int __init i2c_gpio_probe(struct platform_device *pdev)
>  	adap->algo_data = bit_data;
>  	adap->dev.parent = &pdev->dev;
>  
> -	ret = i2c_bit_add_bus(adap);
> +	if (pdev->id == -1)
> +		ret = i2c_bit_add_bus(adap);
> +	else
> +		ret = i2c_bit_add_numbered_bus(adap);
>  	if (ret)
>  		goto err_add_bus;
>  

This isn't sufficient. Before you call i2c_bit_add_numbered_bus(adap),
you are supposed to set adap->nr to the desired i2c adapter number.

-- 
Jean Delvare
