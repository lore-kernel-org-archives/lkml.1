Return-Path: <linux-kernel-owner+w=401wt.eu-S1761611AbZEHODo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761611AbZEHODo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbZEHOBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:01:32 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58249 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757913AbZEHOBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:01:31 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH 05/15] ps3fb: Remove useless debug checks in ps3fb_shutdown()
Date: Fri,  8 May 2009 16:01:14 +0200
Message-Id: <1241791284-11490-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241791284-11490-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1241791284-11490-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/video/ps3fb.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/video/ps3fb.c b/drivers/video/ps3fb.c
index e00c1df..ce0f873 100644
--- a/drivers/video/ps3fb.c
+++ b/drivers/video/ps3fb.c
@@ -1247,7 +1247,6 @@ err:
 
 static int ps3fb_shutdown(struct ps3_system_bus_device *dev)
 {
-	int status;
 	struct fb_info *info = dev->core.driver_data;
 
 	dev_dbg(&dev->core, " -> %s:%d\n", __func__, __LINE__);
@@ -1271,17 +1270,8 @@ static int ps3fb_shutdown(struct ps3_system_bus_device *dev)
 		info = dev->core.driver_data = NULL;
 	}
 	iounmap((u8 __force __iomem *)ps3fb.dinfo);
-
-	status = lv1_gpu_context_free(ps3fb.context_handle);
-	if (status)
-		dev_dbg(&dev->core, "lv1_gpu_context_free failed: %d\n",
-			status);
-
-	status = lv1_gpu_memory_free(ps3fb.memory_handle);
-	if (status)
-		dev_dbg(&dev->core, "lv1_gpu_memory_free failed: %d\n",
-			status);
-
+	lv1_gpu_context_free(ps3fb.context_handle);
+	lv1_gpu_memory_free(ps3fb.memory_handle);
 	ps3_close_hv_device(dev);
 	dev_dbg(&dev->core, " <- %s:%d\n", __func__, __LINE__);
 
-- 
1.6.2.4

