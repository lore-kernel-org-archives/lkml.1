Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbYKCLF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbYKCLF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbYKCLFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:05:47 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46406 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbYKCLFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:05:46 -0500
Date: Mon, 3 Nov 2008 11:04:49 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com
Subject: Re: 2.6.28-rc2-git1: spitz still won't boot
Message-ID: <20081103110449.GB26372@flint.arm.linux.org.uk>
References: <20081031150601.GA1457@ucw.cz> <200810312255.38112.rjw@sisk.pl> <20081103104035.GA19153@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103104035.GA19153@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 11:40:35AM +0100, Pavel Machek wrote:
> > On Friday, 31 of October 2008, Pavel Machek wrote:
> > > Hi!
> > > 
> > > ...unfortunately, 2.6.27 contains the 'reset floating' bug, and from
> > > the point 'reset floating' is fixed, to 2.6.28-rc1, tree will not
> > > compile, so bisect is quite hard to do. Any ideas?
> > 
> > Is this a regression from .27?
> 
> Yes, it is (*).
> 									Pavel
> (*) Okay, so 2.6.27 does not boot due to the 'reset floating' bug.

I wouldn't say that was a bug.  That was by design of Dmitry, which
I'm far from happy with.  If an output is being used to drive a
reset line, you always want to actively drive it to the inactive
state for noise immunity reasons.

> 'reset floating' is fixed in 2.6.28-rc1, and compilation of spitz
> is fixed in 2.6.28-rc2, but it still will not boot.

Compilation errors are only going to get worse as ARM continues to
diversify.  We're entirely reliant on sfr's linux-next project to
find build errors prior to merging, and it is unfortunate that this
time around, sfr was on vacation on the run up to the merge window.
Hence, there was very little build coverage of the changes that
went in during this last merge window.  I spent most of the merge
window fixing up all the shitty patches that people had submitted up
until that point that either broke compilation or had runtime
problems.

> So yes, some new spitz-breaking bug got introduced. But no, 2.6.27
> will not boot due to other bug. 2.6.26 boots.

If 2.6.27 doesn't boot even with the reset fixes applied, there's a hell
of a lot of changes that could be the culpret (and I don't remember much
that happened before this last merge window.)  The only thing I can
suggest is to bisect with the reset fixes on top.

This is precisely where we're let down by not having a Zaurus maintainer
who knows the Zaurus issues inside out, and regularly puts effort into
building and testing kernels for these platforms.  That's a hint for
anyone who's reading this.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
