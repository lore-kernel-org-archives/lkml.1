Return-Path: <linux-kernel-owner+w=401wt.eu-S1752290AbXA0Rm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbXA0Rm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 12:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXA0Rm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 12:42:29 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2467 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752290AbXA0Rm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 12:42:28 -0500
Date: Sat, 27 Jan 2007 17:38:04 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@osdl.org>
Cc: David Brownell <david-b@pacbell.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
Message-ID: <20070127173804.GD3942@ucw.cz>
References: <20061219185223.GA13256@srcf.ucam.org> <200701261356.42171.david-b@pacbell.net> <20070126231521.GA12370@srcf.ucam.org> <200701261642.56896.david-b@pacbell.net> <20070126165657.663358ab.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070126165657.663358ab.akpm@osdl.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > I thought the resolution was that fixing a few of those drivers
> > > > should solve the problem Matthew needed resolved, and that in
> > > > the meanwhile "rmmod drivername" should suffice.  There also seemed
> > > > to be agreement that power management for wireless devices needed
> > > > more work; there might need to be a state between "down/off" and
> > > > "configured and able to talk IP".
> > > 
> > > It's certainly the case that fixing those drivers would result in a 
> > > better long-term situation - however, nobody currently seems to have any 
> > > interest in doing so...
> > 
> > And the way these things work, unfortunately, is that merging your patch
> > would ensure nobody ever gets such interest.  Removing that "state" file
> > (and its bogus infrastructure) has already taken a few years too long.
> > 
> 
> No, we shouldn't just break stuff for our users in the hope that said
> breakage will force some other developer to come in and fix things later.

We are not breaking anything. We just make power consumption go up for
_very_ small minority of our users... and we removed quite a few ways
to oops a kernel that way.

Drivers suspend/resume methods were not designed to be run at runtime;
if you want to re-enable that, you should audit the drivers before
reenable. And at that point, it should be easy to just do it properly.

> We should revert the breakage-causing patch, with the expectation that its
> submitter will ensure that all prerequisites are in place before it is
> reapplied.

Change breaking that was 'introduce suspend early to fix suspend on
mac mini', by Linus, IIRC. So no, it is not easy to revert this one.

> > You imply that it _was_ once supported, which is not true.  Like any
> > other bug (in this case "design bug"), it was there and could be abused.
> > And like some other bugs, fixing it can trigger complaints from (ab)users.
> 
> Could someone please explain in easy-to-understand terms what the
> real-world impact of this bug is upon our users?  How many are affected,
> and under what circumstances, and with what effects?

Oops, if you echo 3 to wrong file, or if you are hit by race.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
