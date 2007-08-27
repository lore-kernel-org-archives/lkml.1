Return-Path: <linux-kernel-owner+w=401wt.eu-S1761280AbXH0VQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761280AbXH0VQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbXH0VNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:13:49 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1141 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbXH0VNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:13:48 -0400
Message-Id: <20070827211345.510955000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:57:55 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 05/23] drm_dma.c: drm_alloc + memset to drm_zalloc
Content-Disposition: inline; filename=drm_dma.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does the conversion of drm_alloc + memset to drm_zalloc.
The memset in loop is also superfluous and can be removed.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/drm_dma.c | 4624 -> 4475 (-149 bytes)
 drivers/char/drm/drm_dma.o | 104277 -> 103917 (-360 bytes)

 drivers/char/drm/drm_dma.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/drm_dma.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/drm_dma.c
@@ -45,17 +45,10 @@
  */
 int drm_dma_setup(struct drm_device *dev)
 {
-	int i;
-
-	dev->dma = drm_alloc(sizeof(*dev->dma), DRM_MEM_DRIVER);
+	dev->dma = drm_zalloc(sizeof(*dev->dma), DRM_MEM_DRIVER);
 	if (!dev->dma)
 		return -ENOMEM;

-	memset(dev->dma, 0, sizeof(*dev->dma));
-
-	for (i = 0; i <= DRM_MAX_ORDER; i++)
-		memset(&dev->dma->bufs[i], 0, sizeof(dev->dma->bufs[0]));
-
 	return 0;
 }

--
