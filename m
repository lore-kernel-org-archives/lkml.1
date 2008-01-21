Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbYAURPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbYAURPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 12:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYAURPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 12:15:04 -0500
Received: from smtp-107-backup.nerim.net ([62.4.16.107]:57515 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751170AbYAURPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 12:15:02 -0500
Date: Mon, 21 Jan 2008 18:15:00 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Felipe Balbi <me@felipebalbi.com>
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net, tony@atomide.com,
       Linux I2C <i2c@lm-sensors.org>
Subject: Re: [PATCH 1/2] I2C: ISP1301_OMAP: New-style i2c driver updates,
 part 1
Message-ID: <20080121181500.48b3a3d2@hyperion.delvare>
In-Reply-To: <1199379597-6273-2-git-send-email-me@felipebalbi.com>
References: <1199379597-6273-1-git-send-email-me@felipebalbi.com>
	<1199379597-6273-2-git-send-email-me@felipebalbi.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Thu,  3 Jan 2008 11:59:56 -0500, Felipe Balbi wrote:
> Based on David Brownell's patch for tps65010, this patch
> starts converting isp1301_omap.c to new-style i2c driver.
> 
> Signed-off-by: Felipe Balbi <me@felipebalbi.com>
> ---
>  drivers/i2c/chips/isp1301_omap.c |   60 +++++++++++++++++++------------------
>  1 files changed, 31 insertions(+), 29 deletions(-)
> 

Next time, please send this patch to the i2c mailing list instead of
LKML if you want to get some attention.

I'm fine with this patch except for:

> diff --git a/drivers/i2c/chips/isp1301_omap.c b/drivers/i2c/chips/isp1301_omap.c
> index b767603..37e1403 100644
> --- a/drivers/i2c/chips/isp1301_omap.c
> +++ b/drivers/i2c/chips/isp1301_omap.c
> (...)
> @@ -1499,12 +1500,13 @@ static int isp1301_probe(struct i2c_adapter *bus, int address, int kind)
>  	isp->timer.data = (unsigned long) isp;
>  
>  	isp->irq = -1;
> -	isp->client.addr = address;
> -	i2c_set_clientdata(&isp->client, isp);
> -	isp->client.adapter = bus;
> -	isp->client.driver = &isp1301_driver;
> -	strlcpy(isp->client.name, DRIVER_NAME, I2C_NAME_SIZE);
> -	i2c = &isp->client;
> +	isp->irq_type = 0;

The structure is initialized by kzalloc() so no need to explicitly set
this field to 0.

> +	isp->c.addr = address;
> +	i2c_set_clientdata(&isp->c, isp);
> +	isp->c.adapter = bus;
> +	isp->c.driver = &isp1301_driver;
> +	strlcpy(isp->c.name, DRIVER_NAME, I2C_NAME_SIZE);
> +	isp->client = i2c = &isp->c;
>  
>  	/* if this is a true probe, verify the chip ... */
>  	if (kind < 0) {

I'll change it myself, no need to resend.

-- 
Jean Delvare
