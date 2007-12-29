Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbXL2Wx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbXL2Wx2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 17:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbXL2WxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 17:53:21 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54535 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbXL2WxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 17:53:20 -0500
Date: Sat, 29 Dec 2007 23:51:34 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] sleepy linux
Message-ID: <20071229235134.GC17823@ucw.cz>
References: <20071225230731.GA29030@elf.ucw.cz> <200712262123.37152.oliver@neukum.org> <20071226203258.GE8094@elf.ucw.cz> <200712271041.30923.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712271041.30923.oliver@neukum.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ... I also don't need to call any suspend() routines, because all the
> > drivers are already suspended, right?
> 
> Well, you have a number of devices which cannot do runtime pm.
> They can do suspend/resume with the whole system. For them these
> operations mean saving/restoring state.
> So for these devices implementing autosuspend makes no sense.
> They would sensibly do only idle/busy detection.

Yep... Let's call busy/idle detection and save/restore state
"autosuspend" for those devices. It does not save any power, but it
can be viewed as "kind-of-suspend". (No, I do not have this kind of
details ready).

> > And yes, I want device activity to prevent s2ram. If user is burning
> > CD, machine should not sleep. If user is actively typing, machine
> 
> In these cases the devices involved should report themselves busy,
> shouldn't they?

Yes.

> > should not sleep. My vision is: screen saver tells kernel keyboard
> > need not be very responsive, at that point keyboard driver can
> > autosuspend the keyboard, and if that was the last device, whole
> > system sleeps.
> 
> We lack a notion of telling devices that they are opened only for
> detecting wakeups. Currently a driver has to assume that an opened
> device has to be fully functional.

Yes, we'll need to add some userland interfaces. No, this will not be
easy.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
