Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYKCLMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYKCLMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbYKCLMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:12:38 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53896 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbYKCLMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:12:37 -0500
Date: Mon, 3 Nov 2008 12:12:36 +0100
From: Pavel Machek <pavel@suse.cz>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com
Subject: Re: 2.6.28-rc2-git1: spitz still won't boot
Message-ID: <20081103111236.GF19153@atrey.karlin.mff.cuni.cz>
References: <20081031150601.GA1457@ucw.cz> <200810312255.38112.rjw@sisk.pl> <20081103104035.GA19153@atrey.karlin.mff.cuni.cz> <20081103110449.GB26372@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103110449.GB26372@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Nov 03, 2008 at 11:40:35AM +0100, Pavel Machek wrote:
> > > On Friday, 31 of October 2008, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > ...unfortunately, 2.6.27 contains the 'reset floating' bug, and from
> > > > the point 'reset floating' is fixed, to 2.6.28-rc1, tree will not
> > > > compile, so bisect is quite hard to do. Any ideas?
> > > 
> > > Is this a regression from .27?
> > 
> > Yes, it is (*).

> > (*) Okay, so 2.6.27 does not boot due to the 'reset floating' bug.
> 
> I wouldn't say that was a bug.  That was by design of Dmitry, which
> I'm far from happy with.  If an output is being used to drive a
> reset line, you always want to actively drive it to the inactive
> state for noise immunity reasons.

Well, if it breaks boot on the machine, I think it is fair to call it
a "bug" :-).

> > 'reset floating' is fixed in 2.6.28-rc1, and compilation of spitz
> > is fixed in 2.6.28-rc2, but it still will not boot.
> 
> Compilation errors are only going to get worse as ARM continues to
> diversify.  We're entirely reliant on sfr's linux-next project to
> find build errors prior to merging, and it is unfortunate that this
> time around, sfr was on vacation on the run up to the merge window.
> Hence, there was very little build coverage of the changes that
> went in during this last merge window.  I spent most of the merge
> window fixing up all the shitty patches that people had submitted up
> until that point that either broke compilation or had runtime
> problems.

:-(.

> > So yes, some new spitz-breaking bug got introduced. But no, 2.6.27
> > will not boot due to other bug. 2.6.26 boots.
> 
> If 2.6.27 doesn't boot even with the reset fixes applied, there's a hell

No, 2.6.27 _does_ boot with reset fixes applied. (But it needs those
reset fixes to boot -- that was what I was trying to say).

> of a lot of changes that could be the culpret (and I don't remember much
> that happened before this last merge window.)  The only thing I can
> suggest is to bisect with the reset fixes on top.

With the reset & compilation fixes on top... and I'll have to search
for the small patch that fixes the compilation :-((.

If you have any idea what should I try to revert between 2.6.27 and
2.6.28-rc2, that would be helpful... bisect is not completely trivial here.

> This is precisely where we're let down by not having a Zaurus maintainer
> who knows the Zaurus issues inside out, and regularly puts effort into
> building and testing kernels for these platforms.  That's a hint for
> anyone who's reading this.

I don't think I have enough time to really maintain Zauruses... but I
can try to help with some testing. So -next is the place that should
get more testing...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
