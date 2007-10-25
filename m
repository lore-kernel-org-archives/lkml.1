Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbXJYVoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbXJYVoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbXJYVo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:44:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:34258 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592AbXJYVo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:44:27 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Subject: Re: [2.6 patch] fujitsu-laptop.c: remove dead code
Date: Thu, 25 Oct 2007 17:44:09 -0400
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
References: <200710250508.l9P58exp003251@turbo.physics.adelaide.edu.au>
In-Reply-To: <200710250508.l9P58exp003251@turbo.physics.adelaide.edu.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251744.10035.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

thanks,
-len

On Thursday 25 October 2007 01:08, Jonathan Woithe wrote:
> > This patch removes dead code spotted by the Coverity checker.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Ack.
> 
> Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
> 
> jonathan
> 
> ---
> --- linux-2.6/drivers/misc/fujitsu-laptop.c.old	2007-10-23 18:51:10.000000000 +0200
> +++ linux-2.6/drivers/misc/fujitsu-laptop.c	2007-10-23 18:51:50.000000000 +0200
> @@ -110,33 +110,30 @@ static int get_lcd_level(void)
>  
>  	// Get the Brightness
>  	status =
>  	    acpi_evaluate_integer(fujitsu->acpi_handle, "GBLL", NULL, &state);
>  	if (status < 0)
>  		return status;
>  
>  	fujitsu->fuj02b1_state = state;
>  	fujitsu->brightness_level = state & 0x0fffffff;
>  
>  	if (state & 0x80000000)
>  		fujitsu->brightness_changed = 1;
>  	else
>  		fujitsu->brightness_changed = 0;
>  
> -	if (status < 0)
> -		return status;
> -
>  	return fujitsu->brightness_level;
>  }
>  
>  /* Backlight device stuff */
>  
>  static int bl_get_brightness(struct backlight_device *b)
>  {
>  	return get_lcd_level();
>  }
>  
>  static int bl_update_status(struct backlight_device *b)
>  {
>  	return set_lcd_level(b->props.brightness);
>  }
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
