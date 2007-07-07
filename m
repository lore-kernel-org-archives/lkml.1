Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbXGGL4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbXGGL4A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 07:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbXGGLzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 07:55:37 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38269 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753042AbXGGLzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 07:55:31 -0400
Date: Sat, 7 Jul 2007 13:49:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070707114917.GC2789@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0707061034540.3737-100000@iolanthe.rowland.org> <1183779845.3388.206.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183779845.3388.206.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > And guess what ? It's what we do on powerbooks, and it works fine,
> > > without a freezer :-)

Well, issue is, you should stop claiming it works fine until issue
below is fixed... please?

And anyway I believe that current issue (fuse deadlocks with s2ram)
should be present on powerbooks, too... it is just way harder to
trigger. All that is neccessary is fused (or one of its helpers) to
get frozen by accessing suspended device.


									Pavel

> > I wish you'd stop saying that.  Have you ever done any serious testing?
> > 
> > Here's something to try:  Add a time delay to the end of hub_suspend in
> > drivers/usb/core/hub.c, so you can provoke a race manually.  Then while
> > one of your root hubs is being suspended and the system is waiting in
> > that delay, either plug in a new USB device to that hub or unplug an
> > existing device.
> > 
> > Be sure that CONFIG_USB_DEBUG is on so that we can figure out what 
> > happened after the fact.
> 
> If you remember, one of the things I've been advocating has always been
> that we should put on hold all plug activity (unplug might be alright as
> long as the user events are just delayed) when we start suspending. No
> new devices, no new bindings. "hub" type devices are respondible for
> bringing in the new stuff after resume.



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
