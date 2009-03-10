Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbZCJFUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbZCJFUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbZCJFMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:12:17 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:51849 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbZCJFMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:12:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ptngl9GrqMNpF2o3bowkghliRV+S5A0VkG5csxN5neKJftcSyO2qJRxVOFNy7z4U//
         ozjfg6aZL8WFzMb/+TsF1d2Yk+E1rTybCfd/lboU/9cy2IgR91DpISYsYFH6SbBta7mc
         uQIUhGSzVV0Zq+HAXwsLQQyVYhk/p9oucvgJo=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>
Subject: [PATCH 25/25] [drivers] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:50 -0500
Message-Id: <1236661850-8237-26-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-25-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-5-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-6-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-9-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-10-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-11-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-12-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-13-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-14-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-15-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-16-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-17-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-18-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-19-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-20-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-21-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-22-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-23-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-24-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-25-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 drivers/ata/pata_hpt366.c       |    3 +--
 drivers/base/iommu.c            |    4 +---
 drivers/gpu/drm/i915/intel_fb.c |    6 ++----
 drivers/mtd/ssfdc.c             |    3 +--
 drivers/sh/intc.c               |    3 +--
 5 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 65c28e5..8e0c9f6 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -234,8 +234,7 @@ static void hpt366_set_mode(struct ata_port *ap, struct ata_device *adev,
 			break;
 		clocks++;
 	}
-	if (!clocks->xfer_mode)
-		BUG();
+	BUG_ON(!clocks->xfer_mode);
 
 	/*
 	 * Combine new mode bits with old config bits and disable
diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
index 5e039d4..e564416 100644
--- a/drivers/base/iommu.c
+++ b/drivers/base/iommu.c
@@ -25,9 +25,7 @@ static struct iommu_ops *iommu_ops;
 
 void register_iommu(struct iommu_ops *ops)
 {
-	if (iommu_ops)
-		BUG();
-
+	BUG_ON(iommu_ops);
 	iommu_ops = ops;
 }
 
diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index b7f0ebe..201b65c 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -663,8 +663,7 @@ static int intelfb_multi_fb_probe_crtc(struct drm_device *dev, struct drm_crtc *
 			if (connector->encoder->crtc == modeset->crtc) {
 				modeset->connectors[conn_count] = connector;
 				conn_count++;
-				if (conn_count > INTELFB_CONN_LIMIT)
-					BUG();
+				BUG_ON(conn_count > INTELFB_CONN_LIMIT);
 			}
 	}
 
@@ -812,8 +811,7 @@ static int intelfb_single_fb_probe(struct drm_device *dev)
 
 			if(connector->encoder->crtc == modeset->crtc) {
 				modeset->connectors[conn_count++] = connector;
-				if (conn_count > INTELFB_CONN_LIMIT)
-					BUG();
+				BUG_ON(conn_count > INTELFB_CONN_LIMIT);
 			}
 		}
 
diff --git a/drivers/mtd/ssfdc.c b/drivers/mtd/ssfdc.c
index 3f67e00..5a1d8e2 100644
--- a/drivers/mtd/ssfdc.c
+++ b/drivers/mtd/ssfdc.c
@@ -393,8 +393,7 @@ static int ssfdcr_readsect(struct mtd_blktrans_dev *dev,
 		" block_addr=%d\n", logic_sect_no, sectors_per_block, offset,
 		block_address);
 
-	if (block_address >= ssfdc->map_len)
-		BUG();
+	BUG_ON(block_address >= ssfdc->map_len);
 
 	block_address = ssfdc->logic_block_map[block_address];
 
diff --git a/drivers/sh/intc.c b/drivers/sh/intc.c
index 58d24c5..a031989 100644
--- a/drivers/sh/intc.c
+++ b/drivers/sh/intc.c
@@ -458,8 +458,7 @@ static unsigned int __init intc_prio_data(struct intc_desc *desc,
 			} else {
 				fn = REG_FN_MODIFY_BASE;
 				mode = MODE_PRIO_REG;
-				if (!pr->set_reg)
-					BUG();
+				BUG_ON(!pr->set_reg);
 				reg_e = pr->set_reg;
 				reg_d = pr->set_reg;
 			}
-- 
1.6.1.3

