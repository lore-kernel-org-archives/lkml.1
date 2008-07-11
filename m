Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbYGKNzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbYGKNzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758522AbYGKNsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:17 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34980 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758689AbYGKNr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:56 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 27/30] W1: ds2490.c magic number work
Date: Fri, 11 Jul 2008 17:51:42 +0400
Message-Id: <12157843071622-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces some magic numbers with marcos and corrects one marco.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

---
 drivers/w1/masters/ds2490.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 754a4bb..d9e07d6 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -88,7 +88,7 @@
 #define COMM_DT				0x2000
 #define COMM_SPU			0x1000
 #define COMM_F				0x0800
-#define COMM_NTP			0x0400
+#define COMM_NTF			0x0400
 #define COMM_ICP			0x0200
 #define COMM_RST			0x0100
 
@@ -440,7 +440,7 @@ static int ds_wait_status(struct ds_device *dev, struct ds_status *st)
 			printk("\n");
 		}
 #endif
-	} while(!(buf[0x08] & 0x20) && !(err < 0) && ++count < 100);
+	} while (!(buf[0x08] & ST_IDLE) && !(err < 0) && ++count < 100);
 
 	if (err >= 16 && st->status & ST_EPOF) {
 		printk(KERN_INFO "Resetting device after ST_EPOF.\n");
@@ -470,8 +470,16 @@ static int ds_reset(struct ds_device *dev)
 {
 	int err;
 
-	//err = ds_send_control(dev, COMM_1_WIRE_RESET | COMM_F | COMM_IM | COMM_SE, SPEED_FLEXIBLE);
-	err = ds_send_control(dev, 0x43, SPEED_NORMAL);
+	/* Other potentionally interesting flags for reset.
+	 *
+	 * COMM_NTF: Return result register feedback.  This could be used to
+	 * detect some conditions such as short, alarming presence, or
+	 * detect if a new device was detected.
+	 *
+	 * COMM_SE which allows SPEED_NORMAL, SPEED_FLEXIBLE, SPEED_OVERDRIVE:
+	 * Select the data transfer rate.
+	 */
+	err = ds_send_control(dev, COMM_1_WIRE_RESET | COMM_IM, SPEED_NORMAL);
 	if (err)
 		return err;
 
-- 
1.4.4.4

