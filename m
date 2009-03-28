Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbZC1ThX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbZC1ThX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZC1ThI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:37:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37720 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbZC1ThH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:37:07 -0400
Date: Sat, 28 Mar 2009 20:37:02 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Stanley.Miao" <stanley.miao@windriver.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [PATCH 31/58] move omap_hdq's probe function to .devinit.text
Message-ID: <20090328193702.GB5588@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de> <1238196439-16535-31-git-send-email-u.kleine-koenig@pengutronix.de> <20090328082148.GA20668@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090328082148.GA20668@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

On Sat, Mar 28, 2009 at 11:21:49AM +0300, Evgeniy Polyakov wrote:
> On Sat, Mar 28, 2009 at 12:26:52AM +0100, Uwe Kleine-König (u.kleine-koenig@pengutronix.de) wrote:
> > A pointer to omap_hdq_probe is passed to the core via
> > platform_driver_register and so the function must not disappear when the
> > .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> > unbinding and binding a device to the driver via sysfs will result in an
> > oops as does a device being registered late.
> > 
> > An alternative to this patch is using platform_driver_probe instead of
> > platform_driver_register plus removing the pointer to the probe function
> > from the struct platform_driver.
> 
> I wonder if it can be hotplugged, but for the consistency it looks good.
Maybe you cannot really hotplug it, but with CONFIG_HOTPLUG you can
unbind it via sysfs and rebind it afterwards, too.

Can I consider this an Acked-by: you?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
