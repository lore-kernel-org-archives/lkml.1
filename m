Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbZFSUbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbZFSUbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 16:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757848AbZFSUbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 16:31:18 -0400
Received: from khc.piap.pl ([195.187.100.11]:39088 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956AbZFSUbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 16:31:17 -0400
To: Dave Airlie <airlied@linux.ie>, Keith Packard <keithp@keithp.com>
Cc: <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Subject: Trivial fixes for drivers/gpu/drm/i915/
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 19 Jun 2009 22:31:17 +0200
Message-ID: <m34ouc55ka.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

size_t is (some sort of) int on x86-32 and long on x86-64, eliminate
compiler warnings by casting to long.

Signed-off-by:  Krzysztof Halasa <khc@pm.waw.pl>

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 39f5c65..d5044db 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1007,8 +1007,8 @@ i915_gem_set_domain_ioctl(struct drm_device *dev, void *data,
 
 	mutex_lock(&dev->struct_mutex);
 #if WATCH_BUF
-	DRM_INFO("set_domain_ioctl %p(%d), %08x %08x\n",
-		 obj, obj->size, read_domains, write_domain);
+	DRM_INFO("set_domain_ioctl %p(%ld), %08x %08x\n",
+		 obj, (long)obj->size, read_domains, write_domain);
 #endif
 	if (read_domains & I915_GEM_DOMAIN_GTT) {
 		ret = i915_gem_object_set_to_gtt_domain(obj, write_domain != 0);
@@ -1051,8 +1051,8 @@ i915_gem_sw_finish_ioctl(struct drm_device *dev, void *data,
 	}
 
 #if WATCH_BUF
-	DRM_INFO("%s: sw_finish %d (%p %d)\n",
-		 __func__, args->handle, obj, obj->size);
+	DRM_INFO("%s: sw_finish %d (%p %ld)\n",
+		 __func__, args->handle, obj, (long)obj->size);
 #endif
 	obj_priv = obj->driver_private;
 
@@ -2377,8 +2377,8 @@ i915_gem_object_bind_to_gtt(struct drm_gem_object *obj, unsigned alignment)
 	}
 
 #if WATCH_BUF
-	DRM_INFO("Binding object of size %d at 0x%08x\n",
-		 obj->size, obj_priv->gtt_offset);
+	DRM_INFO("Binding object of size %ld at 0x%08x\n",
+		 (long)obj->size, obj_priv->gtt_offset);
 #endif
 	ret = i915_gem_object_get_pages(obj);
 	if (ret) {
diff --git a/drivers/gpu/drm/i915/i915_gem_debug.c b/drivers/gpu/drm/i915/i915_gem_debug.c
index 8d0b943..88e9c3f 100644
--- a/drivers/gpu/drm/i915/i915_gem_debug.c
+++ b/drivers/gpu/drm/i915/i915_gem_debug.c
@@ -143,9 +143,9 @@ i915_gem_object_check_coherency(struct drm_gem_object *obj, int handle)
 	uint32_t *backing_map = NULL;
 	int bad_count = 0;
 
-	DRM_INFO("%s: checking coherency of object %p@0x%08x (%d, %dkb):\n",
+	DRM_INFO("%s: checking coherency of object %p@0x%08x (%d, %ldkb):\n",
 		 __func__, obj, obj_priv->gtt_offset, handle,
-		 obj->size / 1024);
+		 (long)(obj->size / 1024));
 
 	gtt_mapping = ioremap(dev->agp->base + obj_priv->gtt_offset,
 			      obj->size);

-- 
Krzysztof Halasa
