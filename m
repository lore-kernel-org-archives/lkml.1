Return-Path: <linux-kernel-owner+w=401wt.eu-S932372Ab0AFRA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab0AFRA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932367Ab0AFRA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:00:57 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:60349 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab0AFRA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:00:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=e7h/zEfG5X6vQ4Vh5n1ppad7dhMWJC9dBNVqUBR0WtST8sqqrT+ZB0X9Qfkdy2dzgN
         gTtPPimtdJ0qVCHg5jiGk6CkOlG7eVgu083IHwgPBKh7Jca9TjK6AAzHxyp+a6mF5Bi2
         b8jsRff4jncS32dACDtHsV0JD4pTlU3DUeODk=
From: Johan Hovold <jhovold@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: James Simmons <jsimmons@infradead.org>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] drm/kms: fix fbdev blanking regression
Date: Wed,  6 Jan 2010 18:00:26 +0100
Message-Id: <1262797226-9593-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262797226-9593-1-git-send-email-jhovold@gmail.com>
References: <1262797226-9593-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 731b5a15a3b1474a41c2ca29b4c32b0f21bc852e (drm/kms: properly
handle fbdev blanking) breaks console blanking on my laptop (GM45
chipset). Instead of blanking the screen, it is dimmed and then the
backlight starts "glowing" in the lower edges of the screen. The glowing
then slowly spreads upwards. Does not look healthy at all...

This patch reverts to the old behaviour of going directly to
DPMS_STANDBY.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/gpu/drm/drm_fb_helper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 1b49fa0..9008583 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -389,7 +389,7 @@ int drm_fb_helper_blank(int blank, struct fb_info *info)
 		break;
 	/* Display: Off; HSync: On, VSync: On */
 	case FB_BLANK_NORMAL:
-		drm_fb_helper_off(info, DRM_MODE_DPMS_ON);
+		drm_fb_helper_off(info, DRM_MODE_DPMS_STANDBY);
 		break;
 	/* Display: Off; HSync: Off, VSync: On */
 	case FB_BLANK_HSYNC_SUSPEND:
-- 
1.6.6

