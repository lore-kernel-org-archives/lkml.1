Return-Path: <linux-kernel-owner+w=401wt.eu-S1758992AbXFUTjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992AbXFUTjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbXFUTjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:39:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43555 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754477AbXFUTji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:39:38 -0400
Date: Thu, 21 Jun 2007 15:39:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Mattia Dongili <malattia@linux.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: can't suspend on vaio sz (rc4 and rc5 are ok) [was Re:
 2.6.22-rc4-mm2]
In-Reply-To: <200706210003.30536.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0706211533420.2933-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Rafael J. Wysocki wrote:

> > I'll see if I can reproduce your problem here.
> 
> Yes, I can.  It's only necessary to load usb-storage (without any devices
> actually using it) and it fails device_suspend() immediately (I don't think
> it's freezer-related).
> 
> I've got the following trace from it:
> 
> usb_endpoint usbdev3.2_ep81: PM: suspend 0->1, parent 3-1:1.0 already 2
> Suspending device 3-1:1.0
> Suspending device usbdev3.2_ep00
> Suspending device 3-1
> Suspending device eth1
> Suspending device eth0
> Suspending device usbdev3.1
> Suspending device usbdev3.1_ep81
> Suspending device 3-0:1.0
> Suspending device usbdev3.1_ep00
> Suspending device usb3
> hub 3-0:1.0: hub_suspend
> ohci_hcd 0000:00:02.1: needs reinit!
> usb usb3: suspend fail, err -16
> usb usb3: 'global' suspend -16
> hub 3-0:1.0: hub_resume
> hub 3-0:1.0: activate --> -108
> suspend_device(): usb_suspend+0x0/0x30() returns -16
> Could not suspend device usb3: error -16
> WARNING: at /home/rafael/src/mm/linux-2.6.22-rc4-mm2/drivers/usb/core/urb.c:293 usb_submit_urb()

Well, a large part of the problem is that

	usb-try-to-debug-bug-8561.patch

hasn't been reverted in 2.6.22-rc4-mm2.  Andrew, that patch is supposed 
to be completely gone.  It isn't still present in your tree, is it?

Alan Stern

