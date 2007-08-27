Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbXH0VOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbXH0VOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXH0VNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:13:46 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1136 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbXH0VNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:13:45 -0400
Message-Id: <20070827211343.113957000@tuxland.pl>
References: <20070827205750.514001000@tuxland.pl>
User-Agent: quilt/0.45-1
Date: Mon, 27 Aug 2007 22:57:52 +0200
From: m.kozlowski@tuxland.pl
To: airlied@linux.ie, akpm@linux-foundation.org
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 02/23] drm_agpsupport.c: drm_alloc + memset to drm_zalloc
Content-Disposition: inline; filename=drm_agpsupport.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/char/drm/drm_agpsupport.c | 13896 -> 13828 (-68 bytes)
 drivers/char/drm/drm_agpsupport.o | 120046 -> 119814 (-232 bytes)

 drivers/char/drm/drm_agpsupport.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- linux-2.6.23-rc3-mm1.orig/drivers/char/drm/drm_agpsupport.c
+++ linux-2.6.23-rc3-mm1/drivers/char/drm/drm_agpsupport.c
@@ -216,10 +216,10 @@ int drm_agp_alloc(struct drm_device *dev

 	if (!dev->agp || !dev->agp->acquired)
 		return -EINVAL;
-	if (!(entry = drm_alloc(sizeof(*entry), DRM_MEM_AGPLISTS)))
-		return -ENOMEM;

-	memset(entry, 0, sizeof(*entry));
+	entry = drm_zalloc(sizeof(*entry), DRM_MEM_AGPLISTS);
+	if (!entry)
+		return -ENOMEM;

 	pages = (request->size + PAGE_SIZE - 1) / PAGE_SIZE;
 	type = (u32) request->type;
@@ -444,11 +444,12 @@ int drm_agp_free_ioctl(struct inode *ino
  */
 struct drm_agp_head *drm_agp_init(struct drm_device *dev)
 {
-	struct drm_agp_head *head = NULL;
+	struct drm_agp_head *head;

-	if (!(head = drm_alloc(sizeof(*head), DRM_MEM_AGPLISTS)))
+	head = drm_zalloc(sizeof(*head), DRM_MEM_AGPLISTS);
+	if (!head)
 		return NULL;
-	memset((void *)head, 0, sizeof(*head));
+
 	head->bridge = agp_find_bridge(dev->pdev);
 	if (!head->bridge) {
 		if (!(head->bridge = agp_backend_acquire(dev->pdev))) {

--
