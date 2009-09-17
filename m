Return-Path: <linux-kernel-owner+w=401wt.eu-S1758374AbZIQQZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbZIQQZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 12:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbZIQQZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 12:25:34 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44939 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbZIQQZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 12:25:33 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>, Cliff Cai <cliff.cai@analog.com>
Subject: [PATCH 05/12 v2] USB: musb: add notes for Blackfin anomalies
Date: Thu, 17 Sep 2009 12:25:34 -0400
Message-Id: <1253204734-14061-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <4AB22CAB.1080905@ru.mvista.com>
References: <4AB22CAB.1080905@ru.mvista.com>
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
v2
	- clean up grammar pointed out by Sergei Shtylyov

 drivers/usb/musb/blackfin.h |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/musb/blackfin.h b/drivers/usb/musb/blackfin.h
index a240c1e..b49a362 100644
--- a/drivers/usb/musb/blackfin.h
+++ b/drivers/usb/musb/blackfin.h
@@ -14,6 +14,33 @@
  * Blackfin specific definitions
  */
 
+/* Anomalies notes:
+ *
+ *  05000450 - USB DMA Mode 1 Short Packet Data Corruption:
+ *             MUSB driver is designed to transfer buffer of N * maxpacket size
+ *             in DMA mode 1 and leave the rest of the data to the next
+ *             transfer in DMA mode 0, so we never transmit a short packet in
+ *             DMA mode 1.
+ *
+ *  05000463 - This anomaly doesn't affect this driver since it
+ *             never uses L1 or L2 memory as data destination.
+ *
+ *  05000464 - This anomaly doesn't affect this driver since it
+ *             never uses L1 or L2 memory as data source.
+ *
+ *  05000465 - The anomaly can be seen when SCLK is over 100 MHz, and there is
+ *             no way to workaround for bulk endpoints.  Since the wMaxPackSize
+ *             of bulk is less than or equal to 512, while the fifo size of
+ *             endpoint 5, 6, 7 is 1024, the double buffer mode is enabled
+ *             automatically when these endpoints are used for bulk OUT.
+ *
+ *  05000466 - This anomaly doesn't affect this driver since it never mixes
+ *             concurrent DMA and core accesses to the TX endpoint FIFOs.
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

