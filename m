Return-Path: <linux-kernel-owner+w=401wt.eu-S1751749AbZLWBeC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbZLWBeC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 20:34:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbZLWBd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 20:33:59 -0500
Received: from gir.skynet.ie ([193.1.99.77]:52774 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbZLWBd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 20:33:58 -0500
Date: Wed, 23 Dec 2009 01:33:50 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm-linus
Message-ID: <alpine.DEB.2.00.0912230126510.5453@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-605202163-1261532030=:5453"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-605202163-1261532030=:5453
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

core: add Arnd's unlocked ioctl support, this in theory (and on booting)
doesn't affect anything, it moves the drm to using unlocked_ioctl, but 
takes the lock. None of the ioctls are setup to use the unlocked path yet,
so all driver and core drm operations will still take it. The vmware 
driver had its own method to use unlocked ioctls so that's been modified
to use Arnd's code. The main reason to merge this is downstream driver 
writers can change their ioctls for drm-next and test it a lot easier.

nouveau: updates for suspend/resume, nv40 free ctxprogs, multi-card fixes
radeon kms: scattered bug fixes, modeset + accel code
vmwgfx: unlocked fixups + drm ioctl flags cleanup

other: misc janitorial patches.

I'll be off until 5th Jan after this, (though lkml might be read on and 
off, until the 28th).

Dave.

 drivers/gpu/drm/drm_drv.c                       |   13 +-
 drivers/gpu/drm/drm_edid.c                      |    2 +-
 drivers/gpu/drm/drm_ioc32.c                     |   89 +--
 drivers/gpu/drm/drm_mm.c                        |    4 +-
 drivers/gpu/drm/i2c/ch7006_drv.c                |    5 +
 drivers/gpu/drm/i2c/ch7006_mode.c               |    5 -
 drivers/gpu/drm/i810/i810_dma.c                 |    2 +-
 drivers/gpu/drm/i810/i810_drv.c                 |    2 +-
 drivers/gpu/drm/i830/i830_dma.c                 |    2 +-
 drivers/gpu/drm/i830/i830_drv.c                 |    2 +-
 drivers/gpu/drm/i915/i915_drv.c                 |    2 +-
 drivers/gpu/drm/i915/i915_ioc32.c               |   23 +-
 drivers/gpu/drm/mga/mga_drv.c                   |    2 +-
 drivers/gpu/drm/mga/mga_ioc32.c                 |   13 +-
 drivers/gpu/drm/nouveau/Makefile                |    5 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c          |  621 ++++++++++-----------
 drivers/gpu/drm/nouveau/nouveau_bios.h          |    1 +
 drivers/gpu/drm/nouveau/nouveau_bo.c            |   19 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c     |    8 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c            |   28 +-
 drivers/gpu/drm/nouveau/nouveau_drv.c           |    8 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h           |   27 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c         |   22 +-
 drivers/gpu/drm/nouveau/nouveau_grctx.c         |  161 ++++++
 drivers/gpu/drm/nouveau/nouveau_grctx.h         |  133 +++++
 drivers/gpu/drm/nouveau/nouveau_ioc32.c         |    4 +-
 drivers/gpu/drm/nouveau/nouveau_state.c         |  147 +++--
 drivers/gpu/drm/nouveau/nv04_crtc.c             |   10 +-
 drivers/gpu/drm/nouveau/nv04_dac.c              |    8 +-
 drivers/gpu/drm/nouveau/nv04_dfp.c              |    8 +-
 drivers/gpu/drm/nouveau/nv04_display.c          |   11 +-
 drivers/gpu/drm/nouveau/nv04_graph.c            |    2 +-
 drivers/gpu/drm/nouveau/nv10_graph.c            |  197 +++++--
 drivers/gpu/drm/nouveau/nv17_tv.c               |    4 +-
 drivers/gpu/drm/nouveau/nv40_graph.c            |  212 ++------
 drivers/gpu/drm/nouveau/nv40_grctx.c            |  678 +++++++++++++++++++++++
 drivers/gpu/drm/nouveau/nv50_crtc.c             |   22 +-
 drivers/gpu/drm/nouveau/nv50_cursor.c           |    8 +-
 drivers/gpu/drm/nouveau/nv50_dac.c              |   20 +-
 drivers/gpu/drm/nouveau/nv50_display.c          |   20 +-
 drivers/gpu/drm/nouveau/nv50_fifo.c             |    2 +-
 drivers/gpu/drm/nouveau/nv50_graph.c            |   10 +-
 drivers/gpu/drm/nouveau/nv50_sor.c              |   16 +-
 drivers/gpu/drm/r128/r128_drv.c                 |    2 +-
 drivers/gpu/drm/r128/r128_ioc32.c               |   16 +-
 drivers/gpu/drm/radeon/atom.c                   |   12 +-
 drivers/gpu/drm/radeon/atom.h                   |    1 +
 drivers/gpu/drm/radeon/atombios.h               |  199 +++++++
 drivers/gpu/drm/radeon/r100.c                   |    4 +
 drivers/gpu/drm/radeon/r100_track.h             |    4 +-
 drivers/gpu/drm/radeon/r300.c                   |   30 +
 drivers/gpu/drm/radeon/r300_cmdbuf.c            |    6 +-
 drivers/gpu/drm/radeon/r300_reg.h               |    1 +
 drivers/gpu/drm/radeon/r600_cs.c                |    4 +-
 drivers/gpu/drm/radeon/radeon.h                 |    4 +-
 drivers/gpu/drm/radeon/radeon_asic.h            |    7 +-
 drivers/gpu/drm/radeon/radeon_atombios.c        |  105 +++-
 drivers/gpu/drm/radeon/radeon_clocks.c          |    2 +-
 drivers/gpu/drm/radeon/radeon_combios.c         |    9 +-
 drivers/gpu/drm/radeon/radeon_connectors.c      |   16 +-
 drivers/gpu/drm/radeon/radeon_device.c          |   80 +++-
 drivers/gpu/drm/radeon/radeon_display.c         |    2 +-
 drivers/gpu/drm/radeon/radeon_drv.c             |    4 +-
 drivers/gpu/drm/radeon/radeon_encoders.c        |   18 +-
 drivers/gpu/drm/radeon/radeon_fence.c           |    9 +-
 drivers/gpu/drm/radeon/radeon_ioc32.c           |   38 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c     |    5 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    2 +
 drivers/gpu/drm/radeon/radeon_mode.h            |    6 +
 drivers/gpu/drm/radeon/radeon_test.c            |    4 +-
 drivers/gpu/drm/radeon/radeon_ttm.c             |    4 +
 drivers/gpu/drm/savage/savage_drv.c             |    2 +-
 drivers/gpu/drm/sis/sis_drv.c                   |    2 +-
 drivers/gpu/drm/tdfx/tdfx_drv.c                 |    2 +-
 drivers/gpu/drm/via/via_drv.c                   |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c             |   47 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h             |   10 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c         |  157 +++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c            |    6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c             |    6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c             |    8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c        |  149 +++---
 include/drm/drmP.h                              |    5 +-
 83 files changed, 2502 insertions(+), 1066 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_grctx.c
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_grctx.h
 create mode 100644 drivers/gpu/drm/nouveau/nv40_grctx.c

commit d94a5108f716bbd524358eb5a440d63991744a62
Merge: 44f9e6c 0786201
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Dec 23 11:18:33 2009 +1000

    Merge remote branch 'korg/drm-radeon-next' into drm-linus
    
    * korg/drm-radeon-next:
      drm/radeon/kms: add definitions for v4 power tables
      drm/radeon/kms: never combine LVDS with another encoder
      drm/radeon/kms: Check module arguments to be valid V2
      drm/radeon/kms: Avoid crash when trying to cleanup uninitialized structure
      drm/radeon/kms: add cvt mode if we only have lvds w/h and no edid (v4)
      drm/radeon/kms: add 3DC compression support
      drm/radeon/kms: allow rendering while no colorbuffer is set on r300
      drm/radeon/kms: enable memory clock reading on legacy (V2)
      drm/radeon/kms: prevent parallel AtomBIOS calls
      drm/radeon/kms: set proper default tv standard
      drm/radeon/kms: fix legacy rmx
      drm/radeon/kms/atom: fill in proper defines for digital setup

commit 0786201d8cd0730e72b0e087484dd47cc5f58409
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Sat Dec 19 12:45:12 2009 -0500

    drm/radeon/kms: add definitions for v4 power tables
    
    [airlied: just adding this for completeness to avoid drift between
    public atombios.h files]
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f56cd64f5f713a3013c4d980a5695c198d839671
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Dec 18 11:28:22 2009 -0500

    drm/radeon/kms: never combine LVDS with another encoder
    
    When linking multiple encoders to a connector, make sure
    to not link LVDS with another connector.  Some bioses
    have the same i2c line for LVDS and VGA.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3642133816f9f25065e3ca310f0720574bcdcc52
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Fri Dec 11 21:18:34 2009 +0100

    drm/radeon/kms: Check module arguments to be valid V2
    
    This patch add a function which check module argument to be
    valid. On invalid argument it prints a warning and setback
    the default value.
    
    V2: Allow 0 for vram limit & agp mode which are the default
    value
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0a0c7596c643239e8d4c3eaaba43b74a96f2411e
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Fri Dec 11 20:36:19 2009 +0100

    drm/radeon/kms: Avoid crash when trying to cleanup uninitialized structure
    
    Add boolean to record if some part of the driver are initialized or
    not this allow to avoid a crash when trying to cleanup uninitialized
    structure members.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d2efdf6d6f425950a61fa5cc3aa22e6718e7f3c8
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Dec 22 10:06:49 2009 -0500

    drm/radeon/kms: add cvt mode if we only have lvds w/h and no edid (v4)
    
    This fixes LVDS on some mac laptops without a panel edid.
    
    v2 - Set proper mode type flags
    v3 - Note that this is not neceesarily the exact panel mode,
    but an approximation based on the cvt formula.  For these
    systems we should ideally read the mode info out of the
    registers or add a mode table, but this works and is much
    simpler.
    v4 - Update comments and debug message.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 512889f450c1851d9e3628f1894b9b64b0701eac
Author: Marek Ol¹ák <maraeo@gmail.com>
Date:   Sat Dec 19 00:23:00 2009 +0100

    drm/radeon/kms: add 3DC compression support
    
    There are 2 formats:
    ATI1N: 64 bits per 4x4 block, one-channel format
    ATI2N: 128 bits per 4x4 block, two-channel format
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 46c64d4bfa01cda7d58c514164f8b127ab6741b7
Author: Marek Ol¹ák <maraeo@gmail.com>
Date:   Thu Dec 17 06:02:28 2009 +0100

    drm/radeon/kms: allow rendering while no colorbuffer is set on r300
    
    Because hardware cannot disable all colorbuffers directly to do depth-only
    rendering, a user should:
    - disable reading from a colorbuffer in blending
    - disable fastfill
    - set the color channel mask to 0 to prevent writing to a colorbuffer
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5ea597f3764880ab3a67fe2246218634a8c12778
Author: Rafa³ Mi³ecki <zajec5@gmail.com>
Date:   Thu Dec 17 13:50:09 2009 +0100

    drm/radeon/kms: enable memory clock reading on legacy (V2)
    
    V2: detect IGP cards (which don't have own memory)
    
    Signed-off-by: Rafa³ Mi³ecki <zajec5@gmail.com>
    Acked-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c31ad97f1886a2ff0f3356dc31d50c57944365da
Author: Rafa³ Mi³ecki <zajec5@gmail.com>
Date:   Thu Dec 17 00:00:46 2009 +0100

    drm/radeon/kms: prevent parallel AtomBIOS calls
    
    This just adds a mutex around the atombios table execution
    so we don't call it from two contexts at once.
    
    Signed-off-by: Rafa³ Mi³ecki <zajec5@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d79766fab9975c6414ebab7d2abf017834a48c35
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Dec 17 19:00:29 2009 -0500

    drm/radeon/kms: set proper default tv standard
    
    we were just using 1 before.
    
    reported on irc by soreau
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 310a82c8c5fc431913fe34a17251118e71c2c876
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Dec 17 01:24:59 2009 -0500

    drm/radeon/kms: fix legacy rmx
    
    This makes 640x480 on my R100 work again, both
    in aspect and centered mode.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Tested-by: Dave Airlie <airlied@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit edc664e314d5dadc326cfc15a536fe906d652204
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Dec 17 11:22:01 2009 -0500

    drm/radeon/kms/atom: fill in proper defines for digital setup
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 44f9e6c6bc508b202755d9e9e48a8ba96a5f0fa4
Merge: 29ebdf9 37cb3e0
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Dec 23 10:28:24 2009 +1000

    Merge remote branch 'nouveau/for-airlied' into drm-linus
    
    * nouveau/for-airlied:
      drm/nouveau: fix bug causing pinned buffers to lose their NO_EVICT flag
      drm/nv50: fix suspend/resume delays without firmware present
      drm/nouveau: prevent all channel creation if accel not available
      drm/nv50: fix two potential suspend/resume oopses
      drm/nv40: implement ctxprog/state generation
      drm/nv10: Add the initial graph context and soft methods needed for LMA.
      drm/nouveau: Fix up buffer eviction, and evict them to GART, if possible.
      drm/nouveau: Add proper error handling to nouveau_card_init
      drm/nv04: Fix NV04 set_operation software method.
      drm/nouveau: Kill global state in BIOS script interpreter
      drm/nouveau: Kill global state in NvShadowBIOS
      drm/nouveau: use drm debug levels
      drm/i2c/ch7006: Fix load detection false positives right after system init.
      drm/nv04-nv40: Fix "conflicting memory types" when saving/restoring VGA fonts.

commit 29ebdf925c2c45f6531a953c6c5c8e4d3b4ac2dc
Author: Marin Mitov <mitov@issp.bas.bg>
Date:   Sun Dec 20 09:03:27 2009 +0200

    drm/kms: silencing a false positive warning.
    
    warning: 'width' may be used uninitialized in this function
    drivers/gpu/drm/drm_edid.c
    
    Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e2108eb1f66d77b4af77caf282cab1d47e3f4831
Author: Bob Gleitsmann <rjgleits@bellsouth.net>
Date:   Mon Dec 21 13:52:09 2009 +1000

    drm/mm: fix logic for selection of best fit block
    
    This is from bug 25728.
    
    [airlied: I'm just forwarding the patch for review, Thomas, ickle?]
    
    Acked-by: Jerome Glisse <jglisse@redhat.com>
    Acked-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7a73ba7469cbea631050094fd14f73acebb97cf9
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Tue Dec 22 16:53:41 2009 +0100

    drm/vmwgfx: Use TTM handles instead of SIDs as user-space surface handles.
    
    Improve the command verifier to catch all occurences of surface handles,
    and translate to SIDs.
    
    This way DMA buffers and 3D surfaces share a common handle space,
    which makes it possible for the kms code to differentiate.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3d3a5b3290043618e8409f3fb68a63de6156fdd4
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Tue Dec 8 12:59:34 2009 +0100

    drm/vmwgfx: Return -ERESTARTSYS when interrupted by a signal.
    
    Fixes for TTM API change.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e1f7800315d78686481b27b113a3317ac687b6bf
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Tue Dec 8 12:57:51 2009 +0100

    drm/vmwgfx: Fix unlocked ioctl and add proper access control
    
    This fixes up vmwgfx for the unlocked ioctl code to avoid
    doing it in the driver. Also adds ioctl flags.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Jakob Bornecrantz <jakob@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 794f3141a194a4f4c28c1d417b071a901f78d9bb
Author: Dave Airlie <airlied@linux.ie>
Date:   Sun Dec 20 16:08:40 2009 +1000

    drm/radeon: fix build on 64-bit with some compilers.
    
    drivers/gpu/drm/radeon/radeon_test.c:45: undefined reference to `__udivdi3'
    
    Reported-by: Mr. James W. Laferriere <babydr@baby-dragons.com>
    Cc: stable@kernel.org
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e265f39e1ff026dcc787f1953c048f3de5aefd16
Author: Julia Lawall <julia@diku.dk>
Date:   Sat Dec 19 08:16:33 2009 +0100

    drivers/gpu: Use kzalloc for allocating only one thing
    
    Use kzalloc rather than kcalloc(1,...)
    
    The use of the allocated memory that looks like an array is &p->relocs[0],
    but this should be the same as p->relocs.
    
    The semantic patch that makes this change is as follows:
    (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @@
    @@
    
    - kcalloc(1,
    + kzalloc(
              ...)
    // </smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 01136acff8cc8251822fbae77f11e8029049c6f1
Author: Andi Kleen <andi@firstfloor.org>
Date:   Mon Dec 21 02:24:47 2009 +0100

    DRM: Rename clamp variable
    
    linux/kernel.h has a "clamp" macro, but r300_cmdbuf also uses a variable
    with the same name. Right now it doesn't seem to include the header,
    but sooner or later someone will. So better rename the variable
    now.
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ed8b67040965e4fe695db333d5914e18ea5f146f
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Wed Dec 16 22:17:09 2009 +0000

    drm: convert drm_ioctl to unlocked_ioctl
    
    drm_ioctl is called with the Big Kernel Lock held,
    which shows up very high in statistics on vfs_ioctl.
    
    Moving the lock into the drm_ioctl function itself
    makes sure we blame the right subsystem and it gets
    us one step closer to eliminating the locked version
    of fops->ioctl.
    
    Since drm_ioctl does not require the lock itself,
    we only need to hold it while calling the specific
    handler. The 32 bit conversion handlers do not
    interact with any other code, so they don't need
    the BKL here either and can just call drm_ioctl.
    
    As a bonus, this cleans up all the other users
    of drm_ioctl which now no longer have to find
    the inode or call lock_kernel.
    
    [airlied: squashed the non-driver bits
    of the second patch in here, this provides
    the flag for drivers to use to select unlocked
    ioctls - but doesn't modify any drivers].
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Cc: David Airlie <airlied@linux.ie>
    Cc: dri-devel@lists.sourceforge.net
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 37cb3e08852be92d94e6a65c489bd8afa2e8a15f
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Wed Dec 16 16:22:42 2009 +1000

    drm/nouveau: fix bug causing pinned buffers to lose their NO_EVICT flag
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 65ec01a9406327f22b1c740f8a42cb93eb676eb5
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Wed Dec 16 15:07:45 2009 +1000

    drm/nv50: fix suspend/resume delays without firmware present
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 0735f62e116fae1e4f36237a97de28e8a56b4c2c
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Wed Dec 16 14:28:55 2009 +1000

    drm/nouveau: prevent all channel creation if accel not available
    
    Previously, if there was no firmware available, the DRM would just
    disable channel creation from userspace, but still use a single
    channel for its own purposes.
    
    With a bit of care it should actually be possible to do this, due
    to the DRM's very limited use of the engine.  It currently doesn't
    work correctly however, resulting in corrupted fbcon and hangs on
    a number of cards.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 3c8868d3dbba5110bd43b49879f12d1a6b2a28ca
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Wed Dec 16 14:51:13 2009 +1000

    drm/nv50: fix two potential suspend/resume oopses
    
    This avoids touching the dummy channel 0/127 we have on nv50.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 054b93e444550a72aef17115363cdef253b9ee7c
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Tue Dec 15 22:02:47 2009 +1000

    drm/nv40: implement ctxprog/state generation
    
    The context programs are *very* simple compared to the ones used by
    the binary driver.  There's notes in nv40_grctx.c explaining most of
    the things we don't implement.  If we discover if/why any of it is
    required further down the track, we'll handle it then.
    
    The PGRAPH state generated for each chipset should match what NVIDIA
    do almost exactly (there's a couple of exceptions).  If someone has
    a lot of time on their hands, they could figure out the mapping of
    object/method to PGRAPH register and demagic the initial state a little,
    it's not terribly important however.
    
    At time of commit, confirmed to be working at least well enough for
    accelerated X (and where tested, for 3D apps) on NV40, NV43, NV44, NV46,
    NV49, NV4A, NV4B and NV4E.
    
    A module option has been added to force the use of external firmware
    blobs if it becomes required.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 15bee69ee1532a29e13124b298027ee6ef54bac8
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Mon Dec 14 15:00:30 2009 +0100

    drm/nv10: Add the initial graph context and soft methods needed for LMA.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 22fbd53809eb7a1b00fe09159fe0a565fb6c725c
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Fri Dec 11 18:40:17 2009 +0100

    drm/nouveau: Fix up buffer eviction, and evict them to GART, if possible.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit c5804be0627508487bd9eacebf9de7f807e5d4e7
Author: Marcin Ko¶cielnicki <koriakin@0x04.net>
Date:   Mon Dec 14 20:58:39 2009 +0000

    drm/nouveau: Add proper error handling to nouveau_card_init
    
    Signed-off-by: Marcin Ko¶cielnicki <koriakin@0x04.net>
    Signed-off-by: Maarten Maathuis <madman2003@gmail.com>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 13c5443b515109f175bb9917c578a7ae973f6851
Author: Marcin Ko¶cielnicki <koriakin@0x04.net>
Date:   Mon Dec 14 20:38:17 2009 +0000

    drm/nv04: Fix NV04 set_operation software method.
    
    Signed-off-by: Marcin Ko¶cielnicki <koriakin@0x04.net>
    Signed-off-by: Maarten Maathuis <madman2003@gmail.com>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 37383650e4f47aef633055e3f62e87a44d83312d
Author: Marcin Ko¶cielnicki <koriakin@0x04.net>
Date:   Tue Dec 15 00:37:31 2009 +0000

    drm/nouveau: Kill global state in BIOS script interpreter
    
    Signed-off-by: Marcin Ko¶cielnicki <koriakin@0x04.net>
    Signed-off-by: Maarten Maathuis <madman2003@gmail.com>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 657b6245ba23d32c7a4fd273549c8c0beebec770
Author: Marcin Ko¶cielnicki <koriakin@0x04.net>
Date:   Tue Dec 15 00:37:30 2009 +0000

    drm/nouveau: Kill global state in NvShadowBIOS
    
    Signed-off-by: Marcin Ko¶cielnicki <koriakin@0x04.net>
    Signed-off-by: Maarten Maathuis <madman2003@gmail.com>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit ef2bb506687a5f1cc8ef2fef370bb168b2808106
Author: Maarten Maathuis <madman2003@gmail.com>
Date:   Sun Dec 13 16:53:12 2009 +0100

    drm/nouveau: use drm debug levels
    
    - Use driver level (0x2) for NV_DEBUG instead of all levels
    - Create a NV_DEBUG_KMS for KMS level (0x4) and use them in modesetting code
    - Remove a few odd NV_TRACE calls and replace some of them with NV_DEBUG_KMS or
    NV_INFO
    
    Signed-off-by: Maarten Maathuis <madman2003@gmail.com>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit dc4a684ae80d914b2b7fe75b2733a3296a8b92d2
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Tue Dec 15 01:34:42 2009 +0100

    drm/i2c/ch7006: Fix load detection false positives right after system init.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 95f158eab42f971c2a6f82cc886ce657d92a25f4
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Fri Dec 11 23:44:49 2009 +0100

    drm/nv04-nv40: Fix "conflicting memory types" when saving/restoring VGA fonts.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
--29444707-605202163-1261532030=:5453--
