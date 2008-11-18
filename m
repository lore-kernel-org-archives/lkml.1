Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbYKRIX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbYKRIX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYKRIWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:22:21 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:29131 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbYKRIWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:22:14 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62691805"
From: Bryan Wu <cooloney@kernel.org>
To: felipe.balbi@nokia.com, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/6] usb: musb: Kill some compiling warning in musb Blackfin part
Date: Tue, 18 Nov 2008 16:23:37 +0800
Message-Id: <1226996620-11388-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226996620-11388-1-git-send-email-cooloney@kernel.org>
References: <1226996620-11388-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/musb/blackfin.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index 6299cf0..c4ade98 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -41,9 +41,11 @@ void musb_write_fifo(struct musb_hw_ep *hw_ep, u16 len, const u8 *src)
 	dump_fifo_data(src, len);
 
 	if (unlikely((unsigned long)src & 0x01))
-		outsw_8(fifo, src, len & 0x01 ? (len >> 1) + 1 : len >> 1);
+		outsw_8((unsigned long)fifo, src,
+			len & 0x01 ? (len >> 1) + 1 : len >> 1);
 	else
-		outsw(fifo, src, len & 0x01 ? (len >> 1) + 1 : len >> 1);
+		outsw((unsigned long)fifo, src,
+			len & 0x01 ? (len >> 1) + 1 : len >> 1);
 }
 
 /*
@@ -54,8 +56,6 @@ void musb_read_fifo(struct musb_hw_ep *hw_ep, u16 len, u8 *dst)
 	void __iomem *fifo = hw_ep->fifo;
 	u8 epnum = hw_ep->epnum;
 	u16 dma_reg = 0;
-	int i;
-	u16 *data;
 
 	DBG(4, "%cX ep%d fifo %p count %d buf %p\n",
 			'R', hw_ep->epnum, fifo, len, dst);
@@ -96,9 +96,11 @@ void musb_read_fifo(struct musb_hw_ep *hw_ep, u16 len, u8 *dst)
 	SSYNC();
 #else
 	if (unlikely((unsigned long)dst & 0x01))
-		insw_8(fifo, dst, len & 0x01 ? (len >> 1) + 1 : len >> 1);
+		insw_8((unsigned long)fifo, dst,
+			len & 0x01 ? (len >> 1) + 1 : len >> 1);
 	else
-		insw(fifo, dst, len & 0x01 ? (len >> 1) + 1 : len >> 1);
+		insw((unsigned long)fifo, dst,
+			len & 0x01 ? (len >> 1) + 1 : len >> 1);
 #endif
 
 	dump_fifo_data(dst, len);
-- 
1.5.6.3
