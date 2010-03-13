Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab0CMKtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 05:49:22 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49118 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab0CMKtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 05:49:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tWBHprfa+FYAOOun/D+cdP3enHPdihzWVIRFjua5lUPSJq4vUzatu9fM9kxkJfTw4Y
         wCLRBjKLXJKZt+bdRrFQ1H4ZWHWBEMPsLAxHxqPoolzX/0ZEOYztdmsCdTMYSD3zrxKG
         SxGo5Ak0wl/UtfmsZx1UsTYCsjaVX9tXHktjs=
From: thcourbon <thcourbon@gmail.com>
To: airlied@linux.ie
Cc: airlied@redhat.com, jglisse@redhat.com, alexdeucher@gmail.com,
       zajec5@gmail.com, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, tcourbon <thomas@cafeaumiel.com>,
       Thomas Courbon <thcourbon@gmail.com>
Subject: [PATCH] drm/radeon : Fix brace coding style and checkpath.pl errors in r600.c This patch applies to radeon/r600.c and should fix the warnings raised by checkpath.pl about brace croding style issues. Also fixes a errors about return not beeing a function and extra spaces. Hope this could help.
Date: Sat, 13 Mar 2010 11:49:04 +0100
Message-Id: <1268477344-14210-1-git-send-email-thcourbon@gmail.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: tcourbon <thomas@cafeaumiel.com>

Signed-off-by: Thomas Courbon <thcourbon@gmail.com>
---
 drivers/gpu/drm/radeon/r600.c |   35 ++++++++++++++---------------------
 1 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index c522901..c964c75 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -372,9 +372,8 @@ void r600_pcie_gart_tlb_flush(struct radeon_device *rdev)
 			printk(KERN_WARNING "[drm] r600 flush TLB failed\n");
 			return;
 		}
-		if (tmp) {
+		if (tmp)
 			return;
-		}
 		udelay(1);
 	}
 }
@@ -562,9 +561,8 @@ static void r600_mc_program(struct radeon_device *rdev)
 	WREG32(HDP_REG_COHERENCY_FLUSH_CNTL, 0);
 
 	rv515_mc_stop(rdev, &save);
-	if (r600_mc_wait_for_idle(rdev)) {
+	if (r600_mc_wait_for_idle(rdev))
 		dev_warn(rdev->dev, "Wait for MC idle timedout !\n");
-	}
 	/* Lockout access through VGA aperture (doesn't exist before R600) */
 	WREG32(VGA_HDP_CONTROL, VGA_MEMORY_DISABLE);
 	/* Update configuration */
@@ -602,9 +600,8 @@ static void r600_mc_program(struct radeon_device *rdev)
 		WREG32(MC_VM_AGP_TOP, 0x0FFFFFFF);
 		WREG32(MC_VM_AGP_BOT, 0x0FFFFFFF);
 	}
-	if (r600_mc_wait_for_idle(rdev)) {
+	if (r600_mc_wait_for_idle(rdev))
 		dev_warn(rdev->dev, "Wait for MC idle timedout !\n");
-	}
 	rv515_mc_resume(rdev, &save);
 	/* we need to own VRAM, so turn off the VGA renderer here
 	 * to stop it overwriting our objects */
@@ -682,13 +679,12 @@ int r600_mc_init(struct radeon_device *rdev)
 	/* Get VRAM informations */
 	rdev->mc.vram_is_ddr = true;
 	tmp = RREG32(RAMCFG);
-	if (tmp & CHANSIZE_OVERRIDE) {
+	if (tmp & CHANSIZE_OVERRIDE)
 		chansize = 16;
-	} else if (tmp & CHANSIZE_MASK) {
+	else if (tmp & CHANSIZE_MASK)
 		chansize = 64;
-	} else {
+	else
 		chansize = 32;
-	}
 	tmp = RREG32(CHMAP);
 	switch ((tmp & NOOFCHAN_MASK) >> NOOFCHAN_SHIFT) {
 	case 0:
@@ -756,7 +752,7 @@ int r600_gpu_soft_reset(struct radeon_device *rdev)
 	u32 srbm_reset = 0;
 	u32 tmp;
 
-	dev_info(rdev->dev, "GPU softreset \n");
+	dev_info(rdev->dev, "GPU softreset\n");
 	dev_info(rdev->dev, "  R_008010_GRBM_STATUS=0x%08X\n",
 		RREG32(R_008010_GRBM_STATUS));
 	dev_info(rdev->dev, "  R_008014_GRBM_STATUS2=0x%08X\n",
@@ -764,9 +760,8 @@ int r600_gpu_soft_reset(struct radeon_device *rdev)
 	dev_info(rdev->dev, "  R_000E50_SRBM_STATUS=0x%08X\n",
 		RREG32(R_000E50_SRBM_STATUS));
 	rv515_mc_stop(rdev, &save);
-	if (r600_mc_wait_for_idle(rdev)) {
+	if (r600_mc_wait_for_idle(rdev))
 		dev_warn(rdev->dev, "Wait for MC idle timedout !\n");
-	}
 	/* Disable CP parsing/prefetching */
 	WREG32(R_0086D8_CP_ME_CNTL, S_0086D8_CP_ME_HALT(0xff));
 	/* Check if any of the rendering block is busy and reset it */
@@ -1315,9 +1310,8 @@ void r600_gpu_init(struct radeon_device *rdev)
 	default:
 		break;
 	}
-	if (tmp > 256) {
+	if (tmp > 256)
 		tmp = 256;
-	}
 	WREG32(VGT_ES_PER_GS, 128);
 	WREG32(VGT_GS_PER_ES, tmp);
 	WREG32(VGT_GS_PER_VS, 2);
@@ -1469,7 +1463,8 @@ int r600_init_microcode(struct radeon_device *rdev)
 		chip_name = "RV710";
 		rlc_chip_name = "R700";
 		break;
-	default: BUG();
+	default:
+		BUG();
 	}
 
 	if (rdev->family >= CHIP_RV770) {
@@ -1955,9 +1950,8 @@ int r600_resume(struct radeon_device *rdev)
 	atom_asic_init(rdev->mode_info.atom_context);
 	/* Initialize clocks */
 	r = radeon_clocks_init(rdev);
-	if (r) {
+	if (r)
 		return r;
-	}
 
 	r = r600_startup(rdev);
 	if (r) {
@@ -2015,9 +2009,8 @@ int r600_init(struct radeon_device *rdev)
 	r = radeon_dummy_page_init(rdev);
 	if (r)
 		return r;
-	if (r600_debugfs_mc_info_init(rdev)) {
+	if (r600_debugfs_mc_info_init(rdev))
 		DRM_ERROR("Failed to register debugfs file for mc !\n");
-	}
 	/* This don't do much */
 	r = radeon_gem_init(rdev);
 	if (r)
@@ -2693,7 +2686,7 @@ static inline u32 r600_get_ih_wptr(struct radeon_device *rdev)
 		tmp |= IH_WPTR_OVERFLOW_CLEAR;
 		WREG32(IH_RB_CNTL, tmp);
 	}
-	return (wptr & rdev->ih.ptr_mask);
+	return wptr & rdev->ih.ptr_mask;
 }
 
 /*        r600 IV Ring
-- 
1.7.0.2

