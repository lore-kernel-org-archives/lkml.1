Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZAVEqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZAVEqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 23:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbZAVEq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 23:46:29 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35076 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756519AbZAVEq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 23:46:28 -0500
Date: Thu, 22 Jan 2009 04:46:26 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm-fixes
Message-ID: <alpine.DEB.2.00.0901220432480.25266@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

This includes a bunch of kms fixes, along one with regression with the 
freeing of maps from the multi-master changes, along with make drm build 
on MIPS work.

Dave.

 drivers/gpu/drm/drm_agpsupport.c  |    3 ++-
 drivers/gpu/drm/drm_crtc.c        |   14 +++++++++-----
 drivers/gpu/drm/drm_drv.c         |    4 ++++
 drivers/gpu/drm/drm_edid.c        |    2 +-
 drivers/gpu/drm/drm_stub.c        |    8 ++++++++
 drivers/gpu/drm/i915/i915_dma.c   |    7 ++++---
 drivers/gpu/drm/i915/i915_gem.c   |    2 +-
 drivers/gpu/drm/i915/intel_lvds.c |   13 +++++++++++++
 include/drm/drm_crtc.h            |    3 ++-
 9 files changed, 44 insertions(+), 12 deletions(-)

commit 2906f0258770d3a9c4e65364df8acc904e148bbe
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Jan 20 19:10:54 2009 -0800

    drm/i915: Fix cursor physical address choice to match the 2D driver.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Eric Anholt <eric@anholt.net>

commit 1bb88edb7a3769992026f34fd648bb459b0469aa
Author: Eric Anholt <eric@anholt.net>
Date:   Thu Jan 15 01:16:25 2009 -0800

    drm: stash AGP include under the do-we-have-AGP ifdef
    
    This fixes the MIPS with DRM build.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Tested-by: Martin Michlmayr <tbm@cyrius.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4942f8b23b56a3f9a713d4436338710579329ffc
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Jan 22 22:23:53 2009 +1000

    drm: don't whine about not reading EDID data
    
    Make this message a little quieter, since it's common and not necessarily
    indicative of a problem.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 335041ed31d774391d9add49824d05e7d19d93e9
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Jan 22 22:22:06 2009 +1000

    drm/i915: hook up LVDS DPMS property
    
    The LVDS output supports DPMS calls, but we never hooked up the property code,
    so set property calls didn't actually do anything.  Implement a set_property
    callback for the LVDS output so that the right thing happens.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

commit ed2dd4b0cc1494c27478f4ea8452f68d2037a60c
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Jan 22 22:21:16 2009 +1000

    drm/i915: remove unnecessary debug output in KMS init
    
    We don't really need to print out the FB BAR...
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 260883c85611d3a7e27130af9aef15252856e14f
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Jan 22 17:58:49 2009 +1000

    i915: fix freeing path for gem phys objects.
    
    This off-by-one was pointed out by Jesse Barnes.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit ad2563c2e42fc67b0976aeb70e9f3faf1c1196e8
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Jan 19 17:21:45 2009 +1000

    drm: create mode_config idr lock
    
    Create a separate mode_config IDR lock for simplicity.  The core DRM
    config structures (connector, mode, etc. lists) are still protected by
    the mode_config mutex, but the CRTC IDR (used for the various identifier
    IDs) is now protected by the mode_config idr_mutex.  Simplifies the
    locking a bit and removes a warning.
    
    All objects are protected by the config mutex, we may in the future,
    split the object further to have reference counts.
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c1ff85d97708550e634fb6fa099c463db90fc40d
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Jan 19 17:17:58 2009 +1000

    drm: fix leak of device mappings since multi-master changes.
    
    Device maps now contain a link to the master that created them, so
    when cleaning up the master, remove any maps that are connected to it.
    Also delete any remaining maps at driver unload time.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
