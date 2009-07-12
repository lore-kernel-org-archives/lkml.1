Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZGLWM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZGLWM2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZGLWMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:12:21 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:27209 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750965AbZGLWMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:12:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LCgNZs6sy88iTMy+8S0y9aRC9GYx0fNggpf3lufWZq1SiKoK52CeUNU0QvAyrjNT0i5y5g4b/rhurTke2JMHReKuhKuMzXT+LgZBWKFEHBs1UsU73/GU585NDuUpeVbsNGJgnsAp/TzJVH2KJkN2p30wschl9u5KKkDlKC2efHM=  ;
X-YMail-OSG: npnyiQ4VM1kLo.YFh8C71C0MaEvU0f0M5S8jKjYNC.YWnWrkXM8AeQvKfEr06bd4IQ1ELtK7XppImf36KiSjieyi5LGlZ12McWpddqS4IMOR.I2ayVpg4o.MPMqNYIBIogDgGFox2GBZv0Rax4TYuJ1tluWcwMRxeCxze91RhZDGLkxYBOcTihEwGwgmntYdTDZe2Sm62SNeTi.CcdRUGd0CoYagNMNzB5HKKBxz5I4eAb7wS10VawVCUAEPQD56vXtzSfz8In_jBtR.akqAiz4s1UMf.pe57sRqnUhjM0_wxEosQyvaz4xAJpwgOi6P7T1krInYlktLegJz69pVAw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] move omap_udc's probe function to .devinit.text
Date: Sun, 12 Jul 2009 15:12:18 -0700
User-Agent: KMail/1.9.10
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
References: <20090711170548.GC5205@suse.de> <200907111530.44736.david-b@pacbell.net> <20090712204803.GA27454@pengutronix.de>
In-Reply-To: <20090712204803.GA27454@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907121512.18358.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 July 2009, Uwe Kleine-König wrote:
> On Sat, Jul 11, 2009 at 03:30:44PM -0700, David Brownell wrote:
> > Repeat -- NAK on this.  Use platform_driver_probe() instead.
>
> Oh, I just noticed that this patch is a relict.  The driver was changed
> to use platform_driver_probe in
> 864e28b4f24106b799e991fa136fa6fa2b638a68.

Good.
 

> And I just found another similar problem.
> E.g. clevo_mail_led_probe is defined to live in .init.text and uses
> platform_driver_probe, but as it's referenced in the driver struct my
> script matched this file.
> 
> (Is it wrong (wrong as in "worth to be fixed") to reference the probe
> function in the driver struct when platform_driver_probe is used?

Wrong, but not dangerous ... so fix, but at low priority.
At least, low until the DEBUG_SECTION_MISMATCH stuff gets
re-enabled.

When platform_driver_probe() returns, that driver field willl
have changed to something safe.


> If so 
> at least
> 
> 	drivers/serial/msm_serial.c
> 	drivers/i2c/busses/i2c-imx.c
> 
> are effected, too.  Patches at
> 
> 	http://news.gmane.org/find-root.php?group=gmane.linux.ports.arm.kernel&article=62319
> 
> )
> 
> The other patches are not affected.
> 
> @Greg:  Please just drop these two patches:
> 
> 	[PATCH] move omap_udc's probe function to .devinit.text
> 	[PATCH] move leds-clevo-mail's probe function to .devinit.text

... and the others I NAKed too.


> 
> Sorry for the unconvenience.
> 
> Best regards
> Uwe
> 
> -- 
> Pengutronix e.K.                              | Uwe Kleine-König            |
> Industrial Linux Solutions                    | http://www.pengutronix.de/  |
> 
> 


