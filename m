Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZALUzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZALUzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZALUzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:55:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59444 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbZALUzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:55:22 -0500
Date: Mon, 12 Jan 2009 21:55:20 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: wrong usage of __devexit_p and __exit_p
Message-ID: <20090112205520.GA10870@pengutronix.de>
References: <20090112135057.GA10250@pengutronix.de> <20090112141457.GA11777@uranus.ravnborg.org> <20090112144327.GB29183@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090112144327.GB29183@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

> > Did you check that this did not introduce any new Section mismatch warnings?
> > We have seen several __exit annotated functions that was used from __init
> > annotated code or even from normal code.
> > Thus the __exit annotation was wrong in these cases.
> I wrote in the commit logs, that the functions are only used as argument
> to __{dev,}exit_p.  There are no direct calls. (IIRC there was only one
> exception that I checked manually.)
Actually the case I remembered here isn't part of the series.
 
> I think the __{dev,}exit_p wrappers are only used to define remove
> callbacks, so there should be no harm.
In the meantime I checked this:

	~/gsrc/linux-2.6$ git diff-tree -r linus/master expsec-master | cut -f 2 | xargs grep -h -E '__(dev)?exit_p'
		.remove		= __devexit_p(s3c_adc_remove),
		.remove		= __devexit_p(s3c_pwm_remove),
		.remove =	__devexit_p(virtblk_remove),
		.remove =	__devexit_p(virtrng_remove),
		.remove = __devexit_p(stli_pciremove)
		.remove   = __devexit_p(hifn_remove),
		.remove = __devexit_p(mpc85xx_pci_err_remove),
		.remove = __devexit_p(mv64x60_pci_err_remove),
		.remove		= __devexit_p(max7301_remove),
		.remove		= __devexit_p(bbc_remove),
		.remove		= __devexit_p(grover_remove),
		.remove		= __exit_p(pxa_camera_remove),
		.remove		= __devexit_p(asic3_remove),
		.remove   = __devexit_p(ilo_remove),
		.remove = __exit_p(mxcnd_remove),
		.remove =	__devexit_p(virtnet_remove),
		.remove		= __devexit_p(atp870u_remove),
		.remove		= __devexit_p(megaraid_detach_one),
		.remove		= __devexit_p(stex_remove),
		.remove		= __devexit_p(jsm_remove_one),
		.remove	= __devexit_p(sc26xx_driver_remove),
		.remove =	__devexit_p(spidev_remove),
		.remove	= __devexit_p(vhci_hcd_remove),
		.remove =	__devexit_p(virtballoon_remove),

So in the patched files __(dev)?exit_p is only used to fill struct
members.  Provided this is the only usage of the respective
functions---and I checked that---it doesn't make sense that they don't
live in .devexit.text (or .exit.text respectively).

Does it make sence for you, too?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
Peiner Strasse 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686              | Fax:   +49-5121-206917-5555 |
