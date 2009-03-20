Return-Path: <linux-kernel-owner+w=401wt.eu-S1764088AbZCTXgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764088AbZCTXgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763030AbZCTXYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:48 -0400
Received: from kroah.org ([198.145.64.141]:48746 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763013AbZCTXYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:27 2009
Message-Id: <20090320222927.635390673@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:40 -0700
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
Subject: [patch 30/43] USB: serial: ftdi: enable UART detection on gnICE JTAG adaptors blacklist interface0
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-ftdi-enable-uart-detection-on-gnice-jtag-adaptors-blacklist-interface0.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

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
@@ -663,6 +663,8 @@ static struct usb_device_id id_table_com
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
@@ -894,6 +894,13 @@
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


