Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbZK3Qr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbZK3Qr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZK3Qr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:47:58 -0500
Received: from nox.protox.org ([88.191.38.29]:42741 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbZK3Qr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:47:57 -0500
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: Disable agp only if we are dealing with an AGP GPU
Date: Mon, 30 Nov 2009 17:47:59 +0100
Message-Id: <1259599679-16698-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On IGP if you pass option agpmode=-1 you would overwrite the set_page
function callback with improper function which endup in non functioning
hw. This patch will disable agp when giving agpmode=-1 parameter only
if we are dealing with an AGP GPU.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_device.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index e3f9edf..eaed6af 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -553,7 +553,7 @@ int radeon_device_init(struct radeon_device *rdev,
 		return r;
 	}
 
-	if (radeon_agpmode == -1) {
+	if (rdev->flags & RADEON_IS_AGP && radeon_agpmode == -1) {
 		radeon_agp_disable(rdev);
 	}
 
-- 
1.6.5.2

