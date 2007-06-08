Return-Path: <linux-kernel-owner+w=401wt.eu-S969094AbXFHO1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969094AbXFHO1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968200AbXFHO1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:27:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38891 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S967337AbXFHO1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:27:44 -0400
Date: Fri, 8 Jun 2007 10:27:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Robert de Rooy <robert.de.rooy@gmail.com>
cc: Jiri Kosina <jikos@jikos.cz>, Greg KH <greg@kroah.com>,
       <Joel.Becker@oracle.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] ThinkPad T41 - Strange USB 2.0 behaviour
In-Reply-To: <Pine.LNX.4.64.0706081217340.23280@twin.jikos.cz>
Message-ID: <Pine.LNX.4.44L0.0706081021400.3473-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Jiri Kosina wrote:

> linux-usb-devel list added
> 
> On Fri, 8 Jun 2007, Robert de Rooy wrote:
> 
> > Jiri Kosina wrote:
> > > On Thu, 7 Jun 2007, Robert de Rooy wrote:
> > >
> > >   
> > > > Yes I figured it was a hardware problem, but that was not really the point
> > > > I was trying to raise ;). I would like, if possible for Linux to
> > > > automatically fallback to USB 1.1 like Windows does (preferably with a
> > > > suitable warning).
> > > >     
> > >
> > > What do you propose as a trigger for the kernel to fallback?
> > >
> > > You can work it around manually, just don't use ehci-hcd, can't you?
> > >
> > >   
> > Yes I can unload ehci-hcd, but I have one USB 2.0 device that strangely enough
> > DOES work as such, and unloading ehci-hcd will cause that also to run at 1.1
> > speed.
> > 
> > Clearly something is failing when plugging a device with ehci-hcd loaded, the
> > driver seems to keep retrying indefinitely. Instead it would be nice if after
> > a few tries it hands the device over to uhci-hcd. This seems to be the
> > behaviour under Windows, so I was wondering if Linux could be made to do
> > something similar.

Robert, it would help somewhat if you could build a kernel with 
CONFIG_USB_DEBUG turned on and post the dmesg log showing what happens 
when you plug in one of those non-working devices.

Yes, in principle Linux can be made to switch over to full speed when 
high speed fails.  But there are limitations: The switchover would work 
only for devices plugged directly into the computer, not for devices 
plugged into a high-speed hub.  And some Linux systems (not regular 
PCs) have EHCI implementations that don't allow such a switch -- or 
if they do, I'm not aware of how to accomplish it.

BTW, depending on the kind of failure the system does not keep 
retrying indefinitely.  It gives up after four attempts.

Alan Stern

