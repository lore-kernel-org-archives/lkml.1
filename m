Return-Path: <linux-kernel-owner+w=401wt.eu-S933589AbZFOSEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589AbZFOSEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762801AbZFOSEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:04:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60332 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533AbZFOSEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:04:42 -0400
Date: Mon, 15 Jun 2009 19:04:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] voltage regulator updates for 2.6.31-rc1
Message-ID: <20090615180443.GI6106@sirena.org.uk>
References: <1245065061.21421.90.camel@vega.slimlogic.co.uk> <alpine.LFD.2.01.0906150927390.3305@localhost.localdomain> <20090615171720.GH6106@sirena.org.uk> <alpine.LFD.2.01.0906151027210.3305@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906151027210.3305@localhost.localdomain>
X-Cookie: Prunes give you a run for your money.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 10:28:31AM -0700, Linus Torvalds wrote:
> On Mon, 15 Jun 2009, Mark Brown wrote:

> > It defines a platform data structure for the architecture code which
> > instantiates the driver to use to pass configuration to the driver.  If

> A quick grep shows:

> 	[torvalds@nehalem linux]$ git grep lp3971.h
> 	drivers/regulator/lp3971.c:#include <linux/regulator/lp3971.h>

> ie _nobody_ includes lp3971.h except for lp3971.c.

> So tell me again, why is that lp3971.h file separate from the only driver 
> that uses it?

Currently there are no in-tree users of the driver at all - being an I2C
device it requires explict instantiation.  When users do get merged they
will need to provide this platform data so it seems to make sense to add
the ability to specify the platform data along with the driver.  If we
omit the platform data for now then any users of the driver would need
to be submitted along with a patch adding the platform data (and would
need to carry that patch while out of tree).

We could also say we won't merge any drivers that don't have an in-tree
user but that goes against the general approach to driver merging and
increases the barrier to upstream submission for people working on
systems using regulators.

This situation where you've got drivers merged that are never actually
used in mainline isn't very unusual - sometimes people produce drivers
while working on systems that are never going to be mainlined, sometimes
it's simply a case of the driver support being ready for mainline before
the board code itself is in a mainlineable state.  It's also not unique
to regulator drivers - one other example I just turned up is the tsc2007
touchscreen driver.
