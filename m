Return-Path: <linux-kernel-owner+w=401wt.eu-S1757091AbYJQAAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbYJQAAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbYJPXzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:55:53 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:57376 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164AbYJPXzu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u1M2TxYJkX7R7eUAdO4NRsqAbxavo8He6j/X22pMGHzZdweLxqwa/si1jp+rBcsHVB
         s30+vPOiJYSwBbhpv+/890NhecfmDB55s7oWcJ9WHswxfW/hJIqSQjLCP6XmWFQMOUWq
         eXI627lZpO+pbbaBRkPJeLNoz6c4yo02xngQ8=
Message-ID: <21d7e9970810161655r234e7bees2628af4b982a01f0@mail.gmail.com>
Date: Fri, 17 Oct 2008 09:55:48 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Dave Airlie" <airlied@linux.ie>
Subject: Re: [git pull] drm git tree for linux-2.6.28-rc1
Cc: torvalds@linux-foundation.org, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <alpine.DEB.0.82.0810170031510.16504@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <alpine.DEB.0.82.0810170031510.16504@skynet.skynet.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 9:38 AM, Dave Airlie <airlied@linux.ie> wrote:
>
> Hi Linus,
>
> Please pull the 'drm-next' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-next
>
> This contains two patches outside the DRM tree to export functionality for
> GEM. These can go away when Nick Piggins vmap and mem allocator
> functionality get moving.
>
> This update mainly contains:
>
> 1. vblank rework, which allows turning off irqs on laptops a lot smarter.
> 2. opregion support from mjg59 - to allow hotkeys on Intel hw.
> 3. radeon updates for new chipsets + PCI bus mastering fix

4. The Intel GEM memory manager. i.e. the major component.

Dave.

>
> Dave.
>
>  arch/x86/mm/highmem_32.c               |    1 +
>  drivers/gpu/drm/Kconfig                |    3 +-
>  drivers/gpu/drm/Makefile               |    5 +-
>  drivers/gpu/drm/drm_agpsupport.c       |   52 +-
>  drivers/gpu/drm/drm_cache.c            |   69 +
>  drivers/gpu/drm/drm_drv.c              |    6 +
>  drivers/gpu/drm/drm_fops.c             |    8 +-
>  drivers/gpu/drm/drm_gem.c              |  421 ++++++
>  drivers/gpu/drm/drm_irq.c              |  464 +++++-
>  drivers/gpu/drm/drm_memory.c           |    2 +
>  drivers/gpu/drm/drm_mm.c               |    5 +-
>  drivers/gpu/drm/drm_proc.c             |  135 ++-
>  drivers/gpu/drm/drm_stub.c             |   11 +-
>  drivers/gpu/drm/drm_sysfs.c            |    2 +-
>  drivers/gpu/drm/i915/Makefile          |    7 +-
>  drivers/gpu/drm/i915/i915_dma.c        |  330 +++--
>  drivers/gpu/drm/i915/i915_drv.c        |  476 +------
>  drivers/gpu/drm/i915/i915_drv.h        | 1180 +++++-----------
>  drivers/gpu/drm/i915/i915_gem.c        | 2558 ++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/i915/i915_gem_debug.c  |  201 +++
>  drivers/gpu/drm/i915/i915_gem_proc.c   |  292 ++++
>  drivers/gpu/drm/i915/i915_gem_tiling.c |  257 ++++
>  drivers/gpu/drm/i915/i915_irq.c        |  514 +++++--
>  drivers/gpu/drm/i915/i915_opregion.c   |  371 +++++
>  drivers/gpu/drm/i915/i915_reg.h        | 1417 ++++++++++++++++++
>  drivers/gpu/drm/i915/i915_suspend.c    |  509 +++++++
>  drivers/gpu/drm/mga/mga_drv.c          |   29 +-
>  drivers/gpu/drm/mga/mga_drv.h          |    6 +-
>  drivers/gpu/drm/mga/mga_irq.c          |   74 +-
>  drivers/gpu/drm/mga/mga_state.c        |    2 +-
>  drivers/gpu/drm/r128/r128_drv.c        |   29 +-
>  drivers/gpu/drm/r128/r128_drv.h        |   11 +-
>  drivers/gpu/drm/r128/r128_irq.c        |   55 +-
>  drivers/gpu/drm/r128/r128_state.c      |    2 +-
>  drivers/gpu/drm/radeon/radeon_cp.c     |   53 +-
>  drivers/gpu/drm/radeon/radeon_drv.c    |   32 +-
>  drivers/gpu/drm/radeon/radeon_drv.h    |   57 +-
>  drivers/gpu/drm/radeon/radeon_irq.c    |  268 +++--
>  drivers/gpu/drm/radeon/radeon_state.c  |    2 +-
>  drivers/gpu/drm/sis/sis_mm.c           |   10 +-
>  drivers/gpu/drm/via/via_drv.c          |   26 +-
>  drivers/gpu/drm/via/via_drv.h          |   16 +-
>  drivers/gpu/drm/via/via_irq.c          |  105 +-
>  drivers/gpu/drm/via/via_mm.c           |    3 +-
>  include/drm/drm.h                      |   63 +-
>  include/drm/drmP.h                     |  249 +++-
>  include/drm/drm_pciids.h               |   54 +-
>  include/drm/i915_drm.h                 |  333 +++++
>  mm/shmem.c                             |    1 +
>  49 files changed, 8813 insertions(+), 1963 deletions(-)
>  create mode 100644 drivers/gpu/drm/drm_cache.c
>  create mode 100644 drivers/gpu/drm/drm_gem.c
>  create mode 100644 drivers/gpu/drm/i915/i915_gem.c
>  create mode 100644 drivers/gpu/drm/i915/i915_gem_debug.c
>  create mode 100644 drivers/gpu/drm/i915/i915_gem_proc.c
>  create mode 100644 drivers/gpu/drm/i915/i915_gem_tiling.c
>  create mode 100644 drivers/gpu/drm/i915/i915_opregion.c
>  create mode 100644 drivers/gpu/drm/i915/i915_reg.h
>  create mode 100644 drivers/gpu/drm/i915/i915_suspend.c
>
> commit 9d512dc0c924f3c75e8d8446c32b4ef77fe15913
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Fri Oct 17 09:29:14 2008 +1000
>
>    drm: make CONFIG_DRM depend on CONFIG_SHMEM.
>
>    This can be removed later when DRM doesn't depend on shmem.
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit e0a92262bdaa9b248a676723cad403285fe35783
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Fri Oct 17 09:21:45 2008 +1000
>
>    radeon: fix PCI bus mastering support enables.
>
>    Someone noticed these registers moved around for later chips,
>    so we redo the codepaths per-chip. PCIE chips don't appear to
>    require explicit enables.
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit fb2fadbfea214c1d7395beef136761bd22c2d5fb
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Fri Oct 17 09:19:33 2008 +1000
>
>    radeon: add RS400 family support.
>
>    This adds support for the RS400 family of IGPs for Intel CPUs.
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 7ade062d9cb62fdaee02fbb88c8a0911659f6e52
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Thu Oct 16 17:12:02 2008 +1000
>
>    drm/radeon: add support for RS740 IGP chipsets.
>
>    This adds support for the HS2100 IGP chipset.
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit b379ef538c692692a6dd2c60d27e738b06a162b3
> Author: Eric Anholt <eric@anholt.net>
> Date:   Wed Oct 15 00:05:58 2008 -0700
>
>    i915: GM45 has GM965-style MCH setup.
>
>    Fixes tiling swizzling mode failures that manifest in glReadPixels().
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit e998d8c1d1773ef074149aff27791139709724c7
> Author: Keith Packard <keithp@keithp.com>
> Date:   Tue Oct 14 21:41:13 2008 -0700
>
>    i915: Don't run retire work handler while suspended
>
>    At leavevt and lastclose time, cancel any pending retire work handler
>    invocation, and keep the retire work handler from requeuing itself if it is
>    currently running.
>
>    This patch restructures i915_gem_idle to perform all of these tasks instead
>    of having both leavevt and lastclose call a sequence of functions.
>
>    Signed-off-by: Keith Packard <keithp@keithp.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit b23f10462fad09bb8c9aa27e0f6ef58df295623b
> Author: Keith Packard <keithp@keithp.com>
> Date:   Tue Oct 14 19:55:10 2008 -0700
>
>    i915: Map status page cached for chips with GTT-based HWS location.
>
>    This should improve performance by avoiding uncached reads by the CPU (the
>    point of having a status page), and may improve stability.  This patch only
>    affects G33, GM45 and G45 chips as those are the only ones using GTT-based
>    HWS mappings.
>
>    Signed-off-by: Keith Packard <keithp@keithp.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 56c994020d1aa2fbcd3457c1f369b18fe14167af
> Author: Keith Packard <keithp@keithp.com>
> Date:   Tue Oct 14 17:20:35 2008 -0700
>
>    i915: Fix up ring initialization to cover G45 oddities
>
>    G45 appears quite sensitive to ring initialization register writes,
>    sometimes leaving the HEAD register with the START register contents. Check
>    to make sure HEAD is reset correctly when START is written, and fix it up,
>    screaming loudly.
>
>    Signed-off-by: Keith Packard <keithp@keithp.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit fc57b4cf6a0f46f2f99065b627a574e788f844c7
> Author: Keith Packard <keithp@keithp.com>
> Date:   Tue Oct 14 17:19:38 2008 -0700
>
>    i915: Use non-reserved status page index for breadcrumb
>
>    Dwords 0 through 0x1f are reserved for use by the hardware. Move the GEM
>    breadcrumb from 0x10 to 0x20 to keep out of this area.
>
>    Signed-off-by: Keith Packard <keithp@keithp.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit cded96bf710f0df960adb64e34f347b955b0b373
> Author: Eric Anholt <eric@anholt.net>
> Date:   Mon Oct 6 15:14:12 2008 -0700
>
>    drm: Increment dev_priv->irq_received so i915_gem_interrupts count works.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 5fed53a040bb697c952f765884f2afb3d89122b7
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Mon Sep 15 15:00:33 2008 -0700
>
>    drm: kill drm_device->irq
>
>    Like the last patch but adds a macro to get at the irq value instead of
>    dereferencing pdev directly.  Should  make things easier for the BSD guys and
>    if we ever support non-PCI devices.
>
>    Signed-off-by:  Jesse Barnes <jbarnes@virtuousgeek.org>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit dd6737d474e09d735619cf2cb67bf7d19b04289e
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Tue Oct 7 13:41:49 2008 +1000
>
>    drm: wbinvd is cache coherent.
>
>    doing an ipi for the wbinvd case isn't necessary.
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 651fd6ce9892b7f3b7e1b95c2e97a67cc4ee88ef
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Tue Oct 7 13:40:36 2008 +1000
>
>    i915: add missing return in error path.
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 6815a878e90d501f1c31f2344610fbbc62a89ce3
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Tue Oct 7 13:40:10 2008 +1000
>
>    i915: fixup permissions on gem ioctls.
>
>    init/entervt/leavevt should be root-only master ioctls.
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 647431866fdb5e3193d1a4a03f62eebe92ef8dbf
> Author: Eric Anholt <eric@anholt.net>
> Date:   Thu Oct 2 12:24:47 2008 -0700
>
>    drm: Clean up many sparse warnings in i915.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 94cd4fa9481dce08b3f2162c2909e9b6122562d4
> Author: Eric Anholt <eric@anholt.net>
> Date:   Tue Sep 23 14:50:57 2008 -0700
>
>    drm: Use ioremap_wc in i915_driver instead of ioremap, since we always want WC.
>
>    Fixes failure to map the ringbuffer when PAT tells us we don't get to do
>    uncached on something that's already mapped WC, or something along those lines.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 84bcd4fc29560148b437a7b8e21a43ee159441e8
> Author: Eric Anholt <eric@anholt.net>
> Date:   Mon Sep 15 13:13:34 2008 -0700
>
>    drm: G33-class hardware has a newer 965-style MCH (no DCC register).
>
>    Fixes bad software fallback rendering in Mesa in dual-channel configurations.
>
>    d9a2470012588dc5313a5ac8bb2f03575af00e99
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 1d02a783be8198b708aa9d51615b06910e597496
> Author: Eric Anholt <eric@anholt.net>
> Date:   Wed Sep 10 14:22:49 2008 -0700
>
>    drm: Avoid oops in GEM execbuffers with bad arguments.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 668f8c23eac44fdcdd4fa6b2f2b21dd895de376b
> Author: Eric Anholt <eric@anholt.net>
> Date:   Tue Sep 9 11:40:34 2008 -0700
>
>    DRM: Return -EBADF on bad object in flink, and return curent name if it exists.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 3eb83c9391a4af9a788d33d31c0b4c69514d23cd
> Author: Kristian Høgsberg <krh@redhat.com>
> Date:   Wed Aug 20 11:04:27 2008 -0400
>
>    i915 gem: install and uninstall irq handler in entervt and leavevt ioctls.
>
>    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 903f763e1b8f5fcc54ef8684e2568a0d0bd69bed
> Author: Kristian Høgsberg <krh@redhat.com>
> Date:   Wed Aug 20 11:20:13 2008 -0400
>
>    i915: Make use of sarea_priv conditional.
>
>    We fail ioctls that depend on the sarea_priv with EINVAL.
>
>    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 811c552c21f3d7fca8eb647ccf0d303378ccea7d
> Author: Eric Anholt <eric@anholt.net>
> Date:   Mon Sep 1 16:45:29 2008 -0700
>
>    i915: Use struct_mutex to protect ring in GEM mode.
>
>    In the conversion for GEM, we had stopped using the hardware lock to protect
>    ring usage, since it was all internal to the DRM now.  However, some paths
>    weren't converted to using struct_mutex to prevent multiple threads from
>    concurrently working on the ring, in particular between the vblank swap handler
>    and ioctls.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit fe2626337a28c50889bcb8b9065f4ae9402d6f62
> Author: Kristian Høgsberg <krh@redhat.com>
> Date:   Wed Aug 20 11:08:52 2008 -0400
>
>    i915: Add chip set ID param.
>
>    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 10413aa13c3780be5cc1eb57517c63af8556790a
> Author: Eric Anholt <eric@anholt.net>
> Date:   Wed Jul 30 12:06:12 2008 -0700
>
>    drm: Add GEM ("graphics execution manager") to i915 driver.
>
>    GEM allows the creation of persistent buffer objects accessible by the
>    graphics device through new ioctls for managing execution of commands on the
>    device.  The userland API is almost entirely driver-specific to ensure that
>    any driver building on this model can easily map the interface to individual
>    driver requirements.
>
>    GEM is used by the 2d driver for managing its internal state allocations and
>    will be used for pixmap storage to reduce memory consumption and enable
>    zero-copy GLX_EXT_texture_from_pixmap, and in the 3d driver is used to enable
>    GL_EXT_framebuffer_object and GL_ARB_pixel_buffer_object.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit da4d1b26db844139b19119596956591ee920dc08
> Author: Eric Anholt <eric@anholt.net>
> Date:   Thu Aug 21 12:53:33 2008 -0700
>
>    Export kmap_atomic_pfn for DRM-GEM.
>
>    The driver would like to map IO space directly for copying data in when
>    appropriate, to avoid CPU cache flushing for streaming writes.
>    kmap_atomic_pfn lets us avoid IPIs associated with ioremap for this process.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 0b735f67af4ca0cb48c78a86587c430506583b20
> Author: Keith Packard <keithp@keithp.com>
> Date:   Fri Jun 20 00:08:06 2008 -0700
>
>    Export shmem_file_setup for DRM-GEM
>
>    GEM needs to create shmem files to back buffer objects.  Though currently
>    creation of files for objects could have been driven from userland, the
>    modesetting work will require allocation of buffer objects before userland
>    is running, for boot-time message display.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Cc: Nick Piggin <npiggin@suse.de>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit b3b0cc9984694841aeba4ee11f6f399391acc322
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Tue Sep 30 12:14:26 2008 -0700
>
>    drm: Rework vblank-wait handling to allow interrupt reduction.
>
>    Previously, drivers supporting vblank interrupt waits would run the interrupt
>    all the time, or all the time that any 3d client was running, preventing the
>    CPU from sleeping for long when the system was otherwise idle.  Now, interrupts
>    are disabled any time that no client is waiting on a vblank event. The new
>    method uses vblank counters on the chipsets when the interrupts are turned
>    off, rather than counting interrupts, so that we can continue to present
>    accurate vblank numbers.
>
>    Co-author: Michel Dänzer <michel@tungstengraphics.com>
>    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 15bc50795d4762ee6e5ee12d55ed3c3bc340258a
> Author: David Howells <dhowells@redhat.com>
> Date:   Tue Sep 2 11:03:14 2008 +1000
>
>    drm/cred: wrap task credential accesses in the drm driver.
>
>    Wrap access to task credentials so that they can be separated more easily from
>    the task_struct during the introduction of COW creds.
>
>    Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().
>
>    Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
>    sense to use RCU directly rather than a convenient wrapper; these will be
>    addressed by later patches.
>
>    Signed-off-by: David Howells <dhowells@redhat.com>
>    Reviewed-by: James Morris <jmorris@namei.org>
>    Acked-by: Serge Hallyn <serue@us.ibm.com>
>    Signed-off-by: David Airlie <airlied@redhat.com>
>
> commit c19fe91b2ef616f1eb5d44b8b1058bd5fb65b5f3
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Mon Aug 25 15:16:19 2008 -0700
>
>    new chip name is GM45
>
>    Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
>
>    i915: official name for GM45 chipset
>
>    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
>    Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 1e836c73bfb9b01fd52cf67737211cc06f6c54b6
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Mon Aug 25 15:11:06 2008 -0700
>
>    separate i915 suspend/resume functions into their own file
>
>    [Patch against drm-next.  Consider this a trial balloon for our new Linux
>    development model.]
>
>    This is a big chunk of code.  Separating it out makes it easier to change
>    without churn on the main i915_drv.c file (and there will be churn as we
>    fix bugs and add things like kernel mode setting).  Also makes it easier
>    to share this file with BSD.
>
>    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 641d7c36fc0a10842081494ea69710e6468e327d
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Tue Sep 2 10:10:16 2008 +1000
>
>    radeon: fix writeback across suspend/resume.
>
>    Make writeback not get disabled on resume.
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit b9b60bbd9b3abfb4006d8743b498195aa6ce501a
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Tue Sep 2 10:06:06 2008 +1000
>
>    drm: fix sysfs error path.
>
>    Pointed out by Roel Kluin on dri-devel.
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 44a2aa414690b6405eca35f7e36d21f4cb5c5e0c
> Author: Adrian Bunk <bunk@kernel.org>
> Date:   Sun Aug 24 17:11:22 2008 +1000
>
>    FB_SIS=m, DRM_SIS=y is not a legal configuration.
>
>    Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
>    Signed-off-by: Adrian Bunk <bunk@kernel.org>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit cc24e799bcc6673727244ee8b05a914fc44573b4
> Author: Matthew Garrett <mjg59@srcf.ucam.org>
> Date:   Tue Aug 5 19:37:25 2008 +0100
>
>    Add Intel ACPI IGD OpRegion support
>
>    This adds the support necessary for allowing ACPI backlight control to
>    work on some newer Intel-based graphics systems. Tested on Thinkpad T61
>    and HP 2510p hardware.
>
>    Signed-off-by: Matthew Garrett <mjg@redhat.com>
>    Signed-off-by: Dave Airlie <airlied@linux.ie>
>
> commit bc2b8d52655557c5772eff58686eb12351b7943d
> Author: Keith Packard <keithp@keithp.com>
> Date:   Wed Jul 30 13:03:43 2008 -0700
>
>    i915: Initialize hardware status page at device load when possible.
>
>    Some chips were unstable with repeated setup/teardown of the hardware status
>    page.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit fd6dbbcdd6af3a0c0b094d9ef5765a2d14edd68d
> Author: Keith Packard <keithp@keithp.com>
> Date:   Wed Jul 30 12:21:20 2008 -0700
>
>    i915: Track progress inside of batchbuffers for determining wedgedness.
>
>    This avoids early termination for long-running commands.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 25188ce88236ca87a05c3b78c7bb39c24610b2f5
> Author: Eric Anholt <eric@anholt.net>
> Date:   Tue Jul 29 12:10:39 2008 -0700
>
>    i915: Add support for MSI and interrupt mitigation.
>
>    Previous attempts at interrupt mitigation had been foiled by i915_wait_irq's
>    failure to update the sarea seqno value when the status page indicated that
>    the seqno had already been passed.  MSI support has been seen to cut CPU
>    costs by up to 40% in some workloads by avoiding other expensive interrupt
>    handlers for frequent graphics interrupts.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 7aaf50415cbd7b7722118323d0f14c6084727730
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Tue Jul 29 11:54:06 2008 -0700
>
>    i915: Use more consistent names for regs, and store them in a separate file.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit ac250e9d7b9cd17181a10ab7ca92f9227b8dfbbb
> Author: Keith Packard <keithp@keithp.com>
> Date:   Wed Jul 30 12:36:08 2008 -0700
>
>    i915: Ignore X server provided mmio address
>
>    It is already correctly detected by the kernel for use in suspend/resume.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit cba9f68955b2e578147c8589e0c6404172dc5a41
> Author: Keith Packard <keithp@keithp.com>
> Date:   Wed Jul 30 12:28:47 2008 -0700
>
>    i915: remove settable use_mi_batchbuffer_start
>
>    The driver can know what hardware requires MI_BATCH_BUFFER vs
>    MI_BATCH_BUFFER_START; there's no reason to let user mode configure this.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 5f4b8116eb2908c9b35f1aa9f60be4e9d54daa1e
> Author: David Howells <dhowells@redhat.com>
> Date:   Wed Jul 30 12:29:38 2008 -0700
>
>    SiS DRM: fix a pointer cast warning
>
>    Fix a pointer cast warning in the SIS DRM code.
>
>    This was introduced in patch ce65a44de07f73ceda1749812b75086b7add408d.
>
>    Signed-off-by: David Howells <dhowells@redhat.com>
>    Cc: Dave Airlie <airlied@linux.ie>
>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 4a5b640906ec824d5f22ca9257b8567fc7de5260
> Author: David Howells <dhowells@redhat.com>
> Date:   Wed Jul 30 12:29:37 2008 -0700
>
>    SiS DRM: fix the memory allocator if the SIS FB is built as a module
>
>    Fix the SIS DRM memory allocator if the SIS FB built as a module.  The SIS DRM
>    code initialises the mm allocation hooks, but _only_ if the SIS FB is not
>    built as a module because it depends on CONFIG_FB_SIS, and that's unset if the
>    SIS FB is not built in.  It must check CONFIG_FB_SIS_MODULE as well.
>
>    Signed-off-by: David Howells <dhowells@redhat.com>
>    Cc: Dave Airlie <airlied@linux.ie>
>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 38e0b1a66b39fce7ceb468b067b04350c17a34bf
> Author: Carlos R. Mafra <crmafra2@gmail.com>
> Date:   Wed Jul 30 12:29:37 2008 -0700
>
>    drm: remove #define's for non-linux systems
>
>    There is no point in considering FreeBSD et al.  in the linux kernel
>    source code.
>
>    Signed-off-by: Carlos R. Mafra <crmafra@gmail.com>
>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
