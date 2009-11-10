Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbZKJLK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbZKJLK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZKJLK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:10:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60220 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZKJLK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:10:28 -0500
Date: Tue, 10 Nov 2009 12:10:01 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Paul Gortmaker <p_gortmaker@yahoo.com>, rtc-linux@googlegroups.com
Subject: Re: [PATCH RESENT] [RTC] Add Freescale MC13783 RTC driver
Message-ID: <20091110111001.GB8418@pengutronix.de>
References: <4AF2E9E7.9050807@epfl.ch> <1257841967-6084-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091110103054.516cc03b@linux.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091110103054.516cc03b@linux.lan.towertech.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 10:30:54AM +0100, Alessandro Zummo wrote:
> On Tue, 10 Nov 2009 09:32:47 +0100
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> 
> > +	ret = mc13783_irq_request_nounmask(priv->mc13783, MC13783_IRQ_1HZ,
> > +			mc13783_rtc_update_handler, DRIVER_NAME, priv);
> > +	if (ret)
> > +		goto err_update_irq_request;
> > +
> > +	mc13783_unlock(priv->mc13783);
> > +
> > +	priv->rtc = rtc_device_register(pdev->name,
> > +			&pdev->dev, &mc13783_rtc_ops, THIS_MODULE);
> > +
> 
>  isn't better to enable irqs after registration.
IMHO it doesn't make a difference for the 1HZ irq, still more as it
remains masked.  The reset irq should be requested before registration.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
