Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab0BXWgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 17:36:10 -0500
Received: from perec.tyrell.hu ([66.197.149.104]:37188 "EHLO perec.tyrell.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758178Ab0BXWgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 17:36:08 -0500
Message-ID: <4B85A9D3.6060709@maroy.hu>
Date: Wed, 24 Feb 2010 23:36:03 +0100
From: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device 8087:0020
References: <Pine.LNX.4.44L0.1002241137030.2436-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1002241137030.2436-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

> You can get more information if you enable CONFIG_USB_DEBUG in your
> kernel configuration.  The most likely explanation is that the suspend
> failed because one of the ports on that root hub issued a wakeup
> request.

I tried, and this is what I seem to be getting now:


Feb 24 23:28:52 tonkachi kernel: [  348.733460] PM: Syncing filesystems ...
Feb 24 23:28:52 tonkachi kernel: [  348.903106] done.
Feb 24 23:28:52 tonkachi kernel: [  348.903123] Freezing user space
processes ... (elapsed 0.00 seconds) done.
Feb 24 23:28:52 tonkachi kernel: [  348.903808] Freezing remaining
freezable tasks ... (elapsed 0.00 seconds) done.
Feb 24 23:28:52 tonkachi kernel: [  348.903952] Suspending console(s)
(use no_console_suspend to debug)
Feb 24 23:28:52 tonkachi kernel: [  348.985903] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 24 23:28:52 tonkachi kernel: [  348.987274] PM: resume devices took
0.060 seconds
Feb 24 23:28:52 tonkachi kernel: [  348.987371] Restarting tasks ...
Feb 24 23:28:52 tonkachi kernel: [  348.988165] done.


though I don't see the pm_op() error log anymore..

would this make sense?

actually, the whole USB susbsystem seems to be very fragile - I plug in
a USB device, and the whole system freezes for about 5 seconds or more.
then the device is registered (for example, a mouse). but I unplug and
re-plug, and the device doesn't work anymore...

or I plug in an external USB DVD drive - but if I unplug it, it is still
listed in lsusb..


Akos

