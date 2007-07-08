Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbXGHVCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbXGHVCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 17:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbXGHVCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 17:02:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44429 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756806AbXGHVCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 17:02:05 -0400
Date: Sun, 8 Jul 2007 23:01:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070708210158.GB5401@elf.ucw.cz>
References: <1183871661.3388.282.camel@localhost.localdomain> <Pine.LNX.4.44L0.0707081517540.11049-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0707081517540.11049-100000@netrider.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > There are two things I believe. There's a generic issue with usermode
> > helpers that make no sense to call between pre-suspend and
> > post-resume, and there's the specific issue of adding/removing
> > devices.
> > 
> > I believe that "bus" drivers such as USB should indeed get a first
> > round of notifications to tell them to stop performing bus
> > plug/unplug operations (it's debatable whether we want to keep unplug
> > going provided we can stack up the usermode events and re-send them
> > later though, but let's say no for the sake of simplicity).
> 
> Yes.  Rafael, how close is your new notifier chain to mainline?  Can it 
> at least be added to Greg KH's development tree so that I can start 
> using it?

It should be in -mm, IIRC.

> > I think it's a fairly significant change from the current freezer and I
> > also think it's a very good idea. The more I think about it, the more I
> > like it, in the sense that it's a simple drop-in that you could put in a
> > lot of the ioctl path of drivers to just block tasks that are trying to
> > call in while suspending, and could be used selectively by things like
> > the USB hub threads.
> 
> That's what I had in mind.  Rafael, can we add an "icebox" routine?  
> Like Ben says, it doesn't need to be much more than a waitqueue
> that the current task puts itself on if a suspend is in progress.  
> Callers arriving at a time when the icebox isn't activated should
> simply return without blocking.  Basically the icebox should be active 
> at the same times as the existing freezer.

You could use try_to_freeze(), but you want it to be separate routine
so it can be grepped for... Can you #define icebox_me try_to_freeze
for testing?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
