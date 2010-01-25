Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804Ab0AYTZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0AYTZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 14:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783Ab0AYTZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 14:25:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56252 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab0AYTZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 14:25:43 -0500
Date: Mon, 25 Jan 2010 20:25:40 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register: warn if probe is in
	.init.text
Message-ID: <20100125192540.GB14834@pengutronix.de>
References: <20100122173846.GA11057@suse.de> <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de> <20100122234936.GA14538@core.coreip.homeip.net> <20100123094916.GA24949@pengutronix.de> <20100125171439.GA27387@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100125171439.GA27387@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

> > > > +	if (drv->probe && kernel_init_text_address((unsigned long)drv->probe))
> > > > +		pr_warning("oops-warning: probe function of platform driver %s"
> > > > +			       " lives in .init.text\n", drv->driver.name);
> > > > +#else
> > > > +	/*
> > > > +	 * without HOTPLUG probe functions can be discarded after the driver is
> > > > +	 * loaded.
> > > > +	 * There is a little chance for false positives, namely if the driver is
> > > > +	 * registered after the .init sections are discarded.
> > > > +	 */
> > > > +	if (drv->probe && !kernel_init_text_address((unsigned long)drv->probe))
> > > > +		pr_info("probably the probe function of platform driver %s can"
> > > > +				" be moved to .init.text\n", drv->driver.name);
> > > 
> > > It really depends on the user's (or rather builder's) local
> > > configuration so how can we make this suggestion?
> > Can you point out a situation that makes the suggestion wrong?  AFAIK
> > there only the possibility that the driver is loaded after .init is
> > discarded (as written in the comment).
> > 
> 
> The presence of CONFIG_HOTPLUG depends on particular .config, so, for
> example, you may not have it set while I have. So you will boot, get the
> suggestion, submit a patch, then I will boot and will get a warning that
> the probe function is in wrong section.
> 
> So in general I wonder if it is possible to request that all probe
> functions are marked as __devinit or not marked at all, regardless of
> CONFIG_HOTPLUG and CONFIG_MODULE settings.
Would you agree if the message would change to

	probably the probe function of platform driver %s can be moved
	to .devinit.text

?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
