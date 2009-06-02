Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbZFBOid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbZFBOid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbZFBOhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:37:20 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:56377
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755144AbZFBOhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:37:18 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KKM8LA-04-0I0-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/4] dma-debug: add dma_debug_driver kernel command line
Date: Tue, 2 Jun 2009 16:36:43 +0200
Message-ID: <1243953404-31799-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243953404-31799-1-git-send-email-joerg.roedel@amd.com>
References: <1243953404-31799-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 02 Jun 2009 14:36:48.0016 (UTC) FILETIME=[8F437100:01C9E38F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the dma_debug_driver= boot parameter to enable the driver
filter for early boot.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 Documentation/kernel-parameters.txt |    7 +++++++
 lib/dma-debug.c                     |   18 ++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e87bdbf..b3f1314 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -646,6 +646,13 @@ and is between 256 and 4096 characters. It is defined in the file
 			DMA-API debugging code disables itself because the
 			architectural default is too low.
 
+	dma_debug_driver=<driver_name>
+			With this option the DMA-API debugging driver
+			filter feature can be enabled at boot time. Just
+			pass the driver to filter for as the parameter.
+			The filter can be disabled or changed to another
+			driver later using sysfs.
+
 	dscc4.setup=	[NET]
 
 	dtc3181e=	[HW,SCSI]
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index c6330b1..d0618aa 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -1109,3 +1109,21 @@ void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 }
 EXPORT_SYMBOL(debug_dma_sync_sg_for_device);
 
+static int __init dma_debug_driver_setup(char *str)
+{
+	int i;
+
+	for (i = 0; i < NAME_MAX_LEN - 1; ++i, ++str) {
+		current_driver_name[i] = *str;
+		if (*str == 0)
+			break;
+	}
+
+	if (current_driver_name[0])
+		printk(KERN_INFO "DMA-API: enable driver filter for "
+				 "driver [%s]\n", current_driver_name);
+
+
+	return 1;
+}
+__setup("dma_debug_driver=", dma_debug_driver_setup);
-- 
1.6.3.1


