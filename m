Return-Path: <linux-kernel-owner+w=401wt.eu-S1759104AbZDCBAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104AbZDCBAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbZDCBAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:00:05 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33673 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbZDCBAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:00:01 -0400
Date: Fri, 3 Apr 2009 01:59:57 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git] drm fixes
Message-ID: <alpine.DEB.2.00.0904030157470.27439@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

This contains a merge from Eric hopefully done right, along with misc 
small fixes since the main merge.

Dave.

 drivers/gpu/drm/drm_crtc_helper.c       |   31 +++++-
 drivers/gpu/drm/drm_edid.c              |    8 +-
 drivers/gpu/drm/drm_gem.c               |    7 +-
 drivers/gpu/drm/drm_sysfs.c             |    1 +
 drivers/gpu/drm/i915/i915_dma.c         |   11 +--
 drivers/gpu/drm/i915/i915_drv.h         |    5 +
 drivers/gpu/drm/i915/i915_gem.c         |   38 +++++--
 drivers/gpu/drm/i915/i915_gem_debug.c   |    2 +
 drivers/gpu/drm/i915/i915_gem_debugfs.c |    6 +
 drivers/gpu/drm/i915/i915_gem_tiling.c  |   16 +++
 drivers/gpu/drm/i915/i915_irq.c         |   67 ++++++++++-
 drivers/gpu/drm/i915/i915_reg.h         |   11 ++
 drivers/gpu/drm/i915/intel_crt.c        |    4 +-
 drivers/gpu/drm/i915/intel_display.c    |   22 ++++-
 drivers/gpu/drm/i915/intel_modes.c      |    1 +
 drivers/gpu/drm/i915/intel_sdvo.c       |  193 +++++++++++++++++--------------
 drivers/gpu/drm/i915/intel_sdvo_regs.h  |    3 +
 drivers/gpu/drm/i915/intel_tv.c         |   30 ++++-
 drivers/gpu/drm/radeon/r600_cp.c        |    8 +-
 include/drm/drm_crtc_helper.h           |    3 +-
 include/drm/drm_os_linux.h              |    4 +-
 21 files changed, 332 insertions(+), 139 deletions(-)

commit 029a2edbd36f5e34ff1aebfba1bca31b5ac9899e
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Sun Mar 29 20:44:26 2009 -0400

    drm/radeon: load the right microcode on rs780
    
    Copy/paste error.  The RV670 microcode should work ok, so it's
    not a show stopper.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5f3dbedf2770cf6aeb5547b3c56734dee4e5186b
Merge: 7a1fb5d... 1055f9d...
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Apr 3 10:27:21 2009 +1000

    Merge branch 'drm-intel-next' of ../anholt-2.6 into drm-linus

commit 7a1fb5d06d3936c0982e2cf8b53b046244a9aad6
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Fri Mar 27 13:05:19 2009 -0700

    drm: remove unused "can_grow" parameter from drm_crtc_helper_initial_config
    
    Cleanup some leftovers from the X port.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b94ee6528954b6838e88aa8cf74ed75acf8dfcff
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Apr 2 14:56:24 2009 -0700

    drm: fix EDID backward compat check
    
    EDIDs should be backward compatible, so don't bail if we see a version
    of 3 (which is out there now) and print a message if we see something
    newer, but allow it to be parsed.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6714977b45279c3a0b0ec2bc937284d9f116752f
Author: yakui_zhao <yakui.zhao@intel.com>
Date:   Thu Apr 2 11:52:12 2009 +0800

    drm: sync the mode validation for INTERLACE/DBLSCAN
    
    Check whether the INTERLACE/DBLSCAN is supported by output device. If
    not, the mode containing the flag of INTERLACE/DBLSCAN will be marked
    as unsupported.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 16456c872e4e3d674dde73f9bdf3f69c0d95e070
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Apr 3 09:10:33 2009 +1000

    drm: fix typo in edid vendor parsing.
    
    Should be,
    
        edid_vendor[2] = (edid->mfg_id[1] & 0x1f) +  '@';
    
    Since vendor ID has only two bytes only, I am somewhat surprised why gcc
    doesn't complain this.
    
    Reported-by: Guo, Chaohong <chaohong.guo@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3c6fc3521acbee33637e7db803ac3cf3b0e2ff04
Author: Jean Delvare <khali@linux-fr.org>
Date:   Thu Apr 2 11:52:24 2009 +0200

    DRM: drm_crtc_helper.h doesn't actually need i2c.h
    
    Remove an include that isn't actually needed to prevent needless
    rebuilds.
    
    Signed-off-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 522b5cc7cec124e06629c0702ffab1307416aec7
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Mar 31 15:14:39 2009 +1100

    drm: fix missing inline function on 32-bit powerpc.
    
    The readq/writeq really need to be static inline on the arches which
    don't provide them.
    
    Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 1055f9ddad093f54dfd708a0f976582034d4ce1a
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Mar 31 18:22:31 2009 -0700

    drm: Use pgprot_writecombine in GEM GTT mapping to get the right bits for !PAT.
    
    Otherwise, the PAGE_CACHE_WC would end up getting us a UC-only mapping, and
    the write performance of GTT maps dropped 10x.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    [anholt: cleaned up unused var]
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 5e118f4139feafe97e913df67b1f7c1e5083e535
Author: Carl Worth <cworth@cworth.org>
Date:   Fri Mar 20 11:54:25 2009 -0700

    drm/i915: Add a spinlock to protect the active_list
    
    This is a baby-step in the direction of having finer-grained
    locking than the struct_mutex. Specifically, this will enable
    new debugging code to read the active list for printing out
    GPU state when the GPU is wedged, (while the struct_mutex is
    held, of course).
    
    Signed-off-by: Carl Worth <cworth@cworth.org>
    [anholt: indentation fix]
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 7026d4ac1fc134566c2c946e6c0d849fc03ba7b7
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Tue Mar 24 14:02:43 2009 +0800

    drm/i915: Fix SDVO TV support
    
    This brings SDVO TV support from 2D driver, including origin
    fix f1ca56e17d0 and later fix 2fcf4fcccfe. Also fix wrong modeline
    definitions for SDVO TV.
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit e642c6f1d2ebea41b8d7ccc132734b74b5821034
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Tue Mar 24 14:02:42 2009 +0800

    drm/i915: Fix SDVO CREATE_PREFERRED_INPUT_TIMING command
    
    This brings fix commit acde0ef683 from 2D driver.
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 171a9e960ec820765e3b8e9dd1e3d8d81233d459
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Tue Mar 24 14:02:41 2009 +0800

    drm/i915: Fix error in SDVO DTD and modeline convert
    
    This brings fix commit 62c0c2f5549a from 2D driver.
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 33b5296120da157c90f40fab0ae498799ee29ca1
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Tue Mar 24 14:02:40 2009 +0800

    drm/i915: Fix SDVO command debug function
    
    Fix compile error of intel_sdvo_debug_response(),
    and explicit use KERN_DEBUG for printk.
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 7d6ff7851c23740c3813bdf457be638381774b69
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Tue Mar 24 00:45:13 2009 +0800

    drm/i915: fix TV mode setting in property change
    
    Only set TV DAC in property change seems doesn't work, we have to
    setup whole crtc pipe which assigned to TV alone.
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    [anholt: Note that this should also fix the oops at startup with new 2D]
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit ebcc8f2eade76946dbb5d5c545b91f8157051aa8
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Mon Mar 23 19:40:57 2009 +0800

    drm/i915: only set TV mode when any property changed
    
    If there's no real property change, don't need to set TV mode again.
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    [anholt: checkpatch.pl fix]
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 580982d399071474c349538b7f5780bc79b54e7f
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Mon Mar 23 13:36:25 2009 -0700

    drm/i915: clean up udelay usage
    
    udelay() of 20 milliseconds really ought to just use mdelay(), that avoids
    the various wrap scenarios and also is more readable
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 5ca58282089b11f64b911618036ee7676f12735b
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Mar 31 14:11:15 2009 -0700

    drm/i915: add VGA hotplug support for 945+
    
    Add VGA port hotplug detection to the i915 driver.  When KMS is enabled,
    plugging in or removing a VGA cable from the VGA connector will
    generate a uevent, which indicates to userspace that it should re-probe
    outputs on this device (to determine modes, etc.).
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    [anholt: dropped extra PORT_HOTPLUG_STAT clear with ack from jbarnes]
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 4a8df45894d26dc503013ea630927731c24be6b8
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Fri Mar 13 16:22:33 2009 +0800

    drm/i915: correctly set IGD device's gtt size for KMS.
    
    IGD device only has last 1 page used by GTT.  This should match the AGP gart
    code.
    
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 6b731a65c86119da808b3687e0bbb8f18ab137ad
Author: Ma Ling <ling.ma@intel.com>
Date:   Wed Mar 11 18:18:29 2009 +0800

    drm/i915: avoid hanging on to a stale pointer to raw_edid.
    
    drm_get_edid will store edid into raw_edid, so when freeing edid memory,
    at the same time clean raw_edid pointer.
    
    Signed-off-by: Ma Ling <ling.ma@intel.com>
    [anholt: Note that raw_edid is not currently used anywhere]
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 959b887cf42fd63cf10e28a7f26126f78aa1c0b0
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Fri Mar 20 14:16:33 2009 -0700

    drm/i915: check for -EINVAL from vm_insert_pfn
    
    Indicates something is wrong with the mapping; and apparently triggers
    in current kernels.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuosugeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 8d7773a32d8aa723030712b0a500a4a402a21c85
Author: Daniel Vetter <daniel@biene.ffwll.ch>
Date:   Sun Mar 29 14:09:41 2009 +0200

    drm/i915: fix up tiling/fence reg setup on i8xx class hw
    
    This fixes all the tiling problems with the 2d ddx. glxgears still doesn't work.
    Changes:
    
    - fix a copy&paste error in i8xx fence reg setup. It resulted in an at most a
      512KB offset of the fence reg window, so was only visible sometimes.
    - add tests for stride and object size constrains (also for i915 and 1965 class
      hw). Userspace seems to have an of-by-one bug there, which changes the fence
      size by at most 512KB due to an overflow.
    - because i8xx hw is quite old (and therefore not as well-tested) I left 2 debug
      WARN_ONs in the i8xx fence reg setup code to hopefully catch any further
      overflows in the bit-fields. Lastly there's one small change to make the
      alignment checks more consistent.
    
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=20289
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Eric Anholt <eric@anholt.net>
