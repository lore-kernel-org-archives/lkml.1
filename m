Return-Path: <linux-kernel-owner+w=401wt.eu-S1764221AbZCaWz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764221AbZCaWz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763773AbZCaWwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:52:24 -0400
Received: from gw.goop.org ([64.81.55.164]:53483 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762396AbZCaWwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:52:20 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 8/9] xen/swiotlb: add sync functions
Date: Tue, 31 Mar 2009 15:52:14 -0700
Message-Id: <1238539935-4295-9-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1238539935-4295-1-git-send-email-jeremy@goop.org>
References: <1238539935-4295-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: bugfix

Add all the missing sync functions.  This fixes iwlagn.
(Need to think about what to do with non-swiotlb mode.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/pci/xen-iommu.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index 080aec1..e85c1cf 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -311,6 +311,13 @@ static struct dma_mapping_ops xen_swiotlb_dma_ops = {
 
 	.mapping_error = swiotlb_dma_mapping_error,
 
+	.sync_single_for_cpu = swiotlb_sync_single_for_cpu,
+	.sync_single_for_device = swiotlb_sync_single_for_device,
+	.sync_single_range_for_cpu = swiotlb_sync_single_range_for_cpu,
+	.sync_single_range_for_device = swiotlb_sync_single_range_for_device,
+	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
+	.sync_sg_for_device = swiotlb_sync_sg_for_device,
+
 	.is_phys = 0,
 };
 
-- 
1.6.0.6

