Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885Ab0AQOgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab0AQOgJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 09:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856Ab0AQOgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 09:36:07 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35440 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab0AQOgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 09:36:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=jq0KiEPEotwG6g0u/UNyeBY5JoFnkEPSYd8k5gvdddqEO5SgUKwIjkW6MEX0Q6PfnF
         yKq4HbReIlPrHHJhLjdqj80penAgO6tVRYFXERIwHyEEHzrD2TyUDhUJ1RREeYyaeUWS
         S+dEeO+ycmBpRGur39KggDyQ6ZGLa1lGesuAA=
Message-ID: <4B53216E.6010802@gmail.com>
Date: Sun, 17 Jan 2010 15:40:46 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] drm: Fix setting of fb_changed in drm_crtc_helper_set_config()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only set fb_changed if bits_per_pixel or depth changed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index 7d0f00a..89197c1 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -840,8 +840,6 @@ int drm_crtc_helper_set_config(struct drm_mode_set *set)
 			 set->crtc->fb->bits_per_pixel) ||
 			 set->fb->depth != set->crtc->fb->depth)
 			fb_changed = true;
-		else
-			fb_changed = true;
 	}
 
 	if (set->x != set->crtc->x || set->y != set->crtc->y)
