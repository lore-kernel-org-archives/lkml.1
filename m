Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbZLXMvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbZLXMvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbZLXMvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:51:54 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:46947 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZLXMvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:51:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=esDdIB/f0PpOn1HE+lGjJio5Aycj7FTPDucsIdE7b8ygkmxjwW5Xw1GRA+4u9tXDHN
         fLCe93IoP88CP6+JEFZVW7r0SnMPC/ix0sr3TonVPHxujwPnKClh03oEK05v+fEfwpLF
         BQ6Jyd7378X+lGGAj/9dXx7BvZhiqUeevyAhA=
Subject: drivers/gpu/drm/radeon/radeon_fence.c: move a dereference below
 the NULL test
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Dec 2009 23:52:00 +1100
Message-ID: <1261659120.3546.15.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a NULL value is possible, the dereference should only occur after the
NULL test.

Coverity CID: 13334

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
diff --git a/drivers/gpu/drm/radeon/radeon_fence.c
b/drivers/gpu/drm/radeon/radeon_fence.c
index cb4cd97..f4f5942 100644
--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -140,14 +140,14 @@ int radeon_fence_create(struct radeon_device
*rdev, struct radeon_fence **fence)
 
 bool radeon_fence_signaled(struct radeon_fence *fence)
 {
-	struct radeon_device *rdev = fence->rdev;
 	unsigned long irq_flags;
 	bool signaled = false;
 
-	if (rdev->gpu_lockup) {
+	if (fence == NULL) {
 		return true;
 	}
-	if (fence == NULL) {
+
+	if (fence->rdev->gpu_lockup) {
 		return true;
 	}
 	write_lock_irqsave(&fence->rdev->fence_drv.lock, irq_flags);


