Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbYKRIX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbYKRIX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYKRIWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:22:23 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:29131 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYKRIWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:22:16 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62691807"
From: Bryan Wu <cooloney@kernel.org>
To: felipe.balbi@nokia.com, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 5/6] usb: musb: tweak musb_read_fifo() to avoid unused warnings
Date: Tue, 18 Nov 2008 16:23:39 +0800
Message-Id: <1226996620-11388-6-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226996620-11388-1-git-send-email-cooloney@kernel.org>
References: <1226996620-11388-1-git-send-email-cooloney@kernel.org>
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
index c4ade98..6ee1fd6 100644
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
