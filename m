Return-Path: <linux-kernel-owner+w=401wt.eu-S1765220AbZFLVpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765220AbZFLVpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933109AbZFLVpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:45:41 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:49789 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791AbZFLVpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aQmnTcn4SOFB6lTjEIXa+MFToAYAd4K20dzmPgg4PysfTu1RdzXl1MAyqES79Tqt8P
         FhwgaPpAXEzMostue0F62uPSMcaiWEQvZZOcbHwfvNkb0bOVc/cnW72Q9OrEX2weKEm3
         Nc3UM3Y6/zABID+3qqbK9nO42AB6Joy+1o51Q=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0906120720410.11737@skynet.skynet.ie>
References: <alpine.DEB.2.00.0906120720410.11737@skynet.skynet.ie>
Date: Sat, 13 Jun 2009 07:45:40 +1000
Message-ID: <21d7e9970906121445j503671c5yedbd9cecf20f0643@mail.gmail.com>
Subject: Re: [git pull] drm v2.6.31 merge (part 1)
From: Dave Airlie <airlied@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 4:28 PM, Dave Airlie<airlied@linux.ie> wrote:
>
> Hi Linus,
>
> Please pull the 'drm-linus' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
>

Did I do something wrong again? or are you just holding off on this, didn't see
it hit the last bunch of merges.

Dave.

> This contains the Intel tree merge (merged properly I haven't rebased or
> touched it), which contains numerous GEM bugfixes + support for a new
> chipset. AMD patches for new r600 chipset support. A more flexible drm
> debugging system to decrease the firehose effect enabling drm debugging
> has, it also contains some paving the way patches for part 2 of the merge.
>
> It also contains one AGP patch for supporting those new chips, and a PNP
> patch to add a new interface that intel kms relies on now, all the
> signoffs for the pnp code should be correct.
>
> Part 2 will contains an initial radeon KMS driver and the TTM memory
> manager, its quite large so I don't want to include it all in this pull.
> The initial radeon KMS code enable switch will hide under staging for now
> for one driver release while we stabilise it in-tree, its not in a bad
> state but its a lot of new code and we'd hate for anyone to fall over it
> my accident. Its quite well separated from the old radeon code so
> shouldn't fall over too much. I'll send the part 2 pull early next week.
>
> Dave.
>
>  drivers/char/agp/intel-agp.c           |   16 +-
>  drivers/gpu/drm/drm_bufs.c             |    3 +-
>  drivers/gpu/drm/drm_edid.c             |   74 +----
>  drivers/gpu/drm/drm_gem.c              |    2 +-
>  drivers/gpu/drm/drm_hashtab.c          |    4 +
>  drivers/gpu/drm/drm_mm.c               |  165 +++++++--
>  drivers/gpu/drm/drm_modes.c            |   18 +-
>  drivers/gpu/drm/drm_stub.c             |   15 +
>  drivers/gpu/drm/i915/i915_dma.c        |   67 ++--
>  drivers/gpu/drm/i915/i915_drv.h        |   48 ++-
>  drivers/gpu/drm/i915/i915_gem.c        |  156 ++++++---
>  drivers/gpu/drm/i915/i915_gem_tiling.c |  152 ++++++++
>  drivers/gpu/drm/i915/i915_irq.c        |  190 +++++++++-
>  drivers/gpu/drm/i915/i915_reg.h        |  616 ++++++++++++++++++++++++++++++-
>  drivers/gpu/drm/i915/i915_suspend.c    |   20 +
>  drivers/gpu/drm/i915/intel_bios.c      |   86 +++++-
>  drivers/gpu/drm/i915/intel_bios.h      |  101 +++++-
>  drivers/gpu/drm/i915/intel_crt.c       |   76 ++++-
>  drivers/gpu/drm/i915/intel_display.c   |  645 ++++++++++++++++++++++++++++++--
>  drivers/gpu/drm/i915/intel_fb.c        |   26 +-
>  drivers/gpu/drm/i915/intel_hdmi.c      |   33 ++-
>  drivers/gpu/drm/i915/intel_lvds.c      |  151 ++++++--
>  drivers/gpu/drm/i915/intel_sdvo.c      |  110 ++++--
>  drivers/gpu/drm/i915/intel_tv.c        |    3 +
>  drivers/gpu/drm/radeon/r600_cp.c       |   42 ++-
>  drivers/gpu/drm/radeon/radeon_cp.c     |    2 +-
>  drivers/gpu/drm/radeon/radeon_drv.h    |    1 +
>  drivers/gpu/drm/via/via_dmablit.c      |    6 +-
>  drivers/pnp/resource.c                 |   18 +
>  include/drm/drmP.h                     |  126 ++++---
>  include/drm/drm_hashtab.h              |    2 +
>  include/drm/drm_mm.h                   |   90 +++++
>  include/drm/drm_pciids.h               |    9 +
>  include/linux/pnp.h                    |    2 +
>  34 files changed, 2677 insertions(+), 398 deletions(-)
>  create mode 100644 include/drm/drm_mm.h
>
> commit 3c24475c1e4e8d10e50df161d8c4f1d382997a7c
> Author: Jerome Glisse <glisse@freedesktop.org>
> Date:   Wed Apr 8 18:34:28 2009 +0200
>
>    drm: include kernel list header file in hashtab header
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit f2cb5d86e1af175a9b210241800f03a447f92621
> Author: Jerome Glisse <glisse@freedesktop.org>
> Date:   Wed Apr 8 17:16:24 2009 +0200
>
>    drm: Export hash table functionality.
>
>    add exports so TTM module can use these functions.
>
>    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 249d6048ca98b5452105b0824abac1275661b8e3
> Author: Jerome Glisse <glisse@freedesktop.org>
> Date:   Wed Apr 8 17:11:16 2009 +0200
>
>    drm: Split out the mm declarations in a separate header. Add atomic operations.
>
>    this is a TTM preparation patch, it rearranges the mm and
>    add operations needed to do mm operations in atomic context.
>
>    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 715cbb05c935e8a4306a730d14a72d5af881523e
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Fri Jun 12 15:55:44 2009 +1000
>
>    drm/radeon: add support for RV790.
>
>    This adds the PCI IDs for the rv790 which are equiv to the rv770.
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 2a71ebcd85bcc4d6607f577f23a491f796c30e82
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Fri Jun 12 15:53:10 2009 +1000
>
>    drm/radeon: add rv740 drm support.
>
>    This adds drm support for the RV740 family of chips to the r600 support code.
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit fbe0efb869efde8d847ede3a925230ef88910086
> Author: Kristian Høgsberg <krh@redhat.com>
> Date:   Tue Jun 9 01:50:41 2009 +1000
>
>    drm_calloc_large: check right size, check integer overflow, use GFP_ZERO
>
>    Previously we would check size instead of size * nmemb, and so would
>    never hit the vmalloc path.  Also add integer overflow check as in kcalloc,
>    and allocate GFP_ZERO pages instead of memset()ing them.
>
>    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 61f11699e7a92d932b31ded3715ad4f70eb26ef2
> Author: Keith Packard <keithp@keithp.com>
> Date:   Sat May 30 20:42:27 2009 -0700
>
>    drm: Eliminate magic I2C frobbing when reading EDID
>
>    This code depends on the underlying I2C adapter using the bit-banging algo,
>    which may not be the case. If specific encoders require this mechanism, they
>    should build a custom I2C algo that implements this workaround, rather than
>    having it in the general path.
>
>    Signed-off-by: Keith Packard <keithp@keithp.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 7ff145593d808a371924652c8d6a15fb75ce2250
> Author: Dave Airlie <airlied@linux.ie>
> Date:   Wed Apr 22 18:52:14 2009 +1000
>
>    drm/i915: duplicate desired mode for use by fbcon.
>
>    duplicate the mode into fbcon storage, so when we free modes later
>    we don't just lose this.
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit c5c07550d41abe86d109430e718f2007113031f8
> Author: Figo.zhang <figo1802@gmail.com>
> Date:   Sat Jun 6 18:26:26 2009 +0800
>
>    drm/via: vfree() no need checking before calling it
>
>    vfree() does it's own NULL checking, no need for explicit check before
>    calling it.
>
>    Signed-off-by: Figo.zhang <figo1802@gmail.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit be25ed9c5cc06e1d17aa97e41daf88f0b46143e6
> Author: yakui_zhao <yakui.zhao@intel.com>
> Date:   Tue Jun 2 14:13:55 2009 +0800
>
>    drm: Replace DRM_DEBUG with DRM_DEBUG_DRIVER in i915 driver
>
>    Replace the DRM_DEBUG with the DRM_DEBUG_DRIVER to print the debug info
>    in i915 driver.
>
>    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit f053185948a1bd16329433f5371809765086c1ec
> Author: yakui_zhao <yakui.zhao@intel.com>
> Date:   Tue Jun 2 14:12:47 2009 +0800
>
>    drm: Replace DRM_DEBUG with DRM_DEBUG_MODE in drm_mode
>
>    Replace the DRM_DEBUG with DRM_DEBUG_MODE macro to print the info in drm_mode.
>
>    airlied:- fixed up to remove a conflicting #define
>    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 342dc382c451f75ea202a65e6f529bdff6d184cd
> Author: yakui_zhao <yakui.zhao@intel.com>
> Date:   Tue Jun 2 14:12:00 2009 +0800
>
>    drm/i915: Replace DRM_DEBUG with DRM_DEBUG_KMS in intel_sdvo
>
>    Use the DRM_DEBUG_KMS/DEBUG_LOG_KMS to print the debug info for
>    SDVO device.
>
>    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 7fb85bfb54a64e9dd82ee4a79022c38ab58f21a0
> Author: yakui_zhao <yakui.zhao@intel.com>
> Date:   Tue Jun 2 14:10:49 2009 +0800
>
>    drm/i915: replace DRM_DEBUG with DRM_DEBUG_KMS in intel_lvds
>
>    Use the DRM_DEBUG_KMS macro definition to print the debug info for
>    the LVDS.
>
>    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 4fefcb27050b98c97b1c32bc710fc2f874449dee
> Author: yakui_zhao <yakui.zhao@intel.com>
> Date:   Tue Jun 2 14:09:47 2009 +0800
>
>    drm: add separate drm debugging levels
>
>    Now all the DRM debug info will be reported if the boot option of
>    "drm.debug=1" is added. Sometimes it is inconvenient to get the debug
>    info in KMS mode. We will get too much unrelated info.
>
>    This will separate several DRM debug levels and the debug level can be used
>    to print the different debug info. And the debug level is controlled by the
>    module parameter of drm.debug
>
>    In this patch it is divided into four debug levels;
>                drm_core, drm_driver, drm_kms, drm_mode.
>
>    At the same time we can get the different debug info by changing the debug
>    level. This can be done by adding the module parameter. Of course it can
>    be changed through the /sys/module/drm/parameters/debug after the system is
>    booted.
>
>    Four debug macro definitions are provided.
>        DRM_DEBUG(fmt, args...)
>        DRM_DEBUG_DRIVER(prefix, fmt, args...)
>        DRM_DEBUG_KMS(prefix, fmt, args...)
>        DRM_DEBUG_MODE(prefix, fmt, args...)
>
>    When the boot option of "drm.debug=4" is added, it will print the debug info
>    using DRM_DEBUG_KMS macro definition.
>    When the boot option of "drm.debug=6" is added, it will print the debug info
>    using DRM_DEBUG_KMS/DRM_DEBUG_DRIVER.
>
>    Sometimes we expect to print the value of an array.
>    For example: SDVO command,
>    In such case the following four DRM debug macro definitions are added:
>        DRM_LOG(fmt, args...)
>        DRM_LOG_DRIVER(fmt, args...)
>        DRM_LOG_KMS(fmt, args...)
>        DRM_LOG_MODE(fmt, args...)
>
>    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit df4f7fe7bd516b3833e25c692c3970e22038a6ca
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Thu Jun 11 16:16:10 2009 +1000
>
>    radeon: remove _DRM_DRIVER from the preadded sarea map
>
>    This shouldn't be there and is what broke r600 late in the 2.6.30
>    release cycle with Ben's patch.
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 2ff2e8a3e1898e692b604424c384f134009dea80
> Author: Ben Skeggs <bskeggs@redhat.com>
> Date:   Tue May 26 10:35:52 2009 +1000
>
>    drm: don't associate _DRM_DRIVER maps with a master
>
>    A driver will use the _DRM_DRIVER map flag to indicate that it wants
>    to be responsible for removing the map itself, bypassing the DRM's
>    automagic cleanup code.
>
>    Since the multi-master changes this has been broken, resulting in some
>    drivers having their registers unmapped before it's finished with them.
>
>    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit b798b1fe3b6436275ad1b517a6823d55e3b75c22
> Author: Robert P. J. Day <rpjday@crashcourse.ca>
> Date:   Wed Jun 10 12:43:49 2009 -0700
>
>    drm: simplify kcalloc() call to kzalloc().
>
>    Calls to kcalloc() for a single element can be simplified to calls to
>    kzalloc().
>
>    Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
>    Cc: Dave Airlie <airlied@linux.ie>
>    Cc: Eric Anholt <eric@anholt.net>
>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 1bcbf3948876e31a8ece28597dec447611ad9c8b
> Author: Pavel Roskin <proski@gnu.org>
> Date:   Wed Jun 10 12:43:48 2009 -0700
>
>    intelfb: fix spelling of "CLOCK"
>
>    Signed-off-by: Pavel Roskin <proski@gnu.org>
>    Cc: Eric Anholt <eric@anholt.net>
>    Cc: Dave Airlie <airlied@linux.ie>
>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit dcae3626d031fe6296b1e96a16f986193a41f840
> Author: Roel Kluin <roel.kluin@gmail.com>
> Date:   Wed Jun 10 12:43:48 2009 -0700
>
>    drm: fix LOCK_TEST_WITH_RETURN macro
>
>    When this macro isn't called with 'file_priv' this will result in a build
>    failure.
>
>    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> commit 03d6069912babc07a3da20e715dd6a5dc8f0f867
> Author: Keith Packard <keithp@keithp.com>
> Date:   Fri Jun 5 18:19:56 2009 -0700
>
>    drm/i915: Hook connector to encoder during load detection (fixes tv/vga detect)
>
>    With the DRM-driven DPMS code, encoders are considered idle unless a
>    connector is hooked to them, so mode setting is skipped. This makes load
>    detection fail as none of the hardware is enabled.
>
>    Signed-off-by: Keith Packard <keithp@keithp.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 2939e1f5331455d17a4a704dd6210e1474002545
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Sat Jun 6 09:46:03 2009 +0100
>
>    drm/i915: NOMEM->NOSPC
>
>    To differentiate between encountering an out-of-memory error with running
>    out of space in the aperture, use ENOSPC for the later.
>
>    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 21d509e339565c82887733c02465bb7f5866c8f5
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Sat Jun 6 09:46:02 2009 +0100
>
>    drm/i915: use I915_GEM_GPU_DOMAINS
>
>    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit b1ce786cb85280490ca3c29a62ddf8608826b414
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Sat Jun 6 09:46:00 2009 +0100
>
>    drm/i915: no need to hold mutex for object lookup
>
>    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 1f803ee5cea67d2387aeedb4b07e645a743729de
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Sat Jun 6 09:45:59 2009 +0100
>
>    drm/i915: Call drm_vblank_post_modeset() on error paths.
>
>    Ensure that the drm_vblank_pre_modeset() is always balanced by
>    drm_vblank_post_modeset() within intel_crtc_mode_set().
>
>    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 5f26a2c7ad6eba97141e8372f3def282f934b169
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Sat Jun 6 09:45:58 2009 +0100
>
>    drm/i915: OR in the COMMAND read domain for the batch buffer.
>
>    The batch buffer may be shared with another read buffer, so we should not
>    ignore any previously set domains, but just or in the command domain (and
>    check that the buffer is not writable).
>
>    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 83d60795157c83389e6aaa0532d5e19afa976a24
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Sat Jun 6 09:45:57 2009 +0100
>
>    drm/i915: Sanity check execbuffer arguments before touching state.
>
>    By sending a broken execbuffer (its length was not suitably aligned) I
>    triggered an operation upon a freed object. The invalid alignment was
>    discovered after updating the write_domain on the object but before the
>    object was placed on the active queue. So during the unwind process
>    following the error, the now freed object attempts to flush its
>    non-existent, but outstanding, GPU writes causing this use-after-free.
>
>    [drm:i915_dispatch_gem_execbuffer] *ERROR* alignment
>    [drm:i915_gem_execbuffer] *ERROR* dispatch failed -22
>    WARNING: at lib/kref.c:43 warn_slowpath_null+0x10/0x15()
>    Modules linked in:
>    Pid: 4552, comm: lt-csi-drm Not tainted 2.6.30-rc6 #423
>    Call Trace:
>     [<c0119ef3>] warn_slowpath_fmt+0x57/0x6d
>     [<c014de24>] ? get_pageblock_migratetype+0x18/0x1e
>     [<c014e8fd>] ? free_hot_page+0xa/0xc
>     [<c014e915>] ? __free_pages+0x16/0x1f
>     [<c0153ebf>] ? shmem_truncate_range+0x63e/0x656
>     [<c015fb2f>] ? slob_page_alloc+0x146/0x1c8
>     [<c0119f19>] warn_slowpath_null+0x10/0x15
>     [<c01f55f2>] kref_get+0x1b/0x21
>     [<c02605db>] i915_gem_object_move_to_active+0x1f/0x56
>     [<c0261302>] i915_add_request+0x156/0x19a
>     [<c026136e>] i915_gem_object_flush_gpu_write_domain+0x28/0x3f
>     [<c0261eca>] i915_gem_object_unbind+0x4a/0x124
>     [<c0261fd7>] i915_gem_free_object+0x33/0x9b
>     [<c0250d6b>] drm_gem_object_free+0x28/0x4a
>     [<c0250d43>] ? drm_gem_object_free+0x0/0x4a
>     [<c01f55ce>] kref_put+0x38/0x41
>     [<c0250cbf>] drm_gem_object_unreference+0x11/0x13
>     [<c0250d06>] drm_gem_object_handle_unreference+0x1e/0x21
>     [<c0250d13>] drm_gem_object_release_handle+0xa/0xe
>     [<c01f3e6b>] idr_for_each+0x5f/0x98
>     [<c0250d09>] ? drm_gem_object_release_handle+0x0/0xe
>     [<c0250daf>] drm_gem_release+0x22/0x34
>     [<c025046f>] drm_release+0x1e8/0x3c4
>     [<c0162d25>] __fput+0xaf/0x146
>     [<c0162dce>] fput+0x12/0x14
>     [<c01605ef>] filp_close+0x48/0x52
>     [<c011b182>] put_files_struct+0x57/0x9b
>     [<c011b1e4>] exit_files+0x1e/0x20
>     [<c011c6b6>] do_exit+0x16d/0x511
>     [<c03704ab>] ? __schedule+0x3d4/0x3e5
>     [<c0103f0d>] ? handle_irq+0xd/0x69
>     [<c011caa7>] do_group_exit+0x4d/0x73
>     [<c011cae0>] sys_exit_group+0x13/0x17
>     [<c010268c>] sysenter_do_call+0x12/0x2b
>
>    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit fa0864b26b4bfa1dd4bb78eeffbc1f398cb56425
> Author: Michael Cousin <mika.cousin@gmail.com>
> Date:   Fri Jun 5 21:16:22 2009 +0200
>
>    drm/i915: Skip lvds with Aopen i945GTt-VFA
>
>    Signed-off-by: Michael Cousin <mika.cousin@gmail.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 80a538e49daddbf3bf783f3464e91bd3181957b2
> Author: Zhenyu Wang <zhenyuw@linux.intel.com>
> Date:   Mon Jun 8 14:40:20 2009 +0800
>
>    drm/i915: Enable probe on new chipset
>
>    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 036a4a7d9272582fc7370359515d807393e2f728
> Author: Zhenyu Wang <zhenyuw@linux.intel.com>
> Date:   Mon Jun 8 14:40:19 2009 +0800
>
>    drm/i915: handle interrupt on new chipset
>
>    Update interrupt handling methods for IGDNG with new registers
>    for display and graphics interrupt functions. As we won't use
>    irq-based vblank sync in dri2, so display interrupt on new chip
>    will be used for hotplug only in future.
>
>    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit d765898970f35acef960581f678b9da9d5c779fa
> Author: Jesse Barnes <jbarnes at virtuousgeek.org>
> Date:   Fri Jun 5 14:41:29 2009 +0000
>
>    drm/i915: enable MCHBAR if needed
>
>    Using the new PNP resource checking code, this patch allows the i915
>    driver to allocate MCHBAR space if needed and use the BAR to determine
>    current memory settings.
>
>    [apw@canonical.com: moved to the new generic PNP resource interface]
>    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>    Signed-off-by: Andy Whitcroft <apw@canonical.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
>    failure to update-index after git-am --reject to hand-apply
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 1b8e69662e1a086878bf930a6042daf7f8a076cc
> Author: Bjorn Helgaas <bjorn.helgaas at hp.com>
> Date:   Fri Jun 5 14:37:23 2009 +0000
>
>    pnp: add PNP resource range checking function
>
>    Add a PNP resource range check function, indicating whether a resource
>    has been assigned to any device.
>
>    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>    [apw@canonical.com: fixed up exports et al]
>    Signed-off-by: Andy Whitcroft <apw@canonical.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit b66d18ddb16603d1e1ec39cb2ff3abf3fd212180
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Fri May 15 14:11:48 2009 -0700
>
>    drm/i915: avoid non-atomic sysrq execution
>
>    The sysrq functions are executed in hardirq context, so we shouldn't be
>    calling sleeping functions from them, like mutex_locks or memory
>    allocations.
>
>    Fix up the i915 sysrq handler to avoid this.
>
>    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 42c2798b35b95c471877133e19ccc3cab00e9b65
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Tue May 5 13:13:16 2009 -0700
>
>    drm/i915: apply G45 vblank count code to all G4x chips and fix max_frame_count
>
>    All G4x and newer chips use the new style frame count register, with a
>    full 32 bit frame count.  Update the code to reflect this.
>
>    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 70aa96ca2d8d938fc036ef8fd189b0151f4fc3ba
> Author: Jarod Wilson <jarod@redhat.com>
> Date:   Wed May 27 17:20:39 2009 -0400
>
>    drm/i915: add ignore lvds quirk info for AOpen Mini PC
>
>    Fix a FIXME in the intel LVDS bring-up code, adding the appropriate
>    blacklist entry for the AOpen Mini PC, courtesy of a dmidecode
>    dump from Florian Demmer.
>
>    Signed-off-by: Jarod Wilson <jarod@redhat.com>
>    CC: Florian Demmer <florian@demmer.org>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 714605e4a05787c51a5ac36c926d2169cfdfbfba
> Author: yakui_zhao <yakui.zhao@intel.com>
> Date:   Sun May 31 17:18:07 2009 +0800
>
>    drm/i915: Initialize the SDVO device based on the sdvo info parsed from VBT
>
>    http://bugs.freedesktop.org/show_bug.cgi?id=20429
>
>    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
>    [anholt: Massive cleanup of the slave addr function]
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 9b9d172d06b0f2d51cc9431e2c6c3055f0cf10ef
> Author: yakui_zhao <yakui.zhao@intel.com>
> Date:   Sun May 31 17:17:17 2009 +0800
>
>    drm/i915: parse VBT general definition block to get the SDVO device info
>
>    The general definition block contains the child device tables, which include
>    the SDVO device info. For example: device slave address, device dvo port,
>    device type.
>
>    We will get the info of SDVO device by parsing the general definition blocks.
>    Only when a valid slave address is found, it is regarded as the SDVO device.
>    And the info of DVO port and slave address is recorded.
>
>    http://bugs.freedesktop.org/show_bug.cgi?id=20429
>
>    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 59a036cfbd29aadf40d2b754cfebee2a96268752
> Author: yakui_zhao <yakui.zhao@intel.com>
> Date:   Sun May 31 17:16:22 2009 +0800
>
>    drm/i915: Add the structure of child_device_config in video BIOS tables.
>
>    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 040d87f15a0129242463d3ed7c48381505f596e2
> Author: Keith Packard <keithp@keithp.com>
> Date:   Sat May 30 20:42:33 2009 -0700
>
>    drm/i915: Add Display Port register defines
>
>    This adds the register definitions for the display port enable register
>    along with those for the GMCH and Link M/N ratios required to drive display
>    port outputs.
>
>    Signed-off-by: Keith Packard <keithp@keithp.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 2245fda810f870dce9b030e6aa604320abba53a5
> Author: Keith Packard <keithp@keithp.com>
> Date:   Sat May 30 20:42:29 2009 -0700
>
>    drm/i915: Don't trim cursor addresses to 11 bits
>
>    We can safely assume that cursor addresses will not extend beyond the
>    addressable screen dimensions; setting the additional bits is harmless in
>    any case.
>
>    Signed-off-by: Keith Packard <keithp@keithp.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit cb66c692d1ae257f32dc7f6085cf9cb9f2f6bab8
> Author: Ma Ling <ling.ma@intel.com>
> Date:   Sun May 31 16:58:32 2009 +0800
>
>    drm/i915: Set correct TV detection voltage level override values
>
>    We detect TV connect status by setting DAC voltage level override
>    values as 0.7 voltage for DAC_A/B/C. The corresponding 2-bits shold be 0x2,
>    In order correctly to set last bit as 0, at first we must clean it.
>
>    It fixed freedesktop.org bug #21204
>
>    Signed-off-by: Ma Ling <ling.ma@intel.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 541998a18b72d2cac48b3369fa4540116ff3f0a8
> Author: Zhenyu Wang <zhenyuw@linux.intel.com>
> Date:   Fri Jun 5 15:38:44 2009 +0800
>
>    drm/i915: Add LVDS support for IGDNG
>
>    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 30ad48b7334a2eb2edf22f6c91f7b3f22a22a837
> Author: Zhenyu Wang <zhenyuw@linux.intel.com>
> Date:   Fri Jun 5 15:38:43 2009 +0800
>
>    drm/i915: Add HDMI support on IGDNG
>
>    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 2c07245fb8f7f0a282282e5a9747e46defdb2cc7
> Author: Zhenyu Wang <zhenyuw@linux.intel.com>
> Date:   Fri Jun 5 15:38:42 2009 +0800
>
>    drm/i915: enable kernel modesetting on IGDNG
>
>    This adds kernel mode setting on IGDNG with VGA output support.
>    Note that suspend/resume doesn't work yet.
>
>    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 2cce0d8740f0d1454d012401257d96c513ce358f
> Author: Zhenyu Wang <zhenyuw@linux.intel.com>
> Date:   Fri Jun 5 15:38:41 2009 +0800
>
>    drm/i915: Disable tiling on IGDNG for now
>
>    Swizzle bit detection not working right on it.
>
>    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit e170b030dcd6aed11dde2d124c09991ec771f529
> Author: Zhenyu Wang <zhenyuw@linux.intel.com>
> Date:   Fri Jun 5 15:38:40 2009 +0800
>
>    drm/i915: Disable opregion on IGDNG for now
>
>    Disable OpRegion support for now until verified on new chipsets.
>
>    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit b9055052d3e0388b4a5e8c3e0bbab665c5996f50
> Author: Zhenyu Wang <zhenyuw@linux.intel.com>
> Date:   Fri Jun 5 15:38:38 2009 +0800
>
>    drm/i915: Add new chipset register definitions
>
>    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 280da227c870a50f669de0c8d46bfb2c62da9995
> Author: Zhenyu Wang <zhenyuw@linux.intel.com>
> Date:   Fri Jun 5 15:38:37 2009 +0800
>
>    drm/i915: Add chipset/feature defines for for new chipsets
>
>    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
>    [anholt: dropped drm_pciids.h hunk to avoid loading an incomplete driver]
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit 32cb055b57eab803ea82b76dc913b0378e5af145
> Author: Zhenyu Wang <zhenyuw@linux.intel.com>
> Date:   Fri Jun 5 15:38:36 2009 +0800
>
>    agp/intel: Add support for new chipsets
>
>    Both desktop and mobile versions are added.
>
>    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>
> commit b962442e46a9340bdbc6711982c59ff0cc2b5afb
> Author: Eric Anholt <eric@anholt.net>
> Date:   Wed Jun 3 07:27:35 2009 +0000
>
>    drm/i915: Change GEM throttling to be 20ms like the comment says.
>
>    keithp didn't like the original 20ms plan because a cooperative client could
>    be starved by an uncooperative client.  There may even have been problems
>    with cooperative clients versus cooperative clients.  So keithp changed
>    throttle to just wait for the second to last seqno emitted by that client.
>    It worked well, until we started getting more round-trips to the server
>    due to DRI2 -- the server throttles in BlockHandler, and so if you did more
>    than one round trip after finishing your frame, you'd end up unintentionally
>    syncing to the swap.
>
>    Fix this by keeping track of the client's requests, so the client can wait
>    when it has an outstanding request over 20ms old.  This should have
>    non-starving behavior, good behavior in the presence of restarts, and less
>    waiting.  Improves high-settings openarena performance on my GM45 by 50%.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>
> commit 1fd1c624362819ecc36db2458c6a972c48ae92d6
> Author: Eric Anholt <eric@anholt.net>
> Date:   Wed Jun 3 07:26:58 2009 +0000
>
>    drm/i915: Save/restore cursor state on suspend/resume.
>
>    This may fix cursor corruption in X on resume, which would persist until
>    the cursor was hidden and then shown again.
>
>    V2: Also include the cursor control regs.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
>    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>
> commit 0e7ddf7eeeef5aea85412120539ab5369577faeb
> Author: Eric Anholt <eric@anholt.net>
> Date:   Thu Jun 4 11:18:14 2009 +0000
>
>    drm/i915: Remove a bad BUG_ON in the fence management code.
>
>    This could be triggered by a gtt mapping fault on 965 that decides to
>    remove the fence from another object that happens to be active currently.
>    Since the other object doesn't rely on the fence reg for its execution, we
>    don't wait for it to finish.  We'll soon be not waiting on 915 most of the
>    time as well, so just drop the BUG_ON.
>
>    Signed-off-by: Eric Anholt <eric@anholt.net>
