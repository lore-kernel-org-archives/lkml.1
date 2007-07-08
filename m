Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbXGHXDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbXGHXDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 19:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbXGHXDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 19:03:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:32956 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752154AbXGHXDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 19:03:11 -0400
Date: Mon, 9 Jul 2007 01:03:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: hibernation/snapshot design [was Re: [PATCH] Remove process freezer from suspend to RAM pathway]
Message-ID: <20070708230300.GI5401@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org> <1183931688.3388.316.camel@localhost.localdomain> <20070708221315.GF5401@elf.ucw.cz> <200707090101.28832.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707090101.28832.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Freezer is not needed for snapshot -- it is needed so that we can
> > write out the snapshot to disk without the need for special
> > drivers/block/simple-ide-for-suspend.c. (We are doing snapshot, then
> > write to disk from userland code in uswsusp).
> 
> Yes.
> 
> BTW, this patch:
> 
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc7/patches/15-freezer-make-kernel-threads-nonfreezable-by-default.patch
> 
> that's queued up in -mm contains a freezer documentation update, in which the
> reasons of using it, as well as its limitations, are described.
> 
> To summarize what was previously said in this thread:
> 
> * Apparently, we agree that the freezer is _generally_ not needed for suspend
>   (ie. any transition to a system sleep state other than hibernation), but some
>   of us (eg. me) think that it wouldn't be reasonable to drop the freezer from
>   the suspend code path _right_ _now_ .
> 
> * Some of us, including you, Nigel and me, think that the freezer is needed
>   for hibernation (please see the document in the patch above for details).
>   In the (very) long run this might be avoided too, but (IMO) certainly not at
>   this point.
> 
> * We seem to agree that in order to remove the freezer from the suspend code
>   path some work needs to be done on device drivers, driver midlayers and the
>   PM core.  We also need to do some work on the PM core in order to introduce
>   a separate hibernation framework and IMO it would be reasonable to
>   synchronize these efforts.
> 
> * We are now to decide what to do so that the freezer can be safely removed
>   from the suspend code path and how to integrate that change with the
>   hibernation code path (if possible and reasonable).

Nice summary, thanks.

> * The freezer vs FUSE issue that started this thread remains unresolved, so
>   it would be desirable to provide a short-term fix (need not be very nice).

Actually there are _2_ freezer vs FUSE issues, and one of them should
be simple to solve, once we have sysrq-t of the deadlock. (Or did I
miss it somewhere with discussion going on 10 lists in parallel?)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
