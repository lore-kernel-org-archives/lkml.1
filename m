Return-Path: <linux-kernel-owner+w=401wt.eu-S933267AbXCUR5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbXCUR5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 13:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933281AbXCUR5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 13:57:40 -0400
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:2478 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933267AbXCUR5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 13:57:40 -0400
Date: Wed, 21 Mar 2007 18:56:18 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 4/4] Blackfin: on-chip Two Wire Interface I2C driver
Message-Id: <20070321185618.96738cbd.khali@linux-fr.org>
In-Reply-To: <1174471688.5648.56.camel@roc-desktop>
References: <1174471688.5648.56.camel@roc-desktop>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

What's the point of setting the Reply-To header to your own address,
other than forcing me to add your name manually each time I reply?

On Wed, 21 Mar 2007 18:08:08 +0800, Wu, Bryan wrote:
> As GPIO based blackfin driver will be replaced by I2C-GPIO generic
> driver, we just update this latest version of blackfin on-chip TWI I2C
> driver according to LKML review.

Good idea.

> [PATCH] Blackfin: on-chip Two Wire Interface I2C driver
> 
> The i2c linux driver for blackfin architecture which supports blackfin
> on-chip TWI controller i2c operation.
> 
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
> Reviewed-by: Jean Delvare <khali@linux-fr.org>
> Cc: David Brownell <david-b@pacbell.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/i2c/busses/Kconfig        |   16 
>  drivers/i2c/busses/Makefile       |    1 
>  drivers/i2c/busses/i2c-bfin-twi.c |  653 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 670 insertions(+)

This is missing a MAINTAINERS entry. Please provide a patch adding it,
and I'm push this patch on my i2c stack (for Linux 2.6.22.)

> +static int __init i2c_bfin_twi_init(void)
> +{
> +	int ret;
> +
> +	pr_info("I2C: Blackfin I2C TWI driver\n");
> +
> +	ret = platform_driver_register(&i2c_bfin_twi_driver);
> +	if (ret) {
> +		pr_debug("Fail to register i2c_bfin_twi driver\n");
> +	}
> +	return ret;
> +}

That pr_debug isn't exactly useful. If the registration failed, the
user will notice soon enough, as the driver will not be loaded at all
and modprobe will return the error code (which is more valuable for
debugging than the message itself.)

-- 
Jean Delvare
