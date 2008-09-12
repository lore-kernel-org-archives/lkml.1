Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYILKrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYILKrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 06:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYILKrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 06:47:08 -0400
Received: from sh.osrg.net ([192.16.179.4]:37421 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbYILKrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 06:47:06 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 1/3] add iommu_device_max_index IOMMU helper function
Date: Fri, 12 Sep 2008 19:42:33 +0900
Message-Id: <1221216155-17640-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.5.GIT
In-Reply-To: <1221216155-17640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1221216155-17640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function helps IOMMUs to know the highest address that a device
can access to.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/iommu-helper.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/iommu-helper.h b/include/linux/iommu-helper.h
index c975caf..58f4110 100644
--- a/include/linux/iommu-helper.h
+++ b/include/linux/iommu-helper.h
@@ -1,3 +1,13 @@
+static inline unsigned long iommu_device_max_index(unsigned long size,
+						   unsigned long offset,
+						   u64 dma_mask)
+{
+	if (size + offset > dma_mask)
+		return dma_mask - offset + 1;
+	else
+		return size;
+}
+
 extern int iommu_is_span_boundary(unsigned int index, unsigned int nr,
 				  unsigned long shift,
 				  unsigned long boundary_size);
-- 
1.5.5.GIT

