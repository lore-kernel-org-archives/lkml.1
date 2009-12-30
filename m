Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbZL3BY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbZL3BY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbZL3BY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:24:58 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:60128 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZL3BY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=e7cjcW0K1mvJsok53bwB1TjOzQzM+Kfft+1XBdGy+jTUQ2uYrHL307g/0Fl+h0uunL
         aqqZeC4dVvW68MBnWKN71jtQIXimUosbj+DmoH5fIiXjIXKH07gNSVA1JU/q+j5X6YiN
         GFSPeycyTM7RjiTpwkNxB3StmUY3gjaQ92fjA=
Subject: [PATCH] drm/radeon/r100.c: check for invalid family
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 12:24:51 +1100
Message-ID: <1262136291.8733.35.camel@ICE-BOX>
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

diff --git drivers/gpu/drm/radeon/r100.c drivers/gpu/drm/radeon/r100.c
index 7172746..e4b9770 100644
--- drivers/gpu/drm/radeon/r100.c
+++ drivers/gpu/drm/radeon/r100.c
@@ -584,6 +584,8 @@ static int r100_cp_init_microcode(struct radeon_device *rdev)
 		   (rdev->family == CHIP_RV570)) {
 		DRM_INFO("Loading R500 Microcode\n");
 		fw_name = FIRMWARE_R520;
+	} else {
+		return -EINVAL;
 	}
 
 	err = request_firmware(&rdev->me_fw, fw_name, &pdev->dev);


