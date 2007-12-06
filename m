Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbXLFJiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbXLFJiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 04:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbXLFJiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 04:38:13 -0500
Received: from [222.73.24.84] ([222.73.24.84]:61184 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbXLFJiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 04:38:12 -0500
Message-ID: <4757C257.6060003@cn.fujitsu.com>
Date: Thu, 06 Dec 2007 17:35:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: airlied@linux.ie
CC: dri-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] DRM: don't cast a pointer to pointer of list_head
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The casting is safe only when the list_head member is the
first member of the structure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 drivers/char/drm/i915_irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/drm/i915_irq.c b/drivers/char/drm/i915_irq.c
index a443f4a..e9e8522 100644
--- a/drivers/char/drm/i915_irq.c
+++ b/drivers/char/drm/i915_irq.c
@@ -555,7 +555,7 @@ int i915_vblank_swap(struct drm_device *dev, void *data,
 
 	spin_lock_irqsave(&dev_priv->swaps_lock, irqflags);
 
-	list_add_tail((struct list_head *)vbl_swap, &dev_priv->vbl_swaps.head);
+	list_add_tail(&vbl_swap->head, &dev_priv->vbl_swaps.head);
 	dev_priv->swaps_pending++;
 
 	spin_unlock_irqrestore(&dev_priv->swaps_lock, irqflags);
-- 
1.5.3.rc7

