Return-Path: <linux-kernel-owner+w=401wt.eu-S964771AbXCGHCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964771AbXCGHCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964778AbXCGHCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:02:43 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51852 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964774AbXCGHCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:02:42 -0500
Date: Tue, 6 Mar 2007 23:02:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: bryan.wu@analog.com
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Sonic Zhang <sonic.adi@gmail.com>,
       Mike Frysinger <vapier.adi@gmail.com>, khali@linux-fr.org,
       linux-kernel@vger.kernel.org, mhfan@ustc.edu,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH -mm] Blackfin: blackfin i2c driver
Message-Id: <20070306230215.0fab528b.akpm@linux-foundation.org>
In-Reply-To: <1173247078.28531.24.camel@roc-desktop>
References: <1173164058.31825.16.camel@roc-desktop>
	<20070306214301.GA5590@martell.zuzino.mipt.ru>
	<1173247078.28531.24.camel@roc-desktop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2007 13:57:58 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:

> Here is the updated blackfin i2c driver.
> 
> [PATCH] Blackfin: blackfin i2c driver
> 
> The i2c linux driver for blackfin architecture which supports both GPIO
> i2c operation and blackfin on-chip TWI controller i2c operation.
> 
> Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
> ---
>  drivers/i2c/busses/Kconfig         |   47 ++++
>  drivers/i2c/busses/i2c-bfin-gpio.c |   98 +++++++++
>  drivers/i2c/busses/i2c-bfin-twi.c  |  589 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 734 insertions(+)
> 
> Index: linux-2.6/drivers/i2c/busses/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/i2c/busses/Kconfig	2007-03-07 13:32:02.000000000 +0800
> +++ linux-2.6/drivers/i2c/busses/Kconfig	2007-03-07 13:44:19.000000000 +0800
> @@ -5,6 +5,53 @@
>  menu "I2C Hardware Bus support"
>  	depends on I2C
>  
> +config I2C_BFIN_GPIO
> +	tristate "Generic Blackfin and HHBF533/561 development board I2C support"
> +	depends on I2C && EXPERIMENTAL
> +	select I2C_ALGOBIT
> +	help
> +	--
> +
> +menu "BFIN I2C SDA/SCL Selection"
> +	depends on I2C_BFIN_GPIO
> +config BFIN_SDA
> +	int "SDA is GPIO Number"
> +	range 0 15 if (BF533 || BF532 || BF531) 
> +	range 0 47 if (BF534 || BF536 || BF537)
> +	range 0 47 if BF561
> +	default 2 if (BF533 || BF532 || BF531) 
> +
> +config BFIN_SCL
> +	int "SCL is GPIO Number"
> +	range 0 15 if (BF533 || BF532 || BF531) 
> +	range 0 47 if (BF534 || BF536 || BF537)
> +	range 0 47 if BF561
> +	default 3 
> +endmenu
> +
> +config I2C_BFIN_GPIO_CYCLE_DELAY
> +	int "Cycle Delay in usec"
> +	depends on I2C_BFIN_GPIO
> +	range 1 100 
> +	default 40
> +
> +config I2C_BFIN_TWI
> +	tristate "Blackfin TWI I2C support"
> +	depends on I2C && (BF534 || BF536 || BF537)
> +	help
> +	  This the TWI I2C device driver for Blackfin 534/536/537.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called i2c-bfin-twi.
> +
> +config TWICLK_KHZ
> +	int "TWI clock (kHZ)"
> +	depends on I2C_BFIN_TWI
> +	default 50
> +	help
> +	  The unit of the TWI clock is kilo HZ. Please divide the clock 
> +	  by 1024 if you count it in HZ. The value should be less than 400.
> +

Well that's cute.  This patch causes an i386 `make allmodconfig' to spew
these:

    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 
    SDA is GPIO Number (BFIN_SDA) [] (NEW) 

out at about 1,000,000/sec, infinitely.

I'll put a `depends on BFIN' in there to shut it up, but I think you've
tickled a Kconfig bug.

