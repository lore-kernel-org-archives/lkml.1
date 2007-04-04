Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbXDDTMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbXDDTMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 15:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbXDDTMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 15:12:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37703 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbXDDTMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 15:12:02 -0400
Date: Wed, 4 Apr 2007 12:12:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 51/90] ARM: OMAP: osk+mistral backlight, power, board
 specific
Message-Id: <20070404121246.96f87902.randy.dunlap@oracle.com>
In-Reply-To: <11757101072553-git-send-email-tony@atomide.com>
References: <11757099691323-git-send-email-tony@atomide.com>
	<11757100623383-git-send-email-tony@atomide.com>
	<11757100641006-git-send-email-tony@atomide.com>
	<11757100661228-git-send-email-tony@atomide.com>
	<11757100691131-git-send-email-tony@atomide.com>
	<11757100713004-git-send-email-tony@atomide.com>
	<11757100752021-git-send-email-tony@atomide.com>
	<11757100781275-git-send-email-tony@atomide.com>
	<11757100811771-git-send-email-tony@atomide.com>
	<11757100821353-git-send-email-tony@atomide.com>
	<11757100853841-git-send-email-tony@atomide.com>
	<1175710087578-git-send-email-tony@atomide.com>
	<11757100911247-git-send-email-tony@atomide.com>
	<1175710093864-git-send-email-tony@atomide.com>
	<11757100952384-git-send-email-tony@atomide.com>
	<11757100982726-g!
 it-send-email-tony@atomide.com>
	<11757101012787-git-send-email-tony@atomide.com>
	<1175710103340-git-send-email-tony@atomide.com>
	<11757101072553-git-send-email-tony@atomide.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Apr 2007 14:05:30 -0400 Tony Lindgren wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Mistral-specific:
> 
>   - Add PWL-driven LCD backlight device
> 
>   - Apply power to the board even when the LCD isn't configured; things
>     like EEPROM, temperature sensor, and wakeup switch depend on it.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/mach-omap1/board-osk.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap1/board-osk.c b/arch/arm/mach-omap1/board-osk.c
> index 253c539..df9681d 100644
> --- a/arch/arm/mach-omap1/board-osk.c
> +++ b/arch/arm/mach-omap1/board-osk.c
> @@ -373,6 +386,15 @@ static void __init osk_mistral_init(void)
>  	} else
>  		printk(KERN_ERR "OSK+Mistral: wakeup button is awol\n");
>  
> +	/* LCD:  backlight, and power; power controls other devices on the
> +	 * board, like the touchscreen, EEPROM, and wakeup (!) switch.
> +	 */
> +	omap_cfg_reg(PWL);
> +	if (omap_request_gpio(2) == 0) {
> +		omap_set_gpio_direction(2, 0 /* out */);
> +		omap_set_gpio_dataout(2, 1 /* on */);

Some #defined values would be better than those comments.

> +	}
> +
>  	platform_add_devices(mistral_devices, ARRAY_SIZE(mistral_devices));
>  }
>  #else



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
