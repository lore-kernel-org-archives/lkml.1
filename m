Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbZHMTun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbZHMTun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbZHMTul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:50:41 -0400
Received: from kroah.org ([198.145.64.141]:36776 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932148AbZHMTr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:47:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:38 2009
Message-Id: <20090813194338.719404891@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Marko=20H=C3=A4nninen?= <bugitus@gmail.com>
Subject: [patch 20/28] USB: ftdi_sio: add vendor and product id for Bayer glucose meter serial converter cable
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=usb-ftdi_sio-add-vendor-and-product-id-for-bayer-glucose-meter-serial-converter-cable.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marko Hänninen <bugitus@gmail.com>

commit c47aacc67a3d26dfab9c9b8965975ed2b2010b30 upstream.

Attached patch adds USB vendor and product IDs for Bayer's USB to serial
converter cable used by Bayer blood glucose meters. It seems to be a
FT232RL based device and works without any problem with ftdi_sio driver
when this patch is applied. See: http://winglucofacts.com/cables/


Signed-off-by: Marko Hänninen <bugitus@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    1 +
 drivers/usb/serial/ftdi_sio.h |    7 +++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -663,6 +663,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(ADI_VID, ADI_GNICE_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(JETI_VID, JETI_SPC1201_PID) },
+	{ USB_DEVICE(BAYER_VID, BAYER_CONTOUR_CABLE_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -897,6 +897,13 @@
 #define JETI_SPC1201_PID	0x04b2
 
 /*
+ * Bayer Ascensia Contour blood glucose meter USB-converter cable.
+ * http://winglucofacts.com/cables/
+ */
+#define BAYER_VID                      0x1A79
+#define BAYER_CONTOUR_CABLE_PID        0x6001
+
+/*
  *   BmRequestType:  1100 0000b
  *   bRequest:       FTDI_E2_READ
  *   wValue:         0


