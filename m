Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbZIUHnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbZIUHnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZIUHnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:43:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35050 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZIUHnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:43:14 -0400
Date: Mon, 21 Sep 2009 09:43:12 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Woodhouse <david.woodhouse@intel.com>
Cc: Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] move sh_flctl's probe function to .devinit.text
Message-ID: <20090921074312.GA15181@pengutronix.de>
References: <1247345591-22643-3-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-4-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-5-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-6-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-7-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-8-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-9-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-10-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-11-git-send-email-u.kleine-koenig@pengutronix.de> <1253401794.6317.50.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1253401794.6317.50.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Sep 19, 2009 at 04:09:54PM -0700, David Woodhouse wrote:
> On Sat, 2009-07-11 at 13:52 -0700, Uwe Kleine-König wrote:
> > A pointer to flctl_probe is passed to the core via
> > platform_driver_register and so the function must not disappear when the
> > .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> > unbinding and binding a device to the driver via sysfs will result in an
> > oops as does a device being registered late.
> > 
> > An alternative to this patch is using platform_driver_probe instead of
> > platform_driver_register plus removing the pointer to the probe function
> > from the struct platform_driver.
> 
> ... which is what you did for orion_nand, so let's do that for sh_flctl
> too.
> 
> http://git.infradead.org/mtd-2.6.git/commitdiff/894572a3635
Ah, you already did it, fine.  If you want (and still can) you can add
my Acked-by:

Best regards, thanks
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
