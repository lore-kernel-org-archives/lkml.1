Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbZC1TN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbZC1TN4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZC1TNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:13:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35040 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbZC1TNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:13:46 -0400
Date: Sat, 28 Mar 2009 20:13:41 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ian Molton <spyro@f2s.com>, Richard Purdie <rpurdie@rpsys.net>,
       Antonino Daplas <adaplas@gmail.com>,
       Alberto Mardegan <mardy@users.sourceforge.net>
Subject: Re: [PATCH 57/58] move w100fb's probe function to .devinit.text
Message-ID: <20090328191341.GA5588@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de> <1238196439-16535-57-git-send-email-u.kleine-koenig@pengutronix.de> <74d0deb30903280301x7408963ek22e6452d1f3e849c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <74d0deb30903280301x7408963ek22e6452d1f3e849c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hellp pHilipp,

On Sat, Mar 28, 2009 at 11:01:10AM +0100, pHilipp Zabel wrote:
> 2009/3/28 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> > A pointer to w100fb_probe is passed to the core via
> > platform_driver_register and so the function must not disappear when the
> > .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> > unbinding and binding a device to the driver via sysfs will result in an
> > oops as does a device being registered late.
> >
> > An alternative to this patch is using platform_driver_probe instead of
> > platform_driver_register plus removing the pointer to the probe function
> > from the struct platform_driver.
> 
> The ATI Imageon chips handled by this driver are not hotpluggable,
what about

	sysdriverdir=/sys/bus/platform/drivers/w100fb
	echo -n w100fb > $sysdriverdir/unbind
	echo -n w100fb > $sysdriverdir/bind

?  (You might have to use w100fb.0 (or another integer id), didn't check

> I think the proposed alternative is the right way.
> Also, shouldn't w100fb_init be moved from __devinit to __init and
> w100fb_remove be put into __exit?
I concentrated for now on the probe functions, primarily because a wrong
section can result in an oops.  If a function is in __devinit instead of
__init the only harm is that it occupies RAM.

Other than that your change looks good.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
