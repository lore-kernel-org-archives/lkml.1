Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbXL1Xf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbXL1Xf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 18:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbXL1XfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 18:35:08 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44163 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbXL1XfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 18:35:03 -0500
Date: Sat, 29 Dec 2007 01:34:50 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Brownell <david-b@pacbell.net>
Cc: Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] USB Kconfig: Reorganize USB Kconfig Menu
Message-ID: <20071228233450.GC9105@does.not.exist>
References: <200712231449.00862.a1426z@gawab.com> <200712271418.59156.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200712271418.59156.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2007 at 02:18:58PM -0800, David Brownell wrote:
> On Sunday 23 December 2007, Al Boldi wrote:
> > 
> > Reogranize USB Kconfig Menu, and move USB_GADGET out into the Device Driver
> > Menu.  This helps the USB Kconfig Menu to be more logical/usable.
> > 
> > Cc: David Brownell <david-b@pacbell.net>
> > Cc: Greg KH <greg@kroah.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Al Boldi <a1426z@gawab.com>
> 
> Along those lines, sure ... but this particular patch can't quite
> be the answer.  For one thing, it rather critially needs the appended,
> else it won't work on ARM.  (And quite a lot of the ARM platforms
> need the gadget stack!!)
> 
> There are ISTR a few other platforms which, for reasons unknown to
> me, don't source drivers/Kconfig but recreate portions of it on
> their own ... that's not something that this patch should change.

$ find . -name Kconfig\* | xargs grep drivers/usb/Kconfig
./arch/arm/Kconfig:source "drivers/usb/Kconfig"
./arch/cris/Kconfig:source "drivers/usb/Kconfig"
./arch/h8300/Kconfig:source "drivers/usb/Kconfig"
./arch/v850/Kconfig:source "drivers/usb/Kconfig"
./drivers/Kconfig:source "drivers/usb/Kconfig"
$ 

> Also, looking at this in xconfig shows some oddness.  That "core"
> submenu holds stuff that would logically be part of the toplevel
> menu for host side USB.  While that toplevel menu has the USS720
> driver, which seems more like a "miscellany" thing...
> 
> The comment about SCSI shouldn't show when SCSI is defined; and
> the comment aboue "SCSI disk support" belongs with the mass storage
> menu, not at the top level.  The way that the mass storage menu
> is presented also hides the fact that you can get fully functional
> mass storage support without checking *any* of the drivers there,
> since the core already handles standard devices.
>...

The SCSI dependency should be handled through select - there's no 
reason for bothering the kconfig user wih such implementation details.

> - Dave
>...


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

