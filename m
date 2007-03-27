Return-Path: <linux-kernel-owner+w=401wt.eu-S933306AbXC0RBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbXC0RBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933761AbXC0RBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:01:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57860 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933306AbXC0RBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:01:24 -0400
Date: Tue, 27 Mar 2007 13:01:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tino Keitel <tino.keitel@gmx.de>
cc: Oliver Neukum <oneukum@suse.de>, <linux-usb-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] possible USB regression with 2.6.21-rc4: iPod
 doesn't work
In-Reply-To: <20070326223359.GA4942@dose.home.local>
Message-ID: <Pine.LNX.4.44L0.0703271255120.2558-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007, Tino Keitel wrote:

> On Tue, Mar 27, 2007 at 00:21:24 +0200, Tino Keitel wrote:
> 
> [...]
> 
> > this is the bisect result:
> > 
> > $ git bisect good
> > 1d619f128ba911cd3e6d6ad3475f146eb92f5c27 is first bad commit
> > commit 1d619f128ba911cd3e6d6ad3475f146eb92f5c27
> 
> I just tested 2.6.21-rc5 with this commit reverted and the iPod was
> regognized with CONFIG_USB_SUSPEND enabled.

It's hard to figure out what's going on with your system for several 
reasons.  For one thing, you've mentioned at least 3 different peculiar 
behaviors.  For another, you posted logs with lots of extra information 
that tends to hide the important parts.  And also you have lots of USB 
devices, which makes it hard to see what's happening with the iPod.


So here's what I want you to do.  To begin with, unplug _all_ your USB 
devices.  Then do "dmesg -c >/dev/null" to clear the kernel log buffer.

After waiting a few seconds, plug the iPod in to the computer.  After a 
few seconds, make a copy of /sys/class/usb_host/usb_host1/registers.  Then 
unplug the iPod.

After waiting a few more seconds, plug in your hub.  Wait a few seconds 
and then plug the iPod into the hub.  After a few seconds, make another 
copy of /sys/class/usb_host/usb_host1/registers.  Then unplug the iPod and 
the hub.  Finally, get a copy of the dmesg log.


After having done all that, repeat it exactly but this time using a 
version of ehci-hcd with that patch reverted.  Post everything and we'll 
see how it looks.

Alan Stern

