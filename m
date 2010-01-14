Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874Ab0ANWbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab0ANWbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273Ab0ANWbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:31:08 -0500
Received: from kroah.org ([198.145.64.141]:60689 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881Ab0ANW25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 44/52] drm/i915: remove render reclock support
Date: Thu, 14 Jan 2010 14:27:23 -0800
Message-Id: <1263508051-7868-44-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-43-git-send-email-gregkh@suse.de>
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
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
 <1263508051-7868-23-git-send-email-gregkh@suse.de>
 <1263508051-7868-24-git-send-email-gregkh@suse.de>
 <1263508051-7868-25-git-send-email-gregkh@suse.de>
 <1263508051-7868-26-git-send-email-gregkh@suse.de>
 <1263508051-7868-27-git-send-email-gregkh@suse.de>
 <1263508051-7868-28-git-send-email-gregkh@suse.de>
 <1263508051-7868-29-git-send-email-gregkh@suse.de>
 <1263508051-7868-30-git-send-email-gregkh@suse.de>
 <1263508051-7868-31-git-send-email-gregkh@suse.de>
 <1263508051-7868-32-git-send-email-gregkh@suse.de>
 <1263508051-7868-33-git-send-email-gregkh@suse.de>
 <1263508051-7868-34-git-send-email-gregkh@suse.de>
 <1263508051-7868-35-git-send-email-gregkh@suse.de>
 <1263508051-7868-36-git-send-email-gregkh@suse.de>
 <1263508051-7868-37-git-send-email-gregkh@suse.de>
 <1263508051-7868-38-git-send-email-gregkh@suse.de>
 <1263508051-7868-39-git-send-email-gregkh@suse.de>
 <1263508051-7868-40-git-send-email-gregkh@suse.de>
 <1263508051-7868-41-git-send-email-gregkh@suse.de>
 <1263508051-7868-42-git-send-email-gregkh@suse.de>
 <1263508051-7868-43-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit cda9d05c499093c67b4a376a15009923acc2127a upstream.

This code generally fails to adjust the render clock, and when it does,
it conflicts with some other register settings and can cause problems.

So remove this code altogether.  I'm reworking it now to do the right
thing, but the only bit it will share is the VBT check for whether
reclocking is supported, so I'm leaving that bit.

Reverts most of 652c393a3368af84359da37c45afc35a91144960 ("add dynamic
clock frequency control"), though for many the regressions showed up
in the later 181a5336d6cc836f05507410d66988c483ad0154 ("Fix render
reclock availability detection").

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/i915/intel_display.c |  127 ----------------------------------
 1 files changed, 0 insertions(+), 127 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 406b532..121b92e 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3737,125 +3737,6 @@ static void intel_gpu_idle_timer(unsigned long arg)
 	queue_work(dev_priv->wq, &dev_priv->idle_work);
 }
 
-void intel_increase_renderclock(struct drm_device *dev, bool schedule)
-{
-	drm_i915_private_t *dev_priv = dev->dev_private;
-
-	if (IS_IGDNG(dev))
-		return;
-
-	if (!dev_priv->render_reclock_avail) {
-		DRM_DEBUG("not reclocking render clock\n");
-		return;
-	}
-
-	/* Restore render clock frequency to original value */
-	if (IS_G4X(dev) || IS_I9XX(dev))
-		pci_write_config_word(dev->pdev, GCFGC, dev_priv->orig_clock);
-	else if (IS_I85X(dev))
-		pci_write_config_word(dev->pdev, HPLLCC, dev_priv->orig_clock);
-	DRM_DEBUG("increasing render clock frequency\n");
-
-	/* Schedule downclock */
-	if (schedule)
-		mod_timer(&dev_priv->idle_timer, jiffies +
-			  msecs_to_jiffies(GPU_IDLE_TIMEOUT));
-}
-
-void intel_decrease_renderclock(struct drm_device *dev)
-{
-	drm_i915_private_t *dev_priv = dev->dev_private;
-
-	if (IS_IGDNG(dev))
-		return;
-
-	if (!dev_priv->render_reclock_avail) {
-		DRM_DEBUG("not reclocking render clock\n");
-		return;
-	}
-
-	if (IS_G4X(dev)) {
-		u16 gcfgc;
-
-		/* Adjust render clock... */
-		pci_read_config_word(dev->pdev, GCFGC, &gcfgc);
-
-		/* Down to minimum... */
-		gcfgc &= ~GM45_GC_RENDER_CLOCK_MASK;
-		gcfgc |= GM45_GC_RENDER_CLOCK_266_MHZ;
-
-		pci_write_config_word(dev->pdev, GCFGC, gcfgc);
-	} else if (IS_I965G(dev)) {
-		u16 gcfgc;
-
-		/* Adjust render clock... */
-		pci_read_config_word(dev->pdev, GCFGC, &gcfgc);
-
-		/* Down to minimum... */
-		gcfgc &= ~I965_GC_RENDER_CLOCK_MASK;
-		gcfgc |= I965_GC_RENDER_CLOCK_267_MHZ;
-
-		pci_write_config_word(dev->pdev, GCFGC, gcfgc);
-	} else if (IS_I945G(dev) || IS_I945GM(dev)) {
-		u16 gcfgc;
-
-		/* Adjust render clock... */
-		pci_read_config_word(dev->pdev, GCFGC, &gcfgc);
-
-		/* Down to minimum... */
-		gcfgc &= ~I945_GC_RENDER_CLOCK_MASK;
-		gcfgc |= I945_GC_RENDER_CLOCK_166_MHZ;
-
-		pci_write_config_word(dev->pdev, GCFGC, gcfgc);
-	} else if (IS_I915G(dev)) {
-		u16 gcfgc;
-
-		/* Adjust render clock... */
-		pci_read_config_word(dev->pdev, GCFGC, &gcfgc);
-
-		/* Down to minimum... */
-		gcfgc &= ~I915_GC_RENDER_CLOCK_MASK;
-		gcfgc |= I915_GC_RENDER_CLOCK_166_MHZ;
-
-		pci_write_config_word(dev->pdev, GCFGC, gcfgc);
-	} else if (IS_I85X(dev)) {
-		u16 hpllcc;
-
-		/* Adjust render clock... */
-		pci_read_config_word(dev->pdev, HPLLCC, &hpllcc);
-
-		/* Up to maximum... */
-		hpllcc &= ~GC_CLOCK_CONTROL_MASK;
-		hpllcc |= GC_CLOCK_133_200;
-
-		pci_write_config_word(dev->pdev, HPLLCC, hpllcc);
-	}
-	DRM_DEBUG("decreasing render clock frequency\n");
-}
-
-/* Note that no increase function is needed for this - increase_renderclock()
- *  will also rewrite these bits
- */
-void intel_decrease_displayclock(struct drm_device *dev)
-{
-	if (IS_IGDNG(dev))
-		return;
-
-	if (IS_I945G(dev) || IS_I945GM(dev) || IS_I915G(dev) ||
-	    IS_I915GM(dev)) {
-		u16 gcfgc;
-
-		/* Adjust render clock... */
-		pci_read_config_word(dev->pdev, GCFGC, &gcfgc);
-
-		/* Down to minimum... */
-		gcfgc &= ~0xf0;
-		gcfgc |= 0x80;
-
-		pci_write_config_word(dev->pdev, GCFGC, gcfgc);
-	}
-}
-
 #define CRTC_IDLE_TIMEOUT 1000 /* ms */
 
 static void intel_crtc_idle_timer(unsigned long arg)
@@ -3969,12 +3850,6 @@ static void intel_idle_update(struct work_struct *work)
 
 	mutex_lock(&dev->struct_mutex);
 
-	/* GPU isn't processing, downclock it. */
-	if (!dev_priv->busy) {
-		intel_decrease_renderclock(dev);
-		intel_decrease_displayclock(dev);
-	}
-
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
 		/* Skip inactive CRTCs */
 		if (!crtc->fb)
@@ -4009,7 +3884,6 @@ void intel_mark_busy(struct drm_device *dev, struct drm_gem_object *obj)
 		return;
 
 	dev_priv->busy = true;
-	intel_increase_renderclock(dev, true);
 
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
 		if (!crtc->fb)
@@ -4514,7 +4388,6 @@ void intel_modeset_cleanup(struct drm_device *dev)
 		del_timer_sync(&intel_crtc->idle_timer);
 	}
 
-	intel_increase_renderclock(dev, false);
 	del_timer_sync(&dev_priv->idle_timer);
 
 	mutex_unlock(&dev->struct_mutex);
-- 
1.6.6

