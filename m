Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbYKXPU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbYKXPU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbYKXPUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:20:17 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:46415 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbYKXPUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:20:13 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/4] HID: move usbhid flags to usbhid.h
Date: Mon, 24 Nov 2008 16:20:07 +0100
Message-Id: <1227540009-14209-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1227540009-14209-1-git-send-email-jirislaby@gmail.com>
References: <1227540009-14209-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move usbhid specific flags from global hid.h into local usbhid.h.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/hid/usbhid/usbhid.h |   10 ++++++++++
 include/linux/hid.h         |    9 ---------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/usbhid/usbhid.h b/drivers/hid/usbhid/usbhid.h
index 332abcd..9eb3056 100644
--- a/drivers/hid/usbhid/usbhid.h
+++ b/drivers/hid/usbhid/usbhid.h
@@ -40,6 +40,16 @@ int usbhid_open(struct hid_device *hid);
 void usbhid_init_reports(struct hid_device *hid);
 void usbhid_submit_report(struct hid_device *hid, struct hid_report *report, unsigned char dir);
 
+/* iofl flags */
+#define HID_CTRL_RUNNING	1
+#define HID_OUT_RUNNING		2
+#define HID_IN_RUNNING		3
+#define HID_RESET_PENDING	4
+#define HID_SUSPENDED		5
+#define HID_CLEAR_HALT		6
+#define HID_DISCONNECTED	7
+#define HID_STARTED		8
+
 /*
  * USB-specific HID struct, to be pointed to
  * from struct hid_device->driver_data
diff --git a/include/linux/hid.h b/include/linux/hid.h
index e5780f8..2c20f20 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -403,15 +403,6 @@ struct hid_output_fifo {
 #define HID_STAT_ADDED		1
 #define HID_STAT_PARSED		2
 
-#define HID_CTRL_RUNNING	1
-#define HID_OUT_RUNNING		2
-#define HID_IN_RUNNING		3
-#define HID_RESET_PENDING	4
-#define HID_SUSPENDED		5
-#define HID_CLEAR_HALT		6
-#define HID_DISCONNECTED	7
-#define HID_STARTED		8
-
 struct hid_input {
 	struct list_head list;
 	struct hid_report *report;
-- 
1.6.0.4

