Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbXD0Mkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbXD0Mkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbXD0Mkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:40:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52095 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755765AbXD0Mki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:40:38 -0400
Date: Fri, 27 Apr 2007 14:40:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Johannes Berg <johannes@sipsolutions.net>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: driver power operations (was Re: suspend2 merge)
Message-ID: <20070427124029.GH22250@elf.ucw.cz>
References: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070425203150.GD17387@elf.ucw.cz> <1177669279.7828.55.camel@johannes.berg> <200704271407.00879.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704271407.00879.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > And, incidentally, it could possibly make both suspend and hibernate
> > work much faster too. The comments there talk about "minimally power
> > management aware" drivers which always do the wrong thing for suspend,
> > in that they always reset everything... Of course, some drivers will
> > actually need to do that, but if freeze/suspend and thaw/restart/resume
> > have the same prototypes (probably just int <function>(void)) then
> > drivers can trivially assign the same there.
> > And hibernate would benefit since a lot of drivers could do a lot less
> > work for freeze/thaw.
> 
> I violently agree with all of the above.
> 
> Moreover, for the hibernation we have two special cases that are of no interest
> for the suspend:
> 1) drivers compiled as modules and not loaded before we restore the image
> 2) drivers that need to allocate much memory in .freeze()
> 
> > Or, if we don't want to have five calls and use 40 bytes (on 64-bit)
> > just for these callback pointers for each device we could just as well
> > have a single callback ->pm(what) and make "what" indicate which one of
> > these five things... But then drivers can't make that code depend on the
> > swsusp configuration which would be doable with five callbacks.
> 
> Five callbacks are fine by me, especially if we can define reasonable defaults
> for the hibernation (and can we?).

Well, we still can default to suspend(PMSG_FREEZE) for freeze(), and
resume() for thaw(). Anything else is just not sane way forward.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
