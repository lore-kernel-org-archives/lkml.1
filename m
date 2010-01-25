Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227Ab0AYGqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab0AYGqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 01:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121Ab0AYGqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 01:46:31 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40433 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab0AYGq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 01:46:29 -0500
Date: Mon, 25 Jan 2010 06:46:12 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes queue
Message-ID: <alpine.DEB.2.00.1001250645040.2474@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1356880992-1264401972=:2474"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1356880992-1264401972=:2474
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

I was out last week for sick kid + LCA dash so stuff queued up behind me, 
I've booted this across a few radeons.

core drm changes: one EDID parser fix - one slighty controversial revert
	a previous fix for FB blanking although correct, uncovered other
	bugs in Intel/radeon KMS drivers, so until fixes for them are available
	revert the part of the change the broke stuff.

nouveau: upstream fixes from F12 testing.
radeon: fixes all over the place from F12 bugs and upstream AMD changes.
	DVI->DP convertors work again
	IRQ fixes that fix kexec regression
	atombios parser updates from AMD should fix s/r bugs on newer cards
	minor r100/r200 command stream parser fixes

Possible r600 local priv escalation fix, the r600 could be used to access
system memory if someone was (a) really sneaky, (b) had a lot of time,
however the commit msg covers it all.

TTM: fix race condition in object deletion handling
vmware/staging: bunch of fixes from VMware for the staging driver
	

Dave.

 drivers/gpu/drm/drm_edid.c                  |    3 +-
 drivers/gpu/drm/drm_fb_helper.c             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c      |  187 ++++++++-----------
 drivers/gpu/drm/nouveau/nouveau_bo.c        |    2 +
 drivers/gpu/drm/nouveau/nouveau_connector.c |   31 +++-
 drivers/gpu/drm/nouveau/nouveau_dma.c       |   76 +++++---
 drivers/gpu/drm/nouveau/nouveau_dp.c        |    8 +-
 drivers/gpu/drm/nouveau/nouveau_drv.c       |    4 +
 drivers/gpu/drm/nouveau/nouveau_drv.h       |    3 +
 drivers/gpu/drm/nouveau/nouveau_gem.c       |   20 ++-
 drivers/gpu/drm/nouveau/nouveau_irq.c       |    7 +
 drivers/gpu/drm/nouveau/nouveau_mem.c       |   15 ++-
 drivers/gpu/drm/nouveau/nouveau_state.c     |    1 +
 drivers/gpu/drm/nouveau/nv04_instmem.c      |    2 +-
 drivers/gpu/drm/nouveau/nv50_crtc.c         |   22 +++-
 drivers/gpu/drm/nouveau/nv50_fifo.c         |    2 +-
 drivers/gpu/drm/nouveau/nv50_graph.c        |    3 +-
 drivers/gpu/drm/nouveau/nv50_sor.c          |   13 ++
 drivers/gpu/drm/radeon/atom.c               |  102 +++++++++--
 drivers/gpu/drm/radeon/atom.h               |    1 +
 drivers/gpu/drm/radeon/atombios_crtc.c      |  259 +++++++++++++++++---------
 drivers/gpu/drm/radeon/r100.c               |    5 +-
 drivers/gpu/drm/radeon/r200.c               |    7 +-
 drivers/gpu/drm/radeon/r420.c               |    4 +-
 drivers/gpu/drm/radeon/r600.c               |   82 +++++----
 drivers/gpu/drm/radeon/r600_blit_kms.c      |   14 +-
 drivers/gpu/drm/radeon/r600_cs.c            |   83 +++++++++
 drivers/gpu/drm/radeon/r600d.h              |   25 +++
 drivers/gpu/drm/radeon/radeon.h             |   11 +-
 drivers/gpu/drm/radeon/radeon_agp.c         |    7 +
 drivers/gpu/drm/radeon/radeon_clocks.c      |    4 +-
 drivers/gpu/drm/radeon/radeon_cs.c          |    1 +
 drivers/gpu/drm/radeon/radeon_device.c      |    1 +
 drivers/gpu/drm/radeon/radeon_display.c     |   45 +++--
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |   77 +-------
 drivers/gpu/drm/radeon/radeon_mode.h        |   28 ++-
 drivers/gpu/drm/radeon/radeon_object.c      |    3 +-
 drivers/gpu/drm/radeon/reg_srcs/r200        |    2 +
 drivers/gpu/drm/radeon/rv770.c              |   33 ++--
 drivers/gpu/drm/ttm/ttm_bo.c                |   69 ++++----
 drivers/gpu/drm/ttm/ttm_lock.c              |    2 +
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c      |   25 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c         |   63 +++++++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h         |    4 +
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c     |   19 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c          |    8 -
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c        |    3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c         |   12 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c     |    9 -
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c    |   64 ++++---
 include/drm/ttm/ttm_bo_driver.h             |    5 +
 51 files changed, 958 insertions(+), 520 deletions(-)

commit 7087e16286913b41ba9a5186360645b57b8508dd
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Jan 25 16:13:55 2010 +1000

    drm/radeon/kms: preface warning printk with driver name
    
    This just adds a little more info to the warning for old -ati/mesa
    userspaces.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f2ab3a13d2cbe19426c27c35a014c98212e914a5
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Jan 25 16:13:12 2010 +1000

    drm/radeon/kms: drop unnecessary printks.
    
    These printks aren't required anymore.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5fd4df4d475a7fee96fff54f6341192f547984e0
Author: Zhenyu Wang <zhenyuw@linux.intel.com>
Date:   Mon Jan 18 16:47:04 2010 +0800

    drm: fix regression in fb blank handling
    
    commit 731b5a15a3b1474a41c2ca29b4c32b0f21bc852e
    Author: James Simmons <jsimmons@infradead.org>
    Date:   Thu Oct 29 20:39:07 2009 +0000
    
        drm/kms: properly handle fbdev blanking
    
    uses DRM_MODE_DPMS_ON for FB_BLANK_NORMAL, but DRM_MODE_DPMS_ON
    is actually for turning output on instead of blank.
    
    This makes fb blank broken on my T61, it put LVDS on but leave
    pipe disabled which made screen totally white or caused some
    'burning' effect.
    
    [airlied: James objects to this but at this point in 2.6.33,
    I can't see a patch that will fix this properly like he wants coming
    in time and otherwise this is a regression - proper fix for 2.6.34
    hopefully.]
    
    Cc: James Simmons <jsimmons@infradead.org>
    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d796d8446fe0ff4442c1a1d0b10c861f17ac8168
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Jan 25 13:08:08 2010 +1000

    drm/radeon/kms: make hibernate work on IGPs
    
    This is the least invasive fix without migrating the radeon driver
    to pm_ops from what I can see. We just always migrate VRAM objects
    on IGPs for now and we can fix it up later to migrate depending
    on STR vs STD.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8ba5152a3acd5914cade42a1c8c9dc58ad8d1a89
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Sat Jan 16 16:05:05 2010 +0100

    drm/vmwgfx: Optimize memory footprint for DMA buffers.
    
    Use VRAM whenever there is free space for DMA buffers,
    but use system GMR memory if using VRAM would cause an eviction.
    
    This significantly reduces the guest system memory usage for
    VMs with a large amount of VRAM allocated.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0eaddb28d3460f13102cd82cf58af875bfb1bd53
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Sat Jan 16 16:05:04 2010 +0100

    drm/ttm: Allow system memory as a busy placement.
    
    This is needed to fix a vmwgfx memory usage bug.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9299795c6e1e11b2d1e6f53a03902dc80cfb3320
Merge: 8d586fe 38678d3
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Jan 25 16:04:21 2010 +1000

    Merge remote branch 'korg/drm-radeon-next' into drm-linus
    
    * korg/drm-radeon-next:
      drm/radeon/kms: fix legacy get_engine/memory clock
      drm/radeon/kms/atom: atom parser fixes
      drm/radeon/kms: clean up atombios pll code
      drm/radeon/kms: clean up pll struct
      drm/radeon/kms/atom: fix crtc lock ordering
      drm/radeon: r6xx/r7xx possible security issue, system ram access
      drm/radeon/kms: r600/r700 don't test ib if ib initialization fails
      drm/radeon/kms: Forbid creation of framebuffer with no valid GEM object
      drm/radeon/kms: r600 handle irq vector ring overflow
      drm/radeon/kms: r600/r700 don't process IRQ if not initialized
      drm/radeon/kms: r600/r700 disable irq at suspend
      drm/radeon/kms/r4xx: cleanup atom path
      drm/radeon/kms: fix atombios_crtc_set_base
      drm/radeon/kms/atom: upstream parser updates
      drm/radeon/kms/atom: fix some parser bugs
      drm/radeon/kms: fix hardcoded mmio size in register functions
      drm/radeon/kms/r100: fix bug in CS parser
      drm/radeon/kms/r200: fix bug in CS parser
      drm/radeon/kms/r200: fix bug in CS parser

commit 8d586fe65a33b1a3a2a2539119248ce12f4bab50
Merge: 1a961ce 1622653
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Jan 25 16:04:11 2010 +1000

    Merge remote branch 'nouveau/for-airlied' of ../drm-nouveau-next into drm-linus
    
    * 'nouveau/for-airlied' of ../drm-nouveau-next:
      drm/nv50: prevent switching off SOR when in use for DVI-over-DP
      drm/nv50: fail auxch transaction if reply count not what we expect
      drm/nouveau: fix failure path if userspace specifies no valid memtypes
      drm/nouveau: report LVDS as disconnected if lid closed
      drm/nv50: prevent accidently turning off encoders we're actually using
      drm/nv50: fix alignment of per-channel fifo cache
      drm/nouveau: Evict buffers in VRAM before freeing sgdma
      drm/nouveau: Acknowledge DMA_VTX_PROTECTION PGRAPH interrupts
      drm/nouveau: fix thinko in nv04_instmem.c
      drm/nouveau: fix a race condition in nouveau_dma_wait()

commit 1a961ce09fe39df9a1b796df98794fd32c76c413
Author: Luca Barbieri <luca@luca-barbieri.com>
Date:   Wed Jan 20 20:01:30 2010 +0100

    drm/ttm: Fix race condition in ttm_bo_delayed_delete (v3, final)
    
    Resending this with Thomas Hellstrom's signoff for merging into 2.6.33
    
    ttm_bo_delayed_delete has a race condition, because after we do:
    kref_put(&nentry->list_kref, ttm_bo_release_list);
    
    we are not holding the list lock and not holding any reference to
    objects, and thus every bo in the list can be removed and freed at
    this point.
    
    However, we then use the next pointer we stored, which is not guaranteed
    to be valid.
    
    This was apparently the cause of some Nouveau oopses I experienced.
    
    This patch rewrites the function so that it keeps the reference to nentry
    until nentry itself is freed and we already got a reference to nentry->next.
    
    v2 updated by me according to Thomas Hellstrom's feedback.
    v3 proposed by Thomas Hellstrom. Commit comment updated by me.
    
    Both updates fixed minor efficiency/style issues only and all three versions
    should be correct.
    
    Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 162265367a96d381f07066581d65e52627b08618
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Fri Jan 22 10:57:01 2010 +1000

    drm/nv50: prevent switching off SOR when in use for DVI-over-DP
    
    Another hack because of us exposing each encoder block's function as
    an encoder rather than exposing a single encoder that deals with them
    all.
    
    A proper fix will come, it's just rather invasive so this hack will
    do until then.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 0107bae01add219e1a146f2b412d64a7f1946028
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Fri Jan 22 09:10:05 2010 +1000

    drm/nv50: fail auxch transaction if reply count not what we expect
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 0208843dd59330c30e0773c77d5362260aa340e0
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Thu Jan 21 15:03:23 2010 +1000

    drm/nouveau: fix failure path if userspace specifies no valid memtypes
    
    We need to add the buffer to the list even if we fail, otherwise the
    validate_fini() call won't unreserve + unreference the GEM object,
    making TTM very unhappy.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit a1470890f29da73783e932078ed911f5871e3ad3
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Mon Jan 18 11:42:37 2010 +1000

    drm/nouveau: report LVDS as disconnected if lid closed
    
    Also adds a module option to ignore the status reported via ACPI, in case
    we hit systems with broken ACPI.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 38678d3557420a1c40f7ad5a04a46a7de7a305b9
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Jan 21 19:28:18 2010 -0500

    drm/radeon/kms: fix legacy get_engine/memory clock
    
    Fix a bad shift in the post div.
    
    Should fix fdo bug 26145
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 947bfc83043181e86e3e3134da158e479c9bcc51
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Jan 21 17:14:49 2010 -0500

    drm/radeon/kms/atom: atom parser fixes
    
    Only reset the reg block on the initial execute
    table call; nested calls require the reg block not be
    reset on each call.  Also reset the fb window and
    io mode.  This matches the upstream parser behavior.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4eaeca33512b9774c25507b9a9bdcfe3791a5cc5
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Jan 19 17:32:27 2010 -0500

    drm/radeon/kms: clean up atombios pll code
    
    - split pll adjust into a separate function
    - use a union for SetPixelClock params
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fc10332b8ac5ca32d11f898027d84c007543bd80
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Jan 19 17:16:10 2010 -0500

    drm/radeon/kms: clean up pll struct
    
    - add a new flag for fixed post div
    - pull the pll flags into the struct
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a348c84d953f61c776e53cde0a63a4e407a23c18
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Jan 21 16:50:30 2010 -0500

    drm/radeon/kms/atom: fix crtc lock ordering
    
    This makes crtc_prepare and crtc_commit match.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c8c15ff1e90bfc4a2db1ba77a01b3b2783e723fc
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Mon Jan 18 13:01:36 2010 +0100

    drm/radeon: r6xx/r7xx possible security issue, system ram access
    
    This patch workaround a possible security issue which can allow
    user to abuse drm on r6xx/r7xx hw to access any system ram memory.
    This patch doesn't break userspace, it detect "valid" old use of
    CB_COLOR[0-7]_FRAG & CB_COLOR[0-7]_TILE registers and overwritte
    the address these registers are pointing to with the one of the
    last color buffer. This workaround will work for old mesa &
    xf86-video-ati and any old user which did use similar register
    programming pattern as those (we expect that there is no others
    user of those ioctl except possibly a malicious one). This patch
    add a warning if it detects such usage, warning encourage people
    to update their mesa & xf86-video-ati. New userspace will submit
    proper relocation.
    
    Fix for xf86-video-ati / mesa (this kernel patch is enough to
    prevent abuse, fix for userspace are to set proper cs stream and
    avoid kernel warning) :
    http://cgit.freedesktop.org/xorg/driver/xf86-video-ati/commit/?id=95d63e408cc88b6934bec84a0b1ef94dfe8bee7b
    http://cgit.freedesktop.org/mesa/mesa/commit/?id=46dc6fd3ed5ef96cda53641a97bc68c3bc104a9f
    
    Abusing this register to perform system ram memory is not easy,
    here is outline on how it could be achieve. First attacker must
    have access to the drm device and be able to submit command stream
    throught cs ioctl. Then attacker must build a proper command stream
    for r6xx/r7xx hw which will abuse the FRAG or TILE buffer to
    overwrite the GPU GART which is in VRAM. To achieve so attacker
    as to setup CB_COLOR[0-7]_FRAG or CB_COLOR[0-7]_TILE to point
    to the GPU GART, then it has to find a way to write predictable
    value into those buffer (with little cleverness i believe this
    can be done but this is an hard task). Once attacker have such
    program it can overwritte GPU GART to program GPU gart to point
    anywhere in system memory. It then can reusse same method as he
    used to reprogram GART to overwritte the system ram through the
    GART mapping. In the process the attacker has to be carefull to
    not overwritte any sensitive area of the GART table, like ring
    or IB gart entry as it will more then likely lead to GPU lockup.
    Bottom line is that i think it's very hard to use this flaw
    to get system ram access but in theory one can achieve so.
    
    Side note: I am not aware of anyone ever using the GPU as an
    attack vector, nevertheless we take great care in the opensource
    driver to try to detect and forbid malicious use of GPU. I don't
    think the closed source driver are as cautious as we are.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit db96380ea26fcc31ab37189aedeabd12894b1431
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Sun Jan 17 21:21:56 2010 +0100

    drm/radeon/kms: r600/r700 don't test ib if ib initialization fails
    
    If ib initialization failed don't try to test ib as it will result
    in an oops (accessing NULL ib buffer ptr).
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 7e71c9e2e7704ebf044d4a964e02fbd2098a173f
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Sun Jan 17 21:21:41 2010 +0100

    drm/radeon/kms: Forbid creation of framebuffer with no valid GEM object
    
    This will avoid oops if at later point the fb is use. Trying to create
    a framebuffer with no valid GEM object is bogus and should be forbidden
    as this patch does.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 7924e5eb8fe422d6b1ce3b3e2be749a480dfcdd9
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Fri Jan 15 14:44:39 2010 +0100

    drm/radeon/kms: r600 handle irq vector ring overflow
    
    In some rare case i faced an irq overflow quickly followed by
    a GPU lockup (hard hang) this patch try to deal with irq vector
    ring overflow, so far haven't been able to reproduce it with
    the patch.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 79c2bbc505751bb5130ac753251fc9a0eb37bb12
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Fri Jan 15 14:44:38 2010 +0100

    drm/radeon/kms: r600/r700 don't process IRQ if not initialized
    
    In some rare case the wptr returned from the hw wasn't 0 and leaded
    to trick r600_process_irq that their were irq to process. Add a
    check to bail out if irq hasn't been initialized this will avoid
    oops provoqued by the rare wptr != 0 on initialization.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 0c45249f419d8b86abe0e51c6627ca4b085e8c23
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Fri Jan 15 14:44:37 2010 +0100

    drm/radeon/kms: r600/r700 disable irq at suspend
    
    To avoid hw doing anythings after we disabled PCIE GART, fully
    disable IRQ at suspend. Also cleanup a bit the ih structure
    and process function.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 615e0cb67968c94fd9e53797985843a5b816dec4
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Wed Jan 20 16:22:53 2010 -0500

    drm/radeon/kms/r4xx: cleanup atom path
    
    most of radeon_legacy_atom_set_surface() is taken care
    of in atombios_set_base(), so remove the duplicate
    setup and move the remaining bits (DISP_MERGE setup and
    FP2 sync) to atombios_crtc.c where they are used.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 54f088a9603dbee88809cb2ddfd8dc1ef8a74be5
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Jan 19 16:34:01 2010 -0500

    drm/radeon/kms: fix atombios_crtc_set_base
    
    Make it call the proper backend depending on the
    GPU family.  Right now r4xx cards with atombios modesetting
    enabled were using the avivo crtc base code.  This also
    allows us to add support for new asics more easily.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit e2f8e87089427d3a203538dc73058b90e82b11f6
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Jan 19 12:45:29 2010 -0500

    drm/radeon/kms/atom: upstream parser updates
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 9f53e7931610cbd1715fd2d2c0f9a853e17f02d8
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Jan 19 12:38:48 2010 -0500

    drm/radeon/kms/atom: fix some parser bugs
    
    - add support for inline src params
    - fix shift_left/shift_right and shl/shr ops
      shift_* ops use inline src params, shl/r use full params
    - fix mask op (uses inline params)
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 07bec2df01cde5590a1700b992d12de3f46b12bc
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Wed Jan 13 19:09:12 2010 -0500

    drm/radeon/kms: fix hardcoded mmio size in register functions
    
    newer asics have large mmio apertures
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit cf57fc7aa2ac61d02a29550b99db6a01ccd7917c
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Jan 18 20:20:07 2010 -0500

    drm/radeon/kms/r100: fix bug in CS parser
    
    The first dword of PACKET3_3D_DRAW_IMMD maps to
    SE_VTX_FMT so the vertex size is part of the draw
    packet.
    
    This patch fixes a possible case where you have a
    command buffer that does not contain SE_VTX_FMT
    register write, but does contain PACKET3_3D_DRAW_IMMD.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 828153e29206196552c2cc34461ad7e5b93e3f22
Author: Andrew Randrianasulu <randrik@mail.ru>
Date:   Wed Jan 20 11:56:07 2010 -0500

    drm/radeon/kms/r200: fix bug in CS parser
    
    Add missing vertex shader regs for r200.
    
    fixed fdo bug 26061
    
    agd5f: use official reg names
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit f3d1ccc14f37a07614c67a270f05a8d94ec3667c
Author: Andrew Randrianasulu <randrik@mail.ru>
Date:   Wed Jan 20 11:36:30 2010 -0500

    drm/radeon/kms/r200: fix bug in CS parser
    
    The checks for CUBE and 3D textures were inverted.
    
    fixes fdo bug 24159
    
    agd5f: added comments for clarity.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 58d65b84dee524b0a4a8b747b8eb8bbf2fb16d9d
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Mon Jan 18 08:52:35 2010 +1000

    drm/nv50: prevent accidently turning off encoders we're actually using
    
    On most cards the DisplayPort connector is created with 2 encoders sharing
    a single SOR (for native DP, and for DVI-over-DP).  The previous logic
    for turning off unused encoders didn't take into account that we could
    have multiple drm_encoders on a single hw encoder and ended up turning off
    encoders that were actually being used still.
    
    This patch fixes that issue.  We probably want to look at something a bit
    better later on, and only expose one drm_encoder per hw encoder block.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 134f248bea4bf5c3169b4950eb49c6651b09eb0e
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Mon Jan 18 08:33:04 2010 +1000

    drm/nv50: fix alignment of per-channel fifo cache
    
    GPU pointer to the structure is shifted right by 10 bits, so we need to
    align to 1024 bytes, not 256.
    
    Reported-by: Maarten Maathuis <madman2003@gmail.com>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 71666475018a3024fb49499096d26a9350349e8b
Author: Luca Barbieri <luca@luca-barbieri.com>
Date:   Sat Jan 16 15:30:15 2010 +0100

    drm/nouveau: Evict buffers in VRAM before freeing sgdma
    
    Currently, we take down the sgdma engine without evicting all buffers
    from VRAM.
    
    The TTM device release will try to evict anything in VRAM to GART
    memory, but this will fail since sgdma has already been taken down.
    
    This causes an infinite loop in kernel mode on module unload.
    It usually doesn't happen because there aren't any buffer on close.
    However, if the GPU is locked up, this condition is easily triggered.
    
    This patch fixes it in the simplest way possible by cleaning VRAM
    right before cleaning SGDMA memory.
    
    Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit d051bbb22e9d8e87e2a5b8efb176d1bfd0f7feee
Author: Luca Barbieri <luca@luca-barbieri.com>
Date:   Sat Jan 16 15:27:51 2010 +0100

    drm/nouveau: Acknowledge DMA_VTX_PROTECTION PGRAPH interrupts
    
    Currently Nouveau is unable to dismiss DMA_VTX_PROTECTION errors,
    which results in an infinite loop in the interrupt handler.
    
    These errors are caused both by bugs in the Gallium driver and by
    user-specified index buffers with out of bounds indices.
    
    By mmio-tracing the nVidia drivers, I found out how this is done.
    On DMA_VTX_PROTECTION, The nVidia driver reads the register 0x402000,
    always getting the value 4, and then writes 4 back to 0x402000.
    
    This patch adds that logic by reading 0x402000 and writing the same
    value back.
    It's unclear what should happen if the value read is not 4, and
    the current approach might not be the correct one.
    
    To test this, modify mesa/progs/trivial/vbo-drawrange.c, defining
    ELTOBJ to 1 and replacing indices with huge out of bounds integers.
    
    Without this patch, the GPU and/or kernel should lock up.
    With this patch, it should misrender as expected but not lock up.
    
    The errors are still logged since they are useful for development.
    
    This has been tested on NV49 and may not work on other cards.
    
    To find out how things work on other cards, run the aforementioned
    test using the blob with mmiotrace and grep for a read of the PGRAPH
    source register.
    
    Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 0d92971dd6973d865a873c24df2d7bfe06ec4486
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Fri Jan 15 12:21:37 2010 +1000

    drm/nouveau: fix thinko in nv04_instmem.c
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit ba59953d281747b1f7518a60f0ba8ff671cd0d65
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Fri Jan 15 12:08:57 2010 +1000

    drm/nouveau: fix a race condition in nouveau_dma_wait()
    
    Can be triggered easily on certain cards (NV46 and NV50 of mine) by
    running "dmesg", the DRM's channel will lockup.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 8471a26b9c36c965d278020cc0699e2e95d120e5
Merge: 79b7dcb 700a0cc
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Jan 15 15:40:39 2010 +1000

    Merge remote branch 'korg/drm-radeon-testing' into drm-linus
    
    * korg/drm-radeon-testing:
      drm/radeon/kms: Use radeon_agp_disable when disabling AGP
      drm/radeon/kms: Disable AGP is aperture size < 32M
      drm/radeon/kms: Fix r600 blit cleanup path
      drm/radeon/kms: Do not unpin buffer in fb destruction
      drm/radeon/kms: fix displayport->dvi connector DDC.

commit 79b7dcb2af7da728819cf060b94ce8c9ead36f7e
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Jan 14 19:02:20 2010 +0100

    drm: EDID accept separate sync video mode
    
    X is accepting such video mode, do the same. Pointed out by Joshua Roys
    on IRC. Fix https://bugzilla.redhat.com/show_bug.cgi?id=540024
    
    [fix printf to use composite not integrated :- airlied]
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 1c974dc21898f9abbcb5e47ae9ddb7e6b473de2e
Merge: 354fb52 12f735b
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Jan 15 13:22:59 2010 +1000

    Merge remote branch 'nouveau/for-airlied' of ../drm-nouveau-next into drm-linus
    
    * 'nouveau/for-airlied' of ../drm-nouveau-next: (44 commits)
      drm/nouveau: check pushbuffer bounds in ioctl
      drm/nouveau: reserve VGA area for the moment
      drm/nouveau: Unset the EDID connector property when the EDID block goes away.
      drm/nouveau: Fallback to analog load detection when the EDID block is invalid.
      drm/nouveau: fix edid memleak in nouveau_connector
      drm/nouveau: Break some long lines.
      drm/nouveau: add NV18 device id to call_lvds_manufacturer_script
      drm/nv50: Fix typo in PGRAPH initialisation.
      drm/nouveau: less magic DCB 1.5 parsing
      drm/nouveau: assume no nv04 board has a DCB table
      drm/nouveau: remove PRIV0 check in nouveau_mem_close()
      drm/nouveau: wait on fence after bo move if validating for another channel
      drm/nouveau: trust init table registers are safe
      drm/nv50: wait for pgraph to idle before unloading the context

commit 12f735b79f0ad63964dedabed3eee8a581bb66a5
Author: Luca Barbieri <luca@luca-barbieri.com>
Date:   Sun Jan 10 20:10:53 2010 +0100

    drm/nouveau: check pushbuffer bounds in ioctl
    
    Currently there is no check that the pushbuffer request bounds are inside
    the TTM BO.
    
    This allows to instruct the kernel to do relocations on user-selected
    addresses, since the relocation bounds checking relies on the request
    bounds.
    
    This can oops the kernel accidentally and is easily exploitable.
    
    This patch adds bound checking and alignment checking for ->offset and
    ->nr_dwords.
    
    It also makes some variables unsigned, which should have no effect,
    but prevents possible bounds checking problems.
    
    Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit ac8fb975e8c88d312a376b035494be17548d01c6
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Fri Jan 15 09:24:20 2010 +1000

    drm/nouveau: reserve VGA area for the moment
    
    This is to prevent things such as GART tables and other important GPU
    structures being allocated there before we take over fbcon ourselves.
    
    This is more of a workaround for the moment, a better solution will
    require some more invasive changes, but it'll be done at some point.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit b8780e2ad20feb8d086bc961a678e8fdb4fa296b
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Thu Jan 14 15:54:23 2010 +0100

    drm/nouveau: Unset the EDID connector property when the EDID block goes away.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 0ed3165e55fdedee6fc04b757907a2d5ccacdf18
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Thu Jan 14 15:47:03 2010 +0100

    drm/nouveau: Fallback to analog load detection when the EDID block is invalid.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit c8ebe275790f2c5efc3ffec515c93b7a139829d3
Author: Xavier Chantry <shiningxc@gmail.com>
Date:   Mon Jan 11 22:42:21 2010 +0100

    drm/nouveau: fix edid memleak in nouveau_connector
    
    This was spotted by kmemleak.
    
    Signed-off-by: Xavier Chantry <shiningxc@gmail.com>
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 3d9aefb8bd1be2b5e07acf0f938c21769f03cc64
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Thu Jan 14 14:56:54 2010 +0100

    drm/nouveau: Break some long lines.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit b79d8a65d52d3d80204e1bad30ee57bb5a58ced1
Author: Andrea Tacconi <tacconet@libero.it>
Date:   Thu Jan 14 14:52:37 2010 +0100

    drm/nouveau: add NV18 device id to call_lvds_manufacturer_script
    
    This fixes imac black screen (NV18 card)
    
    Signed-off-by: Andrea Tacconi <tacconet@libero.it>
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 716abaa8e52548e8863831cb32984655f46b5566
Author: Marcin Ko¶cielnicki <koriakin@0x04.net>
Date:   Tue Jan 12 18:21:56 2010 +0000

    drm/nv50: Fix typo in PGRAPH initialisation.
    
    This enables streamout functionality.
    
    Signed-off-by: Marcin Ko¶cielnicki <koriakin@0x04.net>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit b0d2de860bd621959bc826ffd42618fe1de37a61
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Thu Jan 14 17:53:04 2010 +1000

    drm/nouveau: less magic DCB 1.5 parsing
    
    This in the very least matches the parsing of all the previously known
    entries, and hopefully (at least closer to) correct for any we haven't
    seen yet.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit ed42f8240cfea13580fe91195e52c5247275e7df
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Thu Jan 14 15:58:10 2010 +1000

    drm/nouveau: assume no nv04 board has a DCB table
    
    There's a report of a TNT2 where the DCB table pointer is *not* NULL
    (it contains a part of a VBIOS data string), and we assume this means
    a DCB table is present, causing all kinds of hilarity.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 77cb5c75e89ccfeb993d9dec37f8edb3a855e9f4
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Wed Jan 13 11:22:33 2010 +1000

    drm/nouveau: remove PRIV0 check in nouveau_mem_close()
    
    We don't setup PRIV0 anymore, so this is unnecessary.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit e147eae80afe98b86a7921a40a709584e6603e34
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Tue Jan 12 15:28:19 2010 +1000

    drm/nouveau: wait on fence after bo move if validating for another channel
    
    Not an ideal solution, but it'll do for the moment for correctness.  We
    need to come up with a nicer way to manage inter-channel sync, the hw
    is unfortunately a little lacking in this area.
    
    Should fix some resume corruption, as well as corruption that may be seen
    while under memory pressure.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 9855e584d296a32bbcc1bb3d29b7e0ed078b03cc
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Tue Jan 12 13:02:19 2010 +1000

    drm/nouveau: trust init table registers are safe
    
    Apparently the original reason for checking this was there were known
    register accesses that caused hangs on some chipsets.  This was more
    than likely because of incorrect parsing of previous opcodes, and I
    hardly think aborting a script half way through is going to be any
    better (in fact, we have had bug reports where this has been the cause
    of s/r failures among other things).
    
    This patch (which has been in Fedora 12 for a long time now) removes
    all checking for known register ranges, and just leaves the check to
    ensure the access is within the mapped aperture to avoid an oops.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 0a90dc51aa3162abb7cd64323ba2e6674e1c5ff4
Author: Maarten Maathuis <madman2003@gmail.com>
Date:   Mon Jan 11 21:18:53 2010 +0100

    drm/nv50: wait for pgraph to idle before unloading the context
    
    This should fix the problem with gpu hangs people have had when closing
    channels.
    
    Signed-off-by: Maarten Maathuis <madman2003@gmail.com>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 354fb52cb6138de0e6cf84a0f6a7f3467586e390
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Jan 13 22:28:45 2010 +0100

    drm/ttm: Make sure system buffer objects has offset == 0.
    
    This is a convention that the vmwgfx driver has come to rely on.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d9f36a0051b7c0382107cb0342af1126a6eb627d
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Jan 13 22:28:43 2010 +0100

    drm/vmwgfx: Implement basic pm operations.
    
    Currently we really only support S3, since the device doesn't support
    saving of the 3D state.
    
    On S3/S4, move all buffer objects to swappable memory and take down
    GMR bindings. We need to do that from a PM notifier since we can't
    do persistant memory allocations from the standard PM callbacks.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e99e1e7893ac80fe769477cb1ddd4b482cef8902
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Jan 13 22:28:42 2010 +0100

    drm/ttm: Export symbols needed for vmwgfx suspend / resume operations.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 476d51dbdbaa2e61fa4899459c658f476eee3fd9
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Jan 13 22:28:41 2010 +0100

    drm/vmwgfx: Implement a swap_notify callback.
    
    Unbind GMR bindings on the buffer about to be swapped out.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3f09ea4ecdcbcea05541f83e557d6ce2e56626d8
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Jan 13 22:28:40 2010 +0100

    drm/ttm: Add a swap_notify callback.
    
    This is needed for a bugfix in the vmwgfx driver.
    Drivers may have GPU bindings on buffers that core TTM is not aware of,
    and TTM may view those buffers as ordinary system memory buffers.
    Add a notifier to such drivers when TTM is about to move the buffer
    contents out to swappable memory. The driver must then release any
    private GPU bindings on those buffers.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit effe1105bef07f42366c20eac41b80ff9fcf675e
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Jan 13 22:28:39 2010 +0100

    drm/vmwgfx: Use bo_driver::move_notify to unbind GMRs.
    
    This was previously done explicitly for overlay- and fb buffers.
    Now it's done for any buffer leaving the SYSTEM memory region.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7704befbd599e9c9524f640e14658ca8ed9d8717
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Jan 13 22:28:38 2010 +0100

    drm/vmwgfx: Make fence sequences continous across a VT switch.
    
    A vt switch in stealth mode would take down the FIFO, and re-
    initialize fence sequence numbers. This patch
    saves the current state of the fence sequence when the FIFO is
    disabled.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 50ec3b7c35fda131e92abc6f9d93a230b7e009eb
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Jan 13 22:28:37 2010 +0100

    drm/vmwgfx: Fix an error path causing an oops.
    
    An error happening before the snooper.image member had been set up
    would cause a kfree of an arbitrary pointer. Set up the snooper.image
    member early.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit df1c93bae2b671e2aa50899a120af20afdbd504b
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Jan 13 22:28:36 2010 +0100

    drm/vmwgfx: Don't promote updates from GMR-backed scanouts to fullscreen.
    
    That's unnecessary since partial screen updates from GMRs are fast.
    Also fix cliprect pointer dereferencing
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 700a0cc088a42a2ed92c6f961534fdb38588af87
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Jan 13 15:16:38 2010 +0100

    drm/radeon/kms: Use radeon_agp_disable when disabling AGP
    
    Use same common function to disable agp so we replace the GART
    callback by the proper one when we do so. This fix oops if
    radeon_agp_init report failure.
    
    This patch also move radeon_agp_init out of *_mc_init for r600
    & rv770 so that we can have a similar behavior than for previous
    hw, ie if agp_init fails it will fallback to GPU GART and disable
    AGP.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 0a3f316370da07fcdb11fde4f5a683d60713b7fd
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Jan 13 15:16:39 2010 +0100

    drm/radeon/kms: Disable AGP is aperture size < 32M
    
    radeon KMS need a GART of at least 32M to properly work. This patch
    check the AGP aperture size and disable if it's less than 32M. Note
    than unlike non KMS path we don't staticaly allocate AGP memory so
    we are not wasting memory not used by graphic processing.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 30d2d9a54d48e4fefede0389ded1b6fc2d44a522
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Jan 13 10:29:27 2010 +0100

    drm/radeon/kms: Fix r600 blit cleanup path
    
    r600 blit cleanup path need to check if a bo was allocated before
    trying to free or unpin it. This patch add this check and avoid
    oops when the initialization on r6xx or r7xx hw fails.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6398d42454ce1671b3422c34fd0f600c9c76c8b1
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Jan 13 12:32:36 2010 +0100

    drm/radeon/kms: Do not unpin buffer in fb destruction
    
    It's not necessary to unpin buffer in fb destruction. pin/unpin
    need to be balanced and we don't pin in fb creation. We pin when
    an fb is associated to a crtc and unpin when the fb is disassociated
    from the crtc.
    
    Note:
    Maybe we should take reference on fb in set_base callback so fb
    doesn't disappear until it's unbind from ctrc.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7a15cbd40108a670baae71cbd3cec62b65891fa6
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Jan 14 11:42:17 2010 +1000

    drm/radeon/kms: fix displayport->dvi connector DDC.
    
    It appears that attempting AUXCH DDC breaks the subsequent attempt
    to do DDC over the i2c lines, so use the sink type to determine
    if we should be doing AUXCH or i2c DDC.
    
    This fixes my DVI monitor plugged into DP->DVI convertor.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

--29444707-1356880992-1264401972=:2474--
