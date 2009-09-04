Return-Path: <linux-kernel-owner+w=401wt.eu-S932577AbZIDCak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbZIDCak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 22:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932556AbZIDCaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 22:30:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:56064 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536AbZIDCah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 22:30:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,329,1249282800"; 
   d="scan'208";a="723768519"
Subject: [PATCH 02/29] ioat: move definitions to dma.h
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, netdev@vger.kernel.org,
       Maciej Sosnowski <maciej.sosnowski@intel.com>
Date: Thu, 03 Sep 2009 19:30:40 -0700
Message-ID: <20090904023040.32667.69433.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
References: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of these defines may be useful outside of dma.c and the header is
private so there are no namespace pollution concerns.

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dma.c |   14 --------------
 drivers/dma/ioat/dma.h |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 648797e..16c0807 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -38,28 +38,14 @@
 #include "registers.h"
 #include "hw.h"
 
-#define to_ioat_chan(chan) container_of(chan, struct ioat_dma_chan, common)
-#define to_ioatdma_device(dev) container_of(dev, struct ioatdma_device, common)
-#define to_ioat_desc(lh) container_of(lh, struct ioat_desc_sw, node)
-#define tx_to_ioat_desc(tx) container_of(tx, struct ioat_desc_sw, async_tx)
-
-#define chan_num(ch) ((int)((ch)->reg_base - (ch)->device->reg_base) / 0x80)
 static int ioat_pending_level = 4;
 module_param(ioat_pending_level, int, 0644);
 MODULE_PARM_DESC(ioat_pending_level,
 		 "high-water mark for pushing ioat descriptors (default: 4)");
 
-#define RESET_DELAY  msecs_to_jiffies(100)
-#define WATCHDOG_DELAY  round_jiffies(msecs_to_jiffies(2000))
 static void ioat_dma_chan_reset_part2(struct work_struct *work);
 static void ioat_dma_chan_watchdog(struct work_struct *work);
 
-/*
- * workaround for IOAT ver.3.0 null descriptor issue
- * (channel returns error when size is 0)
- */
-#define NULL_DESC_BUFFER_SIZE 1
-
 /* internal functions */
 static void ioat_dma_start_null_desc(struct ioat_dma_chan *ioat_chan);
 static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan);
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index e80e787..ccb400f 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -43,6 +43,22 @@ enum ioat_interrupt {
 #define IOAT_DMA_DCA_ANY_CPU		~0
 #define IOAT_WATCHDOG_PERIOD		(2 * HZ)
 
+#define to_ioat_chan(chan) container_of(chan, struct ioat_dma_chan, common)
+#define to_ioatdma_device(dev) container_of(dev, struct ioatdma_device, common)
+#define to_ioat_desc(lh) container_of(lh, struct ioat_desc_sw, node)
+#define tx_to_ioat_desc(tx) container_of(tx, struct ioat_desc_sw, async_tx)
+
+#define chan_num(ch) ((int)((ch)->reg_base - (ch)->device->reg_base) / 0x80)
+
+#define RESET_DELAY  msecs_to_jiffies(100)
+#define WATCHDOG_DELAY  round_jiffies(msecs_to_jiffies(2000))
+
+/*
+ * workaround for IOAT ver.3.0 null descriptor issue
+ * (channel returns error when size is 0)
+ */
+#define NULL_DESC_BUFFER_SIZE 1
+
 
 /**
  * struct ioatdma_device - internal representation of a IOAT device

