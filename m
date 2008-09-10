Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYIMI3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYIMI3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 04:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758391AbYIMI1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 04:27:44 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:38944 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758251AbYIMI1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 04:27:43 -0400
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-arm@vger.kernel.org
Cc: Eric Miao <eric.miao@marvell.com>, Russell King <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, Rodolfo Giometti <giometti@linux.it>
Date: Wed, 10 Sep 2008 10:07:36 +0200
Message-Id: <1221034056-16587-3-git-send-email-giometti@enneenne.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1221034056-16587-2-git-send-email-giometti@enneenne.com>
References: <1221034056-16587-1-git-send-email-giometti@enneenne.com>
 <1221034056-16587-2-git-send-email-giometti@enneenne.com>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 2/2] PXA: add configurable consistent memory DMA size.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rodolfo Giometti <giometti@linux.it>

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 arch/arm/mach-pxa/include/mach/memory.h |   13 +++++++++++++
 drivers/video/Kconfig                   |   11 +++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/include/mach/memory.h b/arch/arm/mach-pxa/include/mach/memory.h
index 552eb7f..247c2ef 100644
--- a/arch/arm/mach-pxa/include/mach/memory.h
+++ b/arch/arm/mach-pxa/include/mach/memory.h
@@ -49,4 +49,17 @@ void cmx270_pci_adjust_zones(int node, unsigned long *size,
 #define ISA_DMA_THRESHOLD	(PHYS_OFFSET + SZ_64M - 1)
 #endif
 
+/* Override the ARM default */
+#ifdef CONFIG_FB_PXA_CONSISTENT_DMA_SIZE
+
+#if (CONFIG_FB_PXA_CONSISTENT_DMA_SIZE == 0)
+#undef CONFIG_FB_PXA_CONSISTENT_DMA_SIZE
+#define CONFIG_FB_PXA_CONSISTENT_DMA_SIZE 2
+#endif
+
+#define CONSISTENT_DMA_SIZE \
+	(((CONFIG_FB_PXA_CONSISTENT_DMA_SIZE + 1) & ~1) * 1024 * 1024)
+
+#endif
+
 #endif
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 5d5c8c8..6720d78 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1808,6 +1808,17 @@ config FB_PXA_OVERLAY
 	---help---
 	  Frame buffer overlay driver for PXA27x
 
+config FB_PXA_CONSISTENT_DMA_SIZE
+	int "Consistent DMA memory size (MB)"
+	depends on FB_PXA
+	range 1 14
+	default 2
+	help
+	  Increase the DMA consistent memory size according to your video
+	  memory needs, for example if you want to use overlay support.
+	  The size must be 2MB aligned.
+	  If unsure say 2.
+
 config FB_PXA_PARAMETERS
 	bool "PXA LCD command line parameters"
 	default n
-- 
1.5.4.3

