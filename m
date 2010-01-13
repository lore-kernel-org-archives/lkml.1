Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109Ab0AMFkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab0AMFkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 00:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086Ab0AMFj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 00:39:58 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:38412 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab0AMFj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 00:39:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=fUQ4ZfO2SoreKwVgBgELkx1P4uOpKLmZVq5LY3LH8MdZF8UX5F+D69ma3HnhEnE/ON
         kYGtVAyw9J+y58tjVyqagHSt1Hse9ir8nJyljQAEnLrXRlDhWM9AKqOnRTRsDb5uSlH4
         0SiBTIC8Q19ZjhOai13lRWw2EP+l8QVn8ezDk=
Date: Wed, 13 Jan 2010 13:38:59 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] change drm set mode messages as DRM_DEBUG
Message-ID: <20100113053859.GA3090@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following drm info repeat 207 times during one hour, it's quite annoying
[ 1266.286747] [drm] TV-19: set mode NTSC 480i 0

Change from DRM_INFO to DRM_DEBUG


Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 drivers/gpu/drm/drm_crtc_helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/drivers/gpu/drm/drm_crtc_helper.c	2010-01-12 13:34:36.000000000 +0800
+++ linux-2.6/drivers/gpu/drm/drm_crtc_helper.c	2010-01-13 10:16:44.000000000 +0800
@@ -702,7 +702,7 @@ bool drm_crtc_helper_set_mode(struct drm
 		if (encoder->crtc != crtc)
 			continue;
 
-		DRM_INFO("%s: set mode %s %x\n", drm_get_encoder_name(encoder),
+		DRM_DEBUG("%s: set mode %s %x\n", drm_get_encoder_name(encoder),
 			 mode->name, mode->base.id);
 		encoder_funcs = encoder->helper_private;
 		encoder_funcs->mode_set(encoder, mode, adjusted_mode);
