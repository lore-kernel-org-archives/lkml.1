Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbXHKHXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbXHKHXn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 03:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbXHKHXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 03:23:34 -0400
Received: from smtp-106-saturday.nerim.net ([62.4.16.106]:58468 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752564AbXHKHXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 03:23:33 -0400
Date: Sat, 11 Aug 2007 09:23:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Tony Luck <tony.luck@intel.com>,
       Jiri Slaby <jirislaby@gmail.com>, Roland Dreier <rolandd@cisco.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       James Smart <james.smart@emulex.com>, Hansjoerg Lipp <hjlipp@web.de>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] Add missing newlines to some uses of dev_<level>
 messages
Message-ID: <20070811092342.53106dfb@hyperion.delvare>
In-Reply-To: <1186535381.11897.29.camel@localhost>
References: <1186535381.11897.29.camel@localhost>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, 07 Aug 2007 18:09:39 -0700, Joe Perches wrote:
> Found these while looking at printk uses.
> 
> Add missing newlines to dev_<level> uses
> Add missing KERN_<level> prefixes to multiline dev_<level>s
> Fixed a wierd->weird spelling typo
> Added a newline to a printk

Thanks for doing this.

> diff --git a/drivers/i2c/busses/i2c-pmcmsp.c b/drivers/i2c/busses/i2c-pmcmsp.c
> index 17cecf1..be99c02 100644
> --- a/drivers/i2c/busses/i2c-pmcmsp.c
> +++ b/drivers/i2c/busses/i2c-pmcmsp.c
> @@ -591,18 +591,18 @@ static int pmcmsptwi_master_xfer(struct i2c_adapter *adap,
>  	if (msg->flags & I2C_M_TEN)
>  		pmcmsptwi_set_twi_config(&oldcfg, data);
>  
> -	dev_dbg(&adap->dev, "I2C %s of %d bytes ",
> -		(msg->flags & I2C_M_RD) ? "read" : "write", msg->len);
> +	dev_dbg(&adap->dev, "I2C %s of %d bytes %s\n",
> +		(msg->flags & I2C_M_RD) ? "read" : "write", msg->len,
> +		(ret == MSP_TWI_XFER_OK) ? "succeeded" : "failed");
> +
>  	if (ret != MSP_TWI_XFER_OK) {
>  		/*
>  		 * TODO: We could potentially loop and retry in the case
>  		 * of MSP_TWI_XFER_TIMEOUT.
>  		 */
> -		dev_dbg(&adap->dev, "failed\n");
>  		return -1;
>  	}
>  
> -	dev_dbg(&adap->dev, "succeeded\n");
>  	return 0;
>  }
>  
> diff --git a/drivers/i2c/busses/i2c-pnx.c b/drivers/i2c/busses/i2c-pnx.c
> index 17376fe..f8d0dff 100644
> --- a/drivers/i2c/busses/i2c-pnx.c
> +++ b/drivers/i2c/busses/i2c-pnx.c
> @@ -575,7 +575,7 @@ static int __devinit i2c_pnx_probe(struct platform_device *pdev)
>  	else {
>  		freq_mhz = PNX_DEFAULT_FREQ;
>  		dev_info(&pdev->dev, "Setting bus frequency to default value: "
> -		       "%d MHz", freq_mhz);
> +		       "%d MHz\n", freq_mhz);
>  	}
>  
>  	i2c_pnx->adapter->algo = &pnx_algorithm;
> diff --git a/drivers/i2c/chips/menelaus.c b/drivers/i2c/chips/menelaus.c
> index 48a7e2f..76d4eda 100644
> --- a/drivers/i2c/chips/menelaus.c
> +++ b/drivers/i2c/chips/menelaus.c
> @@ -1198,7 +1198,7 @@ static int menelaus_probe(struct i2c_client *client)
>  		err = request_irq(client->irq, menelaus_irq, IRQF_DISABLED,
>  				  DRIVER_NAME, menelaus);
>  		if (err) {
> -			dev_dbg(&client->dev,  "can't get IRQ %d, err %d",
> +			dev_dbg(&client->dev,  "can't get IRQ %d, err %d\n",
>  					client->irq, err);
>  			goto fail1;
>  		}

drivers/i2c parts reviewed and
Acked-by: Jean Delvare <khali@linux-fr.org>

Note that there are 3 more messages to fix in
drivers/i2c/chips/menelaus.c (3 calls to pr_err.)

-- 
Jean Delvare
