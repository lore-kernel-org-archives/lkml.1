Return-Path: <linux-kernel-owner+w=401wt.eu-S1767053AbXDEP25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767053AbXDEP25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767054AbXDEP25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:28:57 -0400
Received: from nlpi029.sbcis.sbc.com ([207.115.36.58]:35213 "EHLO
	nlpi029.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767053AbXDEP24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:28:56 -0400
X-ORBL: [67.117.73.34]
Date: Thu, 5 Apr 2007 11:28:11 -0400
From: Tony Lindgren <tony@atomide.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 51/90] ARM: OMAP: osk+mistral backlight, power, board specific
Message-ID: <20070405152809.GN24297@atomide.com>
References: <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <20070404121246.96f87902.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404121246.96f87902.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap <randy.dunlap@oracle.com> [070404 15:11]:
> On Wed,  4 Apr 2007 14:05:30 -0400 Tony Lindgren wrote:
> 
> > From: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > Mistral-specific:
> > 
> >   - Add PWL-driven LCD backlight device
> > 
> >   - Apply power to the board even when the LCD isn't configured; things
> >     like EEPROM, temperature sensor, and wakeup switch depend on it.
> > 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > ---
> >  arch/arm/mach-omap1/board-osk.c |   22 ++++++++++++++++++++++
> >  1 files changed, 22 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/mach-omap1/board-osk.c b/arch/arm/mach-omap1/board-osk.c
> > index 253c539..df9681d 100644
> > --- a/arch/arm/mach-omap1/board-osk.c
> > +++ b/arch/arm/mach-omap1/board-osk.c
> > @@ -373,6 +386,15 @@ static void __init osk_mistral_init(void)
> >  	} else
> >  		printk(KERN_ERR "OSK+Mistral: wakeup button is awol\n");
> >  
> > +	/* LCD:  backlight, and power; power controls other devices on the
> > +	 * board, like the touchscreen, EEPROM, and wakeup (!) switch.
> > +	 */
> > +	omap_cfg_reg(PWL);
> > +	if (omap_request_gpio(2) == 0) {
> > +		omap_set_gpio_direction(2, 0 /* out */);
> > +		omap_set_gpio_dataout(2, 1 /* on */);
> 
> Some #defined values would be better than those comments.

Adding OMAP_GPIO_OUT/ON defines could be fixed later on for all
omap_set_gpio_direction/dataout().

Regards,

Tony
