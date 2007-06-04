Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbXFDLBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbXFDLBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 07:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbXFDLA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 07:00:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59901 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752287AbXFDLA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 07:00:58 -0400
Date: Mon, 4 Jun 2007 13:00:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Message-ID: <20070604110052.GI4363@elf.ucw.cz>
References: <20070528205727.GA5911@ucw.cz> <Pine.LNX.4.44L0.0705281719200.10323-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0705281719200.10323-100000@netrider.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > The theoretical answer is that it behaves the way we want.  The kernel 
> > > thread does selective resumes in response to device requests.  If such 
> > > a request comes in while the system is asleep it will awaken the 
> > > system; so it's only logical that a request coming in while the system 
> > > is in the process of going to sleep should abort the suspend.
> > 
> > I'd say that it shows ppc being broken. User wanted to suspend the
> > system, and now unrelated task did lsusb... and system will not sleep.
> > 
> > AFAICT it is DoS issue -- if one of your users keeps doing lsusb, root
> > will not be able to suspend the system.
> 
> This is a matter of one's philosophy.  In suspend-to-RAM, should tasks
> be frozen or should I/O queues be frozen?
> 
> With the USB subsystem I have followed the approach taken by the PM
> core, which is that tasks are frozen.  But one can -- and Linus has on
> at least one occasion -- make a good case that tasks should be left
> running while only I/O is frozen.  This would require the subsystem to
> distinguish between a selective device suspend and a system-wide
> suspend-to-RAM, so that selective resume could be enabled on demand in
> one case but not the other.
> 
> It's quite doable in principle -- it's just not the technique I used.

I guess we need to do that. Random user should not be able to prevent
machine from sleeping.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
