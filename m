Return-Path: <linux-kernel-owner+w=401wt.eu-S933735AbZIPXkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735AbZIPXkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760634AbZIPXiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:38:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45297 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760580AbZIPXir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:38:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>, Cliff Cai <cliff.cai@analog.com>
Subject: [PATCH 05/11] USB: musb: add notes for Blackfin anomalies
Date: Wed, 16 Sep 2009 19:38:39 -0400
Message-Id: <1253144325-1203-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
References: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Add some helpful notes about how the driver works around different
anomalies that exist in the on-chip host controller.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/musb/blackfin.h |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/musb/blackfin.h b/drivers/usb/musb/blackfin.h
index a240c1e..de62962 100644
--- a/drivers/usb/musb/blackfin.h
+++ b/drivers/usb/musb/blackfin.h
@@ -14,6 +14,35 @@
  * Blackfin specific definitions
  */
 
+/* Anomalies notes:
+ *
+ *  05000450 - USB DMA Mode 1 Short Packet Data Corruption:
+ *             MUSB driver is designed to transfer buffer of N * maxpacket size
+ *             in DMA mode 1 and leave rest data to the next transfer in DMA
+ *             mode 0, so we never transmit a short packet in DMA mode 1.
+ *
+ *  05000463 - This anomaly doesn't affect this driver,Since it
+ *             never uses L1 or L2 memory as data destination.
+ *
+ *  05000464 - This anomaly doesn't affect this driver,Since it
+ *             never uses L1 or L2 memory as data source.
+ *
+ *  05000465 - Actually,the anomaly still can be seen when SCLK
+ *             is over 100 MHz,and there is no way to workaround
+ *             for bulk endpoints,because the wMaxPackSize of bulk
+ *             is less than or equal to 512,while the fifo size of
+ *             endpoint 5,6,7 is 1024,the double buffer mode is
+ *             enabled automatically when these endpoints are used
+ *             for bulk OUT.
+ *
+ *  05000466 - This anomaly doesn't affect this driver,Since it
+ *             never mixs concurrent DMA and core accesses to the
+ *             TX endpoint FIFOs.
+ *
+ *  05000467 - The workaround for this anomaly will introduce another
+ *             anomaly - 05000465.
+ */
+
 #undef DUMP_FIFO_DATA
 #ifdef DUMP_FIFO_DATA
 static void dump_fifo_data(u8 *buf, u16 len)
-- 
1.6.5.rc1

