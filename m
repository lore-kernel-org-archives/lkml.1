Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbYHDQFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbYHDQFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYHDQFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:05:03 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:50348 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYHDQFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:05:02 -0400
X-BigFish: VPS11(z1039ozzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K533C0-04-0U9-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, rth@twiddle.net,
       paulus@samba.org, benh@kernel.crashing.org, davem@davemloft.net,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Muli Ben-Yehuda <muli@il.ibm.com>, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/10] introduce generic iommu_num_pages function
Date: Mon, 4 Aug 2008 18:04:44 +0200
Message-ID: <1217865890-3593-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Aug 2008 16:04:51.0589 (UTC) FILETIME=[D3C43350:01C8F64B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the generic iommu_num_pages function. It can be used by
different architectures to calculate the number of IOMMU pages required to map
a given memory area.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/iommu-helper.h |    2 ++
 lib/iommu-helper.c           |    9 +++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/iommu-helper.h b/include/linux/iommu-helper.h
index c975caf..cb659aa 100644
--- a/include/linux/iommu-helper.h
+++ b/include/linux/iommu-helper.h
@@ -8,3 +8,5 @@ extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 				      unsigned long align_mask);
 extern void iommu_area_free(unsigned long *map, unsigned long start,
 			    unsigned int nr);
+extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len,
+				     unsigned long io_page_size);
diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index a3b8d4c..ca4a963 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -80,3 +80,12 @@ void iommu_area_free(unsigned long *map, unsigned long start, unsigned int nr)
 	}
 }
 EXPORT_SYMBOL(iommu_area_free);
+
+unsigned long iommu_num_pages(unsigned long addr, unsigned long len,
+			      unsigned long io_page_size)
+{
+	unsigned long size = (addr & (io_page_size - 1)) + len;
+
+	return DIV_ROUND_UP(size, io_page_size);
+}
+EXPORT_SYMBOL(iommu_num_pages);
-- 
1.5.3.7


