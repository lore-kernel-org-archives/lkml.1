Return-Path: <linux-kernel-owner+w=401wt.eu-S1759225AbXFUVnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbXFUVnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbXFUVnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:43:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54229 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705AbXFUVnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:43:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: can't suspend on vaio sz (rc4 and rc5 are ok) [was Re: 2.6.22-rc4-mm2]
Date: Thu, 21 Jun 2007 23:49:37 +0200
User-Agent: KMail/1.9.5
Cc: Mattia Dongili <malattia@linux.it>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net
References: <Pine.LNX.4.44L0.0706211533420.2933-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0706211533420.2933-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706212349.38512.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 June 2007 21:39, Alan Stern wrote:
> On Thu, 21 Jun 2007, Rafael J. Wysocki wrote:
> 
> > > I'll see if I can reproduce your problem here.
> > 
> > Yes, I can.  It's only necessary to load usb-storage (without any devices
> > actually using it) and it fails device_suspend() immediately (I don't think
> > it's freezer-related).
> > 
> > I've got the following trace from it:
> > 
> > usb_endpoint usbdev3.2_ep81: PM: suspend 0->1, parent 3-1:1.0 already 2
> > Suspending device 3-1:1.0
> > Suspending device usbdev3.2_ep00
> > Suspending device 3-1
> > Suspending device eth1
> > Suspending device eth0
> > Suspending device usbdev3.1
> > Suspending device usbdev3.1_ep81
> > Suspending device 3-0:1.0
> > Suspending device usbdev3.1_ep00
> > Suspending device usb3
> > hub 3-0:1.0: hub_suspend
> > ohci_hcd 0000:00:02.1: needs reinit!
> > usb usb3: suspend fail, err -16
> > usb usb3: 'global' suspend -16
> > hub 3-0:1.0: hub_resume
> > hub 3-0:1.0: activate --> -108
> > suspend_device(): usb_suspend+0x0/0x30() returns -16
> > Could not suspend device usb3: error -16
> > WARNING: at /home/rafael/src/mm/linux-2.6.22-rc4-mm2/drivers/usb/core/urb.c:293 usb_submit_urb()
> 
> Well, a large part of the problem is that
> 
> 	usb-try-to-debug-bug-8561.patch
> 
> hasn't been reverted in 2.6.22-rc4-mm2.

Yes, the problem is not present after reverting this patch.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
