Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZKBN65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZKBN65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbZKBN64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:58:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53152 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbZKBN64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:58:56 -0500
Date: Mon, 2 Nov 2009 14:58:27 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd/mc13783: near complete rewrite
Message-ID: <20091102135827.GA4855@pengutronix.de>
References: <1256330323-13300-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091102115101.GF29351@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091102115101.GF29351@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On Mon, Nov 02, 2009 at 11:51:01AM +0000, Mark Brown wrote:
> On Fri, Oct 23, 2009 at 10:38:43PM +0200, Uwe Kleine-K??nig wrote:
> 
> > -int mc13783_register_irq(struct mc13783 *mc13783, int irq,
> > -		void (*handler) (int, void *), void *data)
> > +int mc13783_irq_request_nounmask(struct mc13783 *mc13783, unsigned int irq,
> > +		irqreturn_t (*handler)(struct mc13783 *, unsigned int, void *),
> > +		const char *name, void *dev)
> 
> If you're changing the signature of the IRQ handler functions it'd be
> nice to change them to irq_handler_t - that way it'll be much easier to
> transition the driver to using genirq in future since it should end up
> being possible to just stub out the Atlas-specific calls in the header
> with calls to the standard IRQ functions when the core is transitioned,
> reducing cross-tree issues.
OK, will do.
 
> This might create issues with a request_nounmask() function, though a
> request plus mask is probably enough - I guess you're using this for
> your the RTC driver in which case a spurious periodic interrupt is
> unlikely to be an issue.
Yes, I use it to simplify things in the RTC driver a bit.  I register
the 1HZ irq unconditionally and only track if it's masked or not.  This way
I can save some case discrimination.

Best regards and thaks for your comments
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
