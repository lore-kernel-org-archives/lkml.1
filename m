Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbZHGLVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbZHGLVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZHGLVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:21:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40462 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZHGLVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:21:23 -0400
Date: Fri, 7 Aug 2009 12:21:24 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [update 2 git pull] drm-fixes
Message-ID: <alpine.DEB.2.00.0908071220120.30840@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

threw another patch in here, after doing some suspend/resume testing 
today. so rs880 pci ids, and a radeon kms TTM patch + radeon kms 
suspend/resume fix.

Dave.

 drivers/gpu/drm/radeon/r600_cp.c       |   22 +++++++++++++++-------
 drivers/gpu/drm/radeon/radeon_device.c |    4 +++-
 drivers/gpu/drm/radeon/radeon_drv.h    |    1 +
 drivers/gpu/drm/radeon/radeon_object.c |    2 +-
 include/drm/drm_pciids.h               |    5 +++++
 5 files changed, 25 insertions(+), 9 deletions(-)

commit 17332925d7b11bb6c2d0c49450ae58dd836005da
Author: Dave Airlie <airlied@linux.ie>
Date:   Fri Aug 7 11:03:26 2009 +1000

    drm/radeon/kms: setup MC/VRAM the same way for suspend/resume
    
    we should align the GTT after VRAM no matter what, as we can
    come back from resume and put in a different place and bad things happen.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 985fe845aea9cd56fd351800302270444556e45a
Author: Jerome Glisse <jglisse@redhat.com>
Date:   Wed Jul 29 18:55:53 2009 +0200

    drm/radeon/kms: Fix caching mode selection for GTT object
    
    GTT object can either be cached,uncached or wc just let core ttm
    pick the best mode according to how the bo driver and GTT memory
    type was initialized.
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 6502fbfaf81b09b3f474bb7b3796257e9450273e
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Tue Aug 4 11:24:24 2009 -0400

    drm/radeon: Add support for RS880 chips
    
    These are new AMD IGP chips
    
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
