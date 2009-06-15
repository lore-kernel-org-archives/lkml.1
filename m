Return-Path: <linux-kernel-owner+w=401wt.eu-S1764753AbZFORR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764753AbZFORR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763874AbZFORRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:17:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55375 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762585AbZFORRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:17:21 -0400
Date: Mon, 15 Jun 2009 18:17:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] voltage regulator updates for 2.6.31-rc1
Message-ID: <20090615171720.GH6106@sirena.org.uk>
References: <1245065061.21421.90.camel@vega.slimlogic.co.uk> <alpine.LFD.2.01.0906150927390.3305@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906150927390.3305@localhost.localdomain>
X-Cookie: Prunes give you a run for your money.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 09:29:54AM -0700, Linus Torvalds wrote:
> On Mon, 15 Jun 2009, Liam Girdwood wrote:

> >  include/linux/regulator/lp3971.h             |   51 +++

> Why the heck would "lp3971.h" be under "include/linux"? That makes no 
> sense what-so-ever. 

> Why isn't it just

> 	drivers/regulator/lp3971.c
> 	drivers/regulator/lp3971.h

It defines a platform data structure for the architecture code which
instantiates the driver to use to pass configuration to the driver.  If
the header were in drivers/regulator then any system using one of these
regulators would need to peer into drivers/regulator in order to set up
the driver.

> instead? There is never any reason for anything but the lp3971 driver to 
> include its own header file, they should _not_ be split up to be in two 
> different places.

All the driver-internal definitions are included in the driver itself,
the regulator drivers have been good about not exposing this.

> In fact, why do we have a "include/linux/regulator/" at all? Does anybody 
> else ever care? I doubt it.

At the minute the regulator API makes at least some platform data
mandatory for regulators (in order to tell the API what configuration
can safely be done on the regulator on a given board).  This could be
changed but it seems to be working well at the minute and provides a
fairly simple and direct way of matching the configuration to the
correct regulator.

Even if the regulator API were reorganised to not require this a
noticable proportion of regulators require some tuning for things like
the passive components surrounding the regulator which would need
platform data.
