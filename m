Return-Path: <linux-kernel-owner+w=401wt.eu-S1759731AbXGEJa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731AbXGEJa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758852AbXGEJaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:30:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35359 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758810AbXGEJaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:30:16 -0400
Date: Thu, 5 Jul 2007 11:30:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070705093013.GA3228@elf.ucw.cz>
References: <20070703042916.GA17240@srcf.ucam.org> <200707031608.06348.nigel@nigel.suspend2.net> <1183447184.10386.102.camel@localhost.localdomain> <200707031456.40890.rjw@sisk.pl> <1183497290.3388.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183497290.3388.4.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >  - For STR, don't do the freezer thing.
> > 
> > In the long run, I agree.
> > 
> > Still, can you please read this post from Alan Stern:
> > 
> > https://lists.linux-foundation.org/pipermail/linux-pm/2007-June/012847.html
> > 
> > ?  I don't think I'm able to repeat the arguments given in there in a
> > convincing way.
> 
> That's the same crackpot I've been hearing for the past 3 years or
> so ...
> 
> Both Paulus and I think the freezer is just a way to try to put your
> head in the sand and ignore the problem. It causes as many problems as
> it solves on its own, and is just not a solution that will be of any use
> once you start implementing dynamic PM schemes etc...

Well, yep, you can view freezer as a head in the sand...

> In many cases, having proper support for "live" suspend of devices is
> just a matter of having a couple of helpers in whatever subsystem those
> drivers hookup with. In the case of network, for example, it's mostly
> trivial (stop the queue). For block, it's not terribly hard neither,
> though you want to have some orderign/atomicity between the blocking of
> the incoming request queue and the sending of things like spindown &
> flush commands to the disk. For old-style IDE, that was fairly easily
> solved by piping suspend/resume command down the request queue itself
> and have the queue block/unblbock itself after processing them. Some of
> that logic could maybe be moved to the block layer for all block drivers
> to benefit.

...but the moment you start blocking tasks that done driver request,
you _do_ have mini-freezer of your own, with pretty much the same
problems.

In another message I shown that removing freezer will not help with
FUSE in general case.

It probably does not help with firmware, too; as soon as udev attempts
to do something with your wireless card, it is blocked, and if the
wireless card needs the firmware from udev, you are deadlocked.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
