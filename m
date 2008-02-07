Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbYBGFhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbYBGFhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 00:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbYBGFhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 00:37:34 -0500
Received: from gir.skynet.ie ([193.1.99.77]:43403 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbYBGFhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 00:37:33 -0500
Date: Thu, 7 Feb 2008 05:37:30 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm patches for 2.6.25
Message-ID: <alpine.DEB.0.82.0802070534290.26136@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-421574104-1202362650=:26136"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-421574104-1202362650=:26136
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-patches' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

Sorry this is so late, after much talking at LCA we decided to pull TTM 
from this round and I had to re-order a lot of things, so highlights of 
this bunch are

intel driver suspend/resume support - can bring back text mode now.
basic radeon r500 CP support
sysfs cleanups.
fix pci_set_master not being called breaking some radeons.

Dave.

 drivers/char/drm/Kconfig          |    9 +-
 drivers/char/drm/Makefile         |    2 -
 drivers/char/drm/README.drm       |    1 -
 drivers/char/drm/ati_pcigart.c    |    6 +-
 drivers/char/drm/drm.h            |    3 +-
 drivers/char/drm/drmP.h           |   68 ++--
 drivers/char/drm/drm_agpsupport.c |    3 +-
 drivers/char/drm/drm_bufs.c       |   23 +-
 drivers/char/drm/drm_context.c    |    2 +-
 drivers/char/drm/drm_drv.c        |   39 +-
 drivers/char/drm/drm_hashtab.c    |    5 +-
 drivers/char/drm/drm_hashtab.h    |    1 -
 drivers/char/drm/drm_ioc32.c      |    6 +-
 drivers/char/drm/drm_ioctl.c      |   25 +-
 drivers/char/drm/drm_irq.c        |    4 +-
 drivers/char/drm/drm_memory.c     |    1 -
 drivers/char/drm/drm_mm.c         |    1 -
 drivers/char/drm/drm_os_linux.h   |    4 +-
 drivers/char/drm/drm_pciids.h     |   97 +++++-
 drivers/char/drm/drm_proc.c       |    4 +-
 drivers/char/drm/drm_sarea.h      |    2 +-
 drivers/char/drm/drm_scatter.c    |   10 +-
 drivers/char/drm/drm_stub.c       |   18 +-
 drivers/char/drm/drm_sysfs.c      |  146 +++++---
 drivers/char/drm/drm_vm.c         |    4 +-
 drivers/char/drm/i810_dma.c       |   24 +-
 drivers/char/drm/i810_drv.h       |   52 ++--
 drivers/char/drm/i830_dma.c       |    2 +-
 drivers/char/drm/i830_drm.h       |    8 +-
 drivers/char/drm/i830_drv.h       |   51 ++--
 drivers/char/drm/i830_irq.c       |    2 +-
 drivers/char/drm/i915_dma.c       |  124 +++---
 drivers/char/drm/i915_drv.c       |  464 ++++++++++++++++++++-
 drivers/char/drm/i915_drv.h       |  848 +++++++++++++++++++++++++++++++++++--
 drivers/char/drm/i915_irq.c       |   26 +-
 drivers/char/drm/i915_mem.c       |   11 +-
 drivers/char/drm/mga_dma.c        |   10 +-
 drivers/char/drm/mga_drv.h        |  123 +++---
 drivers/char/drm/mga_state.c      |   24 +-
 drivers/char/drm/r128_cce.c       |    6 +-
 drivers/char/drm/r128_drv.h       |    5 +-
 drivers/char/drm/r128_state.c     |   43 +-
 drivers/char/drm/r300_cmdbuf.c    |   75 ++--
 drivers/char/drm/r300_reg.h       |   32 +-
 drivers/char/drm/radeon_cp.c      |  166 +++++---
 drivers/char/drm/radeon_drm.h     |   13 +-
 drivers/char/drm/radeon_drv.h     |   91 ++++-
 drivers/char/drm/radeon_irq.c     |    6 +-
 drivers/char/drm/radeon_mem.c     |    6 +-
 drivers/char/drm/radeon_state.c   |   18 +-
 drivers/char/drm/savage_state.c   |    6 +-
 drivers/char/drm/sis_mm.c         |    6 +-
 drivers/char/drm/via_dma.c        |   20 +-
 drivers/char/drm/via_dmablit.c    |  184 ++++----
 drivers/char/drm/via_dmablit.h    |   84 ++--
 drivers/char/drm/via_drm.h        |    4 +-
 drivers/char/drm/via_drv.c        |    2 +-
 drivers/char/drm/via_irq.c        |   26 +-
 drivers/char/drm/via_map.c        |    5 +-
 drivers/char/drm/via_mm.c         |    6 +-
 drivers/char/drm/via_video.c      |    4 +-
 61 files changed, 2291 insertions(+), 770 deletions(-)

commit 3d5e2c13b13468f5eb2ac9323690af7e17f195fe
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Feb 7 15:01:05 2008 +1000

    drm: add initial r500 drm support
    
    This adds CP support for the r500 series of chips, and allows
    accel 2D support on these chips with a new radeon driver.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 576cc458a64673ecf3fa7f1bab751e52fd939071
Author: Roland Scheidegger <sroland@tungstengraphics.com>
Date:   Thu Feb 7 14:59:24 2008 +1000

    radeon: setup the ring buffer fetcher to be less agressive.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 9d5b3ffc42f7820e8ee07705496955e4c2c38dd9
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Feb 7 14:51:32 2008 +1000

    drm: fixup some of the ioctl function exit paths
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 19a8f59ab8ceee751ea720085098355d53f727d6
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Feb 7 14:48:32 2008 +1000

    drm: the drm really should call pci_set_master..
    
    perhaps bonghits could turn on my bus-mastering because the drm
    certainly never bothered doing it before.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 5f5f9d4c7bf96c044fb98c7c107172a730b2a247
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Thu Jan 24 16:46:36 2008 +1000

    i915: Add chipset id for Intel Integrated Graphics Device
    
    This adds new chipset id in drm.
    
    Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3e684eae586a9b210a4517da5637a255b1ff5a92
Author: Márton Németh <nm127@freemail.hu>
Date:   Thu Jan 24 15:58:57 2008 +1000

    drm: cleanup DRM_DEBUG() parameters
    
    As DRM_DEBUG macro already prints out the __FUNCTION__ string (see
    drivers/char/drm/drmP.h), it is not worth doing this again. At some
    other places the ending "\n" was added.
    
    airlied:- I cleaned up a few that this patch missed also
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 4d1f78880e9631fb08052dcc8e3341eecea537e0
Author: Carlos Martín <inean@users.sf.net>
Date:   Wed Jan 23 16:41:17 2008 +1000

    drm/i915: add support for E7221 chipset
    
    E7221 chipset is a server version of the i915.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit d5b0d1b5bda979b077cf011e79fc19677663afc4
Author: Li Zefan <lizf@cn.fujitsu.com>
Date:   Mon Dec 17 09:47:19 2007 +1000

    drm: don't cast a pointer to pointer of list_head
    
    The casting is safe only when the list_head member is the first member of
    the structure.
    
    Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit a96ca105a68bc66c564accdfeb81c36e1d5d46b3
Author: Jesper Juhl <jesper.juhl@gmail.com>
Date:   Mon Dec 17 09:47:17 2007 +1000

    mga_dma: return 'err' not just zero from mga_do_cleanup_dma()
    
    While reading some code I stumbled across the use of 'err' in
    drivers/char/drm/mga_dma.c::mga_do_cleanup_dma() and I think there's a small
    problem.
    
    The variable is only used inside #if __OS_HAS_AGP which is fine, but all that
    ever happens is an assignment to the variable - it is never actually used for
    anything.  The variable is nicely initialized to zero which is also what the
    return statement at the end of function returns (always at the moment).
    
    It looks to me like that function should be returning 'err' instead of always
    just returning 0.  Here's a patch to do that.
    
    Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit e3236a1173222ca209d20bb29f6c1cd3499aa845
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Dec 17 09:41:56 2007 +1000

    drm: add _DRM_DRIVER flag, and re-order unload.
    
    Allow drivers to addmaps that won't be removed by lastclose or unload.
    The unload needs to be re-ordered to avoid removing the hashs before
    the driver has removed the final maps.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 77e27e9fe5bd399c9f56b941b212a58338e94463
Author: Dave Airlie <airlied@linux.ie>
Date:   Thu Nov 29 09:48:20 2007 +1000

    drm: enable udev node creation
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit b018fcdaa5e8b4eabb8cffda687d00004a3c4785
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Nov 22 18:46:54 2007 +1000

    drm: Make DRM_IOCTL_GET_CLIENT return EINVAL when it can't find client #idx.
    
    Fixes the getclient test and dritest -c.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 3260f9fdfee9d5b4135f40943dc0bd0733b7394e
Author: Dave Airlie <airlied@linux.ie>
Date:   Thu Nov 22 18:43:46 2007 +1000

    drm: move drm_mem_init to proper place in startup sequence
    
    For TTM this needs to be called later.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 2716a02f607c964ccaa6fa7266abd3acd73d9033
Author: Dave Airlie <airlied@linux.ie>
Date:   Thu Nov 22 18:23:13 2007 +1000

    drm: call driver load function after initialising AGP
    
    needed to intel chipset flushing
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 7ffa05e0518ebc055ef8f68d7d53e5f7d2ba3428
Author: Ian Romanick <idr@us.ibm.com>
Date:   Thu Nov 22 17:02:08 2007 +1000

    drm: Fix ioc32 compat layer
    
    Previously any ioctls that weren't explicitly listed in the compat ioctl
    table would fail with ENOTTY.  If the incoming ioctl number is outside the
    range of the table, assume that it Just Works, and pass it off to drm_ioctl.
    This make the fence related ioctls work on 64-bit PowerPC.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 47a184a80800dd69abd1206eea1b961070ce2ca3
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Nov 22 16:55:15 2007 +1000

    drm: fd.o bug #11895: Only add the AGP base to map offset if the caller didn't.
    
    The i830 and newer intel 2D code adds the AGP base to map offsets already,
    because it wasn't doing the AGP enable which used to set dev->agp->base.
    
    Credit goes to Zhenyu for finding the issue.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit ba8bbcf6ff4650712f64c0ef61139c73898e2165
Author: Jesse Barnes <jesse.barnes@intel.com>
Date:   Thu Nov 22 14:14:14 2007 +1000

    i915: add suspend/resume support
    
    Add suspend/resume support to the i915 driver.  Moves some of the
    initialization into the driver load routine, and fixes up places where we
    assumed no dev_private existed in some of the cleanup paths.  This allows
    us to suspend/resume properly even if X isn't running.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit e8b962b6df50b74afed14af7f7a7d569b3ba70ac
Author: Jesse Barnes <jesse.barnes@intel.com>
Date:   Thu Nov 22 14:02:38 2007 +1000

    drm: update DRM sysfs support
    
    Make DRM devices use real Linux devices instead of class devices, which are
    going away.  While we're at it, clean up some of the interfaces to take
    struct drm_device * or struct device * and use the global drm_class where
    needed instead of passing it around.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 8b40958032fd236194de57d29be9cf2c1f2643ee
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Nov 22 16:40:37 2007 +1000

    drm: Initialize the AGP structure's base address at init rather than enable.
    
    Not all drivers call enable (intel), but they would still like to use this
    member in driver code.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit ded23359ccb884605336ac2193608a7af9a3b117
Author: Dave Airlie <airlied@linux.ie>
Date:   Mon Nov 5 13:07:28 2007 +1000

    drm: move two function extern into the correct block

commit bc5f4523f772cc7629c5c5a46cf4f2a07a5500b8
Author: Dave Airlie <airlied@linux.ie>
Date:   Mon Nov 5 12:50:58 2007 +1000

    drm: run cleanfile across drm tree
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 8562b3f25d6e23c9d9e48a32672944d1e8a2aa97
Author: Dave Airlie <airlied@optimus.(none)>
Date:   Mon Nov 5 12:37:41 2007 +1000

    drm: some minor cleanups and changes to make memory manager merging easier.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>
--29444707-421574104-1202362650=:26136--
