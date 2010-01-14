Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555Ab0ANWgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0ANWgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761Ab0ANW2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:28:35 -0500
Received: from kroah.org ([198.145.64.141]:60559 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab0ANW2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:33 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Dave Airlie <airlied@linux.ie>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/52] drm/i915: fix unused var
Date: Thu, 14 Jan 2010 14:26:58 -0800
Message-Id: <1263508051-7868-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-18-git-send-email-gregkh@suse.de>
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
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

commit 29bd0ae25f8cb96b63560c2cbccec77b425e1603 upstream.

drivers/gpu/drm/i915/i915_dma.c: In function 'i915_driver_load':
drivers/gpu/drm/i915/i915_dma.c:1114: warning: 'll_base' may be used uninitialized in this function

Partly this is because gcc isn't smart enough.  But `ll_base' does get used
uninitialised in the DRM_DEBUG() call.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Eric Anholt <eric@anholt.net>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/i915/i915_dma.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 4a553ad..bc2db7d 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1111,7 +1111,8 @@ static void i915_setup_compression(struct drm_device *dev, int size)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_mm_node *compressed_fb, *compressed_llb;
-	unsigned long cfb_base, ll_base;
+	unsigned long cfb_base;
+	unsigned long ll_base = 0;
 
 	/* Leave 1M for line length buffer & misc. */
 	compressed_fb = drm_mm_search_free(&dev_priv->vram, size, 4096, 0);
-- 
1.6.6

