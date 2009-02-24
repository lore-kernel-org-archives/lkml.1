Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbZBXAz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbZBXAz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZBXAzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:55:50 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4476 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZBXAzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:55:49 -0500
Date: Tue, 24 Feb 2009 00:55:39 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Message-ID: <20090224005536.GC3601@sirena.org.uk>
References: <200902081037.06645.david-b@pacbell.net> <200902231245.44360.david-b@pacbell.net> <20090223220359.GA3601@sirena.org.uk> <200902231443.16334.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902231443.16334.david-b@pacbell.net>
X-Cookie: You are as I am with You.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch 2.6.29-rc3-git 1/2] regulator: twl4030 regulators
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 02:43:16PM -0800, David Brownell wrote:
> On Monday 23 February 2009, Mark Brown wrote:

> > Yeah, I kind of agree.  To avoid confusion from changing the names I'd
> > be tempted to go for something like "regulator driver constraints" but
> > it's not desparately nice.

> Hence my suggestion:  {regulator,machine,consumer} constraints,
> going from bottom up.  They aren't driver constraints; they
> are hardware constraints:  regulators can't supply arbitrary
> voltages.

Trouble is that the term regulator gets very overloaded and causes
confusion.  There's also fun and games to be had with accuracy once you
start looking too closely at the discrete voltages.

> > 	 To be honest I'm not
> > 100% clear why this new feature is essential to supporting the TWL4030 -
> > I can see that it could be useful but I'm not clear on what makes it
> > essential for this driver.

> I never said it was "essential".  However it does simplify

Apologies, you didn't actually say that, no - I was reading between the
lines there.

> the core driver code a lot by moving a lot of error checks
> to the init code; the checks need to live someplace.  You're

I'm not sure I see that for the constraint tightening, and indeed the
TWL4030 set_voltage() operation does have a range check in it.  Unless
I'm missing something if the tightened constraint is usable then it
should flop out of the range based requests with the constraints left
unmodified.  The reason the TWL4030 driver still has the range check in
the set_voltage() operation is that it is checking to make sure that the
requests that come in can be satisfied from the discrete values the
regulator is able to produce which is a good thing to do.

> the one asking for them to be packaged as a new framework
> feature.

The change to add voltage range constraints if none were supplied is a
noticable policy change from the existing framework standard - it allows
machines to enable voltage changes without specifying what the valid
values are.  I'm not convinced that this is a good idea in the first
place and it will result in the opposite behaviour to the current core
code (which should end up erroring out in constraint checking at runtime).
