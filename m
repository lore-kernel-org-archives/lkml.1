Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbYH0LB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbYH0LB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbYH0LBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:01:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4205 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbYH0LBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:01:48 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2008 07:01:48 EDT
Date: Wed, 27 Aug 2008 12:01:44 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: perex@perex.cz, lrg@kernel.org, Cliff Cai <cliff.cai@analog.com>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 3/4] ASOC: WM8731 codec: add SPI support as well as I2C
Message-ID: <20080827110143.GB10834@sirena.org.uk>
Mail-Followup-To: Bryan Wu <cooloney@kernel.org>, perex@perex.cz,
	lrg@kernel.org, Cliff Cai <cliff.cai@analog.com>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org> <1219829968-6431-4-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219829968-6431-4-git-send-email-cooloney@kernel.org>
X-Cookie: Those who can't write, write manuals.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 05:39:27PM +0800, Bryan Wu wrote:

This looks good, thanks but...

> -#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
> +#if defined (CONFIG_I2C) || defined (CONFIG_I2C_MODULE) && !defined (CONFIG_SND_SOC_WM8731_SPI)
>  	if (setup->i2c_address) {
>  		normal_i2c[0] = setup->i2c_address;
>  		codec->hw_write = (hw_write_t)i2c_master_send;
> @@ -688,8 +745,14 @@ static int wm8731_probe(struct platform_device *pdev)
>  		if (ret != 0)
>  			printk(KERN_ERR "can't add i2c driver");
>  	}
> +#elif defined (CONFIG_SPI_MASTER) && defined (CONFIG_SND_SOC_WM8731_SPI)
> +	codec->hw_write = (hw_write_t)wm8731_spi_write;
> +	ret = spi_register_driver(&wm8731_spi_driver);
> +	if (ret != 0)
> +		printk(KERN_ERR "can't add spi driver");

...as for the SSM2602 it'd be good if it were possible to build a kernel
which supports both I2C and SPI.  If you like I could do this for you -
there's likely to be merge issues due to the update to the new I2C API
anyway?
