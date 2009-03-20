Return-Path: <linux-kernel-owner+w=401wt.eu-S1762777AbZCTXXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777AbZCTXXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760157AbZCTXOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:14:06 -0400
Received: from kroah.org ([198.145.64.141]:53270 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760104AbZCTXN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:13:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:27:13 2009
Message-Id: <20090320222713.225166672@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:26:38 -0700
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
       alan@lxorguk.ukuu.org.uk,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [patch 27/32] USB: serial: ftdi: enable UART detection on gnICE JTAG adaptors blacklist interface0
References: <20090320222611.872315885@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-ftdi-enable-uart-detection-on-gnice-jtag-adaptors-blacklist-interface0.patch
In-Reply-To: <20090320231037.GA2732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Hennerich <michael.hennerich@analog.com>

commit b0d659002168146ec6b03d1ef062d8dcf05ff510 upstream.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    2 ++
 drivers/usb/serial/ftdi_sio.h |    7 +++++++
 2 files changed, 9 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -660,6 +660,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(ATMEL_VID, STK541_PID) },
 	{ USB_DEVICE(DE_VID, STB_PID) },
 	{ USB_DEVICE(DE_VID, WHT_PID) },
+	{ USB_DEVICE(ADI_VID, ADI_GNICE_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -883,6 +883,13 @@
 #define WHT_PID			0x0004 /* Wireless Handheld Terminal */
 
 /*
+ * Blackfin gnICE JTAG
+ * http://docs.blackfin.uclinux.org/doku.php?id=hw:jtag:gnice
+ */
+#define ADI_VID 		0x0456
+#define ADI_GNICE_PID 		0xF000
+
+/*
  *   BmRequestType:  1100 0000b
  *   bRequest:       FTDI_E2_READ
  *   wValue:         0


