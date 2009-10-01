Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZJAQEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZJAQEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZJAQEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:04:12 -0400
Received: from nox.protox.org ([88.191.38.29]:37889 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbZJAQEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:04:10 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH 1/5] drm/radeon/kms: Remove old init path as no hw use it anymore
Date: Thu,  1 Oct 2009 18:02:11 +0200
Message-Id: <1254412935-9976-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This remove old init path and allow code cleanup, now all hw
use the new init path, see top of radeon.h for description of
this.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r100.c          |    1 -
 drivers/gpu/drm/radeon/r300.c          |    1 -
 drivers/gpu/drm/radeon/r420.c          |    1 -
 drivers/gpu/drm/radeon/r520.c          |    1 -
 drivers/gpu/drm/radeon/r600.c          |    5 +-
 drivers/gpu/drm/radeon/radeon.h        |   26 -----
 drivers/gpu/drm/radeon/radeon_asic.h   |  138 ------------------------
 drivers/gpu/drm/radeon/radeon_device.c |  180 +-------------------------------
 drivers/gpu/drm/radeon/rs400.c         |    1 -
 drivers/gpu/drm/radeon/rs600.c         |    1 -
 drivers/gpu/drm/radeon/rs690.c         |    1 -
 drivers/gpu/drm/radeon/rv515.c         |    1 -
 drivers/gpu/drm/radeon/rv770.c         |    5 +-
 13 files changed, 7 insertions(+), 355 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 0a47561..7bea923 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3176,7 +3176,6 @@ int r100_init(struct radeon_device *rdev)
 {
 	int r;
 
-	rdev->new_init_path = true;
 	/* Register debugfs file specific to this group of asics */
 	r100_debugfs(rdev);
 	/* Disable VGA */
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index 18c81dc..e08c4a8 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -1275,7 +1275,6 @@ int r300_init(struct radeon_device *rdev)
 {
 	int r;
 
-	rdev->new_init_path = true;
 	/* Disable VGA */
 	r100_vga_render_disable(rdev);
 	/* Initialize scratch registers */
diff --git a/drivers/gpu/drm/radeon/r420.c b/drivers/gpu/drm/radeon/r420.c
index c5d3ba4..5c7fe52 100644
--- a/drivers/gpu/drm/radeon/r420.c
+++ b/drivers/gpu/drm/radeon/r420.c
@@ -272,7 +272,6 @@ int r420_init(struct radeon_device *rdev)
 {
 	int r;
 
-	rdev->new_init_path = true;
 	/* Initialize scratch registers */
 	radeon_scratch_init(rdev);
 	/* Initialize surface registers */
diff --git a/drivers/gpu/drm/radeon/r520.c b/drivers/gpu/drm/radeon/r520.c
index 9e17aa1..a555b7b 100644
--- a/drivers/gpu/drm/radeon/r520.c
+++ b/drivers/gpu/drm/radeon/r520.c
@@ -228,7 +228,6 @@ int r520_init(struct radeon_device *rdev)
 {
 	int r;
 
-	rdev->new_init_path = true;
 	/* Initialize scratch registers */
 	radeon_scratch_init(rdev);
 	/* Initialize surface registers */
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 6b7a40b..17fff7b 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1531,7 +1531,7 @@ int r600_resume(struct radeon_device *rdev)
 		return r;
 	}
 
-	r = radeon_ib_test(rdev);
+	r = r600_ib_test(rdev);
 	if (r) {
 		DRM_ERROR("radeon: failled testing IB (%d).\n", r);
 		return r;
@@ -1562,7 +1562,6 @@ int r600_init(struct radeon_device *rdev)
 {
 	int r;
 
-	rdev->new_init_path = true;
 	r = radeon_dummy_page_init(rdev);
 	if (r)
 		return r;
@@ -1653,7 +1652,7 @@ int r600_init(struct radeon_device *rdev)
 			DRM_ERROR("radeon: failled initializing IB pool (%d).\n", r);
 			rdev->accel_working = false;
 		}
-		r = radeon_ib_test(rdev);
+		r = r600_ib_test(rdev);
 		if (r) {
 			DRM_ERROR("radeon: failled testing IB (%d).\n", r);
 			rdev->accel_working = false;
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 8e18128..89fffe7 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -590,17 +590,7 @@ struct radeon_asic {
 	void (*fini)(struct radeon_device *rdev);
 	int (*resume)(struct radeon_device *rdev);
 	int (*suspend)(struct radeon_device *rdev);
-	void (*errata)(struct radeon_device *rdev);
-	void (*vram_info)(struct radeon_device *rdev);
 	int (*gpu_reset)(struct radeon_device *rdev);
-	int (*mc_init)(struct radeon_device *rdev);
-	void (*mc_fini)(struct radeon_device *rdev);
-	int (*wb_init)(struct radeon_device *rdev);
-	void (*wb_fini)(struct radeon_device *rdev);
-	int (*gart_init)(struct radeon_device *rdev);
-	void (*gart_fini)(struct radeon_device *rdev);
-	int (*gart_enable)(struct radeon_device *rdev);
-	void (*gart_disable)(struct radeon_device *rdev);
 	void (*gart_tlb_flush)(struct radeon_device *rdev);
 	int (*gart_set_page)(struct radeon_device *rdev, int i, uint64_t addr);
 	int (*cp_init)(struct radeon_device *rdev, unsigned ring_size);
@@ -610,7 +600,6 @@ struct radeon_asic {
 	void (*ring_start)(struct radeon_device *rdev);
 	int (*ring_test)(struct radeon_device *rdev);
 	void (*ring_ib_execute)(struct radeon_device *rdev, struct radeon_ib *ib);
-	int (*ib_test)(struct radeon_device *rdev);
 	int (*irq_set)(struct radeon_device *rdev);
 	int (*irq_process)(struct radeon_device *rdev);
 	u32 (*get_vblank_counter)(struct radeon_device *rdev, int crtc);
@@ -788,7 +777,6 @@ struct radeon_device {
 	bool				shutdown;
 	bool				suspend;
 	bool				need_dma32;
-	bool				new_init_path;
 	bool				accel_working;
 	struct radeon_surface_reg surface_regs[RADEON_GEM_MAX_SURFACES];
 	const struct firmware *me_fw;	/* all family ME firmware */
@@ -948,27 +936,13 @@ static inline void radeon_ring_write(struct radeon_device *rdev, uint32_t v)
 #define radeon_resume(rdev) (rdev)->asic->resume((rdev))
 #define radeon_suspend(rdev) (rdev)->asic->suspend((rdev))
 #define radeon_cs_parse(p) rdev->asic->cs_parse((p))
-#define radeon_errata(rdev) (rdev)->asic->errata((rdev))
-#define radeon_vram_info(rdev) (rdev)->asic->vram_info((rdev))
 #define radeon_gpu_reset(rdev) (rdev)->asic->gpu_reset((rdev))
-#define radeon_mc_init(rdev) (rdev)->asic->mc_init((rdev))
-#define radeon_mc_fini(rdev) (rdev)->asic->mc_fini((rdev))
-#define radeon_wb_init(rdev) (rdev)->asic->wb_init((rdev))
-#define radeon_wb_fini(rdev) (rdev)->asic->wb_fini((rdev))
-#define radeon_gpu_gart_init(rdev) (rdev)->asic->gart_init((rdev))
-#define radeon_gpu_gart_fini(rdev) (rdev)->asic->gart_fini((rdev))
-#define radeon_gart_enable(rdev) (rdev)->asic->gart_enable((rdev))
-#define radeon_gart_disable(rdev) (rdev)->asic->gart_disable((rdev))
 #define radeon_gart_tlb_flush(rdev) (rdev)->asic->gart_tlb_flush((rdev))
 #define radeon_gart_set_page(rdev, i, p) (rdev)->asic->gart_set_page((rdev), (i), (p))
-#define radeon_cp_init(rdev,rsize) (rdev)->asic->cp_init((rdev), (rsize))
-#define radeon_cp_fini(rdev) (rdev)->asic->cp_fini((rdev))
-#define radeon_cp_disable(rdev) (rdev)->asic->cp_disable((rdev))
 #define radeon_cp_commit(rdev) (rdev)->asic->cp_commit((rdev))
 #define radeon_ring_start(rdev) (rdev)->asic->ring_start((rdev))
 #define radeon_ring_test(rdev) (rdev)->asic->ring_test((rdev))
 #define radeon_ring_ib_execute(rdev, ib) (rdev)->asic->ring_ib_execute((rdev), (ib))
-#define radeon_ib_test(rdev) (rdev)->asic->ib_test((rdev))
 #define radeon_irq_set(rdev) (rdev)->asic->irq_set((rdev))
 #define radeon_irq_process(rdev) (rdev)->asic->irq_process((rdev))
 #define radeon_get_vblank_counter(rdev, crtc) (rdev)->asic->get_vblank_counter((rdev), (crtc))
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index 7bc86a6..d38f996 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -71,7 +71,6 @@ int r100_set_surface_reg(struct radeon_device *rdev, int reg,
 int r100_clear_surface_reg(struct radeon_device *rdev, int reg);
 void r100_bandwidth_update(struct radeon_device *rdev);
 void r100_ring_ib_execute(struct radeon_device *rdev, struct radeon_ib *ib);
-int r100_ib_test(struct radeon_device *rdev);
 int r100_ring_test(struct radeon_device *rdev);
 
 static struct radeon_asic r100_asic = {
@@ -79,27 +78,13 @@ static struct radeon_asic r100_asic = {
 	.fini = &r100_fini,
 	.suspend = &r100_suspend,
 	.resume = &r100_resume,
-	.errata = NULL,
-	.vram_info = NULL,
 	.gpu_reset = &r100_gpu_reset,
-	.mc_init = NULL,
-	.mc_fini = NULL,
-	.wb_init = NULL,
-	.wb_fini = NULL,
-	.gart_init = NULL,
-	.gart_fini = NULL,
-	.gart_enable = NULL,
-	.gart_disable = NULL,
 	.gart_tlb_flush = &r100_pci_gart_tlb_flush,
 	.gart_set_page = &r100_pci_gart_set_page,
-	.cp_init = NULL,
-	.cp_fini = NULL,
-	.cp_disable = NULL,
 	.cp_commit = &r100_cp_commit,
 	.ring_start = &r100_ring_start,
 	.ring_test = &r100_ring_test,
 	.ring_ib_execute = &r100_ring_ib_execute,
-	.ib_test = NULL,
 	.irq_set = &r100_irq_set,
 	.irq_process = &r100_irq_process,
 	.get_vblank_counter = &r100_get_vblank_counter,
@@ -145,27 +130,13 @@ static struct radeon_asic r300_asic = {
 	.fini = &r300_fini,
 	.suspend = &r300_suspend,
 	.resume = &r300_resume,
-	.errata = NULL,
-	.vram_info = NULL,
 	.gpu_reset = &r300_gpu_reset,
-	.mc_init = NULL,
-	.mc_fini = NULL,
-	.wb_init = NULL,
-	.wb_fini = NULL,
-	.gart_init = NULL,
-	.gart_fini = NULL,
-	.gart_enable = NULL,
-	.gart_disable = NULL,
 	.gart_tlb_flush = &r100_pci_gart_tlb_flush,
 	.gart_set_page = &r100_pci_gart_set_page,
-	.cp_init = NULL,
-	.cp_fini = NULL,
-	.cp_disable = NULL,
 	.cp_commit = &r100_cp_commit,
 	.ring_start = &r300_ring_start,
 	.ring_test = &r100_ring_test,
 	.ring_ib_execute = &r100_ring_ib_execute,
-	.ib_test = NULL,
 	.irq_set = &r100_irq_set,
 	.irq_process = &r100_irq_process,
 	.get_vblank_counter = &r100_get_vblank_counter,
@@ -195,25 +166,13 @@ static struct radeon_asic r420_asic = {
 	.fini = &r420_fini,
 	.suspend = &r420_suspend,
 	.resume = &r420_resume,
-	.errata = NULL,
-	.vram_info = NULL,
 	.gpu_reset = &r300_gpu_reset,
-	.mc_init = NULL,
-	.mc_fini = NULL,
-	.wb_init = NULL,
-	.wb_fini = NULL,
-	.gart_enable = NULL,
-	.gart_disable = NULL,
 	.gart_tlb_flush = &rv370_pcie_gart_tlb_flush,
 	.gart_set_page = &rv370_pcie_gart_set_page,
-	.cp_init = NULL,
-	.cp_fini = NULL,
-	.cp_disable = NULL,
 	.cp_commit = &r100_cp_commit,
 	.ring_start = &r300_ring_start,
 	.ring_test = &r100_ring_test,
 	.ring_ib_execute = &r100_ring_ib_execute,
-	.ib_test = NULL,
 	.irq_set = &r100_irq_set,
 	.irq_process = &r100_irq_process,
 	.get_vblank_counter = &r100_get_vblank_counter,
@@ -248,27 +207,13 @@ static struct radeon_asic rs400_asic = {
 	.fini = &rs400_fini,
 	.suspend = &rs400_suspend,
 	.resume = &rs400_resume,
-	.errata = NULL,
-	.vram_info = NULL,
 	.gpu_reset = &r300_gpu_reset,
-	.mc_init = NULL,
-	.mc_fini = NULL,
-	.wb_init = NULL,
-	.wb_fini = NULL,
-	.gart_init = NULL,
-	.gart_fini = NULL,
-	.gart_enable = NULL,
-	.gart_disable = NULL,
 	.gart_tlb_flush = &rs400_gart_tlb_flush,
 	.gart_set_page = &rs400_gart_set_page,
-	.cp_init = NULL,
-	.cp_fini = NULL,
-	.cp_disable = NULL,
 	.cp_commit = &r100_cp_commit,
 	.ring_start = &r300_ring_start,
 	.ring_test = &r100_ring_test,
 	.ring_ib_execute = &r100_ring_ib_execute,
-	.ib_test = NULL,
 	.irq_set = &r100_irq_set,
 	.irq_process = &r100_irq_process,
 	.get_vblank_counter = &r100_get_vblank_counter,
@@ -307,27 +252,13 @@ static struct radeon_asic rs600_asic = {
 	.fini = &rs600_fini,
 	.suspend = &rs600_suspend,
 	.resume = &rs600_resume,
-	.errata = NULL,
-	.vram_info = NULL,
 	.gpu_reset = &r300_gpu_reset,
-	.mc_init = NULL,
-	.mc_fini = NULL,
-	.wb_init = NULL,
-	.wb_fini = NULL,
-	.gart_init = NULL,
-	.gart_fini = NULL,
-	.gart_enable = NULL,
-	.gart_disable = NULL,
 	.gart_tlb_flush = &rs600_gart_tlb_flush,
 	.gart_set_page = &rs600_gart_set_page,
-	.cp_init = NULL,
-	.cp_fini = NULL,
-	.cp_disable = NULL,
 	.cp_commit = &r100_cp_commit,
 	.ring_start = &r300_ring_start,
 	.ring_test = &r100_ring_test,
 	.ring_ib_execute = &r100_ring_ib_execute,
-	.ib_test = NULL,
 	.irq_set = &rs600_irq_set,
 	.irq_process = &rs600_irq_process,
 	.get_vblank_counter = &rs600_get_vblank_counter,
@@ -359,27 +290,13 @@ static struct radeon_asic rs690_asic = {
 	.fini = &rs690_fini,
 	.suspend = &rs690_suspend,
 	.resume = &rs690_resume,
-	.errata = NULL,
-	.vram_info = NULL,
 	.gpu_reset = &r300_gpu_reset,
-	.mc_init = NULL,
-	.mc_fini = NULL,
-	.wb_init = NULL,
-	.wb_fini = NULL,
-	.gart_init = NULL,
-	.gart_fini = NULL,
-	.gart_enable = NULL,
-	.gart_disable = NULL,
 	.gart_tlb_flush = &rs400_gart_tlb_flush,
 	.gart_set_page = &rs400_gart_set_page,
-	.cp_init = NULL,
-	.cp_fini = NULL,
-	.cp_disable = NULL,
 	.cp_commit = &r100_cp_commit,
 	.ring_start = &r300_ring_start,
 	.ring_test = &r100_ring_test,
 	.ring_ib_execute = &r100_ring_ib_execute,
-	.ib_test = NULL,
 	.irq_set = &rs600_irq_set,
 	.irq_process = &rs600_irq_process,
 	.get_vblank_counter = &rs600_get_vblank_counter,
@@ -417,27 +334,13 @@ static struct radeon_asic rv515_asic = {
 	.fini = &rv515_fini,
 	.suspend = &rv515_suspend,
 	.resume = &rv515_resume,
-	.errata = NULL,
-	.vram_info = NULL,
 	.gpu_reset = &rv515_gpu_reset,
-	.mc_init = NULL,
-	.mc_fini = NULL,
-	.wb_init = NULL,
-	.wb_fini = NULL,
-	.gart_init = &rv370_pcie_gart_init,
-	.gart_fini = &rv370_pcie_gart_fini,
-	.gart_enable = NULL,
-	.gart_disable = NULL,
 	.gart_tlb_flush = &rv370_pcie_gart_tlb_flush,
 	.gart_set_page = &rv370_pcie_gart_set_page,
-	.cp_init = NULL,
-	.cp_fini = NULL,
-	.cp_disable = NULL,
 	.cp_commit = &r100_cp_commit,
 	.ring_start = &rv515_ring_start,
 	.ring_test = &r100_ring_test,
 	.ring_ib_execute = &r100_ring_ib_execute,
-	.ib_test = NULL,
 	.irq_set = &rs600_irq_set,
 	.irq_process = &rs600_irq_process,
 	.get_vblank_counter = &rs600_get_vblank_counter,
@@ -466,27 +369,13 @@ static struct radeon_asic r520_asic = {
 	.fini = &rv515_fini,
 	.suspend = &rv515_suspend,
 	.resume = &r520_resume,
-	.errata = NULL,
-	.vram_info = NULL,
 	.gpu_reset = &rv515_gpu_reset,
-	.mc_init = NULL,
-	.mc_fini = NULL,
-	.wb_init = NULL,
-	.wb_fini = NULL,
-	.gart_init = NULL,
-	.gart_fini = NULL,
-	.gart_enable = NULL,
-	.gart_disable = NULL,
 	.gart_tlb_flush = &rv370_pcie_gart_tlb_flush,
 	.gart_set_page = &rv370_pcie_gart_set_page,
-	.cp_init = NULL,
-	.cp_fini = NULL,
-	.cp_disable = NULL,
 	.cp_commit = &r100_cp_commit,
 	.ring_start = &rv515_ring_start,
 	.ring_test = &r100_ring_test,
 	.ring_ib_execute = &r100_ring_ib_execute,
-	.ib_test = NULL,
 	.irq_set = &rs600_irq_set,
 	.irq_process = &rs600_irq_process,
 	.get_vblank_counter = &rs600_get_vblank_counter,
@@ -533,36 +422,22 @@ int r600_set_surface_reg(struct radeon_device *rdev, int reg,
 			 uint32_t offset, uint32_t obj_size);
 int r600_clear_surface_reg(struct radeon_device *rdev, int reg);
 void r600_ring_ib_execute(struct radeon_device *rdev, struct radeon_ib *ib);
-int r600_ib_test(struct radeon_device *rdev);
 int r600_ring_test(struct radeon_device *rdev);
 int r600_copy_blit(struct radeon_device *rdev,
 		   uint64_t src_offset, uint64_t dst_offset,
 		   unsigned num_pages, struct radeon_fence *fence);
 
 static struct radeon_asic r600_asic = {
-	.errata = NULL,
 	.init = &r600_init,
 	.fini = &r600_fini,
 	.suspend = &r600_suspend,
 	.resume = &r600_resume,
 	.cp_commit = &r600_cp_commit,
-	.vram_info = NULL,
 	.gpu_reset = &r600_gpu_reset,
-	.mc_init = NULL,
-	.mc_fini = NULL,
-	.wb_init = &r600_wb_init,
-	.wb_fini = &r600_wb_fini,
-	.gart_enable = NULL,
-	.gart_disable = NULL,
 	.gart_tlb_flush = &r600_pcie_gart_tlb_flush,
 	.gart_set_page = &rs600_gart_set_page,
-	.cp_init = NULL,
-	.cp_fini = NULL,
-	.cp_disable = NULL,
-	.ring_start = NULL,
 	.ring_test = &r600_ring_test,
 	.ring_ib_execute = &r600_ring_ib_execute,
-	.ib_test = &r600_ib_test,
 	.irq_set = &r600_irq_set,
 	.irq_process = &r600_irq_process,
 	.fence_ring_emit = &r600_fence_ring_emit,
@@ -589,29 +464,16 @@ int rv770_resume(struct radeon_device *rdev);
 int rv770_gpu_reset(struct radeon_device *rdev);
 
 static struct radeon_asic rv770_asic = {
-	.errata = NULL,
 	.init = &rv770_init,
 	.fini = &rv770_fini,
 	.suspend = &rv770_suspend,
 	.resume = &rv770_resume,
 	.cp_commit = &r600_cp_commit,
-	.vram_info = NULL,
 	.gpu_reset = &rv770_gpu_reset,
-	.mc_init = NULL,
-	.mc_fini = NULL,
-	.wb_init = &r600_wb_init,
-	.wb_fini = &r600_wb_fini,
-	.gart_enable = NULL,
-	.gart_disable = NULL,
 	.gart_tlb_flush = &r600_pcie_gart_tlb_flush,
 	.gart_set_page = &rs600_gart_set_page,
-	.cp_init = NULL,
-	.cp_fini = NULL,
-	.cp_disable = NULL,
-	.ring_start = NULL,
 	.ring_test = &r600_ring_test,
 	.ring_ib_execute = &r600_ring_ib_execute,
-	.ib_test = &r600_ib_test,
 	.irq_set = &r600_irq_set,
 	.irq_process = &r600_irq_process,
 	.fence_ring_emit = &r600_fence_ring_emit,
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index a6733cf..2d07ccc 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -321,10 +321,6 @@ int radeon_asic_init(struct radeon_device *rdev)
 	case CHIP_RV380:
 		rdev->asic = &r300_asic;
 		if (rdev->flags & RADEON_IS_PCIE) {
-			rdev->asic->gart_init = &rv370_pcie_gart_init;
-			rdev->asic->gart_fini = &rv370_pcie_gart_fini;
-			rdev->asic->gart_enable = &rv370_pcie_gart_enable;
-			rdev->asic->gart_disable = &rv370_pcie_gart_disable;
 			rdev->asic->gart_tlb_flush = &rv370_pcie_gart_tlb_flush;
 			rdev->asic->gart_set_page = &rv370_pcie_gart_set_page;
 		}
@@ -529,19 +525,11 @@ int radeon_device_init(struct radeon_device *rdev,
 			   rdev->family == CHIP_R423) {
 			DRM_INFO("Forcing AGP to PCIE mode\n");
 			rdev->flags |= RADEON_IS_PCIE;
-			rdev->asic->gart_init = &rv370_pcie_gart_init;
-			rdev->asic->gart_fini = &rv370_pcie_gart_fini;
-			rdev->asic->gart_enable = &rv370_pcie_gart_enable;
-			rdev->asic->gart_disable = &rv370_pcie_gart_disable;
 			rdev->asic->gart_tlb_flush = &rv370_pcie_gart_tlb_flush;
 			rdev->asic->gart_set_page = &rv370_pcie_gart_set_page;
 		} else {
 			DRM_INFO("Forcing AGP to PCI mode\n");
 			rdev->flags |= RADEON_IS_PCI;
-			rdev->asic->gart_init = &r100_pci_gart_init;
-			rdev->asic->gart_fini = &r100_pci_gart_fini;
-			rdev->asic->gart_enable = &r100_pci_gart_enable;
-			rdev->asic->gart_disable = &r100_pci_gart_disable;
 			rdev->asic->gart_tlb_flush = &r100_pci_gart_tlb_flush;
 			rdev->asic->gart_set_page = &r100_pci_gart_set_page;
 		}
@@ -576,105 +564,10 @@ int radeon_device_init(struct radeon_device *rdev,
 	DRM_INFO("register mmio base: 0x%08X\n", (uint32_t)rdev->rmmio_base);
 	DRM_INFO("register mmio size: %u\n", (unsigned)rdev->rmmio_size);
 
-	rdev->new_init_path = false;
 	r = radeon_init(rdev);
 	if (r) {
 		return r;
 	}
-	if (!rdev->new_init_path) {
-		/* Setup errata flags */
-		radeon_errata(rdev);
-		/* Initialize scratch registers */
-		radeon_scratch_init(rdev);
-		/* Initialize surface registers */
-		radeon_surface_init(rdev);
-
-		/* TODO: disable VGA need to use VGA request */
-		/* BIOS*/
-		if (!radeon_get_bios(rdev)) {
-			if (ASIC_IS_AVIVO(rdev))
-				return -EINVAL;
-		}
-		if (rdev->is_atom_bios) {
-			r = radeon_atombios_init(rdev);
-			if (r) {
-				return r;
-			}
-		} else {
-			r = radeon_combios_init(rdev);
-			if (r) {
-				return r;
-			}
-		}
-		/* Reset gpu before posting otherwise ATOM will enter infinite loop */
-		if (radeon_gpu_reset(rdev)) {
-			/* FIXME: what do we want to do here ? */
-		}
-		/* check if cards are posted or not */
-		if (!radeon_card_posted(rdev) && rdev->bios) {
-			DRM_INFO("GPU not posted. posting now...\n");
-			if (rdev->is_atom_bios) {
-				atom_asic_init(rdev->mode_info.atom_context);
-			} else {
-				radeon_combios_asic_init(rdev->ddev);
-			}
-		}
-		/* Get clock & vram information */
-		radeon_get_clock_info(rdev->ddev);
-		radeon_vram_info(rdev);
-		/* Initialize clocks */
-		r = radeon_clocks_init(rdev);
-		if (r) {
-			return r;
-		}
-
-		/* Initialize memory controller (also test AGP) */
-		r = radeon_mc_init(rdev);
-		if (r) {
-			return r;
-		}
-		/* Fence driver */
-		r = radeon_fence_driver_init(rdev);
-		if (r) {
-			return r;
-		}
-		r = radeon_irq_kms_init(rdev);
-		if (r) {
-			return r;
-		}
-		/* Memory manager */
-		r = radeon_object_init(rdev);
-		if (r) {
-			return r;
-		}
-		r = radeon_gpu_gart_init(rdev);
-		if (r)
-			return r;
-		/* Initialize GART (initialize after TTM so we can allocate
-		 * memory through TTM but finalize after TTM) */
-		r = radeon_gart_enable(rdev);
-		if (r)
-			return 0;
-			r = radeon_gem_init(rdev);
-		if (r)
-			return 0;
-
-		/* 1M ring buffer */
-		r = radeon_cp_init(rdev, 1024 * 1024);
-		if (r)
-			return 0;
-		r = radeon_wb_init(rdev);
-		if (r)
-			DRM_ERROR("radeon: failled initializing WB (%d).\n", r);
-		r = radeon_ib_pool_init(rdev);
-		if (r)
-			return 0;
-		r = radeon_ib_test(rdev);
-		if (r)
-			return 0;
-		rdev->accel_working = true;
-	}
-	DRM_INFO("radeon: kernel modesetting successfully initialized.\n");
 	if (radeon_testing) {
 		radeon_test_moves(rdev);
 	}
@@ -689,30 +582,7 @@ void radeon_device_fini(struct radeon_device *rdev)
 	DRM_INFO("radeon: finishing device.\n");
 	rdev->shutdown = true;
 	/* Order matter so becarefull if you rearrange anythings */
-	if (!rdev->new_init_path) {
-		radeon_ib_pool_fini(rdev);
-		radeon_cp_fini(rdev);
-		radeon_wb_fini(rdev);
-		radeon_gpu_gart_fini(rdev);
-		radeon_gem_fini(rdev);
-		radeon_mc_fini(rdev);
-#if __OS_HAS_AGP
-		radeon_agp_fini(rdev);
-#endif
-		radeon_irq_kms_fini(rdev);
-		radeon_fence_driver_fini(rdev);
-		radeon_clocks_fini(rdev);
-		radeon_object_fini(rdev);
-		if (rdev->is_atom_bios) {
-			radeon_atombios_fini(rdev);
-		} else {
-			radeon_combios_fini(rdev);
-		}
-		kfree(rdev->bios);
-		rdev->bios = NULL;
-	} else {
-		radeon_fini(rdev);
-	}
+	radeon_fini(rdev);
 	iounmap(rdev->rmmio);
 	rdev->rmmio = NULL;
 }
@@ -752,14 +622,7 @@ int radeon_suspend_kms(struct drm_device *dev, pm_message_t state)
 
 	radeon_save_bios_scratch_regs(rdev);
 
-	if (!rdev->new_init_path) {
-		radeon_cp_disable(rdev);
-		radeon_gart_disable(rdev);
-		rdev->irq.sw_int = false;
-		radeon_irq_set(rdev);
-	} else {
-		radeon_suspend(rdev);
-	}
+	radeon_suspend(rdev);
 	/* evict remaining vram memory */
 	radeon_object_evict_vram(rdev);
 
@@ -778,7 +641,6 @@ int radeon_suspend_kms(struct drm_device *dev, pm_message_t state)
 int radeon_resume_kms(struct drm_device *dev)
 {
 	struct radeon_device *rdev = dev->dev_private;
-	int r;
 
 	acquire_console_sem();
 	pci_set_power_state(dev->pdev, PCI_D0);
@@ -788,43 +650,7 @@ int radeon_resume_kms(struct drm_device *dev)
 		return -1;
 	}
 	pci_set_master(dev->pdev);
-	/* Reset gpu before posting otherwise ATOM will enter infinite loop */
-	if (!rdev->new_init_path) {
-		if (radeon_gpu_reset(rdev)) {
-			/* FIXME: what do we want to do here ? */
-		}
-		/* post card */
-		if (rdev->is_atom_bios) {
-			atom_asic_init(rdev->mode_info.atom_context);
-		} else {
-			radeon_combios_asic_init(rdev->ddev);
-		}
-		/* Initialize clocks */
-		r = radeon_clocks_init(rdev);
-		if (r) {
-			release_console_sem();
-			return r;
-		}
-		/* Enable IRQ */
-		rdev->irq.sw_int = true;
-		radeon_irq_set(rdev);
-		/* Initialize GPU Memory Controller */
-		r = radeon_mc_init(rdev);
-		if (r) {
-			goto out;
-		}
-		r = radeon_gart_enable(rdev);
-		if (r) {
-			goto out;
-		}
-		r = radeon_cp_init(rdev, rdev->cp.ring_size);
-		if (r) {
-			goto out;
-		}
-	} else {
-		radeon_resume(rdev);
-	}
-out:
+	radeon_resume(rdev);
 	radeon_restore_bios_scratch_regs(rdev);
 	fb_set_suspend(rdev->fbdev_info, 0);
 	release_console_sem();
diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index 8b67605..a769c29 100644
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -460,7 +460,6 @@ int rs400_init(struct radeon_device *rdev)
 {
 	int r;
 
-	rdev->new_init_path = true;
 	/* Disable VGA */
 	r100_vga_render_disable(rdev);
 	/* Initialize scratch registers */
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index 985c594..01f6834 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -439,7 +439,6 @@ int rs600_init(struct radeon_device *rdev)
 {
 	int r;
 
-	rdev->new_init_path = true;
 	/* Disable VGA */
 	rv515_vga_render_disable(rdev);
 	/* Initialize scratch registers */
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index 3040ae9..025e322 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -672,7 +672,6 @@ int rs690_init(struct radeon_device *rdev)
 {
 	int r;
 
-	rdev->new_init_path = true;
 	/* Disable VGA */
 	rv515_vga_render_disable(rdev);
 	/* Initialize scratch registers */
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index cc342aa..41a34c2 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -553,7 +553,6 @@ int rv515_init(struct radeon_device *rdev)
 {
 	int r;
 
-	rdev->new_init_path = true;
 	/* Initialize scratch registers */
 	radeon_scratch_init(rdev);
 	/* Initialize surface registers */
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index e0b97d1..867d04b 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -915,7 +915,7 @@ int rv770_resume(struct radeon_device *rdev)
 		return r;
 	}
 
-	r = radeon_ib_test(rdev);
+	r = r600_ib_test(rdev);
 	if (r) {
 		DRM_ERROR("radeon: failled testing IB (%d).\n", r);
 		return r;
@@ -946,7 +946,6 @@ int rv770_init(struct radeon_device *rdev)
 {
 	int r;
 
-	rdev->new_init_path = true;
 	r = radeon_dummy_page_init(rdev);
 	if (r)
 		return r;
@@ -1034,7 +1033,7 @@ int rv770_init(struct radeon_device *rdev)
 			DRM_ERROR("radeon: failled initializing IB pool (%d).\n", r);
 			rdev->accel_working = false;
 		}
-		r = radeon_ib_test(rdev);
+		r = r600_ib_test(rdev);
 		if (r) {
 			DRM_ERROR("radeon: failled testing IB (%d).\n", r);
 			rdev->accel_working = false;
-- 
1.6.4.4

