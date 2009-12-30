Return-Path: <linux-kernel-owner+w=401wt.eu-S1751991AbZL3BSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbZL3BSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbZL3BSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:18:36 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:56976 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbZL3BSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:18:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=pzbeAhdmZ1Sip3m51yukRBsWJcT0tvsPI0kl8aFkI5txDEd8TjGN0Jc9veUxP4luRb
         wcla999p4VY1PTy0iBO24gK3kRw8mYXCzi6UsuOBvJsL0HPLjeibK/5ppzFTnYawVCxw
         chOPC0j4MNZfYdzzg5T/R98kRY9Nv6cUbA0N8=
Subject: [PATCH] drm/radeon/radeon_device.c: move a dereference below a
 NULL test
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 12:18:30 +1100
Message-ID: <1262135910.8733.23.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a NULL value is possible, the dereference should only occur after the
NULL test.

Coverity CID: 13335

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>

diff --git drivers/gpu/drm/radeon/radeon_device.c drivers/gpu/drm/radeon/radeon_device.c
index 7c68480..0c51f8e 100644
--- drivers/gpu/drm/radeon/radeon_device.c
+++ drivers/gpu/drm/radeon/radeon_device.c
@@ -733,16 +733,18 @@ void radeon_device_fini(struct radeon_device *rdev)
  */
 int radeon_suspend_kms(struct drm_device *dev, pm_message_t state)
 {
-	struct radeon_device *rdev = dev->dev_private;
+	struct radeon_device *rdev;
 	struct drm_crtc *crtc;
 	int r;
 
-	if (dev == NULL || rdev == NULL) {
+	if (dev == NULL || dev->dev_private == NULL) {
 		return -ENODEV;
 	}
 	if (state.event == PM_EVENT_PRETHAW) {
 		return 0;
 	}
+	rdev = dev->dev_private;
+
 	/* unpin the front buffers */
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
 		struct radeon_framebuffer *rfb = to_radeon_framebuffer(crtc->fb);


