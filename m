Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYFITz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYFITz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbYFITzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:55:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:46325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbYFITzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:55:19 -0400
Date: Mon, 9 Jun 2008 12:50:15 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Pavel Machek <pavel@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linus Torvalds <torvalds@linuxfoundation.org>,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
Message-ID: <20080609195015.GA6601@suse.de>
References: <200806091712.46869.oliver@neukum.org> <Pine.LNX.4.44L0.0806091142390.2943-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0806091142390.2943-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 11:44:21AM -0400, Alan Stern wrote:
> On Mon, 9 Jun 2008, Oliver Neukum wrote:
> 
> > Am Montag 09 Juni 2008 17:03:10 schrieb Alan Stern:
> > > On Mon, 9 Jun 2008, Pavel Machek wrote:
> > > 
> > > > Besides, it seems to break suspend/resume of printers, and probably
> > > > all the drivers that do not have reset_resume() method. That's
> > > > actually a regression.
> > > > 
> > > > https://bugzilla.novell.com/show_bug.cgi?id=394820
> > > 
> > > The right way to fix this is to add reset_resume to the printer driver.  
> > 
> > reset_resume() is supposed to restore all state. The printer driver does
> > not know which state a printer is in, except for the trivial case of the
> > printer not being in use, as it doesn't know the meaning of the data
> > going to the printer.
> > 
> > You might argue that you deserve what you get when you hibernate
> > while printing, but then it makes no sense to implement it anyhow,
> > disconnection and reconnection work just as well and are cleaner.
> > The same is true for many devices.
> 
> In which case the correct approach is the second one I mentioned (which 
> you omitted in your reply): Make usbcore unbind drivers that don't 
> support reset_resume.

That sounds reasonable to me.  Oliver or Pavel, care to try this out?

thanks,

greg k-h
