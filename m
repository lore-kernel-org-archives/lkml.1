Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbYFJO72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbYFJO72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYFJO7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:59:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46445 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753745AbYFJO7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:59:19 -0400
Date: Tue, 10 Jun 2008 10:59:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Pavel Machek <pavel@suse.cz>, <linux-usb@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linuxfoundation.org>,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
In-Reply-To: <200806101055.14539.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0806101057500.2709-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Oliver Neukum wrote:

> Am Montag 09 Juni 2008 23:56:51 schrieb Pavel Machek:
> > On Mon 2008-06-09 14:39:10, Linus Torvalds wrote:
> > > 
> > > 
> > > On Mon, 9 Jun 2008, Pavel Machek wrote:
> > > > 
> > > > I believe we should just revert the "CONFIG_USB_PERSIST force on"
> > > > patch, and solve this properly in 2.6.27.
> > > 
> > > Why?
> > > 
> > > The code would _still_ be buggy with that revert in place. You have to 
> > > enable CONFIG_USB_PERSIST just to get even the _possibility_ of the sane 
> > > behavior. 
> > > 
> > > If there is a problem with usblp, it just needs to be fixed. 
> > 
> > With USB_PERSIST on, you have problem on all drivers but usb-storage,
> > AFAICT... because usb-storage seems to be the only driver implementing
> > reset_resume.
> > 
> > I guess it is possible to do something like "if reset_resume() is
> > unavailable, try plain resume()" in usb/driver.c, but I'd really
> > changes to the suspend/resume callback to go in -rc1 so that they are
> > tested properly, and not hot-patch it now.
> 
> If a hotfix it must be, here's my take. It works for me, but it isn't
> tested well.
> Alan, what do you think?

I don't have time right now to check it; will do so later today.  At 
first glance it seems okay -- it doesn't cover absolutely all the 
cases, but it does cover system sleep transitions.  And it's clearly 
better than what Linus proposed.

Alan Stern

