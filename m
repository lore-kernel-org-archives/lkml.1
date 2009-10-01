Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbZJAKG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbZJAKG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbZJAKGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:06:48 -0400
Received: from smtp.nokia.com ([192.100.105.134]:35753 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095AbZJAKGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:06:46 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net
Cc: linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH 1/2] LIS3LV02D: axis remap, irq and resource setup / release added to platform data
Date: Thu,  1 Oct 2009 13:06:30 +0300
Message-Id: <1254391591-9696-2-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1254391591-9696-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1254391591-9696-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 01 Oct 2009 10:06:33.0971 (UTC) FILETIME=[DAEC4430:01CA427E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds axis remapping and second IRQ request to platform data.
Second IRQ request doesn't exists in all lis3xxx variants.

Setup and release functions added to support
platform specific operations.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/lis3lv02d.h |    1 +
 include/linux/lis3lv02d.h |   13 +++++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 3e1ff46..b89f465 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -207,6 +207,7 @@ struct lis3lv02d {
 	struct axis_conversion	ac;        /* hw -> logical axis */
 
 	u32			irq;       /* IRQ number */
+	u32			irq2;      /* IRQ number (LIS302DL) */
 	struct fasync_struct	*async_queue; /* queue for the misc device */
 	wait_queue_head_t	misc_wait; /* Wait queue for the misc device */
 	unsigned long		misc_opened; /* bit0: whether the device is open */
diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
index dbe0702..7ac1e56 100644
--- a/include/linux/lis3lv02d.h
+++ b/include/linux/lis3lv02d.h
@@ -43,6 +43,19 @@ struct lis3lv02d_platform_data {
 #define LIS3_WAKEUP_Z_HI	(1 << 5)
 	unsigned char wakeup_flags;
 	unsigned char wakeup_thresh;
+#define LIS3_NO_MAP		0
+#define LIS3_DEV_X		1
+#define LIS3_DEV_Y		2
+#define LIS3_DEV_Z		3
+#define LIS3_INV_DEV_X	       -1
+#define LIS3_INV_DEV_Y	       -2
+#define LIS3_INV_DEV_Z	       -3
+	s8 axis_x;
+	s8 axis_y;
+	s8 axis_z;
+	u32 irq2;
+	int (*setup_resources)(void);
+	int (*release_resources)(void);
 };
 
 #endif /* __LIS3LV02D_H_ */
-- 
1.5.6.3

