Return-Path: <linux-kernel-owner+w=401wt.eu-S1752047Ab0AKEws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab0AKEws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 23:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637Ab0AKEwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 23:52:47 -0500
Received: from gir.skynet.ie ([193.1.99.77]:46562 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab0AKEwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 23:52:46 -0500
Date: Mon, 11 Jan 2010 04:52:35 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm
Message-ID: <alpine.DEB.2.00.1001110450150.19527@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-318580327-1263185555=:19527"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-318580327-1263185555=:19527
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

This contains 3 trees:
core: two KMS fixes, one for a regression I found with Fedora's plymouth
on my r100 laptop with an 8-bpp console, the other for unwanted outputs
lighting up on resume.

radeon kms: a regression fix since we added host data flushing support
some users reported r300s dying under load, this change fixes that, along
with better s/r support for gpus with sideport RAM, along with eDP
support (needed for new imacs to display anything). Also we sync'ed the
whitespace in ObjectID.h with all the other copies to make syncing them
with AMD's master copy easier, its not kernel compliant but it is a lot
easier to work with for AMD.

nouveau: scattering of fixes from the nouveau upstream tree.

Dave.

 drivers/gpu/drm/drm_crtc.c                 |    1 +
 drivers/gpu/drm/drm_crtc_helper.c          |   26 +-
 drivers/gpu/drm/drm_fb_helper.c            |    9 +-
 drivers/gpu/drm/drm_irq.c                  |    5 +-
 drivers/gpu/drm/nouveau/Kconfig            |    5 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c       |  243 ++++++---
 drivers/gpu/drm/nouveau/nouveau_channel.c  |   47 +--
 drivers/gpu/drm/nouveau/nouveau_dma.c      |   34 +-
 drivers/gpu/drm/nouveau/nouveau_dma.h      |   10 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h      |   72 ++-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c    |   19 +-
 drivers/gpu/drm/nouveau/nouveau_fbcon.h    |    1 +
 drivers/gpu/drm/nouveau/nouveau_fence.c    |    2 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c      |   33 +-
 drivers/gpu/drm/nouveau/nouveau_irq.c      |    1 +
 drivers/gpu/drm/nouveau/nouveau_mem.c      |   87 +++
 drivers/gpu/drm/nouveau/nouveau_object.c   |    2 +-
 drivers/gpu/drm/nouveau/nouveau_reg.h      |   16 +-
 drivers/gpu/drm/nouveau/nouveau_state.c    |   27 +-
 drivers/gpu/drm/nouveau/nouveau_ttm.c      |   30 +-
 drivers/gpu/drm/nouveau/nv04_dac.c         |   35 +-
 drivers/gpu/drm/nouveau/nv04_fbcon.c       |   41 +-
 drivers/gpu/drm/nouveau/nv04_fifo.c        |   34 ++
 drivers/gpu/drm/nouveau/nv04_graph.c       |  159 +++---
 drivers/gpu/drm/nouveau/nv10_fb.c          |   32 +-
 drivers/gpu/drm/nouveau/nv10_graph.c       |   28 +-
 drivers/gpu/drm/nouveau/nv17_tv.c          |  115 ++++-
 drivers/gpu/drm/nouveau/nv20_graph.c       |   61 +--
 drivers/gpu/drm/nouveau/nv40_fb.c          |   53 ++-
 drivers/gpu/drm/nouveau/nv40_graph.c       |  116 ++---
 drivers/gpu/drm/nouveau/nv50_display.c     |   17 +
 drivers/gpu/drm/nouveau/nv50_fbcon.c       |   23 +-
 drivers/gpu/drm/nouveau/nv50_fifo.c        |    6 +-
 drivers/gpu/drm/radeon/Makefile            |    5 +
 drivers/gpu/drm/radeon/ObjectID.h          |  801 +++++++++++++++-------------
 drivers/gpu/drm/radeon/atombios_dp.c       |    6 +-
 drivers/gpu/drm/radeon/mkregtable.c        |    4 +-
 drivers/gpu/drm/radeon/r100.c              |   23 +-
 drivers/gpu/drm/radeon/r300.c              |   17 +-
 drivers/gpu/drm/radeon/r420.c              |   41 ++-
 drivers/gpu/drm/radeon/r520.c              |    1 +
 drivers/gpu/drm/radeon/r600.c              |   21 +-
 drivers/gpu/drm/radeon/r600_blit_kms.c     |    4 +-
 drivers/gpu/drm/radeon/radeon.h            |    9 +-
 drivers/gpu/drm/radeon/radeon_agp.c        |    6 +-
 drivers/gpu/drm/radeon/radeon_asic.h       |   12 -
 drivers/gpu/drm/radeon/radeon_atombios.c   |   41 ++-
 drivers/gpu/drm/radeon/radeon_combios.c    |   14 +
 drivers/gpu/drm/radeon/radeon_connectors.c |   23 +-
 drivers/gpu/drm/radeon/radeon_display.c    |    7 +-
 drivers/gpu/drm/radeon/radeon_encoders.c   |   14 +-
 drivers/gpu/drm/radeon/radeon_gem.c        |    2 -
 drivers/gpu/drm/radeon/radeon_irq_kms.c    |   10 +-
 drivers/gpu/drm/radeon/radeon_legacy_tv.c  |   14 +-
 drivers/gpu/drm/radeon/radeon_mode.h       |   26 -
 drivers/gpu/drm/radeon/radeon_object.c     |    5 +-
 drivers/gpu/drm/radeon/reg_srcs/r420       |  795 +++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/reg_srcs/rs600      |   68 +++-
 drivers/gpu/drm/radeon/reg_srcs/rv515      |    6 +
 drivers/gpu/drm/radeon/rs400.c             |    2 +
 drivers/gpu/drm/radeon/rs600.c             |   10 +-
 drivers/gpu/drm/radeon/rs690.c             |    2 +
 drivers/gpu/drm/radeon/rv515.c             |    1 +
 drivers/gpu/drm/radeon/rv770.c             |    3 +-
 include/drm/drm_mode.h                     |    1 +
 65 files changed, 2411 insertions(+), 973 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/reg_srcs/r420

commit f22d6ddaeb8126623d62c828a4d4a96dfc4cbc5c
Merge: 0c9d2c4 40c2298
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Jan 11 14:43:16 2010 +1000

    Merge branch 'for-airlied' of /ssd/git/drm-nouveau-next into drm-linus
    
    * 'for-airlied' of /ssd/git/drm-nouveau-next: (28 commits)
      drm/nv04: Fix set_operation software method.
      drm/nouveau: initialise DMA tracking parameters earlier
      drm/nouveau: use dma.max rather than pushbuf size for checking GET validity
      drm/nv04: differentiate between nv04/nv05
      drm/nouveau: Fix null deref in nouveau_fence_emit due to deleted fence
      drm/nv50: prevent a possible ctxprog hang
      drm/nouveau: have ttm's fault handler called directly
      drm/nv50: restore correct cache1 get/put address on fifoctx load
      drm/nouveau: create function for "dealing" with gpu lockup
      drm/nouveau: remove unused nouveau_channel_idle() function
      drm/nouveau: fix handling of fbcon colours in 8bpp
      drm/nv04: Context switching fixes.
      drm/nouveau: Use the software object for fencing.
      drm/nouveau: Allocate a per-channel instance of NV_SW.
      drm/nv50: make the blocksize depend on vram size
      drm/nouveau: better alignment of bo sizes and use roundup instead of ALIGN
      drm/nouveau: Don't skip card take down on nv0x.
      drm/nouveau: Implement nv42-nv43 TV load detection.
      drm/nouveau: Clean up the nv17-nv4x load detection code a bit.
      drm/nv50: fix fillrect color
      ...

commit 0c9d2c418aa4a45534943c4c9a1c8dda82d3b481
Merge: 94fd163 804c755
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Jan 11 14:42:58 2010 +1000

    Merge remote branch 'korg/drm-radeon-next' into drm-linus
    
    * korg/drm-radeon-next:
      drm/radeon/kms: add additional safe regs for r4xx/rs6xx and r5xx
      drm/radeon/kms: Don't try to enable IRQ if we have no handler installed
      drm: Avoid calling vblank function is vblank wasn't initialized
      drm/radeon: mkregtable.c: close a file before exit
      drm/radeon/kms: Make sure we release AGP device if we acquired it
      drm/radeon/kms: Schedule host path read cache flush through the ring V2
      drm/radeon/kms: Workaround RV410/R420 CP errata (V3)
      drm/radeon/kms: detect sideport memory on IGP chips
      drm/radeon: fix a couple of array index errors
      drm/radeon/kms: add support for eDP (embedded DisplayPort)
      drm: Add eDP connector type
      drm/radeon/kms: pull in the latest upstream ObjectID.h changes
      drm/radeon/kms: whitespace changes to ObjectID.h
      drm/radeon/kms: fix typo in atom connector type handling

commit 40c2298bdcc8b766a39964c44e9a74d16aa95d53
Author: Marcin Ko¶cielnicki <koriakin@0x04.net>
Date:   Sun Jan 10 17:09:14 2010 +0000

    drm/nv04: Fix set_operation software method.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit c63834e1db41b59d6c7bfb1d2a549c027a42a877
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Fri Jan 8 10:57:39 2010 +1000

    drm/nouveau: initialise DMA tracking parameters earlier
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 400f14ac4ef02b2f77c9d0e3ad7d66e2f6c8e663
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Fri Jan 8 10:53:40 2010 +1000

    drm/nouveau: use dma.max rather than pushbuf size for checking GET validity
    
    Some upcoming G80 DMA changes will depend on this, but it's split out for
    bisectibility just in case it causes some unexpected issues.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit cc6e496587502057af02139931736b0b7a49f637
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Thu Jan 7 13:47:57 2010 +1000

    drm/nv04: differentiate between nv04/nv05
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit d6126c5c8b2019658aadc9754dca80a7573dbff5
Author: Luca Barbieri <luca@luca-barbieri.com>
Date:   Wed Jan 6 04:02:45 2010 +0100

    drm/nouveau: Fix null deref in nouveau_fence_emit due to deleted fence
    
    Currently Nouveau will unvalidate all buffers if it is forced to wait on
    one, and then start revalidating from the beginning.  While doing so, it
    destroys the operation fence, causing nouveau_fence_emit to crash.
    
    This patch fixes this bug by taking the fence object out of validate_op
    and creating it just before emit.  The fence pointer is initialized to 0
    and unref'ed unconditionally.
    
    In addition to fixing the bug, this prevents its reintroduction and
    simplifies the code.
    
    Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit dc8d76cac942e7344a72ad18afb90fa46cf20bb4
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Wed Jan 6 12:00:02 2010 +1000

    drm/nv50: prevent a possible ctxprog hang
    
    The below is mainly an educated guess at what's going on, docs would
    sure be handy...  NVIDIA? :P
    
    It appears it's possible for a ctxprog to run even while a GPU exception
    is pending.  The GF8 and up ctxprogs appear to have a small snippet of
    code which detects this, and stalls the ctxprog until it's been handled,
    which essentially looks like:
    
    	if (r2 & 0x00008000) {
    		r0 |= 0x80000000;
    		while (r0 & 0x80000000) {}
    	}
    
    I don't know of any way that flag would get cleared unless the driver
    intervenes (and indeed, in the cases I've seen the hang, nothing steps
    in to automagically clear it for us).  This patch causes the driver to
    clear the flag during the PGRAPH IRQ handler.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 1959ca80e1f88b82c1cb7227f437910768ab0c94
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Mon Jan 4 15:52:20 2010 +1000

    drm/nouveau: have ttm's fault handler called directly
    
    There's no good reason for us to have our own anymore, this is left over
    from an early port to these TTM interfaces.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit a908b96c22883f967e4ddf5aa5b35e3b4a0629a5
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Tue Jan 5 09:41:05 2010 +1000

    drm/nv50: restore correct cache1 get/put address on fifoctx load
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit c03ec7f91fcf20af177dbc728d518fb462bad42d
Author: Marcin Slusarz <marcin.slusarz@gmail.com>
Date:   Mon Jan 4 19:25:09 2010 +0100

    drm/nouveau: create function for "dealing" with gpu lockup
    
    It's mostly a cleanup, but in nv50_fbcon_accel_init gpu lockup
    message was printed, but HWACCEL_DISBALED flag was not set.
    
    Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit e9dd8e11edfff5e348f3dcfd152a70c5da921126
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Mon Jan 4 12:53:01 2010 +1000

    drm/nouveau: remove unused nouveau_channel_idle() function
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit 7de3643f938af910bef4c1f800176a3ebdc29502
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Mon Jan 4 09:10:55 2010 +1000

    drm/nouveau: fix handling of fbcon colours in 8bpp
    
    Depending on the visual, the colours handed to us in fillrect() can either be
    an actual colour, or an index into the pseudo-palette.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit ea911a1cf4f9c5bef18ff399ee2e2ec77792b650
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Sat Dec 26 14:39:46 2009 +0100

    drm/nv04: Context switching fixes.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>

commit a5027ccd3c1abe190d2b84a2d7e40d5f099e48a7
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Sat Dec 26 02:09:36 2009 +0100

    drm/nouveau: Use the software object for fencing.
    
    This should avoid a race condition on nv0x, if we're doing it with
    actual PGRAPH objects and a there's a fence within the FIFO DMA fetch
    area when a context switch kicks in.
    
    In that case we get an ILLEGAL_MTHD interrupt as expected, but the
    values in PGRAPH_TRAPPED_ADDR aren't calculated correctly and they're
    almost useless (e.g. you can see ILLEGAL_MTHDs for the now inactive
    channel, with a wrong offset/data pair).
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>

commit ca4362adb4c01807dfcf3f2b3152a7ee36f0d1ca
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Sat Dec 26 02:42:45 2009 +0100

    drm/nouveau: Allocate a per-channel instance of NV_SW.
    
    It will be useful for various synchronization purposes, mostly stolen
    from "[PATCH] drm/nv50: synchronize user channel after buffer object
    move on kernel channel" by Maarten Maathuis.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>

commit 0a2d090f99c9686e5107ed59533fc4210a9a47d1
Author: Maarten Maathuis <madman2003@gmail.com>
Date:   Sat Dec 26 21:46:36 2009 +0100

    drm/nv50: make the blocksize depend on vram size
    
    - This should be better than what we have now.
    - I'm less sure about the non power of two path.
    
    Signed-off-by: Maarten Maathuis <madman2003@gmail.com>

commit c2b82924bda0c3de2b49bd3a4d8b6725721820bc
Author: Maarten Maathuis <madman2003@gmail.com>
Date:   Fri Dec 25 18:51:17 2009 +0100

    drm/nouveau: better alignment of bo sizes and use roundup instead of ALIGN
    
    - Aligning to block size should ensure that the extra size is enough.
    - Using roundup, because not all sizes are powers of two.
    
    Signed-off-by: Maarten Maathuis <madman2003@gmail.com>

commit 8f71c29e442e013212a98e2b37eb1074c4d1134f
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Tue Dec 22 18:24:09 2009 +0100

    drm/nouveau: Don't skip card take down on nv0x.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>

commit b7f7e41b895afd110d1f5121161fd401eccd98c9
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Thu Dec 17 18:57:44 2009 +0100

    drm/nouveau: Implement nv42-nv43 TV load detection.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>

commit 02076da97a15bbf7477bffed71d02f726de2afc2
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Thu Dec 17 18:52:44 2009 +0100

    drm/nouveau: Clean up the nv17-nv4x load detection code a bit.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>

commit e55ca7e68efc7c2d320cd9975ebc5e0fd27debf0
Author: Marcin Slusarz <marcin.slusarz@gmail.com>
Date:   Mon Dec 21 23:00:41 2009 +0100

    drm/nv50: fix fillrect color
    
    struct fb_fillrect->color is not a color, but index into pseudo_palette
    array
    
    Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit fbe36a7a069267b82b7b82a66d79a4406cfa90b2
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Mon Dec 21 12:16:52 2009 +1000

    drm/nv50: ignore vbios table's claim to the contrary if EDID says >8bpc
    
    Should fix dim panel issues reported on Dell M6400/M6500.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

commit aeca15e596eba284c727049d0b9b855b13c48856
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Wed Dec 16 19:03:28 2009 +0100

    drm/nouveau: Drop redundant placement initialization.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>

commit 69a18c328b762eaec3f8ca3af8c7cbf10b536bf8
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Wed Dec 16 19:05:38 2009 +0100

    drm/nouveau: No need to force evict=true when swapping evicted BOs back in.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>

commit c6af6053be60840dcbb037c3798557cbf71cbb08
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Wed Dec 16 19:05:00 2009 +0100

    drm/nouveau: Fix "general protection fault" in the flipd/flips eviction path.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>

commit 73cb9276fd189c19558a97600456bd13fa5debe8
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Wed Dec 16 12:27:11 2009 +0100

    drm/i2c/ch7006: Drop build time dependency to nouveau.
    
    This partially reverts e4b41066, as this driver is intended to be
    useful with any KMS driver for suitable hardware. The missing build
    dependency that commit workarounded was DRM_KMS_HELPER.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>

commit 287c1532145b63d394060d46c0309b123b862345
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Fri Dec 11 16:51:09 2009 +0100

    drm/nouveau: Make the MM aware of pre-G80 tiling.
    
    This commit has also the following 3 bugfix commits squashed into it from
    the nouveau git tree:
    
    drm/nouveau: Fix up the tiling alignment restrictions for nv1x.
    drm/nouveau: Fix up the nv2x tiling alignment restrictions.
    drm/nv50: fix align typo for g9x
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>

commit 0d87c100312ce75d9bb75a456d8a542e84a1722f
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Wed Dec 16 12:12:27 2009 +0100

    drm/nouveau: Pre-G80 tiling support.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>

commit 617e234b01757698ed5f8c9a5fbf12717b76e371
Author: Francisco Jerez <currojerez@riseup.net>
Date:   Sun Dec 13 20:07:42 2009 +0100

    drm/nouveau: Add cache_flush/pull fifo engine functions.
    
    Signed-off-by: Francisco Jerez <currojerez@riseup.net>

commit 94fd163d86b049842856864cdeac318131ec576d
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Jan 11 14:20:55 2010 +1000

    drm: reduce WARN_ON to a printk.
    
    Lots of ppl keep thinking this is an oops, it was just a warning for
    me to see, just make it a printk now.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 509c7d83c3b18a50a0bd02afa43c8ee3c7605bc9
Author: Dave Airlie <airlied@redhat.com>
Date:   Fri Jan 8 09:27:08 2010 +1000

    drm/kms/fb: check for depth changes from userspace for resizing.
    
    If userspace (plymouth in this case) asks for a deeper depth,
    refuse it as well due to lack of resizing.
    
    This fixes an issue since < 32MB cards went to 8bpp and plymouth
    crashes on startup.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 89347bb8ef2d0af1ae8d847b7df91e9f04eccf2a
Author: David John <davidjon@xenontk.org>
Date:   Thu Dec 31 12:00:46 2009 +0530

    drm: Keep disabled outputs disabled after suspend / resume
    
    With the current DRM code, an output that has been powered off
    from userspace will automatically power back on when resuming
    from suspend. This patch fixes this behaviour.
    
    Tested only with the Intel i915 driver on an Intel GM45 Express
    chipset.
    
    Signed-off-by: David John <davidjon@xenontk.org>
    Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 804c7559e9376c3ba78ae15a30337b1e24f8ae80
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Fri Jan 8 15:58:49 2010 -0500

    drm/radeon/kms: add additional safe regs for r4xx/rs6xx and r5xx
    
    - r4xx/rs6xx: add support for extended pixel shader
    instruction/temp regs
    - r5xx: add SM3 regs
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 003e69f9862bcda89a75c27750efdbc17ac02945
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Jan 7 15:39:14 2010 +0100

    drm/radeon/kms: Don't try to enable IRQ if we have no handler installed
    
    If for any reason we haven't installed handler we shouldn't try to
    enable IRQ/MSI on the hw so we don't get unhandled IRQ/MSI which
    makes the kernel sad.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e77cef9c2d87db835ad9d70cde4a9b00b0ca2262
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Jan 7 15:39:13 2010 +0100

    drm: Avoid calling vblank function is vblank wasn't initialized
    
    In some case vblank might not be initialized and we shouldn't
    try to use associated function. This patch make sure this is
    the case. It also export drm_vblank_cleanup so driver can cleanup
    vblank if for any reason IRQ/MSI is not working.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 059d233f9c1183ed2f59d631e4daf486060e880d
Author: Alexander Beregalov <a.beregalov@gmail.com>
Date:   Thu Jan 7 02:59:31 2010 +0300

    drm/radeon: mkregtable.c: close a file before exit
    
    Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d0269ed8580b492df75dafb011dc51a1390bf200
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Jan 7 16:08:32 2010 +0100

    drm/radeon/kms: Make sure we release AGP device if we acquired it
    
    In some case we weren't releasing the AGP device at module unloading.
    This leaded to unfunctional AGP at next module load. This patch make
    sure we release the AGP bus if we acquire it.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit cafe6609d6dc0a6a278f9fdbb59ce4d761a35ddd
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Thu Jan 7 12:39:21 2010 +0100

    drm/radeon/kms: Schedule host path read cache flush through the ring V2
    
    R300 family will hard lockup if host path read cache flush is
    done through MMIO to HOST_PATH_CNTL. But scheduling same flush
    through ring seems harmless. This patch remove the hdp_flush
    callback and add a flush after each fence emission which means
    a flush after each IB schedule. Thus we should have same behavior
    without the hard lockup.
    
    Tested on R100,R200,R300,R400,R500,R600,R700 family.
    
    V2: Adjust fence counts in r600_blit_prepare_copy()
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 62cdc0c20663ef840a94850892517b2b7f584904
Author: Corbin Simpson <MostAwesomeDude@gmail.com>
Date:   Wed Jan 6 19:28:48 2010 +0100

    drm/radeon/kms: Workaround RV410/R420 CP errata (V3)
    
    Long story short, this fixes sporadic hardlocks with my rv410 during
    times of intense 2D acceleration (Flash on Fx3).
    
    V2: Fix indentation and move errata_fini to suspend function so we
    don't leak scratch register over suspend/resume cycle.
    V3: Move scratch_reg to asic specific structure (aim is to slowly
        move stuff to asic specific structure and avoid poluting
        radeon_device struct with asic specific variables)
    
    Signed-off-by: Corbin Simpson <MostAwesomeDude@gmail.com>
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 06b6476d6b291473d0928ed242158a001d50c0f0
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Jan 5 11:27:29 2010 -0500

    drm/radeon/kms: detect sideport memory on IGP chips
    
    This detects if the sideport memory is enabled and
    if it is VRAM is evicted on suspend/resume.
    
    This should fix s/r issues on some IGPs.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit fc9a89f97e532152ae614d5ce717b81c8f8b0e91
Author: Darren Jenkins <darrenrjenkins@gmail.com>
Date:   Thu Jan 7 01:35:21 2010 -0500

    drm/radeon: fix a couple of array index errors
    
    There are a couple of array overruns, and some associated confusion in
    the code.
    This is just a wild guess at what the code should actually look like.
    
    Coverity CID: 13305 13306
    
    agd5f: fix up the original intent of the timing code
    
    Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 196c58d21fc47fbabab6a98e23e5a6335f717e44
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Jan 7 14:22:32 2010 -0500

    drm/radeon/kms: add support for eDP (embedded DisplayPort)
    
    This is displayport used for internal connections such
    as laptop panels and systems with integrated monitors.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7970e677accb676f15e11468c60cb93ae477a513
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Jan 7 13:47:47 2010 -0500

    drm: Add eDP connector type
    
    Add a new connector type for eDP (embedded displayport)
    
    eDP is more or less the same as DP but there are some
    cases when you might want to handle it separately.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f0f480adcb6c44e76186c6d3036e06ed7e7e0202
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Jan 7 11:39:07 2010 -0500

    drm/radeon/kms: pull in the latest upstream ObjectID.h changes
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a7bc115fffb69a55cf2c332567ea6908d9026f22
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Jan 7 11:35:48 2010 -0500

    drm/radeon/kms: whitespace changes to ObjectID.h
    
    Makes it easier to keep in sync with ddx and the upstream
    AMD versions.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a5899fcc189e9357873ddf26d5e6e7e6ff84c2f4
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Jan 7 14:19:47 2010 -0500

    drm/radeon/kms: fix typo in atom connector type handling
    
    Also remove the problematic enums that were unused
    remnants from the ddx.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
--29444707-318580327-1263185555=:19527--
