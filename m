Return-Path: <linux-kernel-owner+w=401wt.eu-S1762770AbZAGWm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762770AbZAGWm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbZAGWmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:42:45 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:5525 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbZAGWmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:42:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=OIWchwf5G0wFYAOEpEXnKbo7QVDnilAtWKhWfq64iubHXxIInsAl69OmNJE5MKmetu
         flt8LFek+kx4BcuOCmN4fDSylwud6SB66lb9JNaX8LlFzSGxAhhs2cQTabmd3jNlDtHf
         YSjZPW/1pLFuhph1Xduk5wPGM/8ZIGLZvP28Q=
Subject: [PATCH] trivial: replace last usages of __FUNCTION__ in kernel
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, airlied <airlied@linux.ie>,
       Eric Anholt <eric@anholt.net>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 14:42:41 -0800
Message-Id: <1231368161.5586.30.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mm/numa_32.c                     |    4 ++--
 drivers/gpu/drm/drm_crtc.c                |    2 +-
 drivers/gpu/drm/i915/i915_gem.c           |    4 ++--
 drivers/media/dvb/frontends/lgdt3304.c    |   10 +++++-----
 drivers/media/dvb/frontends/s921_module.c |    2 +-
 drivers/media/dvb/ttpci/budget-ci.c       |    2 +-
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 8518c67..d1f7439 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -239,7 +239,7 @@ void resume_map_numa_kva(pgd_t *pgd_base)
 		start_pfn = node_remap_start_pfn[node];
 		size = node_remap_size[node];
 
-		printk(KERN_DEBUG "%s: node %d\n", __FUNCTION__, node);
+		printk(KERN_DEBUG "%s: node %d\n", __func__, node);
 
 		for (pfn = 0; pfn < size; pfn += PTRS_PER_PTE) {
 			unsigned long vaddr = start_va + (pfn << PAGE_SHIFT);
@@ -251,7 +251,7 @@ void resume_map_numa_kva(pgd_t *pgd_base)
 						PAGE_KERNEL_LARGE_EXEC));
 
 			printk(KERN_DEBUG "%s: %08lx -> pfn %08lx\n",
-				__FUNCTION__, vaddr, start_pfn + pfn);
+				__func__, vaddr, start_pfn + pfn);
 		}
 	}
 }
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 53c8725..5b2cbb7 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -210,7 +210,7 @@ static int drm_mode_object_get(struct drm_device *dev,
 	int ret;
 
 	WARN(!mutex_is_locked(&dev->mode_config.mutex),
-	     "%s called w/o mode_config lock\n", __FUNCTION__);
+	     "%s called w/o mode_config lock\n", __func__);
 again:
 	if (idr_pre_get(&dev->mode_config.crtc_idr, GFP_KERNEL) == 0) {
 		DRM_ERROR("Ran out memory getting a mode number\n");
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 14afc23..1384d66 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1445,7 +1445,7 @@ static void i915_write_fence_reg(struct drm_i915_fence_reg *reg)
 
 	if ((obj_priv->gtt_offset & ~I915_FENCE_START_MASK) ||
 	    (obj_priv->gtt_offset & (obj->size - 1))) {
-		WARN(1, "%s: object not 1M or size aligned\n", __FUNCTION__);
+		WARN(1, "%s: object not 1M or size aligned\n", __func__);
 		return;
 	}
 
@@ -1478,7 +1478,7 @@ static void i830_write_fence_reg(struct drm_i915_fence_reg *reg)
 
 	if ((obj_priv->gtt_offset & ~I915_FENCE_START_MASK) ||
 	    (obj_priv->gtt_offset & (obj->size - 1))) {
-		WARN(1, "%s: object not 1M or size aligned\n", __FUNCTION__);
+		WARN(1, "%s: object not 1M or size aligned\n", __func__);
 		return;
 	}
 
diff --git a/drivers/media/dvb/frontends/lgdt3304.c b/drivers/media/dvb/frontends/lgdt3304.c
index 469ace5..3bb0c43 100644
--- a/drivers/media/dvb/frontends/lgdt3304.c
+++ b/drivers/media/dvb/frontends/lgdt3304.c
@@ -42,7 +42,7 @@ static int i2c_write_demod_bytes (struct dvb_frontend *fe, __u8 *buf, int len)
 
 	for (i=0; i<len-1; i+=3){
 		if((err = i2c_transfer(state->i2c, &i2cmsgs, 1))<0) {
-			printk("%s i2c_transfer error %d\n", __FUNCTION__, err);
+			printk("%s i2c_transfer error %d\n", __func__, err);
 			if (err < 0)
 				return err;
 			else
@@ -73,7 +73,7 @@ static int lgdt3304_i2c_read_reg(struct dvb_frontend *fe, unsigned int reg)
 	i2cmsgs[1].buf = &buf;
 
 	if((ret = i2c_transfer(state->i2c, i2cmsgs, 2))<0) {
-		printk("%s i2c_transfer error %d\n", __FUNCTION__, ret);
+		printk("%s i2c_transfer error %d\n", __func__, ret);
 		return ret;
 	}
 
@@ -94,7 +94,7 @@ static int lgdt3304_i2c_write_reg(struct dvb_frontend *fe, int reg, int val)
 	};
 	ret = i2c_transfer(state->i2c, &i2cmsgs, 1);
 	if (ret != 1) {
-		printk("%s i2c_transfer error %d\n", __FUNCTION__, ret);
+		printk("%s i2c_transfer error %d\n", __func__, ret);
 		return ret;
 	}
 
@@ -238,7 +238,7 @@ static int lgdt3304_set_parameters(struct dvb_frontend *fe, struct dvb_frontend_
 		}
 
 		if (err) {
-			printk("%s error setting modulation\n", __FUNCTION__);
+			printk("%s error setting modulation\n", __func__);
 		} else {
 			state->current_modulation = param->u.vsb.modulation;
 		}
@@ -305,7 +305,7 @@ static int lgdt3304_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		}
 		break;
 	default:
-		printk("%s unhandled modulation\n", __FUNCTION__);
+		printk("%s unhandled modulation\n", __func__);
 	}
 
 
diff --git a/drivers/media/dvb/frontends/s921_module.c b/drivers/media/dvb/frontends/s921_module.c
index 3cbb9cb..892af8c 100644
--- a/drivers/media/dvb/frontends/s921_module.c
+++ b/drivers/media/dvb/frontends/s921_module.c
@@ -136,7 +136,7 @@ static int s921_write(void *dev, u8 reg, u8 val) {
 	};
 
 	if((err = i2c_transfer(state->i2c, &i2cmsgs, 1))<0) {
-		printk("%s i2c_transfer error %d\n", __FUNCTION__, err);
+		printk("%s i2c_transfer error %d\n", __func__, err);
 		if (err < 0)
 			return err;
 		else
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 3507463..4d2a5cf 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -1450,7 +1450,7 @@ static void frontend_init(struct budget_ci *budget_ci)
 		if (budget_ci->budget.dvb_frontend) {
 			if (dvb_attach(stb6100_attach, budget_ci->budget.dvb_frontend, &tt3200_stb6100_config, &budget_ci->budget.i2c_adap)) {
 				if (!dvb_attach(lnbp21_attach, budget_ci->budget.dvb_frontend, &budget_ci->budget.i2c_adap, 0, 0)) {
-					printk("%s: No LNBP21 found!\n", __FUNCTION__);
+					printk("%s: No LNBP21 found!\n", __func__);
 					dvb_frontend_detach(budget_ci->budget.dvb_frontend);
 					budget_ci->budget.dvb_frontend = NULL;
 				}
-- 
1.6.1.94.g9388



