Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935949Ab0CMA4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:56:31 -0500
Received: from kroah.org ([198.145.64.141]:46858 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935402Ab0CMAbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:22 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:09 2010
Message-Id: <20100313002709.342792894@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@linux.ie>
Subject: [047/145] drm/radeon/kms: r600/r700 dont test ib if ib initialization fails
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Jerome Glisse <jglisse@redhat.com>

commit db96380ea26fcc31ab37189aedeabd12894b1431 upstream

If ib initialization failed don't try to test ib as it will result
in an oops (accessing NULL ib buffer ptr).

[bwh: Adjusted context for 2.6.32]
Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@linux.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r600.c  |   13 +++++++------
 drivers/gpu/drm/radeon/rv770.c |   13 +++++++------
 2 files changed, 14 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1686,13 +1686,14 @@ int r600_init(struct radeon_device *rdev
 	if (rdev->accel_working) {
 		r = radeon_ib_pool_init(rdev);
 		if (r) {
-			DRM_ERROR("radeon: failled initializing IB pool (%d).\n", r);
-			rdev->accel_working = false;
-		}
-		r = r600_ib_test(rdev);
-		if (r) {
-			DRM_ERROR("radeon: failled testing IB (%d).\n", r);
+			dev_err(rdev->dev, "IB initialization failed (%d).\n", r);
 			rdev->accel_working = false;
+		} else {
+			r = r600_ib_test(rdev);
+			if (r) {
+				dev_err(rdev->dev, "IB test failed (%d).\n", r);
+				rdev->accel_working = false;
+			}
 		}
 	}
 	return 0;
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -1034,13 +1034,14 @@ int rv770_init(struct radeon_device *rde
 	if (rdev->accel_working) {
 		r = radeon_ib_pool_init(rdev);
 		if (r) {
-			DRM_ERROR("radeon: failled initializing IB pool (%d).\n", r);
-			rdev->accel_working = false;
-		}
-		r = r600_ib_test(rdev);
-		if (r) {
-			DRM_ERROR("radeon: failled testing IB (%d).\n", r);
+			dev_err(rdev->dev, "IB initialization failed (%d).\n", r);
 			rdev->accel_working = false;
+		} else {
+			r = r600_ib_test(rdev);
+			if (r) {
+				dev_err(rdev->dev, "IB test failed (%d).\n", r);
+				rdev->accel_working = false;
+			}
 		}
 	}
 	return 0;


