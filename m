Return-Path: <linux-kernel-owner+w=401wt.eu-S1760477AbZELMSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477AbZELMSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 08:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbZELMSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 08:18:10 -0400
Received: from mail.atmel.fr ([81.80.104.162]:53636 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909AbZELMSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 08:18:09 -0400
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 May 2009 08:18:04 EDT
Message-ID: <4A0966D8.3080100@atmel.com>
Date: Tue, 12 May 2009 14:08:56 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ben Nizette <bn@niasdigital.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       kernel <kernel@avr32linux.org>
Subject: Re: [PATCH] atmel-lcdc: Fix pixclock upper bound detection
References: <1241918979.3246.10.camel@linux-51e8.site>
In-Reply-To: <1241918979.3246.10.camel@linux-51e8.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Nizette :
> AFAICT the code which checks that the requested pixclock value is within
> bounds is incorrect.  It ensures that the lcdc core clock is at least
> (bytes per pixel) times higher than the pixel clock rather than just
> greater than or equal to.
> 
> There are tighter restrictions on the pixclock value as a function of
> bus width for STN panels but even then it isn't a simple relationship as
> currently checked for.  IMO either something like the below patch should
> be applied or else more detailed checking logic should be implemented
> which takes in to account the panel type as well.
> 
> CMIIW :-)
> 
> Signed-off-by: Ben Nizette <bn@niasdigital.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
> diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
> index 9a577a8..5779641 100644
> --- a/drivers/video/atmel_lcdfb.c
> +++ b/drivers/video/atmel_lcdfb.c
> @@ -351,7 +351,7 @@ static int atmel_lcdfb_check_var(struct fb_var_screeninfo *var,
>  	dev_dbg(dev, "  bpp:        %u\n", var->bits_per_pixel);
>  	dev_dbg(dev, "  clk:        %lu KHz\n", clk_value_khz);
>  
> -	if ((PICOS2KHZ(var->pixclock) * var->bits_per_pixel / 8) > clk_value_khz) {
> +	if (PICOS2KHZ(var->pixclock) > clk_value_khz) {
>  		dev_err(dev, "%lu KHz pixel clock is too fast\n", PICOS2KHZ(var->pixclock));
>  		return -EINVAL;
>  	}
> 
> 
> 


-- 
Nicolas Ferre
