Return-Path: <linux-kernel-owner+w=401wt.eu-S935592AbXHIJFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935592AbXHIJFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764873AbXHIJFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:05:30 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:1864 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761550AbXHIJF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:05:29 -0400
Date: Thu, 9 Aug 2007 11:05:26 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
Subject: Re: [2.6 patch] drivers/i2c/i2c-core.c: make code static
Message-ID: <20070809110526.5c2c7d6c@hyperion.delvare>
In-Reply-To: <20070729145708.GL16817@stusta.de>
References: <20070729145708.GL16817@stusta.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Sun, 29 Jul 2007 16:57:08 +0200, Adrian Bunk wrote:
> After the i2c-isa removal some code can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> 
>  drivers/i2c/i2c-core.c |    7 +++----
>  include/linux/i2c.h    |    2 --
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> --- linux-2.6.23-rc1-mm1/include/linux/i2c.h.old	2007-07-26 12:46:44.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/include/linux/i2c.h	2007-07-26 12:46:53.000000000 +0200
> @@ -35,8 +35,6 @@
>  #include <linux/sched.h>	/* for completion */
>  #include <linux/mutex.h>
>  
> -extern struct bus_type i2c_bus_type;
> -
>  /* --- General options ------------------------------------------------	*/
>  
>  struct i2c_msg;
> --- linux-2.6.23-rc1-mm1/drivers/i2c/i2c-core.c.old	2007-07-26 08:59:44.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/drivers/i2c/i2c-core.c	2007-07-26 09:01:42.000000000 +0200
> @@ -190,7 +190,7 @@
>  	{ },
>  };
>  
> -struct bus_type i2c_bus_type = {
> +static struct bus_type i2c_bus_type = {
>  	.name		= "i2c",
>  	.dev_attrs	= i2c_dev_attrs,
>  	.match		= i2c_device_match,
> @@ -201,7 +201,6 @@
>  	.suspend	= i2c_device_suspend,
>  	.resume		= i2c_device_resume,
>  };
> -EXPORT_SYMBOL_GPL(i2c_bus_type);

This one was left exported on request by David Brownell. See this
discussion thread:
http://lists.lm-sensors.org/pipermail/i2c/2007-March/000924.html

I am personally fine with removing this export, as it can always be
added later if needed. But if others share David's point of view, I am
also fine leaving the export as is.

>  
>  /**
>   * i2c_new_device - instantiate an i2c device for use with a new style driver
> @@ -285,7 +284,7 @@
>  
>  /* I2C bus adapters -- one roots each I2C or SMBUS segment */
>  
> -void i2c_adapter_dev_release(struct device *dev)
> +static void i2c_adapter_dev_release(struct device *dev)
>  {
>  	struct i2c_adapter *adap = to_i2c_adapter(dev);
>  	complete(&adap->dev_released);
> @@ -303,7 +302,7 @@
>  	{ },
>  };
>  
> -struct class i2c_adapter_class = {
> +static struct class i2c_adapter_class = {
>  	.owner			= THIS_MODULE,
>  	.name			= "i2c-adapter",
>  	.dev_attrs		= i2c_adapter_attrs,

These ones are unquestionably correct, good catch, thanks.

-- 
Jean Delvare
