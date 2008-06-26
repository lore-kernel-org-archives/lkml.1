Return-Path: <linux-kernel-owner+w=401wt.eu-S1761839AbYFZNAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761839AbYFZNAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759059AbYFZMlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:41:37 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:22527 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758680AbYFZMlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:41:32 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 39/60] microblaze_v4: dma support
Date: Thu, 26 Jun 2008 14:30:08 +0200
Message-Id: <1214483429-32360-40-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-39-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz>
 <1214483429-32360-22-git-send-email-monstr@seznam.cz>
 <1214483429-32360-23-git-send-email-monstr@seznam.cz>
 <1214483429-32360-24-git-send-email-monstr@seznam.cz>
 <1214483429-32360-25-git-send-email-monstr@seznam.cz>
 <1214483429-32360-26-git-send-email-monstr@seznam.cz>
 <1214483429-32360-27-git-send-email-monstr@seznam.cz>
 <1214483429-32360-28-git-send-email-monstr@seznam.cz>
 <1214483429-32360-29-git-send-email-monstr@seznam.cz>
 <1214483429-32360-30-git-send-email-monstr@seznam.cz>
 <1214483429-32360-31-git-send-email-monstr@seznam.cz>
 <1214483429-32360-32-git-send-email-monstr@seznam.cz>
 <1214483429-32360-33-git-send-email-monstr@seznam.cz>
 <1214483429-32360-34-git-send-email-monstr@seznam.cz>
 <1214483429-32360-35-git-send-email-monstr@seznam.cz>
 <1214483429-32360-36-git-send-email-monstr@seznam.cz>
 <1214483429-32360-37-git-send-email-monstr@seznam.cz>
 <1214483429-32360-38-git-send-email-monstr@seznam.cz>
 <1214483429-32360-39-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/dma-mapping.h |    1 +
 include/asm-microblaze/dma.h         |   18 ++++++++++++++++++
 include/asm-microblaze/scatterlist.h |   26 ++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/dma-mapping.h
 create mode 100644 include/asm-microblaze/dma.h
 create mode 100644 include/asm-microblaze/scatterlist.h

diff --git a/include/asm-microblaze/dma-mapping.h b/include/asm-microblaze/dma-mapping.h
new file mode 100644
index 0000000..e7e1690
--- /dev/null
+++ b/include/asm-microblaze/dma-mapping.h
@@ -0,0 +1 @@
+#include <asm-generic/dma-mapping.h>
diff --git a/include/asm-microblaze/dma.h b/include/asm-microblaze/dma.h
new file mode 100644
index 0000000..6ab357b
--- /dev/null
+++ b/include/asm-microblaze/dma.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_DMA_H
+#define _ASM_MICROBLAZE_DMA_H
+
+/* we don't have dma address limit. define it as zero to be
+ * unlimited. */
+#define MAX_DMA_ADDRESS		(0)
+
+#define ISA_DMA_THRESHOLD	(0)
+
+#endif /* _ASM_MICROBLAZE_DMA_H */
diff --git a/include/asm-microblaze/scatterlist.h b/include/asm-microblaze/scatterlist.h
new file mode 100644
index 0000000..bbe73e6
--- /dev/null
+++ b/include/asm-microblaze/scatterlist.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_SCATTERLIST_H
+#define _ASM_MICROBLAZE_SCATTERLIST_H
+
+struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long	sg_magic;
+#endif
+	unsigned long	page_link;
+	dma_addr_t	dma_address;
+	unsigned int	offset;
+	unsigned int	length;
+};
+
+#define sg_dma_address(sg)      ((sg)->dma_address)
+#define sg_dma_len(sg)          ((sg)->length)
+
+#endif /* _ASM_MICROBLAZE_SCATTERLIST_H */
-- 
1.5.4.GIT

