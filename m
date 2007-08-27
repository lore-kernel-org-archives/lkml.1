Return-Path: <linux-kernel-owner+w=401wt.eu-S1764069AbXH0VTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764069AbXH0VTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757418AbXH0VOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:14:00 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1168 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756692AbXH0VN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:13:59 -0400
Message-Id: <20070827211353.294728000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:58:03 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 13/23] i830_dma.c: drm_alloc + memset to drm_zalloc
Content-Disposition: inline; filename=i830_dma.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/i830_dma.c | 41269 -> 41212 (-57 bytes)
 drivers/char/drm/i830_dma.o | 157920 -> 157480 (-440 bytes)

 drivers/char/drm/i830_dma.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/i830_dma.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/i830_dma.c
@@ -336,8 +336,6 @@ static int i830_dma_initialize(struct dr
 {
 	struct drm_map_list *r_list;

-	memset(dev_priv, 0, sizeof(drm_i830_private_t));
-
 	list_for_each_entry(r_list, &dev->maplist, head) {
 		if (r_list->map &&
 		    r_list->map->type == _DRM_SHM &&
@@ -465,9 +463,9 @@ static int i830_dma_init(struct inode *i

 	switch (init.func) {
 	case I830_INIT_DMA:
-		dev_priv = drm_alloc(sizeof(drm_i830_private_t),
+		dev_priv = drm_zalloc(sizeof(drm_i830_private_t),
 				     DRM_MEM_DRIVER);
-		if (dev_priv == NULL)
+		if (!dev_priv)
 			return -ENOMEM;
 		retcode = i830_dma_initialize(dev, dev_priv, &init);
 		break;

--
