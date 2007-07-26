Return-Path: <linux-kernel-owner+w=401wt.eu-S935683AbXGZQmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935683AbXGZQmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934266AbXGZQgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:36:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43333 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934299AbXGZQgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:36:11 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] drivers/ misc __iomem annotations
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1IE6Jt-0005SR-Rp@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:36:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/edac/i3000_edac.c  |    2 +-
 drivers/ide/pci/scc_pata.c |    4 ++--
 drivers/video/tgafb.c      |    2 +-
 drivers/w1/masters/ds1wm.c |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index 0ecfdc4..e895f9f 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -275,7 +275,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	unsigned char *c0dra = dra, *c1dra = &dra[I3000_RANKS_PER_CHANNEL / 2];
 	unsigned char *c0drb = drb, *c1drb = &drb[I3000_RANKS_PER_CHANNEL];
 	unsigned long mchbar;
-	void *window;
+	void __iomem *window;
 
 	debugf0("MC: %s()\n", __func__);
 
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index f668d23..bf19ddf 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -551,8 +551,8 @@ static int setup_mmio_scc (struct pci_dev *dev, const char *name)
 	unsigned long dma_base = pci_resource_start(dev, 1);
 	unsigned long ctl_size = pci_resource_len(dev, 0);
 	unsigned long dma_size = pci_resource_len(dev, 1);
-	void *ctl_addr;
-	void *dma_addr;
+	void __iomem *ctl_addr;
+	void __iomem *dma_addr;
 	int i;
 
 	for (i = 0; i < MAX_HWIFS; i++) {
diff --git a/drivers/video/tgafb.c b/drivers/video/tgafb.c
index 89facb7..d292a37 100644
--- a/drivers/video/tgafb.c
+++ b/drivers/video/tgafb.c
@@ -849,7 +849,7 @@ tgafb_clut_imageblit(struct fb_info *info, const struct fb_image *image)
 	u32 *palette = ((u32 *)info->pseudo_palette);
 	unsigned long pos, line_length, i, j;
 	const unsigned char *data;
-	void *regs_base, *fb_base;
+	void __iomem *regs_base, *fb_base;
 
 	dx = image->dx;
 	dy = image->dy;
diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 763bc73..4b69664 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -85,7 +85,7 @@ static struct {
 };
 
 struct ds1wm_data {
-	void		*map;
+	void		__iomem *map;
 	int		bus_shift; /* # of shifts to calc register offsets */
 	struct platform_device *pdev;
 	struct ds1wm_platform_data *pdata;
-- 
1.5.3.GIT


