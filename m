Return-Path: <linux-kernel-owner+w=401wt.eu-S936515AbZLQE1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936515AbZLQE1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935654AbZLQEEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:54 -0500
Received: from kroah.org ([198.145.64.141]:55695 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935630AbZLQEEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:44 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:53 2009
Message-Id: <20091217035653.504981807@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>
Subject: [082/151] drm/i915: Set the error code after failing to insert new offset into mm ht.
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 5618ca6abc2d6f475b258badc017a5254cf43d1b upstream.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1288,6 +1288,7 @@ i915_gem_create_mmap_offset(struct drm_g
 	list->hash.key = list->file_offset_node->start;
 	if (drm_ht_insert_item(&mm->offset_hash, &list->hash)) {
 		DRM_ERROR("failed to add to map hash\n");
+		ret = -ENOMEM;
 		goto out_free_mm;
 	}
 


