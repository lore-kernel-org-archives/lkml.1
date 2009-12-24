Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbZLXNZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbZLXNZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 08:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZLXNZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 08:25:50 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:41598 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZLXNZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 08:25:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ma9rEOgbE6KpeAxxSbkoAeq0+Yt+gg0ZlgwDf47hjtAEhWIh1e4HyI0R4gKlckYXVt
         0MIW5f+mqSmaFztfYSyaWIRvnBPNopHFIaDBZ0pmlVr6xoLsdChLMfpSFom8tRtYG4P0
         cEFCabhj4c5XqYjHOeKJvySsZedkEm7qd/m+Q=
Subject: drivers/gpu/drm/radeon/radeon_cp.c: fix resource leak on error
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Dec 2009 00:25:54 +1100
Message-ID: <1261661154.3546.47.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If drm_addmap() fails master_priv is leaked.


Coverity CID: 13195

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
diff --git a/drivers/gpu/drm/radeon/radeon_cp.c
b/drivers/gpu/drm/radeon/radeon_cp.c
index 0b2f9c2..06123ba 100644
--- a/drivers/gpu/drm/radeon/radeon_cp.c
+++ b/drivers/gpu/drm/radeon/radeon_cp.c
@@ -2145,6 +2145,7 @@ int radeon_master_create(struct drm_device *dev,
struct drm_master *master)
 			 &master_priv->sarea);
 	if (ret) {
 		DRM_ERROR("SAREA setup failed\n");
+		kfree(master_priv);
 		return ret;
 	}
 	master_priv->sarea_priv = master_priv->sarea->handle + sizeof(struct
drm_sarea);


