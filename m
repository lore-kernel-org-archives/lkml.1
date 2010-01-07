Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048Ab0AGERk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0AGERk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 23:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389Ab0AGERj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 23:17:39 -0500
Received: from gir.skynet.ie ([193.1.99.77]:46771 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab0AGERi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 23:17:38 -0500
Date: Thu, 7 Jan 2010 04:17:28 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1001070415380.15109@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

This contains some EDID parser fixups, a patch to make the drm_pci_alloc 
sane (follow up from Eric to fix Intel driver bug that required this fix),
along with some kernel bug fixes for radeon kms and some coverity fixes.

Dave.

 drivers/gpu/drm/ati_pcigart.c              |   10 ++++-
 drivers/gpu/drm/drm_bufs.c                 |    4 +-
 drivers/gpu/drm/drm_edid.c                 |   14 +++++---
 drivers/gpu/drm/drm_fb_helper.c            |    2 +-
 drivers/gpu/drm/drm_pci.c                  |    8 +----
 drivers/gpu/drm/i915/i915_dma.c            |    2 +-
 drivers/gpu/drm/i915/i915_gem.c            |    2 +-
 drivers/gpu/drm/radeon/radeon_atombios.c   |    2 +
 drivers/gpu/drm/radeon/radeon_combios.c    |   50 +++++++++++++++++++++++-----
 drivers/gpu/drm/radeon/radeon_connectors.c |    2 +-
 drivers/gpu/drm/radeon/radeon_cp.c         |    1 +
 drivers/gpu/drm/radeon/radeon_device.c     |    6 ++-
 drivers/gpu/drm/radeon/radeon_display.c    |    5 ++-
 drivers/gpu/drm/radeon/radeon_fence.c      |    9 ++---
 drivers/gpu/drm/radeon/radeon_irq.c        |   10 +++---
 drivers/gpu/drm/radeon/rs600.c             |    2 +-
 include/drm/drmP.h                         |    2 +-
 17 files changed, 87 insertions(+), 44 deletions(-)

commit a81406b4143ff07e586bbe03c50f089da94eefe1
Merge: 90520b7 43b19f1
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Jan 7 14:00:29 2010 +1000

    Merge remote branch 'korg/drm-radeon-next' into drm-linus
    
    * korg/drm-radeon-next:
      drm/radeon/kms: rs600: use correct mask for SW interrupt
      gpu/drm/radeon/radeon_irq.c: move a dereference below a NULL test
      drm/radeon/radeon_device.c: move a dereference below a NULL test
      drm/radeon/radeon_fence.c: move a dereference below the NULL test
      drm/radeon/radeon_connectors.c: add a NULL test before dereference
      drm/radeon/kms: fix memory leak
      drm/radeon/kms: add missing breaks in i2c and ss lookups
      drm/radeon/kms: add primary dac adj values table
      drm/radeon/kms: fallback to default connector table

commit 43b19f161c7a9941e3aa7db0e3ee19b93980e3d7
Author: Luca Tettamanti <kronos.it@gmail.com>
Date:   Mon Dec 28 22:53:05 2009 +0100

    drm/radeon/kms: rs600: use correct mask for SW interrupt
    
    The mask happens to be the same, but the IH is reading the status, not the
    not the control register.
    
    Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 65aa2f4e8d85b6145ef4834f440a63ab68bd7443
Author: Darren Jenkins <darrenrjenkins@gmail.com>
Date:   Wed Dec 30 12:16:35 2009 +1100

    gpu/drm/radeon/radeon_irq.c: move a dereference below a NULL test
    
    If a NULL value is possible, the dereference should only occur after the
    NULL test.
    
    Coverity CID: 13338
    
    Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 875c186620e017e62b773c93e46af21bb704fe6b
Author: Darren Jenkins <darrenrjenkins@gmail.com>
Date:   Wed Dec 30 12:18:30 2009 +1100

    drm/radeon/radeon_device.c: move a dereference below a NULL test
    
    If a NULL value is possible, the dereference should only occur after the
    NULL test.
    
    Coverity CID: 13335
    
    Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3655d54af8dd85788c3e5088387469703a0f8f12
Author: Darren Jenkins <darrenrjenkins@gmail.com>
Date:   Wed Dec 30 12:20:05 2009 +1100

    drm/radeon/radeon_fence.c: move a dereference below the NULL test
    
    If a NULL value is possible, the dereference should only occur after the
    NULL test.
    
    Coverity CID: 13334
    
    Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit d8a7f79246a447722bd90c2c4ba3ca068b2aa4c0
Author: Darren Jenkins <darrenrjenkins@gmail.com>
Date:   Wed Dec 30 12:22:55 2009 +1100

    drm/radeon/radeon_connectors.c: add a NULL test before dereference
    
    The encoder variable can be NULL in this function so I believe it should
    be checked before dereference.
    
    Coverity CID: 13253
    
    [airlied: extremely unlikely to happen]
    
    Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 5eb226132f53d5ec36ce4e7ff9d6b49cceb50f3d
Author: Jiri Slaby <jslaby@suse.cz>
Date:   Wed Jan 6 17:39:31 2010 +0100

    drm/radeon/kms: fix memory leak
    
    Stanse found a memory leak in radeon_master_create. master_priv is not
    freed/assigned on all paths. Fix that.
    
    Signed-off-by: Jiri Slaby <jslaby@suse.cz>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 90520b78a4f8ba1faef75961eddd8192077e0ac2
Merge: d94a510 e89a8c9
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Jan 7 13:36:00 2010 +1000

    Merge branch 'drm-core-next' into drm-linus
    
    * drm-core-next:
      drm/kms: Fix &&/|| confusion in drm_fb_helper_connector_parse_command_line()
      drm/edid: Fix CVT width/height decode
      drm/edid: Skip empty CVT codepoints
      drm: remove address mask param for drm_pci_alloc()

commit e89a8c901ca94a47c0e0b2fb335623d810e37545
Author: Roel Kluin <roel.kluin@gmail.com>
Date:   Thu Dec 31 13:06:29 2009 +0100

    drm/kms: Fix &&/|| confusion in drm_fb_helper_connector_parse_command_line()
    
    This always evaluates to true.
    
    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 8e10ee9a0da12c586d3397150e34a946507c23f3
Author: Adam Jackson <ajax@redhat.com>
Date:   Mon Jan 4 17:53:07 2010 -0500

    drm/edid: Fix CVT width/height decode
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 69da301589b579f9619475e30cc449df9193410c
Author: Adam Jackson <ajax@redhat.com>
Date:   Mon Jan 4 17:53:06 2010 -0500

    drm/edid: Skip empty CVT codepoints
    
    Signed-off-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e6be8d9d17bd44061116f601fe2609b3ace7aa69
Author: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date:   Tue Jan 5 11:25:05 2010 +0800

    drm: remove address mask param for drm_pci_alloc()
    
    drm_pci_alloc() has input of address mask for setting pci dma
    mask on the device, which should be properly setup by drm driver.
    And leave it as a param for drm_pci_alloc() would cause confusion
    or mistake would corrupt the correct dma mask setting, as seen on
    intel hw which set wrong dma mask for hw status page. So remove
    it from drm_pci_alloc() function.
    
    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 1d3d51b6d2d6fb51c6c30a8c7ed0fd939f6100bf
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Dec 28 13:45:23 2009 -0500

    drm/radeon/kms: add missing breaks in i2c and ss lookups
    
    Should fix fdo bug 25741
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 246263ccc31e4ba2886cca17000bf09ea683eac5
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Dec 29 12:09:17 2009 -0500

    drm/radeon/kms: add primary dac adj values table
    
    Look up primary dac adj values from the table if
    there is no bios or bios dac table to reference.
    
    The lookup table may need to be adjusted for certain
    families.
    
    Should fix kernel bug 14945.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b9597a1c6fa6cbc938f14ab6a7fe09047b3a346b
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Jan 4 19:12:02 2010 -0500

    drm/radeon/kms: fallback to default connector table
    
    if necessary for combios
    
    Some early combios radeon cards don't have a connector
    table or dac table in the bios, if they do not, fallback
    to the default tables.
    
    Should fix kernel bug 14963.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
