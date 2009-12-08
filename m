Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbZLHPDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbZLHPDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbZLHPDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:03:53 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39007 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755826AbZLHPDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:03:52 -0500
Date: Tue, 8 Dec 2009 10:03:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
In-Reply-To: <200912081004.00055.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.0912080958050.3046-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009, Ondrej Zary wrote:

> > You don't have to compile either driver into the kernel.  Try doing
> > this:
> >
> > 	rmmod ehci-hcd
> >
> > 	dmesg -c >/dev/null (clear the log buffer)
> >
> > 	Start up usbmon on the 0u file
> >
> > 	Plug in the hub, which attaches to UHCI
> >
> > 	modprobe ehci-hcd
> > 	At this point the hub should switch over to EHCI
> >
> > It will make things easier to understand if you unplug all other USB
> > devices first.  Let's see what that shows, both in usbmon and in dmesg.
> >
> > It would be nice if the EHCI controller turned out to be at fault.
> > Then we could blame this entire problem on the controller hardware.  :-)
> 
> OK, all USB devices disconnected, except for that mass storage card reader
> which is built-in.
> 
> Strange, it worked fine:

...

> Tried multiple times with different devices (except the Nexio) connected and it
> always worked. Everything reconnected to ehci after loading the moduled.

Then you should try again in the original configuration to see if it 
still happens.  If it all works right, forget about it and let's move 
on.

To start, you could modify those debugging lines I had you put in.  As 
well as printing out qh->qh_next, also print ((unsigned long) 
qh->hw_next) with a %lx format specifier.

Alan Stern

