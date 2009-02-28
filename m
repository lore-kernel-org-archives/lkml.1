Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZB1UB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZB1UB3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 15:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZB1UBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 15:01:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48580 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbZB1UBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 15:01:20 -0500
Date: Sat, 28 Feb 2009 15:01:16 -0500
From: Kyle McMartin <kyle@infradead.org>
To: airlied@redhat.com
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Subject: [PATCH, trivial] i915: add newline to i915_gem_object_pin failure
	msg
Message-ID: <20090228200116.GD28503@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Prevents formatting nasty as below:

[drm:i915_gem_object_pin] *ERROR* Failure to bind: -12<3>[drm:i915_gem_evict_something] *ERROR* inactive empty 1 request empty 1 flushing empty 1

Signed-off-by: Kyle McMartin <kyle@redhat.com>

---
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 85685bf..d51ae5d 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2712,7 +2712,7 @@ i915_gem_object_pin(struct drm_gem_object *obj, uint32_t alignment)
 		ret = i915_gem_object_bind_to_gtt(obj, alignment);
 		if (ret != 0) {
 			if (ret != -EBUSY && ret != -ERESTARTSYS)
-				DRM_ERROR("Failure to bind: %d", ret);
+				DRM_ERROR("Failure to bind: %d\n", ret);
 			return ret;
 		}
 		/*
