Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0BLLBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:01:06 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35249 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab0BLLBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:01:04 -0500
Date: Fri, 12 Feb 2010 12:01:00 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [WARNING] mxc_w1_probe should not be __init modified
Message-ID: <20100212110100.GA18221@pengutronix.de>
References: <1265971348.2484.63.camel@realization>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1265971348.2484.63.camel@realization>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 12, 2010 at 11:42:28AM +0100, Alberto Panizzo wrote:
> Today linux-next build, report this:
> 
> WARNING: drivers/w1/masters/built-in.o(.data+0x0): Section mismatch in reference from the variable mxc_w1_driver to the function .init.text:mxc_w1_probe()
> The variable mxc_w1_driver references
> the function __init mxc_w1_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 
> 
> 
> I don't know if should be modified with __devinit instead or nothing at all.
Yes it should use __devinit.  If you need a reason, try

	cd /sys/bus/platform/drivers/mxc_w1
	echo -n mxc_w1.0 > unbind
	echo -n mxc_w1.0 > bind

While at it, mxc_w1_remove can be moved to devexit.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
