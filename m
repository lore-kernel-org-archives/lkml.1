Return-Path: <linux-kernel-owner+w=401wt.eu-S1764065AbZCTXgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764065AbZCTXgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763014AbZCTXYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:47 -0400
Received: from kroah.org ([198.145.64.141]:48738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763000AbZCTXYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:46 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:27 2009
Message-Id: <20090320222927.486077903@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Axel Wachtler <axel.wachtler@atmel.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [patch 29/43] USB: serial: add FTDI USB/Serial converter devices
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-add-ftdi-usb-serial-converter-devices.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Axel Wachtler <axel.wachtler@atmel.com>

commit 7f82b6dd7015aabca2fd55fb690248f742cd67f3 upstream.

Add the following devices to the USB FTDI SIO device table:

 Bus 001 Device 009: ID 03eb:2109 Atmel Corp.
 http://www.atmel.com/dyn/products/tools_card.asp?tool_id=4187

 Bus 001 Device 008: ID 1cf1:0001
 http://www.dresden-elektronik.de/shop/prod75.html

 Bus 001 Device 007: ID 1c1f:0004
 http://www.dresden-elektronik.de/shop/prod64.html

Signed-off-by: Axel Wachtler <axel.wachtler@atmel.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    3 +++
 drivers/usb/serial/ftdi_sio.h |   13 +++++++++++++
 2 files changed, 16 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -660,6 +660,9 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO4x4_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DGQG_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DUSB_PID) },
+	{ USB_DEVICE(ATMEL_VID, STK541_PID) },
+	{ USB_DEVICE(DE_VID, STB_PID) },
+	{ USB_DEVICE(DE_VID, WHT_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -881,6 +881,19 @@
 #define RATOC_PRODUCT_ID_USB60F	0xb020
 
 /*
+ * Atmel STK541
+ */
+#define ATMEL_VID		0x03eb /* Vendor ID */
+#define STK541_PID		0x2109 /* Zigbee Controller */
+
+/*
+ * Dresden Elektronic Sensor Terminal Board
+ */
+#define DE_VID			0x1cf1 /* Vendor ID */
+#define STB_PID			0x0001 /* Sensor Terminal Board */
+#define WHT_PID			0x0004 /* Wireless Handheld Terminal */
+
+/*
  *   BmRequestType:  1100 0000b
  *   bRequest:       FTDI_E2_READ
  *   wValue:         0


