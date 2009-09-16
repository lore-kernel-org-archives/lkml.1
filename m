Return-Path: <linux-kernel-owner+w=401wt.eu-S933698AbZIPXjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698AbZIPXjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933689AbZIPXi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:38:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45311 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933659AbZIPXiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:38:52 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 09/11] USB: musb: error out when anomaly 05000380 is applicable
Date: Wed, 16 Sep 2009 19:38:43 -0400
Message-Id: <1253144325-1203-9-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
References: <1253144325-1203-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Since we can't work around anomaly 05000380, throw a build error up and
instruct the user to use a different mode.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/musb/blackfin.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/musb/blackfin.h b/drivers/usb/musb/blackfin.h
index de62962..21b7730 100644
--- a/drivers/usb/musb/blackfin.h
+++ b/drivers/usb/musb/blackfin.h
@@ -43,6 +43,16 @@
  *             anomaly - 05000465.
  */
 
+/* The Mentor USB DMA engine on BF52x (silicon v0.0 and v0.1) seems to be
+ * unstable in host mode.  This may be caused by Anomaly 05000380.  After
+ * digging out the root cause, we will change this number accordingly.
+ * So, need to either use silicon v0.2+ or disable DMA mode in MUSB.
+ */
+#if ANOMALY_05000380 && defined(CONFIG_BF52x) && \
+    defined(CONFIG_USB_MUSB_HDRC) && !defined(CONFIG_MUSB_PIO_ONLY)
+# error "Please use PIO mode in MUSB driver on bf52x chip v0.0 and v0.1"
+#endif
+
 #undef DUMP_FIFO_DATA
 #ifdef DUMP_FIFO_DATA
 static void dump_fifo_data(u8 *buf, u16 len)
-- 
1.6.5.rc1

