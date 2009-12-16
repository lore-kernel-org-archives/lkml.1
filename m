Return-Path: <linux-kernel-owner+w=401wt.eu-S1761639AbZLPGQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639AbZLPGQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 01:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761599AbZLPGQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 01:16:13 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49892 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761602AbZLPGQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 01:16:11 -0500
Date: Wed, 16 Dec 2009 06:16:02 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: updated git tree [git pull] drm fixes + hdmi audio
In-Reply-To: <alpine.DEB.2.00.0912160603160.25055@skynet.skynet.ie>
Message-ID: <alpine.DEB.2.00.0912160614500.25055@skynet.skynet.ie>
References: <alpine.DEB.2.00.0912160603160.25055@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-189873072-1260944162=:25055"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-189873072-1260944162=:25055
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


On Wed, 16 Dec 2009, Dave Airlie wrote:

> 
> Hi Linus,
> 
> Please pull the 'drm-linus' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
> 
> This contains radeon HDMI audio support, along with fixes to nouveau for 
> powerpc from Ben H, some build fixes for nouveau, some TTM fixes,
> and some radeon regression fixes we've found since the merge.

+ 2 fixes for the command stream checker for radeon mesa support - updated
stats below.

> 
> I still have an outstanding pull request for the vmware KMS driver at:
> Please pull the 'drm-vmware-staging' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-vmware-staging
> 
> Though that shouldn't affect this pull at all.

 drivers/gpu/drm/nouveau/Kconfig          |    5 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c     |    2 +
 drivers/gpu/drm/nouveau/nouveau_fence.c  |    2 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c    |    7 -
 drivers/gpu/drm/nouveau/nouveau_mem.c    |    4 +
 drivers/gpu/drm/nouveau/nv40_graph.c     |   20 +-
 drivers/gpu/drm/radeon/Makefile          |    2 +-
 drivers/gpu/drm/radeon/r100.c            |   54 +++-
 drivers/gpu/drm/radeon/r100_track.h      |    5 +
 drivers/gpu/drm/radeon/r200.c            |   10 +-
 drivers/gpu/drm/radeon/r300.c            |   24 ++-
 drivers/gpu/drm/radeon/r600.c            |   19 +-
 drivers/gpu/drm/radeon/r600_audio.c      |  267 ++++++++++++++++
 drivers/gpu/drm/radeon/r600_hdmi.c       |  506 ++++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/r600_reg.h        |   74 +++++
 drivers/gpu/drm/radeon/radeon.h          |   25 ++
 drivers/gpu/drm/radeon/radeon_drv.c      |    4 +
 drivers/gpu/drm/radeon/radeon_encoders.c |   16 +-
 drivers/gpu/drm/radeon/radeon_gem.c      |    8 +-
 drivers/gpu/drm/radeon/radeon_mode.h     |    3 +
 drivers/gpu/drm/radeon/radeon_object.c   |   21 +-
 drivers/gpu/drm/radeon/radeon_object.h   |   16 +-
 drivers/gpu/drm/radeon/radeon_pm.c       |    7 +-
 drivers/gpu/drm/radeon/radeon_ttm.c      |   14 +-
 drivers/gpu/drm/radeon/rs400.c           |    2 +
 drivers/gpu/drm/radeon/rv770.c           |   14 +-
 drivers/gpu/drm/ttm/ttm_bo.c             |   77 +++--
 drivers/gpu/drm/ttm/ttm_bo_vm.c          |    2 +-
 28 files changed, 1118 insertions(+), 92 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/r600_audio.c
 create mode 100644 drivers/gpu/drm/radeon/r600_hdmi.c

commit d785d78bbdb53580b12c40e820af5a3281ce2fc8
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Dec 7 13:16:06 2009 +1000

    drm/radeon/kms: fix r100->r500 CS checker for compressed textures. (v2)
    
    This adds support for compressed textures to the r100->r500 CS
    checker, it lets me run openarena and the demos in mesa fine.
    
    Thanks to Maciej Cencora for initial comments.
    
    Changes since v1:
    fix calculations with Maciej formulas
    
    Reviewed-by: Maciej Cencora <m.cencora@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6e7267721fd67d626433ea10c59fc232c6928259
Author: Maciej Cencora <m.cencora@gmail.com>
Date:   Tue Dec 15 23:13:08 2009 +0100

    drm/radeon/kms: allow for texture tiling
    
    This adds the relocations for texture tiling for KMS.
    
    Signed-off-by: Maciej Cencora <m.cencora@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a3922105319120a48b97ebb42cb43acb5a7e4e73
Merge: ece84e0 6234077
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Dec 16 15:58:36 2009 +1000

    Merge remote branch 'korg/drm-radeon-next' into drm-linus
    
    * korg/drm-radeon-next:
      drm/radeon/kms: init pm on all chipsets

commit 6234077d6bad4db25d516743b6723c1b26505341
Author: Rafa³ Mi³ecki <zajec5@gmail.com>
Date:   Tue Dec 15 21:46:58 2009 +0100

    drm/radeon/kms: init pm on all chipsets
    
    Signed-off-by: Rafa³ Mi³ecki <zajec5@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ece84e04e99ff015fbf5071545ff2e643c9aea7f
Merge: dafc3bd 9ddc8c5
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Dec 16 15:52:21 2009 +1000

    Merge remote branch 'nouveau/for-airlied' of /ssd/git/drm-nouveau-next into drm-linus
    
    * 'nouveau/for-airlied' of /ssd/git/drm-nouveau-next:
      drm/nouveau: remove use of -ERESTART
      nouveau: Fix endianness with new context program loader
      drm/nouveau: fix build with CONFIG_AGP=n
      drm/nouveau: fix ch7006 build

commit dafc3bd515d6079406986f7748b48adb3c7170f2
Author: Christian Koenig <deathsimple@vodafone.de>
Date:   Sun Oct 11 23:49:13 2009 +0200

    drm/radeon/kms: HDMI support for R600 KMS
    
    Adding basic HDMI support for R600 KMS, ported from radeonhd ddx.
    
    [airlied:- checkpatch cleanups]
    Signed-off-by: Christian Koenig <deathsimple@vodafone.de>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7923c615b811945a9d9f456c92a7a32c34167458
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Dec 15 17:15:07 2009 -0500

    drm/radeon/kms: make sure mc is initialized before mapping blit bo
    
    We need to make sure the the MC is intialized before we map the
    blit shader object on r6xx+.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f89551bfe953a144f7d4918ca4c12e11de1e455d
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Tue Dec 15 18:23:23 2009 +0100

    drm/radeon/kms: Return to userspace on ERESTARTSYS
    
    radeon_object.h wasn't converted to ERESTARTSYS change. No
    each time we got an ERESTARTSYS we return to userspace (ie
    we were interrupted by a signal and we let the userspace
    reschedule the ioctl).
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 51f07b7ebce15c1848743a2ba43a0005375d8243
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Dec 16 13:10:43 2009 +1000

    drm/radeon/gem: don't leak a gem object if reserve fails on get tiling (v2)
    
    Not sure it ever happens in practice, spotted during code review.
    
    spare brace snuck in
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ecabd32a623eaf3e4c853ff73f200c8079028000
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Dec 15 10:39:48 2009 +1000

    drm/radeon/kms: don't report allocate failure on ERESTARTSYS
    
    if we fail with ERESTARTSYS during alloc, we'll get a retry from
    userspace so don't report it in dmesg.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d03d858970a158fa82d9ba0d502bdea0bdb3ad33
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Mon Dec 14 21:02:09 2009 +0100

    drm/radeon/kms: Check if bo we got from ttm are radeon object or not
    
    If they are not radeon object don't do anythings special for them,
    this avoid rare oops than can happen in a complex use case.
    
    [airlied: additional fixups]
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9fb03e63511cc20d413c2896396ba77df3db8411
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Fri Dec 11 15:13:22 2009 +0100

    drm/radeon/kms: If no placement is supplied fallback to system
    
    Do as we did before rework, if no placement is supplied at bo
    creation time, fallback to allocating bo from system ram. This
    will fix most of the creation failed issue report we got since
    the rework get merged.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5012f5063f41ca01240e5983c3b2cceb9aafc7a4
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Dec 10 18:07:26 2009 +0100

    drm/ttm: Fix memory type manager debug information printing
    
    System memory type doesn't have a drm_mm manager associated to
    it. This patch avoid trying to call drm_mm_debug on unitialized
    drm_mm when printing debug info on the system memory manager.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit eb6d2c39dbe46ea1c4f3da4eac5728c73f109ea1
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Dec 10 16:15:52 2009 +0100

    drm/ttm: Fix printk format & compute bo->mem.size at bo initialization
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9c51ba1db37cab780f38b2210913959f22d7b830
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Dec 2 18:33:46 2009 +0100

    drm/ttm: Fix potential ttm_mem_evict_first races.
    
    1) The function was previously called with a potentially empty
    LRU list which would have lead to an OOPS or servere corruption.
    2) In rare cases, after reservation has succeeded, another process may
    already have evicted it or even pinned it. We must revalidate the
    buffer status after releasing the lru lock.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit aaa207369436d04bb85382ddbb688a5b9461fd21
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Dec 2 18:33:45 2009 +0100

    drm/ttm: Delayed delete fixes.
    
    1) Remove from lru before reserving so we avoid competing with
    evicting processes.
    2) Avoid calling kref_put() on bo::list_kref while spinlocked.
    3) Additional refcounting bug-checking.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b663752627e7c6b4bc414684d71c6adce5719fce
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Dec 14 14:51:35 2009 +1000

    drm/ttm: fix two bugs in new placement routines.
    
    a) the loops were going to <= not <, leading to illegal memory access
    b) the busy placement checks were using the placement arrays not the
       busy placement ones.
    
    Acked-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b8ff7357da45e025c446fe0479612215fe56a249
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Dec 15 08:07:12 2009 +1000

    drm/ttm: fix incorrect logic in ttm_bo_io path
    
    This path isn't used by radeon yet, but future drivers will want it,
    so fix it right.
    
    Reported-by: Luca Barbieri <luca@luca-barbieri.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9ddc8c52f58338ddc278fc82e540d9eaf4489dc7
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Tue Dec 15 11:04:25 2009 +1000

    drm/nouveau: remove use of -ERESTART
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 81a5487756573b43458073969bc36b1e19124c24
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Mon Dec 14 14:31:40 2009 +1100

    nouveau: Fix endianness with new context program loader
    
    When switching to request_firmware() to load the context programs,
    some endian fixes need to be applied. This makes it work again on
    my quad g5 nvidia 6600.
    
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit b694dfb25a8de4ffbc14c9092ab8f88344ca86b1
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Tue Dec 15 10:38:32 2009 +1000

    drm/nouveau: fix build with CONFIG_AGP=n
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 61c2bb45697a56e96313a5f85f609b0c12ae26ff
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Mon Dec 14 11:51:40 2009 -0800

    drm/nouveau: fix ch7006 build
    
    The ch7006 driver could be built even when nouveau was not enabled,
    but the build fails in that case, so make it depend on DRM_NOUVEUA.
    
    Also make the I2c encoder/helper chips menu depend on I2C (no build
    error, just visual inspection).
    
    ERROR: "drm_helper_probe_single_connector_modes" [drivers/gpu/drm/i2c/ch7006.ko] undefined!
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
--29444707-189873072-1260944162=:25055--
