Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbZCENqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbZCENqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbZCENpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:45:40 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40804 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbZCENpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:45:39 -0500
Date: Thu, 5 Mar 2009 14:48:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arve Hj?nnev?g <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090305134806.GA1697@elf.ucw.cz>
References: <200902190004.18878.rjw@sisk.pl> <Pine.LNX.4.44L0.0902181826500.23001-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0902181826500.23001-100000@iolanthe.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-02-18 18:31:15, Alan Stern wrote:
> On Thu, 19 Feb 2009, Rafael J. Wysocki wrote:
> 
> > > If some devices are autosuspended after a local inactivity timeout, I
> > > don't want to wait for those devices to autosuspend if I know the code
> > > that needed to run is done. This could cause delays in the normal
> > > case,
> > 
> > Isn't it a matter of adjusting the inactivity timeouts in a suitable way?
> 
> It's not that simple.  A single device driver has a very local view, 
> not suitable for deciding whether the entire system should go to sleep.
> 
> So for example, a disk driver might think it's appropriate to spin down 
> the disk after 10 seconds of inactivity.  But an overall system monitor 
> might realize that nothing is going on right now and want to put the 
> system to sleep immediately, without waiting the 10 seconds for the 
> disk to autosuspend.

Hmm, I'm not sure. If system is so busy that it keeps the disk up, it
may not be good idea to sleep whole system.

Example: "idle fileserver". Current command is done, so we seem to be
idle; but when we sleep, new command comes. While system really is
idle, it is bad idea to suspend.

If the overall system monitor can decide disk will not be used, it can
just sleep the disk.

> > > and it could prevent suspend if a background process (not using
> > > wakelocks) is accessing a disk more frequently than its idle timeout.
> > 
> > Well, actually, shouldn't it prevent suspend from happening?  Arguably, it just
> > means that the disk is continuously being accessed with respect to the inactive
> > timeout granularity.
> 
> That's true, but it shows the problem of making the autosleep decision
> based on disk activity.  An auto-sleep should not have to wait for
> every device (or some suitable subset) to become idle for some minimum
> time; it should be able to kick in at short notice.

I believe we do want to wake for timeouts, as not all sources of
wakeup are local.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
