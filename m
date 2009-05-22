Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbZEVMRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbZEVMRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758083AbZEVMQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:16:10 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:36130
	"EHLO WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758076AbZEVMQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:16:08 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KK1OQE-03-94B-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/9] amd-iommu: add function to flush tlb for all domains
Date: Fri, 22 May 2009 14:15:37 +0200
Message-ID: <1242994540-28799-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
References: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:15:42.0423 (UTC) FILETIME=[06D53670:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: be able to flush io/tlb for all allocated domains ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu.h |    1 +
 arch/x86/kernel/amd_iommu.c      |   11 +++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index f712344..1750e1f 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -27,6 +27,7 @@ extern int amd_iommu_init(void);
 extern int amd_iommu_init_dma_ops(void);
 extern void amd_iommu_detect(void);
 extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
+extern void amd_iommu_flush_all_domains(void);
 #else
 static inline int amd_iommu_init(void) { return -ENODEV; }
 static inline void amd_iommu_detect(void) { }
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index d9e9dc1..826ad07 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -449,6 +449,17 @@ static void iommu_flush_domain(u16 domid)
 	}
 }
 
+void amd_iommu_flush_all_domains(void)
+{
+	int i;
+
+	for (i = 1; i < MAX_DOMAIN_ID; ++i) {
+		if (!test_bit(i, amd_iommu_pd_alloc_bitmap))
+			continue;
+		iommu_flush_domain(i);
+	}
+}
+
 /****************************************************************************
  *
  * The functions below are used the create the page table mappings for
-- 
1.6.3.1


