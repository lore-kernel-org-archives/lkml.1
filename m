Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbZLCO7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbZLCO7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbZLCO7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:59:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44531 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbZLCO7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:59:50 -0500
Date: Thu, 3 Dec 2009 14:58:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Daniel Mack <daniel@caiaq.de>, Matt Fleming <matt@console-pimps.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Eric Miao <eric.y.miao@gmail.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, Cliff Brake <cbrake@bec-systems.com>,
       Pierre Ossman <pierre@ossman.eu>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.infradead.org,
       Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH] mmc: move regulator handling to core
Message-ID: <20091203145825.GA26651@n2100.arm.linux.org.uk>
References: <1259844390-10541-1-git-send-email-daniel@caiaq.de> <20091203130627.GA31254@rakim.wolfsonmicro.main> <20091203131423.GV14091@buzzloop.caiaq.de> <20091203132241.GB31533@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203132241.GB31533@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 01:22:41PM +0000, Mark Brown wrote:
> On Thu, Dec 03, 2009 at 02:14:23PM +0100, Daniel Mack wrote:
> > I would expect the power to be killed when the last user stops using it.
> > Which should result in the same effect if you only have one host, one
> > regulator, and one user.
> 
> Yes, it's always fine in that case (modulo always_on and/or regulators
> without power control).  This goes back to the thing about using
> regulator_get_exclusive(), the message given was that the MMC drivers
> really needed to be able to guarantee that the power would be removed
> when that was requested.

If you take some cards through a series of steps and they stop responding,
it's normally because you've caused their internal state machine to
transition to "invalid" mode.

Further commands are ignored.  The only recovery is to power cycle them.

As for the regulator support in mmci, I can't say anything about it - I
don't have anything which uses it (not that I have any desire at present
to bring a MMC or SD card near Linux after my relatively new 128MB MMC
card got totally buggered with pxamci - that's not to say that Linux is
at fault, but the utter crap that seemingly most MMC/SD cards are.  Hence
why I'm not listed as maintainer of mmci.)

The regulator support in mmci is purely Linus' domain.
