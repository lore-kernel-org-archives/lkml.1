Return-Path: <linux-kernel-owner+w=401wt.eu-S1763774AbXH0VUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763774AbXH0VUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758025AbXH0VOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:14:03 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1168 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756692AbXH0VOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:14:00 -0400
Message-Id: <20070827211356.744586000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:58:07 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 17/23] mga_dma.c: drm_alloc + memset to drm_zalloc
Content-Disposition: inline; filename=mga_dma.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/mga_dma.c | 30418 -> 30253 (-165 bytes)
 drivers/char/drm/mga_dma.o | 140668 -> 140304 (-364 bytes)

 drivers/char/drm/mga_dma.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/mga_dma.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/mga_dma.c
@@ -254,23 +254,20 @@ static int mga_freelist_init(struct drm_
 	int i;
 	DRM_DEBUG("count=%d\n", dma->buf_count);

-	dev_priv->head = drm_alloc(sizeof(drm_mga_freelist_t), DRM_MEM_DRIVER);
-	if (dev_priv->head == NULL)
+	dev_priv->head = drm_zalloc(sizeof(drm_mga_freelist_t), DRM_MEM_DRIVER);
+	if (!dev_priv->head)
 		return DRM_ERR(ENOMEM);

-	memset(dev_priv->head, 0, sizeof(drm_mga_freelist_t));
 	SET_AGE(&dev_priv->head->age, MGA_BUFFER_USED, 0);

 	for (i = 0; i < dma->buf_count; i++) {
 		buf = dma->buflist[i];
 		buf_priv = buf->dev_private;

-		entry = drm_alloc(sizeof(drm_mga_freelist_t), DRM_MEM_DRIVER);
-		if (entry == NULL)
+		entry = drm_zalloc(sizeof(drm_mga_freelist_t), DRM_MEM_DRIVER);
+		if (!entry)
 			return DRM_ERR(ENOMEM);

-		memset(entry, 0, sizeof(drm_mga_freelist_t));
-
 		entry->next = dev_priv->head->next;
 		entry->prev = dev_priv->head;
 		SET_AGE(&entry->age, MGA_BUFFER_FREE, 0);
@@ -397,12 +394,11 @@ int mga_driver_load(struct drm_device *
 {
 	drm_mga_private_t *dev_priv;

-	dev_priv = drm_alloc(sizeof(drm_mga_private_t), DRM_MEM_DRIVER);
+	dev_priv = drm_zalloc(sizeof(drm_mga_private_t), DRM_MEM_DRIVER);
 	if (!dev_priv)
 		return DRM_ERR(ENOMEM);

 	dev->dev_private = (void *)dev_priv;
-	memset(dev_priv, 0, sizeof(drm_mga_private_t));

 	dev_priv->usec_timeout = MGA_DEFAULT_USEC_TIMEOUT;
 	dev_priv->chipset = flags;

--
