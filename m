Return-Path: <linux-kernel-owner+w=401wt.eu-S1763703AbXH0VRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763703AbXH0VRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbXH0VNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:13:53 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1153 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbXH0VNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:13:52 -0400
Message-Id: <20070827211349.235189000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:57:59 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 09/23] drm_scatter.c: drm_alloc + memset to drm_alloc
Content-Disposition: inline; filename=drm_scatter.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/drm_scatter.c | 6113 -> 5945 (-168 bytes)
 drivers/char/drm/drm_scatter.o | 105552 -> 105584 (+32 bytes)

 drivers/char/drm/drm_scatter.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/drm_scatter.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/drm_scatter.c
@@ -83,26 +83,22 @@ int drm_sg_alloc(struct inode *inode, st
 	if (copy_from_user(&request, argp, sizeof(request)))
 		return -EFAULT;

-	entry = drm_alloc(sizeof(*entry), DRM_MEM_SGLISTS);
+	entry = drm_zalloc(sizeof(*entry), DRM_MEM_SGLISTS);
 	if (!entry)
 		return -ENOMEM;

-	memset(entry, 0, sizeof(*entry));
-
 	pages = (request.size + PAGE_SIZE - 1) / PAGE_SIZE;
 	DRM_DEBUG("sg size=%ld pages=%ld\n", request.size, pages);

 	entry->pages = pages;
-	entry->pagelist = drm_alloc(pages * sizeof(*entry->pagelist),
+	entry->pagelist = drm_calloc(pages, sizeof(*entry->pagelist),
 				    DRM_MEM_PAGES);
 	if (!entry->pagelist) {
 		drm_free(entry, sizeof(*entry), DRM_MEM_SGLISTS);
 		return -ENOMEM;
 	}

-	memset(entry->pagelist, 0, pages * sizeof(*entry->pagelist));
-
-	entry->busaddr = drm_alloc(pages * sizeof(*entry->busaddr),
+	entry->busaddr = drm_calloc(pages, sizeof(*entry->busaddr),
 				   DRM_MEM_PAGES);
 	if (!entry->busaddr) {
 		drm_free(entry->pagelist,
@@ -111,7 +107,6 @@ int drm_sg_alloc(struct inode *inode, st
 		drm_free(entry, sizeof(*entry), DRM_MEM_SGLISTS);
 		return -ENOMEM;
 	}
-	memset((void *)entry->busaddr, 0, pages * sizeof(*entry->busaddr));

 	entry->virtual = vmalloc_32(pages << PAGE_SHIFT);
 	if (!entry->virtual) {

--
