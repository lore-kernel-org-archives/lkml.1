Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYKCBAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYKCBAC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 20:00:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYKCA7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 19:59:52 -0500
Received: from gir.skynet.ie ([193.1.99.77]:37128 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbYKCA7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 19:59:52 -0500
Date: Mon, 3 Nov 2008 00:59:49 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: [git pull] drm fixes for 2.6.28-rc4
Message-ID: <alpine.DEB.0.82.0811030058220.21357@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-591965694-1225673989=:21357"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-591965694-1225673989=:21357
Content-Type: TEXT/PLAIN; charset=iso-2022-jp


Hi Linus,

Please pull the 'drm-next' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-next

Intel: One build fix and a new API needed to make GEM work properly.
radeon: fix a regression is the bus mastering patches on rs480.

Dave.

 drivers/gpu/drm/i915/Makefile       |    3 ++-
 drivers/gpu/drm/i915/i915_dma.c     |    1 +
 drivers/gpu/drm/i915/i915_drv.h     |    9 +++++++++
 drivers/gpu/drm/i915/i915_gem.c     |   22 ++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_cp.c  |   15 ++++++++-------
 drivers/gpu/drm/radeon/radeon_drv.h |   12 ++++++------
 include/drm/i915_drm.h              |   13 +++++++++++++
 7 files changed, 61 insertions(+), 14 deletions(-)

commit 5a125c3c79167e78ba44efef03af7090ef28eeaf
Author: Eric Anholt <eric@anholt.net>
Date:   Wed Oct 22 21:40:13 2008 -0700

    i915: Add GEM ioctl to get available aperture size.
    
    This will let userland know when to submit its batchbuffers, before they get
    too big to fit in the aperture.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 4e270e9b8a9d246290f3901f1fb6c5efdb734ddf
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Oct 28 07:48:34 2008 +1000

    drm/radeon: fixup further bus mastering confusion.
    
    rs400/480 are like previous chips not like rs6xx chips.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 65e082c9a33a6e9f24e9a713a7d38d11206d3c3d
Author: Len Brown <len.brown@intel.com>
Date:   Fri Oct 24 17:18:10 2008 -0400

    build fix: CONFIG_DRM_I915=y && CONFIG_ACPI=n
    
    drivers/gpu/drm/i915/i915_opregion.c:340: error: implicit declaration of function ‘register_acpi_notifier’
    drivers/gpu/drm/i915/i915_opregion.c:361: error: implicit declaration of function ‘unregister_acpi_notifier’
    
    Signed-off-by: Len Brown <len.brown@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
--29444707-591965694-1225673989=:21357--
