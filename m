Return-Path: <linux-kernel-owner+w=401wt.eu-S934818AbZLQBYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934818AbZLQBYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763739AbZLQBVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:21:15 -0500
Received: from kroah.org ([198.145.64.141]:41487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763682AbZLQBVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:21:01 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:08 2009
Message-Id: <20091217011608.305374103@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Stefan Bader <stefan.bader@canonical.com>
Subject: [79/90] drm/i915: save/restore BLC histogram control reg across suspend/resume
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 0eb96d6ed38430b72897adde58f5477a6b71757a upstream.

Turns out some machines, like the ThinkPad X40 don't come back if you
don't save/restore this register.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Cc: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_drv.h     |    1 +
 drivers/gpu/drm/i915/i915_reg.h     |    2 ++
 drivers/gpu/drm/i915/i915_suspend.c |    2 ++
 3 files changed, 5 insertions(+)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -264,6 +264,7 @@ typedef struct drm_i915_private {
 	u32 saveDSPASURF;
 	u32 saveDSPATILEOFF;
 	u32 savePFIT_PGM_RATIOS;
+	u32 saveBLC_HIST_CTL;
 	u32 saveBLC_PWM_CTL;
 	u32 saveBLC_PWM_CTL2;
 	u32 saveFPB0;
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -915,6 +915,8 @@
 #define   BACKLIGHT_DUTY_CYCLE_SHIFT		(0)
 #define   BACKLIGHT_DUTY_CYCLE_MASK		(0xffff)
 
+#define BLC_HIST_CTL		0x61260
+
 /* TV port control */
 #define TV_CTL			0x68000
 /** Enables the TV encoder */
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -416,6 +416,7 @@ int i915_save_state(struct drm_device *d
 	dev_priv->savePP_CONTROL = I915_READ(PP_CONTROL);
 	dev_priv->savePFIT_PGM_RATIOS = I915_READ(PFIT_PGM_RATIOS);
 	dev_priv->saveBLC_PWM_CTL = I915_READ(BLC_PWM_CTL);
+	dev_priv->saveBLC_HIST_CTL = I915_READ(BLC_HIST_CTL);
 	if (IS_I965G(dev))
 		dev_priv->saveBLC_PWM_CTL2 = I915_READ(BLC_PWM_CTL2);
 	if (IS_MOBILE(dev) && !IS_I830(dev))
@@ -560,6 +561,7 @@ int i915_restore_state(struct drm_device
 
 	I915_WRITE(PFIT_PGM_RATIOS, dev_priv->savePFIT_PGM_RATIOS);
 	I915_WRITE(BLC_PWM_CTL, dev_priv->saveBLC_PWM_CTL);
+	I915_WRITE(BLC_HIST_CTL, dev_priv->saveBLC_HIST_CTL);
 	I915_WRITE(PP_ON_DELAYS, dev_priv->savePP_ON_DELAYS);
 	I915_WRITE(PP_OFF_DELAYS, dev_priv->savePP_OFF_DELAYS);
 	I915_WRITE(PP_DIVISOR, dev_priv->savePP_DIVISOR);


