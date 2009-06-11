Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbZFKVIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbZFKVIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 17:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbZFKVID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 17:08:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35628 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbZFKVIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:08:01 -0400
Date: Thu, 11 Jun 2009 23:07:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Eric Piel <eric.piel@tremplin-utc.net>
Subject: Re: [PATCH] lis3: add click function
Message-ID: <20090611210755.GC27376@elf.ucw.cz>
References: <1244750146-31215-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244750146-31215-1-git-send-email-daniel@caiaq.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 21:55:46, Daniel Mack wrote:
> The LIS3 accelerometer chip has a 'click' feature which can be used to
> detect sudden motion on any of the three axis. Configuration data is
> passed via spi platform_data and no action is taken if that's not
> specified, so it won't harm any existing platform.
> 
> To make the configuration effective, the IRQ lines need to be set up
> appropriately. This patch also adds a way to do that from board support
> code.
> 
> The DD_* definitions were removed because I couldn't find any reference
> of them in the datasheet and the overlapped with the CLICK_ register
> space.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Eric Piel <eric.piel@tremplin-utc.net>

Well, patch looks mostly okay, but it would be nice to separate
cleanups onto separate patch... 
 
> index 07ae74b..8d50ef2 100644
> --- a/drivers/hwmon/lis3lv02d_spi.c
> +++ b/drivers/hwmon/lis3lv02d_spi.c
> @@ -66,21 +66,22 @@ static int __devinit lis302dl_spi_probe(struct spi_device *spi)
>  	if (ret < 0)
>  		return ret;
>  
> -	lis3_dev.bus_priv = spi;
> -	lis3_dev.init = lis3_spi_init;
> -	lis3_dev.read = lis3_spi_read;
> -	lis3_dev.write = lis3_spi_write;
> -	lis3_dev.irq = spi->irq;
> -	lis3_dev.ac = lis3lv02d_axis_normal;
> +	lis3_dev.bus_priv	= spi;
> +	lis3_dev.init		= lis3_spi_init;
> +	lis3_dev.read		= lis3_spi_read;
> +	lis3_dev.write		= lis3_spi_write;
> +	lis3_dev.irq		= spi->irq;
> +	lis3_dev.ac		= lis3lv02d_axis_normal;
> +	lis3_dev.pdata		= spi->dev.platform_data;
>  	spi_set_drvdata(spi, &lis3_dev);
>  
> -	ret = lis3lv02d_init_device(&lis3_dev);
> -	return ret;
> +	return lis3lv02d_init_device(&lis3_dev);
>  }
>  
>  static int __devexit lis302dl_spi_remove(struct spi_device *spi)
>  {
>  	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
> +
>  	lis3lv02d_joystick_disable();
>  	lis3lv02d_poweroff(lis3);
>  	return 0;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
