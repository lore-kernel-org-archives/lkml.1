Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbZLXNIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbZLXNIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 08:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbZLXNIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 08:08:39 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:51284 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZLXNIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 08:08:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=KHhwzxRQy7o6zWhPU6demAvJ1VrAOCTbVxo+vg3Kn0CwSXzik82/dBxadiTuWd4io+
         NqM7lJnhfQiMnCWAoMu67ymfc0REPRWkh+KT7BIi3FxusVwDD/zRROqOOU7HkTc/fTxO
         joOkWHYSJcB+QMJdVpIwrtfAprIff8jIaMsWU=
Subject: drivers/gpu/drm/radeon/radeon_connectors.c: add a NULL test before
 dereference
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Dec 2009 00:08:45 +1100
Message-ID: <1261660125.3546.31.camel@ICE-BOX>
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
diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c
b/drivers/gpu/drm/radeon/radeon_connectors.c
index 5eece18..3ba86fc 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -603,7 +603,7 @@ static enum drm_connector_status
radeon_vga_detect(struct drm_connector *connect
 				ret = connector_status_connected;
 		}
 	} else {
-		if (radeon_connector->dac_load_detect) {
+		if (radeon_connector->dac_load_detect && encoder) {
 			encoder_funcs = encoder->helper_private;
 			ret = encoder_funcs->detect(encoder, connector);
 		}


