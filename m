Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbZJBBwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbZJBBwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZJBBwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:52:10 -0400
Received: from kroah.org ([198.145.64.141]:33164 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007AbZJBBdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:16 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:15 2009
Message-Id: <20091002012415.188369380@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chris Wilson <chris@chris-wilson.co.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [058/136] drm/i915: Add buffer to inactive list immediately during fault
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-add-buffer-to-inactive-list-immediately-during-fault.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Chris Wilson <chris@chris-wilson.co.uk>

commit 4960aaca14010b9ff92e5726dd178cbd6805d412 upstream.

If we failed to set the domain, the buffer was no longer being tracked
on any list.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1155,14 +1155,13 @@ int i915_gem_fault(struct vm_area_struct
 			mutex_unlock(&dev->struct_mutex);
 			return VM_FAULT_SIGBUS;
 		}
+		list_add_tail(&obj_priv->list, &dev_priv->mm.inactive_list);
 
 		ret = i915_gem_object_set_to_gtt_domain(obj, write);
 		if (ret) {
 			mutex_unlock(&dev->struct_mutex);
 			return VM_FAULT_SIGBUS;
 		}
-
-		list_add_tail(&obj_priv->list, &dev_priv->mm.inactive_list);
 	}
 
 	/* Need a new fence register? */


