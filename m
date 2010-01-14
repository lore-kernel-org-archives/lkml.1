Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832Ab0ANWhC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab0ANWhC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:37:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598Ab0ANW2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:28:34 -0500
Received: from kroah.org ([198.145.64.141]:60540 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab0ANW22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:28 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/52] drm/i915: Permit pinning whilst the device is 'suspended'
Date: Thu, 14 Jan 2010 14:26:53 -0800
Message-Id: <1263508051-7868-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-13-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit e3d8affb0d2d95f2da61e30ce86b33177feb91e8 upstream.

As pinning (allocating and binding GTT memory) does not actually invoke
GPU commands, it is safe, and indeed is attempted, during resumption
from suspension:

  [drm:intel_init_clock_gating] *ERROR* failed to pin power context: -16

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/i915/i915_gem.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 2e10b9a..3d75c67 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2571,9 +2571,6 @@ i915_gem_object_bind_to_gtt(struct drm_gem_object *obj, unsigned alignment)
 	bool retry_alloc = false;
 	int ret;
 
-	if (dev_priv->mm.suspended)
-		return -EBUSY;
-
 	if (obj_priv->madv != I915_MADV_WILLNEED) {
 		DRM_ERROR("Attempting to bind a purgeable object\n");
 		return -EINVAL;
-- 
1.6.6

