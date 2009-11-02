Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZKBOJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZKBOJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 09:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbZKBOJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 09:09:23 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35809 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbZKBOJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 09:09:21 -0500
Date: Mon, 2 Nov 2009 14:09:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd/mc13783: near complete rewrite
Message-ID: <20091102140925.GB6840@sirena.org.uk>
References: <1256330323-13300-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091102115101.GF29351@sirena.org.uk> <20091102135827.GA4855@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102135827.GA4855@pengutronix.de>
X-Cookie: The only perfect science is hind-sight.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 02:58:27PM +0100, Uwe Kleine-K?nig wrote:
> On Mon, Nov 02, 2009 at 11:51:01AM +0000, Mark Brown wrote:

> > This might create issues with a request_nounmask() function, though a
> > request plus mask is probably enough - I guess you're using this for
> > your the RTC driver in which case a spurious periodic interrupt is
> > unlikely to be an issue.

> Yes, I use it to simplify things in the RTC driver a bit.  I register
> the 1HZ irq unconditionally and only track if it's masked or not.  This way
> I can save some case discrimination.

What I've done for wm8350 is just request the IRQ then immediately mask
it and not worry about a periodic notification coming in in the gap -
reporting the extra periodic notification is vanishingly unlikely to do
any harm in the case that the race does crop up.
