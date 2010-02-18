Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab0BRRGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:06:55 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:53858 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758653Ab0BRRGv (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 18 Feb 2010 12:06:51 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       dwmw2@infradead.org, alex.williamson@hp.com
Cc: jeremy@goop.org, Ian.Campbell@eu.citrix.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 08/10] swiotlb: Re-order the function declerations.
Date: Thu, 18 Feb 2010 11:27:04 -0500
Message-Id: <1266510426-6815-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266510426-6815-8-git-send-email-konrad.wilk@oracle.com>
References: <1266510426-6815-1-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-2-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-3-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-4-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-5-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-6-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-7-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-8-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B7D6E9F.0089:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move to the top the function declerations dealing with startup/shutdown
of SWIOTLB. This is in preperation of next set of patches which export
bookkeeping functions out of swiotlb.c. This will move all of them
at the top of the header file, while the dma_ops functions are the end
of the header file.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/swiotlb.h |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index febedcf..84e7a53 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -23,7 +23,15 @@ extern int swiotlb_force;
 #define IO_TLB_SHIFT 11
 
 extern void swiotlb_init(int verbose);
+#ifdef CONFIG_SWIOTLB
+extern void __init swiotlb_free(void);
+#else
+static inline void swiotlb_free(void) { }
+#endif
+extern void swiotlb_print_info(void);
+
 
+/* IOMMU functions. */
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
@@ -89,11 +97,4 @@ swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
 extern int
 swiotlb_dma_supported(struct device *hwdev, u64 mask);
 
-#ifdef CONFIG_SWIOTLB
-extern void __init swiotlb_free(void);
-#else
-static inline void swiotlb_free(void) { }
-#endif
-
-extern void swiotlb_print_info(void);
 #endif /* __LINUX_SWIOTLB_H */
-- 
1.6.2.5

