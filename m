Return-Path: <linux-kernel-owner+w=401wt.eu-S1763835AbXH0VXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763835AbXH0VXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760125AbXH0VOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:14:12 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1173 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758941AbXH0VOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:14:08 -0400
Message-Id: <20070827211400.040995000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:58:11 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 21/23] savage_bci.c: drm_alloc + memset to drm_zalloc and cleanup
Content-Disposition: inline; filename=savage_bci.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The initialization in for loop can be removed as the SET_AGE macro
set the age struct and other members to zero.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/savage_bci.c | 31888 -> 31634 (-254 bytes)
 drivers/char/drm/savage_bci.o | 138936 -> 138984 (+48 bytes)

 drivers/char/drm/savage_bci.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/savage_bci.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/savage_bci.c
@@ -294,20 +294,13 @@ void savage_freelist_put(struct drm_devi
  */
 static int savage_dma_init(drm_savage_private_t * dev_priv)
 {
-	unsigned int i;
-
 	dev_priv->nr_dma_pages = dev_priv->cmd_dma->size /
 	    (SAVAGE_DMA_PAGE_SIZE * 4);
-	dev_priv->dma_pages = drm_alloc(sizeof(drm_savage_dma_page_t) *
-					dev_priv->nr_dma_pages, DRM_MEM_DRIVER);
-	if (dev_priv->dma_pages == NULL)
+	dev_priv->dma_pages = drm_calloc(dev_priv->nr_dma_pages,
+				sizeof(drm_savage_dma_page_t), DRM_MEM_DRIVER);
+	if (!dev_priv->dma_pages)
 		return DRM_ERR(ENOMEM);

-	for (i = 0; i < dev_priv->nr_dma_pages; ++i) {
-		SET_AGE(&dev_priv->dma_pages[i].age, 0, 0);
-		dev_priv->dma_pages[i].used = 0;
-		dev_priv->dma_pages[i].flushed = 0;
-	}
 	SET_AGE(&dev_priv->last_dma_age, 0, 0);

 	dev_priv->first_dma_page = 0;
@@ -539,11 +532,10 @@ int savage_driver_load(struct drm_device
 {
 	drm_savage_private_t *dev_priv;

-	dev_priv = drm_alloc(sizeof(drm_savage_private_t), DRM_MEM_DRIVER);
-	if (dev_priv == NULL)
+	dev_priv = drm_zalloc(sizeof(drm_savage_private_t), DRM_MEM_DRIVER);
+	if (!dev_priv)
 		return DRM_ERR(ENOMEM);

-	memset(dev_priv, 0, sizeof(drm_savage_private_t));
 	dev->dev_private = (void *)dev_priv;

 	dev_priv->chipset = (enum savage_family)chipset;

--
