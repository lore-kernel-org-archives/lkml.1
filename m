Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbZBFKUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbZBFKUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 05:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbZBFKUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 05:20:38 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:51423 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZBFKUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 05:20:37 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82429930"
From: Bryan Wu <cooloney@kernel.org>
To: felipe.balbi@nokia.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] usb: musb: tweak musb_read_fifo() to avoid unused warnings
Date: Fri,  6 Feb 2009 18:22:16 +0800
Message-Id: <1233915736-18506-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/musb/blackfin.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index 7861348..0ebb19d 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -54,13 +54,11 @@ void musb_write_fifo(struct musb_hw_ep *hw_ep, u16 len, const u8 *src)
 void musb_read_fifo(struct musb_hw_ep *hw_ep, u16 len, u8 *dst)
 {
 	void __iomem *fifo = hw_ep->fifo;
+
+#ifdef CONFIG_BF52x
 	u8 epnum = hw_ep->epnum;
 	u16 dma_reg = 0;
 
-	DBG(4, "%cX ep%d fifo %p count %d buf %p\n",
-			'R', hw_ep->epnum, fifo, len, dst);
-
-#ifdef CONFIG_BF52x
 	invalidate_dcache_range((unsigned int)dst,
 		(unsigned int)(dst + len));
 
@@ -103,6 +101,9 @@ void musb_read_fifo(struct musb_hw_ep *hw_ep, u16 len, u8 *dst)
 			len & 0x01 ? (len >> 1) + 1 : len >> 1);
 #endif
 
+	DBG(4, "%cX ep%d fifo %p count %d buf %p\n",
+			'R', hw_ep->epnum, fifo, len, dst);
+
 	dump_fifo_data(dst, len);
 }
 
-- 
1.5.6.3
