Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbYFIPob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbYFIPob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYFIPoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:44:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35758 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751024AbYFIPoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:44:23 -0400
Date: Mon, 9 Jun 2008 11:44:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Pavel Machek <pavel@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linus Torvalds <torvalds@linuxfoundation.org>, <gregkh@suse.de>,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
In-Reply-To: <200806091712.46869.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0806091142390.2943-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008, Oliver Neukum wrote:

> Am Montag 09 Juni 2008 17:03:10 schrieb Alan Stern:
> > On Mon, 9 Jun 2008, Pavel Machek wrote:
> > 
> > > Besides, it seems to break suspend/resume of printers, and probably
> > > all the drivers that do not have reset_resume() method. That's
> > > actually a regression.
> > > 
> > > https://bugzilla.novell.com/show_bug.cgi?id=394820
> > 
> > The right way to fix this is to add reset_resume to the printer driver.  
> 
> reset_resume() is supposed to restore all state. The printer driver does
> not know which state a printer is in, except for the trivial case of the
> printer not being in use, as it doesn't know the meaning of the data
> going to the printer.
> 
> You might argue that you deserve what you get when you hibernate
> while printing, but then it makes no sense to implement it anyhow,
> disconnection and reconnection work just as well and are cleaner.
> The same is true for many devices.

In which case the correct approach is the second one I mentioned (which 
you omitted in your reply): Make usbcore unbind drivers that don't 
support reset_resume.

Alan Stern

