Return-Path: <linux-kernel-owner+w=401wt.eu-S1764335AbXH0VWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764335AbXH0VWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759580AbXH0VOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:14:10 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1170 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411AbXH0VOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:14:08 -0400
Message-Id: <20070827211357.647851000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:58:08 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 18/23] r128_cce.c: drm_alloc + memset to drm_zalloc
Content-Disposition: inline; filename=r128_cce.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/r128_cce.c | 25912 -> 25792 (-120 bytes)
 drivers/char/drm/r128_cce.o | 133640 -> 133468 (-172 bytes)

 drivers/char/drm/r128_cce.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/r128_cce.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/r128_cce.c
@@ -353,12 +353,10 @@ static int r128_do_init_cce(struct drm_d

 	DRM_DEBUG("\n");

-	dev_priv = drm_alloc(sizeof(drm_r128_private_t), DRM_MEM_DRIVER);
-	if (dev_priv == NULL)
+	dev_priv = drm_zalloc(sizeof(drm_r128_private_t), DRM_MEM_DRIVER);
+	if (!dev_priv)
 		return DRM_ERR(ENOMEM);

-	memset(dev_priv, 0, sizeof(drm_r128_private_t));
-
 	dev_priv->is_pci = init->is_pci;

 	if (dev_priv->is_pci && !dev->sg) {
@@ -778,11 +776,10 @@ static int r128_freelist_init(struct drm
 	drm_r128_freelist_t *entry;
 	int i;

-	dev_priv->head = drm_alloc(sizeof(drm_r128_freelist_t), DRM_MEM_DRIVER);
-	if (dev_priv->head == NULL)
+	dev_priv->head = drm_zalloc(sizeof(drm_r128_freelist_t), DRM_MEM_DRIVER);
+	if (!dev_priv->head)
 		return DRM_ERR(ENOMEM);

-	memset(dev_priv->head, 0, sizeof(drm_r128_freelist_t));
 	dev_priv->head->age = R128_BUFFER_USED;

 	for (i = 0; i < dma->buf_count; i++) {

--
