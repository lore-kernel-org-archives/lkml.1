Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab0BCSJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 13:09:48 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42654 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750791Ab0BCSJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 13:09:46 -0500
Date: Wed, 3 Feb 2010 13:09:45 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Corey Wright <undefined@pobox.com>
cc: Greg KH <gregkh@suse.de>, <stable@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: regression in 2.6.27.45 with usb and suspend-to-disk
In-Reply-To: <20100203115956.cb479447.undefined@pobox.com>
Message-ID: <Pine.LNX.4.44L0.1002031306220.1260-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010, Corey Wright wrote:

> > Please build a kernel with CONFIG_USB_DEBUG enabled and post a dmesg 
> > log showing the problem during the second hibernation attempt.
> 
> [  675.443474] PM: Syncing filesystems ... done.
> [  675.576353] Freezing user space processes ... (elapsed 0.00 seconds)
> done.
> [  675.606968] Freezing remaining freezable tasks ... (elapsed 0.00
> seconds) done.
> [  675.629249] PM: Shrinking memory...  -\|done (3129 pages freed)
> [  679.547522] PM: Freed 12516 kbytes in 3.90 seconds (3.20 MB/s)
> [  679.565065] Suspending console(s) (use no_console_suspend to debug)
> [  679.585425] uhci_hcd 0000:00:10.0: release dev 2 ep81-INT, period 8,
> phase 4, 118 us
> [  679.585453] hub 2-0:1.0: hub_suspend
> [  679.585460] usb usb2: bus suspend
> [  679.585463] usb usb2: suspend_rh
> [  679.585534] hub 1-0:1.0: hub_suspend
> [  679.585538] usb usb1: bus suspend
> [  679.585542] ehci_hcd 0000:00:10.4: suspend root hub
> [  679.585547] ehci_hcd 0000:00:10.4: suspend failed because port 8 is
> resuming

There you have it.  What is the USB device attached to port 8 on bus 1 
(i.e., /sys/bus/usb/devices/1-8)?

And what happens if you do:

	echo disabled >/sys/bus/usb/devices/1-8/power/wakeup

before trying to hibernate?

Alan Stern

