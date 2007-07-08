Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbXGHVIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbXGHVIL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 17:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756965AbXGHVH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 17:07:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35413 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757034AbXGHVH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 17:07:57 -0400
Date: Sun, 8 Jul 2007 23:07:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070708210729.GC5401@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org> <1183871661.3388.282.camel@localhost.localdomain> <200707082115.27363.rjw@sisk.pl> <1183928612.3388.289.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183928612.3388.289.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I just think that the freezer approach, as it is, is backward. We can't
> > > have a 3rd party try to discriminate what to freeze and what not, it
> > > will always get something wrong, and in some cases with the wrong timing
> > > or ordering.
> > 
> > Nice discussion, except for one thing: the freezer doesn't decide what to
> > freeze.  For example, even right now kernel threads decide if they want to be
> > frozen.
> 
> Somewhat... userspace doesn't and workqueues are a gray area.

But userspace must not be neccessary for kernel functioning, so that's
quite okay. And we do need to solve the workqueues.

> Also, I've been thinking this "icebox" idea a bit more and it seems in
> fact a bit racy in some areas, at least for use by things like drivers,
> unless we end up doing something aking to an RCU on suspend, waiting for
> all tasks to reach userland once, but that has the same annoyances as
> the current freezer.
> 
> Thus I'm tempted to go back to saying that driver can handle things
> locally :-)

:-). Or perhaps freezer is not _that_ evil after all?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
