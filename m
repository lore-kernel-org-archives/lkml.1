Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbZLXMsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbZLXMsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbZLXMsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:48:52 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:48425 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZLXMsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:48:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=t+VuiqKIvM+6ULq/Aa4NGoFTA/7ExtKTeizIQcmb8T7mssxK4gPMrEio0ohPgQRzfb
         hxyJea2vsjDUhYr7Q6+Q6vIzuhy6GHSccPgZiZyOPRt96ZXxXdCeGUbymUbM8/g+kbn/
         B0Pvwc3H1uUTEVkzX0UMEVpf9wVZTRSWKvk4g=
Subject: drivers/gpu/drm/radeon/radeon_device.c: move a dereference below a
 NULL test
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Dec 2009 23:48:58 +1100
Message-ID: <1261658938.3546.12.camel@ICE-BOX>
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
diff --git a/drivers/gpu/drm/radeon/radeon_device.c
b/drivers/gpu/drm/radeon/radeon_device.c
index 02bcdb1..c0104b0 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -663,16 +663,18 @@ void radeon_device_fini(struct radeon_device
*rdev)
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


