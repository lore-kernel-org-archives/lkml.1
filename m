Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbYCNOeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbYCNOeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYCNOeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:34:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60534 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752284AbYCNOeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:34:07 -0400
Date: Fri, 14 Mar 2008 10:34:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tino Keitel <tino.keitel@gmx.de>
cc: Jiri Kosina <jkosina@suse.cz>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: broken access to a USB HID device after suspend
In-Reply-To: <20080314071336.GA14550@dose.home.local>
Message-ID: <Pine.LNX.4.44L0.0803141020190.4478-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008, Tino Keitel wrote:

> On Thu, Mar 13, 2008 at 14:59:48 -0400, Alan Stern wrote:
> 
> [...]
> 
> > > Well, it seems to be "fixed" by a suspend/resume cycle. Do you have
> > > a
> > > hint how I could try to fix it without suspend/resume, to test if
> > > it is
> > > really the LCD's fault?
> >
> > Testing has to come before fixing -- you can't fix the problem if you
> > don't know which component is at fault.  For all we know, the
> > hardware
> > could be fine and the problem could lie in your application.
> 
> I meant a method other than suspend/resume to fix the broken behaviour,
> so that we get an indication where the problem exactly is.

There's the blunt-force method: Buy a new LCD device.  That's not 
entirely a joke; the information you have provided so far indicate a
fairly high probability that your device is broken.  (Although a new 
device might also be broken in exactly the same way...)

> > All I can think of for testing is to use usbmon to record the data
> > transfers when those -110 errors come up.
> 
> Well, I still don't have USB_DEBUG or usbmon enabled, but I just got
> that error again. I pulled the power plug from the LCD and replugged
> it, without success. Then I did a suspend/resume cycle, and it worked.

I was going to suggest that something might be going wrong with the
data toggles.  But if that were the problem then cycling the power on
the device would definitely have fixed it.

When you get these errors, do you exit from the hidmon program and 
restart it?  Do the errors still occur after restarting?

My earlier suggestions remain: Use CONFIG_USB_DEBUG and usbmon.  
However without knowing what requests the device will accept and what 
its responses ought to be, it will be very difficult to debug this
problem.

Alan Stern

