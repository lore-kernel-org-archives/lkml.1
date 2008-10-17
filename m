Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbYJQV3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbYJQV3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 17:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYJQV3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 17:29:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49224 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314AbYJQV3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 17:29:40 -0400
Date: Fri, 17 Oct 2008 22:29:37 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] drm patches for 2.6.27-rc1
Message-ID: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-95108770-1224278977=:14817"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-95108770-1224278977=:14817
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT

Hi Linus,

This is a new tree, I had a conflict with your latest tree due to some
trivial cleanups you merged. I've added the fix for CVE-2008-3831 which is
unembargoed.

Please pull the 'drm-next' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-next

This contains two patches outside the DRM git tree to add exports for GEM
functionality while we await Nick Piggins vmap and shmem changes.

This update contains the following.

1. CVE-2008-3831 - fixes for memset on arbitrary memory via i915 on G33 hw and
above.
2. Intel GEM memory manager .
3. Opregion support for Intel Integrated chipsets.
4. Updated radeon driver with support for new chipsets + bugfixes
5. vblank reworking to save power and interrupts on intel/radeon GPUs.

Dave.

 arch/x86/mm/highmem_32.c               |    1 +
 drivers/gpu/drm/Kconfig                |    3 +-
 drivers/gpu/drm/Makefile               |    5 +-
 drivers/gpu/drm/drm_agpsupport.c       |   52 +-
 drivers/gpu/drm/drm_cache.c            |   69 +
 drivers/gpu/drm/drm_drv.c              |    6 +
 drivers/gpu/drm/drm_fops.c             |    8 +-
 drivers/gpu/drm/drm_gem.c              |  421 ++++++
 drivers/gpu/drm/drm_irq.c              |  464 +++++-
 drivers/gpu/drm/drm_memory.c           |    2 +
 drivers/gpu/drm/drm_mm.c               |    5 +-
 drivers/gpu/drm/drm_proc.c             |  135 ++-
 drivers/gpu/drm/drm_stub.c             |   11 +-
 drivers/gpu/drm/drm_sysfs.c            |    2 +-
 drivers/gpu/drm/i915/Makefile          |    7 +-
 drivers/gpu/drm/i915/i915_dma.c        |  332 +++--
 drivers/gpu/drm/i915/i915_drv.c        |  476 +------
 drivers/gpu/drm/i915/i915_drv.h        | 1180 +++++-----------
 drivers/gpu/drm/i915/i915_gem.c        | 2558 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_gem_debug.c  |  201 +++
 drivers/gpu/drm/i915/i915_gem_proc.c   |  292 ++++
 drivers/gpu/drm/i915/i915_gem_tiling.c |  257 ++++
 drivers/gpu/drm/i915/i915_irq.c        |  514 +++++--
 drivers/gpu/drm/i915/i915_opregion.c   |  371 +++++
 drivers/gpu/drm/i915/i915_reg.h        | 1417 ++++++++++++++++++
 drivers/gpu/drm/i915/i915_suspend.c    |  509 +++++++
 drivers/gpu/drm/mga/mga_drv.c          |   29 +-
 drivers/gpu/drm/mga/mga_drv.h          |    6 +-
 drivers/gpu/drm/mga/mga_irq.c          |   74 +-
 drivers/gpu/drm/mga/mga_state.c        |    2 +-
 drivers/gpu/drm/r128/r128_drv.c        |   29 +-
 drivers/gpu/drm/r128/r128_drv.h        |   11 +-
 drivers/gpu/drm/r128/r128_irq.c        |   55 +-
 drivers/gpu/drm/r128/r128_state.c      |    2 +-
 drivers/gpu/drm/radeon/radeon_cp.c     |   53 +-
 drivers/gpu/drm/radeon/radeon_drv.c    |   32 +-
 drivers/gpu/drm/radeon/radeon_drv.h    |   57 +-
 drivers/gpu/drm/radeon/radeon_irq.c    |  268 +++--
 drivers/gpu/drm/radeon/radeon_state.c  |    2 +-
 drivers/gpu/drm/sis/sis_mm.c           |   10 +-
 drivers/gpu/drm/via/via_drv.c          |   26 +-
 drivers/gpu/drm/via/via_drv.h          |   16 +-
 drivers/gpu/drm/via/via_irq.c          |  105 +-
 drivers/gpu/drm/via/via_mm.c           |    3 +-
 include/drm/drm.h                      |   63 +-
 include/drm/drmP.h                     |  249 +++-
 include/drm/drm_pciids.h               |   54 +-
 include/drm/i915_drm.h                 |  333 +++++
 mm/shmem.c                             |    1 +
 49 files changed, 8814 insertions(+), 1964 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_cache.c
 create mode 100644 drivers/gpu/drm/drm_gem.c
 create mode 100644 drivers/gpu/drm/i915/i915_gem.c
 create mode 100644 drivers/gpu/drm/i915/i915_gem_debug.c
 create mode 100644 drivers/gpu/drm/i915/i915_gem_proc.c
 create mode 100644 drivers/gpu/drm/i915/i915_gem_tiling.c
 create mode 100644 drivers/gpu/drm/i915/i915_opregion.c
 create mode 100644 drivers/gpu/drm/i915/i915_reg.h
 create mode 100644 drivers/gpu/drm/i915/i915_suspend.c

commit 4b40893918203ee1a1f6a114316c2a19c072e9bd
Author: Matthias Hopf <mhopf@suse.de>
Date:   Sat Oct 18 07:18:05 2008 +1000

    drm/i915: fix ioremap of a user address for non-root (CVE-2008-3831)
    
    Olaf Kirch noticed that the i915_set_status_page() function of the i915
    kernel driver calls ioremap with an address offset that is supplied by
    userspace via ioctl. The function zeroes the mapped memory via memset
    and tells the hardware about the address. Turns out that access to that
    ioctl is not restricted to root so users could probably exploit that to
    do nasty things. We haven't tried to write actual exploit code though.
    
    It only affects the Intel G33 series and newer.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9e0b97e37fddaf5419d8af24362015ab684eff7e
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Oct 17 09:29:14 2008 +1000

    drm: make CONFIG_DRM depend on CONFIG_SHMEM.
    
    This can be removed later when DRM doesn't depend on shmem.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit edc6f389f6ae9cb7621270a8ddbb1892bd8df125
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Oct 17 09:21:45 2008 +1000

    radeon: fix PCI bus mastering support enables.
    
    Someone noticed these registers moved around for later chips,
    so we redo the codepaths per-chip. PCIE chips don't appear to
    require explicit enables.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b2ceddfa52cbeb244b90096f1e8d3e9f7e0ce299
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Oct 17 09:19:33 2008 +1000

    radeon: add RS400 family support.
    
    This adds support for the RS400 family of IGPs for Intel CPUs.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f0738e92403466d45cfb5008da668260c77fff4b
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Oct 16 17:12:02 2008 +1000

    drm/radeon: add support for RS740 IGP chipsets.
    
    This adds support for the HS2100 IGP chipset.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b612eda98e4b4bae4c98a863f039bc89425f9039
Author: Eric Anholt <eric@anholt.net>
Date:   Wed Oct 15 00:05:58 2008 -0700

    i915: GM45 has GM965-style MCH setup.
    
    Fixes tiling swizzling mode failures that manifest in glReadPixels().
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6dbe2772d6af067845bab57be490c302f4490ac7
Author: Keith Packard <keithp@keithp.com>
Date:   Tue Oct 14 21:41:13 2008 -0700

    i915: Don't run retire work handler while suspended
    
    At leavevt and lastclose time, cancel any pending retire work handler
    invocation, and keep the retire work handler from requeuing itself if it is
    currently running.
    
    This patch restructures i915_gem_idle to perform all of these tasks instead
    of having both leavevt and lastclose call a sequence of functions.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ba1eb1d825fdef40f69871caf8e5842d00efbbc5
Author: Keith Packard <keithp@keithp.com>
Date:   Tue Oct 14 19:55:10 2008 -0700

    i915: Map status page cached for chips with GTT-based HWS location.
    
    This should improve performance by avoiding uncached reads by the CPU (the
    point of having a status page), and may improve stability.  This patch only
    affects G33, GM45 and G45 chips as those are the only ones using GTT-based
    HWS mappings.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 50aa253d820ad4577e2231202f2c8fd89f9dc4e6
Author: Keith Packard <keithp@keithp.com>
Date:   Tue Oct 14 17:20:35 2008 -0700

    i915: Fix up ring initialization to cover G45 oddities
    
    G45 appears quite sensitive to ring initialization register writes,
    sometimes leaving the HEAD register with the START register contents. Check
    to make sure HEAD is reset correctly when START is written, and fix it up,
    screaming loudly.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0cdad7e88a23910a911a3339ff2d70f8f952d7b8
Author: Keith Packard <keithp@keithp.com>
Date:   Tue Oct 14 17:19:38 2008 -0700

    i915: Use non-reserved status page index for breadcrumb
    
    Dwords 0 through 0x1f are reserved for use by the hardware. Move the GEM
    breadcrumb from 0x10 to 0x20 to keep out of this area.
    
    Signed-off-by: Keith Packard <keithp@keithp.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 630681d9a5314e6cf53d144f7f58b7c19862a7d3
Author: Eric Anholt <eric@anholt.net>
Date:   Mon Oct 6 15:14:12 2008 -0700

    drm: Increment dev_priv->irq_received so i915_gem_interrupts count works.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9bfbd5cb72c9edb8504a4a7a0aa89cdb2fcb4845
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Sep 15 15:00:33 2008 -0700

    drm: kill drm_device->irq
    
    Like the last patch but adds a macro to get at the irq value instead of
    dereferencing pdev directly.  Should  make things easier for the BSD guys and
    if we ever support non-PCI devices.
    
    Signed-off-by:  Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e0f0754ff6128570dcf38032f5bfb1f195e5bbee
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Oct 7 13:41:49 2008 +1000

    drm: wbinvd is cache coherent.
    
    doing an ipi for the wbinvd case isn't necessary.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e7d22bc3cb57126196c4f475d4e55aa44e151784
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Oct 7 13:40:36 2008 +1000

    i915: add missing return in error path.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 2bdf00b22154023ac312481583603f4724eb1401
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Oct 7 13:40:10 2008 +1000

    i915: fixup permissions on gem ioctls.
    
    init/entervt/leavevt should be root-only master ioctls.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3043c60c485ad694392d3f71bd7ef9f5c5f7cfdd
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Oct 2 12:24:47 2008 -0700

    drm: Clean up many sparse warnings in i915.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit bd88ee4c1b1c8fc8b78a0ba7b6235d230cea0d05
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Sep 23 14:50:57 2008 -0700

    drm: Use ioremap_wc in i915_driver instead of ioremap, since we always want WC.
    
    Fixes failure to map the ringbuffer when PAT tells us we don't get to do
    uncached on something that's already mapped WC, or something along those lines.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 28af0a2767412937e8424364a8ece9b230bdbc83
Author: Eric Anholt <eric@anholt.net>
Date:   Mon Sep 15 13:13:34 2008 -0700

    drm: G33-class hardware has a newer 965-style MCH (no DCC register).
    
    Fixes bad software fallback rendering in Mesa in dual-channel configurations.
    
    d9a2470012588dc5313a5ac8bb2f03575af00e99
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4f481ed22ec0d412336a13dc4477f6d0f3688882
Author: Eric Anholt <eric@anholt.net>
Date:   Wed Sep 10 14:22:49 2008 -0700

    drm: Avoid oops in GEM execbuffers with bad arguments.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d4e7b898c12b2b458323243abdd4a215f8f8f090
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Sep 9 11:40:34 2008 -0700

    DRM: Return -EBADF on bad object in flink, and return curent name if it exists.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit dbb19d302baa8ba518599701914f600935fc53fa
Author: Kristian Høgsberg <krh@redhat.com>
Date:   Wed Aug 20 11:04:27 2008 -0400

    i915 gem: install and uninstall irq handler in entervt and leavevt ioctls.
    
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c99b058f132388a666544d293392d52d1def6b12
Author: Kristian Høgsberg <krh@redhat.com>
Date:   Wed Aug 20 11:20:13 2008 -0400

    i915: Make use of sarea_priv conditional.
    
    We fail ioctls that depend on the sarea_priv with EINVAL.
    
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 546b0974c39657017407c86fe79811100b60700d
Author: Eric Anholt <eric@anholt.net>
Date:   Mon Sep 1 16:45:29 2008 -0700

    i915: Use struct_mutex to protect ring in GEM mode.
    
    In the conversion for GEM, we had stopped using the hardware lock to protect
    ring usage, since it was all internal to the DRM now.  However, some paths
    weren't converted to using struct_mutex to prevent multiple threads from
    concurrently working on the ring, in particular between the vblank swap handler
    and ioctls.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ed4c9c4acf948b42b138747fcb8843ecb1a24ce4
Author: Kristian Høgsberg <krh@redhat.com>
Date:   Wed Aug 20 11:08:52 2008 -0400

    i915: Add chip set ID param.
    
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 673a394b1e3b69be886ff24abfd6df97c52e8d08
Author: Eric Anholt <eric@anholt.net>
Date:   Wed Jul 30 12:06:12 2008 -0700

    drm: Add GEM ("graphics execution manager") to i915 driver.
    
    GEM allows the creation of persistent buffer objects accessible by the
    graphics device through new ioctls for managing execution of commands on the
    device.  The userland API is almost entirely driver-specific to ensure that
    any driver building on this model can easily map the interface to individual
    driver requirements.
    
    GEM is used by the 2d driver for managing its internal state allocations and
    will be used for pixmap storage to reduce memory consumption and enable
    zero-copy GLX_EXT_texture_from_pixmap, and in the 3d driver is used to enable
    GL_EXT_framebuffer_object and GL_ARB_pixel_buffer_object.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d1d8c925b71dd6753bf438f9e14a9e5c5183bcc6
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Aug 21 12:53:33 2008 -0700

    Export kmap_atomic_pfn for DRM-GEM.
    
    The driver would like to map IO space directly for copying data in when
    appropriate, to avoid CPU cache flushing for streaming writes.
    kmap_atomic_pfn lets us avoid IPIs associated with ioremap for this process.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 395e0ddc44005ced5e4fed9bfc2e4bdf63d37627
Author: Keith Packard <keithp@keithp.com>
Date:   Fri Jun 20 00:08:06 2008 -0700

    Export shmem_file_setup for DRM-GEM
    
    GEM needs to create shmem files to back buffer objects.  Though currently
    creation of files for objects could have been driven from userland, the
    modesetting work will require allocation of buffer objects before userland
    is running, for boot-time message display.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Cc: Nick Piggin <npiggin@suse.de>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0a3e67a4caac273a3bfc4ced3da364830b1ab241
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Sep 30 12:14:26 2008 -0700

    drm: Rework vblank-wait handling to allow interrupt reduction.
    
    Previously, drivers supporting vblank interrupt waits would run the interrupt
    all the time, or all the time that any 3d client was running, preventing the
    CPU from sleeping for long when the system was otherwise idle.  Now, interrupts
    are disabled any time that no client is waiting on a vblank event. The new
    method uses vblank counters on the chipsets when the interrupts are turned
    off, rather than counting interrupts, so that we can continue to present
    accurate vblank numbers.
    
    Co-author: Michel Dänzer <michel@tungstengraphics.com>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 2df68b439fcb97a4c55f81516206ef4ee325e28d
Author: David Howells <dhowells@redhat.com>
Date:   Tue Sep 2 11:03:14 2008 +1000

    drm/cred: wrap task credential accesses in the drm driver.
    
    Wrap access to task credentials so that they can be separated more easily from
    the task_struct during the introduction of COW creds.
    
    Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().
    
    Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
    sense to use RCU directly rather than a convenient wrapper; these will be
    addressed by later patches.
    
    Signed-off-by: David Howells <dhowells@redhat.com>
    Reviewed-by: James Morris <jmorris@namei.org>
    Acked-by: Serge Hallyn <serue@us.ibm.com>
    Signed-off-by: David Airlie <airlied@redhat.com>

commit b9bfdfe6703eb089839d48316a79c84924a3c335
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Aug 25 15:16:19 2008 -0700

    new chip name is GM45
    
    Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
    
    i915: official name for GM45 chipset
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 317c35d1446f68b34d4de4e1100fc01680bd4877
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Aug 25 15:11:06 2008 -0700

    separate i915 suspend/resume functions into their own file
    
    [Patch against drm-next.  Consider this a trial balloon for our new Linux
    development model.]
    
    This is a big chunk of code.  Separating it out makes it easier to change
    without churn on the main i915_drv.c file (and there will be churn as we
    fix bugs and add things like kernel mode setting).  Also makes it easier
    to share this file with BSD.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6b79d521e07aae155303a992245abb539974dbaa
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Sep 2 10:10:16 2008 +1000

    radeon: fix writeback across suspend/resume.
    
    Make writeback not get disabled on resume.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 38eda21189b414b1520ea7aa0e71220796f7008f
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Sep 2 10:06:06 2008 +1000

    drm: fix sysfs error path.
    
    Pointed out by Roel Kluin on dri-devel.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit dfcf96d09cff63c9aaa8e7c98bbc71e5073b1377
Author: Adrian Bunk <bunk@kernel.org>
Date:   Sun Aug 24 17:11:22 2008 +1000

    FB_SIS=m, DRM_SIS=y is not a legal configuration.
    
    Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8ee1c3db9075cb3211352e737e0feb98fd733b20
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Tue Aug 5 19:37:25 2008 +0100

    Add Intel ACPI IGD OpRegion support
    
    This adds the support necessary for allowing ACPI backlight control to
    work on some newer Intel-based graphics systems. Tested on Thinkpad T61
    and HP 2510p hardware.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 398c9cb20b5c6c5d1313912b937d653a46fec578
Author: Keith Packard <keithp@keithp.com>
Date:   Wed Jul 30 13:03:43 2008 -0700

    i915: Initialize hardware status page at device load when possible.
    
    Some chips were unstable with repeated setup/teardown of the hardware status
    page.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d3a6d4467ca44833bcb4ba1893a7aeaae939e4d5
Author: Keith Packard <keithp@keithp.com>
Date:   Wed Jul 30 12:21:20 2008 -0700

    i915: Track progress inside of batchbuffers for determining wedgedness.
    
    This avoids early termination for long-running commands.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ed4cb4142b242d8090d3811d5eb4abf6aa985bc8
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Jul 29 12:10:39 2008 -0700

    i915: Add support for MSI and interrupt mitigation.
    
    Previous attempts at interrupt mitigation had been foiled by i915_wait_irq's
    failure to update the sarea seqno value when the status page indicated that
    the seqno had already been passed.  MSI support has been seen to cut CPU
    costs by up to 40% in some workloads by avoiding other expensive interrupt
    handlers for frequent graphics interrupts.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 585fb111348f7cdc30c6a1b903987612ddeafb23
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Jul 29 11:54:06 2008 -0700

    i915: Use more consistent names for regs, and store them in a separate file.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 962d4fd7273e144ae003ddb90138ae4b80567c70
Author: Keith Packard <keithp@keithp.com>
Date:   Wed Jul 30 12:36:08 2008 -0700

    i915: Ignore X server provided mmio address
    
    It is already correctly detected by the kernel for use in suspend/resume.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0790d5e148c0747499742a3c09ba5f1c07f9ed0d
Author: Keith Packard <keithp@keithp.com>
Date:   Wed Jul 30 12:28:47 2008 -0700

    i915: remove settable use_mi_batchbuffer_start
    
    The driver can know what hardware requires MI_BATCH_BUFFER vs
    MI_BATCH_BUFFER_START; there's no reason to let user mode configure this.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 48f185d0e0f3adde81117ead074e5e6ec5548449
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jul 30 12:29:38 2008 -0700

    SiS DRM: fix a pointer cast warning
    
    Fix a pointer cast warning in the SIS DRM code.
    
    This was introduced in patch ce65a44de07f73ceda1749812b75086b7add408d.
    
    Signed-off-by: David Howells <dhowells@redhat.com>
    Cc: Dave Airlie <airlied@linux.ie>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6bb9e4bff5c6fd908d907222108ef5650d77972f
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jul 30 12:29:37 2008 -0700

    SiS DRM: fix the memory allocator if the SIS FB is built as a module
    
    Fix the SIS DRM memory allocator if the SIS FB built as a module.  The SIS DRM
    code initialises the mm allocation hooks, but _only_ if the SIS FB is not
    built as a module because it depends on CONFIG_FB_SIS, and that's unset if the
    SIS FB is not built in.  It must check CONFIG_FB_SIS_MODULE as well.
    
    Signed-off-by: David Howells <dhowells@redhat.com>
    Cc: Dave Airlie <airlied@linux.ie>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ddb7f4cb819fb6b9df261ce4c80b3c6f4852620d
Author: Carlos R. Mafra <crmafra2@gmail.com>
Date:   Wed Jul 30 12:29:37 2008 -0700

    drm: remove #define's for non-linux systems
    
    There is no point in considering FreeBSD et al.  in the linux kernel
    source code.
    
    Signed-off-by: Carlos R. Mafra <crmafra@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
--29444707-95108770-1224278977=:14817--
