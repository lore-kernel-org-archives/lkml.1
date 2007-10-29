Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbXJ2OWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbXJ2OWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbXJ2OWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:22:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51338 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752466AbXJ2OWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:22:06 -0400
Date: Mon, 29 Oct 2007 10:22:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dtor@insightbb.com>
cc: linux-input@atrey.karlin.mff.cuni.cz, Adrian Bunk <bunk@kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       Nick Sillik <n.sillik@temple.edu>, David Brownell <david-b@pacbell.net>,
       Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [linux-usb-devel] [RFC: 2.6 patch] remove the USB_STORAGE_ONETOUCH
 driver
In-Reply-To: <200710282238.11692.dtor@insightbb.com>
Message-ID: <Pine.LNX.4.44L0.0710291017520.4550-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, Dmitry Torokhov wrote:

> On Sunday 28 October 2007 16:39, Jiri Kosina wrote:
> > On Sun, 28 Oct 2007, Torsten Kaiser wrote:
> > 
> > > But it looks like that uses another driver:
> > > hiddev0hidraw1: USB HID v1.10 Device [Western Digital External HDD] on
> > > usb-0000:00:02.1-5.2
> > > Otherwise I would be willing to try to test this, if someone would tell 
> > > me how to check that the second commit did fix the suspend problem.
> > 
> > If you need to unbind usbhid driver from the device and bind another one, 
> > you can use the 'unbind' and 'bind' files in sysfs.
> > 
> > As soon as the driver you are willing to test is bound to the device, you 
> > can go ahead with testing any functionality you wish (probably 
> > suspend/resume cycle is needed here?).
> > 
> > If the device is claimed by usbhid driver (because its descriptor probably 
> > states that it's HID-compliant device) and should be claimed by another 
> > driver, it's necessary to add it to usbhid blacklist -- just let me know.
> > 
> 
> Maybe onetouch driver is not needed after all. I wonder what key/button does
> HID deriver reports when it binds to it... Torsten, could you please post
> your /proc/bus/input/devices?

You guys all sound confused about this.

The original reason writing for the onetouch driver was because the
button on this disk drive isn't an HID device!  That is, the drive
doesn't include any of the usual HID descriptors for the button and the
button doesn't send HID-style reports.

Torsten's assessment was correct.  Originally there was no PM support 
for the onetouch driver.  Now there is (although it isn't very good), 
so it would be legitimate to remove the !PM condition.

As far as I know, the only person who ever used the onetouch driver was 
its author.

Alan Stern

