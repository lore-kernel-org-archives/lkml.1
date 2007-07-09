Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbXGIO44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbXGIO44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 10:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbXGIO4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 10:56:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:55591 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753512AbXGIO4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 10:56:46 -0400
Date: Mon, 9 Jul 2007 16:57:17 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070709145717.GA3492@stusta.de>
References: <Pine.LNX.4.44L0.0707081517540.11049-100000@netrider.rowland.org> <200707090847.43378.oliver@neukum.org> <1183972420.5961.26.camel@localhost.localdomain> <200707091123.57400.oliver@neukum.org> <1183973636.5961.37.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1183973636.5961.37.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 07:33:56PM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2007-07-09 at 11:23 +0200, Oliver Neukum wrote:
> > Suspension is to be transparent. Apart from a jump in the system clock
> > user space must not notice, thus returning errors due to suspension is
> > not an option.
> 
> Who says ?
> 
> If I'm talking to a USB printer, it will notice the USB bus being
> suspended, believe me. It's actually likely to screw up whatever job is
> in progress. It make perfect sense to error out attempts to talk to it
> when suspended.
> 
> I don't think "transparent" is an absolute requirement. In some cases,
> it doesn't make sense and the printer is a good example of that. The
> printing daemon is typically something that will ideally need to grow
> knowledge about suspend/resume to interrupt things at the right time.
> 
> That's one of the thing... we don't even have the kernel right, so we
> are light-years from having the rest of userland right.
> 
> For example, from a user point of view, what should happen if you
> suspend while printing ?

There might be other existing things with a semantics that might be 
worth looking at, e.g.:

I don't have an USB printer, but what happens if you unplug the printer 
while printing, wait 30 seconds, and plug it in again?
Wait 3 hours?

Could this work theoretically?
Does it work in practice?

This are non-theoretical use cases kernel and userspace already somehow 
handle today, and for userspace an USB printer disconnected for 3 hours 
and a 3 hour suspend might simply be the same with the latter not 
requiring any extra userspace handling.

Another example might be mounted NFS file systems:

The case that a client's ethernet cable gets unplugged for 24 hours and 
plugged in again is a real life use case NFS and all applications 
already have to handle.

> Well, it's a matter of policy (thus should be configurable), but I would
> exect (as a former Mac user) something around the lines of this as a
> default:
> 
>  - If the laptop's clamshell has been closed, it's likely that the
> user's just picking up the laptop for a ride, makes sense to abort jobs
> in progress.
> 
>  - If this is a manual action via the menus, displaying a dialog asking
> if you really want to suspend before your page is finished makes sense
> (with that dialog disappearing and the machine going to sleep if you
> just wait and let it print).
> 
> That sort of thing requires much more than just kernel collaboration of
> course, but a whole infrastructure in userland as well.
> 
> So no, suspend is -not- transparent, doesn't have to be, it's something
> that is to be decided on a case-by-case basis (or rather,
> driver-per-driver and possibly via policy settings).

But keep in mind that every piece that does not work transparently 
might result in less use cases for suspend.

There are cases like CD burning while suspending that might not be 
solvable, but as much as possible should work as transparently as 
possible.

> Ben.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

