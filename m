Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab0BDRee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:34:34 -0500
Received: from kroah.org ([198.145.64.141]:34654 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933082Ab0BDRVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:43 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:00 2010
Message-Id: <20100204171459.918511620@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [20/74] drm/i915: Reload hangcheck timer too for Ironlake
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit c566ec49159b806db95a90fd8f37448376cd0ad2 upstream.

Make sure hangcheck timer won't beat us unexpectedly on Ironlake.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_irq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -282,6 +282,8 @@ irqreturn_t igdng_irq_handler(struct drm
 		dev_priv->mm.irq_gem_seqno = seqno;
 		trace_i915_gem_request_complete(dev, seqno);
 		DRM_WAKEUP(&dev_priv->irq_queue);
+		dev_priv->hangcheck_count = 0;
+		mod_timer(&dev_priv->hangcheck_timer, jiffies + DRM_I915_HANGCHECK_PERIOD);
 	}
 
 	I915_WRITE(GTIIR, gt_iir);


