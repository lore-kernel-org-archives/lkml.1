Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZCFDAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZCFDAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 22:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbZCFC7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 21:59:50 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:18839 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZCFC7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 21:59:49 -0500
X-IronPort-AV: E=Sophos;i="4.38,311,1233550800"; 
   d="scan'208";a="83875805"
From: Bryan Wu <cooloney@kernel.org>
To: ftdi-usb-sio-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] usb/serial: ftdi: Enable UART detection on gnICE JTAG adaptors blacklist interface0
Date: Fri,  6 Mar 2009 11:01:56 +0800
Message-Id: <1236308516-23820-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/serial/ftdi_sio.c |    2 ++
 drivers/usb/serial/ftdi_sio.h |    7 +++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index f92f4d7..e15ec7c 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -663,6 +663,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(ALTI2_VID, ALTI2_N3_PID) },
 	{ USB_DEVICE(FTDI_VID, DIEBOLD_BCS_SE923_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_NDI_HUC_PID) },
+	{ USB_DEVICE(ADI_VID, ADI_GNICE_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio.h b/drivers/usb/serial/ftdi_sio.h
index e300c84..1e42181 100644
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -893,6 +893,13 @@
 #define DIEBOLD_BCS_SE923_PID	0xfb99
 
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
-- 
1.5.6.3
