Return-Path: <linux-kernel-owner+w=401wt.eu-S1752479AbZG2HiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbZG2HiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 03:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZG2HiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 03:38:15 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60387 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbZG2HiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 03:38:13 -0400
Date: Wed, 29 Jul 2009 08:38:12 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] update the staging radeon kms driver
Message-ID: <alpine.DEB.2.00.0907290834120.25358@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1963875480-1248853092=:25358"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1963875480-1248853092=:25358
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please read below then think about pulling the 'drm-radeon-kms' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-radeon-kms

The radeon kms driver has gotten a lot of bugfixes and cleanups in the run 
up to using it in F12, I'm going to be pulling this tree in there, so I said I 
may as well offer it up for you to include. I've been careful to not touch 
any code outside the radeon kms and TTM code (I even dropped some patches 
that touched the main drm code). The only non-kms file touched is adding 
an export needed for TTM.

You can pull this if you want, the kms driver is under staging and I'd 
like to have a better working baseline in the 2.6.31 final kernel than 
what we have now.

Dave.

 arch/x86/mm/highmem_32.c                        |    1 +
 drivers/gpu/drm/radeon/Makefile                 |    3 +-
 drivers/gpu/drm/radeon/atombios_crtc.c          |  293 +++++-----
 drivers/gpu/drm/radeon/r100.c                   |  770 +++++++++++++++++++++-
 drivers/gpu/drm/radeon/r300.c                   |   78 ++-
 drivers/gpu/drm/radeon/r300_reg.h               |    4 +-
 drivers/gpu/drm/radeon/r500_reg.h               |    2 +
 drivers/gpu/drm/radeon/r520.c                   |   22 +-
 drivers/gpu/drm/radeon/r600.c                   |    5 +-
 drivers/gpu/drm/radeon/radeon.h                 |   87 +++-
 drivers/gpu/drm/radeon/radeon_asic.h            |   32 +
 drivers/gpu/drm/radeon/radeon_atombios.c        |    9 +-
 drivers/gpu/drm/radeon/radeon_benchmark.c       |    4 +-
 drivers/gpu/drm/radeon/radeon_cs.c              |    8 +-
 drivers/gpu/drm/radeon/radeon_cursor.c          |    9 +-
 drivers/gpu/drm/radeon/radeon_device.c          |   59 +-
 drivers/gpu/drm/radeon/radeon_display.c         |   74 ++-
 drivers/gpu/drm/radeon/radeon_drv.c             |    4 +
 drivers/gpu/drm/radeon/radeon_encoders.c        |  359 +----------
 drivers/gpu/drm/radeon/radeon_fb.c              |   70 ++-
 drivers/gpu/drm/radeon/radeon_fence.c           |    2 +-
 drivers/gpu/drm/radeon/radeon_gart.c            |    2 +-
 drivers/gpu/drm/radeon/radeon_gem.c             |   45 ++-
 drivers/gpu/drm/radeon/radeon_kms.c             |    2 +
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c     |  687 ++++++--------------
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |  188 +------
 drivers/gpu/drm/radeon/radeon_mode.h            |   51 +-
 drivers/gpu/drm/radeon/radeon_object.c          |  158 ++++-
 drivers/gpu/drm/radeon/radeon_ring.c            |   15 +-
 drivers/gpu/drm/radeon/radeon_share.h           |   39 ++
 drivers/gpu/drm/radeon/radeon_test.c            |  209 ++++++
 drivers/gpu/drm/radeon/radeon_ttm.c             |   24 +-
 drivers/gpu/drm/radeon/rs400.c                  |   30 +-
 drivers/gpu/drm/radeon/rs600.c                  |    7 +-
 drivers/gpu/drm/radeon/rs690.c                  |  479 ++++++++++++++-
 drivers/gpu/drm/radeon/rs690r.h                 |   99 +++
 drivers/gpu/drm/radeon/rv515.c                  |  798 +++++++++++++++++++----
 drivers/gpu/drm/radeon/rv515r.h                 |  170 +++++
 drivers/gpu/drm/radeon/rv770.c                  |    2 +-
 drivers/gpu/drm/ttm/ttm_bo.c                    |   63 ++-
 drivers/gpu/drm/ttm/ttm_bo_util.c               |   69 ++-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                 |    3 +
 drivers/gpu/drm/ttm/ttm_tt.c                    |   25 +-
 include/drm/radeon_drm.h                        |   23 +-
 include/drm/ttm/ttm_bo_driver.h                 |   20 +-
 include/drm/ttm/ttm_module.h                    |    2 +-
 46 files changed, 3576 insertions(+), 1529 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/radeon_share.h
 create mode 100644 drivers/gpu/drm/radeon/radeon_test.c
 create mode 100644 drivers/gpu/drm/radeon/rs690r.h
 create mode 100644 drivers/gpu/drm/radeon/rv515r.h

commit ed8f0d9e708a1a7c9222e7d0a35d97521e904223
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Jul 29 17:07:38 2009 +1000

    drm/radeon: set fb aperture sizes for framebuffer handoff.
    
    This will allow efi/vesa to handoff to radeon.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b42db2b12df7b4f7b2ace581a7726cb5bcb2d658
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Jul 29 16:56:52 2009 +1000

    drm/ttm: fix highuser vs dma32 confusion.
    
    DMA32 and highmem are sort of exclusive.
    
    Noticed by AndrewR on #radeon.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ea3c13bd8c2ed1d3670bd72e60f562a427355fdf
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Mon Jul 20 01:44:03 2009 +0200

    drm/radeon: Fix size used for benchmarking BO copies.
    
    The incorrect size caused benchmark results to be inflated by a factor of 4.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ecc0b32645bf19a3a240e72be3022ab3b46ad3d0
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Tue Jul 21 11:23:57 2009 +0200

    drm/radeon: Add radeon.test parameter for running BO GPU copy tests.
    
    If enabled, during initialization BO GTT->VRAM and VRAM->GTT GPU copies are
    tested across the whole GTT aperture.
    
    This has helped uncover the benchmark copy size bug and verify the maximum
    aperture size supported by the AGP bridge in my PowerBook.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3b170c3b2e688665fbc2845ba5bb4304bf38a119
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Jul 24 13:47:45 2009 +1000

    drm/radeon/kms: allow interruptible waits for objects.
    
    Blocking here isn't something the X server mouse appreciates,
    avoid the block and let userspace retry the waits.
    
    libdrm_radeon userspace library is also expecting EBUSY not ERESTART
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f121ecfebbea1452a17d57c656def7d1537440f7
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Fri Jul 24 10:22:36 2009 +0200

    drm/ttm: powerpc: Fix Highmem cache flushing.
    
    Temporarily maps highmem pages while flushing to get a valid virtual
    address to flush.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 73ba651fc246fcc3e446da4155e0425b4219d2c4
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Fri Jul 24 09:57:33 2009 +0200

    x86: Export kmap_atomic_prot() needed for TTM.
    
    This functionality is needed to kmap_atomic() highmem pages that may
    potentially have or are about to set up other mappings with
    non-standard caching attributes.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 542c6f6df51327dbb180cf4d9b34827e147efe17
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Fri Jul 24 09:57:34 2009 +0200

    drm/ttm: Fix ttm in-kernel copying of pages with non-standard caching attributes.
    
    For x86 this affected highmem pages only, since they were always kmapped
    cache-coherent, and this is fixed using kmap_atomic_prot().
    
    For other architectures that may not modify the linear kernel map we
    resort to vmap() for now, since kmap_atomic_prot() generally uses the
    linear kernel map for lowmem pages. This of course comes with a
    performance impact and should be optimized when possible.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4677f15c60421d48566c48c3149474e64977f071
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Tue Jul 21 17:45:13 2009 +0200

    drm/ttm: Fix an oops and sync object leak.
    
    The code was potentially dereferencig a NULL sync object pointer.
    At the same time a sync object reference was potentially leaked.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7a50f01a4ab89d5c05eb2cf62e206ac0bfc61d2c
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Jul 21 20:39:30 2009 +1000

    drm/radeon/kms: vram sizing on certain r100 chips needs workaround.
    
    If an rn50/r100/m6/m7 GPU has < 64MB RAM, i.e. 8/16/32, the
    aperture used to calculate the MC_FB_LOCATION needs to be worked
    out from the CONFIG_APER_SIZE register, and not the actual vram size.
    
    TTM VRAM size was also being initialised wrong, use actual vram size
    to initialise it.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 664f86590295217b2319edf88830e87b800f6c4a
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Tue Jul 28 12:30:57 2009 +0200

    drm/radeon: Pay more attention to object placement requested by userspace.
    
    Previously we were basically always setting the GTT and VRAM flags regardless of
    what userspace requested.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 1ab2e1059916b917af19e4137a4222988bd7a169
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Tue Jul 28 12:30:56 2009 +0200

    drm/radeon: Fall back to evicting BOs with memcpy if necessary.
    
    Otherwise if there's no GTT space we would fail the eviction, leading to
    cascaded failure.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e46074effd5510e7a8fe34b93828d98a50835da2
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Tue Jul 28 12:30:55 2009 +0200

    drm/radeon: Don't unreserve twice on failure to validate.
    
    This is done later in radeon_object_list_unvalidate(). Doing it twice triggers
    a BUG in TTM, rendering X on KMS unusable until reboot.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c93bb85b5cba3e3a06f2cad8e9bc5c23d3d10aac
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Mon Jul 13 21:04:08 2009 +0200

    drm/radeon/kms: fix bandwidth computation on avivo hardware
    
    Fix bandwidth computation and crtc priority in memory controller
    so that crtc memory request are fullfill in time to avoid display
    artifact.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e024e11070a0a0dc7163ce1ec2da354a638bdbed
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Jun 24 09:48:08 2009 +1000

    drm/radeon/kms: add initial colortiling support.
    
    This adds new set/get tiling interfaces where the pitch
    and macro/micro tiling enables can be set. Along with
    a flag to decide if this object should have a surface when mapped.
    
    The only thing we need to allocate with a mapped surface should be
    the frontbuffer. Note rotate scanout shouldn't require one, and
    back/depth shouldn't either, though mesa needs some fixes.
    
    It fixes the TTM interfaces along Thomas's suggestions, and I've tested
    the surface stealing code with two X servers and not seen any lockdep issues.
    
    I've stopped tiling the fbcon frontbuffer, as I don't see there being
    any advantage other than testing, I've left the testing commands in there,
    just flip the fb_tiled to true in radeon_fb.c
    
    Open: Can we integrate endian swapping in with this?
    
    Future features:
    texture tiling - need to relocate texture registers TXOFFSET* with tiling info.
    
    This also merges Michel's cleanup surfaces regs at init time patch
    even though it makes sense on its own, this patch really relies on it.
    
    Some PowerMac firmwares set up a tiling surface at the beginning of VRAM
    which messes us up otherwise.
    that patch is:
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c836e862803b2aa2bd9a354e151316d2b42c44ec
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Jul 13 13:51:03 2009 -0400

    drm/radeon/kms: fix hotspot handling on pre-avivo chips
    
    Need to adjust CUR_OFFSET for yorigin
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit eb1300bcd70b3bffbefb6ae0eab13a571255ee93
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Jul 13 11:09:56 2009 -0400

    drm/radeon/kms: enable frac fb divs on rs600/rs690/rs740
    
    Allows us to hit dot clocks much closer, especially on
    chips with non-27 Mhz reference clocks like most IGP chips.
    This fixes most flickering and blanking problems with
    non-exact dot clocks on these chips.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d0e275a90a81b37409a0cfbca77581e3d235f5cf
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Jul 13 11:08:18 2009 -0400

    drm/radeon/kms: add PLL flag to prefer frequencies <= the target freq
    
    This is needed when using fractional feedback dividers on some IGP
    chips.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b995e4330de0d8b1b8b9e49ce10cc6dc78e2cbba
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue Jul 14 02:02:32 2009 +1000

    drm/radeon/kms: block RN50 from using 3D engine.
    
    RN50/ES1000 is a cut-down rv100 chip used in the server market.
    The 3D engine on these is either not there or unverified so refuse
    any attempt to configure registers on it.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 2a0f8918fc34713ecaeb900ffb9afa61df4cb08e
Author: Dave Airlie <airlied@linux.ie>
Date:   Sat Jul 11 04:44:47 2009 +1000

    drm/radeon/kms: fix VRAM sizing like DDX does it.
    
    Doing this like the DDX seems like the most sure fire way to avoid
    having to reinvent it slowly and painfully. At the moment we keep
    getting things wrong with aper vs vram, so we know the DDX does it right.
    
    booted on PCI r100, PCIE rv370, IGP rs400.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ad49f501867cba87e1e45e5ebae0b12435d68bf1
Author: Dave Airlie <airlied@linux.ie>
Date:   Fri Jul 10 22:36:26 2009 +1000

    drm/ttm/radeon: add dma32 support.
    
    This add support for using dma32 memory on gpus that really need it.
    
    Currently IGPs are left without DMA32 but we might need to change
    that unless we can fix rs690.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 61b576dbbe6a19d102c025ebc102a0749e2d3c80
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Wed Jun 24 00:12:55 2009 +1000

    drm/radeon: Endianness fixes for radeondrmfb.
    
    For now handle it via r/g/b offsets and disallow 16 bpp modes on big endian
    machines.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 77bd36f014bc5a3f28507a4e86a81b2b3d2439c3
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Jul 10 09:33:00 2009 +1000

    drm/radeon/kms: don't swap PCIEGART PTEs in VRAM.
    
    On powerpc, since we aren't using any hw swappers, this will
    get flipped around by default in hw.
    
    tested on a G5 + rv515.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5176fdc4c5873e52f9cb6e166d80e843847e7eb4
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Jun 30 11:47:14 2009 +1000

    drm/radeon/kms: drop zero length CS indirect buffers.
    
    If userspace sends a zero length IB, it really shouldn't have bothered
    so EINVAL it.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e7168cab5bbac0a0e5413fd55ba0e92555bf860d
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Jul 9 16:01:42 2009 +1000

    drm/radeon/kms: fix vram vs aper size check.
    
    Fix this to be correct like the DDX code, looks like a typo
    on transfer to the kernel.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 2007d633d639c896396e4c4b53b38068f3831307
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Wed Jul 8 16:17:23 2009 -0400

    drm/radeon/kms: get lvds info for DIG LVTMA and UNIPHY encoders
    
    Noticed by Rafa³ Mi³ecki on dri-devel.  On r6xx/r7xx hardware, laptop
    panels can be driven by KLDSCP_LVTMA or UNIPHY.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 848577ee27f704231b1860ae987a1be78b88b06e
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Wed Jul 8 16:15:30 2009 -0400

    drm/radeon/kms: fix quirk for MSI laptop
    
    The line mux for the connector in the bios tables
    is used for enumerating drm connectors.  Since
    this laptop has a quirk where the same line much is
    listed for both VGA and LVDS, the connectors get
    combined.  Setting the line mux on LVDS to an unused
    value prevents both encoders from being combined into
    the same connector.  This should fix bko bug 13720.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ae3e8122cbf8f9301369f276f4179aa6ec1b5b9c
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Jun 24 19:57:34 2009 +0200

    ttm: Fix caching mode selection.
    
    A bug caused a new caching state to be selected on each buffer object
    validation regardless of the current caching state.
    Moreover, a caching state could be selected that wasn't supported by
    the memory type.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d1724078d6a01177c1db4ea0b75fda1ca8a73d57
Author: Thomas Hellstrom <thellstrom@vmware.com>
Date:   Wed Jun 24 19:57:35 2009 +0200

    ttm: Make messages more readable.
    
    Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 531369e62649bb8f31217cc0bf33ee6f89f1dff6
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Jun 29 11:21:25 2009 +1000

    drm/radeon: fix support for vline relocations.
    
    Userspace sends us a special relocation type to sync video/exa
    to vlines to avoid tearing, this deals with the relocation
    in the kernel, it picks the correct crtc and avoids issues
    where crtcs are disabled.
    
    This version also parses the wait until to make sure it isn't
    trying to do anything evil.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3e43d82125952826202a8cd20ba84a66f3ff8808
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Jul 9 15:04:18 2009 +1000

    drm/radeon/kms: respect TOM on rs100->rs480 IGP variants.
    
    Normally we are free to place VRAM where we want in the GPUs
    memory address space, however on IGP chips the VRAM is actual RAM,
    and no special translation or aperture is used inside the GPU MC.
    
    So when you move the VRAM aperture away from the TOM register,
    you actually move it into main memory and can trash things quite badly.
    
    This commit makes the code respect the TOM location for MC_FB_LOCATION.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4162338a1dab388474d4115289d1d7071623f04d
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Jul 9 15:04:19 2009 +1000

    drm/radeon/kms: set crtc and cursor offsets correctly on legacy chips.
    
    The crtc and cursor offsets on the legacy chips are offset from
    DISPLAY_BASE_ADDR. The code worked if display base addr was at 0,
    but otherwise falls to pieces.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6cdf65855cf884712532fc72770baaef7bdf1b9a
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Jun 29 18:29:13 2009 +1000

    drm/radeon/kms: remove IB flushing trick.
    
    If there is a problem then this is hiding it, we shouldn't
    ever need to flush the IB. Either the buffers are:
    
    WB - caching just works.
    WC - no need to do explicit flush, the MB + readback will do it
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4c9bc75cbc6f2f447a38a123aa6e0605fab3cb7a
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Jun 29 18:29:12 2009 +1000

    drm/radeon/kms: mmio base/size should be resource_size_t.
    
    Unsigned long is incorrect for 64-bit resources on 32-bit hw.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ed10f95d60d41033d356fdcf88c240d7065bd5b4
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Jun 29 18:29:11 2009 +1000

    drm/radeon/kms: fix some GART table entry bugs.
    
    1. rv370 can accept 40-bit addresses - also at 24-bit shift not 4 bits
    2. rs480 table can be in 40-bit space. - 4 bit shift for top 8 bits
    3. rs480 table entries can be in 40-bit space.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
--29444707-1963875480-1248853092=:25358--
