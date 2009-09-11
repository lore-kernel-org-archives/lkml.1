Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbZIKNz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbZIKNz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 09:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZIKNz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 09:55:29 -0400
Received: from nox.protox.org ([88.191.38.29]:47947 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZIKNz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 09:55:28 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: cleanup - remove radeon_share.h
Date: Fri, 11 Sep 2009 15:55:33 +0200
Message-Id: <1252677333-7876-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radeon_share.h was begining to give problem with include order in
respect of radeon.h. It's easier and also i think cleaner to move
what was in radeon_share.h into radeon.h. At the same time use the
extern keyword for function shared accross the module.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r300.c         |    1 -
 drivers/gpu/drm/radeon/r520.c         |    1 -
 drivers/gpu/drm/radeon/r600.c         |    1 -
 drivers/gpu/drm/radeon/r600_cs.c      |    1 -
 drivers/gpu/drm/radeon/radeon.h       |   93 ++++++++++++++++++++++++---
 drivers/gpu/drm/radeon/radeon_share.h |  116 ---------------------------------
 drivers/gpu/drm/radeon/rs400.c        |    1 -
 drivers/gpu/drm/radeon/rv515.c        |    1 -
 drivers/gpu/drm/radeon/rv770.c        |    1 -
 9 files changed, 84 insertions(+), 132 deletions(-)
 delete mode 100644 drivers/gpu/drm/radeon/radeon_share.h

diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index 92f9cb7..ced3322 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -31,7 +31,6 @@
 #include "radeon_reg.h"
 #include "radeon.h"
 #include "radeon_drm.h"
-#include "radeon_share.h"
 #include "r100_track.h"
 #include "r300d.h"
 
diff --git a/drivers/gpu/drm/radeon/r520.c b/drivers/gpu/drm/radeon/r520.c
index ebd6b0f..0e1686d 100644
--- a/drivers/gpu/drm/radeon/r520.c
+++ b/drivers/gpu/drm/radeon/r520.c
@@ -28,7 +28,6 @@
 #include "drmP.h"
 #include "radeon_reg.h"
 #include "radeon.h"
-#include "radeon_share.h"
 
 /* r520,rv530,rv560,rv570,r580 depends on : */
 void r100_hdp_reset(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index d8fcef4..1bc2567 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -32,7 +32,6 @@
 #include "radeon_drm.h"
 #include "radeon.h"
 #include "radeon_mode.h"
-#include "radeon_share.h"
 #include "r600d.h"
 #include "avivod.h"
 #include "atom.h"
diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
index 39bf634..33b89cd 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -27,7 +27,6 @@
  */
 #include "drmP.h"
 #include "radeon.h"
-#include "radeon_share.h"
 #include "r600d.h"
 #include "avivod.h"
 
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index e314756..8cec5bf 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -50,7 +50,6 @@
 #include <linux/kref.h>
 
 #include "radeon_mode.h"
-#include "radeon_share.h"
 #include "radeon_reg.h"
 
 /*
@@ -640,11 +639,55 @@ struct radeon_asic {
 	void (*bandwidth_update)(struct radeon_device *rdev);
 };
 
+/*
+ * Asic structures
+ */
 struct r100_asic {
 	const unsigned	*reg_safe_bm;
 	unsigned	reg_safe_bm_size;
 };
 
+struct r300_asic {
+	const unsigned	*reg_safe_bm;
+	unsigned	reg_safe_bm_size;
+};
+
+struct r600_asic {
+	unsigned max_pipes;
+	unsigned max_tile_pipes;
+	unsigned max_simds;
+	unsigned max_backends;
+	unsigned max_gprs;
+	unsigned max_threads;
+	unsigned max_stack_entries;
+	unsigned max_hw_contexts;
+	unsigned max_gs_threads;
+	unsigned sx_max_export_size;
+	unsigned sx_max_export_pos_size;
+	unsigned sx_max_export_smx_size;
+	unsigned sq_num_cf_insts;
+};
+
+struct rv770_asic {
+	unsigned max_pipes;
+	unsigned max_tile_pipes;
+	unsigned max_simds;
+	unsigned max_backends;
+	unsigned max_gprs;
+	unsigned max_threads;
+	unsigned max_stack_entries;
+	unsigned max_hw_contexts;
+	unsigned max_gs_threads;
+	unsigned sx_max_export_size;
+	unsigned sx_max_export_pos_size;
+	unsigned sx_max_export_smx_size;
+	unsigned sq_num_cf_insts;
+	unsigned sx_num_of_sets;
+	unsigned sc_prim_fifo_size;
+	unsigned sc_hiz_tile_fifo_size;
+	unsigned sc_earlyz_tile_fifo_fize;
+};
+
 union radeon_asic_config {
 	struct r300_asic	r300;
 	struct r100_asic	r100;
@@ -935,9 +978,14 @@ static inline void radeon_ring_write(struct radeon_device *rdev, uint32_t v)
 #define radeon_bandwidth_update(rdev) (rdev)->asic->bandwidth_update((rdev))
 
 /* Common functions */
-int radeon_modeset_init(struct radeon_device *rdev);
-void radeon_modeset_fini(struct radeon_device *rdev);
+extern int radeon_modeset_init(struct radeon_device *rdev);
+extern void radeon_modeset_fini(struct radeon_device *rdev);
 extern bool radeon_card_posted(struct radeon_device *rdev);
+extern int radeon_clocks_init(struct radeon_device *rdev);
+extern void radeon_clocks_fini(struct radeon_device *rdev);
+extern void radeon_scratch_init(struct radeon_device *rdev);
+extern void radeon_surface_init(struct radeon_device *rdev);
+extern int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data);
 
 /* r100,rv100,rs100,rv200,rs200,r200,rv250,rs300,rv280 */
 struct r100_mc_save {
@@ -951,10 +999,10 @@ struct r100_mc_save {
 extern void r100_cp_disable(struct radeon_device *rdev);
 extern int r100_cp_init(struct radeon_device *rdev, unsigned ring_size);
 extern void r100_cp_fini(struct radeon_device *rdev);
-void r100_pci_gart_tlb_flush(struct radeon_device *rdev);
-int r100_pci_gart_enable(struct radeon_device *rdev);
-void r100_pci_gart_disable(struct radeon_device *rdev);
-int r100_pci_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
+extern void r100_pci_gart_tlb_flush(struct radeon_device *rdev);
+extern int r100_pci_gart_enable(struct radeon_device *rdev);
+extern void r100_pci_gart_disable(struct radeon_device *rdev);
+extern int r100_pci_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
 extern int r100_debugfs_mc_info_init(struct radeon_device *rdev);
 extern int r100_gui_wait_for_idle(struct radeon_device *rdev);
 extern void r100_ib_fini(struct radeon_device *rdev);
@@ -963,6 +1011,7 @@ extern void r100_irq_disable(struct radeon_device *rdev);
 extern int r100_irq_set(struct radeon_device *rdev);
 extern void r100_mc_stop(struct radeon_device *rdev, struct r100_mc_save *save);
 extern void r100_mc_resume(struct radeon_device *rdev, struct r100_mc_save *save);
+extern void r100_vram_init_sizes(struct radeon_device *rdev);
 extern void r100_wb_disable(struct radeon_device *rdev);
 extern void r100_wb_fini(struct radeon_device *rdev);
 extern int r100_wb_init(struct radeon_device *rdev);
@@ -974,8 +1023,34 @@ extern void r300_vram_info(struct radeon_device *rdev);
 extern void rv370_pcie_gart_disable(struct radeon_device *rdev);
 
 /* r420,r423,rv410 */
-u32 r420_mc_rreg(struct radeon_device *rdev, u32 reg);
-void r420_mc_wreg(struct radeon_device *rdev, u32 reg, u32 v);
+extern u32 r420_mc_rreg(struct radeon_device *rdev, u32 reg);
+extern void r420_mc_wreg(struct radeon_device *rdev, u32 reg, u32 v);
 extern int r420_debugfs_pipes_info_init(struct radeon_device *rdev);
 
+/* rv515 */
+extern void rv515_bandwidth_avivo_update(struct radeon_device *rdev);
+
+/* rs690, rs740 */
+extern void rs690_line_buffer_adjust(struct radeon_device *rdev,
+					struct drm_display_mode *mode1,
+					struct drm_display_mode *mode2);
+
+/* r600, rv610, rv630, rv620, rv635, rv670, rs780, rs880 */
+extern bool r600_card_posted(struct radeon_device *rdev);
+extern void r600_cp_stop(struct radeon_device *rdev);
+extern void r600_ring_init(struct radeon_device *rdev, unsigned ring_size);
+extern int r600_cp_resume(struct radeon_device *rdev);
+extern int r600_count_pipe_bits(uint32_t val);
+extern int r600_gart_clear_page(struct radeon_device *rdev, int i);
+extern int r600_mc_wait_for_idle(struct radeon_device *rdev);
+extern void r600_pcie_gart_tlb_flush(struct radeon_device *rdev);
+extern int r600_ib_test(struct radeon_device *rdev);
+extern int r600_ring_test(struct radeon_device *rdev);
+extern int r600_wb_init(struct radeon_device *rdev);
+extern void r600_wb_fini(struct radeon_device *rdev);
+extern void r600_scratch_init(struct radeon_device *rdev);
+extern int r600_blit_init(struct radeon_device *rdev);
+extern void r600_blit_fini(struct radeon_device *rdev);
+extern int r600_cp_init_microcode(struct radeon_device *rdev);
+
 #endif
diff --git a/drivers/gpu/drm/radeon/radeon_share.h b/drivers/gpu/drm/radeon/radeon_share.h
deleted file mode 100644
index 5f9e358..0000000
--- a/drivers/gpu/drm/radeon/radeon_share.h
+++ /dev/null
@@ -1,116 +0,0 @@
-/*
- * Copyright 2008 Advanced Micro Devices, Inc.
- * Copyright 2008 Red Hat Inc.
- * Copyright 2009 Jerome Glisse.
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the "Software"),
- * to deal in the Software without restriction, including without limitation
- * the rights to use, copy, modify, merge, publish, distribute, sublicense,
- * and/or sell copies of the Software, and to permit persons to whom the
- * Software is furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
- * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
- * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
- * OTHER DEALINGS IN THE SOFTWARE.
- *
- * Authors: Dave Airlie
- *          Alex Deucher
- *          Jerome Glisse
- */
-#ifndef __RADEON_SHARE_H__
-#define __RADEON_SHARE_H__
-
-/* Common */
-struct radeon_device;
-struct radeon_cs_parser;
-int radeon_clocks_init(struct radeon_device *rdev);
-void radeon_clocks_fini(struct radeon_device *rdev);
-void radeon_scratch_init(struct radeon_device *rdev);
-void radeon_surface_init(struct radeon_device *rdev);
-int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data);
-
-
-/* R100, RV100, RS100, RV200, RS200, R200, RV250, RS300, RV280 */
-void r100_vram_init_sizes(struct radeon_device *rdev);
-
-
-/* R300, R350, RV350, RV380 */
-struct r300_asic {
-	const unsigned	*reg_safe_bm;
-	unsigned	reg_safe_bm_size;
-};
-
-
-/* RS690, RS740 */
-void rs690_line_buffer_adjust(struct radeon_device *rdev,
-			      struct drm_display_mode *mode1,
-			      struct drm_display_mode *mode2);
-
-
-/* RV515 */
-void rv515_bandwidth_avivo_update(struct radeon_device *rdev);
-
-
-/* R600, RV610, RV630, RV620, RV635, RV670, RS780, RS880 */
-bool r600_card_posted(struct radeon_device *rdev);
-void r600_cp_stop(struct radeon_device *rdev);
-void r600_ring_init(struct radeon_device *rdev, unsigned ring_size);
-int r600_cp_resume(struct radeon_device *rdev);
-int r600_count_pipe_bits(uint32_t val);
-int r600_gart_clear_page(struct radeon_device *rdev, int i);
-int r600_mc_wait_for_idle(struct radeon_device *rdev);
-void r600_pcie_gart_tlb_flush(struct radeon_device *rdev);
-int r600_ib_test(struct radeon_device *rdev);
-int r600_ring_test(struct radeon_device *rdev);
-int r600_wb_init(struct radeon_device *rdev);
-void r600_wb_fini(struct radeon_device *rdev);
-void r600_scratch_init(struct radeon_device *rdev);
-int r600_blit_init(struct radeon_device *rdev);
-void r600_blit_fini(struct radeon_device *rdev);
-int r600_cp_init_microcode(struct radeon_device *rdev);
-struct r600_asic {
-	unsigned max_pipes;
-	unsigned max_tile_pipes;
-	unsigned max_simds;
-	unsigned max_backends;
-	unsigned max_gprs;
-	unsigned max_threads;
-	unsigned max_stack_entries;
-	unsigned max_hw_contexts;
-	unsigned max_gs_threads;
-	unsigned sx_max_export_size;
-	unsigned sx_max_export_pos_size;
-	unsigned sx_max_export_smx_size;
-	unsigned sq_num_cf_insts;
-};
-
-/* RV770, RV7300, RV710 */
-struct rv770_asic {
-	unsigned max_pipes;
-	unsigned max_tile_pipes;
-	unsigned max_simds;
-	unsigned max_backends;
-	unsigned max_gprs;
-	unsigned max_threads;
-	unsigned max_stack_entries;
-	unsigned max_hw_contexts;
-	unsigned max_gs_threads;
-	unsigned sx_max_export_size;
-	unsigned sx_max_export_pos_size;
-	unsigned sx_max_export_smx_size;
-	unsigned sq_num_cf_insts;
-	unsigned sx_num_of_sets;
-	unsigned sc_prim_fifo_size;
-	unsigned sc_hiz_tile_fifo_size;
-	unsigned sc_earlyz_tile_fifo_fize;
-};
-
-#endif
diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index 8c3ea7e..e1e4ce4 100644
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -29,7 +29,6 @@
 #include <drm/drmP.h>
 #include "radeon_reg.h"
 #include "radeon.h"
-#include "radeon_share.h"
 
 /* rs400,rs480 depends on : */
 void r100_hdp_reset(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index 99e397f..03d4902 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -29,7 +29,6 @@
 #include "drmP.h"
 #include "rv515d.h"
 #include "radeon.h"
-#include "radeon_share.h"
 
 #include "rv515_reg_safe.h"
 /* rv515 depends on : */
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index 57765f6..5ba5204 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -29,7 +29,6 @@
 #include <linux/platform_device.h>
 #include "drmP.h"
 #include "radeon.h"
-#include "radeon_share.h"
 #include "rv770d.h"
 #include "avivod.h"
 #include "atom.h"
-- 
1.6.4.2

