Return-Path: <linux-kernel-owner+w=401wt.eu-S1760543AbZE1PVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760543AbZE1PVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbZE1PUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:20:50 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:14144
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758742AbZE1PUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:20:49 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KKD1AC-01-JYU-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/4] dma-debug: add dma_debug_driver kernel command line
Date: Thu, 28 May 2009 17:19:30 +0200
Message-ID: <1243523971-12681-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243523971-12681-1-git-send-email-joerg.roedel@amd.com>
References: <1243523971-12681-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 28 May 2009 15:19:34.0435 (UTC) FILETIME=[B4E72730:01C9DFA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the dma_debug_driver= boot parameter to enable the driver
filter for early boot.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 65043c7..7b51fa4 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -1098,3 +1098,22 @@ void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 }
 EXPORT_SYMBOL(debug_dma_sync_sg_for_device);
 
+static int __init parse_dma_debug_driver(char *str)
+{
+	int i;
+
+	for (i = 0; i < NAME_MAX_LEN - 1; ++i, ++str) {
+		current_driver_name[i] = *str;
+		if (*str == ' ' || *str == '\t' || isspace(*str) || *str == 0)
+			break;
+	}
+	current_driver_name[i] = 0;
+
+	if (current_driver_name[0])
+		printk(KERN_INFO "DMA-API: enable driver filter for "
+				 "driver [%s]\n", current_driver_name);
+
+
+	return 1;
+}
+__setup("dma_debug_driver=", parse_dma_debug_driver);
-- 
1.6.3.1


