Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbYFGB2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbYFGB2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760816AbYFGBJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:53 -0400
Received: from sous-sol.org ([216.99.217.87]:42585 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760793AbYFGBJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:52 -0400
Message-Id: <20080607010607.718193988@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:34 -0700
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
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Akira Tsukamoto <akirat@rd.scei.sony.co.jp>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 19/50] usb-serial: Use ftdi_sio driver for RATOC REX-USB60F
Content-Disposition: inline; filename=usb-serial-use-ftdi_sio-driver-for-ratoc-rex-usb60f.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

upstream commit: 26ab705396b65a469233a8327ecb51b8aebb6be0

This patch reverts 57833ea6b95a3995149f1f6d1a8d8862ab7a0ba2
("usb-serial: pl2303: add support for RATOC REX-USB60F") and adds
support for the device to ftdi_sio driver.

Cc: Akira Tsukamoto <akirat@rd.scei.sony.co.jp>
Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/serial/ftdi_sio.c |    1 +
 drivers/usb/serial/ftdi_sio.h |    6 ++++++
 drivers/usb/serial/pl2303.c   |    1 -
 drivers/usb/serial/pl2303.h   |    1 -
 4 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -366,6 +366,7 @@ static struct usb_device_id id_table_com
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_OOCDLINK_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -581,6 +581,12 @@
 #define	FIC_NEO1973_DEBUG_PID	0x5118
 
 /*
+ * RATOC REX-USB60F
+ */
+#define RATOC_VENDOR_ID		0x0584
+#define RATOC_PRODUCT_ID_USB60F	0xb020
+
+/*
  *   BmRequestType:  1100 0000b
  *   bRequest:       FTDI_E2_READ
  *   wValue:         0
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -66,7 +66,6 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(ITEGNO_VENDOR_ID, ITEGNO_PRODUCT_ID_2080) },
 	{ USB_DEVICE(MA620_VENDOR_ID, MA620_PRODUCT_ID) },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID) },
-	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ USB_DEVICE(TRIPP_VENDOR_ID, TRIPP_PRODUCT_ID) },
 	{ USB_DEVICE(RADIOSHACK_VENDOR_ID, RADIOSHACK_PRODUCT_ID) },
 	{ USB_DEVICE(DCU10_VENDOR_ID, DCU10_PRODUCT_ID) },
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -36,7 +36,6 @@
 
 #define RATOC_VENDOR_ID		0x0584
 #define RATOC_PRODUCT_ID	0xb000
-#define RATOC_PRODUCT_ID_USB60F	0xb020
 
 #define TRIPP_VENDOR_ID		0x2478
 #define TRIPP_PRODUCT_ID	0x2008

-- 
