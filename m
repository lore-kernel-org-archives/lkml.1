Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbZL3BUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbZL3BUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZL3BUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:20:13 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:51769 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbZL3BUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:20:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=k6YEOVhy8RudJOY4lcinXwDv7WcLdbGfUrLfzKfnXvmfq0L1v1xPE3LyMEHLj7Vjr4
         GaXF3Eo95KRzzuGgDjihfMLSeIx1R0uApsKj/x33ZU36CRQZ472e4KgPQt3xsIwaQ2TT
         e7ERZmD9Ofen23IhBohRVPT1R6WI8aaex/ldQ=
Subject: [PATCH] drm/radeon/radeon_fence.c: move a dereference below the
 NULL test
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 12:20:05 +1100
Message-ID: <1262136005.8733.26.camel@ICE-BOX>
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

diff --git drivers/gpu/drm/radeon/radeon_fence.c drivers/gpu/drm/radeon/radeon_fence.c
index 4cdd8b4..f3a8380 100644
--- drivers/gpu/drm/radeon/radeon_fence.c
+++ drivers/gpu/drm/radeon/radeon_fence.c
@@ -140,14 +140,14 @@ int radeon_fence_create(struct radeon_device *rdev, struct radeon_fence **fence)
 
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


