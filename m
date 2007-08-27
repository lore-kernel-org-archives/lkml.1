Return-Path: <linux-kernel-owner+w=401wt.eu-S1764218AbXH0VVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764218AbXH0VVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758388AbXH0VOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:14:06 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1170 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231AbXH0VOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:14:05 -0400
Message-Id: <20070827211355.909371000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:58:06 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 16/23] i915_mem.c: drm_alloc + memset to drm_zalloc
Content-Disposition: inline; filename=i915_mem.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/i915_mem.c | 9842 -> 9808 (-34 bytes)
 drivers/char/drm/i915_mem.o | 114556 -> 114464 (-92 bytes)

 drivers/char/drm/i915_mem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/i915_mem.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/i915_mem.c
@@ -189,7 +189,7 @@ static int init_heap(struct mem_block **
 	if (!blocks)
 		return -ENOMEM;

-	*heap = drm_alloc(sizeof(**heap), DRM_MEM_BUFLISTS);
+	*heap = drm_zalloc(sizeof(**heap), DRM_MEM_BUFLISTS);
 	if (!*heap) {
 		drm_free(blocks, sizeof(*blocks), DRM_MEM_BUFLISTS);
 		return -ENOMEM;
@@ -200,7 +200,6 @@ static int init_heap(struct mem_block **
 	blocks->filp = NULL;
 	blocks->next = blocks->prev = *heap;

-	memset(*heap, 0, sizeof(**heap));
 	(*heap)->filp = (DRMFILE) - 1;
 	(*heap)->next = (*heap)->prev = blocks;
 	return 0;

--
