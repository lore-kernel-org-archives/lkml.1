Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYIYKP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYIYKP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 06:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbYIYKOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 06:14:22 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:4654 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbYIYKOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 06:14:21 -0400
X-BigFish: VPS3(zzzzzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7QXRA-03-FWG-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/3] x86/iommu: make GART driver checkpatch clean
Date: Thu, 25 Sep 2008 12:13:53 +0200
Message-ID: <1222337635-28285-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1222337635-28285-1-git-send-email-joerg.roedel@amd.com>
References: <1222337635-28285-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Sep 2008 10:13:55.0502 (UTC) FILETIME=[6AD74CE0:01C91EF7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-gart_64.c |   17 +++++++++--------
 include/asm-x86/gart.h        |    2 ++
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index b85a2f9..aa569db 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -27,8 +27,8 @@
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
 #include <linux/sysdev.h>
+#include <linux/io.h>
 #include <asm/atomic.h>
-#include <asm/io.h>
 #include <asm/mtrr.h>
 #include <asm/pgtable.h>
 #include <asm/proto.h>
@@ -175,7 +175,8 @@ static void dump_leak(void)
 	       iommu_leak_pages);
 	for (i = 0; i < iommu_leak_pages; i += 2) {
 		printk(KERN_DEBUG "%lu: ", iommu_pages-i);
-		printk_address((unsigned long) iommu_leak_tab[iommu_pages-i], 0);
+		printk_address((unsigned long) iommu_leak_tab[iommu_pages-i],
+				0);
 		printk(KERN_CONT "%c", (i+1)%2 == 0 ? '\n' : ' ');
 	}
 	printk(KERN_DEBUG "\n");
@@ -688,7 +689,8 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 	if (!error)
 		error = sysdev_register(&device_gart);
 	if (error)
-		panic("Could not register gart_sysdev -- would corrupt data on next suspend");
+		panic("Could not register gart_sysdev -- "
+		      "would corrupt data on next suspend");
 
 	flush_gart();
 
@@ -710,8 +712,6 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 	return -1;
 }
 
-extern int agp_amd64_init(void);
-
 static struct dma_mapping_ops gart_dma_ops = {
 	.map_single			= gart_map_single,
 	.unmap_single			= gart_unmap_single,
@@ -777,8 +777,8 @@ void __init gart_iommu_init(void)
 	    (no_agp && init_k8_gatt(&info) < 0)) {
 		if (max_pfn > MAX_DMA32_PFN) {
 			printk(KERN_WARNING "More than 4GB of memory "
-			       	          "but GART IOMMU not available.\n"
-			       KERN_WARNING "falling back to iommu=soft.\n");
+			       "but GART IOMMU not available.\n");
+			printk(KERN_WARNING "falling back to iommu=soft.\n");
 		}
 		return;
 	}
@@ -868,7 +868,8 @@ void __init gart_parse_options(char *p)
 	if (!strncmp(p, "leak", 4)) {
 		leak_trace = 1;
 		p += 4;
-		if (*p == '=') ++p;
+		if (*p == '=')
+			++p;
 		if (isdigit(*p) && get_option(&p, &arg))
 			iommu_leak_pages = arg;
 	}
diff --git a/include/asm-x86/gart.h b/include/asm-x86/gart.h
index 3f62a83..cdf4f78 100644
--- a/include/asm-x86/gart.h
+++ b/include/asm-x86/gart.h
@@ -29,6 +29,8 @@ extern int fix_aperture;
 #define AMD64_GARTCACHECTL	0x9c
 #define AMD64_GARTEN		(1<<0)
 
+extern int agp_amd64_init(void);
+
 static inline void enable_gart_translation(struct pci_dev *dev, u64 addr)
 {
 	u32 tmp, ctl;
-- 
1.5.6.4


