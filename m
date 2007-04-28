Return-Path: <linux-kernel-owner+w=401wt.eu-S1031000AbXD1Dy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031000AbXD1Dy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 23:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031003AbXD1Dy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 23:54:26 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:33379 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031000AbXD1DyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 23:54:24 -0400
X-Greylist: delayed 1549 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2007 23:54:24 EDT
Date: Sat, 28 Apr 2007 04:28:33 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: [git pull] DRM patches for 2.6.22-rc1
Message-ID: <Pine.LNX.4.64.0704280427350.8378@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1112504443-1177730913=:8378"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1112504443-1177730913=:8378
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN; format=flowed
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-patches' branch of
git://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

This contains the drm patch for 2.6.22-rc1, and contains a number of fixes
in the mmap code and the locking for AIGLX systems along with new hw support
for i965GM.

Dave.

  drivers/char/drm/README.drm    |   16 +++--
  drivers/char/drm/drm.h         |    4 +-
  drivers/char/drm/drmP.h        |   23 +------
  drivers/char/drm/drm_bufs.c    |   75 +++--------------------
  drivers/char/drm/drm_drv.c     |    9 +--
  drivers/char/drm/drm_fops.c    |   96 ++++++++++++++--------------
  drivers/char/drm/drm_hashtab.c |   17 +-----
  drivers/char/drm/drm_hashtab.h |    1 -
  drivers/char/drm/drm_irq.c     |    4 +-
  drivers/char/drm/drm_lock.c    |  134 ++++++++-------------------------------
  drivers/char/drm/drm_mm.c      |    2 +
  drivers/char/drm/drm_pciids.h  |    3 +-
  drivers/char/drm/drm_proc.c    |    2 +-
  drivers/char/drm/drm_stub.c    |    1 -
  drivers/char/drm/drm_vm.c      |  102 ++++++++++++-------------------
  drivers/char/drm/i915_dma.c    |    3 +-
  drivers/char/drm/radeon_cp.c   |    8 +-
  drivers/char/drm/sis_drv.c     |    2 +-
  drivers/char/drm/via_drv.c     |    3 +-
  drivers/char/drm/via_mm.h      |   40 ++++++++++++
  20 files changed, 196 insertions(+), 349 deletions(-)

commit ce7dd06372058f9e3e57ee4c0aeba694a43a80ad
Author: Wang Zhenyu <zhenyu.z.wang@intel.com>
Date:   Thu Apr 26 07:42:56 2007 +1000

     drm/i915: Add 965GM pci id update

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 9e9c1326a592c677c94d730fcf4446d0e275aef4
Author: Dave Airlie <airlied@linux.ie>
Date:   Sat Mar 24 17:57:54 2007 +1100

     drm: just use io_remap_pfn_range on all archs..

     Move the sparc64 ifdef around to clean this up.

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 38315878a560eede1a2db52e511ad3a2cfbb4206
Author: Hugh Dickins <hugh@veritas.com>
Date:   Sat Mar 24 17:55:16 2007 +1100

     drm: fix DRM_CONSISTENT mapping

     This patch got lost in the DRM git tree for ages, bring it back to life.

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit d7d8aac79dc38cbdef83b774e49bafdae9918137
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Sat Mar 24 17:52:49 2007 +1100

     drm: fix up mmap locking in preparation for ttm changes

     This change is needed to protect againt disappearing maps which aren't common.
     The map lists are protected using sturct_mutex but drm_mmap never locked it.

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 040ac32048d5efabd557c1e0a6ab8aec2c710c56
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Fri Mar 23 13:28:33 2007 +1100

     drm: fix driver deadlock with AIGLX and reclaim_buffers_locked

     Bugzilla Bug #9457

     Add refcounting of user waiters to the DRM hardware lock, so that we can use
     DRM_LOCK_CONT flag more conservatively.

     Also add a kernel waiter refcount that if nonzero transfers the lock for the
     kernel context when it is released. This is useful when waiting for idle and can be used for very simple fence object driver implementations for the new memory manager

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 4b560fde06aeb342f3ff0bce924627ab722d251a
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Mon Mar 19 09:08:21 2007 +1100

     drm: fix warning in drm_fops.c

     drivers/char/drm/drm_fops.c: In function 'drm_setup':
     drivers/char/drm/drm_fops.c:60: warning: comparison of distinct pointer types lacks a cast

     Unfortunately PAGE_SIZE has different types on different architectures.

     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 99da6d861c659bb1a961b70f50fad268b9ed5a5f
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Mon Mar 19 08:52:17 2007 +1100

     drm: allow for more generic drm ioctls

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 6244270ef62203e057191bf85489e2ff91cc0e60
Author: Jay Estabrook <Jay.Estabrook@hp.com>
Date:   Sun Mar 11 11:46:27 2007 +1100

     drm: fix alpha domain handling

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 74be8e3b3707956f8f232313de9fad896d5489ac
Author: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
Date:   Sun Mar 11 11:45:24 2007 +1100

     via: fix CX700 pci id

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 0bead7cdc94b4897f3d92db6170737a2da527134
Author: Adrian Bunk <bunk@stusta.de>
Date:   Sun Mar 11 11:41:16 2007 +1100

     drm: make drm_io_prot static.

     This patch makes the needlessly global drm_io_prot() static.

     Signed-off-by: Adrian Bunk <bunk@stusta.de>
     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 5379397182a7b5fa1c68ceaefe311ce4c1d04b2a
Author: Robert P. J. Day <rpjday@mindspring.com>
Date:   Sun Mar 11 11:39:31 2007 +1100

     drm: remove via_mm.h

     Delete apparently unused header file drivers/char/drm/via_mm.h.

     Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit c1185ccdfb797df82fa84b581eea128041bd63b0
Author: Dave Airlie <airlied@linux.ie>
Date:   Sun Feb 18 18:23:11 2007 +1100

     drm: add missing NULL assignment

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 80b2c386f3d8c3367533a8600b599f8686c9d386
Author: Michel Dänzer <michel@tungstengraphics.com>
Date:   Sun Feb 18 18:03:21 2007 +1100

     drm/radeon: Fix u32 overflows when determining AGP base address in card space.

     The overflows could lead to the AGP aperture overlapping the framebuffer are    in the card's address space when the latter is located at the very end of th    32 bit address space, which would result in a freeze on X server startup,
     probably because the card read commands from the framebuffer instead of from    AGP.

     See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=392915 .

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit cd839d0048c3cb332cb0cd7d3de3431f8e1d3c7a
Author: Dave Airlie <airlied@linux.ie>
Date:   Sun Feb 18 17:14:09 2007 +1100

     drm: port over use_vmalloc code from git hashtab

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 11d9c2fd0ae74647ea2b52f9bdfa7a920b48d1f1
Author: Dave Airlie <airlied@linux.ie>
Date:   Sun Feb 18 17:13:39 2007 +1100

     drm: fix crash with fops lock and fixup sarea/page size locking

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 54ba2f76e281286cf4b2860ed8354602eab4c1ef
Author: Dave Airlie <airlied@linux.ie>
Date:   Sat Feb 10 12:07:47 2007 +1100

     drm: bring bufs code from git tree.

     This checks the AGP mappings are in a valid place and also fixes the size
     check in the vm..

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 5cc7f9abec8391e43b0a052c8880509668e24b35
Author: Dave Airlie <airlied@linux.ie>
Date:   Sat Feb 10 11:53:13 2007 +1100

     drm: move protection stuff into separate function

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 8311d570bcb3faea68941ebd5e240eb2e96d65a0
Author: Ahmed S. Darwish <darwish.07@gmail.com>
Date:   Fri Feb 9 10:30:10 2007 +1100

     drm: Use ARRAY_SIZE macro when appropriate

     Use ARRAY_SIZE macro already defined in kernel.h

     Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit f54d1e40b2732cd882646de3c860d24a6920cbc2
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Fri Feb 9 10:28:21 2007 +1100

     drm: update README.drm (bugzilla #7933)

     Update URLs in drivers/char/drm/README.drm, to take care of kernel bugzilla

     Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 41ed5de9714f3690642d50c44973308476a7d334
Author: Adrian Bunk <bunk@stusta.de>
Date:   Fri Feb 9 10:25:22 2007 +1100

     drm: remove unused exports

     This patch removes two unused exports.

     Signed-off-by: Adrian Bunk <bunk@stusta.de>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Dave Airlie <airlied@linux.ie>
--29444707-1112504443-1177730913=:8378--
