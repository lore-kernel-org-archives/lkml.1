Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbZGLUsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbZGLUsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 16:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbZGLUsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 16:48:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49463 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZGLUsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 16:48:07 -0400
Date: Sun, 12 Jul 2009 22:48:03 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Brownell <david-b@pacbell.net>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] move omap_udc's probe function to .devinit.text
Message-ID: <20090712204803.GA27454@pengutronix.de>
References: <20090711170548.GC5205@suse.de> <1247345591-22643-37-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-38-git-send-email-u.kleine-koenig@pengutronix.de> <200907111530.44736.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200907111530.44736.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 11, 2009 at 03:30:44PM -0700, David Brownell wrote:
> On Saturday 11 July 2009, Uwe Kleine-König wrote:
> > An alternative to this patch is using platform_driver_probe instead of
> > platform_driver_register plus removing the pointer to the probe function
> > from the struct platform_driver.
> 
> Repeat -- NAK on this.  Use platform_driver_probe() instead.
Oh, I just noticed that this patch is a relict.  The driver was changed
to use platform_driver_probe in
864e28b4f24106b799e991fa136fa6fa2b638a68.

As my old patch just applied anyhow I didn't notice that.

And I just found another similar problem.
E.g. clevo_mail_led_probe is defined to live in .init.text and uses
platform_driver_probe, but as it's referenced in the driver struct my
script matched this file.

(Is it wrong (wrong as in "worth to be fixed") to reference the probe
function in the driver struct when platform_driver_probe is used?  If so
at least

	drivers/serial/msm_serial.c
	drivers/i2c/busses/i2c-imx.c

are effected, too.  Patches at

	http://news.gmane.org/find-root.php?group=gmane.linux.ports.arm.kernel&article=62319

)

The other patches are not affected.

@Greg:  Please just drop these two patches:

	[PATCH] move omap_udc's probe function to .devinit.text
	[PATCH] move leds-clevo-mail's probe function to .devinit.text

Sorry for the unconvenience.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
