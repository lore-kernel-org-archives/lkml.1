Return-Path: <linux-kernel-owner+w=401wt.eu-S1767407AbXCIQ5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767407AbXCIQ5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767408AbXCIQ5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:57:06 -0500
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:4731 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767407AbXCIQ5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:57:05 -0500
Date: Fri, 9 Mar 2007 17:55:40 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-core: i2c bitbang gpio structure
Message-Id: <20070309175540.6bb22798.khali@linux-fr.org>
In-Reply-To: <1173435201.18580.17.camel@roc-desktop>
References: <1173435201.18580.17.camel@roc-desktop>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Fri, 09 Mar 2007 18:13:21 +0800, Wu, Bryan wrote:
> Hi folks,
> 
> A new structure is added to i2c-core for GPIO-based I2C interface
> adapter. My latest GPIO based I2C adapter driver for Blackfin system
> will use this stuff. And also IXP4XX GPIO based I2C driver can also be
> moved to this.
>
> Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
> ---
>  include/linux/i2c.h |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> Index: include/linux/i2c.h
> ===================================================================
> --- include/linux/i2c.h	(revision 2813)
> +++ include/linux/i2c.h	(working copy)
> @@ -201,6 +201,26 @@ struct i2c_algorithm {
>  };
>  
>  /*
> + * Some chips do not have an I2C unit, so GPIO lines are just used to 
> + * Used as platform_data to provide GPIO pin information to this kind GPIO 
> + * based I2C driver.
> + */
> +struct i2c_bitbang_gpio {
> +	int sda;
> +	int scl;
> +};

Why would this be included in the generic i2c.h header file? As far as
I can see this structure only makes sense for bit-banged I2C busses, so
this structure should be declared in i2c-algo-bit.h.

Also, this structure alone isn't very useful. I'm waiting to see
drivers actually making use of it before I will consider merging this
patch at all.

> +
> +static inline int i2c_bitbang_gpio_sda(struct i2c_bitbang_gpio *gpio)
> +{
> +	return (gpio->sda);
> +}
> +
> +static inline int i2c_bitbang_gpio_scl(struct i2c_bitbang_gpio *gpio)
> +{
> +	return (gpio->scl);
> +}

What's the point of these?

-- 
Jean Delvare
