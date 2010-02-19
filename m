Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab0BSRQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:16:48 -0500
Received: from kroah.org ([198.145.64.141]:57403 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab0BSRAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:18 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:35 2010
Message-Id: <20100219163235.535839906@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>
Subject: [20/93] drm/i915: Increase fb alignment to 64k
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit fd2e8ea597222b8f38ae8948776a61ea7958232e upstream.

An untiled framebuffer must be aligned to 64k. This is normally handled
by intel_pin_and_fence_fb_obj(), but the intelfb_create() likes to be
different and do the pinning itself. However, it aligns the buffer
object incorrectly for pre-i965 chipsets causing a PGTBL_ERR when it is
installed onto the output.

Fixes:
  KMS error message while initializing modesetting -
  render error detected: EIR: 0x10 [i915]
  http://bugs.freedesktop.org/show_bug.cgi?id=22936

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -148,7 +148,7 @@ static int intelfb_create(struct drm_dev
 
 	mutex_lock(&dev->struct_mutex);
 
-	ret = i915_gem_object_pin(fbo, PAGE_SIZE);
+	ret = i915_gem_object_pin(fbo, 64*1024);
 	if (ret) {
 		DRM_ERROR("failed to pin fb: %d\n", ret);
 		goto out_unref;


