Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbZAGB7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbZAGB7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 20:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbZAGB7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 20:59:24 -0500
Received: from gir.skynet.ie ([193.1.99.77]:38191 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbZAGB7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 20:59:23 -0500
Date: Wed, 7 Jan 2009 01:59:21 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm
Message-ID: <alpine.DEB.2.00.0901070158070.19217@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-308820800-1231293561=:19217"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-308820800-1231293561=:19217
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-next' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-next

This is mostly KMS related fixes, with a GEM related fix that stable also 
needs.

Dave.

 drivers/gpu/drm/drm_drv.c            |    6 +-
 drivers/gpu/drm/i915/Makefile        |    1 +
 drivers/gpu/drm/i915/i915_dma.c      |   46 ++++--
 drivers/gpu/drm/i915/i915_drv.h      |    2 +
 drivers/gpu/drm/i915/i915_gem.c      |   15 +-
 drivers/gpu/drm/i915/i915_reg.h      |   25 +++-
 drivers/gpu/drm/i915/intel_display.c |   48 +++++--
 drivers/gpu/drm/i915/intel_drv.h     |    5 +-
 drivers/gpu/drm/i915/intel_hdmi.c    |  280 ++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_sdvo.c    |    8 +-
 10 files changed, 397 insertions(+), 39 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/intel_hdmi.c

commit a75f28419a7efff611a81293d41d0e2137d7591e
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Jan 7 11:54:57 2009 +1000

    drm: fix ordering of driver unload vs agp unload.
    
    For KMS drivers, we really need to cleanup the driver before disabling
    the AGP subsystem.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 241fa85b2bb655224357d713c251077dee3585ce
Author: Eric Anholt <eric@anholt.net>
Date:   Fri Jan 2 18:05:51 2009 -0800

    drm/i915: Respect the other stolen memory sizes we know of.
    
    fd.o bug #19336.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 1fc45d84d616cec00566152c1080903c461eb537
Author: Eric Anholt <eric@anholt.net>
Date:   Fri Jan 2 15:57:35 2009 -0800

    drm/i915: Non-mobile parts don't have integrated TV-out.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 7d57382e65994ab7d01741373bd1c420370aed9f
Author: Eric Anholt <eric@anholt.net>
Date:   Fri Jan 2 13:33:00 2009 -0800

    drm/i915: Add support for integrated HDMI on G4X hardware.
    
    This is ported directly from the userland 2D driver code.  The HDMI audio bits
    aren't hooked up yet.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 3f8bc370ac679a5fe5c098f30d3cf8e80f62a9f8
Author: Kristian Høgsberg <krh@redhat.com>
Date:   Wed Dec 17 22:14:59 2008 -0500

    drm/i915: Pin cursor bo and unpin old bo when setting cursor.
    
    We also didn't track the cursor bo before and would leak a reference
    when the cursor image was change.
    
    Signed-off-by: Kristian Høgsberg <krh@redhat.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 9bb2d6f94aeb9a185d69aedbd19421b6da4e3309
Author: Eric Anholt <eric@anholt.net>
Date:   Tue Dec 23 18:42:32 2008 -0800

    drm/i915: Don't allow objects to get bound while VT switched.
    
    This avoids a BUG_ON in the enter_vt path due to objects being in the GTT
    when we shouldn't have ever let them be (as we're not supposed to touch the
    device during that time).
    
    This was triggered by a change in the 2D driver to use the GTT mapping of
    objects after pinning them to improve software fallback performance.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@linux.ie>
--29444707-308820800-1231293561=:19217--
