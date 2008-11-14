Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbYKNEGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbYKNEGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 23:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYKNEG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 23:06:29 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33092 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYKNEG2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 23:06:28 -0500
From: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
To: Greg KH <gregkh@suse.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Felipe Balbi <felipe.balbi@nokia.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
Date: Fri, 14 Nov 2008 09:36:03 +0530
Subject: RE: [GIT PATCH] USB patches for 2.6-git
Thread-Topic: [GIT PATCH] USB patches for 2.6-git
Thread-Index: AclF5CRYMah77pL6RUC4uBSkKXcJpAAKSdJg
Message-ID: <19F8576C6E063C45BE387C64729E739403E5F2B47B@dbde02.ent.ti.com>
References: <20081113230259.GA3681@kroah.com>
In-Reply-To: <20081113230259.GA3681@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

There is a difference in the musb patch I submitted and the one which actually has been
forwarded to you by Felipe. This difference has introduced a bug.

The patch in you series is,
usb: musb: fix BULK request on different available endpoints


It was submitted by me at,
http://marc.info/?l=linux-usb&m=122337227617797&w=2


And the one which is forwarded to you by Felipe is at,
http://marc.info/?l=linux-usb&m=122528597316728&w=2


There is a difference in between above two as below.
Original: +	if (best_end < 0 && qh->type == USB_ENDPOINT_XFER_BULK) {
Sent to you: +	if (best_end > 0 && qh->type == USB_ENDPOINT_XFER_BULK) {

It should be [best_end < 0].

If it is possible then please correct this mismatch in your series.

Regards,
Ajay

> -----Original Message-----
> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Greg KH
> Sent: Friday, November 14, 2008 4:33 AM
> To: Linus Torvalds; Andrew Morton
> Cc: linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: [GIT PATCH] USB patches for 2.6-git
> 
> Here are a few USB patches for your 2.6-git tree.
> 
> These patches are:
> 	- lots of new device ids for different drivers
> 	- usb storage quirks
> 	- documentation fixes
> 	- ehci fixes
> 	- ps3 shutdown fix
> 	- musb driver fixes (this is the majority of these patches)
> 	- misc fixes
> 
> Please pull from:
> 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/
> 
> All of these have been in the -next and -mm releases for a while.
> 
> The full patches will be sent to the linux-usb mailing list, if anyone
> wants to see them.
> 
> thanks,
> 
> greg k-h
> 
> ------------
> 
>  drivers/block/ub.c                  |   20 ++++-
>  drivers/net/usb/asix.c              |    4 +
>  drivers/usb/class/cdc-acm.c         |    9 +-
>  drivers/usb/core/message.c          |    1 +
>  drivers/usb/core/sysfs.c            |    2 +-
>  drivers/usb/core/urb.c              |    4 +-
>  drivers/usb/gadget/f_acm.c          |    4 +
>  drivers/usb/host/Kconfig            |   23 ++----
>  drivers/usb/host/ehci-hcd.c         |   25 +++---
>  drivers/usb/host/ehci-ps3.c         |    1 +
>  drivers/usb/host/ehci-sched.c       |    4 +-
>  drivers/usb/host/isp1760-if.c       |   22 +++---
>  drivers/usb/host/ohci-ps3.c         |    3 +-
>  drivers/usb/host/r8a66597-hcd.c     |    5 +-
>  drivers/usb/misc/sisusbvga/sisusb.c |    1 +
>  drivers/usb/misc/vstusb.c           |    2 +-
>  drivers/usb/musb/musb_core.c        |    6 +-
>  drivers/usb/musb/musb_debug.h       |    4 +-
>  drivers/usb/musb/musb_host.c        |  159 ++++++++++++++++++++++-------------
>  drivers/usb/musb/musb_host.h        |    1 +
>  drivers/usb/musb/omap2430.c         |    2 +
>  drivers/usb/musb/tusb6010.c         |    2 +-
>  drivers/usb/serial/cp2101.c         |    2 +
>  drivers/usb/serial/option.c         |    6 ++
>  drivers/usb/storage/Kconfig         |    4 +-
>  drivers/usb/storage/unusual_devs.h  |   22 +++++
>  include/linux/usb.h                 |    2 +
>  27 files changed, 218 insertions(+), 122 deletions(-)
> 
> ---------------
> 
> Ajay Kumar Gupta (3):
>       usb: musb: Fix for isochronous IN transfer
>       usb: musb: Removes compilation warning in gadget mode
>       usb: musb: fix BULK request on different available endpoints
> 
> Alan Stern (4):
>       USB: don't register endpoints for interfaces that are going away
>       USB: unusual_devs entry for Argosy USB mass-storage interface
>       USB: EHCI: fix handling of dead controllers
>       USB: EHCI: fix divide-by-zero bug
> 
> Albert Comerma (1):
>       USB: SISUSB2VGA driver: add 0x0711, 0x0903
> 
> Brandon Philips (1):
>       USB: cdc-acm.c: fix recursive lock in acm_start_wb error path
> 
> Craig Shelley (1):
>       USB: CP2101 Add device ID for AMB2560
> 
> Damir N Abdullin (1):
>       + usb-serial-cp2101-add-enfora-gsm2228.patch added to -mm tree
> 
> David Brownell (1):
>       USB: gadget: cdc-acm deadlock fix
> 
> Felipe Balbi (2):
>       usb: musb: tusb6010: kill compile warning
>       usb: musb: fix debug global variable name
> 
> Geoff Levand (1):
>       USB: Fix PS3 USB shutdown problems
> 
> Greg Kroah-Hartman (1):
>       USB: vstusb: fix compiler warning on x86-64
> 
> Jason Cooper (1):
>       USB: net: asix: add support for Cables-to-Go USB Ethernet adapter
> 
> Leslie Watter (1):
>       USB: Add YISO u893 usb modem vendor and product IDs to option driver
> 
> Paul Bolle (1):
>       USB: storage: adjust comment in Kconfig
> 
> Paul Ready (1):
>       USB: add Nikon D300 camera to unusual_devs
> 
> Pete Zaitcev (1):
>       ub: stub pre_reset and post_reset to fix oops
> 
> Rabin Vincent (1):
>       USB: mention URB_FREE_BUFFER in usb_free_urb documentation
> 
> Ricky Wong (1):
>       usb: unusual devs patch for Nokia 7610 Supernova
> 
> Sebastian Andrzej Siewior (1):
>       USB: remove optional bus bindings in isp1760, fixing runtime warning
> 
> Yoshihiro Shimoda (1):
>       usb: r8a66597-hcd: fix wrong data access in SuperH on-chip USB
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

