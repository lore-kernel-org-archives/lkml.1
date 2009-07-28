Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbZG1XFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbZG1XFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbZG1XFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:05:22 -0400
Received: from kroah.org ([198.145.64.141]:43097 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978AbZG1XEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:04:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:46 2009
Message-Id: <20090728225946.030192226@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:59:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Brownell <dbrownell@users.sourceforge.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 34/37] usbnet cdc_subset: fix issues talking to PXA gadgets
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=usbnet-cdc_subset-fix-issues-talking-to-pxa-gadgets.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Brownell <dbrownell@users.sourceforge.net>

[ Upstream commit 6be832529a8129c9d90a1d3a78c5d503a710b6fc ]

The host-side CDC subset driver is binding more specifically
than it should ... only to PXA 210/25x/26x Linux-USB gadgets.

Loosen that restriction to match the gadget driver driver.
This will various PXA 27x and PXA 3xx devices happier when
talking to Linux hosts, potentially others.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Tested-by: Aric D. Blumer <aric@sdgsystems.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/usb/cdc_subset.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/usb/cdc_subset.c
+++ b/drivers/net/usb/cdc_subset.c
@@ -307,9 +307,10 @@ static const struct usb_device_id	produc
 	USB_DEVICE (0x1286, 0x8001),    // "blob" bootloader
 	.driver_info =  (unsigned long) &blob_info,
 }, {
-	// Linux Ethernet/RNDIS gadget on pxa210/25x/26x, second config
-	// e.g. Gumstix, current OpenZaurus, ...
-	USB_DEVICE_VER (0x0525, 0xa4a2, 0x0203, 0x0203),
+	// Linux Ethernet/RNDIS gadget, mostly on PXA, second config
+	// e.g. Gumstix, current OpenZaurus, ... or anything else
+	// that just enables this gadget option.
+	USB_DEVICE (0x0525, 0xa4a2),
 	.driver_info =	(unsigned long) &linuxdev_info,
 },
 #endif


