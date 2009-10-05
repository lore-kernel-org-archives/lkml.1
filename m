Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbZJEH00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbZJEH00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758569AbZJEH0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:26:24 -0400
Received: from smtp.nokia.com ([192.100.122.233]:47943 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549AbZJEH0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:26:23 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net
Cc: linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH 1/2] LIS3LV02D: axis remap and resource setup / release
Date: Mon,  5 Oct 2009 10:24:37 +0300
Message-Id: <1254727478-19802-2-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1254727478-19802-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1254727478-19802-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 05 Oct 2009 07:24:45.0547 (UTC) FILETIME=[E9E753B0:01CA458C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added possibility to remap axes via platform data.
Function pointers for resource setup and release purposes

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 include/linux/lis3lv02d.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
index dbe0702..5a809f6 100644
--- a/include/linux/lis3lv02d.h
+++ b/include/linux/lis3lv02d.h
@@ -43,6 +43,18 @@ struct lis3lv02d_platform_data {
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
+	int (*setup_resources)(void);
+	int (*release_resources)(void);
 };
 
 #endif /* __LIS3LV02D_H_ */
-- 
1.5.6.3

