Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZLCNk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZLCNk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbZLCNk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:40:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43347 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755239AbZLCNk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:40:27 -0500
Date: Thu, 3 Dec 2009 13:40:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Pierre Ossman <pierre@ossman.eu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Fleming <matt@console-pimps.org>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Eric Miao <eric.y.miao@gmail.com>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Cliff Brake <cbrake@bec-systems.com>,
       Jarkko Lavinen <jarkko.lavinen@nokia.com>, linux-mmc@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mmc: move regulator handling to core
Message-ID: <20091203134031.GA1311@rakim.wolfsonmicro.main>
References: <1259844390-10541-1-git-send-email-daniel@caiaq.de>
 <20091203130627.GA31254@rakim.wolfsonmicro.main>
 <20091203131423.GV14091@buzzloop.caiaq.de>
 <20091203132241.GB31533@rakim.wolfsonmicro.main>
 <20091203133200.GX14091@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203133200.GX14091@buzzloop.caiaq.de>
X-Cookie: Haste makes waste.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 02:32:00PM +0100, Daniel Mack wrote:
> On Thu, Dec 03, 2009 at 01:22:41PM +0000, Mark Brown wrote:
> > On Thu, Dec 03, 2009 at 02:14:23PM +0100, Daniel Mack wrote:

> > > I would expect the power to be killed when the last user stops using it.
> > > Which should result in the same effect if you only have one host, one
> > > regulator, and one user.

> > Yes, it's always fine in that case (modulo always_on and/or regulators
> > without power control). 

> Well, it didn't for me and always_on, though, due to the return values I
> described.

I mean your new code is fine.

> > This goes back to the thing about using
> > regulator_get_exclusive(), the message given was that the MMC drivers
> > really needed to be able to guarantee that the power would be removed
> > when that was requested.

> > Like I say, if there isn't a *strict* requirement but it's only
> > desirable (possibly strongly desirable) then your approach is obviously
> > preferable.

> The mmci people would need to answer that. To me, the code just looked
> like a power saving feature.

> If this driver needs it, the only tweak to my patch to let that
> particular call site use regulator_get_exclusive, and the core will
> still do the right thing. For this case, the behaviour should be exactly
> the same than it currently is, correct?

No, you'll also need to update the way the driver bootstraps the
reference count since with regulator_get_exclusive() the reference count
is initialised to 1 if the regulator is enabled when it is claimed.
