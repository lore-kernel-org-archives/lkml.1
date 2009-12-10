Return-Path: <linux-kernel-owner+w=401wt.eu-S933171AbZLJGRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171AbZLJGRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 01:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933073AbZLJGRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 01:17:13 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39536 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933064AbZLJGRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 01:17:07 -0500
Date: Thu, 10 Dec 2009 06:17:08 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm
Message-ID: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-585066557-1260425828=:24701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-585066557-1260425828=:24701
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Highlights:
core: pageflipping ioctl, lots of EDID fixes from Fedora, fbdev helper 
fixes, move DisplayPort i2c helper from Intel to core, kms dirty region 
ioctl added.
AGP: fix to Intel AGP driver to clear GTT properly on startup
Intel: Ironlake support, Pineview support, Overlay support,

TTM: add support for vmwgfx driver which will go in staging, rework the 
validation APIs to allow better placement flexibility

Radeon KMS: Major bulk of changes, add DisplayPort support to KMS driver,
R600 IRQ support (requires out of tree firmware), IRQ mitigation support,
encoder cloninng support, external TMDS chip support, lots of 
suspend/resume fixes, new PLL algo for r500+ from AMD, digital output 
hotplug detection support (required for DisplayPort), radeon object 
handling rework to avoid numerous locking issues.

The biggest missing feature from the Radeon KMS driver before we can
probably mark it not-staging is some sort of power management support,
this is being worked on, but is a hairy problem, but lots of people
have cards that run hot or with full fan and it would be nice to do 
something about it. However we will probably remove the staging bit before
2.6.33 goes live.

Also VMware have submitted a driver to go into staging to drive their
virtual GPU, that we should probably merge via Greg before the windows 
closes.

Dave.

 drivers/char/agp/intel-agp.c                       |  103 +-
 drivers/gpu/drm/Makefile                           |    2 +-
 drivers/gpu/drm/drm_crtc.c                         |  176 +++-
 drivers/gpu/drm/drm_crtc_helper.c                  |    5 +-
 .../{i915/intel_dp_i2c.c => drm_dp_i2c_helper.c}   |   76 +-
 drivers/gpu/drm/drm_drv.c                          |   42 +-
 drivers/gpu/drm/drm_edid.c                         |  328 +++--
 drivers/gpu/drm/drm_fb_helper.c                    |   23 +-
 drivers/gpu/drm/drm_fops.c                         |  112 ++-
 drivers/gpu/drm/drm_irq.c                          |  130 ++-
 drivers/gpu/drm/drm_mm.c                           |  110 ++-
 drivers/gpu/drm/drm_modes.c                        |   28 +-
 drivers/gpu/drm/drm_stub.c                         |   15 +
 drivers/gpu/drm/i915/Makefile                      |    2 +-
 drivers/gpu/drm/i915/dvo_ch7017.c                  |    9 +-
 drivers/gpu/drm/i915/dvo_ch7xxx.c                  |   16 +-
 drivers/gpu/drm/i915/dvo_ivch.c                    |   37 +-
 drivers/gpu/drm/i915/dvo_sil164.c                  |   20 +-
 drivers/gpu/drm/i915/dvo_tfp410.c                  |   34 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |  120 ++-
 drivers/gpu/drm/i915/i915_dma.c                    |   40 +-
 drivers/gpu/drm/i915/i915_drv.c                    |    1 +
 drivers/gpu/drm/i915/i915_drv.h                    |   80 +-
 drivers/gpu/drm/i915/i915_gem.c                    |  114 ++-
 drivers/gpu/drm/i915/i915_gem_tiling.c             |    6 +-
 drivers/gpu/drm/i915/i915_irq.c                    |  163 ++-
 drivers/gpu/drm/i915/i915_opregion.c               |   92 ++-
 drivers/gpu/drm/i915/i915_reg.h                    |   71 +-
 drivers/gpu/drm/i915/i915_suspend.c                |   86 +-
 drivers/gpu/drm/i915/intel_bios.c                  |  137 ++-
 drivers/gpu/drm/i915/intel_bios.h                  |   17 +
 drivers/gpu/drm/i915/intel_crt.c                   |   50 +-
 drivers/gpu/drm/i915/intel_display.c               | 1036 ++++++++++-----
 drivers/gpu/drm/i915/intel_dp.c                    |  162 ++-
 drivers/gpu/drm/i915/intel_drv.h                   |   44 +
 drivers/gpu/drm/i915/intel_fb.c                    |    7 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |   55 +-
 drivers/gpu/drm/i915/intel_i2c.c                   |   21 +-
 drivers/gpu/drm/i915/intel_lvds.c                  |  140 ++-
 drivers/gpu/drm/i915/intel_overlay.c               | 1416 ++++++++++++++++++++
 drivers/gpu/drm/i915/intel_sdvo.c                  |   14 +-
 drivers/gpu/drm/i915/intel_tv.c                    |   58 +-
 drivers/gpu/drm/radeon/Makefile                    |    2 +-
 drivers/gpu/drm/radeon/atom.c                      |   33 +-
 drivers/gpu/drm/radeon/atom.h                      |    2 +
 drivers/gpu/drm/radeon/atombios.h                  |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |   59 +-
 drivers/gpu/drm/radeon/atombios_dp.c               |  790 +++++++++++
 drivers/gpu/drm/radeon/r100.c                      |  245 +++-
 drivers/gpu/drm/radeon/r100_track.h                |   10 +-
 drivers/gpu/drm/radeon/r300.c                      |   33 +-
 drivers/gpu/drm/radeon/r420.c                      |   25 +-
 drivers/gpu/drm/radeon/r500_reg.h                  |    2 +
 drivers/gpu/drm/radeon/r520.c                      |    8 +-
 drivers/gpu/drm/radeon/r600.c                      | 1147 +++++++++++++++-
 drivers/gpu/drm/radeon/r600_blit_kms.c             |   34 +-
 drivers/gpu/drm/radeon/r600d.h                     |  212 +++-
 drivers/gpu/drm/radeon/radeon.h                    |  165 ++-
 drivers/gpu/drm/radeon/radeon_asic.h               |   70 +
 drivers/gpu/drm/radeon/radeon_atombios.c           |  332 ++++--
 drivers/gpu/drm/radeon/radeon_benchmark.c          |   36 +-
 drivers/gpu/drm/radeon/radeon_clocks.c             |   23 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |  688 ++++++++--
 drivers/gpu/drm/radeon/radeon_connectors.c         |  194 +++-
 drivers/gpu/drm/radeon/radeon_cp.c                 |   45 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |   13 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   62 +-
 drivers/gpu/drm/radeon/radeon_display.c            |  145 ++-
 drivers/gpu/drm/radeon/radeon_drv.c                |    4 +
 drivers/gpu/drm/radeon/radeon_drv.h                |    1 -
 drivers/gpu/drm/radeon/radeon_encoders.c           |  276 +++--
 drivers/gpu/drm/radeon/radeon_fb.c                 |   72 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |   47 +-
 drivers/gpu/drm/radeon/radeon_fixed.h              |   17 +
 drivers/gpu/drm/radeon/radeon_gart.c               |   42 +-
 drivers/gpu/drm/radeon/radeon_gem.c                |  104 +-
 drivers/gpu/drm/radeon/radeon_i2c.c                |  182 ++-
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |   61 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |   42 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c        |  104 ++-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |  125 +-
 drivers/gpu/drm/radeon/radeon_mode.h               |  149 ++-
 drivers/gpu/drm/radeon/radeon_object.c             |  560 +++-----
 drivers/gpu/drm/radeon/radeon_object.h             |  157 ++-
 drivers/gpu/drm/radeon/radeon_pm.c                 |    6 +-
 drivers/gpu/drm/radeon/radeon_reg.h                |   60 +-
 drivers/gpu/drm/radeon/radeon_ring.c               |   67 +-
 drivers/gpu/drm/radeon/radeon_test.c               |   55 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |   94 +-
 drivers/gpu/drm/radeon/rs400.c                     |   17 +-
 drivers/gpu/drm/radeon/rs600.c                     |  236 +++-
 drivers/gpu/drm/radeon/rs600d.h                    |  112 ++-
 drivers/gpu/drm/radeon/rs690.c                     |   57 +-
 drivers/gpu/drm/radeon/rv515.c                     |   24 +-
 drivers/gpu/drm/radeon/rv770.c                     |   79 +-
 drivers/gpu/drm/ttm/Makefile                       |    3 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |  545 ++++----
 drivers/gpu/drm/ttm/ttm_bo_util.c                  |    1 +
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |    7 +-
 drivers/gpu/drm/ttm/ttm_execbuf_util.c             |  117 ++
 drivers/gpu/drm/ttm/ttm_lock.c                     |  311 +++++
 drivers/gpu/drm/ttm/ttm_memory.c                   |   16 +-
 drivers/gpu/drm/ttm/ttm_object.c                   |  452 +++++++
 drivers/gpu/drm/ttm/ttm_tt.c                       |    1 +
 include/drm/drm.h                                  |   65 +-
 include/drm/drmP.h                                 |   87 +-
 include/drm/drm_crtc.h                             |   47 +-
 .../i915/intel_dp.h => include/drm/drm_dp_helper.h |   74 +-
 include/drm/drm_edid.h                             |    8 +
 include/drm/drm_mm.h                               |   35 +
 include/drm/drm_mode.h                             |   80 ++-
 include/drm/drm_os_linux.h                         |    2 +-
 include/drm/i915_drm.h                             |   78 +-
 include/drm/mga_drm.h                              |    2 +-
 include/drm/radeon_drm.h                           |    2 +-
 include/drm/ttm/ttm_bo_api.h                       |   56 +-
 include/drm/ttm/ttm_bo_driver.h                    |   37 +-
 include/drm/ttm/ttm_execbuf_util.h                 |  107 ++
 include/drm/ttm/ttm_lock.h                         |  247 ++++
 include/drm/ttm/ttm_memory.h                       |    1 +
 include/drm/ttm/ttm_object.h                       |  267 ++++
 include/drm/via_drm.h                              |    2 +-
 122 files changed, 12028 insertions(+), 2947 deletions(-)
 rename drivers/gpu/drm/{i915/intel_dp_i2c.c => drm_dp_i2c_helper.c} (79%)
 create mode 100644 drivers/gpu/drm/i915/intel_overlay.c
 create mode 100644 drivers/gpu/drm/radeon/atombios_dp.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_execbuf_util.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_lock.c
 create mode 100644 drivers/gpu/drm/ttm/ttm_object.c
 rename drivers/gpu/drm/i915/intel_dp.h => include/drm/drm_dp_helper.h (70%)
 create mode 100644 include/drm/ttm/ttm_execbuf_util.h
 create mode 100644 include/drm/ttm/ttm_lock.h
 create mode 100644 include/drm/ttm/ttm_object.h

commit 4361e52ad0372e6fd2240a2207b49a4de1f45ca9
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Dec 10 15:59:32 2009 +1000

    drm/radeon/kms: fix warning about cur_placement being uninitialised.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 115a5c2ba0aac55e1bac390f271c818c3cbfa1fb
Merge: 0b5e8db fb53f86
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Dec 10 15:47:57 2009 +1000

    Merge remote branch 'korg/drm-radeon-next' of into drm-linus
    
    This merges some TTM overhauls to allow us to do better object placement
    for certain radeon GPUs that need scanout+cursor within range of each other,
    along with an API change to not return ERESTART to userspace, but to use
    ERESTARTSYS properly internally and have it convert to EINTR and catch that
    correctly. Also lots of radeon fixes across the board.

commit 0b5e8db639de032bd4febbb0a5b1cd2c19bac26d
Merge: 7b0a9e8 4f8d619
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Dec 10 15:44:11 2009 +1000

    Merge remote branch 'anholt/drm-intel-next' into drm-linus
    
    Pull more Intel changes in, especially one to init the GTT properly

commit fb53f8621a3fab88776ae2450a1f3afc7920231b
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Dec 9 21:55:10 2009 +0100

    drm/ttm: Print debug information on memory manager when eviction fails
    
    This add helper function to print information on eviction placements
    and memory manager status when eviction fails to allocate memory
    space.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 99d7e48e8cb867f303439ad40e995e203841bd94
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Dec 9 21:55:09 2009 +0100

    drm: Add memory manager debug function
    
    drm_mm_debug_table will print the memory manager state
    in table allowing to give a snapshot of the manager at
    given point in time. Usefull for debugging.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 550e2d9270e2f0a10c3b063899f70e4cca25fe72
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Dec 9 14:15:38 2009 +1000

    drm/radeon/kms: restore surface registers on resume.
    
    On resume on my rv530 laptop surface cntl was left disabled, so
    wierd stuff would happen with rendering to a tiled front buffer.
    
    This checks if the surface regs are assigned to bos and reprograms
    the surface registers on resume using the same path that clears
    them all on init.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 779720a3209849be202ac36a811e934865c50971
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Wed Dec 9 19:31:44 2009 -0500

    drm/radeon/kms/r600/r700: fallback gracefully on ucode failure
    
    Sent the wrong patch earlier.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7cb7d1d7b650c9764c8a1b00e2b43d932acde779
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Dec 9 22:14:27 2009 +0100

    drm/ttm: Initialize eviction placement in case the driver callback doesn't
    
    This would allow to catch driver callback error of not properly
    setting the eviction placement structure.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit cf0fe4566dcc0c5bd9b7da8c9a53e712593db118
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Dec 9 18:21:55 2009 +0100

    drm/radeon/kms: cleanup structure and module if initialization fails
    
    This would allow us to properly unload others module like TTM if
    initialization fails after we initiliazed TTM structure.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit eaa5fd1a66fefd7cc918d80250d66fa48b10b81f
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Dec 9 21:57:37 2009 +0100

    drm/radeon/kms: actualy set the eviction placements we choose
    
    Stupid bug, somehow copying the eviction placements into the
    result structure was missing.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 4a04a844ba0c09b5641bf2ebd9f9517aa76e52fb
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Dec 9 17:39:16 2009 +0100

    drm/radeon/kms: Fix NULL ptr dereference
    
    radeon_atombios_fini might be call while there is not valid
    atombios structure allocated, thus test for a not null ptr
    before trying to access this structure.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit b27b63750d912e80d61d2120c4a1664062d0f808
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Wed Dec 9 17:44:25 2009 -0500

    drm/radeon/kms/avivo: add support for new pll selection algo
    
    Supported on all AVIVO-based asics.
    Can be disabled via the new_pll module parameter:
    new_pll=0 - disable
    new_pll=1 - enable
    enabled by default
    
    [airlied: fixed to use do_div]
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 69b3b5e59bc763c30d0098ae4bbe1225c0e82a04
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Wed Dec 9 14:40:06 2009 -0500

    drm/radeon/kms/avivo: fix some bugs in the display bandwidth setup
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 2e7b6f7fa62d92d941c626f8ae45f5cd75a52d55
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Dec 9 15:32:23 2009 +1000

    drm/radeon/kms: fix return value from fence function.
    
    We only want to return here for errors, the wait functions return
    a positive timeout otherwise, which gets back to userspace and
    causes X to crash here.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5cc6fbab9da5680e7e5d2507d0f0c2c52ff18031
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Mon Dec 7 18:36:19 2009 +0100

    drm/radeon: Remove tests for -ERESTART from the TTM code.
    
    Also sets affected TTM calls up to not wait interruptible, since
    that would cause an in-kernel spin until the TTM call succeeds, since
    the Radeon code does not return to user-space when a signal is received.
    
    Modifies interruptible fence waits to return -ERESTARTSYS rather than
    -EBUSY when interrupted by a signal, since that's the (yet undocumented)
    semantics required by the TTM sync object hooks.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 98ffc4158e12008102cb6ae242a7fc46f9243f0d
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Mon Dec 7 18:36:18 2009 +0100

    drm/ttm: Have the TTM code return -ERESTARTSYS instead of -ERESTART.
    
    Return -ERESTARTSYS instead of -ERESTART when interrupted by a signal.
    The -ERESTARTSYS is converted to an -EINTR by the kernel signal layer
    before returned to user-space.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 312ea8da049a1830aa50c6e00002e50e30df476e
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Mon Dec 7 15:52:58 2009 +0100

    drm/radeon/kms: Convert radeon to new TTM validation API (V2)
    
    This convert radeon to use new TTM validation API, it doesn't
    really take advantage of it beside in the eviction case.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ca262a9998d46196750bb19a9dc4bd465b170ff7
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Tue Dec 8 15:33:32 2009 +0100

    drm/ttm: Rework validation & memory space allocation (V3)
    
    This change allow driver to pass sorted memory placement,
    from most prefered placement to least prefered placement.
    In order to avoid long function prototype a structure is
    used to gather memory placement informations such as range
    restriction (if you need a buffer to be in given range).
    Range restriction is determined by fpfn & lpfn which are
    the first page and last page number btw which allocation
    can happen. If those fields are set to 0 ttm will assume
    buffer can be put anywhere in the address space (thus it
    avoids putting a burden on the driver to always properly
    set those fields).
    
    This patch also factor few functions like evicting first
    entry of lru list or getting a memory space. This avoid
    code duplication.
    
    V2: Change API to use placement flags and array instead
        of packing placement order into a quadword.
    V3: Make sure we set the appropriate mem.placement flag
        when validating or allocation memory space.
    
    [Pending Thomas Hellstrom further review but okay
    from preliminary review so far].
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a2e68e92d384d37c8cc6bb7206d43b1eb9bc3f08
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Mon Dec 7 15:52:56 2009 +0100

    drm: Add search/get functions to get a block in a specific range
    
    These are required for changes to TTM.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit cf2f05d30dacab32e6866347be6cbfa4030b33b7
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Dec 8 15:45:13 2009 +1000

    drm/radeon/kms: fix avivo tiling regression since radeon object rework
    
    The object rework moved the tiling flag setup around wrongly,
    so tiling we getting setup then overwritten by fb format.
    
    Fixes regression with drm-radeon-next on rv530 laptop tiling test.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4f8d619cc3ab805aa1726c1dfe196a0705b955bd
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Tue Dec 8 22:12:06 2009 +0000

    drm/i915: Remove a debugging printk from hangcheck
    
    A residual bare printk survived the merger of the hang detector, remove
    this debugging left-over.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit d3f420d1089169fb48366e1aa750bdd92db0a04b
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Dec 8 14:30:49 2009 -0500

    drm/radeon/kms: make sure i2c id matches
    
    Entries in the i2c table aren't always ordered
    by id.  This allows us to remove some quirks
    that are no longer needed.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 279b215ecb8acc735c01ac89b1aa28c4a27dcafa
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Dec 8 14:07:03 2009 -0500

    drm/radeon/kms: make sure ss id matches
    
    entries in the ss table aren't always ordered
    by id.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 390d0bbe88b3ef00c28086076d791533407f298e
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Dec 8 12:48:20 2009 -0500

    drm/radeon/kms: connector fixes
    
    - Don't add dac load detection property to DVI-D
    - Make sure i2c info is valid before adding DP aux chan bus
    - Don't create scaling_mode_property twice
    - fix typo that prevented coherent and load detection from working
    - add coherent prop to DP (for dp->dvi adapters)
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ec42a6e7dcfc2e9a92fad1c132bc9e110fafeb3f
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Dec 8 15:58:08 2009 +1000

    drm/ttm: fix memory leak noticed by kmemleak.
    
    If we don't need the zone we need to free it.
    
    Acked-By: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b16d9acbdb97452d1418420e069acf7381ef10bb
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Dec 9 11:23:42 2009 +0800

    drm: disable all the possible outputs/crtcs before entering KMS mode
    
    Sometimes we will use a crtc for integerated LVDS, which is different with
    that assigned by BIOS. If we want to get flicker-free transitions,
    then we could read out the current state for it and set our current state
    accordingly.
    
    But it is true that if we aren't reading current state out, we do need
    to turn everything off before modesetting.  Otherwise the clocks can get very
    angry and we get things worse than a flicker at boot.
    In fact we also do the similar thing in UMS mode. We will disable all the
    possible outputs/crtcs for the first modesetting.
    
    So we disable all the possible outputs/crtcs before entering the KMS mode.
    Before we configure connector/encoder/crtc, the function of
    drm_helper_disable_unused_function can disable all the possible outputs/crtcs.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Reviewed-by: Eric Anholt <eric@anholt.net>
    Reviewed-by: Rafal Milecki <zajec5@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7e8b60faea972604c315634cff62d44803731ea9
Author: Andrew Lutomirski <luto@mit.edu>
Date:   Sun Nov 8 13:49:51 2009 -0500

    drm/i915: restore render clock gating on resume
    
    Rather than restoring just a few clock gating registers on resume,
    just reinitialize the whole thing.
    
    Signed-off-by: Andy Lutomirski <luto@mit.edu>
    [anholt: Fixed up for RC6 support landed since the patch was written]
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 7b0a9e8302522d5f7bb7fab6b8a3c8ce8181609c
Merge: 3f838fc d4877cf
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Dec 8 14:29:15 2009 +1000

    Merge remote branch 'korg/drm-radeon-dp' into drm-linus
    
    This merges the radeon KMS DisplayPort and hotplug detect support.
    
    Tested on RV635 DP card with a Dell 2408 monitor.
    
    Conflicts:
    	drivers/gpu/drm/drm_fb_helper.c

commit 3f838fc50c0dcdc993c24f6f5da0cda1228fc276
Merge: 3ff9916 22dd501
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Dec 8 14:06:07 2009 +1000

    Merge remote branch 'korg/drm-radeon-next' into drm-linus
    
    This merges all the radeon changes that weren't reliant on core-next.

commit 3ff99164f67aae78a2bd2313f65ad55bddb1ffea
Merge: 1bd049f f2b115e
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Dec 8 14:03:47 2009 +1000

    Merge remote branch 'anholt/drm-intel-next' into drm-linus
    
    This merges the upstream Intel tree and fixes up numerous conflicts
    due to patches merged into Linus tree later in -rc cycle.
    
    Conflicts:
    	drivers/char/agp/intel-agp.c
    	drivers/gpu/drm/drm_dp_i2c_helper.c
    	drivers/gpu/drm/i915/i915_irq.c
    	drivers/gpu/drm/i915/i915_suspend.c

commit 1bd049fa895f9c6743f38b52ce14775f5a31ea63
Merge: 22763c5 b0a007d
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Dec 8 13:52:41 2009 +1000

    Merge branch 'drm-core-next' into drm-linus
    
    Bring all core drm changes into 2.6.32 tree and resolve
    the conflict that occurs.
    
    Conflicts:
    	drivers/gpu/drm/drm_fb_helper.c

commit b0a007dc27d8d3ff3db07b3ea997323d9330f770
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Tue Dec 8 11:15:10 2009 +1000

    drm/kms: fix fb cmap allocation to use modeset->crtc not crtc
    
    crtc may be undefined at this point.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d4877cf2293f5463f531769fd12300cb3417c778
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Dec 4 16:56:37 2009 -0500

    drm/radeon/kms: enable hpd support
    
    This enabled interrupt driven hpd support for all
    radeon chips.  Assuming the hpd pin is wired up
    correctly, the driver will generate uevents on
    digital monitor connect and disconnect and retrain
    DP monitors automatically.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 429770b3e39999c4d025fbcb9959502adc3989d8
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Dec 4 15:26:55 2009 -0500

    drm/radeon/kms: add asic callbacks for hpd
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e0df1ac5c2cf346f4cc335025734978a4d747aa0
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Dec 4 15:12:21 2009 -0500

    drm/radeon/kms: add hpd support for r6xx/r7xx/rs780/rs880 asics
    
    This just adds the functionality, it's not hooked up
    yet.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit dcfdd4083509f9c46b1e92c58c062d50da50580e
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Dec 4 15:04:19 2009 -0500

    drm/radeon/kms: add hpd support for r5xx/rs600/rs690/rs740 asics
    
    This just adds the functionality, it's not hooked up
    yet.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 05a05c506f52041daa511f4899b63d21c9457474
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Dec 4 14:53:41 2009 -0500

    drm/radeon/kms: add hpd support for r1xx-r4xx asics
    
    This just adds the functionality, it's not hooked up
    yet.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b500f68045058454549f5f8553110ef086d8d06b
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Dec 3 13:08:53 2009 -0500

    drm/radeon/kms: add regs and irq tracking bits for hpd
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit eed45b30cd1423f8dc10b4312700773cac13c1c8
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Dec 4 14:45:27 2009 -0500

    drm/radeon/kms: get HPD info for connectors
    
    This populates the connectors with HPD (Hot Plug Detect)
    information.  This will be used in subsequent patches
    for automatic digital monitor connect/disconnect handling.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 53c1e09fea4cf3fc0ec1f735a5fcab78c43cb55d
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Nov 27 13:14:37 2009 -0500

    drm/radeon/kms: clean up DP debugging
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9fa05c98d69eb77c82e59b5e434ca63bba230ba0
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Nov 27 13:01:46 2009 -0500

    drm/radeon/kms: fix DP detect
    
    only return connected if there is actually a
    monitor connected.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e8696330e2a95e1b5872550dcf3ed04aecaf96b3
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Nov 26 08:57:23 2009 +1000

    drm/radeon/kms: drop unused array to fix warning.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 58682f107ad5178e47a45af3af1851442d05d7fc
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Nov 26 08:56:35 2009 +1000

    drm/radeon/kms: do dp link training at dpms on time not mode set.
    
    This moves the radeon DP link training call to happen when we
    dpms on the encoder not when we set the mode.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5fbfce7fc906c4a9e3d5e0872e5d6affaca54761
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Nov 26 08:55:18 2009 +1000

    drm/radeon/kms: make displayport work by reorganising vsemph setup.
    
    This fix reorganises the initial DP link training slightly, and
    actually makes DP work under kms here.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 54d9cb47dd6a754e434e5adeccb3a1e2835594fd
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Nov 26 08:49:17 2009 +1000

    drm/radeon/kms/dp: fix return in dpcd retrival.
    
    Not returning here caused us to get a display port version of 0 for everything
    this caused power up to not get sent which ends up in a black screen.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ffd09c648a76a1cf96872c033e98d4730f9b10a4
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Nov 24 16:13:23 2009 -0500

    drm/radeon/kms: free aux channel i2c adapter on destroy
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5801ead6bd6bddf5505d6eab55f84d8ee8106cd8
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Nov 24 13:32:59 2009 -0500

    drm/radeon/kms: add support for DP modesetting
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f92a8b6758bdc0f277c4f42aa7d736a205ac9ded
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Nov 23 18:40:40 2009 -0500

    drm/radeon/kms: handle dp sinks in atom encoder/transmitter tables
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4143e919ea999c9356ae4f71b5a3a80e075290d5
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Nov 23 18:02:35 2009 -0500

    drm/radeon/kms: store sink type in atom dig connector
    
    This will be used laster when the encoder and transmitters
    are set up.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6a93cb250a60af1bb7b4070949f8546a2fdc52ef
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Nov 23 17:39:28 2009 -0500

    drm/radeon/kms: i2c reorg
    
    - keep the atom i2c id in the i2c rec
    - fix gpio regs for GPIO and MDGPIO on pre-avivo chips
    - track whether the i2c line is hw capable
    - track whether the i2c line uses the multimedia i2c block
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 1a66c95a64c9ae0bc8382254f544b24b23f498ec
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Nov 20 19:40:13 2009 -0500

    drm/radeon/kms: DP fixes and cleanup from the ddx
    
    - dpcp -> dpcd
    - fix up dig encoder routing
    - aux transaction table takes delay in 10 usec units
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 746c1aa4d100f7441423050f34be79f401fbf7d4
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Dec 8 07:07:28 2009 +1000

    drm/radeon/kms: initial radeon displayport porting
    
    This is enough to retrieve EDID and DPCP.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5618ca6abc2d6f475b258badc017a5254cf43d1b
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Dec 2 15:15:30 2009 +0000

    drm/i915: Set the error code after failing to insert new offset into mm ht.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Cc: stable@kernel.org
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit fcffb947668073fd9c47da33f8e72add7f62163d
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Dec 2 16:48:57 2009 +0000

    drm/i915: Report purgeable status in buffer lists.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit fc61901373987ad61851ed001fe971f3ee8d96a3
Author: David Woodhouse <dwmw2@infradead.org>
Date:   Wed Dec 2 11:00:05 2009 +0000

    agp/intel-agp: Clear entire GTT on startup
    
    Some BIOSes fail to initialise the GTT, which will cause DMA faults when
    the IOMMU is enabled. We need to clear the whole thing to point at the
    scratch page, not just the part that Linux is going to use.
    
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
    [anholt: Note that this may also help with stability in the presence of
    driver bugs, by not drawing to memory we don't own]
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 447aeb907e417e0e837b4a4026d5081c88b6e8ca
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Dec 8 09:25:45 2009 +1000

    drm/ttm: fix unreachable code.
    
    None of the in-tree drivers use user objects yet so this wasn't hitting
    us.
    
    Stanse found unreachable code in ttm_bo_add_ttm:
    http://decibel.fi.muni.cz/~xslaby/stanse/error.cgi?db=32&id=714#l238
    
    Reported-by: Jiri Slaby <jirislaby@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ab2c0672984f7f7ebec6d5f615fd5a6ebad26f3d
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Dec 4 10:55:24 2009 +1000

    drm/intel: refactor DP i2c support and DP common header to drm helper
    
    Both radeon and nouveau can re-use this code so move it up a level
    so they can. However the hw interfaces for aux ch are different
    enough that the code to translate from mode, address, bytes
    to actual hw interfaces isn't generic, so move that code into the
    Intel driver.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 22dd50133ab7548adb23e86c302d6e8b75817e8c
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Sun Dec 6 19:45:17 2009 -0500

    drm/radeon/kms: fix vram setup on rs600/rs690/rs740
    
    Don't remap vram to 0 on IGP chips.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f2b115e69d46344ae7afcaad5823496d2a0d8650
Author: Adam Jackson <ajax@redhat.com>
Date:   Thu Dec 3 17:14:42 2009 -0500

    drm/i915: Fix product names and #defines
    
    IGD* isn't a useful name.  Replace with the codenames, as sourced from
    pci.ids.
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    [anholt: Fixed up for merge with pineview/ironlake changes]
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 2a008d0ccde4ce59a2714e132d5f86a0771e6422
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Dec 4 16:35:57 2009 -0500

    drm/radeon/kms: more r4xx lvds fixes
    
    Grab pll ref div from regs at driver init.  r4xx seems very
    picky about the dividers for the pll driving lvds.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 92cde00cbaf3236ef7ea9bd4f0b43c8c4a3f507f
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Dec 4 10:55:12 2009 -0500

    drm/radeon/kms/legacy: set common regs to sane value
    
    The DDX and radeonfb always set these regs to a sane value.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6b02af1c1f35550ce1a9873841fe9c50b1613591
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Dec 4 10:40:41 2009 -0500

    drm/radeon/kms/legacy: set overscan regs on modeset
    
    These can end up with garbage otherwise.
    
    fixes rh bug 537140
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d904ef9b00a4473af16766e99f17bdbb5f0fde65
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Nov 17 06:29:46 2009 +1000

    drm/radeon/kms: add support to atom parser for FB read/write
    
    FB read/write really doesn't need to access the actual VRAM, we
    can just use a scratch area. This is required for using atom displayport
    calls later.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 107f517b8f2a9d5858e640bc046606b1cff14bb5
Author: Adam Jackson <ajax@redhat.com>
Date:   Thu Dec 3 17:14:41 2009 -0500

    agp/intel: Fix product names and #defines
    
    IGD* isn't a useful name.  Replace with the codenames, as sourced
    from pci.ids.
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit f84676185368e36c6bc0eeab87ab73ed39042648
Merge: 22dd501 447aeb9
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Dec 8 07:03:55 2009 +1000

    Merge remote branch 'origin/drm-core-next' into test
    
    Conflicts:
    	drivers/gpu/drm/drm_fb_helper.c

commit ffb4728095b030f0885ea8e0907ee4ac57b130ee
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Dec 7 11:34:08 2009 +0000

    drm/i915: Drop a some common DRM_ERROR()
    
    These are handled by the error return being propagated to user-space and
    do not any add any information to the original error, so are useless.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 85364905f9ae12d19cb34099257d493e5d9a0c4e
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Dec 3 09:52:43 2009 -0800

    drm/i915: warn if Pineview CxSR can't be enabled
    
    If we don't detect a supported memory configuration, we can't enable
    CxSR.  Warn the user in this case so they can file a bug.

commit 22fd0fab3b512b5fcb4fd0b0668deeaa701511f9
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Wed Dec 2 13:42:53 2009 -0800

    drm/i915: pageflip fixes
    
    This patch brings the tree up to date with some fixes that were in a
    more recent version of the page flipping patch you applied.  It fixes
    pre-965 flip support, removes a leftover hack that forced alignment,
    and initializes the pipe & plane CRTC mappings.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 85bb0c377f259100d049937e30c85f7a8dea0fa0
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Sun Dec 6 21:46:28 2009 +0100

    drm: Export symbols needed for the vmwgfx driver.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4bfd75cb08a362cb1df35dc6a5032d12843c6d87
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Sun Dec 6 21:46:27 2009 +0100

    drm/ttm: Export symbols needed for the vmwgfx driver.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c078aa2fc4d8e022c3b611e07b25ff77afdf9b73
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Sun Dec 6 21:46:26 2009 +0100

    drm/ttm: Add TTM execbuf utilities.
    
    Utilities to reserve, unreserve and fence a list of TTM
    buffer objects in a deadlock-safe manner.
    
    Used by the vmwgfx driver.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4aff1013f5e4ae08a24155c029a2c5e1a7929de6
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Sun Dec 6 21:46:25 2009 +0100

    drm/ttm: Add ttm lock functionality.
    
    This is intended to be used by ttm-aware drivers to
    1) Block clients to inactive masters when
    they try to validate buffers for GPU use.
    2) Optionally block clients to the current master when
    there is thrashing due to GPU memory shortage.
    
    Used by the vmwgfx driver.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 88071539a3f5195f9e9dae38a3e35b3ce4b9f9fc
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Sun Dec 6 21:46:24 2009 +0100

    drm/ttm: Add user-space objects.
    
    Add objects needed for user-space to maintain reference counts on ttm objects.
    This is used by the vmwgfx driver which allows user-space to maintain
    map-counts on dma buffers, lock-counts on the ttm lock and ref-counts on
    gpu surfaces, gpu contexts and dma buffer.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 64bffd03756249e11b8651ccf33ac3a50a93ed4c
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Dec 7 13:29:51 2009 +1000

    drm/radeon/kms: fix RS600 MC setup.
    
    Again we try to put VRAM at 0, and it didn't work on this chipset,
    reports of corrupt RAM appeared on irc and bugzilla.
    
    Fix the vram location according to what the BIOS setup, I'm not 100%
    sure we don't need the same thing on rs690/rs780/rs880, we probably
    should do it there just in case as its what the DDX does.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4f15d24adb39803ba7b9363d0bb5dd714a6706f6
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Sat Dec 5 17:55:37 2009 -0500

    drm/radeon/kms: fix up gart setup on rs600
    
    Set up rs600 gart like r600:
    - set gart system aperture to vram
    - inside gart system aperture is unmapped*
    - outside gart system aperture is mapped*
    
    *mapped refers to memory handled by page tables
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit aa1a750ecb3412f69fe34081b249aa978154f360
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Dec 4 11:51:34 2009 +1000

    drm/radeon/kms: quirk for Gigabyte RV515 card, DVI+VGA not 2xDVI.
    
    Similiar to other quirks for RV515, this card has no second DVI port.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0088dbdb809e8799cb8f26da5ac64b15201fa99d
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Dec 3 16:28:02 2009 -0500

    drm/radeon/kms: rs6xx/rs740: clamp vram to aperture size
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Cc: stable@kernel.org
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 722f29434e72188b2d20f9b41f4b5952073ed568
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Dec 3 16:18:19 2009 -0500

    drm/radeon/kms: fix vram setup on rs600
    
    also fix up rs690 mem width.
    
    should fix fdo bug 25408
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Cc: stable@kernel.org
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8de21525439e6b5bb8d8c81e49094d867bf82f6d
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Dec 3 12:15:54 2009 -0500

    drm/radeon/kms: fix legacy crtc2 dpms
    
    noticed by Matthijs Kooijman on fdo bug 22140
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Cc: stable@kernel.org
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 500b758725314ab1b5316eb0caa5b0fa26740e6b
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Wed Dec 2 11:46:52 2009 -0500

    drm/radeon/kms: handle vblanks properly with dpms on
    
    avivo chips
    
    Copied from pre-avivo code.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Cc: stable@kernel.org
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4e3f9b78ff917cc5c833858fdb5d96bc262e0bf3
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Dec 1 14:49:50 2009 -0500

    drm/radeon/kms: Add quirk for HIS X1300 board
    
    Board is DVI+VGA, not DVI+DVI
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Cc: stable@kernel.org
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4c4f5413c3208da7621cd29baac1fbdca89181b2
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Wed Dec 2 00:59:37 2009 -0500

    drm/radeon/kms: don't use bios dividers for lvds on r4xx
    
    R4xx cards don't have lvds pll dividers since they use atom.
    
    should fix rh bug 541562
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d684076627a4561ea698bf7652a1a1baabdcdbdc
Author: Rafał Miłecki <zajec5@gmail.com>
Date:   Tue Nov 10 22:26:21 2009 +0100

    drm/radeon/kms: fix ring info in debugfs on r600+
    
    Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
    Acked-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 93e7de7b37cb6c75032007e5b84e1305f1705485
Author: Rafał Miłecki <zajec5@gmail.com>
Date:   Wed Nov 4 23:34:10 2009 +0100

    drm/radeon/kms: fix typo in define: engine -> memory
    
    Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c142c3e5e3e826bdeca77062ec44be558ff2f6b9
Author: Rafał Miłecki <zajec5@gmail.com>
Date:   Fri Nov 6 11:38:34 2009 +0100

    drm/radeon/kms/pm: fix typos
    
    Unit typo noticed by taiu on IRC
    
    Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 01d01ba947670cf58f22119fc126fdf39078f6ba
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Dec 4 10:18:02 2009 +1000

    drm/mm: fixup typo in debug functions.
    
    Free and used were reversed.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 884840aa3ce3214259e69557be5b4ce0d781ffa4
Author: Jakob Bornecrantz <jakob@vmware.com>
Date:   Thu Dec 3 23:25:47 2009 +0000

    drm: Add dirty ioctl and property
    
    This commit adds a ioctl and property to allow userspace
    to notify the kernel that a framebuffer has changed. Instead
    of snooping the command stream this allows finer grained
    tracking of which areas have changed.
    
    The primary user for this functionality is virtual hardware
    like the vmware svga device, but also Xen hardware likes to
    be notify. There is also real hardware like DisplayLink and
    DisplayPort that might take advantage of this ioctl.
    
    Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c3a73ba13bac7fd96030f39202b2d37fb19c46a6
Author: Martin Michlmayr <tbm@cyrius.com>
Date:   Thu Nov 19 16:29:45 2009 +0000

    drm/ttm: Fix build failure due to missing struct page
    
    drm/ttm fails to build on MIPS because "struct page" is not known:
    | In file included from drivers/gpu/drm/ttm/ttm_memory.c:28:
    | include/drm/ttm/ttm_memory.h:154: warning: 'struct page' declared inside parameter list
    | include/drm/ttm/ttm_memory.h:154: warning: its scope is only this definition or declaration, which is probably not what you want
    | include/drm/ttm/ttm_memory.h:156: warning: 'struct page' declared inside parameter list
    | drivers/gpu/drm/ttm/ttm_memory.c:540: error: conflicting types for 'ttm_mem_global_alloc_page'
    | include/drm/ttm/ttm_memory.h:154: error: previous declaration of 'ttm_mem_global_alloc_page' was here
    | drivers/gpu/drm/ttm/ttm_memory.c:561: error: conflicting types for 'ttm_mem_global_free_page'
    | include/drm/ttm/ttm_memory.h:156: error: previous declaration of 'ttm_mem_global_free_page' was here
    
    Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
    Cc: stable@kernel.org
    Acked-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 46a79fa08a9a890a12cf9ec3ce51800911a907bf
Author: Dan Carpenter <error27@gmail.com>
Date:   Sat Nov 28 12:30:32 2009 +0200

    drm/ttm: fix small memory leak in ttm_memory.c
    
    I moved the allocation until after the check for (si->totalhigh == 0).
    
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Acked-By:  Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 1a95916f5465ad6c91398f17924949db7e0b5c36
Author: Kristian Høgsberg <krh@bitplanet.net>
Date:   Wed Dec 2 12:13:48 2009 -0500

    drm: Add compatibility #ifdefs for *BSD
    
    This let's use use the linux drm headers as the canonical source for
    libdrm on all platforms.
    
    Signed-off-by: Kristian Høgsberg <krh@bitplanet.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 862302ffe422378a5213f558fc5cdf62c37050a9
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Dec 2 18:15:25 2009 +0000

    drm: Add support for drm master_[set|drop] callbacks.
    
    The vmwgfx driver has a per master rw lock around TTM, to guarantee
    mutual exclusion when needed.
    
    This is typically when all evictable buffers are evicted due to
    
    1) vt switch
    2) master switch
    3) suspend / resume.
    
    In the multi-master case, on master switch the new master takes the
    previously active master lock in write mode, and then evicts all
    buffers. Any clients to previous masters will then block on that lock
    when trying to validate a buffer. fbdev also acts as a virtual master
    wrt this.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9340d8cfeacd16cef1cbe94527f7baaed7640669
Author: Adam Jackson <ajax@redhat.com>
Date:   Thu Dec 3 17:44:40 2009 -0500

    drm/edid: Decode 3-byte CVT codes from EDID 1.4
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 2dbdc52c8162291aa7541b8ba6e1c1587f50c1dd
Author: Adam Jackson <ajax@redhat.com>
Date:   Thu Dec 3 17:44:39 2009 -0500

    drm/edid: Add new detailed block types from EDID 1.4
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 07a5e6324abacad56a8e7bcb44dd404e84f75f57
Author: Adam Jackson <ajax@redhat.com>
Date:   Thu Dec 3 17:44:38 2009 -0500

    drm/edid: Add DMT modes to the pool if the monitor is GTF-capable
    
    See also: http://bugzilla.redhat.com/539785
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7ac96a9cb4982140e206bf3b58236efb2498ab3f
Author: Adam Jackson <ajax@redhat.com>
Date:   Thu Dec 3 17:44:37 2009 -0500

    drm/modes: Add drm_mode_hsync()
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9cf00977da092096c7a983276dad8b3002d23a99
Author: Adam Jackson <ajax@redhat.com>
Date:   Thu Dec 3 17:44:36 2009 -0500

    drm/edid: Unify detailed block parsing between base and extension blocks
    
    Also fix an embarassing bug in standard timing subblock parsing that
    would result in an infinite loop.
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6e36595a2131e7ed5ee2674be54b2713ba7f0490
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Dec 2 10:03:34 2009 +0800

    drm/i915: Declare the new VBT parsing functions as static
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 652af9d74e1a3a10bb10f0d8e8f42ddac26bbc1a
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Dec 2 10:03:33 2009 +0800

    drm/i915: Add the missing clonemask for display port on Ironlake
    
    Add the missing clonemask for display port on Ironlake.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
    cc: stable@kernel.org
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit f24bc39facc1e74eb989908106fe9f6d375ae16e
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Dec 2 10:03:32 2009 +0800

    drm/i915: fix the incorrect condition judgement in dp_is_present_in_vbt
    
    We were always looking for the PORT_IDPB entry.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 4c7886791264f03428d5424befb1b96f08fc90f4
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Fri Nov 20 14:29:23 2009 +0100

    drm/radeon/kms: Rework radeon object handling
    
    The locking & protection of radeon object was somewhat messy.
    This patch completely rework it to now use ttm reserve as a
    protection for the radeon object structure member. It also
    shrink down the various radeon object structure by removing
    field which were redondant with the ttm information. Last it
    converts few simple functions to inline which should with
    performances.
    
    airlied: rebase on top of r600 and other changes.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 1614f8b17b8cc3ad143541d41569623d30dbc9ec
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Dec 1 16:04:56 2009 +1000

    drm/radeon/kms: add irq mitigation code for sw interrupt.
    
    We really don't need to process every irq that comes in, we only
    really want to do SW irq processing when we are actually waiting for
    a fence to pass. I'm not 100% sure this is race free esp on non-MSI systems
    so it needs some testing.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d8f60cfc93452d0554f6a701aa8e3236cbee4636
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Dec 1 13:43:46 2009 -0500

    drm/radeon/kms: Add support for interrupts on r6xx/r7xx chips (v3)
    
    This enables the use of interrupts on r6xx/r7xx hardware.
    Interrupts are implemented via a ring buffer.  The GPU adds
    interrupts vectors to the ring and the host reads them off
    in the interrupt handler.  The interrupt controller requires
    firmware like the CP.  This firmware must be installed and
    accessble to the firmware loader for interrupts to function.
    
    MSIs don't seem to work on my RS780.  They work fine on all
    my discrete cards.  I'm not sure about other RS780s or
    RS880s.  I've disabled MSIs on RS780 and RS880, but it would
    probably be worth checking on some other systems.
    
    v2 - fix some checkpatch.pl problems;
         re-read the disp int status reg if we restart the ih;
    
    v3 - remove the irq handler if r600_irq_init() fails;
         remove spinlock in r600_ih_ring_fini();
         move ih rb overflow check to r600_get_ih_wptr();
         move irq ack to separate function;
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 50dafba685c0f12c23d315820370b32d9ba64db7
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Dec 1 15:02:17 2009 +1000

    drm/radeon/kms: call correct atom table for digital output dpms.
    
    found while working on displayport.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ee2215f0b269f4c460807e3f827665eb7049aa34
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Nov 26 15:58:36 2009 +0100

    drm/radeon/kms: Don't overwrite crtc_gen_cntl or crtc_gen_cntl2
    
    Don't overwritte  crtc_gen_cntl or crtc_gen_cntl2 or we may loose the
    cursor. This especialy happen when changing video mode. Fix bugs:
    https://bugzilla.redhat.com/show_bug.cgi?id=529146
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ed160143c6967e89aee05b0685e73c4103bb3e38
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Dec 1 14:12:14 2009 -0500

    drm/radeon/kms: add tv standard property to tv connectors
    
    Lets user select tv-standard.  The property was there,
    just not hooked up.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 72542d77058bd45ccafd1e15ed3c70349fe3277b
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Dec 1 14:06:31 2009 +1000

    drm/radeon/kms: ignore unposted GPUs with no BIOS.
    
    If we find a GPU but we can't find its BIOS and it isn't posted,
    then ignore it.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4b30b87042aa71ed8682e4df622a10456796fccd
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Dec 1 09:13:40 2009 +1000

    drm/radeon/kms: fix divide by 0 in clocks code
    
    If the chip isn't initialised properly this can happen.
    also fix return value in combios clocks function.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7dde8a19656ddec769b609e8b5662aa7243b8b6a
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Nov 30 01:40:24 2009 -0500

    drm/radeon/kms/atom: pull misc mode info for lvds from bios tables
    
    sync polarity, etc.  This will likely fix LVDS problems
    on some laptops.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 30256a3f6b646f6c6ab7276a97b40792faac5f1d
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Mon Nov 30 17:47:59 2009 +0100

    drm/radeon/kms: Disable agp only if we are dealing with an AGP GPU
    
    On IGP if you pass option agpmode=-1 you would overwrite the set_page
    function callback with improper function which endup in non functioning
    hw. This patch will disable agp when giving agpmode=-1 parameter only
    if we are dealing with an AGP GPU.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ec51efa9b2b8ff10b535a853c293e85bada886e4
Author: Pierre Ossman <pierre@ossman.eu>
Date:   Mon Nov 30 21:15:44 2009 +0100

    drm/radeon/kms: Disable both CRTCs during mode switch
    
    Reconfiguring one CRTC whilst another is running can cause a hang under
    some circumstances. Unfortunately we haven't pinpointed exactly what those
    circumstances are, so disable all CRTCs for every mode switch.
    
    Signed-off-by: Pierre Ossman <pierre@ossman.eu>
    Acked-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 32f48ffea91008a27b99aab7a68a3443559d83fb
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Nov 30 01:54:16 2009 -0500

    drm/radeon/kms: fix LVDS setup on r4xx
    
    R4xx mobility chips use atombios, which does not store
    the LVDS_GEN_CNTL parameter setup like combios.  Rather,
    it's configured in LVDSEncoderControl.  As such,
    LVDS_GEN_CNTL is set wrong when on resume.  Call
    LVDSEncoderControl to set it properly.
    
    Should fix fdo bug 25336
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 23956dfa82eab95931aab5fa9886c1e96c41e4dc
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Nov 23 12:01:09 2009 +1000

    drm/radeon/kms: add HDP flushing for all GPUs.
    
    rendercheck under kms on r600s was failing due to HDP flushing not happening.
    
    This adds HDP flushing to the object wait function for r100->r700 families.
    
    rendercheck passes basic tests on r600 with this change.
    
    Acked-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 38e1492130c42ac806ffd8b21ccf64eb1c997d10
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Wed Aug 5 00:19:51 2009 +0200

    drm/radeon: Give userspace more accurate information about available memory.
    
    This patch varies from the original and just removes memory for kernel
    pinned objects.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 47381156a8f0d793bacfa346cc4cc515399525f7
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Nov 18 13:39:34 2009 +1000

    drm/radeon/kms: pick 8bpp console when 32MB or less VRAM
    
    making the pinned console smaller gives X a bit more room to play with.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 1f3b6a45f0805690269a7a9d265cbbc2f15b6c6e
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Oct 13 14:10:37 2009 +1000

    drm/radeon/kms: add support for encoder cloning.
    
    The RN50 really needs this since its a single crtc card,
    however other gpus may benefit from it as well.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 2de3b4841f67a15c7b8e820b84dd6b7cc41370da
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Tue Nov 17 14:08:55 2009 -0800

    drm/radeon/kms: fix oops when set_base is call with no FB
    
    Just do nothing if crct_set_base() is called with no FB.
    
    The oops happens when the user switches between X & vt or in some case
    when changing mode.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fd874ad0a0dcf715333a3f3564c6486a3a90bb22
Author: Alex Deucher <alex@hp.localdomain>
Date:   Mon Nov 16 18:33:51 2009 -0500

    drm/radeon/kms: add quirk for MSI S270
    
    doesn't have a tv-out port
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 71407c46fecb82c542b6209f021d38a2901969a3
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Nov 17 15:44:01 2009 -0500

    drm/radeon/kms: deal with connectors sourced to the same encoder
    
    Some systems have multiple connectors connected to the same encoder;
    e.g., DVI and HDMI connected to the same encoder with the same ddc
    line. Since we expose connectors as xrandr outputs, randr treats them
    separately which results in it trying to source the same encoder to
    different crtcs. If we have an HDMI and DVI-D port on the same encoder,
    pick the one to be considered connected based on the edid (HDMI if edid
    indicates HDMI, DVI otherwise).
    
    Should fix fdo bug 25150
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3e5f8ff3a9f4e7a71c5371b2122b32faf31c563a
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Nov 17 17:12:10 2009 -0500

    drm/radeon/kms: add quirk for Acer laptop
    
    DVI-I port is actually DVI-D
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 80297e87bc9728a6ce559063fc4c117eba1f955a
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Nov 12 14:55:14 2009 -0500

    drm/radeon/kms: rework scaler handling
    
    Keep requested scaler type in radeon_encoder
    and the actual scaler type used in radeon_crtc.
    This prevents us from enabling the scaler when it's
    not required (i.e., the requested mode is the native
    mode).  Also, always set the adjusted mode equal
    to the native mode for lvds.
    
    Should fix:
    https://bugzilla.redhat.com/show_bug.cgi?id=522271
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Acked-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fe6890c3e8019cf1cebce60a86c19180359d3292
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Nov 12 14:01:36 2009 -0500

    drm/radeon/kms: fix typo in legacy internal tmds mode fixup
    
    Call to set active device was missing.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 17e15b0c719b5ec0b344d3ebe3787b48315a0218
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Nov 5 15:36:53 2009 +1000

    drm/radeon/kms: AGP systems need PCI bus mastering enabled
    
    We might not hit this yet, but when if we do any sort of writeback
    we really need to enable PCI bus mastering on these systems from
    what I can see.
    
    This enables PCI BM on all radeons that require it.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fcec570b27a47e428a9bfc8572ae4c7c230d0488
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Nov 10 21:25:07 2009 -0500

    drm/radeon/kms: add support for external tmds on legacy boards
    
    This enables initialization of external tmds chips on pre-atom
    and mac systems.  Macs are untested.  Also, some macs have single
    link tmds chips while others have dual link tmds chips.  We need
    to figure out which ones have which.
    
    This gets external TMDS working on my RS485 and RV380.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9b9fe72488a3a637e0550cc888e3f7a8f70e521e
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Nov 10 15:59:44 2009 -0500

    drm/radeon/kms: clean up i2c
    
    - Change reg/mask names to match what we use internally
    and in the bios
    - Clarify how i2c over gpio on radeon actually works
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ab1e9ea08f1e94639b2d21a6bde5b55d31b1deee
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Nov 5 18:27:30 2009 -0500

    drm/radeon/kms: dont't pass a radeon_connector to radeon_i2c_do_lock()
    
    We need this for supporting things other than ddc on i2c.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f0217c42c9ab3d772e543f635ce628b9478f70b6
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Dec 1 11:56:30 2009 -0800

    drm/i915: Fix DDC on some systems by clearing BIOS GMBUS setup.
    
    This is a sync of a fix I made in the old UMS code.  If the BIOS uses
    the GMBUS and doesn't clear that setup, then our bit-banging I2C can
    fail, leading to monitors not being detected.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit d09c23de9f967a7b7dcee0ffc57222ddbd821aba
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Nov 6 15:39:56 2009 +0800

    drm/i915: Add 30ms delay to make SDVO TV detection reliable.
    
    Without this, on some boots the TV wouldn't be detected.  Testing
    showed 15ms to be insufficient.
    
    https://bugs.freedesktop.org/show_bug.cgi?id=24290
    https://bugs.freedesktop.org/show_bug.cgi?id=20785
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Tested-by: Yan Seiner <yan@seiner.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 04b2d218001bdddb41b84c9f78d6bb3cd3b5b31c
Author: Kristian Høgsberg <krh@bitplanet.net>
Date:   Fri Nov 6 08:39:18 2009 -0500

    drm/i915: Fix typo in ioctl struct name.
    
    Signed-off-by: Kristian Høgsberg <krh@bitplanet.net>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 778c902640530371a169ad1c03566e7c51b09874
Author: Li Peng <peng.li@linux.intel.com>
Date:   Mon Nov 9 12:51:22 2009 +0800

    drm/i915: Fix sync to vblank when VGA output is turned off
    
    In current vblank-wait implementation, if we turn off VGA output,
    drm_wait_vblank will still wait on the disabled pipe until timeout,
    because vblank on the pipe is assumed be enabled. This would cause
    slow system response on some system such as moblin.
    
    This patch resolve the issue by adding a drm helper function
    drm_vblank_off which explicitly clear vblank_enabled[crtc], wake up
    any waiting queue and save last vblank counter before turning off
    crtc. It also slightly change drm_vblank_get to ensure that we will
    will return immediately if trying to wait on a disabled pipe.
    
    Signed-off-by: Li Peng <peng.li@intel.com>
    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    [anholt: hand-applied for conflicts with overlay changes]
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 27dfaf4f5825a119305db1bc63bef30ed400e376
Author: Adam Jackson <ajax@redhat.com>
Date:   Fri Nov 20 13:22:44 2009 +0800

    drm/i915: disable the interrupt hotplug for integrated TV output
    
    Otherwise, I'd get stuck in a loop where (afaict) output scan would
    trigger a TV interrupt, which would trigger a scan, etc.  TV load
    detection not being the fastest thing in the world, X would process
    requests very slowly.
    
    https://bugs.freedesktop.org/show_bug.cgi?id=24404
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Acked-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 28cf798f5a9bd894ee90b27667b0d36b4933ae23
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Nov 30 01:08:56 2009 +0000

    drm/i915: Don't update the render-clock for every bo.
    
    Only update the render-clock on transition from busy to idle and vice
    versa, or else we burn a significant percentage of the cpu just rewriting
    the register -- not quite as power-friendly as intended ;-)
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 38b3037ee47fbd65a36bc7c39f60a900fbbe3b8e
Author: Adam Jackson <ajax@redhat.com>
Date:   Tue Nov 24 10:07:00 2009 -0500

    drm/i915: Fix LVDS presence check
    
    Assume that either the presence of an LVDS entry in the VBT or an ACPI
    lid device indicates an LVDS device.  ACPI lid alone is not sufficient.
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 05dd8f973f895692dd33c95e87c0e69aa0e7a93b
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Dec 1 09:25:23 2009 -0800

    drm/i915: Fix warning introduced with the page flipping ioctl.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit e9560f7cb20722e0e7db46bbb6f43c2194a238d5
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Nov 19 10:49:07 2009 -0800

    drm/i915: add GETPARAM request for page flipping
    
    Add a GETPARAM request for checking if page flipping is supported.
    Useful for the 2D driver to enable the flipping path.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 7bd4d7be5c8c35a401b1589201e5d43a64d3f05b
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Nov 19 10:50:22 2009 -0800

    drm: use page flip event to signal flip completion
    
    We don't actually know which frame number the flip will complete on, so
    userspace needs a specific flip notification to tell it when the last flip
    completed.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Acked-by: Kristian Høgsberg <krh@bitplanet.net>

commit 6b95a207c1fd552e7d017837c5eaf1b0173a48c9
Author: Kristian Høgsberg <krh@bitplanet.net>
Date:   Wed Nov 18 11:25:18 2009 -0500

    drm/i915: Add intel implementation of the pageflip ioctl
    
    Acked-by: Jakob Bornecrantz <jakob@vmware.com>
    Acked-by: Thomas Hellström <thomas@shipmail.org>
    Review-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Jesse "Orange Smoothie" Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Kristian Høgsberg <krh@bitplanet.net>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit f40d6817a5c2bf84f5fe7b5d1a83f1e8f8669951
Merge: 103a196 46557be
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Dec 1 09:01:54 2009 -0800

    Merge remote branch 'airlied/drm-next' into drm-intel-next

commit 103a196f4224dc6872081305cf7f82ebf67aa7bd
Author: Zhenyu Wang <zhenyuw@linux.intel.com>
Date:   Fri Nov 27 11:44:36 2009 +0800

    drm/i915: PineView only has LVDS and CRT ports
    
    PineView only has 2 ports for LVDS and CRT. Don't enable other
    ports for it.
    
    Cc: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit c35614380d5c956bfda20eab2755b2f5a7d6f1e7
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Tue Nov 24 09:48:48 2009 +0800

    drm/i915: Don't set up the TV port if it isn't in the BIOS table.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 7cf4f69d3f4511f443473954456cb91d5514756d
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Tue Nov 24 09:48:47 2009 +0800

    drm/i915: Don't set up the LVDS if it isn't in the BIOS device table.
    
    We not only check the device type, but also check the addin_offset. If the
    addin_offset is zero, it won't be initialized.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Reviewed-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    [anholt: hand-applied due to conflicts]

commit ae266c98f580a9ba5e0bfdb1d1f0f70ab3cd807f
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Tue Nov 24 09:48:46 2009 +0800

    drm/i915: Don't set up DP ports that aren't in the BIOS device table.
    
    Use the child device array to decide whether the given DP output should be
    initialized. If the given DP port can't be found in child device array,
    it is not present and won't be initialized.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit fc816655236cd9da162356e96e74c7cfb0834d92
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Tue Nov 24 09:48:45 2009 +0800

    drm/i915: Don't set up HDMI ports that aren't in the BIOS device table.
    
    Use the child device array to decide whether the given HDMI output should be
    initialized. If the given HDMI port can't be found in child device array,
    it is not present and won't be initialized.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 6363ee6f496eb7e3b3f78dc105e522c7b496089b
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Tue Nov 24 09:48:44 2009 +0800

    drm/i915: parse child device from VBT
    
    On some laptops there is no HDMI/DP. But the xrandr still reports
    several disconnected HDMI/display ports. In such case the user will be
    confused.
     >DVI1 disconnected (normal left inverted right x axis y axis)
     >DP1 disconnected (normal left inverted right x axis y axis)
     >DVI2 disconnected (normal left inverted right x axis y axis)
     >DP2 disconnected (normal left inverted right x axis y axis)
     >DP3 disconnected (normal left inverted right x axis y axis)
    
    This patch set is to use the child device parsed in VBT to decide whether
    the HDMI/DP/LVDS/TV should be initialized.
    
    Parse the child device from VBT.
    
    The device class type is also added for LFP, TV, HDMI, DP output.
    
    https://bugs.freedesktop.org/show_bug.cgi?id=22785
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Reviewed-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit c1b5dea097258b3d3d570d5ccc8f4bf5accb3f29
Author: Kristian Høgsberg <krh@bitplanet.net>
Date:   Wed Nov 11 12:19:18 2009 -0500

    drm/i915: Disable pwrctx before unpin and free
    
    Otherwise the chip may scribble over free memory.
    
    Signed-off-by: Kristian Høgsberg <krh@bitplanet.net>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 69341a5e01897714f968b7dccb94f57137acf45f
Author: Kristian Høgsberg <krh@bitplanet.net>
Date:   Wed Nov 11 12:19:17 2009 -0500

    drm/i915: Hold struct_mutex while unreffing pwrctx object
    
    This also extends the mutex to cover fbc disabling, which is safe.
    
    Signed-off-by: Kristian Høgsberg <krh@bitplanet.net>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 33db679b4ee94e5a55abb439a87905d76739095a
Author: Kristian Høgsberg <krh@bitplanet.net>
Date:   Wed Nov 11 12:19:16 2009 -0500

    drm/i915: Unregister i915_wedged debugfs entry using the right key
    
    Signed-off-by: Kristian Høgsberg <krh@bitplanet.net>
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 29874f44fbcbc24b231b42c9956f8f9de9407231
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Wed Nov 18 15:15:02 2009 +0800

    drm/i915: fix gpio register detection logic for BIOS without VBT
    
    if no VBT is present, crt_ddc_bus will be left at 0, and cause us
    to use that for the GPIO register offset. That's never a valid register
    offset, so let the "undefined" value be 0 instead of -1.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    [anholt: clarified the commit message a bit]

commit d271817baecbccb47da0d9f28c285a0dae8a06b7
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri Nov 27 13:06:56 2009 +0000

    drm/i915: Avoid NULL dereference with component_only tv_modes
    
    In commit d2d9f2324, the guard for a valid video mode was removed. This
    caused the regression:
    
      kernel crash during kms graphic boot on Intel GM4500 platform
      https://bugzilla.redhat.com/show_bug.cgi?id=540218
    
    This patches changes the logic slightly not to rely on a coupled
    variable, but to just check whether the video_modes is valid before
    dereferencing.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Cc: David Woodhouse <dwmw2@infradead.org>
    Cc: Zhenyu Wang <zhenyu.z.wang@intel.com>
    [ickle: Actually reference the correct bug report]
    Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 9bedb9743fd906e4160468663ee6e1bbdc4412b8
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon Nov 30 15:55:49 2009 +0100

    drm/i915: fixup interrupted overlay switch off calls
    
    When switching to interruptible sleeps in the overlay code, I've
    forgotten to recover from interruptions at one site.  This
    resulted in the overlay still running when it should have been
    switched off. This in turn caused a hang on resume because it
    tried to disable the (not-running) overlay in preparation for the
    resume modeset.
    
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=24980
    Tested-by: maximlevitsky@gmail.com
    
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 12ca45fea91cfbb09df828bea958b47348caee6d
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sat Apr 25 10:08:26 2037 +0200

    drm/i915: overlay: extract some duplicated code
    
    I've suspected some bug there wrt to suspend, but that was not
    the case. Clean up the code anyway.
    
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 26444877812fb2a2b9301b0b3702fdf9f9e06e4b
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Wed Oct 14 17:19:28 2009 +0800

    drm/i915: remove Pineview EOS protection support
    
    HW guys have an evaluation about the impact about EOS, and say the impact
    is quite small, so they have removed EOS detection support. This patch
    removes EOS feature.
    
    revert commit 043029655816ed4cfc2ed247020ef97e5d637392
    directly reverting it gives a hunk error, so please use this one.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    [anholt: fixed up commit message for update that the feature's really gone]

commit 311089d3d372c6f2b01a6d8a5ed7fcbcd9ad7621
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Thu Nov 26 14:22:41 2009 +0800

    drm/i915: use msleep for intel_wait_for_vblank
    
    20ms delay is quite big and the routine isn't called in atomic context.
    better use msleep to let other tasks run. This can reduce cpu time used
    by Xorg, so potentially boost boot.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 1991bdfaf5897b6fbfdc7dce81508f7cbc044768
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Tue Nov 17 17:19:23 2009 +0800

    drm/i915: handle failure path correctly for lvds
    
    In failure path, make sure encoder is cleaned up, otherwise there
    is a kernel oops.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 1b3c7a47f993bf9ab6c4c7cc3bbf5588052b58f4
Author: Zhenyu Wang <zhenyuw@linux.intel.com>
Date:   Wed Nov 25 13:09:38 2009 +0800

    drm/i915: Fix LVDS stability issue on Ironlake
    
    In disable sequence, all output ports on PCH have to be disabled
    before PCH transcoder, but LVDS port was left always enabled. This
    one fixes that by disable LVDS port properly during pipe disable
    process, and resolved stability issue seen on Ironlake. Also move
    panel fitting disable time just after pipe disable to align with
    the spec.
    
    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 4215866059b126590aceddfe9f846595b0c1f458
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Nov 20 11:24:18 2009 +0800

    drm/i915: Restore the DPLL calculation logic for 9xx platform
    
    The DPLL calculation logic for 9xx platform is changed in:
    commit 652c393a3368af84359da37c45afc35a91144960
    Author: Jesse Barnes <jbarnes@virtuousgeek.org>
    Date:   Mon Aug 17 13:31:43 2009 -0700
    
        drm/i915: add dynamic clock frequency control
    
    Maybe we will get the different M/N/P combination with that by using the
    previous dpll calculation logic.
    
    So restore the DPLL calculation logic for 9xx platform.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit d1fcea6a529d22212b324f26cd660c85b289a026
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Nov 20 11:24:17 2009 +0800

    drm/i915: Check whether the LVDS downclock is found in VBT
    
    Enumerate the LVDS panel timing info entry list in VBT to check whether
    the LVDS downclock is found. If found, the downclock is also used to switch
    dynamically between low and high frequency for LVDS.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 18f9ed12f8c977e25d65a16af8e8d73f72417ba1
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Nov 20 03:24:16 2009 +0000

    drm/i915: Enable LVDS downclock feature through EDID.
    
    If more than one mode with the same resolution defined in EDID has different
    refresh rate, it is thought that the downclock is found for LVDS.
    We will program the different FPx0/1 register so that we can select dynamically
    between the low and high frequency.
    
    On the g4x platform we will use the CxSR feature to switch the different
    refresh rate if the LVDS downclock feature is supported.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit c8e0f93a381d1d76135e567f13a4418fce66fd95
Author: Eric Anholt <eric@anholt.net>
Date:   Sun Nov 22 03:49:37 2009 +0100

    drm/i915: Replace a calloc followed by copying data over it with malloc.
    
    Execbufs involve quite a bit of payload, to the extent that cache misses
    show up in the profiles here, and a suspicion that some of those cachelines
    may get evicted and then reloaded in the subsequent copy.
    
    This is still abstracted like drm_calloc_large since we want to check for
    size overflow, and because we want to choose between kmalloc and vmalloc
    on the fly.  cairo's interface for malloc-with-calloc's-args was used as
    the model.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 9632b41f00cc2fb2846569cc99dbeef78e5c94a0
Author: Adam Jackson <ajax@redhat.com>
Date:   Mon Nov 23 14:23:07 2009 -0500

    drm/modes: Fall back to 1024x768 instead of 800x600
    
    This matches the X server's fallback modes when using RANDR 1.2.
    
    See also: http://bugzilla.redhat.com/538761
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 862b89c069cafded4e31029be511f2e0b58d9c5f
Author: Adam Jackson <ajax@redhat.com>
Date:   Mon Nov 23 14:23:06 2009 -0500

    drm/edid: Fix up partially corrupted headers
    
    We'll still fail the block if it fails the EDID checksum though.
    
    See also: http://bugzilla.redhat.com/534120
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 47ee4ccf745ea88ee1aadcf5895d91af3b73ea64
Author: Adam Jackson <ajax@redhat.com>
Date:   Mon Nov 23 14:23:05 2009 -0500

    drm/edid: Retry EDID fetch up to four times
    
    This matches the X server's retry logic.  Note that we'll only retry if
    we get a DDC response but fail validation; legitimately disconnected
    outputs will bomb out early.
    
    See also: http://bugzilla.redhat.com/532957
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f985dedb57bae741b4326415f72fe1a1e556563b
Author: Adam Jackson <ajax@redhat.com>
Date:   Mon Nov 23 14:23:04 2009 -0500

    drm/modes: Limit fallback modes to 60Hz
    
    See also: http://bugzilla.redhat.com/514600
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3bea21b64c0e3f380814de990ef57ff1f08dbf95
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Wed Nov 4 09:43:00 2009 +0100

    drm/kms: allocate framebuffer cmap
    
    Without an allocated colormap, FBIOGETCMAP fails.  This would make
    programs restore an all-black colormap ("links -g") or fail to work
    altogether ("mplayer -vo fbdev2").
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7a654158bdf9dc318fd451fbf606ed100d6ba25f
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Wed Nov 4 09:42:56 2009 +0100

    drm: set the type of the drm_framebuffer::fbdev field
    
    The fbdev field of the drm_framebuffer structure is always used to store
    a pointer to a fb_info, so there is no reason for it to be void*.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit cda6be1ce27d721a88cb90543a1e6d0f41baeaa4
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Wed Nov 4 09:42:52 2009 +0100

    drm/fb: fix FBIOGET/PUT_VSCREENINFO pixel clock handling
    
    When the framebuffer driver does not publish detailed timing information
    for the current video mode, the correct value for the pixclock field is
    zero, not -1.
    
    Since pixclock is actually unsigned, the value -1 would be interpreted
    as 4294967295 picoseconds (i.e., about 4 milliseconds) by
    register_framebuffer() and userspace programs.
    
    This patch allows X.org's fbdev driver to work.
    
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 731b5a15a3b1474a41c2ca29b4c32b0f21bc852e
Author: James Simmons <jsimmons@infradead.org>
Date:   Thu Oct 29 20:39:07 2009 +0000

    drm/kms: properly handle fbdev blanking
    
    I examined several fbdev drivers and foudn the blanking code in
    drm_fb_helper to be wrong. This patch fixes the fbdev blanking to behave
    like other fbdev drivers.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 46557bef3f3834ac33031c7be27d39d90d507442
Merge: 4efc50d d91d8a3
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Nov 18 10:09:55 2009 +1000

    Merge branch 'drm-core-next' of ../linux-2.6 into drm-next

commit d91d8a3f88059d93e34ac70d059153ec69a9ffc7
Author: Kristian Høgsberg <krh@bitplanet.net>
Date:   Tue Nov 17 12:43:55 2009 -0500

    drm/kms: add page flipping ioctl
    
    This adds a page flipping ioctl to the KMS API.  The ioctl takes an fb ID
    and a ctrc ID and flips the crtc to the given fb at the next vblank.
    The ioctl returns immediately but the flip doesn't happen until after
    any rendering that's currently queued up against the new framebuffer
    is done.  After submitting a page flip, any execbuffer involving the
    old front buffer will block until the flip is completed.
    
    Optionally, a vblank event can be generated when the swap eventually
    happens.
    
    Signed-off-by: Kristian Høgsberg <krh@bitplanet.net>
    Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit dad07ca71719598bc990dbdbeda763d15a10e98b
Author: Andres Salomon <dilinger@collabora.co.uk>
Date:   Tue Nov 17 14:41:25 2009 -0800

    drm: check return values in drm_version
    
    In drm_version, actually check the results from function calls so that
    we're not potentially passing garbage back to userspace.
    
    Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 140a45fc3253746e1e42feafc63509df5d90889e
Author: Andres Salomon <dilinger@collabora.co.uk>
Date:   Tue Nov 17 14:41:24 2009 -0800

    drm: replace DRM_COPY macro w/ a function
    
    Don't inline it; the compiler can figure it out.  Comments added that are
    based upon my interpretation of the code.  Hopefully they're correct. :)
    
    Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 156822f7175d9ceb9d7e808502d3c5de8841e047
Author: Andres Salomon <dilinger@collabora.co.uk>
Date:   Tue Nov 17 14:41:23 2009 -0800

    drm: kill more unused DRM macros
    
    There are a few more macros in drmP.h that are unused; DRM_GET_PRIV_SAREA,
    DRM_ARRAY_SIZE, and DRM_WAITCOUNT can go away completely.
    
    Unfortunately, DRM_COPY is still used in one place, but we can at least
    move it to where it's used.  It's an awful looking macro..
    
    [akpm: fix overeagerness]
    Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
    Cc: Dave Airlie <airlied@linux.ie>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 420a457088669e055e767dfb8468909cd1799cf9
Author: Andres Salomon <dilinger@collabora.co.uk>
Date:   Tue Nov 17 14:41:23 2009 -0800

    drm: kill some unused DRM_PROC macros from drmP.h
    
    i915_gem_proc.c appears to have been the last user of the DRM_PROC_*
    macros, and it has gone away.  The macros should die as well.
    
    Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4a9216453c8537a7f43a3b1708509b9dd271dc9f
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Nov 10 08:21:25 2009 +0000

    drm: when queuing an event with NEXTONMISS, return queued sequence to userspace
    
    If we queue a vblank event but miss it, we should return the actual
    sequence number we queued to userspace, so its event handling function
    will know which event to look for.
    
    Acked-by: Kristian Høgsberg <krh@bitplanet.net>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c9a9c5e02aedc1a2815877b0268f886d2640b771
Author: Kristian Høgsberg <krh@bitplanet.net>
Date:   Sat Sep 12 04:33:34 2009 +1000

    drm: Add async event synchronization for drmWaitVblank
    
    This patch adds a new flag to the drmWaitVblank ioctl, which asks the drm
    to return immediately and notify userspace when the specified vblank sequence
    happens by sending an event back on the drm fd.
    
    The event mechanism works with the other flags supported by the ioctls,
    specifically, the vblank sequence can be specified relatively or absolutely,
    and works for primary and seconday crtc.
    
    The signal field of the vblank request is used to provide user data,
    which will be sent back to user space in the vblank event.
    
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4efc50d697ed8d9a91f0005d922907a7b6c9290d
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Nov 10 08:21:25 2009 +0000

    drm: when queuing an event with NEXTONMISS, return queued sequence to userspace
    
    If we queue a vblank event but miss it, we should return the actual
    sequence number we queued to userspace, so its event handling function
    will know which event to look for.
    
    Acked-by: Kristian Høgsberg <krh@bitplanet.net>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fe625f137d28d1ebe22a71ee064ffab2841055a5
Merge: 6782cc7 7433874
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Nov 6 14:33:40 2009 +1000

    Merge branch 'drm-next' of ../drm-2.6 into drm-next

commit 6782cc7b615ae5f028783992b7fe43b53e4e786f
Merge: 4fe9676 a3fa632
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Nov 6 13:47:54 2009 +1000

    Merge branch 'drm-next' of ../drm-2.6 into drm-next

commit 5b8f0be0dce012d190a53d55240fe3fde6306476
Merge: 43bcd61 4fe9676
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Nov 5 15:04:06 2009 -0800

    Merge remote branch 'airlied/drm-next' into drm-intel-next

commit 43bcd61fae05fc6062b4f117c5adb1a72c9f8c57
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Nov 3 09:03:34 2009 +0000

    drm/i915: fix get_core_clock_speed for G33 class desktop chips
    
    Somehow the case for G33 got dropped while porting from ums code.
    This made a 400MHz chip into a 133MHz one which resulted in the
    unnecessary enabling of double wide pipe mode which in turn
    screwed up the overlay code.
    
    Nothing else (than the overlay code) seems to be affected.
    
    This fixes fdo.org bug #24835
    
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit c650156af34bffa3d3a62c9fe26eee595aab3fd1
Author: Zhenyu Wang <zhenyuw@linux.intel.com>
Date:   Tue Nov 3 18:57:21 2009 +0000

    drm/i915: Add display hotplug event on Ironlake
    
    Enable display hotplug irqs from Ibex Peak (PCH).
    
    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 01c66889c14aa163c49355b3be2ccfb214500599
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Oct 28 05:10:00 2009 +0000

    drm/i915: Add ACPI OpRegion support for Ironlake
    
    Add the support of ACPI opregion on Ironlake so that the backlight
    brightness can be adjusted by using ACPI interface
       >/sys/class/backlight/acpi_video0/brightness
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Tested-by: Zhao Yakui <yakui.zhao@intel.com>
    [zhenyuw: cleanups, fix typo for checking GSE irq and convert to
    current irq handling logic.]
    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 1dc7546d1a73664e5d117715b214bea9cae5951c
Author: Jesse Barnes <jbarnes@jbarnes-x200.(none)>
Date:   Mon Oct 19 10:08:17 2009 +0900

    drm/i915: enable self-refresh on 965
    
    Need to calculate the SR watermark and enable it.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit a4f45cf178f0d0ad4e516e020818b5f1c00e3d63
Author: Kristian Høgsberg <krh@bitplanet.net>
Date:   Mon Oct 19 14:35:30 2009 -0400

    drm/i915: Support 30 bit depth modes
    
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit f3cd474bb235f2331c1a6f579bdbf892386e5c7c
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Tue Oct 13 22:20:20 2009 +0100

    drm/i915: debugfs interface to manually reset the GPU
    
    Create a /debug/dri/%d/i915_wedged file to display the current wedged
    status, and to enable setting that value. On an i965, this will also
    trigger a GPU reset.
    
    Useful in order to attempt to recover from some error conditions that
    are not currently caught by the automatic hang detection code.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit aed5f1dc264e2bc87e8656dd6945e4b1e72ebdbc
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Oct 14 13:40:04 2009 +0100

    drm/i915: Use a single thread workqueue
    
    Our work is serialised so allocating per-cpu workqueues is overkill and
    a waste of resources.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit d0c3b04ae953fd3bf69f9b1430c22608d2d3b90d
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Oct 9 11:39:43 2009 +0800

    drm/i915: Replace DRM_DEBUG with DRM_DEBUG_KMS in DVO output code.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 3e0f27ed75369298176abdf2fbe59116b6587a56
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Oct 13 12:23:22 2009 -0700

    drm/i915: Enable the SDVO debug code, which is now under DEBUG_KMS.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 28c97730c36e06d5ba0c442156eb2154347cc3fe
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Oct 9 11:39:41 2009 +0800

    drm/i915: Replace DRM_DEBUG with DRM_DEBUG_KMS
    
    Replace the DRM_DEBUG with DRM_DEBUG_KMS in output device code.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 44d98a614267c81a04ba9c7a0427c3a628985b7d
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Fri Oct 9 11:39:40 2009 +0800

    drm/i915: Replace DRM_DEBUG with DRM_DEBUG_DRIVER
    
    Replace the DRM_DEBUG with DRM_DEBUG_DRIVER in generic i915 driver.
    Then the debug info can be obtained by adding the boot option of
    "drm.debug=0x02".
    
    At the same time the debug info in increase/decrease clock is also
    printed by using DRM_DEBUG_DRIVER instead of DRM_DEBUG_KMS.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 5c5a4359fe392b52b444134877fc4002be542b42
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sun Oct 4 15:00:36 2009 +0200

    drm/i915: overlay: kill one more unnecessary uninterruptible sleep
    
    I've simply overlooked one case in the conversion to interruptible
    sleeps. Rectify this.
    
    Also delete a leftover debug printk.
    
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 1df4b35b61df27fc5b173fe2789d976e40e1dc22
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Sep 15 22:57:38 2009 +0200

    drm/i915: kill i915_lp_ring_sync
    
    It's not needed anymore.
    
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 03f77ea5972e6a2363152aec692744cac824daba
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Sep 15 22:57:37 2009 +0200

    drm/i915: implement interruptible sleeps in the overlay code
    
    At least for the common case of userspace ioctls. When doing a
    modeset operation, the wait is still uninterruptible. But considering
    that failing to turn off the overlay when switching off the crtc it's
    running on hangs the chip, it doesn't complicate matters _very_
    much. There's just an unkillable X in addition to a black screen.
    BUG() about it and explain in the code.
    
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 5a5a0c64a99d7542c48c99d1a8bbb49e665842be
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Sep 15 22:57:36 2009 +0200

    drm/i915: implement fastpath for overlay flip waiting
    
    As long as the gpu can keep up, neither the cpu (waiting for gpu)
    nore the gpu (waiting for vblank to do an overlay flip) stalls.
    
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 240a2d12dfff98f8fa1332dc8424284d96f0801e
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Sep 15 22:57:35 2009 +0200

    drm/i915: fully switch off overlay when not in use
    
    Now that the cache flushing of the memory based overlay regs works,
    we can safely switch off the overlay. Beforehand it was only disabled
    (like in userspace).
    
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 02e792fbaadb75dec8e476a05b610e49908fc6a4
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Sep 15 22:57:34 2009 +0200

    drm/i915: implement drmmode overlay support v4
    
    This implements intel overlay support for kms via a device-specific
    ioctl. Thomas Hellstrom brought up the idea of a general ioctl (on
    dri-devel). We've reached the conclusion that such an infrastructure
    only makes sense when multiple kms overlay implementations exists,
    which atm don't (and it doesn't look like this is gonna change).
    
    Open issues:
    - Runs in sync with the gpu, i.e. unnecessary waiting. I've decided
      to wait on this because the hw tends to hang when changing something
      in this area. I left some dummy functions as infrastructure.
    - polyphase filtering uses a static table.
    - uses uninterruptible sleeps. Unfortunately the alternatives may
      unnecessarily wedged the hw if/when we timeout too early (and
      userspace only overloaded the batch buffers with stuff worth a few
      secs of gpu time).
    
    Changes since v1:
    - fix off-by-one misconception on my side. This fixes fullscreen
      playback.
    Changes since v2:
    - add underrun detection as spec'ed for i965.
    - flush caches properly, fixing visual corruptions.
    Changes since v4:
    - fix up cache flushing of overlay memory regs.
    - killed require_pipe_a logic - it hangs the chip.
    
    Tested-By: diego.abelenda@gmail.com (on a 865G)
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    [anholt: Resolved against the MADVISE ioctl going in before this one]
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit f0f8a9cecea322b215600d96cf0c1eb08343a4e9
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Sep 15 22:57:33 2009 +0200

    drm/i915: kill superflous IS_I855 macro
    
    It is identical to I85X. Use that one instead.
    
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    [anholt: fix conflicts against the display function pointer stuff]
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 48764bf43f746113fc77877d7e80f2df23ca4cbb
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Sep 15 22:57:32 2009 +0200

    drm/i915: add i915_lp_ring_sync helper
    
    This just waits until the hw passed the current ring position with
    cmd execution. This slightly changes the existing i915_wait_request
    function to make uninterruptible waiting possible - no point in
    returning to userspace while mucking around with the overlay, that
    piece of hw is just too fragile.
    
    Also replace a magic 0 with the symbolic constant (and kill the then
    superflous comment) while I was looking at the code.
    
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 7a9c906094de8b3dc227de448019dbc386cd25d4
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Sep 15 22:57:31 2009 +0200

    drm: make drm_mode_object_find typesafe
    
    I've wasted half a day hunting a bug that could easily be spotted by
    gcc. Prevent this from reoccurring.
    
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 97f5ab6651a996ecefed73e41684422f3b29d9a8
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Oct 8 10:16:48 2009 -0700

    drm/i915: add render standby support
    
    Render standy allows the GPU to power down the render unit when idle.
    In order for this to work, it needs a page of graphics memory to save
    state.  This patch allocates that page and enables the feature on
    supported chipsets.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 4fe9676d1ae6639b5749140eba052261d363366b
Merge: 273fad2 e29649d
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Nov 5 08:28:54 2009 +1000

    Merge branch 'drm-next' of ../drm-2.6 into drm-next

commit 273fad2b8248e7eea8fba39555434223dd9216a4
Merge: c182be3 ea1495a
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Oct 28 16:08:41 2009 +1000

    Merge branch 'drm-next' of ../drm-2.6 into drm-next

commit c182be37ed7cb04c344501b88b8fdb747016e6cf
Author: Kristian Høgsberg <krh@bitplanet.net>
Date:   Sat Sep 12 04:33:34 2009 +1000

    drm: Add async event synchronization for drmWaitVblank
    
    This patch adds a new flag to the drmWaitVblank ioctl, which asks the drm
    to return immediately and notify userspace when the specified vblank sequence
    happens by sending an event back on the drm fd.
    
    The event mechanism works with the other flags supported by the ioctls,
    specifically, the vblank sequence can be specified relatively or absolutely,
    and works for primary and seconday crtc.
    
    The signal field of the vblank request is used to provide user data,
    which will be sent back to user space in the vblank event.
    
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0a5c1e61dbaceb6ce56281a3128a6912b0dcd043
Author: Robert Noland <rnoland@2hip.net>
Date:   Tue Oct 20 07:23:07 2009 -0500

    drm/radeon: A bit of cleanup work on radeon_freelist_get()
    
    Fix the main loop to search all buffers before sleeping.
    Remove dead code
    
    Signed-off-by: Robert Noland <rnoland@2hip.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
--29444707-585066557-1260425828=:24701--
