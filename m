Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbZFSUfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbZFSUfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 16:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZFSUfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 16:35:10 -0400
Received: from khc.piap.pl ([195.187.100.11]:57327 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbZFSUfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 16:35:09 -0400
To: Dave Airlie <airlied@linux.ie>, Keith Packard <keithp@keithp.com>
Cc: <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Subject: Trivial fixes #2 for drivers/gpu/drm/i915/: debug code
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 19 Jun 2009 22:35:09 +0200
Message-ID: <m33a9w55du.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

obj_priv->page_list has been recently renamed to obj_priv->pages.
Fix the normally disabled debug code, too.

Signed-off-by:  Krzysztof Halasa <khc@pm.waw.pl>

diff --git a/drivers/gpu/drm/i915/i915_gem_debug.c b/drivers/gpu/drm/i915/i915_gem_debug.c
index 8d0b943..88e9c3f 100644
--- a/drivers/gpu/drm/i915/i915_gem_debug.c
+++ b/drivers/gpu/drm/i915/i915_gem_debug.c
@@ -87,7 +87,7 @@ i915_gem_dump_object(struct drm_gem_object *obj, int len,
 			chunk_len = page_len - chunk;
 			if (chunk_len > 128)
 				chunk_len = 128;
-			i915_gem_dump_page(obj_priv->page_list[page],
+			i915_gem_dump_page(obj_priv->pages[page],
 					   chunk, chunk + chunk_len,
 					   obj_priv->gtt_offset +
 					   page * PAGE_SIZE,
@@ -157,7 +157,7 @@ i915_gem_object_check_coherency(struct drm_gem_object *obj, int handle)
 	for (page = 0; page < obj->size / PAGE_SIZE; page++) {
 		int i;
 
-		backing_map = kmap_atomic(obj_priv->page_list[page], KM_USER0);
+		backing_map = kmap_atomic(obj_priv->pages[page], KM_USER0);
 
 		if (backing_map == NULL) {
 			DRM_ERROR("failed to map backing page\n");

-- 
Krzysztof Halasa
