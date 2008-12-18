Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbYLRW7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbYLRW7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbYLRW7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:59:39 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:64087 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbYLRW7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:59:37 -0500
Message-ID: <494ad5d5.0710660a.4800.ffffc418@mx.google.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Thu, 18 Dec 2008 21:18:47 +0100
Subject: [PATCH 2/6] drm/i915: fix sparse warnings: make symbols static
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:

  drivers/gpu/drm/i915/i915_drv.c:38:14: warning: symbol 'i915_modeset' was not declared. Should it be static?
  drivers/gpu/drm/i915/i915_dma.c:824:5: warning: symbol 'i915_probe_agp' was not declared. Should it be static?
  drivers/gpu/drm/i915/i915_dma.c:1010:5: warning: symbol 'i915_driver_firstopen' was not declared. Should it be static?
  drivers/gpu/drm/i915/intel_display.c:347:1: warning: symbol 'intel_pipe_set_base' was not declared. Should it be static?
  drivers/gpu/drm/i915/intel_display.c:1332:6: warning: symbol 'intel_crtc_init' was not declared. Should it be static?
  drivers/gpu/drm/i915/intel_display.c:1378:5: warning: symbol 'intel_connector_clones' was not declared. Should it be static?
  drivers/gpu/drm/i915/intel_crt.c:240:6: warning: symbol 'intel_crt_enc_destroy' was not declared. Should it be static?
  drivers/gpu/drm/i915/intel_sdvo.c:62:6: warning: symbol 'intel_sdvo_write_sdvox' was not declared. Should it be static?
  drivers/gpu/drm/i915/intel_sdvo.c:299:5: warning: symbol 'intel_sdvo_get_pixel_multiplier' was not declared. Should it be static?
  drivers/gpu/drm/i915/intel_sdvo.c:314:6: warning: symbol 'intel_sdvo_set_control_bus_switch' was not declared. Should it be static?
  drivers/gpu/drm/i915/intel_sdvo.c:970:6: warning: symbol 'intel_sdvo_enc_destroy' was not declared. Should it be static
  drivers/gpu/drm/i915/intel_fb.c:341:5: warning: symbol 'intelfb_blank' was not declared. Should it be static?
  drivers/gpu/drm/i915/intel_fb.c:431:5: warning: symbol 'intelfb_create' was not declared. Should it be static?
  drivers/gpu/drm/i915/intel_tv.c:1615:6: warning: symbol 'intel_tv_enc_destroy' was not declared. Should it be static?
  drivers/gpu/drm/i915/intel_dvo.c:46:25: warning: symbol 'intel_dvo_devices' was not declared. Should it be static?
  drivers/gpu/drm/i915/intel_dvo.c:338:6: warning: symbol 'intel_dvo_enc_destroy' was not declared. Should it be static?
  drivers/gpu/drm/i915/i915_opregion.c:260:5: warning: symbol 'intel_opregion_video_event' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/gpu/drm/i915/i915_dma.c      |    6 +++---
 drivers/gpu/drm/i915/i915_drv.c      |    2 +-
 drivers/gpu/drm/i915/i915_opregion.c |    4 ++--
 drivers/gpu/drm/i915/intel_crt.c     |    2 +-
 drivers/gpu/drm/i915/intel_display.c |    6 +++---
 drivers/gpu/drm/i915/intel_dvo.c     |    4 ++--
 drivers/gpu/drm/i915/intel_fb.c      |   10 +++++-----
 drivers/gpu/drm/i915/intel_sdvo.c    |    9 +++++----
 drivers/gpu/drm/i915/intel_tv.c      |    2 +-
 9 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index efcce1a..36a6884 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -821,8 +821,8 @@ static int i915_set_status_page(struct drm_device *dev, void *data,
  * some RAM for the framebuffer at early boot.  This code figures out
  * how much was set aside so we can use it for our own purposes.
  */
-int i915_probe_agp(struct drm_device *dev, unsigned long *aperture_size,
-		   unsigned long *preallocated_size)
+static int i915_probe_agp(struct drm_device *dev, unsigned long *aperture_size,
+			  unsigned long *preallocated_size)
 {
 	struct pci_dev *bridge_dev;
 	u16 tmp = 0;
@@ -1007,7 +1007,7 @@ void i915_master_destroy(struct drm_device *dev, struct drm_master *master)
 }
 
 
-int i915_driver_firstopen(struct drm_device *dev)
+static int i915_driver_firstopen(struct drm_device *dev)
 {
 	if (drm_core_check_feature(dev, DRIVER_MODESET))
 		return 0;
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index cbee41c..f8b3df0 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -35,7 +35,7 @@
 #include "drm_pciids.h"
 #include <linux/console.h>
 
-unsigned int i915_modeset = -1;
+static unsigned int i915_modeset = -1;
 module_param_named(modeset, i915_modeset, int, 0400);
 
 unsigned int i915_fbpercrtc = 0;
diff --git a/drivers/gpu/drm/i915/i915_opregion.c b/drivers/gpu/drm/i915/i915_opregion.c
index 13ae731..ff01283 100644
--- a/drivers/gpu/drm/i915/i915_opregion.c
+++ b/drivers/gpu/drm/i915/i915_opregion.c
@@ -257,8 +257,8 @@ void opregion_enable_asle(struct drm_device *dev)
 
 static struct intel_opregion *system_opregion;
 
-int intel_opregion_video_event(struct notifier_block *nb, unsigned long val,
-			       void *data)
+static int intel_opregion_video_event(struct notifier_block *nb,
+				      unsigned long val, void *data)
 {
 	/* The only video events relevant to opregion are 0x80. These indicate
 	   either a docking event, lid switch or display switch request. In
diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_crt.c
index 5d9c94e..dcaed34 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -237,7 +237,7 @@ static const struct drm_connector_helper_funcs intel_crt_connector_helper_funcs
 	.best_encoder = intel_best_encoder,
 };
 
-void intel_crt_enc_destroy(struct drm_encoder *encoder)
+static void intel_crt_enc_destroy(struct drm_encoder *encoder)
 {
 	drm_encoder_cleanup(encoder);
 }
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 96c2da5..9094119 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -343,7 +343,7 @@ intel_wait_for_vblank(struct drm_device *dev)
 	udelay(20000);
 }
 
-void
+static void
 intel_pipe_set_base(struct drm_crtc *crtc, int x, int y)
 {
 	struct drm_device *dev = crtc->dev;
@@ -1329,7 +1329,7 @@ static const struct drm_crtc_funcs intel_crtc_funcs = {
 };
 
 
-void intel_crtc_init(struct drm_device *dev, int pipe)
+static void intel_crtc_init(struct drm_device *dev, int pipe)
 {
 	struct intel_crtc *intel_crtc;
 	int i;
@@ -1375,7 +1375,7 @@ struct drm_crtc *intel_get_crtc_from_pipe(struct drm_device *dev, int pipe)
 	return crtc;
 }
 
-int intel_connector_clones(struct drm_device *dev, int type_mask)
+static int intel_connector_clones(struct drm_device *dev, int type_mask)
 {
 	int index_mask = 0;
 	struct drm_connector *connector;
diff --git a/drivers/gpu/drm/i915/intel_dvo.c b/drivers/gpu/drm/i915/intel_dvo.c
index 008bfae..cc621c8 100644
--- a/drivers/gpu/drm/i915/intel_dvo.c
+++ b/drivers/gpu/drm/i915/intel_dvo.c
@@ -43,7 +43,7 @@ extern struct intel_dvo_dev_ops ivch_ops;
 extern struct intel_dvo_dev_ops tfp410_ops;
 extern struct intel_dvo_dev_ops ch7017_ops;
 
-struct intel_dvo_device intel_dvo_devices[] = {
+static struct intel_dvo_device intel_dvo_devices[] = {
 	{
 		.type = INTEL_DVO_CHIP_TMDS,
 		.name = "sil164",
@@ -335,7 +335,7 @@ static const struct drm_connector_helper_funcs intel_dvo_connector_helper_funcs
 	.best_encoder = intel_best_encoder,
 };
 
-void intel_dvo_enc_destroy(struct drm_encoder *encoder)
+static void intel_dvo_enc_destroy(struct drm_encoder *encoder)
 {
 	drm_encoder_cleanup(encoder);
 }
diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index a89ebea..12664c3 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -338,7 +338,7 @@ static void intelfb_off(struct fb_info *info, int dpms_mode)
 	}
 }
 
-int intelfb_blank(int blank, struct fb_info *info)
+static int intelfb_blank(int blank, struct fb_info *info)
 {
 	switch (blank) {
 	case FB_BLANK_UNBLANK:
@@ -428,10 +428,10 @@ static struct notifier_block paniced = {
 	.notifier_call = intelfb_panic,
 };
 
-int intelfb_create(struct drm_device *dev, uint32_t fb_width,
-		   uint32_t fb_height, uint32_t surface_width,
-		   uint32_t surface_height,
-		   struct intel_framebuffer **intel_fb_p)
+static int intelfb_create(struct drm_device *dev, uint32_t fb_width,
+			  uint32_t fb_height, uint32_t surface_width,
+			  uint32_t surface_height,
+			  struct intel_framebuffer **intel_fb_p)
 {
 	struct fb_info *info;
 	struct intelfb_par *par;
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 626258d..fbbaa4f 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -59,7 +59,7 @@ struct intel_sdvo_priv {
  * SDVOB and SDVOC to work around apparent hardware issues (according to
  * comments in the BIOS).
  */
-void intel_sdvo_write_sdvox(struct intel_output *intel_output, u32 val)
+static void intel_sdvo_write_sdvox(struct intel_output *intel_output, u32 val)
 {
 	struct drm_device *dev = intel_output->base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -296,7 +296,7 @@ static u8 intel_sdvo_read_response(struct intel_output *intel_output,
 	return status;
 }
 
-int intel_sdvo_get_pixel_multiplier(struct drm_display_mode *mode)
+static int intel_sdvo_get_pixel_multiplier(struct drm_display_mode *mode)
 {
 	if (mode->clock >= 100000)
 		return 1;
@@ -311,7 +311,8 @@ int intel_sdvo_get_pixel_multiplier(struct drm_display_mode *mode)
  * SDVO chips which defeats the purpose of doing a bus switch in the first
  * place.
  */
-void intel_sdvo_set_control_bus_switch(struct intel_output *intel_output, u8 target)
+static void intel_sdvo_set_control_bus_switch(struct intel_output *intel_output,
+					      u8 target)
 {
 	intel_sdvo_write_cmd(intel_output, SDVO_CMD_SET_CONTROL_BUS_SWITCH, &target, 1);
 }
@@ -967,7 +968,7 @@ static const struct drm_connector_helper_funcs intel_sdvo_connector_helper_funcs
 	.best_encoder = intel_best_encoder,
 };
 
-void intel_sdvo_enc_destroy(struct drm_encoder *encoder)
+static void intel_sdvo_enc_destroy(struct drm_encoder *encoder)
 {
 	drm_encoder_cleanup(encoder);
 }
diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index d409b86..fbb35dc 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1612,7 +1612,7 @@ static const struct drm_connector_helper_funcs intel_tv_connector_helper_funcs =
 	.best_encoder = intel_best_encoder,
 };
 
-void intel_tv_enc_destroy(struct drm_encoder *encoder)
+static void intel_tv_enc_destroy(struct drm_encoder *encoder)
 {
 	drm_encoder_cleanup(encoder);
 }
-- 
1.5.6.3

