Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYFGBOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYFGBOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757927AbYFGBJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:09 -0400
Received: from sous-sol.org ([216.99.217.87]:42399 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757926AbYFGBJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:03 -0400
Message-Id: <20080607010552.869620643@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:22 -0700
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
       Eugeniy Meshcheryakov <eugen@debian.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 07/50] USB: do not handle device 1410:5010 in option driver
Content-Disposition: inline; filename=usb-do-not-handle-device-1410-5010-in-option-driver.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Eugeniy Meshcheryakov <eugen@debian.org>

commit cdafc37a7b727b75ced65e31e47dafbd8b70f97f upstream

This device is not a serial port, but a virtual CD-ROM device. For
example with my Novatel MC950D:

lsusb -v -d 1410:5010 | grep InterfaceClass
      bInterfaceClass         8 Mass Storage

After some time (ca. 5min) or if virtual CD is ejected, device id
changes to 1410:4400:

% lsusb -v -d 1410:4400 | grep InterfaceClass
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceClass       255 Vendor Specific Class

Variable name says that 0x5010 is a Novatel U727, but searching in
internet shows, that this device also provides virtual CD that should be
ejected before use. Product id for serial port in this case is 0x4100.

Signed-off-by: Eugeniy Meshcheryakov <eugen@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/usb/serial/option.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -154,8 +154,6 @@ static int  option_send_setup(struct usb
 #define NOVATELWIRELESS_PRODUCT_MC727		0x4100
 #define NOVATELWIRELESS_PRODUCT_MC950D		0x4400
 
-#define NOVATELWIRELESS_PRODUCT_U727		0x5010
-
 /* FUTURE NOVATEL PRODUCTS */
 #define NOVATELWIRELESS_PRODUCT_EVDO_1		0x6000
 #define NOVATELWIRELESS_PRODUCT_HSPA_1		0x7000
@@ -269,7 +267,6 @@ static struct usb_device_id option_ids[]
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EU870D) }, /* Novatel EU850D/EU860D/EU870D */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC950D) }, /* Novatel MC930D/MC950D */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC727) }, /* Novatel MC727/U727/USB727 */
-	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_U727) }, /* Novatel U727 */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_1) }, /* Novatel EVDO product */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_1) }, /* Novatel HSPA product */
 	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EMBEDDED_1) }, /* Novatel Embedded product */

-- 
