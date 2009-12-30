Return-Path: <linux-kernel-owner+w=401wt.eu-S1752090AbZL3BYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbZL3BYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbZL3BYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:24:04 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:64599 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbZL3BYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:24:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=vy+4XAe6RY7WqW496IGTjz2SHo/yR23g9czzz1TjLTSsYjeMcBFuOsrr1TcaDP7Fe0
         T104smCYA5ocKsFLgWMZbikJ8suYVeEIHQBChuphOqP3JqCfu2Ug/UuPxv5oY047J9up
         Ov1/KnzaujwGBXUeQ8UQ3TKoRu5yIW0owD2is=
Subject: [PATCH] drm/radeon/radeon_cp.c: check for invalid radeon family
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 12:23:55 +1100
Message-ID: <1262136235.8733.33.camel@ICE-BOX>
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

diff --git drivers/gpu/drm/radeon/radeon_cp.c drivers/gpu/drm/radeon/radeon_cp.c
index 0b2f9c2..1e66337 100644
--- drivers/gpu/drm/radeon/radeon_cp.c
+++ drivers/gpu/drm/radeon/radeon_cp.c
@@ -531,6 +531,8 @@ static int radeon_cp_init_microcode(drm_radeon_private_t *dev_priv)
 		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RV570)) {
 		DRM_INFO("Loading R500 Microcode\n");
 		fw_name = FIRMWARE_R520;
+	} else {
+		return -EINVAL;
 	}
 
 	err = request_firmware(&dev_priv->me_fw, fw_name, &pdev->dev);


