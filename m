Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbYHaXBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbYHaXBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 19:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYHaXAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 19:00:52 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35627 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbYHaXAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 19:00:51 -0400
Date: Mon, 1 Sep 2008 00:00:49 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm debug message downgrade.
Message-ID: <alpine.DEB.0.82.0808312359080.23105@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

In theory people seeing this message have bugs that need fixing, in 
practice these aren't kernel bugs, and need a lot of investigation. So 
just don't spam peoples logs.

Dave.

 drivers/gpu/drm/radeon/radeon_cp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

commit 6c7be29810dd85b4fe75588ec536446c1579d492
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Sep 1 08:51:52 2008 +1000

    drm/radeon: downgrade debug message from info to debug.
    
    If this triggers its bad, however some machines seem to have been
    triggering it for ages and we didn't know until we added the debug.
    
    So downgrade the debug now so people don't call this a regression.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>

diff --git a/drivers/gpu/drm/radeon/radeon_cp.c b/drivers/gpu/drm/radeon/radeon_cp.c
index 3331f88..248ab4a 100644
--- a/drivers/gpu/drm/radeon/radeon_cp.c
+++ b/drivers/gpu/drm/radeon/radeon_cp.c
@@ -223,7 +223,7 @@ static int radeon_do_wait_for_fifo(drm_radeon_private_t * dev_priv, int entries)
 			return 0;
 		DRM_UDELAY(1);
 	}
-	DRM_INFO("wait for fifo failed status : 0x%08X 0x%08X\n",
+	DRM_DEBUG("wait for fifo failed status : 0x%08X 0x%08X\n",
 		 RADEON_READ(RADEON_RBBM_STATUS),
 		 RADEON_READ(R300_VAP_CNTL_STATUS));
 
@@ -252,7 +252,7 @@ static int radeon_do_wait_for_idle(drm_radeon_private_t * dev_priv)
 		}
 		DRM_UDELAY(1);
 	}
-	DRM_INFO("wait idle failed status : 0x%08X 0x%08X\n",
+	DRM_DEBUG("wait idle failed status : 0x%08X 0x%08X\n",
 		 RADEON_READ(RADEON_RBBM_STATUS),
 		 RADEON_READ(R300_VAP_CNTL_STATUS));
 
