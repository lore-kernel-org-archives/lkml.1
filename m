Return-Path: <linux-kernel-owner+w=401wt.eu-S932112Ab0AEAwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab0AEAwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241Ab0AEAe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:34:57 -0500
Received: from kroah.org ([198.145.64.141]:34145 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab0AEAex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:53 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dave Airlie <airlied@linux.ie>,
       Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/97] drm/radeon: fix build on 64-bit with some compilers.
Date: Mon,  4 Jan 2010 16:32:32 -0800
Message-Id: <1262651630-7354-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@linux.ie>

commit 794f3141a194a4f4c28c1d417b071a901f78d9bb upstream.

drivers/gpu/drm/radeon/radeon_test.c:45: undefined reference to `__udivdi3'

Reported-by: Mr. James W. Laferriere <babydr@baby-dragons.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/radeon/radeon_test.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_test.c b/drivers/gpu/drm/radeon/radeon_test.c
index f8a465d..c8942ca 100644
--- a/drivers/gpu/drm/radeon/radeon_test.c
+++ b/drivers/gpu/drm/radeon/radeon_test.c
@@ -42,8 +42,8 @@ void radeon_test_moves(struct radeon_device *rdev)
 	/* Number of tests =
 	 * (Total GTT - IB pool - writeback page - ring buffer) / test size
 	 */
-	n = (rdev->mc.gtt_size - RADEON_IB_POOL_SIZE*64*1024 - RADEON_GPU_PAGE_SIZE -
-	     rdev->cp.ring_size) / size;
+	n = ((u32)(rdev->mc.gtt_size - RADEON_IB_POOL_SIZE*64*1024 - RADEON_GPU_PAGE_SIZE -
+	     rdev->cp.ring_size)) / size;
 
 	gtt_obj = kzalloc(n * sizeof(*gtt_obj), GFP_KERNEL);
 	if (!gtt_obj) {
-- 
1.6.6

