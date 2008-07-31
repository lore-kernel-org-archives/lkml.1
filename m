Return-Path: <linux-kernel-owner+w=401wt.eu-S1763233AbYGaDAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763233AbYGaDAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 23:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbYGaCwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:52:00 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:55974 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397AbYGaCv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:51:57 -0400
Date: Wed, 30 Jul 2008 21:50:26 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 27/30] W1: ds2490.c magic number work
Message-ID: <20080731025026.GB12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net> <20080729161356.2de456fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729161356.2de456fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Jul 2008 21:50:27 -0500 (CDT)
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
index 0f35693..29df1d2 100644
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
