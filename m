Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbZEEXUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbZEEXUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZEEXUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:20:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44266 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbZEEXUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:20:34 -0400
Date: Wed, 6 May 2009 00:20:30 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.0905060013470.12168@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

This is just a bunch of minor fixes and cleanups from F11 development and 
that area.

I'm off on holidays to Ireland until the start of June, so I'm sorta 
hoping the merge window won't magic itself up in that time, we are hoping 
to merge the radeon kms code under an experimental banner. I'm leaving 
core drm in Jesse Barnes hands, and Eric will continue looking after 
Intel.

Dave.

 drivers/gpu/drm/drm_crtc_helper.c   |   19 -------------------
 drivers/gpu/drm/drm_drv.c           |    3 ++-
 drivers/gpu/drm/drm_stub.c          |   15 +++++++++------
 drivers/gpu/drm/drm_sysfs.c         |    2 --
 drivers/gpu/drm/r128/r128_cce.c     |    6 +++---
 drivers/gpu/drm/radeon/radeon_drv.h |    3 ++-
 6 files changed, 16 insertions(+), 32 deletions(-)

commit 42beefc0093725ec0f8cea340cc54c36ccaceea0
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed May 6 09:04:52 2009 +1000

    drm/r128: fix r128 ioremaps to use ioremap_wc.
    
    This should allow r128 to start working again since PAT changes.
    
    taken from F-11 kernel.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3788f48a0fad246dbab826e8b2f07b403b0e3279
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Mon Mar 2 10:37:44 2009 +1000

    drm: cleanup properly in drm_get_dev() failure paths
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 30ddbd94401a132f4d932775d1902b3c9a8c41b5
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Mon Mar 2 11:13:04 2009 +1000

    drm: clean the map list before destroying the hash table
    
    The hash tables contains some of the mapping
    so its really nice to have it for the deletion phase.
    
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 400138bc8b9fca66d7d40511eaed2dc3a75426c8
Author: Jonas Bonn <jonas@southpole.se>
Date:   Fri Apr 24 15:06:36 2009 +1000

    drm: remove unreachable code in drm_sysfs.c
    
    This code was never going to get called in there.
    
    Signed-off-by: Jonas Bonn <jonas@southpole.se>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 59738d5c974d81b566cb53c203f5db268b7b3545
Author: Jonas Bonn <jonas@southpole.se>
Date:   Fri Apr 24 15:05:02 2009 +1000

    drm: add control node checks missing from kms merge
    
    This line that checks the DRM_CONTROL_ALLOW flag was missed from the KMS
    merge.  Re-add the check on the IOCTL, as this is currently the only use of
    this flag.
    
    Signed-off-by: Jonas Bonn <jonas@southpole.se>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit c964b129425c98cb37da365e772bdbe5281f3a05
Author: Dave Airlie <airlied@linux.ie>
Date:   Wed Apr 22 18:32:56 2009 +1000

    drm/kms: don't try to shortcut drm mode set function
    
    We have a drm_set_config which takes a crtc/encoder/mode setup,
    and checks it to see if it can shortcut and just do a base setup,
    or whether a complete mode setting is required.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit e8a1344119f3787b822d110336e5dd33f6ffca70
Author: Maciej Cencora <m.cencora@gmail.com>
Date:   Fri Apr 17 15:55:09 2009 +0200

    drm/radeon: bump minor version for occlusion queries support
    
    We already added support, just need to let userspace
    know when it can use them.
    
    Signed-off-by: Maciej Cencora <m.cencora@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
