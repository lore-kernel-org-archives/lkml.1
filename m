Return-Path: <linux-kernel-owner+w=401wt.eu-S1030746AbXCNJQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030746AbXCNJQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030715AbXCNJQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:16:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60725 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030746AbXCNJQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:16:06 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 7/13] fix ipath_dma_free_coherent() prototype
Cc: linux-kernel@vger.kernel.org, rolandd@cisco.com
Message-Id: <E1HRPaW-00039Z-Ne@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:16:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


method gets u64, not dma_addr_t

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/infiniband/hw/ipath/ipath_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_dma.c b/drivers/infiniband/hw/ipath/ipath_dma.c
index f6f9490..f87f003 100644
--- a/drivers/infiniband/hw/ipath/ipath_dma.c
+++ b/drivers/infiniband/hw/ipath/ipath_dma.c
@@ -167,7 +167,7 @@ static void *ipath_dma_alloc_coherent(struct ib_device *dev, size_t size,
 }
 
 static void ipath_dma_free_coherent(struct ib_device *dev, size_t size,
-				    void *cpu_addr, dma_addr_t dma_handle)
+				    void *cpu_addr, u64 dma_handle)
 {
 	free_pages((unsigned long) cpu_addr, get_order(size));
 }
-- 
1.5.0-rc2.GIT


