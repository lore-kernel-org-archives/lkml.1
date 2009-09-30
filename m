Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbZI3B61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbZI3B61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 21:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZI3B60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 21:58:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40184 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbZI3B6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 21:58:25 -0400
Date: Wed, 30 Sep 2009 11:58:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: linux-next: manual merge of the drm tree with the  tree
Message-Id: <20090930115824.683a1dd1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/radeon/radeon_asic.h between commit
28d520433b6375740990ab99d69b0d0067fd656b ("drm/vgaarb: add VGA
arbitration support to the drm and kms") from Linus' tree and commits
d39c3b895876427c5083a936e00f3f5b7f0fc1b3 ("drm/radeon/kms: Convert RV515
to new init path and associated cleanup") and
f0ed1f655aa0375e2abba84cc4e8e6c853d48555 ("drm/radeon/kms: Convert R520
to new init path and associated cleanup") from the drm tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/radeon/radeon_asic.h
index 8968f78,bce0cb0..0000000
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@@ -431,25 -421,29 +428,30 @@@ void rv515_ring_start(struct radeon_dev
  uint32_t rv515_pcie_rreg(struct radeon_device *rdev, uint32_t reg);
  void rv515_pcie_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
  void rv515_bandwidth_update(struct radeon_device *rdev);
+ int rv515_resume(struct radeon_device *rdev);
+ int rv515_suspend(struct radeon_device *rdev);
  static struct radeon_asic rv515_asic = {
  	.init = &rv515_init,
- 	.errata = &rv515_errata,
- 	.vram_info = &rv515_vram_info,
+ 	.fini = &rv515_fini,
+ 	.suspend = &rv515_suspend,
+ 	.resume = &rv515_resume,
+ 	.errata = NULL,
+ 	.vram_info = NULL,
 +	.vga_set_state = &r100_vga_set_state,
  	.gpu_reset = &rv515_gpu_reset,
- 	.mc_init = &rv515_mc_init,
- 	.mc_fini = &rv515_mc_fini,
- 	.wb_init = &r100_wb_init,
- 	.wb_fini = &r100_wb_fini,
+ 	.mc_init = NULL,
+ 	.mc_fini = NULL,
+ 	.wb_init = NULL,
+ 	.wb_fini = NULL,
  	.gart_init = &rv370_pcie_gart_init,
  	.gart_fini = &rv370_pcie_gart_fini,
- 	.gart_enable = &rv370_pcie_gart_enable,
- 	.gart_disable = &rv370_pcie_gart_disable,
+ 	.gart_enable = NULL,
+ 	.gart_disable = NULL,
  	.gart_tlb_flush = &rv370_pcie_gart_tlb_flush,
  	.gart_set_page = &rv370_pcie_gart_set_page,
- 	.cp_init = &r100_cp_init,
- 	.cp_fini = &r100_cp_fini,
- 	.cp_disable = &r100_cp_disable,
+ 	.cp_init = NULL,
+ 	.cp_fini = NULL,
+ 	.cp_disable = NULL,
  	.cp_commit = &r100_cp_commit,
  	.ring_start = &rv515_ring_start,
  	.ring_test = &r100_ring_test,
@@@ -476,30 -470,29 +478,30 @@@
  /*
   * r520,rv530,rv560,rv570,r580
   */
- void r520_errata(struct radeon_device *rdev);
- void r520_vram_info(struct radeon_device *rdev);
- int r520_mc_init(struct radeon_device *rdev);
- void r520_mc_fini(struct radeon_device *rdev);
- void r520_bandwidth_update(struct radeon_device *rdev);
+ int r520_init(struct radeon_device *rdev);
+ int r520_resume(struct radeon_device *rdev);
  static struct radeon_asic r520_asic = {
- 	.init = &rv515_init,
- 	.errata = &r520_errata,
- 	.vram_info = &r520_vram_info,
+ 	.init = &r520_init,
+ 	.fini = &rv515_fini,
+ 	.suspend = &rv515_suspend,
+ 	.resume = &r520_resume,
+ 	.errata = NULL,
+ 	.vram_info = NULL,
 +	.vga_set_state = &r100_vga_set_state,
  	.gpu_reset = &rv515_gpu_reset,
- 	.mc_init = &r520_mc_init,
- 	.mc_fini = &r520_mc_fini,
- 	.wb_init = &r100_wb_init,
- 	.wb_fini = &r100_wb_fini,
- 	.gart_init = &rv370_pcie_gart_init,
- 	.gart_fini = &rv370_pcie_gart_fini,
- 	.gart_enable = &rv370_pcie_gart_enable,
- 	.gart_disable = &rv370_pcie_gart_disable,
+ 	.mc_init = NULL,
+ 	.mc_fini = NULL,
+ 	.wb_init = NULL,
+ 	.wb_fini = NULL,
+ 	.gart_init = NULL,
+ 	.gart_fini = NULL,
+ 	.gart_enable = NULL,
+ 	.gart_disable = NULL,
  	.gart_tlb_flush = &rv370_pcie_gart_tlb_flush,
  	.gart_set_page = &rv370_pcie_gart_set_page,
- 	.cp_init = &r100_cp_init,
- 	.cp_fini = &r100_cp_fini,
- 	.cp_disable = &r100_cp_disable,
+ 	.cp_init = NULL,
+ 	.cp_fini = NULL,
+ 	.cp_disable = NULL,
  	.cp_commit = &r100_cp_commit,
  	.ring_start = &rv515_ring_start,
  	.ring_test = &r100_ring_test,
