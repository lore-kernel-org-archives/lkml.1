Return-Path: <linux-kernel-owner+w=401wt.eu-S1763974AbXH0VUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763974AbXH0VUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757617AbXH0VOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:14:01 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1170 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757231AbXH0VOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:14:00 -0400
Message-Id: <20070827211354.342059000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:58:04 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 14/23] i915_dma.c: drm_alloc + memset to drm_zalloc
Content-Disposition: inline; filename=i915_dma.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/i915_dma.c | 22680 -> 22623 (-57 bytes)
 drivers/char/drm/i915_dma.o | 134192 -> 133704 (-488 bytes)

 drivers/char/drm/i915_dma.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/i915_dma.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/i915_dma.c
@@ -130,8 +130,6 @@ static int i915_initialize(struct drm_de
 			   drm_i915_private_t * dev_priv,
 			   drm_i915_init_t * init)
 {
-	memset(dev_priv, 0, sizeof(drm_i915_private_t));
-
 	dev_priv->sarea = drm_getsarea(dev);
 	if (!dev_priv->sarea) {
 		DRM_ERROR("can not find sarea!\n");
@@ -263,9 +261,9 @@ static int i915_dma_init(DRM_IOCTL_ARGS)

 	switch (init.func) {
 	case I915_INIT_DMA:
-		dev_priv = drm_alloc(sizeof(drm_i915_private_t),
+		dev_priv = drm_zalloc(sizeof(drm_i915_private_t),
 				     DRM_MEM_DRIVER);
-		if (dev_priv == NULL)
+		if (!dev_priv)
 			return DRM_ERR(ENOMEM);
 		retcode = i915_initialize(dev, dev_priv, &init);
 		break;

--
