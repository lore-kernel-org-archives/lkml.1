Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYCMKMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYCMKMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYCMKLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:11:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35227 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852AbYCMKLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:11:35 -0400
Date: Thu, 13 Mar 2008 08:43:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: akpm@linux-foundation.org, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       mm-commits@vger.kernel.org, dilinger@queued.net, adaplas@pol.net,
       dilinger@debian.org, rjw@sisk.pl
Subject: Re: +
	pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspen
	d-vt-switch.patch added to -mm tree
Message-ID: <20080313074332.GA19117@elf.ucw.cz>
References: <200803120527.m2C5RmWl011967@imap1.linux-foundation.org> <20080312085149.GA3993@ucw.cz> <20080312144506.GE1018@cosmic.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312144506.GE1018@cosmic.amd.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > (Note: I'm not convinced that console_sem is the best way to protect this, but
> > > we should probably have some form of locking..)
> > 
> > I guess this is okay for now, but we probably want to make it more
> > elaborate in future.
> > 
> > Console switch is there to make sure kernel (not X) owns the graphical
> > hardware.
> > 
> > That is unneccessary for gxfb since X never owns graphics hardware,
> > good. (I do not see why it is optional, then. Do you really want to
> > see tty1?)
> 
> Its the dream for the lxfb and gxfb to own the graphics hardware
> completely (at least, thats what Jim Gettys keeps pounding in to my
> brain), but we're not quite there yet.  What we have here are 
> framebuffer drivers that are intelligent enough to save and restore the
> state of the graphics engine, which is still a lot better then most other
> drivers.

Ok.

> > Now, question is what happens with two graphics cards, one of them
> > driven by X. Fortunately that is uncommon.
> 
> We would be screwed.  But since the Geode has built in graphics logic,
> it doesn't make much sense to use an external card, so we'll mostly
> avoid this problem.  But even if it happens, we'll have the VT switch
> available in a pinch.
> 
> > Also, it would be nice to make the logic the other way around. Move vt
> > switching to the drivers that need it because X can be expected to own
> > the hardware.
> 
> Conservation of energy.  Its easier to make 3 or 4 drivers opt out of 

Nice euphemism. You did quick hack instead of proper solution, and
someone will have to clean it up sooner or later...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
