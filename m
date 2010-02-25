Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab0BYP1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:27:36 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36129 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759190Ab0BYP1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:27:34 -0500
Date: Thu, 25 Feb 2010 10:27:34 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device
 8087:0020
In-Reply-To: <4B85A9D3.6060709@maroy.hu>
Message-ID: <Pine.LNX.4.44L0.1002251020100.1686-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010, Ákos Maróy wrote:

> Alan,
> 
> > You can get more information if you enable CONFIG_USB_DEBUG in your
> > kernel configuration.  The most likely explanation is that the suspend
> > failed because one of the ports on that root hub issued a wakeup
> > request.
> 
> I tried, and this is what I seem to be getting now:
> 
> 
> Feb 24 23:28:52 tonkachi kernel: [  348.733460] PM: Syncing filesystems ...
> Feb 24 23:28:52 tonkachi kernel: [  348.903106] done.
> Feb 24 23:28:52 tonkachi kernel: [  348.903123] Freezing user space
> processes ... (elapsed 0.00 seconds) done.
> Feb 24 23:28:52 tonkachi kernel: [  348.903808] Freezing remaining
> freezable tasks ... (elapsed 0.00 seconds) done.
> Feb 24 23:28:52 tonkachi kernel: [  348.903952] Suspending console(s)
> (use no_console_suspend to debug)
> Feb 24 23:28:52 tonkachi kernel: [  348.985903] xhci_hcd 0000:02:00.0:
> WARN: short transfer on control ep
> Feb 24 23:28:52 tonkachi kernel: [  348.987274] PM: resume devices took
> 0.060 seconds
> Feb 24 23:28:52 tonkachi kernel: [  348.987371] Restarting tasks ...
> Feb 24 23:28:52 tonkachi kernel: [  348.988165] done.
> 
> 
> though I don't see the pm_op() error log anymore..
> 
> would this make sense?

You should not be looking at the system log file; you should use the 
output from dmesg.

By the way, I noticed above that you have xhci-hcd installed.  As far 
as I know, that driver does not yet support system suspend.  You should 
try unloading xhci-hcd before doing the suspend (both with and without 
CONFIG_USB_DEBUG).

> actually, the whole USB susbsystem seems to be very fragile - I plug in
> a USB device, and the whole system freezes for about 5 seconds or more.
> then the device is registered (for example, a mouse). but I unplug and
> re-plug, and the device doesn't work anymore...
> 
> or I plug in an external USB DVD drive - but if I unplug it, it is still
> listed in lsusb..

These separate issues deserve to be investigated more closely.  The USB 
stack is not supposed to be that fragile.  Describe your environment 
more fully and provide the dmesg log from a kernel with 
CONFIG_USB_DEBUG enabled showing what happens during the experiments.

Alan Stern

