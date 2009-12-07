Return-Path: <linux-kernel-owner+w=401wt.eu-S935311AbZLGPWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935311AbZLGPWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935271AbZLGPWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:22:37 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60890 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935267AbZLGPWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:22:36 -0500
Date: Mon, 7 Dec 2009 10:22:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
In-Reply-To: <200912071002.54308.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.0912071015180.3064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Ondrej Zary wrote:

> > > diff between ehci and uhci logs:
> > > There seems to be some problem with timing.
> > > Also order of ehci_usb vs uhci_usb loading changes.
> >
> > That order doesn't matter much.  But this...
> 
> Looks like it does matter. I compiled ehci_hcd in kernel and left uhci_hcd as 
> module - and the hub was always attached to ehci. Compiled uhci_hcd in kernel 
> and ehci_hcd as module - and it was always attached to uhci. So the HW is 
> probably OK.

As a matter of fact, it probably isn't.  The hub should have switched
over to EHCI when the module was loaded.  The question remains whether 
the problem is in the hub or in the EHCI controller.

You don't have to compile either driver into the kernel.  Try doing
this:

	rmmod ehci-hcd

	dmesg -c >/dev/null (clear the log buffer)

	Start up usbmon on the 0u file

	Plug in the hub, which attaches to UHCI

	modprobe ehci-hcd
	At this point the hub should switch over to EHCI

It will make things easier to understand if you unplug all other USB 
devices first.  Let's see what that shows, both in usbmon and in dmesg.

It would be nice if the EHCI controller turned out to be at fault.  
Then we could blame this entire problem on the controller hardware.  :-)

Alan Stern

