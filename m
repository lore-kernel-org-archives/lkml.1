Return-Path: <linux-kernel-owner+w=401wt.eu-S1758453AbZAFW3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453AbZAFW3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbZAFWOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:14:06 -0500
Received: from kroah.org ([198.145.64.141]:51307 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755763AbZAFWOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:14:03 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Tony Luck <tony.luck@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 44/60] IA64: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:12:03 -0800
Message-Id: <1231279939-32728-44-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/ia64/kernel/pci-dma.c  |    2 +-
 arch/ia64/sn/kernel/tiocx.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index 2a92f63..d0ada06 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -39,7 +39,7 @@ int iommu_detected __read_mostly;
    be probably a smaller DMA mask, but this is bug-to-bug compatible
    to i386. */
 struct device fallback_dev = {
-	.bus_id = "fallback device",
+	.init_name = "fallback device",
 	.coherent_dma_mask = DMA_32BIT_MASK,
 	.dma_mask = &fallback_dev.coherent_dma_mask,
 };
diff --git a/arch/ia64/sn/kernel/tiocx.c b/arch/ia64/sn/kernel/tiocx.c
index a88eba3..3f86423 100644
--- a/arch/ia64/sn/kernel/tiocx.c
+++ b/arch/ia64/sn/kernel/tiocx.c
@@ -206,8 +206,7 @@ cx_device_register(nasid_t nasid, int part_num, int mfg_num,
 	cx_dev->dev.parent = NULL;
 	cx_dev->dev.bus = &tiocx_bus_type;
 	cx_dev->dev.release = tiocx_bus_release;
-	snprintf(cx_dev->dev.bus_id, BUS_ID_SIZE, "%d",
-		 cx_dev->cx_id.nasid);
+	dev_set_name(&cx_dev->dev, "%d", cx_dev->cx_id.nasid);
 	device_register(&cx_dev->dev);
 	get_device(&cx_dev->dev);
 
-- 
1.6.0.4

