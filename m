Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbZLXNVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbZLXNVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 08:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbZLXNVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 08:21:30 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:51715 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZLXNV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 08:21:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=lrxmoX5dglVHP+psdHR/VJuDXjkboXw/xf7dfcMsTxXUC/yhj+TItT/cxOY93Fc8yR
         sHgPLc/Ug8IxAN7aNXj2qZkx5YKcxj1B0aeS/5jG9bO8PYvVYoT5IKPhV6GCAbywJsKE
         +IB3HgX9jWfRx/98Cl1saE3OebntXd10B3oHE=
Subject: drivers/gpu/drm/radeon/r100.c: check for invalid family
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Dec 2009 00:21:36 +1100
Message-ID: <1261660896.3546.43.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is an invalid family the fw_name is NULL and causes an
NULL pointer dereference.
This just adds a check for something unexpected.

Coverity CID: 13251

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
diff --git a/drivers/gpu/drm/radeon/r100.c
b/drivers/gpu/drm/radeon/r100.c
index 84e5df7..7d5de31 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -584,6 +584,8 @@ static int r100_cp_init_microcode(struct
radeon_device *rdev)
 		   (rdev->family == CHIP_RV570)) {
 		DRM_INFO("Loading R500 Microcode\n");
 		fw_name = FIRMWARE_R520;
+	} else {
+		return -EINVAL;
 	}
 
 	err = request_firmware(&rdev->me_fw, fw_name, &pdev->dev);


