Return-Path: <linux-kernel-owner+w=401wt.eu-S1761272AbZFSWic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761272AbZFSWic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759509AbZFSWct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:32:49 -0400
Received: from khc.piap.pl ([195.187.100.11]:46508 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758792AbZFSWb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:31:28 -0400
To: Dave Airlie <airlied@linux.ie>
Cc: Keith Packard <keithp@keithp.com>, <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: Trivial fixes for drivers/gpu/drm/i915/ (#1 V2)
References: <m34ouc55ka.fsf@intrepid.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 20 Jun 2009 00:31:28 +0200
In-Reply-To: <m34ouc55ka.fsf@intrepid.localdomain> (Krzysztof Halasa's message of "Fri\, 19 Jun 2009 22\:31\:17 +0200")
Message-ID: <m3prcz4zzz.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

size_t is (some sort of) int on x86-32 and long on x86-64, correct
format specifiers.

Signed-off-by:  Krzysztof Halasa <khc@pm.waw.pl>

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 39f5c65..cdaa8b6 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1007,7 +1007,7 @@ i915_gem_set_domain_ioctl(struct drm_device *dev, void *data,
 
 	mutex_lock(&dev->struct_mutex);
 #if WATCH_BUF
-	DRM_INFO("set_domain_ioctl %p(%d), %08x %08x\n",
+	DRM_INFO("set_domain_ioctl %p(%zd), %08x %08x\n",
 		 obj, obj->size, read_domains, write_domain);
 #endif
 	if (read_domains & I915_GEM_DOMAIN_GTT) {
@@ -1051,7 +1051,7 @@ i915_gem_sw_finish_ioctl(struct drm_device *dev, void *data,
 	}
 
 #if WATCH_BUF
-	DRM_INFO("%s: sw_finish %d (%p %d)\n",
+	DRM_INFO("%s: sw_finish %d (%p %zd)\n",
 		 __func__, args->handle, obj, obj->size);
 #endif
 	obj_priv = obj->driver_private;
@@ -2377,7 +2377,7 @@ i915_gem_object_bind_to_gtt(struct drm_gem_object *obj, unsigned alignment)
 	}
 
 #if WATCH_BUF
-	DRM_INFO("Binding object of size %d at 0x%08x\n",
+	DRM_INFO("Binding object of size %zd at 0x%08x\n",
 		 obj->size, obj_priv->gtt_offset);
 #endif
 	ret = i915_gem_object_get_pages(obj);
diff --git a/drivers/gpu/drm/i915/i915_gem_debug.c b/drivers/gpu/drm/i915/i915_gem_debug.c
index 8d0b943..e602614 100644
--- a/drivers/gpu/drm/i915/i915_gem_debug.c
+++ b/drivers/gpu/drm/i915/i915_gem_debug.c
@@ -143,7 +143,7 @@ i915_gem_object_check_coherency(struct drm_gem_object *obj, int handle)
 	uint32_t *backing_map = NULL;
 	int bad_count = 0;
 
-	DRM_INFO("%s: checking coherency of object %p@0x%08x (%d, %dkb):\n",
+	DRM_INFO("%s: checking coherency of object %p@0x%08x (%d, %zdkb):\n",
 		 __func__, obj, obj_priv->gtt_offset, handle,
 		 obj->size / 1024);
 

-- 
Krzysztof Halasa
