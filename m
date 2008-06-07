Return-Path: <linux-kernel-owner+w=401wt.eu-S933415AbYFGBXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415AbYFGBXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760462AbYFGBJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:43 -0400
Received: from sous-sol.org ([216.99.217.87]:42540 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760190AbYFGBJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:26 -0400
Message-Id: <20080607010547.418640025@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:18 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Xiaofan Chen <xiaofanc@gmail.com>, Michael Hund <MHund@LD-Didactic.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 03/50] USB: remove PICDEM FS USB demo (04d8:000c) device from ldusb
Content-Disposition: inline; filename=usb-remove-picdem-fs-usb-demo-device-from-ldusb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Xiaofan Chen <xiaofanc@gmail.com>

commit 5fc89390f74ac42165db477793fb30f6a200e79c upstream
Date: Tue, 13 May 2008 21:52:00 +0800
Subject: [patch 03/50] USB: remove PICDEM FS USB demo (04d8:000c) device from ldusb

Microchip has changed the PICDEM FS USB demo device (0x04d8:000c)
to use bulk transfer and not interrupt transfer. So I've updated the libusb
based program here (Post #31).
	http://forum.microchip.com/tm.aspx?m=106426&mpage=2

So I believe that the in-kernel ldusb driver will no longer work with the
demo firmware.  It should be removed.


Signed-off-by: Xiaofan Chen <xiaofanc@gmail.com>
Cc: Michael Hund <MHund@LD-Didactic.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/usb/misc/ldusb.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -63,9 +63,6 @@
 #define USB_DEVICE_ID_VERNIER_CYCLOPS	0x0004
 #define USB_DEVICE_ID_VERNIER_LCSPEC	0x0006
 
-#define USB_VENDOR_ID_MICROCHIP		0x04d8
-#define USB_DEVICE_ID_PICDEM		0x000c
-
 #ifdef CONFIG_USB_DYNAMIC_MINORS
 #define USB_LD_MINOR_BASE	0
 #else
@@ -92,7 +89,6 @@ static struct usb_device_id ld_usb_table
 	{ USB_DEVICE(USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_GOTEMP) },
 	{ USB_DEVICE(USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_SKIP) },
 	{ USB_DEVICE(USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_CYCLOPS) },
-	{ USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICDEM) },
 	{ USB_DEVICE(USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_LCSPEC) },
 	{ }					/* Terminating entry */
 };

-- 
