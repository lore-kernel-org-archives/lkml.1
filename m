Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbZIOTRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbZIOTRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbZIOTRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:17:40 -0400
Received: from kroah.org ([198.145.64.141]:33068 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758533AbZIOTPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:15:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/20] driver core: platform_device_add_data(): use kmemdup()
Date: Tue, 15 Sep 2009 12:12:47 -0700
Message-Id: <1253041976-1111-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090915181247.GA32167@kroah.com>
References: <20090915181247.GA32167@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Instead of open-coding it.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 0f7d434..ed156a1 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -10,6 +10,7 @@
  * information.
  */
 
+#include <linux/string.h>
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -213,14 +214,13 @@ EXPORT_SYMBOL_GPL(platform_device_add_resources);
 int platform_device_add_data(struct platform_device *pdev, const void *data,
 			     size_t size)
 {
-	void *d;
+	void *d = kmemdup(data, size, GFP_KERNEL);
 
-	d = kmalloc(size, GFP_KERNEL);
 	if (d) {
-		memcpy(d, data, size);
 		pdev->dev.platform_data = d;
+		return 0;
 	}
-	return d ? 0 : -ENOMEM;
+	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(platform_device_add_data);
 
-- 
1.6.4.2

