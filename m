Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbZGMJBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbZGMJBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbZGMJBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:01:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32786 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbZGMJBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:01:12 -0400
Date: Mon, 13 Jul 2009 11:01:06 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Eric Miao <eric.miao@marvell.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Sokolovsky <pmiscml@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] move corgi-ssp's probe function to .devinit.text
Message-ID: <20090713090106.GB10549@pengutronix.de>
References: <20090711170548.GC5205@suse.de> <1247345591-22643-1-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-2-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-3-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-4-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-5-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-6-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-7-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-8-git-send-email-u.kleine-koenig@pengutronix.de> <4A5AF3D1.7080802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A5AF3D1.7080802@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 04:44:01PM +0800, Eric Miao wrote:
> Uwe Kleine-König wrote:
> > A pointer to corgi_ssp_probe is passed to the core via
> > platform_driver_register and so the function must not disappear when the
> > .init sections are discarded.  Otherwise (when having HOTPLUG=y)
> > unbinding and binding a device to the driver via sysfs will result in an
> > oops as does a device being registered late.
> > 
> > An alternative to this patch is using platform_driver_probe instead of
> > platform_driver_register plus removing the pointer to the probe function
> > from the struct platform_driver.
> > 
> 
> This corgi_ssp.c and corgi_lcd.c will be obsoleted soon, the only user
> corgi_ts.c has been marked as deprecated, and will be remove once the
> ssp cleanup work is done, so further fixes to these files are pointless.
OK, dropped.  I hope that either the drivers will be gone when I respin
this series or I still remember having dropped the patches :-)

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
