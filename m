Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbXFTWQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbXFTWQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbXFTWQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:16:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49209 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbXFTWQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:16:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mattia Dongili <malattia@linux.it>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: can't suspend on vaio sz (rc4 and rc5 are ok) [was Re: 2.6.22-rc4-mm2]
Date: Thu, 21 Jun 2007 00:22:50 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <200706202250.04414.rjw@sisk.pl> <200706210003.30536.rjw@sisk.pl>
In-Reply-To: <200706210003.30536.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706210022.51369.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 June 2007 00:03, Rafael J. Wysocki wrote:
> On Wednesday, 20 June 2007 22:50, Rafael J. Wysocki wrote:
> > On Wednesday, 20 June 2007 17:38, Mattia Dongili wrote:
> > > On Wed, Jun 20, 2007 at 01:40:18PM +0200, Rafael J. Wysocki wrote:
> > > > On Wednesday, 20 June 2007 07:22, Mattia Dongili wrote:
> > > > > On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
> > > > > > 
> > > > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/
> > > > > 
> > > > > Hello,
> > > > > on this vaio sz72b I can't suspend if usb-storage is loaded. Bisecting
> > > > > is becoming troublesome as different sets have slightly different
> > > > > problems.
> > > > > At one point (with the GREGKH usb stuff built) I had the kernel
> > > > > reporting it cannot stop the usb-storage thread so I guess that
> > > > > something later in the series made things worse (freezable workqueues?).
> > > > > 
> > > > > Clues?
> > > > 
> > > > Can you please try 2.6.22-rc5 with the patches from
> > > > 
> > > > http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc5/patches/
> > > > 
> > > > applied.  That should allow us to eliminate some suspects. ;-)
> > > 
> > > you're safe then! .22-rc5 + your suspend patch-set can suspend and
> > > resume happily.
> > 
> > OK, thanks.  OTOH, that would have been less patches to check ... ;-)
> > 
> > I'll see if I can reproduce your problem here.
> 
> Yes, I can.  It's only necessary to load usb-storage (without any devices
> actually using it) and it fails device_suspend() immediately (I don't think
> it's freezer-related).

It seems to be 100% reproducible in arbitrary configuration.

Here's a dmesg snippet from another machine:

Suspending device usbdev4.1
Suspending device usbdev4.1_ep81
Suspending device 4-0:1.0
Suspending device usbdev4.1_ep00
Suspending device usb4
hub 4-0:1.0: activate --> -108
suspend_device(): usb_suspend+0x0/0x30() returns -16
Could not suspend device usb4: error -16
PM: Image restored successfully.
Restarting tasks ... <3>hub 4-0:1.0: hub_port_status failed (err = -108)
hub 4-0:1.0: hub_port_status failed (err = -108)
hub 4-0:1.0: hub_port_status failed (err = -108)
done.
swsusp: Basic memory bitmaps freed

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
