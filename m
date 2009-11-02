Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbZKBOdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbZKBOdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 09:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZKBOdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 09:33:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35481 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbZKBOdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 09:33:02 -0500
Date: Mon, 2 Nov 2009 15:32:29 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd/mc13783: near complete rewrite
Message-ID: <20091102143229.GB4855@pengutronix.de>
References: <1256330323-13300-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091102115101.GF29351@sirena.org.uk> <20091102135827.GA4855@pengutronix.de> <20091102140925.GB6840@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091102140925.GB6840@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Nov 02, 2009 at 02:09:25PM +0000, Mark Brown wrote:
> On Mon, Nov 02, 2009 at 02:58:27PM +0100, Uwe Kleine-K?nig wrote:
> > On Mon, Nov 02, 2009 at 11:51:01AM +0000, Mark Brown wrote:
> 
> > > This might create issues with a request_nounmask() function, though a
> > > request plus mask is probably enough - I guess you're using this for
> > > your the RTC driver in which case a spurious periodic interrupt is
> > > unlikely to be an issue.
> 
> > Yes, I use it to simplify things in the RTC driver a bit.  I register
> > the 1HZ irq unconditionally and only track if it's masked or not.  This way
> > I can save some case discrimination.
> 
> What I've done for wm8350 is just request the IRQ then immediately mask
> it and not worry about a periodic notification coming in in the gap -
> reporting the extra periodic notification is vanishingly unlikely to do
> any harm in the case that the race does crop up.
On mc13783 the 1HZ irq triggers immediately after unmasking provided
that it has power for more than 1s.  Because of locking the irq isn't
recognized as 1HZ as the irqhandler tries to take the lock that the rtc
probe function is holding and only releasing after the irq is masked.
So for me it's just a spurious irq.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
