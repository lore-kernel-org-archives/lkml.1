Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbZKBLvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbZKBLvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 06:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZKBLvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 06:51:00 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41093 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbZKBLu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 06:50:59 -0500
Date: Mon, 2 Nov 2009 11:51:01 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd/mc13783: near complete rewrite
Message-ID: <20091102115101.GF29351@sirena.org.uk>
References: <1256330323-13300-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256330323-13300-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Cookie: <ahzz_> i figured 17G oughta be enough.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 10:38:43PM +0200, Uwe Kleine-K??nig wrote:

> -int mc13783_register_irq(struct mc13783 *mc13783, int irq,
> -		void (*handler) (int, void *), void *data)
> +int mc13783_irq_request_nounmask(struct mc13783 *mc13783, unsigned int irq,
> +		irqreturn_t (*handler)(struct mc13783 *, unsigned int, void *),
> +		const char *name, void *dev)

If you're changing the signature of the IRQ handler functions it'd be
nice to change them to irq_handler_t - that way it'll be much easier to
transition the driver to using genirq in future since it should end up
being possible to just stub out the Atlas-specific calls in the header
with calls to the standard IRQ functions when the core is transitioned,
reducing cross-tree issues.

This might create issues with a request_nounmask() function, though a
request plus mask is probably enough - I guess you're using this for
your the RTC driver in which case a spurious periodic interrupt is
unlikely to be an issue.
