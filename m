Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbYBFRE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbYBFRE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbYBFRET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:04:19 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:40090 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbYBFRES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:04:18 -0500
Message-ID: <47A9E883.2000806@tiscali.nl>
Date: Wed, 06 Feb 2008 18:04:03 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, rpurdie@openedhand.com,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/HP7XX] - Add combined LCD / BL driver for platform HP
 Jornada 7xx handhelds
References: <20080205195331.fa2ca02b.Kristoffer.ericson@gmail.com>	<47A9A944.7090401@tiscali.nl>	<47A9AA4F.80508@tiscali.nl> <20080206173341.619c52c8.Kristoffer.ericson@gmail.com>
In-Reply-To: <20080206173341.619c52c8.Kristoffer.ericson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristoffer Ericson wrote:
> Oki, here is attempt #2 (btw, new mail or just keep thread?)
> 
> Tested to build and checkpatch.
> 
> diff --git a/drivers/video/backlight/jornada720_bllcd.c b/drivers/video/backlight/jornada720_bllcd.c

> +static int jornada_bl_update_status(struct backlight_device *dev)
> +{
> +	int ret = 0;
> +
> +	jornada_ssp_start();
> +
> +	if (dev->props.power != FB_BLANK_UNBLANK ||
> +		dev->props.fb_blank != FB_BLANK_UNBLANK) {
> +		ret = jornada_ssp_inout(BRIGHTNESSOFF);
> +		if (ret == -ETIMEDOUT)

since there is no curly bracket here...

> +			printk(KERN_ERR "jornada720_bl:	\
> +				BrightnessOff timeout\n");

...indentation is wrong in lines below

> +			/* backlight off */
> +			PPSR &= ~PPC_LDD1;
> +			PPDR |= PPC_LDD1;
> +
> +	} else	{	/* backlight on */

too much indentation in lines below as well

> +			PPSR |= PPC_LDD1;
> +			if ((jornada_ssp_inout(SETBRIGHTNESS)) == TXDUMMY) {
> +			    /* send brightness value (0 is max, 255 lowest) */
> +				if (jornada_ssp_byte(JORNADA_BL_MAX_BRIGHTNESS -
> +					 dev->props.brightness) != -ETIMEDOUT)
> +				ret = (JORNADA_BL_MAX_BRIGHTNESS -
> +					dev->props.brightness);
> +			} else
> +				printk(KERN_ERR "jornada720_bl:	\
> +					SetBrightness timeout\n");
> +		}
> +	jornada_ssp_end();
> +
> +	return ret;
> +}

> +static int jornada_lcd_set_contrast(struct lcd_device *pdev, int contrast)
> +{
> +	int ret = 0;
> +
> +	jornada_ssp_start();
> +
> +	ret = jornada_ssp_inout(SETCONTRAST);
> +
> +	if (ret == -ETIMEDOUT)
> +		printk(KERN_ERR "jornada_lcd: failure to set contrast\n");
> +	 else

whitespace before else

> +		ret = jornada_ssp_byte(contrast);
> +
> +	jornada_ssp_end();
> +
> +	return ret;
> +}
> +
> +static int jornada_lcd_set_power(struct lcd_device  *pdev, int power)
> +{
> +	if (power != FB_BLANK_UNBLANK) {
> +		/* turn off LCD */
> +		PPSR &= ~PPC_LDD2;
> +		PPDR |= PPC_LDD2;
> +	} else {
> +		/* turn on LCD */
> +		PPSR |= PPC_LDD2;
> +		}

whitespace before curly bracket

> +
> +	return 0;
> +}
