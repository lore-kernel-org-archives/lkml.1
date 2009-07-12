Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZGLIf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZGLIf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 04:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZGLIfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 04:35:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47043 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbZGLIfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 04:35:16 -0400
Date: Sun, 12 Jul 2009 10:35:10 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Brownell <david-b@pacbell.net>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] move omap_udc's probe function to .devinit.text
Message-ID: <20090712083510.GA24424@pengutronix.de>
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

Hello David,

On Sat, Jul 11, 2009 at 03:30:44PM -0700, David Brownell wrote:
> On Saturday 11 July 2009, Uwe Kleine-König wrote:
> > An alternative to this patch is using platform_driver_probe instead of
> > platform_driver_register plus removing the pointer to the probe function
> > from the struct platform_driver.
> 
> Repeat -- NAK on this.  Use platform_driver_probe() instead.
> 
> I really don't like this series of patches.  It's just adding
> bloat to kernels, in chunks of up to a page per patch.
I'm aware that in some cases platform_driver_probe is better.  But as I
don't have access to most of the affected platforms I consider it saver.
That's why I choosed this way.  The problem with platform_driver_probe
is that if a device is added only after the driver is probed the
device isn't bound.

So if you say you can test it, it's totally OK for me to go the other
way.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
