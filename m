Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbYD3Huv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbYD3Huv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbYD3Hum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:50:42 -0400
Received: from aun.it.uu.se ([130.238.12.36]:35473 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377AbYD3Hul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:50:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18456.9402.658349.517658@harpo.it.uu.se>
Date: Wed, 30 Apr 2008 09:50:18 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Riku Voipio <riku.voipio@iki.fi>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       buytenh@wantstofly.org, tbm@cyrius.com
Subject: Re: [PATCH] Add pca9532 platform data for Thecus N2100
In-Reply-To: <20080429200853.GB20889@kos.to>
References: <20080429200853.GB20889@kos.to>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Riku Voipio writes:
 > Thecus N2100 has leds and a buzzer attached to a pca9532
 > controller. Attach the driver to the i2c bus and define
 > the pca9532 pin coniguration for this platform in n2100_leds.
 > 
 > With this patch, support for N2100 should be complete in mainline
 > Linux.
 > 
 > Signed-off-by: Riku Voipio <riku.voipio@iki.fi>
 > ---
 >  arch/arm/mach-iop32x/n2100.c |   52 ++++++++++++++++++++++++++++++++++++++++++
 >  1 files changed, 52 insertions(+), 0 deletions(-)
 > 
 > diff --git a/arch/arm/mach-iop32x/n2100.c b/arch/arm/mach-iop32x/n2100.c
 > index bc91d6e..029d234 100644
 > --- a/arch/arm/mach-iop32x/n2100.c
 > +++ b/arch/arm/mach-iop32x/n2100.c
 > @@ -17,6 +17,7 @@
 >  #include <linux/mm.h>
 >  #include <linux/init.h>
 >  #include <linux/f75375s.h>
 > +#include <linux/leds-pca9532.h>
 >  #include <linux/delay.h>
 >  #include <linux/kernel.h>
 >  #include <linux/pci.h>
 > @@ -206,6 +207,53 @@ static struct f75375s_platform_data n2100_f75375s = {
 >  	.pwm_enable = { 0, 0 },
 >  };
 >  
 > +static struct pca9532_platform_data n2100_leds = {
 > +	.leds = {
 > +	{	.name = "n2100:red:satafail0",
 > +		.state = PCA9532_OFF,
 > +		.type = PCA9532_TYPE_LED,
 > +	},
 > +	{	.name = "n2100:red:satafail1",
 > +		.state = PCA9532_OFF,
 > +		.type = PCA9532_TYPE_LED,
 > +	},
 > +	{	.name = "n2100:blue:usb",
 > +		.state = PCA9532_OFF,
 > +		.type = PCA9532_TYPE_LED,
 > +	},
 > +	{ 	.type = PCA9532_TYPE_NONE },
 > +
 > +	{ 	.type = PCA9532_TYPE_NONE },
 > +	{ 	.type = PCA9532_TYPE_NONE },
 > +	{ 	.type = PCA9532_TYPE_NONE },
 > +	{	.name = "n2100:red:usb",
 > +		.state = PCA9532_OFF,
 > +		.type = PCA9532_TYPE_LED,
 > +	},
 > +
 > +	{	.type = PCA9532_TYPE_NONE }, /* power OFF gpio */
 > +	{	.type = PCA9532_TYPE_NONE }, /* reset gpio */
 > +	{	.type = PCA9532_TYPE_NONE },
 > +	{	.type = PCA9532_TYPE_NONE },
 > +
 > +	{	.type = PCA9532_TYPE_NONE },
 > +	{	.name = "n2100:orange:system",
 > +		.state = PCA9532_OFF,
 > +		.type = PCA9532_TYPE_LED,
 > +	},
 > +	{	.name = "n2100:red:system",
 > +		.state = PCA9532_OFF,
 > +		.type = PCA9532_TYPE_LED,
 > +	},
 > +	{	.name = "N2100 beeper"  ,
 > +		.state =  PCA9532_OFF,
 > +		.type = PCA9532_TYPE_N2100_BEEP,
 > +	},
 > +	},
 > +	.psc = { 0, 0 },
 > +	.pwm = { 0, 0 },
 > +};
 > +

This .leds field looks like an array where an item's position
is significant. If this is the case, initialisers should use
the "[N] = { ... }," notation, IMO.

Also, intendation in the .leds initialiser is wrong.

Apart from that, thank you for completing the n2100 hw support.

/Mikael
