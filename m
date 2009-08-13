Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbZHMMui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbZHMMui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 08:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbZHMMuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 08:50:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50389 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbZHMMug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 08:50:36 -0400
Date: Thu, 13 Aug 2009 14:26:48 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-input@vger.kernel.org
Subject: Re: [PATCH 2/5] [input] add mc13783 touchscreen driver
Message-ID: <20090813122648.GH17992@pengutronix.de>
References: <1250089531-10399-1-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-2-git-send-email-s.hauer@pengutronix.de> <1250089531-10399-3-git-send-email-s.hauer@pengutronix.de> <20090812163521.75631526EC9@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812163521.75631526EC9@mailhub.coreip.homeip.net>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 14:25:00 up 7 days, 23:44, 62 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 09:04:38AM -0700, Dmitry Torokhov wrote:
> On Wed, Aug 12, 2009 at 05:05:28PM +0200, Sascha Hauer wrote:
> > This driver provides support for the touchscreen interface
> > integrated into the Freescale MC13783.
> > 
> > changes since v1:
> > 
> > - remove unused functions
> > - use queue_delayed_work instead of queue_work
> > - report pen events as BTN_TOUCH instead of ABS_PRESSURE
> > - handle interrupt registration in open/close functions
> > - do not call input_free_device() on already registered
> >   input_device
> > - use platform_driver_probe instead of platform_driver_register
> 
> BTW, if you are using platform_driver_probe() then __init is OK for
> .probe() because all probes will only be run once, when driver loads.
> IIRC the ability to discard probe() code was the main reason for
> introducing platform_driver_probe().

But __devinit should be ok also, right?

> 
> > +
> > +	/* unmask the ts wakeup interrupt */
> > +	mc13783_set_bits(priv->mc13783, MC13783_REG_INTERRUPT_MASK_0,
> > +			MC13783_INT_MASK_TSM, 0);
> > +
> > +	mc13783_adc_set_ts_status(priv->mc13783, 1);
> > +
> 
> I actually expected these bits to go into ->open(); not the request IRQ
> stuff...

Yes I know, I just found it convenient to request the interrupts there
so that we do not risk getting interrupts nobody is interested in this
moment.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
