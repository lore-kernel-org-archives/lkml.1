Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbZK0Nzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbZK0Nzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZK0Nzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:55:52 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:32076 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZK0Nzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:51 -0500
X-SpamScore: 1
X-BigFish: VPS1(zz18c1J655Nc8kzz1202hzz92fbmz32i6bh65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KTRTD1-02-34K-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/34] x86/amd-iommu: Separate internal interface definitions
Date: Fri, 27 Nov 2009 14:55:12 +0100
Message-ID: <1259330145-14865-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:47.0811 (UTC) FILETIME=[52657330:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves all function declarations which are only
used inside the driver code to a seperate header file.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu.h       |   10 +++-----
 arch/x86/include/asm/amd_iommu_proto.h |   38 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/amd_iommu_types.h |    5 ----
 arch/x86/kernel/amd_iommu.c            |    1 +
 arch/x86/kernel/amd_iommu_init.c       |    1 +
 5 files changed, 44 insertions(+), 11 deletions(-)
 create mode 100644 arch/x86/include/asm/amd_iommu_proto.h

diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index b8ef2ee..0891338 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -23,15 +23,13 @@
 #include <linux/irqreturn.h>
 
 #ifdef CONFIG_AMD_IOMMU
-extern int amd_iommu_init_dma_ops(void);
-extern int amd_iommu_init_passthrough(void);
+
 extern void amd_iommu_detect(void);
-extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
-extern void amd_iommu_flush_all_domains(void);
-extern void amd_iommu_flush_all_devices(void);
-extern void amd_iommu_apply_erratum_63(u16 devid);
+
 #else
+
 static inline void amd_iommu_detect(void) { }
+
 #endif
 
 #endif /* _ASM_X86_AMD_IOMMU_H */
diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/arch/x86/include/asm/amd_iommu_proto.h
new file mode 100644
index 0000000..84786fb
--- /dev/null
+++ b/arch/x86/include/asm/amd_iommu_proto.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright (C) 2009 Advanced Micro Devices, Inc.
+ * Author: Joerg Roedel <joerg.roedel@amd.com>
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
+#ifndef _ASM_X86_AMD_IOMMU_PROTO_H
+#define _ASM_X86_AMD_IOMMU_PROTO_H
+
+struct amd_iommu;
+
+extern int amd_iommu_init_dma_ops(void);
+extern int amd_iommu_init_passthrough(void);
+extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
+extern void amd_iommu_flush_all_domains(void);
+extern void amd_iommu_flush_all_devices(void);
+extern void amd_iommu_apply_erratum_63(u16 devid);
+extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
+
+#ifndef CONFIG_AMD_IOMMU_STATS
+
+static inline void amd_iommu_stats_init(void) { }
+
+#endif /* !CONFIG_AMD_IOMMU_STATS */
+
+#endif /* _ASM_X86_AMD_IOMMU_PROTO_H  */
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 2a2cc7a..27db7f9 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -462,11 +462,6 @@ struct __iommu_counter {
 #define ADD_STATS_COUNTER(name, x)
 #define SUB_STATS_COUNTER(name, x)
 
-static inline void amd_iommu_stats_init(void) { }
-
 #endif /* CONFIG_AMD_IOMMU_STATS */
 
-/* some function prototypes */
-extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
-
 #endif /* _ASM_X86_AMD_IOMMU_TYPES_H */
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index b74b212..50d2b05 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -28,6 +28,7 @@
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
+#include <asm/amd_iommu_proto.h>
 #include <asm/amd_iommu_types.h>
 #include <asm/amd_iommu.h>
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 72bdbda..db30cfe 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/msi.h>
 #include <asm/pci-direct.h>
+#include <asm/amd_iommu_proto.h>
 #include <asm/amd_iommu_types.h>
 #include <asm/amd_iommu.h>
 #include <asm/iommu.h>
-- 
1.6.5.3


