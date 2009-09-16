Return-Path: <linux-kernel-owner+w=401wt.eu-S933742AbZIPXkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742AbZIPXkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933651AbZIPXkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:40:22 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45300 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933608AbZIPXit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:38:49 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>, Cliff Cai <cliff.cai@analog.com>
Subject: [PATCH 06/11] USB: musb: add work around for Blackfin anomaly 05000456
Date: Wed, 16 Sep 2009 19:38:40 -0400
Message-Id: <1253144325-1203-6-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
References: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Only allow USE_MODE1 when the Blackfin part is not affected by anomaly
05000456 (USB Receive Interrupt Is Not Generated in DMA Mode 1) since we
can't support the mode in that case.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/musb/musb_dma.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/musb/musb_dma.h b/drivers/usb/musb/musb_dma.h
index 0a2c4e3..916065b 100644
--- a/drivers/usb/musb/musb_dma.h
+++ b/drivers/usb/musb/musb_dma.h
@@ -80,6 +80,17 @@ struct musb_hw_ep;
 #define tusb_dma_omap()			0
 #endif
 
+/* Anomaly 05000456 - USB Receive Interrupt Is Not Generated in DMA Mode 1
+ *	Only allow DMA mode 1 to be used when the USB will actually generate the
+ *	interrupts we expect.
+ */
+#ifdef CONFIG_BLACKFIN
+# undef USE_MODE1
+# if !ANOMALY_05000456
+#  define USE_MODE1
+# endif
+#endif
+
 /*
  * DMA channel status ... updated by the dma controller driver whenever that
  * status changes, and protected by the overall controller spinlock.
-- 
1.6.5.rc1

