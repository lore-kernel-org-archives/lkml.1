Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbXFOP7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbXFOP7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbXFOP7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:59:22 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:2446 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753373AbXFOP7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:59:22 -0400
Date: Fri, 15 Jun 2007 17:59:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: hskinnemoen@atmel.com, linux-kernel@vger.kernel.org, i2c@lm-sensors.org
Subject: Re: [PATCH] i2c-gpio: Add support for new-style clients
Message-ID: <20070615175942.3d2d65b7@hyperion.delvare>
In-Reply-To: <20070614.154046.96688009.nemoto@toshiba-tops.co.jp>
References: <20070613.004316.128619812.anemo@mba.ocn.ne.jp>
	<20070614082417.4be74afc@hyperion.delvare>
	<20070614.154046.96688009.nemoto@toshiba-tops.co.jp>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007 15:40:46 +0900 (JST), Atsushi Nemoto wrote:
> On Thu, 14 Jun 2007 08:24:17 +0200, Jean Delvare <khali@linux-fr.org> wrote:
> > > +	if (pdev->id == -1)
> > > +		ret = i2c_bit_add_bus(adap);
> > > +	else
> > > +		ret = i2c_bit_add_numbered_bus(adap);
> > >  	if (ret)
> > >  		goto err_add_bus;
> > >  
> > 
> > This isn't sufficient. Before you call i2c_bit_add_numbered_bus(adap),
> > you are supposed to set adap->nr to the desired i2c adapter number.
> 
> Oh, indeed.  That worked for me just I only used bus number 0.
> Here is a revised patch.
> 
> 
> Subject: [PATCH] i2c-gpio: Add support for new-style clients (take 2)
> 
> Use i2c_bit_add_numbered_bus() if platform_device id specified, so
> that the i2c-gpio adapter works well with new-style pre-declared
> devices.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
> diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
> index a7dd546..88c5735 100644
> --- a/drivers/i2c/busses/i2c-gpio.c
> +++ b/drivers/i2c/busses/i2c-gpio.c
> @@ -142,7 +142,12 @@ static int __init i2c_gpio_probe(struct platform_device *pdev)
>  	adap->algo_data = bit_data;
>  	adap->dev.parent = &pdev->dev;
>  
> -	ret = i2c_bit_add_bus(adap);
> +	if (pdev->id == -1)
> +		ret = i2c_bit_add_bus(adap);
> +	else {
> +		adap->nr = pdev->id;
> +		ret = i2c_bit_add_numbered_bus(adap);
> +	}
>  	if (ret)
>  		goto err_add_bus;
>  

That's better. Patch applied, thanks.

-- 
Jean Delvare
