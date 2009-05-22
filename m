Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbZEVMNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbZEVMNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756307AbZEVMNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:13:04 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:62342 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZEVMNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:13:01 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KK1OLF-04-9VX-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/7] amd-iommu: add amd_iommu_dump parameter
Date: Fri, 22 May 2009 14:12:43 +0200
Message-ID: <1242994369-28697-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994369-28697-1-git-send-email-joerg.roedel@amd.com>
References: <1242994369-28697-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:12:49.0808 (UTC) FILETIME=[9FF24100:01C9DAD6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: add parameter to dump the ACPI table for AMD IOMMU ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    6 ++++++
 arch/x86/kernel/amd_iommu_init.c       |   10 ++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 95c8cd9..89dfb37 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -194,6 +194,12 @@
 #define PD_DMA_OPS_MASK		(1UL << 0) /* domain used for dma_ops */
 #define PD_DEFAULT_MASK		(1UL << 1) /* domain is a default dma_ops
 					      domain for an IOMMU */
+extern bool amd_iommu_dump;
+#define DUMP_printk(format, arg...)					\
+	do {								\
+		if (amd_iommu_dump)						\
+			printk(KERN_INFO "AMD IOMMU: " format, ## arg);	\
+	} while(0);
 
 /*
  * This structure contains generic data for  IOMMU protection domains
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 8c0be09..57fb7a7 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -115,6 +115,8 @@ struct ivmd_header {
 	u64 range_length;
 } __attribute__((packed));
 
+bool amd_iommu_dump;
+
 static int __initdata amd_iommu_detected;
 
 u16 amd_iommu_last_bdf;			/* largest PCI device id we have
@@ -1211,6 +1213,13 @@ void __init amd_iommu_detect(void)
  *
  ****************************************************************************/
 
+static int __init parse_amd_iommu_dump(char *str)
+{
+	amd_iommu_dump = true;
+
+	return 1;
+}
+
 static int __init parse_amd_iommu_options(char *str)
 {
 	for (; *str; ++str) {
@@ -1235,5 +1244,6 @@ static int __init parse_amd_iommu_size_options(char *str)
 	return 1;
 }
 
+__setup("amd_iommu_dump", parse_amd_iommu_dump);
 __setup("amd_iommu=", parse_amd_iommu_options);
 __setup("amd_iommu_size=", parse_amd_iommu_size_options);
-- 
1.6.3.1


