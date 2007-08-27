Return-Path: <linux-kernel-owner+w=401wt.eu-S1751844AbXH0VRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbXH0VRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbXH0VNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:13:52 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1151 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbXH0VNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:13:51 -0400
Message-Id: <20070827211348.428083000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:57:58 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 08/23] drm_irq.c: drm_alloc + memset to drm_zalloc
Content-Disposition: inline; filename=drm_irq.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/drm_irq.c | 13062 -> 13003 (-59 bytes)
 drivers/char/drm/drm_irq.o | 114446 -> 114298 (-148 bytes)

 drivers/char/drm/drm_irq.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/drm_irq.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/drm_irq.c
@@ -322,13 +322,9 @@ int drm_wait_vblank(DRM_IOCTL_ARGS)

 		spin_unlock_irqrestore(&dev->vbl_lock, irqflags);

-		if (!
-		    (vbl_sig =
-		     drm_alloc(sizeof(struct drm_vbl_sig), DRM_MEM_DRIVER))) {
+		vbl_sig = drm_zalloc(sizeof(struct drm_vbl_sig), DRM_MEM_DRIVER);
+		if (!vbl_sig)
 			return -ENOMEM;
-		}
-
-		memset((void *)vbl_sig, 0, sizeof(*vbl_sig));

 		vbl_sig->sequence = vblwait.request.sequence;
 		vbl_sig->info.si_signo = vblwait.request.signal;

--
