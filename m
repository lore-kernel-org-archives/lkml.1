Return-Path: <linux-kernel-owner+w=401wt.eu-S1763698AbXH0VVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763698AbXH0VVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757191AbXH0VOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:14:04 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1170 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758024AbXH0VOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:14:02 -0400
Message-Id: <20070827211355.073460000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:58:05 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 15/23] i915_irq.c: drm_calloc to drm_zalloc and bugfix
Content-Disposition: inline; filename=i915_irq.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does drm_calloc to drm_zalloc conversion. Also it
seems that unpatched version allocated wrong nr of bytes.

drm_i915_vbl_swap_t *vbl_swap;

...

sizeof(vbl_swap) vs. sizeof(*vbl_swap)

No?

Please review.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/i915_irq.c | 15749 -> 15746 (-3 bytes)
 drivers/char/drm/i915_irq.o | 128940 -> 128856 (-84 bytes)

 drivers/char/drm/i915_irq.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/i915_irq.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/i915_irq.c
@@ -541,8 +541,7 @@ int i915_vblank_swap(DRM_IOCTL_ARGS)
 		return DRM_ERR(EBUSY);
 	}

-	vbl_swap = drm_calloc(1, sizeof(vbl_swap), DRM_MEM_DRIVER);
-
+	vbl_swap = drm_zalloc(sizeof(*vbl_swap), DRM_MEM_DRIVER);
 	if (!vbl_swap) {
 		DRM_ERROR("Failed to allocate memory to queue swap\n");
 		return DRM_ERR(ENOMEM);

--
