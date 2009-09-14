Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbZINOjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbZINOjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbZINOjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:39:52 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44901 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589AbZINOjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:39:51 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH] USB: serial: ftdi: handle gnICE+ JTAG adaptors
Date: Mon, 14 Sep 2009 10:39:53 -0400
Message-Id: <1252939193-29651-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Detect the UART on interface1 and blacklist interface0 (as that is the
JTAG port).

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/serial/ftdi_sio.c |    2 ++
 drivers/usb/serial/ftdi_sio.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 8fec5d4..de342f0 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -694,6 +694,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(DE_VID, WHT_PID) },
 	{ USB_DEVICE(ADI_VID, ADI_GNICE_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(ADI_VID, ADI_GNICEPLUS_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(JETI_VID, JETI_SPC1201_PID) },
 	{ USB_DEVICE(MARVELL_VID, MARVELL_SHEEVAPLUG_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
diff --git a/drivers/usb/serial/ftdi_sio.h b/drivers/usb/serial/ftdi_sio.h
index 8c92b88..eb8ad1f 100644
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -930,6 +930,7 @@
  */
 #define ADI_VID 		0x0456
 #define ADI_GNICE_PID 		0xF000
+#define ADI_GNICEPLUS_PID 	0xF001
 
 /*
  * JETI SPECTROMETER SPECBOS 1201
-- 
1.6.4.2

