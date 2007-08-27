Return-Path: <linux-kernel-owner+w=401wt.eu-S1764391AbXH0VXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764391AbXH0VXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760135AbXH0VON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:14:13 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1170 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759078AbXH0VOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:14:10 -0400
Message-Id: <20070827211359.436226000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:58:10 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 20/23] radeon_mem.c: drm_alloc + memset to drm_zalloc
Content-Disposition: inline; filename=radeon_mem.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/radeon_mem.c | 7711 -> 7677 (-34 bytes)
 drivers/char/drm/radeon_mem.o | 115484 -> 115396 (-88 bytes)

 drivers/char/drm/radeon_mem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/radeon_mem.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/radeon_mem.c
@@ -139,7 +139,7 @@ static int init_heap(struct mem_block **
 	if (!blocks)
 		return DRM_ERR(ENOMEM);

-	*heap = drm_alloc(sizeof(**heap), DRM_MEM_BUFS);
+	*heap = drm_zalloc(sizeof(**heap), DRM_MEM_BUFS);
 	if (!*heap) {
 		drm_free(blocks, sizeof(*blocks), DRM_MEM_BUFS);
 		return DRM_ERR(ENOMEM);
@@ -150,7 +150,6 @@ static int init_heap(struct mem_block **
 	blocks->filp = NULL;
 	blocks->next = blocks->prev = *heap;

-	memset(*heap, 0, sizeof(**heap));
 	(*heap)->filp = (DRMFILE) - 1;
 	(*heap)->next = (*heap)->prev = blocks;
 	return 0;

--
