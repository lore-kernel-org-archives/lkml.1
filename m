Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbZL3BXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbZL3BXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZL3BXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:23:04 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:35409 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZL3BXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:23:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RRJEvTLFlRN1ZOwQFT5dFdf+0nskqMgEWF92zAE7PE1fIPQrsaBDa6Z52s3JELp6FF
         jBicVHtSOJeyuYZaG9AlqXNUPHE2yjLSbwN4MQYm8Oq7gu8F5OUjphZIukkzx4s5J3ww
         oh/bX8DP1wdxld/RCuxBte2sRln38W6lq8ap8=
Subject: [PATCH] drm/radeon/radeon_connectors.c: add a NULL test before
 dereference
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 12:22:55 +1100
Message-ID: <1262136175.8733.31.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The encoder variable can be NULL in this function so I believe it should
be checked before dereference.

Coverity CID: 13253

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>

diff --git drivers/gpu/drm/radeon/radeon_connectors.c drivers/gpu/drm/radeon/radeon_connectors.c
index 2016156..b82ae61 100644
--- drivers/gpu/drm/radeon/radeon_connectors.c
+++ drivers/gpu/drm/radeon/radeon_connectors.c
@@ -615,7 +615,7 @@ static enum drm_connector_status radeon_vga_detect(struct drm_connector *connect
 				ret = connector_status_connected;
 		}
 	} else {
-		if (radeon_connector->dac_load_detect) {
+		if (radeon_connector->dac_load_detect && encoder) {
 			encoder_funcs = encoder->helper_private;
 			ret = encoder_funcs->detect(encoder, connector);
 		}


