Return-Path: <linux-kernel-owner+w=401wt.eu-S1761001AbZGIOTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761001AbZGIOTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760949AbZGIOS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:18:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58352 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760826AbZGIOS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:18:57 -0400
Date: Thu, 9 Jul 2009 10:18:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Michael S. Zick" <lkml@morethan.org>
cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Null Pointer BUG in uhci_hcd
In-Reply-To: <200907081731.33106.lkml@morethan.org>
Message-ID: <Pine.LNX.4.44L0.0907090950590.5823-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jul 2009, Michael S. Zick wrote:

> It is unlikely that VIA Tech. will recall the CX700 chipset.
> 
> So being able to take a device off-line (like the driver claims it is doing)
> and *leave* it off-line - until told to "try again" - that would be an
> improvement.

Sorry, you lost me there.  In all the logs you have posted, I can find 
only one line where the kernel claims to be taking a device offline:

> Jun 30 10:38:31 cb01 kernel: sd 2:0:0:0: Device offlined - not ready after error recovery

And in that case it _did_ leave the device offline.  So what are you
concerned about?


> The current process of filling up the /var/log directory until the machine
> chokes is a rather fragile sort of response to a hot-plugged device, good or bad.

It isn't a response to a hot-plugged device; it's a response to broken
hardware.  If your hardware was working properly you could hot-plug
and hot-unplug devices 'till you turned blue in the face, without
filling up the /var/log directory.


> > > > I suspect it's worse than a simple interrupt-routing mistake.
> > > > 
> > > 
> > > I would not object to your removing that one mistake - that is one less
> > > to contend with.
> > 
> > I didn't say there was an interrupt-routing mistake; I said it was 
> > _worse_ than an interrupt-routing mistake.
> > 
> 
> Never claimed you did - the driver made that claim.
> But still, it would be nice to get rid of the interrupt-routing mistake.

How can you get rid of an interrupt-routine mistake if there is no such 
mistake in the first place?

Not that I'm claiming there is no such mistake -- the logs you have 
provided aren't clear in this respect.  So that's the first issue to 
address: Determine whether the interrupts are or aren't being routed 
correctly.

To that end, you should try doing some more directed testing.

Start with a nice cold boot, with no USB devices plugged in.  Copy the 
dmesg log and clear the kernel's log buffer.  And just to get as much 
information as possible, start a process copying usbmon's 0u file 
(you'll have to enable CONFIG_USB_MON if it isn't already enabled).

Then plug in a high-speed device.  When everything settles down, copy
the dmesg buffer again and also get a copy of the
/sys/kernel/debug/ehci/0000:00:10.4/registers file.  Those, together 
with the usbmon trace, will provide a good starting point.

Assuming something goes wrong, of course.  If everything works okay, 
you'll have to keep trying similar experiments (plugging and unplugging 
devices) until something breaks.

Alan Stern

