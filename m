Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbZBTCic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbZBTCic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbZBTCiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:38:23 -0500
Received: from gir.skynet.ie ([193.1.99.77]:43387 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZBTCiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:38:21 -0500
Date: Fri, 20 Feb 2009 02:38:19 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes tree.
Message-ID: <alpine.DEB.2.00.0902200234560.30665@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-987886256-1235097499=:30665"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-987886256-1235097499=:30665
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Intel: This contains one lockdep fix, the other is still under discussion 
along with a few locking and error path fixes. It also contains some 
minor kms updates for PLL clocks and LVDS found during Fedora integration.

Radeon: fixes a suspend/resume regression introduced by the master 
changes.

Dave.

 drivers/gpu/drm/drm_crtc.c             |    3 +-
 drivers/gpu/drm/drm_crtc_helper.c      |   21 +++-
 drivers/gpu/drm/drm_fops.c             |    3 +
 drivers/gpu/drm/drm_gem.c              |   79 +++++++++++-----
 drivers/gpu/drm/i915/i915_drv.c        |    2 +
 drivers/gpu/drm/i915/i915_drv.h        |    2 +
 drivers/gpu/drm/i915/i915_gem.c        |  119 +++++++++++++++---------
 drivers/gpu/drm/i915/i915_gem_tiling.c |    6 +-
 drivers/gpu/drm/i915/intel_bios.c      |    8 ++
 drivers/gpu/drm/i915/intel_display.c   |  160 +++++++++++++++++---------------
 drivers/gpu/drm/i915/intel_fb.c        |    8 +-
 drivers/gpu/drm/i915/intel_lvds.c      |    2 -
 drivers/gpu/drm/i915/intel_sdvo.c      |    2 +-
 drivers/gpu/drm/i915/intel_tv.c        |    2 +-
 drivers/gpu/drm/radeon/radeon_cp.c     |   21 +++-
 include/drm/drmP.h                     |    2 +
 include/drm/drm_crtc.h                 |    2 +-
 include/drm/drm_crtc_helper.h          |   10 +-
 18 files changed, 279 insertions(+), 173 deletions(-)

commit 3d16118dc825a654043dfe3e14371fdf2976994d
Author: etienne <etienne.basset@numericable.fr>
Date:   Fri Feb 20 09:44:45 2009 +1000

    drm/radeon: update sarea copies of last_ variables on resume.
    
    This fixes a regression reported in bug #12613.
    
    [airlied: not I tweaked the patch slightly and fixed it by etienne did
    all the hardwork so gets authorship]
    
    Signed-off-by: etienne <etienne.basset@numericable.fr>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ab00b3e5210954cbaff9207db874a9f03197e3ba
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Wed Feb 11 14:01:46 2009 -0800

    drm/i915: Keep refs on the object over the lifetime of vmas for GTT mmap.
    
    This fixes potential fault at fault time if the object was unreferenced
    while the mapping still existed.  Now, while the mmap_offset only lives
    for the lifetime of the object, the object also stays alive while a vma
    exists that needs it.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 496818f08a78476abdb307e241911536221239fc
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Wed Feb 11 13:28:14 2009 -0800

    drm/i915: take struct mutex around fb unref
    
    Need to do this in case the unref ends up doing a free.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 43565a0648e664744ac9201c199681451355edcc
Author: Kristian Høgsberg <krh@bitplanet.net>
Date:   Fri Feb 13 20:56:52 2009 -0500

    drm: Use spread spectrum when the bios tells us it's ok.
    
    Lifted from the DDX modesetting.
    
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a29f5ca3d691995266a4b1df313e32ff0509a03c
Author: Kristian Høgsberg <krh@bitplanet.net>
Date:   Fri Feb 13 20:56:51 2009 -0500

    drm: Collapse identical i8xx_clock() and i9xx_clock().
    
    They used to be different.  Now they're identical.
    
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f3cade5c037054ce5f57651fe0b64eaa9781c753
Author: Kristian Høgsberg <krh@bitplanet.net>
Date:   Fri Feb 13 20:56:50 2009 -0500

    drm: Bring PLL limits in sync with DDX values.
    
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7f9872e06d749afdc2029aa6b7ffe88cb3b8c5c2
Author: Kristian Høgsberg <krh@bitplanet.net>
Date:   Fri Feb 13 20:56:49 2009 -0500

    drm: Add locking around cursor gem operations.
    
    We need to hold the struct_mutex around pinning and the phys object
    operations.
    
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5c3b82e2b229e78eb32f4ea12d16f3ebeeab3fc7
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Feb 11 13:25:09 2009 +0000

    drm: Propagate failure from setting crtc base.
    
    Check the error paths within intel_pipe_set_base() to first cleanup and
    then report back the error.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit e62fb64e6187ea9d8bcedb17ccaa045ed92d4b55
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Feb 11 16:39:21 2009 +0000

    drm: Check for a NULL encoder when reverting on error path
    
    We need to skip the connectors with a NULL encoder to match the success
    path and avoid an OOPS.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 85a7bb98582b60b7e9130159d2464eb0bbac13f7
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Feb 11 14:52:44 2009 +0000

    drm/i915: Cleanup the hws on ringbuffer constrution failure.
    
    If we fail to create the ringbuffer, then we need to cleanup the allocated
    hws.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 67eabc0553a32c491fdb392ff2358a0384562050
Author: Steve Aarnio <steve.j.aarnio@linux.intel.com>
Date:   Thu Feb 12 11:34:02 2009 -0800

    drm/i915: Don't add panel_fixed_mode to the probed modes list at LVDS init.
    
    In the case where no EDID data is read from the device, adding the
    panel_fixed_mode pointer to the probed modes list causes data corruption.
    
    If the panel_fixed_mode pointer is added to the probed modes list at
    init time, a copy of the mode is added again at drm_get_modes() request
    time.  Then, the panel_fixed_mode pointer is freed because it is seen as
    a duplicate mode.  Unfortunately, this pointer is still stored and used
    in mode_fixup().
    
    Because the panel_fixed_mode data is copied and returned at
    drm_get_modes() time, it is unnecessary to add this information at init
    time.
    
    Signed-off-by: Steve Aarnio <steve.j.aarnio@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit ea39f835168f60b01e59d0f348da25d297e7cf94
Author: Kristian Høgsberg <krh@redhat.com>
Date:   Thu Feb 12 14:37:56 2009 -0500

    drm: Release user fbs in drm_release
    
    Avoids leaking fbs and associated buffers on release.
    
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
    Tested-by: Tested-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit b4476f52e43fadcb9402723a1a55ba1308757525
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Feb 11 14:26:36 2009 +0000

    drm/i915: Unpin the fb on error during construction.
    
    If we fail whilst constructing the fb, then we need to unpin it as well.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 3eb2ee77b0b6b7b2c10308d7b46d2a459fb5be10
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Feb 11 14:26:34 2009 +0000

    drm/i915: Unpin the hws if we fail to kmap.
    
    A missing unpin on the error path.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 47ed185a777632063d2748f59d14ec6fdeb26f67
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Feb 11 14:26:33 2009 +0000

    drm/i915: Unpin the ringbuffer if we fail to ioremap it.
    
    A missing unpin on the error path.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 491152b8778d7d290579c989e8607892accde920
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Feb 11 14:26:32 2009 +0000

    drm/i915: unpin for an invalid memory domain.
    
    A missing unreference and unpin after rejecting the relocation for an
    invalid memory domain.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 13af10627676879d1b20ee3cdba9a28f0906dd98
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Feb 11 14:26:31 2009 +0000

    drm/i915: Release and unlock on mmap_gtt error path.
    
    We failed to unlock the mutex after failing to create the mmap offset.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 2ebed176a7ee126448d34fc336afb2ea0238c280
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Feb 11 14:26:30 2009 +0000

    drm/i915: Set framebuffer alignment based upon the fence constraints.
    
    Set the request alignment to 0, and leave it up to i915_gem_object_pin()
    to set the appropriate alignment to match the fence covering the object.
    
    Eric Anholt mentioned that the pinning code is meant to choose the
    maximum of the request alignment and that of the fence covering the
    object... However currently, the pinning code will only apply the fence
    constraints if the supplied alignment is 0.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 8d59bae5d9aae10ab230561519bfb97962509bcb
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Feb 11 14:26:28 2009 +0000

    drm: Do not leak a new reference for flink() on an existing name
    
    The name table should only hold a single reference, so avoid leaking
    additional references for secondary calls to flink().
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit a35f2e2b83a789e189a501ebd722bc9a1310eb05
Author: Roland Dreier <rdreier@cisco.com>
Date:   Fri Feb 6 17:48:09 2009 -0800

    drm/i915: Fix potential AB-BA deadlock in i915_gem_execbuffer()
    
    Lockdep warns that i915_gem_execbuffer() can trigger a page fault (which
    takes mmap_sem) while holding dev->struct_mutex, while drm_vm_open()
    (which is called with mmap_sem already held) takes dev->struct_mutex.
    So this is a potential AB-BA deadlock.
    
    The way that i915_gem_execbuffer() triggers a page fault is by doing
    copy_to_user() when returning new buffer offsets back to userspace;
    however there is no reason to hold the struct_mutex when doing this
    copy, since what is being copied is the contents of an array private to
    i915_gem_execbuffer() anyway.  So we can fix the potential deadlock (and
    get rid of the lockdep warning) by simply moving the copy_to_user()
    outside of where struct_mutex is held.
    
    This fixes <http://bugzilla.kernel.org/show_bug.cgi?id=12491>.
    
    Reported-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
    Tested-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
    Signed-off-by: Roland Dreier <rolandd@cisco.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 96dec61d563fb8dff2c8427fdf85327a95b65c74
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Sun Feb 8 19:08:04 2009 +0000

    drm/i915: refleak along pin() error path.
    
    A missing unreference if the user calls pin() a second time on a pinned
    buffer.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit d6873102fd36c577f88174d8bd50f1d51645fc51
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Sun Feb 8 19:07:51 2009 +0000

    drm/i915: hold mutex for unreference() in i915_gem_tiling.c
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit a198bc80ae59cf7c6da93bc8bd017b2198148ed7
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri Feb 6 16:55:20 2009 +0000

    drm/i915: Cleanup trivial leak on execbuffer error path.
    
    Also spotted by Owain Ainsworth.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 3e49c4f4cf786b70bbc369b99e590de4bebac1b3
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Feb 9 11:31:41 2009 +0000

    drm: Free the object ref on error.
    
    Ensure that the object is unreferenced if we fail to allocate during
    drm_gem_flink_ioctl().
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit ad45aa9e6e010283bbd8cf0c6309866233e113f2
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Feb 9 11:31:41 2009 +0000

    drm: Potential use-after-free on error path.
    
    Remove the member from the hash table before we free the structure!
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 005568be363b90c9333c3bcbc1e7a53922816322
Author: Tobias Klauser <tklauser@distanz.ch>
Date:   Mon Feb 9 22:02:42 2009 +0100

    drm/i915: Storage class should be before const qualifier
    
    The C99 specification states in section 6.11.5:
    
    The placement of a storage-class specifier other than at the beginning
    of the declaration specifiers in a declaration is an obsolescent
    feature.
    
    Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>
--29444707-987886256-1235097499=:30665--
