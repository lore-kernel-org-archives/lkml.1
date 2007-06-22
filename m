Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbXFVJ1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbXFVJ1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 05:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXFVJ07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 05:26:59 -0400
Received: from mtoichi16.ns.itscom.net ([219.110.2.186]:50670 "EHLO
	mtoichi16.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbXFVJ06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 05:26:58 -0400
Date: Fri, 22 Jun 2007 18:25:18 +0900
From: Mattia Dongili <malattia@linux.it>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: can't suspend on vaio sz (rc4 and rc5 are ok) [was Re: 2.6.22-rc4-mm2]
Message-ID: <20070622092518.GD25100@inferi.kami.home>
References: <Pine.LNX.4.44L0.0706211533420.2933-100000@iolanthe.rowland.org> <200706212349.38512.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706212349.38512.rjw@sisk.pl>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.22-rc5-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 11:49:37PM +0200, Rafael J. Wysocki wrote:
> On Thursday, 21 June 2007 21:39, Alan Stern wrote:
> > On Thu, 21 Jun 2007, Rafael J. Wysocki wrote:
> > 
> > > > I'll see if I can reproduce your problem here.
> > > 
> > > Yes, I can.  It's only necessary to load usb-storage (without any devices
> > > actually using it) and it fails device_suspend() immediately (I don't think
> > > it's freezer-related).
> > > 
> > > I've got the following trace from it:
> > > 
> > > usb_endpoint usbdev3.2_ep81: PM: suspend 0->1, parent 3-1:1.0 already 2
> > > Suspending device 3-1:1.0
> > > Suspending device usbdev3.2_ep00
> > > Suspending device 3-1
> > > Suspending device eth1
> > > Suspending device eth0
> > > Suspending device usbdev3.1
> > > Suspending device usbdev3.1_ep81
> > > Suspending device 3-0:1.0
> > > Suspending device usbdev3.1_ep00
> > > Suspending device usb3
> > > hub 3-0:1.0: hub_suspend
> > > ohci_hcd 0000:00:02.1: needs reinit!
> > > usb usb3: suspend fail, err -16
> > > usb usb3: 'global' suspend -16
> > > hub 3-0:1.0: hub_resume
> > > hub 3-0:1.0: activate --> -108
> > > suspend_device(): usb_suspend+0x0/0x30() returns -16
> > > Could not suspend device usb3: error -16
> > > WARNING: at /home/rafael/src/mm/linux-2.6.22-rc4-mm2/drivers/usb/core/urb.c:293 usb_submit_urb()
> > 
> > Well, a large part of the problem is that
> > 
> > 	usb-try-to-debug-bug-8561.patch
> > 
> > hasn't been reverted in 2.6.22-rc4-mm2.
> 
> Yes, the problem is not present after reverting this patch.

Not for me, I had that patch already reverted. As I said there was a
point when bisecting which the kernel came back to life instead of just
hanging trying to suspend.
I'll try to get a trace with that. May the usb_storage verbose debug
help there?

-- 
mattia
:wq!
