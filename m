Return-Path: <linux-kernel-owner+w=401wt.eu-S1763958AbZFOR3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763958AbZFOR3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbZFOR3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:29:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116AbZFOR3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:29:04 -0400
Date: Mon, 15 Jun 2009 10:28:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] voltage regulator updates for 2.6.31-rc1
In-Reply-To: <20090615171720.GH6106@sirena.org.uk>
Message-ID: <alpine.LFD.2.01.0906151027210.3305@localhost.localdomain>
References: <1245065061.21421.90.camel@vega.slimlogic.co.uk> <alpine.LFD.2.01.0906150927390.3305@localhost.localdomain> <20090615171720.GH6106@sirena.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Jun 2009, Mark Brown wrote:

> On Mon, Jun 15, 2009 at 09:29:54AM -0700, Linus Torvalds wrote:
> > On Mon, 15 Jun 2009, Liam Girdwood wrote:
> 
> > >  include/linux/regulator/lp3971.h             |   51 +++
> 
> > Why the heck would "lp3971.h" be under "include/linux"? That makes no 
> > sense what-so-ever. 
> 
> > Why isn't it just
> 
> > 	drivers/regulator/lp3971.c
> > 	drivers/regulator/lp3971.h
> 
> It defines a platform data structure for the architecture code which
> instantiates the driver to use to pass configuration to the driver.  If
> the header were in drivers/regulator then any system using one of these
> regulators would need to peer into drivers/regulator in order to set up
> the driver.

A quick grep shows:

	[torvalds@nehalem linux]$ git grep lp3971.h
	drivers/regulator/lp3971.c:#include <linux/regulator/lp3971.h>

ie _nobody_ includes lp3971.h except for lp3971.c.

So tell me again, why is that lp3971.h file separate from the only driver 
that uses it?

		Linus
