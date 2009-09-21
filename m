Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZIUFMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZIUFMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 01:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbZIUFMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 01:12:52 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55458 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbZIUFMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 01:12:49 -0400
Date: Mon, 21 Sep 2009 06:12:54 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm tree.
Message-ID: <alpine.DEB.2.00.0909210610200.26881@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-580670798-1253509974=:26881"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-580670798-1253509974=:26881
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

This contains the main chunk of the drm changes for 2.6.32, I think Eric 
has been on holidays for a week so I'd expect some more Intel changes 
incoming in the merge window. It also contains a few merges for things 
that were conflicting with things I sent to you via the drm-fixes tree,
but they weren't always trivial.

Major highlights core drm/non-kms:
move mga/r128/radeon to firmware loader - major LOC churn,
decreases in-memory radeon module footprint quite a bit.
r600 3D support in non-kms mode.
VGA arbitration support for core drm and kms (was waiting for
jbarnes tree to land).

core KMS:
add support for GTF/CVT/DMT modes, gets us a long way towards X
merge intel and radeon kms framebuffer implementations for sanity.

radeon KMS:
R600 KMS support + acceleration support.
move to generating the safe register tables with a script.
radeon tv-out supported ported from userspace
rn50/r100/r200 command submission trackers added

intel: 
some IGDNG fixes
important fix for wrapping at end of ring
more SDVO tv-out support
dynamic clocking support


Dave.

 drivers/gpu/drm/Kconfig                            |   18 +-
 drivers/gpu/drm/Makefile                           |    8 +-
 drivers/gpu/drm/drm_bufs.c                         |    4 +-
 drivers/gpu/drm/drm_cache.c                        |   46 +-
 drivers/gpu/drm/drm_crtc.c                         |   77 +-
 drivers/gpu/drm/drm_crtc_helper.c                  |  223 +-
 drivers/gpu/drm/drm_drv.c                          |    4 +-
 drivers/gpu/drm/drm_edid.c                         |  504 +-
 drivers/gpu/drm/drm_encoder_slave.c                |  116 +
 drivers/gpu/drm/drm_fb_helper.c                    |  707 +
 drivers/gpu/drm/drm_gem.c                          |   11 +-
 drivers/gpu/drm/drm_irq.c                          |   27 +
 drivers/gpu/drm/drm_mm.c                           |   21 +
 drivers/gpu/drm/drm_modes.c                        |  435 +-
 drivers/gpu/drm/drm_proc.c                         |   17 +-
 drivers/gpu/drm/drm_sysfs.c                        |   28 +
 drivers/gpu/drm/i915/Makefile                      |    2 +-
 .../i915/{i915_gem_debugfs.c => i915_debugfs.c}    |   91 +-
 drivers/gpu/drm/i915/i915_dma.c                    |  120 +-
 drivers/gpu/drm/i915/i915_drv.c                    |    9 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   63 +-
 drivers/gpu/drm/i915/i915_gem.c                    |   14 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c             |   80 +-
 drivers/gpu/drm/i915/i915_irq.c                    |   21 +
 drivers/gpu/drm/i915/i915_reg.h                    |  144 +-
 drivers/gpu/drm/i915/i915_suspend.c                |    4 +-
 drivers/gpu/drm/i915/intel_bios.c                  |    8 +-
 drivers/gpu/drm/i915/intel_crt.c                   |   28 +
 drivers/gpu/drm/i915/intel_display.c               |  624 +-
 drivers/gpu/drm/i915/intel_drv.h                   |    8 +-
 drivers/gpu/drm/i915/intel_fb.c                    |  737 +-
 drivers/gpu/drm/i915/intel_i2c.c                   |    8 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |   22 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |  331 +-
 drivers/gpu/drm/i915/intel_tv.c                    |   30 +
 drivers/gpu/drm/mga/mga_dma.c                      |    4 +-
 drivers/gpu/drm/mga/mga_drv.h                      |    1 -
 drivers/gpu/drm/mga/mga_ucode.h                    |11645 ----------
 drivers/gpu/drm/mga/mga_warp.c                     |  180 +-
 drivers/gpu/drm/r128/r128_cce.c                    |  116 +-
 drivers/gpu/drm/r128/r128_drv.h                    |    8 +
 drivers/gpu/drm/r128/r128_state.c                  |   36 +-
 drivers/gpu/drm/radeon/Kconfig                     |    1 -
 drivers/gpu/drm/radeon/Makefile                    |   43 +-
 drivers/gpu/drm/radeon/atombios.h                  |   11 +
 drivers/gpu/drm/radeon/atombios_crtc.c             |  105 +-
 drivers/gpu/drm/radeon/avivod.h                    |   69 +
 drivers/gpu/drm/radeon/mkregtable.c                |  720 +
 drivers/gpu/drm/radeon/r100.c                      | 1232 +-
 drivers/gpu/drm/radeon/r100_track.h                |  124 +
 drivers/gpu/drm/radeon/r100d.h                     |  607 +
 drivers/gpu/drm/radeon/r200.c                      |  456 +
 drivers/gpu/drm/radeon/r300.c                      |  556 +-
 drivers/gpu/drm/radeon/r300.h                      |   36 -
 drivers/gpu/drm/radeon/r300d.h                     |  101 +
 drivers/gpu/drm/radeon/r420.c                      |  301 +-
 drivers/gpu/drm/radeon/r420d.h                     |  249 +
 drivers/gpu/drm/radeon/r520.c                      |    6 -
 drivers/gpu/drm/radeon/r600.c                      | 1802 ++-
 drivers/gpu/drm/radeon/r600_blit.c                 |  850 +
 drivers/gpu/drm/radeon/r600_blit_kms.c             |  805 +
 drivers/gpu/drm/radeon/r600_blit_shaders.c         | 1072 +
 drivers/gpu/drm/radeon/r600_blit_shaders.h         |   14 +
 drivers/gpu/drm/radeon/r600_cp.c                   |  541 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |  657 +
 drivers/gpu/drm/radeon/r600_microcode.h            |23297 --------------------
 drivers/gpu/drm/radeon/r600d.h                     |  662 +
 drivers/gpu/drm/radeon/radeon.h                    |  269 +-
 drivers/gpu/drm/radeon/radeon_asic.h               |  240 +-
 drivers/gpu/drm/radeon/radeon_atombios.c           |  171 +-
 drivers/gpu/drm/radeon/radeon_clocks.c             |   10 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |   58 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |  480 +-
 drivers/gpu/drm/radeon/radeon_cp.c                 |  151 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |    3 +-
 drivers/gpu/drm/radeon/radeon_device.c             |  423 +-
 drivers/gpu/drm/radeon/radeon_display.c            |  101 +-
 drivers/gpu/drm/radeon/radeon_drv.c                |   23 +-
 drivers/gpu/drm/radeon/radeon_drv.h                |  151 +-
 drivers/gpu/drm/radeon/radeon_encoders.c           |  137 +-
 drivers/gpu/drm/radeon/radeon_fb.c                 |  674 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |   49 +-
 drivers/gpu/drm/radeon/radeon_gart.c               |    9 +-
 drivers/gpu/drm/radeon/radeon_ioc32.c              |   15 +
 drivers/gpu/drm/radeon/radeon_irq.c                |   18 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |    1 -
 drivers/gpu/drm/radeon/radeon_kms.c                |   25 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c        |   85 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |  368 +-
 drivers/gpu/drm/radeon/radeon_legacy_tv.c          |  904 +
 drivers/gpu/drm/radeon/radeon_microcode.h          | 1844 --
 drivers/gpu/drm/radeon/radeon_mode.h               |   74 +-
 drivers/gpu/drm/radeon/radeon_object.c             |   10 +
 drivers/gpu/drm/radeon/radeon_object.h             |    1 +
 drivers/gpu/drm/radeon/radeon_reg.h                |   79 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |  143 +-
 drivers/gpu/drm/radeon/radeon_share.h              |   39 -
 drivers/gpu/drm/radeon/radeon_state.c              |   23 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |   96 +-
 drivers/gpu/drm/radeon/reg_srcs/r100               |  105 +
 drivers/gpu/drm/radeon/reg_srcs/r200               |  184 +
 drivers/gpu/drm/radeon/reg_srcs/r300               |  729 +
 drivers/gpu/drm/radeon/reg_srcs/rn50               |   30 +
 drivers/gpu/drm/radeon/reg_srcs/rs600              |  729 +
 drivers/gpu/drm/radeon/reg_srcs/rv515              |  486 +
 drivers/gpu/drm/radeon/rs400.c                     |   56 +-
 drivers/gpu/drm/radeon/rs600.c                     |  106 +-
 drivers/gpu/drm/radeon/rs690.c                     |    4 -
 drivers/gpu/drm/radeon/rs780.c                     |  102 -
 drivers/gpu/drm/radeon/rv515.c                     |  524 +-
 drivers/gpu/drm/radeon/{rv515r.h => rv515d.h}      |   56 +-
 drivers/gpu/drm/radeon/rv770.c                     | 1050 +-
 drivers/gpu/drm/radeon/rv770d.h                    |  341 +
 drivers/gpu/drm/ttm/ttm_bo.c                       |  295 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |    4 +-
 drivers/gpu/drm/ttm/ttm_global.c                   |    4 +-
 drivers/gpu/drm/ttm/ttm_memory.c                   |  508 +-
 drivers/gpu/drm/ttm/ttm_module.c                   |   58 +-
 drivers/gpu/drm/ttm/ttm_tt.c                       |  104 +-
 firmware/Makefile                                  |   16 +
 firmware/WHENCE                                    |  121 +
 firmware/matrox/g200_warp.H16                      |   28 +
 firmware/matrox/g400_warp.H16                      |   44 +
 firmware/r128/r128_cce.bin.ihex                    |  129 +
 firmware/radeon/R100_cp.bin.ihex                   |  130 +
 firmware/radeon/R200_cp.bin.ihex                   |  130 +
 firmware/radeon/R300_cp.bin.ihex                   |  130 +
 firmware/radeon/R420_cp.bin.ihex                   |  130 +
 firmware/radeon/R520_cp.bin.ihex                   |  130 +
 firmware/radeon/R600_me.bin.ihex                   | 1345 ++
 firmware/radeon/R600_pfp.bin.ihex                  |  145 +
 firmware/radeon/RS600_cp.bin.ihex                  |  130 +
 firmware/radeon/RS690_cp.bin.ihex                  |  130 +
 firmware/radeon/RS780_me.bin.ihex                  | 1345 ++
 firmware/radeon/RS780_pfp.bin.ihex                 |  145 +
 firmware/radeon/RV610_me.bin.ihex                  | 1345 ++
 firmware/radeon/RV610_pfp.bin.ihex                 |  145 +
 firmware/radeon/RV620_me.bin.ihex                  | 1345 ++
 firmware/radeon/RV620_pfp.bin.ihex                 |  145 +
 firmware/radeon/RV630_me.bin.ihex                  | 1345 ++
 firmware/radeon/RV630_pfp.bin.ihex                 |  145 +
 firmware/radeon/RV635_me.bin.ihex                  | 1345 ++
 firmware/radeon/RV635_pfp.bin.ihex                 |  145 +
 firmware/radeon/RV670_me.bin.ihex                  | 1345 ++
 firmware/radeon/RV670_pfp.bin.ihex                 |  145 +
 firmware/radeon/RV710_me.bin.ihex                  |  341 +
 firmware/radeon/RV710_pfp.bin.ihex                 |  213 +
 firmware/radeon/RV730_me.bin.ihex                  |  341 +
 firmware/radeon/RV730_pfp.bin.ihex                 |  213 +
 firmware/radeon/RV770_me.bin.ihex                  |  341 +
 firmware/radeon/RV770_pfp.bin.ihex                 |  213 +
 include/drm/drmP.h                                 |   57 +-
 include/drm/drm_cache.h                            |   38 +
 include/drm/drm_crtc.h                             |   16 +
 include/drm/drm_crtc_helper.h                      |    3 +
 include/drm/drm_encoder_slave.h                    |  162 +
 include/drm/drm_fb_helper.h                        |   82 +
 include/drm/drm_mm.h                               |    7 +
 include/drm/drm_mode.h                             |   11 +-
 include/drm/drm_sysfs.h                            |   12 +
 include/drm/radeon_drm.h                           |   12 +-
 include/drm/ttm/ttm_bo_api.h                       |   13 +-
 include/drm/ttm/ttm_bo_driver.h                    |   94 +-
 include/drm/ttm/ttm_memory.h                       |   43 +-
 include/drm/ttm/ttm_module.h                       |    2 +
 165 files changed, 35577 insertions(+), 41361 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_encoder_slave.c
 create mode 100644 drivers/gpu/drm/drm_fb_helper.c
 rename drivers/gpu/drm/i915/{i915_gem_debugfs.c => i915_debugfs.c} (79%)
 delete mode 100644 drivers/gpu/drm/mga/mga_ucode.h
 create mode 100644 drivers/gpu/drm/radeon/avivod.h
 create mode 100644 drivers/gpu/drm/radeon/mkregtable.c
 create mode 100644 drivers/gpu/drm/radeon/r100_track.h
 create mode 100644 drivers/gpu/drm/radeon/r100d.h
 create mode 100644 drivers/gpu/drm/radeon/r200.c
 delete mode 100644 drivers/gpu/drm/radeon/r300.h
 create mode 100644 drivers/gpu/drm/radeon/r300d.h
 create mode 100644 drivers/gpu/drm/radeon/r420d.h
 create mode 100644 drivers/gpu/drm/radeon/r600_blit.c
 create mode 100644 drivers/gpu/drm/radeon/r600_blit_kms.c
 create mode 100644 drivers/gpu/drm/radeon/r600_blit_shaders.c
 create mode 100644 drivers/gpu/drm/radeon/r600_blit_shaders.h
 create mode 100644 drivers/gpu/drm/radeon/r600_cs.c
 delete mode 100644 drivers/gpu/drm/radeon/r600_microcode.h
 create mode 100644 drivers/gpu/drm/radeon/r600d.h
 create mode 100644 drivers/gpu/drm/radeon/radeon_legacy_tv.c
 delete mode 100644 drivers/gpu/drm/radeon/radeon_microcode.h
 delete mode 100644 drivers/gpu/drm/radeon/radeon_share.h
 create mode 100644 drivers/gpu/drm/radeon/reg_srcs/r100
 create mode 100644 drivers/gpu/drm/radeon/reg_srcs/r200
 create mode 100644 drivers/gpu/drm/radeon/reg_srcs/r300
 create mode 100644 drivers/gpu/drm/radeon/reg_srcs/rn50
 create mode 100644 drivers/gpu/drm/radeon/reg_srcs/rs600
 create mode 100644 drivers/gpu/drm/radeon/reg_srcs/rv515
 delete mode 100644 drivers/gpu/drm/radeon/rs780.c
 rename drivers/gpu/drm/radeon/{rv515r.h => rv515d.h} (78%)
 create mode 100644 drivers/gpu/drm/radeon/rv770d.h
 create mode 100644 firmware/matrox/g200_warp.H16
 create mode 100644 firmware/matrox/g400_warp.H16
 create mode 100644 firmware/r128/r128_cce.bin.ihex
 create mode 100644 firmware/radeon/R100_cp.bin.ihex
 create mode 100644 firmware/radeon/R200_cp.bin.ihex
 create mode 100644 firmware/radeon/R300_cp.bin.ihex
 create mode 100644 firmware/radeon/R420_cp.bin.ihex
 create mode 100644 firmware/radeon/R520_cp.bin.ihex
 create mode 100644 firmware/radeon/R600_me.bin.ihex
 create mode 100644 firmware/radeon/R600_pfp.bin.ihex
 create mode 100644 firmware/radeon/RS600_cp.bin.ihex
 create mode 100644 firmware/radeon/RS690_cp.bin.ihex
 create mode 100644 firmware/radeon/RS780_me.bin.ihex
 create mode 100644 firmware/radeon/RS780_pfp.bin.ihex
 create mode 100644 firmware/radeon/RV610_me.bin.ihex
 create mode 100644 firmware/radeon/RV610_pfp.bin.ihex
 create mode 100644 firmware/radeon/RV620_me.bin.ihex
 create mode 100644 firmware/radeon/RV620_pfp.bin.ihex
 create mode 100644 firmware/radeon/RV630_me.bin.ihex
 create mode 100644 firmware/radeon/RV630_pfp.bin.ihex
 create mode 100644 firmware/radeon/RV635_me.bin.ihex
 create mode 100644 firmware/radeon/RV635_pfp.bin.ihex
 create mode 100644 firmware/radeon/RV670_me.bin.ihex
 create mode 100644 firmware/radeon/RV670_pfp.bin.ihex
 create mode 100644 firmware/radeon/RV710_me.bin.ihex
 create mode 100644 firmware/radeon/RV710_pfp.bin.ihex
 create mode 100644 firmware/radeon/RV730_me.bin.ihex
 create mode 100644 firmware/radeon/RV730_pfp.bin.ihex
 create mode 100644 firmware/radeon/RV770_me.bin.ihex
 create mode 100644 firmware/radeon/RV770_pfp.bin.ihex
 create mode 100644 include/drm/drm_cache.h
 create mode 100644 include/drm/drm_encoder_slave.h
 create mode 100644 include/drm/drm_fb_helper.h
 create mode 100644 include/drm/drm_sysfs.h

commit 28d520433b6375740990ab99d69b0d0067fd656b
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Sep 21 14:33:58 2009 +1000

    drm/vgaarb: add VGA arbitration support to the drm and kms.
    
    VGA arb requires DRM support for non-kms drivers, to turn on/off
    irqs when disabling the mem/io regions.
    
    VGA arb requires KMS support for GPUs where we can turn off VGA
    decoding. Currently we know how to do this for intel and radeon
    kms drivers, which allows them to be removed from the arbiter.
    
    This patch comes from Fedora rawhide kernel.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit aadd4e17452d3d5c2269cd2b000b7de7cfb6c79e
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Sep 21 14:48:45 2009 +1000

    drm/radeon: some r420s have a CP race with the DMA engine.
    
    This patch makes sure the CP doesn't DMA do VRAM while 2D
    is active by inserting a CP resync token.
    
    todo: port to kms.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5a6e9f9658c853fea8ebbf64cd36287f00a011a2
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Sep 18 11:30:30 2009 -0400

    drm/radeon/r600/kms: rv670 is not DCE3
    
    RV670 was using the wrong modesetting code.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 18a4cd2e9147dd41234dade56edb62c6222832eb
Author: Dave Airlie <airlied@linux.ie>
Date:   Mon Sep 21 14:15:10 2009 +1000

    drm/radeon/kms: r420 idle after programming GA_ENHANCE
    
    https://bugs.freedesktop.org/show_bug.cgi?id=24041
    
    The idle allows rs690 to startup properly.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fe62e1a45d8b11cf653cba79e244fc07bb9a84b0
Author: Dave Airlie <airlied@linux.ie>
Date:   Mon Sep 21 14:06:30 2009 +1000

    drm/radeon/kms: more fixes to rv770 suspend/resume path.
    
    This resumes my
    RV730PRO (4650)
    RV770 (4850)
    fine.
    
    Still researching the RV4550 (RV710), resumes without X fine.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4153e584ee02ee59388a89879795fd3653a6b6da
Author: Dave Airlie <airlied@linux.ie>
Date:   Fri Sep 18 18:41:24 2009 +1000

    drm/radeon/kms: more alignment for rv770.c with r600.c
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9052aa2458fc13788e468a010fa0ed9aa4020380
Author: Dave Airlie <airlied@linux.ie>
Date:   Fri Sep 18 18:33:07 2009 +1000

    drm/radeon/kms: rv770 blit init called too late.
    
    re-align with r600 code, to init blit earlier.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fc30b8efbe1b271eb64e0d4f6cb2a91bb57ee5f3
Author: Dave Airlie <airlied@linux.ie>
Date:   Fri Sep 18 15:19:37 2009 +1000

    drm/radeon/kms: move around new init path code to avoid posting at init
    
    We really don't want to post the card at init, it takes a relatively
    long time and isn't required, so split the resume path into
    a startup path called by both init/resume and separate resume
    entry point to do posting.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit bc1a631e5104317cc8b4ef7d14adc597f2844003
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue Sep 15 11:07:52 2009 +1000

    drm/radeon/r600: fix some issues with suspend/resume.
    
    a) don't zero gart table on gart enable
    b) move pinning shader object into resume path
    c) unpin shader object on suspend
    d) set cp ready to false after cp shutdown on suspend.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 698443d9ec1a33eff65b27b9514e06998bf57eb3
Author: Dave Airlie <airlied@linux.ie>
Date:   Fri Sep 18 14:16:38 2009 +1000

    drm/radeon/kms: disable VGA rendering engine before taking over VRAM
    
    Before we use any of VRAM, we need to disable the VGA rendering
    engine, this render text mode into a graphical framebuffer
    for scanout, however it does this on vblank, and can end up
    overwriting the GART table and r600 shader objects.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5e6dde7ec2e72f49ff749204efc03a59478d7d34
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Thu Sep 17 09:42:28 2009 +0200

    drm/radeon/kms: Move radeon_get_clock_info() call out of radeon_clocks_init().
    
    Someone on IRC reported problems after commit
    95a8f1bf4f48b434c9f839ab5a0773f66b39d7c6 ('drm/radeon/kms: Move
    radeon_clocks_init() call back after getting VRAM info.'). And indeed, at least
    some ASIC vram_info hooks use the clock info obtained by
    radeon_get_clock_info(). So, move that call out of radeon_clocks_init(), ahead
    of the radeon_vram_info() call.
    
    [airlied - fixup missing r600/rv770 calls]
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
    
    drm/radeon/kms: fix get clock info calls for r600/rv770 init path.
    
    These were missed when it got split out.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 445282db9e815e7f5e82761c3c971dc9ea988d85
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Sep 9 17:40:54 2009 +1000

    drm/radeon/kms: add initial connector properties
    
    This adds:
    coherent mode: TMDS coherent mode for atom cards.
    scaling mode: LVDS scaler mode
    load detect: DAC load detection, DVI-I, VGA, TV
    tmds pll: legacy TMDS pll selection
    tv standard: TV standard selection.
    
    for later: other TV ones? dvi subconnector selection using std prop
    
    [contains fixes pointed out on dri-devel for atom bios mixups
     by Michel]
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c88f9f0c91de55efaece6d9bd9ec920b90244776
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Tue Sep 15 17:09:30 2009 +0200

    drm/radeon/kms: Use surfaces for scanout / cursor byte swapping on big endian.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 733289c2656c556d5cf36eafa1c8ec77222c359f
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Sep 16 15:24:21 2009 +0200

    drm/radeon/kms: don't fail if we fail to init GPU acceleration
    
    Userspace can query if acceleration is working or not true get
    info ioctl and could fallback to software if for some reason
    kernel failed to initialize KMS. This should allow to give a
    working KMS setup in all case (even with non functionning accel).
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7cbb355e947b3b426cefd9a3dc0dda3af9f9345a
Author: Dave Airlie <airlied@linux.ie>
Date:   Thu Sep 17 16:11:31 2009 +1000

    drm/r600/kms: fixup number of loops per blit calculation.
    
    Some people were seeing
    *ERROR* radeon: writting more dword to ring than expected
    after certain blits, the loops calculation didn't take
    into account that we do a separate blit for the remainder
    after doing the aligned blits.
    
    Acked-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 41456df2d45299c2eea5aaabafbaa2430ab9a124
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Sep 16 10:15:21 2009 +1000

    drm/radeon/kms: reprogram format in set base.
    
    This should in theory fix the problem with a mode set being required
    for adjusting the color depth.
    
    This also adds in the necessary bits to the format tables for
    8-bit, though it doesn't work yet.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 65cb15a686cedab52abc336d7a400fe3a110ac4c
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Sep 18 14:31:48 2009 +1000

    drm/radeon: avivo chips have no separate int bit for display
    
    display interrupts are not enabled via this register, the
    DISPLAY_INT bit is a status only to show that other regs
    need to be read.
    
    Noticed by Alex Deucher
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b15591f3120309093fc6d3df26b4242187d7b384
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Sep 17 14:25:12 2009 -0400

    drm/radeon/r600: don't do interrupts
    
    Interrupts are not supported yet.  This prevents
    things like mesa from trying to use them.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 812c369dbf3b5a726b52bbfb8adbc230f3f81bcf
Author: Pekka Paalanen <pq@iki.fi>
Date:   Thu Sep 17 22:59:54 2009 +0300

    drm: fix _DRM_GEM addmap error message
    
    Fix the error message: this is add, not rm.
    Move the closing brace to proper spot: _DRM_GEM branch should not be
    included in the block.
    
    Signed-off-by: Pekka Paalanen <pq@iki.fi>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9b1596af17dc9bf38c304f69fb253d6cfa73d136
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Fri Sep 18 10:43:52 2009 +1000

    drm: update crtc x/y when only fb changes
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e87b2c42b397ae64ac13a390011931f7ef222321
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Sep 17 18:14:41 2009 -0700

    drm: fix drm_fb_helper handling of kernel crtcs
    
    The drm_fb_helper shouldn't mess with CRTCs that aren't enabled or in
    its initial config. Ideally it shouldn't even include CRTCs in its
    initial config if they're not in use, but my old fix for that no longer
    works.  At any rate, this fixes a real bug I was seeing where after a
    console blank, both pipes would come back on, even though only one had
    been enabled before that.  Since the other pipe had a bogus config,
    this led to some screen corruption.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8dfaa8a7779ad2667d539aca6ae11cd87f562db6
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Tue Sep 15 17:09:27 2009 +0200

    drm/radeon/kms: Get LVDS native mode details from EDID if necessary.
    
    Fixes RMX problems on older Apple laptops which don't have an x86 BIOS ROM.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit f657c2a7310ad56e2b67f35f4c5c6106a7146b9c
Author: Yang Zhao <yang@yangman.ca>
Date:   Tue Sep 15 12:21:01 2009 +1000

    drm/radeon: Save and restore bios scratch regs during S/R
    
    [airlied:- adapted slightly in naming]
    
    Signed-off-by: Yang Zhao <yang@yangman.ca>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ecb114a128d150422d22eda238cb812f6b20bf39
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue Sep 15 11:12:56 2009 +1000

    drm/radeon/kms: IB locking dumps out a lockdep ordering issue
    
    We sometimes lock IB then the ring and sometimes the ring then
    the IB. This is mostly due to the IB locking not being well defined
    about what data in the structs it actually locks. Define what I
    believe is the correct behaviour and gets rid of the lock dep ordering
    warning.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 42dea5ddb56fe10e1d9a7840ddcb1df97a208a99
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue Sep 15 20:21:11 2009 +1000

    drm/radeon/kms: we should return 0 when we have no modes not -1.
    
    This fixes my monitor with broken EDID so it at least get 800x600.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 48e113e516a94ac9622a8326c4de670beb3366e6
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Tue Sep 15 17:09:32 2009 +0200

    drm/radeon/kms: Free CS parser state tracking memory.
    
    Fixes leak hidden in commit 9f022ddfb23793b475ff7e57ac08a766dd5d31bd
    ('drm/radeon/kms: convert r4xx to new init path').
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit fdd5cace733370ab7a518a98ef084e02aa76fdea
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Tue Sep 15 17:09:33 2009 +0200

    drm/radeon/kms: Don't kzalloc memory which is immediately overwritten.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 95a8f1bf4f48b434c9f839ab5a0773f66b39d7c6
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Tue Sep 15 17:09:26 2009 +0200

    drm/radeon/kms: Move radeon_clocks_init() call back after getting VRAM info.
    
    It may indirectly call radeon_set_clock_gating() which relies on the VRAM info.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit fb1fbf8e098cd4cd2c1dece3dc8f15e7de82170a
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Tue Sep 15 17:09:28 2009 +0200

    drm/radeon/kms: Only add common modes which fit in both panel dimensions.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 70ba2a374704e00df8868a7ac3d7350329d28924
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Sep 15 09:03:43 2009 +1000

    drm/radeon/kms: add 32/64 ioctl support.
    
    Although the new radeon driver ioctls don't need this, some of
    the drm initialisation ioctls require it, so add this to make them
    work.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4aac047323e3082d0866b8ad3784236632105af4
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Mon Sep 14 18:29:49 2009 +0200

    drm/radeon/kms: clear confusion in GART init/deinit path
    
    GART static one time initialization was mixed up with GART
    enabling/disabling which could happen several time for instance
    during suspend/resume cycles. This patch splits all GART
    handling into 4 differents function. gart_init is for one
    time initialization, gart_deinit is called upon module unload
    to free resources allocated by gart_init, gart_enable enable
    the GART and is intented to be call after first initialization
    and at each resume cycle or reset cycle. Finaly gart_disable
    stop the GART and is intended to be call at suspend time or
    when unloading the module.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 21f9a437222e92adb3abc68584a5f04801b92739
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Fri Sep 11 15:55:33 2009 +0200

    drm/radeon/kms: cleanup - remove radeon_share.h
    
    radeon_share.h was begining to give problem with include order in
    respect of radeon.h. It's easier and also i think cleaner to move
    what was in radeon_share.h into radeon.h. At the same time use the
    extern keyword for function shared accross the module.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a4d68279b44522a2b2374a6bd4861756bfad40fe
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Fri Sep 11 13:00:43 2009 +0200

    drm/radeon/kms: move mtrr range add and memory information
    
    Move mtrr range and memory information printing to radeon_object_init,
    this are memory information and initialization common to all GPU and
    they better fit in this function. Will also prevent code duplication
    with upcoming init path changes.
    
    airlied: fixed warning introduced
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9f022ddfb23793b475ff7e57ac08a766dd5d31bd
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Fri Sep 11 15:35:22 2009 +0200

    drm/radeon/kms: convert r4xx to new init path
    
    This convert r4xx to new init path it also fix few bugs.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d42571efe33552cd519b7f3800a788b5f2d51798
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Sep 11 15:27:14 2009 -0400

    drm/radeon/kms: fix typo in quirks
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 1be340563cf40210487afe332c0d7c9a523dba5f
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Sep 11 12:02:03 2009 -0400

    drm/radeon/kms/r600: fix blit dword count for non r6xx
    
    rv6xx emits two extra dwords in the render target setup.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 7747b713049e63aa64bcac679535ddfff92b312d
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Sep 11 11:15:43 2009 -0400

    drm/radeon/kms: add common lvds modes in the ddc case
    
    previous patch only handled the non-ddc case.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 2f9a60d76692ffbc749d97ac55717f70eb1f9432
Author: Dave Airlie <airlied@linux.ie>
Date:   Fri Sep 11 18:35:38 2009 +1000

    drm/radeon/kms: set fbdev_info for suspend/resume
    
    this hopefully will bring back suspend/resume under kms.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6cf8a3f58806f12b975a89cfd7edf01566ff80a0
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Sep 10 21:46:48 2009 +0200

    drm/radeon/kms: move modeset init outside of GPU init
    
    We are splitting GPU & modeset init so that it's easier
    to abord only remaining GPU init when somethings fails.
    We want to always provide enough funcionalities to get
    fbcon and a shadowfb X working. Only acceptable error
    during initialization are memory allocation failure or
    io mapping failure.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 923f6848e1686059ef8d272d1fca4d3577911a41
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Sep 10 17:53:39 2009 -0400

    drm/radeon/kms: add common scaled modes for TV and LVDS
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 705af9c7a8bcb9c8752a73be9ca356acb5c7688c
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Sep 10 16:31:13 2009 -0400

    drm/radeon/kms: pull in latest quirks and fixes from ddx
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a381287759b2b65e7de9fb35801c781cab016f10
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Sep 10 15:54:35 2009 -0400

    drm/radeon/kms/r600: use blit for BO moves
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c000273ebc830c27b8c9e03d5f4c147d3e310f48
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Sep 10 13:47:09 2009 +0200

    drm/radeon/kms: R3XX/R4XX AGP asic use PCI GART not PCIE GART
    
    R3XX/R4XX AGP asic use the old PCI GART block, not the new PCIE GART.
    Make sure we pick the right GART when disabling AGP.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Acked-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 119e20dc149581db3064661b2e659f308f97b663
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Sep 10 02:53:50 2009 -0400

    drm/radeon/kms/r600: fix blit support
    
    select the correct max number of bytes per blit based
    on whether the size is multiple of 4 bytes.  This
    determines whether we can use 8 or 32 bit pixels for
    the blit.
    
    airlied: also merged the IB padding patch +
    correcting the VS offset for context
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a513c184d99fe10e7b20771ef86f5f807769318f
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Sep 9 22:23:07 2009 +0200

    drm/radeon/kms: Don't try to process irq when we are unloading
    
    If module is being unloaded we should not try to handle irq especialy
    we should not call into drm helper or we could hard hang the computer
    free_irq will call the irq handler to make sure we behave properly.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 905b68223be18937159a29b354e6a332952ff952
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Sep 9 22:24:20 2009 +0200

    drm/radeon/kms: add R4XX mc register access helper.
    
    Atombios will use the mc register access helper and R4XX hw have a
    bigger mc range than R3XX so add R4XX specific mc register access
    helper.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a18d7ea15356679f58c2fafe2957786c5f7f9201
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Sep 9 22:23:27 2009 +0200

    drm/radeon/kms: call r100_cp_disable rather than duplicating code.
    
    r100_cp_fini was duplicating code of r100_cp_disable, call r100_cp_disable
    instead.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 45600232b3dbb97817c9e15de848c742901893e1
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Sep 9 22:23:45 2009 +0200

    drm/radeon/kms: wait for cp idle before stopping it.
    
    If we stop CP and that it's still processing thing GPU hang might
    happen, this patch wait for CP idle (the wait can timeout) so we
    can avoid shutting down CP at bad time. This is especialy usefull
    when reseting the GPU as it seems GPU reset fails to properly reset
    CP when the CP wasn't stop after being idle.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5d93b135fc051be3740cbe55729fc7b86a7069d7
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Wed Sep 9 16:09:36 2009 -0400

    drm/radeon/r600: fix legacy blit code
    
    ARRAY_SIZE is number of elements not bytes.  Fix
    ring counts accordingly, also make a few functions
    static.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit cecc6b63a5de547a345c491bb4c18c01a15984a4
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Sep 8 14:45:05 2009 -0400

    drm/radeon/r600: use fence->timeout directly
    
    Fixes fence timeouts on r6xx/r7xx.  Noticed by
    taiu on IRC.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>

commit 60d15f551abdbc5fef70d85f55aac1e85950bf59
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Sep 8 14:22:45 2009 -0400

    drm/radeon/kms: re-apply 2007d633d639c896396e4c4b53b38068f3831307
    
    Got accidently reverted by c93bb85b5cba3e3a06f2cad8e9bc5c23d3d10aac
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit cc84ef3fd20ef6dfe5fbc4778e7017d015b3bf7d
Merge: c746e20... 3ff323f...
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Sep 8 14:49:32 2009 +1000

    Merge remote branch 'origin/master' of ../linux-2.6 into drm-next
    
    This was a non-trivial merge with some patches sent to Linus
    in drm-fixes.
    
    Conflicts:
    	drivers/gpu/drm/radeon/r300.c
    	drivers/gpu/drm/radeon/radeon_asic.h
    	drivers/gpu/drm/radeon/rs600.c
    	drivers/gpu/drm/radeon/rs690.c
    	drivers/gpu/drm/radeon/rv515.c

commit c746e205f2fb6f74b4a622382607f065eca5eb49
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue Sep 8 14:38:45 2009 +1000

    drm/radeon/kms: don't allow ERESTART to hit userspace.
    
    the pre-r600 fence code returns ebusy if we get hit by a signal
    so we should continue to do that.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 620f37811dcc9e0f97ee79fbf8908fcc097deaee
Author: Adam Jackson <ajax@redhat.com>
Date:   Tue Sep 8 11:51:46 2009 +1000

    drm: prune modes when output is disconnected.
    
    When an output was disconnected, its mode list would remain.  If you later
    plugged into a sink with no EDID (projector, etc), you'd inherit the mode
    list from the old sink, which is not what you want.
    
    taken from Fedora kernel
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 1ecff1eb0b83efa85be5b54c958e831e37f993f3
Author: Adam Jackson <ajax@redhat.com>
Date:   Tue Sep 8 11:48:40 2009 +1000

    drm: shut the EDID warnings up.
    
    These really aren't all that useful.
    
    taken from Fedora kernel.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ec2a4c3fdc8e82fe82a25d800e85c1ea06b74372
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Aug 4 11:43:41 2009 +1000

    drm/i915: get the bridge device once.
    
    The driver gets the bridge device in a number of places, upcoming
    vga arb code paths need the bridge device, however they need it in
    under a lock, and the pci lookup can allocate memory. So clean
    this code up before then and get the bridge once for the driver lifetime.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f1938cd6e900a85de64184e46d841efc9efd3484
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Sep 8 11:32:08 2009 +1000

    drm: include seq_file.h for debugfs builds.
    
    Fixes a warning seen on powerpc.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f641e51e7469cc3a8115a3bd70b4526d566b1c60
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Sep 8 11:17:38 2009 +1000

    drm/radeon/kms: lower debugging on dpms events.
    
    Lower the debugging on encoders when getting DPMS events.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a0cdc6495bdd0ea12390b9edaf13c8cb653df109
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Sep 8 11:09:50 2009 +1000

    drm/kms/radeon: make kms default a runtime option
    
    This makes the kms/enable disable a runtime not a build time
    option.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6fcefd56f5060ca99ab03c9f2ad1f17c3a543ca1
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Sep 8 11:08:32 2009 +1000

    drm/kms: fix kms helper license + Kconfig
    
    Allow the KMS module to work properly, and also rename
    it to KMS_HELPER so its clearer what its for.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3ce0a23d2d253185df24e22e3d5f89800bb3dd1c
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Tue Sep 8 10:10:24 2009 +1000

    drm/radeon/kms: add r600 KMS support
    
    This adds the r600 KMS + CS support to the Linux kernel.
    
    The r600 TTM support is quite basic and still needs more
    work esp around using interrupts, but the polled fencing
    should work okay for now.
    
    Also currently TTM is using memcpy to do VRAM moves,
    the code is here to use a 3D blit to do this, but
    isn't fully debugged yet.
    
    Authors:
    Alex Deucher <alexdeucher@gmail.com>
    Dave Airlie <airlied@redhat.com>
    Jerome Glisse <jglisse@redhat.com>
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4ce001abafafe77e5dd943d1480fc9f87894e96f
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Aug 13 16:32:14 2009 +1000

    drm/radeon/kms: add initial radeon tv-out support.
    
    This ports the tv-out code from the DDX to KMS.
    
    adds a radeon.tv module option, radeon.tv=0 to disable tv
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 551ebd837c75fc75df81811a18b7136c39cab487
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Sep 1 15:25:57 2009 +1000

    drm/radeon/kms: add rn50/r100/r200 CS tracker.
    
    This adds the command stream checker for the RN50, R100 and R200 cards.
    
    It stops any access to 3D registers on RN50, and does checks
    on buffer sizes on the r100/r200 cards. It also fixes some texture
    sizing checks on r300.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 11670d3c93210793562748d83502ecbef4034765
Merge: 575dc34... 01dfba9...
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Sep 7 20:27:20 2009 +1000

    Merge intel drm-intel-next branch
    
    Merge remote branch 'anholt/drm-intel-next' of ../anholt-2.6 into drm-next
    
    Conflicts:
    	drivers/gpu/drm/i915/intel_display.c
    	drivers/gpu/drm/i915/intel_drv.h
    	drivers/gpu/drm/i915/intel_sdvo.c

commit 575dc34ee0de867ba83abf25998e0963bff451fa
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Sep 7 18:43:26 2009 +1000

    drm/kms: remove old std mode fallback code.
    
    The new code adds modes in the helper, which makes more sense
    I disliked the non-driver code adding modes.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 50fe4cfdc759fb3c0cffc3b90281efb139631fb7
Author: ykzhao <yakui.zhao@intel.com>
Date:   Thu Sep 3 14:30:04 2009 +0800

    drm/kms/i915: Add the default mode for CRT output without EDID
    
    Add the default mode for every output device when there
    is no mode for it.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f0fda0a47b26aba986fe65897891956c1792b526
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Thu Sep 3 09:33:48 2009 +0800

    drm/kms: add a function that can add the mode for the output device without EDID
    
    Add a function that can be used to add the default mode for the output device
    without EDID.
    It will add the default mode that meets with the requirements of given
    hdisplay/vdisplay limit.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 559ee21d261a54c42594ef9405d27e9008eedf44
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Thu Sep 3 09:33:47 2009 +0800

    drm/kms: try to find the std mode in DMT table
    
    When we need to add the standard timing mode, we will firstly check whether it
    can be found in DMT table by comparing the hdisplay/vdisplay/vfresh_rate.
    If it can't be found, then we will use the cvt/gtf to add the required mode.
    If it can be found, it will be returned.
    
    At the same time the function of drm_mode_vrefresh is also fixed. It will
    return the result of actual refresh_rate plus 0.5.
    For example:
    When the calculated value is 84.9, then the fresh_rate is 85.
    When the calculated value is 70.02, then the fresh_rate is 70.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit aa9eaa1f0962152d0bde821149d82fe7b70a6f92
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Thu Sep 3 09:33:46 2009 +0800

    drm/kms: Add the default mode table
    
    When we add a standard timing mode in UMS, we will first check whether it can
    be found in default mode table. If it can't be found, then we will use cvt/gtf
    to add the standard timing mode.
    Add the default mode table so that we can check whether the given mode
    can be found in the default mode table as what we have done in UMS mode.
    
    If the status of one output device is connected but there is no EDID, it will
    have no correct mode. In such case we can add some default modes for it. Of
    course we only add the modes in the default modes list that visible part is not
    greater than 1024x768.
    
    The default mode is autogenerated from the DMT spec. And it is copied from
    xserver/hw/xfree86/modes/xf86EdidModes.c. But the mode with reduced blank
    feature is removed.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 13a8195b148615b15a4f4385f695f2a232095414
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Sep 7 15:45:33 2009 +1000

    drm: split crtc/fb helpers into a separate module
    
    I really don't want to have core drm module rely on CONFIG_FB,
    so this is the easiest answer.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit adf551bb25bfb83b79ce3c3887557ed817e26cc9
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Sep 7 13:49:07 2009 +1000

    drm/radeon/kms: add updated registers from drm-fixes.
    
    Fixes up the DISCARD + 2 sided stencil in the new generator scripts.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a498b8210f2f6ee0529c28048b5c4cecc17937c2
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Sep 1 14:40:41 2009 +1000

    drm/radeon/kms: block depthxy offset from use from userspace.
    
    This could be used to bypass CS checks.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 01dfba93d9dfcf6d7abfc55ff5d9d6e76fa01ba0
Author: Eric Anholt <eric@anholt.net>
Date:   Sun Sep 6 15:18:53 2009 -0700

    drm/i915: Put the idle reclocking work on our private workqueue as well.
    
    Fixes (again) whole-system lockups due to GPU lockups.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 0ef82af7253c1929a3995f271b8b0db462d1a0c3
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Sat Sep 5 18:07:06 2009 +0100

    drm/i915: Pad ringbuffer with NOOPs before wrapping
    
    According to the docs, the ringbuffer is not allowed to wrap in the middle
    of an instruction.
    
    G45 PRM, Vol 1b, p101:
      While the “free space” wrap may allow commands to be wrapped around the
      end of the Ring Buffer, the wrap should only occur between commands.
      Padding (with NOP) may be required to follow this restriction.
    
    Do as commanded.
    
    [Having seen bug reports where there is evidence of split commands, but
    apparently the GPU has continued on merrily before a bizarre and untimely
    death, this may or may not fix a few random hangs.]
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    CC: Eric Anholt <eric@anholt.net>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 5e17ee74b541b56b5d4cfab6502a5116f224e32c
Author: Zhenyu Wang <zhenyuw@linux.intel.com>
Date:   Thu Sep 3 09:30:06 2009 +0800

    drm/i915: do dynamic clock freq control only in kernel modesetting
    
    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 57cdaf90f5f607eb029356074fefb66c9b1c0659
Author: Keith Packard <keithp@keithp.com>
Date:   Fri Sep 4 13:07:54 2009 +0800

    drm/I915: Use the CRT DDC to get the EDID for DVI-connector on Mac
    
    mac Mini's have a single DDC line on the DVI connector, shared between the
    analog link and the digital link. So, if DDC isn't detected on GPIOE (the
    usual SDVO DDC link), try GPIOA (the usual VGA DDC link) when there isn't a
    VGA monitor connected.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 553bd149bb2de7848b2b84642876f27202421368
Author: Zhenyu Wang <zhenyuw@linux.intel.com>
Date:   Wed Sep 2 10:57:52 2009 +0800

    drm/i915: fix tiling on IGDNG
    
    It seems that on IGDNG the same swizzling setup always applys.
    And front buffer tiling needs to set address swizzle in display
    arb control too.
    
    Fix plane tricle feed setting in v1 which should be disable bit,
    and always setup address swizzle to let hardware care for buffer
    tiling in all cases.
    
    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 65655d4ab72456c4c3e503fead55fabf8211a79d
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Aug 11 16:05:31 2009 +0200

    drm/i915: modeset: always set intel_crtc->dpms_mode by moving the assignment up.
    
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit c05422d52ee6b4cff8b63eab1a7351780518fc5e
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Aug 11 16:05:30 2009 +0200

    drm/i915: remove open-coded drm_mode_object_find
    
    And clean up a small whitespace goof-up in the same function, while
    I was looking at it.
    
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 67cf781bea52d461b7c8b63b23be19e87c33d7bf
Author: Eric Anholt <eric@anholt.net>
Date:   Mon Aug 31 08:52:02 2009 -0700

    drm/i915: Make the downclocking debug code be under DRM_DEBUG not DRM_ERROR.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

commit d6073d775c4b26107351cb8d5e21cec4391f6314
Author: Kyle McMartin <kyle@redhat.com>
Date:   Tue May 26 12:27:34 2009 -0400

    drm/i915: i915_modeset is signed
    
    Signed-off-by: Kyle McMartin <kyle@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 652c393a3368af84359da37c45afc35a91144960
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Aug 17 13:31:43 2009 -0700

    drm/i915: add dynamic clock frequency control
    
    There are several sources of unnecessary power consumption on Intel
    graphics systems. The first is the LVDS clock. TFTs don't suffer from
    persistence issues like CRTs, and so we can reduce the LVDS refresh rate
    when the screen is idle. It will be automatically upclocked when
    userspace triggers graphical activity. Beyond that, we can enable memory
    self refresh. This allows the memory to go into a lower power state when
    the graphics are idle. Finally, we can drop some clocks on the gpu
    itself. All of these things can be reenabled between frames when GPU
    activity is triggered, and so there should be no user visible graphical
    changes.
    
    Signed-off-by: Jesse Barnes <jesse.barnes@intel.com>
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 043029655816ed4cfc2ed247020ef97e5d637392
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Mon Aug 24 10:25:23 2009 +0800

    drm/i915: Support IGD EOS
    
    In the event that any one of the DAC analog outputs (R,G,B) were driven
    at full-scale (white video) or some analog level close to full-scale
    voltage, and if the video cable were then disconnected, the analog video
    voltage level would exceed the maximum electrical overstress limit of the
    native (thin-oxide) transistors thus causing a long-term reliability concern.
    The electrical overstress condition occurs in this particular case.
    
    This patch address the IGD EOS (electrical overstress condition) issue.
    When the EOS interrupt occurs, OS should disable DAC and then disable EOS,
    then the normal hotplug operation follows.
    
    TODO: it appears the normal unplug interrupt is missed as reported by Li Peng,
    need more checks here.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit ce6feabd1b38f9adf4a962d71bc4762047e8f889
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Aug 24 13:50:26 2009 +0800

    drm/i915: Enable PAL and SECAM format and add the propery for SDVO-TV
    
    Currently SDVO TV only support NTSC-M format. In this patch
    we introduce PAL and SECAM formats available and create seting-format
    property at init time. When user dynamically chose preferred
    format by xrandr command, it will refine all modelines
    provided by SDVO device, then instruct SDVO device to execute.
    At the same time the property is added for SDVO-TV so that the SDVO-TV mode can be changed
    by using xrandr.
    
    https://bugs.freedesktop.org/show_bug.cgi?id=22891
    
    Signed-off-by: Ma Ling <ling.ma@intel.com>
    review-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 213c2e643145fc7d8a67f2d5d54ee0f6d7193e2e
Author: Ma Ling <ling.ma@intel.com>
Date:   Mon Aug 24 13:50:25 2009 +0800

    drm/i915: select TV format according to connector type
    
    For integrated TV there are 3 connector types: S-VIDEO, Composite and
    Component(YprPb). Those tv formats whose component flag is true should
    be assigned to Component connector, others are for S-VIDEO and Composite.
    The patch intends to find appropriate tv format for each connector.
    In such case it will return the correct modeline to user space. Otherwise
    it will return the incorrect modeline when S-video/composite is connected.
    
    Signed-off-by: Ma Ling <ling.ma@intel.com>
    reviewed-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 5f6a169598938d9e5703f06b64c4f4f972561ce5
Author: Zhenyu Wang <zhenyuw@linux.intel.com>
Date:   Mon Aug 10 21:37:24 2009 +0800

    drm/i915: update debugfs interrupt info on IGDNG
    
    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 9e3a6d155ed0a7636b926a798dd7221ea107b274
Author: Ben Gamari <bgamari.foss@gmail.com>
Date:   Wed Jul 1 22:26:53 2009 -0400

    drm/i915: Add i915 register dumping debugfs file
    
    Add a debugfs file to dump the entire register range. Here we
    assume that reading write-only/reserved registers won't make the chip
    angry. Seems to hold true, thankfully.
    
    Signed-off-by: Ben Gamari <bgamari.foss@gmail.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 27c202ad7f141d4efa9c64e30bf4a4d3bcd799ae
Author: Ben Gamari <bgamari.foss@gmail.com>
Date:   Wed Jul 1 22:26:52 2009 -0400

    drm/i915: Move i915_gem_debugfs.c to i915_debugfs.c
    
    Signed-off-by: Ben Gamari <bgamari.foss@gmail.com>
    [anholt: hand-applied for conflicts]
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit ff6fdbed8f465f796da7ab32cde67e2dfb9e1f8f
Author: Maarten Maathuis <madman2003@gmail.com>
Date:   Tue Sep 1 03:39:04 2009 +0200

    drm/crtc_helper: avoid NULL-pointer dereference when encoder is NULL
    
    Signed-off-by: Maarten Maathuis <madman2003@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 9c552dd79346f86a3b53e41255c92c6f560b80fb
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Sep 2 14:00:11 2009 +1000

    drm/crtc: fix mismerge of last patch.
    
    We only want to NULL encoder->crtc when it is off.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a3a0544b2c84e1d7a2022b558ecf66d8c6a8dd93
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Aug 31 15:16:30 2009 +1000

    drm/kms: add explicit encoder disable function and detach harder.
    
    For shared tv-out and VGA encoders, we really need to know if
    the encoder is just being switched off temporarily in blanking
    or if we are really disabling it hard.
    
    Also we need to try harder to disconnect encoders from unused
    connectors so we can share more efficently.
    
    (shared encoders stuff is coming in radeon tv-out support)
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ed017d9fb17af3162f5acf922eb5731c541e1f3a
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Sep 2 09:41:13 2009 +1000

    drm: fix drm_cache.c for arch with no support.
    
    This produces a warn on for architectures where this gets called
    but we don't have a cache flushing implementation suitable.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fa8a123855e20068204982596b8fafceb1a67f0b
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Aug 26 13:13:37 2009 +1000

    drm/mm: add ability to dump mm lists via debugfs
    
    This adds code to the drm_mm to talk to debugfs, and adds
    support to radeon to add the VRAM and GTT mm lists to debugfs.
    
    I tested with spinlock debugging and it doesn't give out.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3420e74262a7d6496d0ac433d6f61c9972f015f6
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Aug 31 10:33:29 2009 +1000

    drm: fix two issues with fb consolidation.
    
    Set accel to none, we really don't want anyone thinking
    fb is an accel interface.
    Pass pitch not depth to function for intel.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3b51096f95633e6ab47675984e8e38fc37b09eeb
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Fri Aug 28 22:58:07 2009 +0400

    drm: use proc_create_data()
    
    airlied: fixup race against drm info by filling out
    tmp before adding it to proc.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 882f0219518196a94cd2772004e87b178467139a
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Aug 26 18:20:49 2009 +0800

    drm/kms: Parse the detailed time info in CEA-EDID
    
    Sometimes we can obtain the EDID with multiple blocks from the display device.
    For example: HDMI monitor.
    When the CEA-EDID block is detected, we should also parse the detailed timing
    info from it. Otherwise we will lose some modes for the display device.
    
    The first step is check whether the CEA EDID block is found. If it exists,
    it will skip the CEA-data block and parse the detailed timing info.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 785b93ef8c309730c2de84ce9c229e40e2d01480
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Aug 28 15:46:53 2009 +1000

    drm/kms: move driver specific fb common code to helper functions (v2)
    
    Initially I always meant this code to be shared, but things
    ran away from me before I got to it.
    
    This refactors the i915 and radeon kms fbdev interaction layers
    out into generic helpers + driver specific pieces.
    
    It moves all the panic/sysrq enhancements to the core file,
    and stores a linked list of kernel fbs. This could possibly be
    improved to only store the fb which has fbcon on it for panics
    etc.
    
    radeon retains some specific codes used for a big endian
    workaround.
    
    changes:
    fix oops in v1
    fix freeing path for crtc_info
    
    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7dc482dfeeeefcfd000d4271c4626937406756d7
Author: Ben Hutchings <ben@decadent.org.uk>
Date:   Sun Aug 23 16:59:04 2009 +0100

    drm/r128: Add test for initialisation to all ioctls that require it
    
    Almost all r128's private ioctls require that the CCE state has
    already been initialised.  However, most do not test that this has
    been done, and will proceed to dereference a null pointer.  This may
    result in a security vulnerability, since some ioctls are
    unprivileged.
    
    This adds a macro for the common initialisation test and changes all
    ioctl implementations that require prior initialisation to use that
    macro.
    
    Also, r128_do_init_cce() does not test that the CCE state has not
    been initialised already.  Repeated initialisation may lead to a crash
    or resource leak.  This adds that test.
    
    Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 70967ab9c0c9017645d167d33675eab996633631
Author: Ben Hutchings <ben@decadent.org.uk>
Date:   Sat Aug 29 14:53:51 2009 +0100

    radeon: Use request_firmware()
    
    Loosely based on a patch by
    Jaswinder Singh Rajput <jaswinderlinux@gmail.com>.
    
    KMS support by Dave Airlie <airlied@redhat.com>.
    
    For Radeon 100- to 500-series, firmware blobs look like:
        struct {
            __be32 datah;
            __be32 datal;
        } cp_ucode[256];
    
    For Radeon 600-series, there are two separate firmware blobs:
        __be32 me_ucode[PM4_UCODE_SIZE * 3];
        __be32 pfp_ucode[PFP_UCODE_SIZE];
    
    For Radeon 700-series, likewise:
        __be32 me_ucode[R700_PM4_UCODE_SIZE];
        __be32 pfp_ucode[R700_PFP_UCODE_SIZE];
    
    Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 1ae70072f0699916c1a77a9bacad958ee46f7395
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Sat Aug 29 22:20:34 2009 +0200

    drm: dereference of tmp in drm_proc_create_files()
    
    tmp allocation may fail, prevent a dereference.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ff846ab7f76ffecba4f0bef026163d2a2364d7d0
Author: Maarten Maathuis <madman2003@gmail.com>
Date:   Wed Aug 19 00:56:45 2009 +0200

    drm/crtc_helper: NULL encoder->crtc when switching encoders
    
    - Previously the old encoder would be called during modeset and without a connector bad things happened.
    
    Signed-off-by: Maarten Maathuis <madman2003@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f380ef86916904e4b79f7bec599deb51057b2d0c
Author: Maarten Maathuis <madman2003@gmail.com>
Date:   Wed Aug 19 00:56:44 2009 +0200

    drm/crtc_helper: place drm_helper_encoder_in_use() in the header file
    
    - The symbol was already exported.
    
    Signed-off-by: Maarten Maathuis <madman2003@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e67aae79f93d9584aaa24d2a2c76383e9d588f98
Author: Maarten Maathuis <madman2003@gmail.com>
Date:   Thu Aug 27 10:18:29 2009 +0200

    drm/crtc_helper: replace modeset fail path with something simpler
    
    - The previous system was not very transparent, nor flexible.
    - This is needed to be able to fix a few bugs in the mechanism.
    
    Signed-off-by: Maarten Maathuis <madman2003@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 689d7c2a1127378854c7d7ea8d7c81238a824240
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Aug 27 11:51:23 2009 +1000

    drm/radeon: cleanup mkregtable.c
    
    This cleans up the code in mkregtable.c to be more kernel style.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a1a2d1d32250f6fcc317419e9dfb4a5a6946d2e6
Author: Pekka Paalanen <pq@iki.fi>
Date:   Sun Aug 23 12:40:55 2009 +0300

    drm: GEM handles are u32, not int
    
    Several functions in the GEM kernel API used int as handle type, but
    user API has it __u32 which is also the intended type.
    
    Replace int with u32.
    
    Signed-off-by: Pekka Paalanen <pq@iki.fi>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3f7dc91adef90a20f806282724c40d68d5b020aa
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Aug 27 11:10:15 2009 +1000

    drm/rs600/690: use autogenerated safe register tables.
    
    This ports rs690 to the safe reg tables and makes rs600 also
    use the same table.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 52f97df5da1f94d2b7db1bb53a2f053ae162b649
Author: Ben Hutchings <ben@decadent.org.uk>
Date:   Sun Aug 23 18:37:26 2009 +0100

    drm/r128: Use request_firmware() to load CCE microcode
    
    Firmware blob looks like this:
        __be32 datah
        __be32 datal
    
    Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ece2be7993cc5e269cbf0cad6442b401a2c31915
Author: Ben Hutchings <ben@decadent.org.uk>
Date:   Sun Aug 23 18:34:25 2009 +0100

    drm/mga: Use request_firmware() to load microcode
    
    Image format is IHEX, one record for each pipe in order (record
    addresses are ignored).
    
    Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c9c97b8c75019814d8c007059bc827bb475be917
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Aug 27 09:53:47 2009 +1000

    drm/ttm: consolidate cache flushing code in one place.
    
    This merges the TTM and drm cache flushing into one file in the
    drm core.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 50f153036c9d9e4ae1768d5ca9c2ad4184f7a0b7
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Aug 21 13:21:01 2009 +1000

    drm/radeon/kms: generate the safe register tables.
    
    Previously we just made these offline and included them,
    but no reason we can't generate them at build time.
    
    TODO: add rs690 + r100/r200 when done.
    should we do rs480/rs690 no tcl version?
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 759e4f83f418f4001e724042b4c0e408d615d9ec
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Thu Aug 20 10:29:09 2009 +0200

    drm/ttm: Fixes for "Memory accounting rework."
    
    ttm:
    Fix error paths when kobject_add returns an error.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7f5f4db2d50ea1af8f160686d2e97bbfa5102b4f
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Thu Aug 20 10:29:08 2009 +0200

    drm/ttm: Fixes for "Make parts of a struct ttm_bo_device global"
    
    ttm:
    Remove a stray debug printout.
    Remove a re-init of the lru spinlock at device init.
    
    radeon:
    Fix the size of the bo_global allocation.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 51c8b4071d84d46cc100baa5931ad06b2a823c95
Merge: a987fca... 6c30c53...
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Aug 20 13:38:04 2009 +1000

    Merge Linus master to drm-next
    
    linux-next conflict reported needed resolution.
    
    Conflicts:
    	drivers/gpu/drm/drm_crtc.c
    	drivers/gpu/drm/drm_edid.c
    	drivers/gpu/drm/i915/intel_sdvo.c
    	drivers/gpu/drm/radeon/radeon_ttm.c
    	drivers/gpu/drm/ttm/ttm_bo.c

commit a987fcaa805fcb24ba885c2e29fd4fdb6816f08f
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Tue Aug 18 16:51:56 2009 +0200

    ttm: Make parts of a struct ttm_bo_device global.
    
    Common resources, like memory accounting and swap lists should be
    global and not per device. Introduce a struct ttm_bo_global to
    accomodate this, and register it with sysfs. Add a small sysfs interface
    to return the number of active buffer objects.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 5fd9cbad3a4ae82c83c55b9c621d156c326724ef
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Mon Aug 17 16:28:39 2009 +0200

    drm/ttm: Memory accounting rework.
    
    Use inclusive zones to simplify accounting and its sysfs representation.
    Use DMA32 accounting where applicable.
    
    Add a sysfs interface to make the heuristically determined limits
    readable and configurable.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit e9840be8c23601285a70520b4898818f28ce8c2b
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Tue Aug 18 10:27:57 2009 +0200

    drm/ttm: Add a virtual ttm sysfs device.
    
    The device directory will be the base directory of the
    sysfs representation of other ttm subsystems.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 327c225bd548bf7871f116a0baa5ebdac884e452
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Mon Aug 17 16:28:37 2009 +0200

    drm: Enable drm drivers to add drm sysfs devices.
    
    Export utility functions for drivers to add specialized devices in the
    sysfs drm class subdirectory.
    
    Initially this will be needed form TTM to add a virtual device that
    handles power management.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit a0724fcf829e5afb66159ef68cb16a805ea11b42
Author: Pekka Paalanen <pq@iki.fi>
Date:   Mon Aug 17 01:18:38 2009 +0300

    drm/ttm: optimize bo_kmap_type values
    
    A micro-optimization on the function ttm_kmap_obj_virtual().
    
    By defining the values of enum ttm_bo_kmap_obj::bo_kmap_type to have a
    bit indicating iomem, size of the function ttm_kmap_obj_virtual() will be
    reduced by 16 bytes on x86_64 (gcc 4.1.2).
    
    ttm_kmap_obj_virtual() may be heavily used, when buffer objects are
    accessed via wrappers, that work for both kinds of memory addresses:
    iomem cookies and kernel virtual.
    
    Signed-off-by: Pekka Paalanen <pq@iki.fi>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 949ef70e2d1a5c12178875f513df34fc85d91a38
Author: Pekka Paalanen <pq@iki.fi>
Date:   Mon Aug 17 19:49:19 2009 +0300

    drm/kms: no need to return void value (encoder)
    
    Cc: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Pekka Paalanen <pq@iki.fi>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 53bd83899f5ba6b0da8f5ef976129273854a72d4
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Wed Jul 1 10:04:40 2009 -0700

    drm: clarify scaling property names
    
    Now that we're using the scaling property in the Intel driver I noticed
    that the names were a bit confusing.  I've corrected them according to
    our discussion on IRC and the mailing list, though I've left out
    potential new additions for a new scaling property with an integer (or
    two) for the scaling factor.  None of the drivers implement that today,
    but if someone wants to do it, I think it could be done with the
    addition of a single new type and a new property to describe the
    scaling factor in the X and Y directions.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Acked-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 776f3360de6ed246e973577828f725681120fd7a
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Aug 19 15:56:37 2009 +1000

    drm: fixup includes in encoder slave header files.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 453a7d46dca88704ed88b364c445ff55680a8557
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Wed Aug 19 15:51:55 2009 +1000

    drm: remove root requirement from DRM_IOCTL_SET_VERSION (+ DRM_IOCTL_AUTH_MAGIC)
    
    Just a DRM_MASTER flag is sufficient here, though maybe this call is
    totally deprecated anyway (xf86-video-intel still calls it though).
    
    (airlied: drop ioctl auth_magic as discussed on mailing list also)
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit cfcf4738cd6b5d7bed1473acad76d6430cf1fb0a
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Aug 13 13:31:54 2009 +1000

    drm: fixup include file in drm_encoder_slave
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a75f0236292a5fca65f26efedca48bd07db1834d
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Wed Aug 12 02:30:10 2009 +0200

    drm: Add more standard TV properties.
    
    Overscan, saturation, hue. Used in the nouveau driver for GPUs with
    integrated TV encoders.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 841b4117b30d544690fceb952037b1cddf14783f
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Wed Aug 12 02:30:09 2009 +0200

    drm: Fix drm_cvt_mode() for interlaced modes.
    
    The calculated vdisplay was half the right value.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b6b7902e54c7e8abbc213d8bdc290350c00ccfe5
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Sun Aug 2 04:19:20 2009 +0200

    drm: Define some new standard TV properties.
    
    Namely "brightness", "contrast" and "flicker reduction".
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit aeaa1ad3ff32be833680e484d99ec29d892da1ff
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Sun Aug 2 04:19:19 2009 +0200

    drm: Define DRM_MODE_SUBCONNECTOR_SCART
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 74bd3c26b90f39b9dcc05c471333da8998572b5d
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Sun Aug 2 04:19:18 2009 +0200

    drm: Define DRM_MODE_CONNECTOR_TV
    
    The existing TV connector types are often unsuitable either because
    there is no way to probe them until they're actually plugged in or
    because they can change during run time (e.g. 7-pin DIN connectors
    that behave as S-Video, Component, Composite or SCART depending on the
    adaptor plugged in).
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 2066facca4c7dfe9f5068ece0200a4dbf10f49e1
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Sun Aug 2 04:19:17 2009 +0200

    drm/kms: slave encoder interface.
    
    Define some helper functions to make easier to detach a KMS encoder
    implementation from the drm module of the GPU it's used in. This is
    mainly useful for some external I2C encoders known to be present on
    cards with GPUs from several different manufacturers.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 58367ed65f30128d8b763bf4c1fb942da49ade15
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Jul 20 13:48:07 2009 +0800

    drm: Add the debug info in generic drm mode by using DRM_DEBUG_KMS
    
    Add the debug info in generic drm mode by using DRM_DEBUG_KMS
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 87fdff81cd2d770f0adc742e21eb5e062ad20def
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Jul 20 13:48:06 2009 +0800

    DRM: Add the explanation about DRM debug level
    
    Add the explanation about DRM debug level in the drmP header file. This is to
    explain how/where to use the different DRM debug level.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f940f37f022f7392ab81a35516222cbd46110b42
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Jul 20 13:48:05 2009 +0800

    drm: Remove the macro defintion of DRM_DEBUG_MODE
    
    Two macro definitions of DRM_DEBUG_KMS/MODE can be used to add the debug
    info related with KMS. It is confusing.
    So remove the macro definition of DRM_DEBUG_MODE. Instead it can be replaced
    by the DRM_DEBUG_KMS.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Acked-by: Ian Romanick <ian.d.romanick@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8a4c47f346cc7a12d0897c05eb3cc1add26b487f
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Jul 20 13:48:04 2009 +0800

    drm: Remove the unused prefix in DRM_DEBUG_KMS/DRIVER/MODE
    
    We will have to add a prefix when using the macro defintion of DRM_DEBUG_KMS
    /DRM_DEBUG_DRIVER/MODE. It is not convenient. We should use the DRM_NAME
    as default prefix.
    So remove the prefix in the macro definition of DRM_DEBUG_KMS/DRIVER/MODE.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Acked-by: Ian Romanick <ian.d.romanick@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5c61259e6c7290082108e93815f7f72f27da14f4
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Jun 22 13:17:10 2009 +0800

    drm/mode: get the modeline for standard timing in EDID by using CVT/GTF
    
    Create the standard timing modeline by using CVT/GFT algorithm while
    interpreting the EDID.
    
    In course of interpreting the EDID, the timing level will be obtained,
    which is used to determine whether the CVT/GTF algorithm is selected to
    generate the modeline for the given hdisplay/vdisplay/vrefresh_rate.
    In the UMS mode firstly it will check whether it can be found in
    the DMT table. If it can be found, then the modeline is returned. Then the
    timing_level is used to choose CVT/GTF.
    As there is no DMT table, no modeline is returned when timing level
    is DMT. For the other two timing levels, the CVT/GTF will be called to
    generate the required standard timing modeline.
    
    [airlied: fixed up conflicts since EDID rework]
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 26bbdadad356ec02d33657858d91675f3e9aca94
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Jun 22 13:17:09 2009 +0800

    drm/mode: add the GTF algorithm in kernel space
    
    Add the GTF algorithm in kernel space. And this function can be called to
    generate the required modeline.
    
    I copied it from the file of xserver/hw/xfree86/modes/xf86gtf.c. What I have
    done is to translate it by using integer calculation. This is to avoid
    the float-point calculation in kernel space.
    At the same tie I also refer to the function of fb_get_mode in
    drivers/video/fbmon.c
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit d782c3f95c9263dc0b98e7115f75f1e18b9600b3
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Mon Jun 22 13:17:08 2009 +0800

    drm/mode: add the CVT algorithm in kernel space
    
    Add the CVT algorithm in kernel space. And this function can be called to
    generate the required modeline.
    
    I copied it from the file of xserver/hw/xfree86/modes/xf86cvt.c. What I have
    done is to translate it by using integer calculation. This is to avoid
    the float-point calculation in kernel space.
    
    [airlied:- cleaned up some bits]
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>
--29444707-580670798-1253509974=:26881--
