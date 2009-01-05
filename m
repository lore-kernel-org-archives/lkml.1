Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbZAEPTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbZAEPTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbZAEPSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:18:52 -0500
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:33780 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145AbZAEPSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:18:51 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 05/13] add dma_mapping_ops for SGI Altix
Date: Mon,  5 Jan 2009 23:36:10 +0900
Message-Id: <1231166178-20050-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231166178-20050-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1231166178-20050-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166178-20050-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166178-20050-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166178-20050-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166178-20050-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is for IA64_SGI_SN2.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/sn/pci/pci_dma.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index 53ebb64..4ad13ff 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -11,6 +11,7 @@
 
 #include <linux/module.h>
 #include <linux/dma-attrs.h>
+#include <linux/dma-mapping.h>
 #include <asm/dma.h>
 #include <asm/sn/intr.h>
 #include <asm/sn/pcibus_provider_defs.h>
@@ -465,3 +466,18 @@ int sn_pci_legacy_write(struct pci_bus *bus, u16 port, u32 val, u8 size)
  out:
 	return ret;
 }
+
+struct dma_mapping_ops sn_dma_ops = {
+	.alloc_coherent		= sn_dma_alloc_coherent,
+	.free_coherent		= sn_dma_free_coherent,
+	.map_single_attrs	= sn_dma_map_single_attrs,
+	.unmap_single_attrs	= sn_dma_unmap_single_attrs,
+	.map_sg_attrs		= sn_dma_map_sg_attrs,
+	.unmap_sg_attrs		= sn_dma_unmap_sg_attrs,
+	.sync_single_for_cpu 	= sn_dma_sync_single_for_cpu,
+	.sync_sg_for_cpu	= sn_dma_sync_sg_for_cpu,
+	.sync_single_for_device = sn_dma_sync_single_for_device,
+	.sync_sg_for_device	= sn_dma_sync_sg_for_device,
+	.mapping_error		= sn_dma_mapping_error,
+	.dma_supported_op	= sn_dma_supported,
+};
-- 
1.6.0.6

