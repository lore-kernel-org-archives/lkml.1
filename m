Return-Path: <linux-kernel-owner+w=401wt.eu-S1763495AbXH0VTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763495AbXH0VTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbXH0VN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:13:58 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1166 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbXH0VN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:13:57 -0400
Message-Id: <20070827211352.555505000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:58:02 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 12/23] i810_dma.c: drm_alloc + memset to drm_zalloc
Content-Disposition: inline; filename=i810_dma.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/i810_dma.c | 37542 -> 37480 (-62 bytes)
 drivers/char/drm/i810_dma.o | 150664 -> 149996 (-668 bytes)

 drivers/char/drm/i810_dma.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/i810_dma.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/i810_dma.c
@@ -328,7 +328,6 @@ static int i810_dma_initialize(struct dr
 			       drm_i810_init_t * init)
 {
 	struct drm_map_list *r_list;
-	memset(dev_priv, 0, sizeof(drm_i810_private_t));

 	list_for_each_entry(r_list, &dev->maplist, head) {
 		if (r_list->map &&
@@ -498,9 +497,9 @@ static int i810_dma_init(struct inode *i
 		if (retcode)
 			return retcode;

-		dev_priv = drm_alloc(sizeof(drm_i810_private_t),
+		dev_priv = drm_zalloc(sizeof(drm_i810_private_t),
 				     DRM_MEM_DRIVER);
-		if (dev_priv == NULL)
+		if (!dev_priv)
 			return -ENOMEM;
 		retcode = i810_dma_initialize(dev, dev_priv, &init);
 		break;
@@ -512,9 +511,9 @@ static int i810_dma_init(struct inode *i
 				   sizeof(drm_i810_init_t))) {
 			return -EFAULT;
 		}
-		dev_priv = drm_alloc(sizeof(drm_i810_private_t),
+		dev_priv = drm_zalloc(sizeof(drm_i810_private_t),
 				     DRM_MEM_DRIVER);
-		if (dev_priv == NULL)
+		if (!dev_priv)
 			return -ENOMEM;
 		retcode = i810_dma_initialize(dev, dev_priv, &init);
 		break;

--
