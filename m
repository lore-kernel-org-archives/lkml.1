Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876Ab0AMGZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0AMGZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 01:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421Ab0AMGZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 01:25:22 -0500
Received: from gir.skynet.ie ([193.1.99.77]:50973 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab0AMGZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 01:25:21 -0500
Date: Wed, 13 Jan 2010 06:25:10 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1001130623380.32257@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-222486487-1263363910=:32257"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-222486487-1263363910=:32257
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-linus' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Small set of fixes, one brown paper bagger where I switched from warn to 
printk but lost the conditional, dropped the mode set msg which spams on 
intel a lot, and some random radeon kms fixes one for a s/r regression.

Dave.

 drivers/gpu/drm/drm_crtc_helper.c               |    5 +++--
 drivers/gpu/drm/radeon/r600.c                   |    8 ++++----
 drivers/gpu/drm/radeon/radeon_combios.c         |    3 +++
 drivers/gpu/drm/radeon/radeon_connectors.c      |    8 ++++++++
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |   21 ++++++++++++++++++++-
 drivers/gpu/drm/radeon/radeon_ttm.c             |    5 ++++-
 6 files changed, 42 insertions(+), 8 deletions(-)

commit 194fda0dd83623f7927d505e39008c73fbc1c141
Merge: ef14587 9270eb1
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Jan 13 16:17:38 2010 +1000

    Merge remote branch 'korg/drm-radeon-next' into drm-linus
    
    * korg/drm-radeon-next
      drm/radeon/kms: only evict to GTT if CP is ready
      drm/radeon/kms: Fix crash getting TV info with no BIOS.
      drm/radeon/kms/rv100: reject modes > 135 Mhz on DVI (v2)
      drm/radeon/kms/r6xx+: make irq handler less verbose
      drm/radeon/kms: fix up LVDS handling on macs (v2)

commit ef14587706521287f1c7ea3326e732f7d86dd096
Author: Dave Young <hidave.darkstar@gmail.com>
Date:   Wed Jan 13 13:38:59 2010 +0800

    drm: change drm set mode messages as DRM_DEBUG
    
    Following drm info repeat 207 times during one hour, it's quite annoying
    [ 1266.286747] [drm] TV-19: set mode NTSC 480i 0
    
    Change from DRM_INFO to DRM_DEBUG
    
    Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 70a94d6a35072b62f808155f117f00485a395f03
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Jan 13 16:15:11 2010 +1000

    drm: fix crtc no modes printf + typo
    
    Toralf Förster pointed out the typo, the fact I forget the if
    statement is purely personal fail.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 9270eb1b496cb002d75f49ef82c9ef4cbd22a5a0
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Jan 13 09:21:49 2010 +1000

    drm/radeon/kms: only evict to GTT if CP is ready
    
    Testing GTT ready might be more correct but cp.ready
    works fine and has been tested on irc by 2-3 ppl.
    
    fixes bug k.org 15035 and fd.o 25733
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 11f3b59e3654c66c4e8ef2c48f8138b78bf440da
Author: Michel Dänzer <daenzer@vmware.com>
Date:   Mon Jan 11 08:58:38 2010 +0100

    drm/radeon/kms: Fix crash getting TV info with no BIOS.
    
    Signed-off-by: Michel Dänzer <daenzer@vmware.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 1b24203e51072b6e76aff8c74bdd67eb3b34a724
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Jan 11 15:02:31 2010 -0500

    drm/radeon/kms/rv100: reject modes > 135 Mhz on DVI (v2)
    
    Due to heat issues.  Fixes fdo bug 25992
    
    v2: fix typo noticed by Maarten Maathuis
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit b042589ca038e647fa1e2bb4e7ac3963688479b8
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Mon Jan 11 19:47:38 2010 -0500

    drm/radeon/kms/r6xx+: make irq handler less verbose
    
    Unhandled vectors can be safely ignored, no need
    to spam the kernel log by default.
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3890ddf56dbc0f804953198e65a7e406ed654576
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Jan 12 11:16:57 2010 -0500

    drm/radeon/kms: fix up LVDS handling on macs (v2)
    
    Based on radeonfb code and recent ddx fix.
    
    v2: minor formatting fix from Michel Dänzer
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Reviewed-by: Michel Dänzer <michel@daenzer.net>
    Tested-by: Michel Dänzer <michel@daenzer.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
--29444707-222486487-1263363910=:32257--
