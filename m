Return-Path: <linux-kernel-owner+w=401wt.eu-S936570AbZLQEam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936570AbZLQEam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936545AbZLQE36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:29:58 -0500
Received: from kroah.org ([198.145.64.141]:55665 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935572AbZLQEEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:41 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:53 2009
Message-Id: <20091217035653.117673162@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [079/151] drm/radeon/kms: fix vram setup on rs600
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 722f29434e72188b2d20f9b41f4b5952073ed568 upstream.

also fix up rs690 mem width.

should fix fdo bug 25408

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/rs600.c |    6 ++++++
 drivers/gpu/drm/radeon/rs690.c |   10 ++--------
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -315,6 +315,12 @@ void rs600_vram_info(struct radeon_devic
 	/* FIXME: to do or is these values sane ? */
 	rdev->mc.vram_is_ddr = true;
 	rdev->mc.vram_width = 128;
+
+	rdev->mc.real_vram_size = RREG32(RADEON_CONFIG_MEMSIZE);
+	rdev->mc.mc_vram_size = rdev->mc.real_vram_size;
+
+	rdev->mc.aper_base = drm_get_resource_start(rdev->ddev, 0);
+	rdev->mc.aper_size = drm_get_resource_len(rdev->ddev, 0);
 }
 
 void rs600_bandwidth_update(struct radeon_device *rdev)
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -131,19 +131,13 @@ void rs690_pm_info(struct radeon_device 
 
 void rs690_vram_info(struct radeon_device *rdev)
 {
-	uint32_t tmp;
 	fixed20_12 a;
 
 	rs400_gart_adjust_size(rdev);
 	/* DDR for all card after R300 & IGP */
 	rdev->mc.vram_is_ddr = true;
-	/* FIXME: is this correct for RS690/RS740 ? */
-	tmp = RREG32(RADEON_MEM_CNTL);
-	if (tmp & R300_MEM_NUM_CHANNELS_MASK) {
-		rdev->mc.vram_width = 128;
-	} else {
-		rdev->mc.vram_width = 64;
-	}
+	rdev->mc.vram_width = 128;
+
 	rdev->mc.real_vram_size = RREG32(RADEON_CONFIG_MEMSIZE);
 	rdev->mc.mc_vram_size = rdev->mc.real_vram_size;
 


