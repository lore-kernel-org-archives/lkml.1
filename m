Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbZL3BZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbZL3BZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZL3BZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:25:52 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:47061 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZL3BZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:25:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=AL3LKJeB/2RvYZ44aJA3RpMSxkx4tcy57yMT8jl6XsKvTJubMltKC541202LD93DbN
         gtVqXIlvs1gaBg74Be5zUfHoUKy9Vuo1sAK3UI8PoR7euwqGwXbyukmZpuxbLKVor+0Y
         N08FKWxWC1G7cZx0F57QUKmAccpGpDp8sC1rk=
Subject: [PATCH] drm/radeon/radeon_cp.c: fix resource leak on error
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 12:25:45 +1100
Message-ID: <1262136345.8733.36.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If drm_addmap() fails master_priv is leaked.


Coverity CID: 13195

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>

diff --git drivers/gpu/drm/radeon/radeon_cp.c drivers/gpu/drm/radeon/radeon_cp.c
index 0b2f9c2..06123ba 100644
--- drivers/gpu/drm/radeon/radeon_cp.c
+++ drivers/gpu/drm/radeon/radeon_cp.c
@@ -2145,6 +2145,7 @@ int radeon_master_create(struct drm_device *dev, struct drm_master *master)
 			 &master_priv->sarea);
 	if (ret) {
 		DRM_ERROR("SAREA setup failed\n");
+		kfree(master_priv);
 		return ret;
 	}
 	master_priv->sarea_priv = master_priv->sarea->handle + sizeof(struct drm_sarea);


