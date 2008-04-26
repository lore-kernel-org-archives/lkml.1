Return-Path: <linux-kernel-owner+w=401wt.eu-S1757759AbYDZI1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbYDZI1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 04:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYDZI1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 04:27:17 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45064 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYDZI1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 04:27:09 -0400
Date: Sat, 26 Apr 2008 09:25:35 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm patches for 2.6.26-rc1
Message-ID: <alpine.DEB.0.82.0804260924050.12688@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-300141906-1209198335=:12688"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-300141906-1209198335=:12688
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-patches' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

Nothing major in this, the TTM and modesetting stuff is still on hold, so 
this is just other things that were in the queue, some bug fixes and code 
re-org.

Dave.

 drivers/char/drm/ati_pcigart.c    |    7 -
 drivers/char/drm/drm.h            |   17 +
 drivers/char/drm/drmP.h           |  133 ++++++---
 drivers/char/drm/drm_agpsupport.c |    2 +-
 drivers/char/drm/drm_drv.c        |   60 ++--
 drivers/char/drm/drm_fops.c       |   41 ++--
 drivers/char/drm/drm_irq.c        |  381 ++++++++++++++++++++----
 drivers/char/drm/drm_proc.c       |   61 +++--
 drivers/char/drm/drm_stub.c       |  138 ++++++---
 drivers/char/drm/drm_sysfs.c      |   46 ++--
 drivers/char/drm/drm_vm.c         |   22 +-
 drivers/char/drm/i810_dma.c       |    4 +-
 drivers/char/drm/i830_dma.c       |    4 +-
 drivers/char/drm/i915_dma.c       |  160 ++++++++---
 drivers/char/drm/i915_drm.h       |   45 +++-
 drivers/char/drm/i915_drv.c       |    8 +-
 drivers/char/drm/i915_drv.h       |  103 ++++++-
 drivers/char/drm/i915_irq.c       |  605 ++++++++++++++++++++++++++++---------
 drivers/char/drm/mga_drv.c        |    7 +-
 drivers/char/drm/mga_drv.h        |    6 +-
 drivers/char/drm/mga_irq.c        |   69 +++--
 drivers/char/drm/r128_drv.c       |    7 +-
 drivers/char/drm/r128_drv.h       |    9 +-
 drivers/char/drm/r128_irq.c       |   55 +++--
 drivers/char/drm/radeon_drv.c     |    8 +-
 drivers/char/drm/radeon_drv.h     |   19 +-
 drivers/char/drm/radeon_irq.c     |  171 +++++------
 drivers/char/drm/via_drv.c        |    6 +-
 drivers/char/drm/via_drv.h        |    7 +-
 drivers/char/drm/via_irq.c        |   81 +++--
 30 files changed, 1621 insertions(+), 661 deletions(-)

commit b74e2082f8e7b8f37af3fc39e8ee0dd0d218c589
Author: Dave Airlie <airlied@linux.ie>
Date:   Sat Apr 26 18:21:28 2008 +1000

    drm: _end is shadowing real _end, just rename it.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit ac741ab71bb39e6977694ac0cc26678d8673cda4
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Apr 22 16:03:07 2008 +1000

    drm/vbl rework: rework how the drm deals with vblank.
    
    Other Authors: Michel Dänzer <michel@tungstengraphics.com>
    mga: Ian Romanick <idr@us.ibm.com>
    via: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
    
    This re-works the DRM internals to provide a better interface for drivers
    to expose vblank on multiple crtcs.
    
    It also includes work done by Michel on making i915 triple buffering and pageflipping work properly.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 2c14f28be2a3f2a2e9861b156d64fbe2bc7000c3
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Apr 21 16:47:32 2008 +1000

    drm: reorganise minor number handling using backported modesetting code.
    
    rips out the head crap and replaces it with an idr and drm_minor structure
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 7b832b56bd971348329c3f4c753ca0abfdf3a3d1
Author: Keith Packard <keithp@keithp.com>
Date:   Mon Apr 21 16:31:10 2008 +1000

    drm/i915: Handle tiled buffers in vblank tasklet
    
    The vblank tasklet update code must build 2D blt commands with the appropriate
    tiled flags
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit a36b7dcc05bc4c4580f11cf78e95edfefa86b8a6
Author: Keith Packard <keithp@keithp.com>
Date:   Mon Apr 21 16:27:24 2008 +1000

    drm/i965: On I965, use correct 3DSTATE_DRAWING_RECTANGLE command in vblank
    
    The batchbuffer submission paths were fixed to use the 965-specific command,
    but the vblank tasklet was not. When the older version is sent, the 965 will
    lock up.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit f1c3e67eb73a4a1db31e235883156ac098e29ff6
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Sun Apr 20 10:26:31 2008 +1000

    drm: Remove unneeded dma sync in ATI pcigart alloc
    
    Now that the ATI pcigart code uses dma_alloc_coherent, we don't need
    the dma_sync_single_for_device() that we used to have here.
    
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5ff64611333fd282793ff8997e02138aa2f6aab9
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Sun Apr 20 10:26:25 2008 +1000

    drm: Fix mismerge of non-coherent DMA patch
    
    The patch for supporting non coherent PCI DMA in the DRM was mismerged
    causing the page protection to be updated for the wrong type of
    mapping.
    
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
--29444707-300141906-1209198335=:12688--
