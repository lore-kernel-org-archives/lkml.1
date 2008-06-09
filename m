Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYFIU6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYFIU6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYFIU6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:58:34 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59617 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbYFIU6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:58:33 -0400
Date: Mon, 9 Jun 2008 22:59:16 +0200
From: Pavel Machek <pavel@suse.cz>
To: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linus Torvalds <torvalds@linuxfoundation.org>,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
Message-ID: <20080609205916.GC21429@elf.ucw.cz>
References: <200806091712.46869.oliver@neukum.org> <Pine.LNX.4.44L0.0806091142390.2943-100000@iolanthe.rowland.org> <20080609195015.GA6601@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609195015.GA6601@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-06-09 12:50:15, Greg KH wrote:
> On Mon, Jun 09, 2008 at 11:44:21AM -0400, Alan Stern wrote:
> > On Mon, 9 Jun 2008, Oliver Neukum wrote:
> > 
> > > Am Montag 09 Juni 2008 17:03:10 schrieb Alan Stern:
> > > > On Mon, 9 Jun 2008, Pavel Machek wrote:
> > > > 
> > > > > Besides, it seems to break suspend/resume of printers, and probably
> > > > > all the drivers that do not have reset_resume() method. That's
> > > > > actually a regression.
> > > > > 
> > > > > https://bugzilla.novell.com/show_bug.cgi?id=394820
> > > > 
> > > > The right way to fix this is to add reset_resume to the printer driver.  
> > > 
> > > reset_resume() is supposed to restore all state. The printer driver does
> > > not know which state a printer is in, except for the trivial case of the
> > > printer not being in use, as it doesn't know the meaning of the data
> > > going to the printer.
> > > 
> > > You might argue that you deserve what you get when you hibernate
> > > while printing, but then it makes no sense to implement it anyhow,
> > > disconnection and reconnection work just as well and are cleaner.
> > > The same is true for many devices.
> > 
> > In which case the correct approach is the second one I mentioned (which 
> > you omitted in your reply): Make usbcore unbind drivers that don't 
> > support reset_resume.
> 
> That sounds reasonable to me.  Oliver or Pavel, care to try this out?

I'm not an USB hacker, and 2.6.26 release is pretty near. I do have
USB printer somewhere around, maybe it still works.

But problem is _not_ limited to usblp. usblp is just a part of
problem, the one we caught in testing.

reset_resume() is only implemented in storage/usb.c... while resume()
is pretty widespread in the usb drivers.

I believe we should just revert the "CONFIG_USB_PERSIST force on"
patch, and solve this properly in 2.6.27.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
