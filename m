Return-Path: <linux-kernel-owner+w=401wt.eu-S1761304AbYFZTgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761304AbYFZTgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761356AbYFZT3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:08 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:4135 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761303AbYFZT3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:02 -0400
X-BigFish: VPS4(z1039oz18c1K655Oc8kzz10d3izzz32i43j67h)
X-Spam-TCS-SCL: 6:0
X-WSS-ID: 0K334RU-04-UOI-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 30/34] AMD IOMMU: add amd_iommu.h to export functions to the generic x86 dma code
Date: Thu, 26 Jun 2008 21:28:06 +0200
Message-ID: <1214508490-29683-31-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:12.0221 (UTC) FILETIME=[C5CCA6D0:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the amd_iommu.h file which will be included in the generic
code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c      |    1 +
 arch/x86/kernel/amd_iommu_init.c |    1 +
 include/asm-x86/amd_iommu.h      |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-x86/amd_iommu.h

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index c282bde..134dea1 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -25,6 +25,7 @@
 #include <asm/proto.h>
 #include <asm/gart.h>
 #include <asm/amd_iommu_types.h>
+#include <asm/amd_iommu.h>
 
 #define CMD_SET_TYPE(cmd, t) ((cmd)->data[1] |= ((t) << 28))
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index ec6f13b..bae4a76 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -23,6 +23,7 @@
 #include <linux/list.h>
 #include <asm/pci-direct.h>
 #include <asm/amd_iommu_types.h>
+#include <asm/amd_iommu.h>
 #include <asm/gart.h>
 
 /*
diff --git a/include/asm-x86/amd_iommu.h b/include/asm-x86/amd_iommu.h
new file mode 100644
index 0000000..30a1204
--- /dev/null
+++ b/include/asm-x86/amd_iommu.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright (C) 2007-2008 Advanced Micro Devices, Inc.
+ * Author: Joerg Roedel <joerg.roedel@amd.com>
+ *         Leo Duran <leo.duran@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#ifndef _ASM_X86_AMD_IOMMU_H
+#define _ASM_X86_AMD_IOMMU_H
+
+#ifdef CONFIG_AMD_IOMMU
+extern int amd_iommu_init(void);
+extern int amd_iommu_init_dma_ops(void);
+extern void amd_iommu_detect(void);
+#else
+static inline int amd_iommu_init(void) { return -ENODEV; }
+static inline void amd_iommu_detect(void) { }
+#endif
+
+#endif
-- 
1.5.3.7


