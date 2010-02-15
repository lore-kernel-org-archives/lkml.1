Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab0BOQxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 11:53:33 -0500
Received: from smtp.nokia.com ([192.100.122.233]:65294 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab0BOQxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:53:32 -0500
From: Aaro Koskinen <aaro.koskinen@nokia.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       a.zummo@towertech.it
Cc: stable@kernel.org
Subject: [PATCH] rtc-core: fix memory leak
Date: Mon, 15 Feb 2010 18:54:06 +0200
Message-Id: <1266252846-12602-1-git-send-email-aaro.koskinen@nokia.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 15 Feb 2010 16:52:27.0508 (UTC) FILETIME=[415ADB40:01CAAE5F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idr should be destroyed when the module is unloaded. Found with
kmemleak.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: stable <stable@kernel.org>
---
 drivers/rtc/class.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index be5a6b7..40845c7 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -226,6 +226,7 @@ static void __exit rtc_exit(void)
 {
 	rtc_dev_exit();
 	class_destroy(rtc_class);
+	idr_destroy(&rtc_idr);
 }
 
 subsys_initcall(rtc_init);
-- 
1.5.6.5

