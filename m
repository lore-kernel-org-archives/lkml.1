Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbZLXNSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbZLXNSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 08:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbZLXNSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 08:18:11 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:50385 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbZLXNSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 08:18:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=hMj4phvG0tY71PtnJbtv1N6RGlSzaAoT5VLnhzsK9h+SKBAvgkdjCUJ3Rvc+Ph3hed
         nSLWvi/YcU29IT7X2J2rSOmHCbTDXmlzPWKYXwaGvDNbPiQHNrXyr0FlKd/CtQEK+sZi
         6pqVorkWmIZdtmfAeFF33Z+U/gwBCN5ryplyI=
Subject: drivers/gpu/drm/radeon/radeon_cp.c: check for invalid radeon family
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Dec 2009 00:18:16 +1100
Message-ID: <1261660696.3546.40.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is an invalid radeon family the fw_name is NULL and causes an
NULL pointer dereference.
This just adds a check for something unexpected.

Coverity CID: 13252

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
diff --git a/drivers/gpu/drm/radeon/radeon_cp.c
b/drivers/gpu/drm/radeon/radeon_cp.c
index 0b2f9c2..1e66337 100644
--- a/drivers/gpu/drm/radeon/radeon_cp.c
+++ b/drivers/gpu/drm/radeon/radeon_cp.c
@@ -531,6 +531,8 @@ static int
radeon_cp_init_microcode(drm_radeon_private_t *dev_priv)
 		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RV570)) {
 		DRM_INFO("Loading R500 Microcode\n");
 		fw_name = FIRMWARE_R520;
+	} else {
+		return -EINVAL;
 	}
 
 	err = request_firmware(&dev_priv->me_fw, fw_name, &pdev->dev);


