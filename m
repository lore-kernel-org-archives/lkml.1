Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbZLXMo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbZLXMo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZLXMoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:44:25 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:37090 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbZLXMoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:44:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=F/o795ap3vNW1vwSwjIxXyAgfeSUQsS8d0Ouf/dwE6XZozVBGnzeAmDIkxe7fm0UDp
         uS81c9/WeWwJ4k10uWSKEWR8qavxgHAidcZ+aJE01R5WrxjsdmuY0wNjqw8UyqS+i5Wq
         q5LiMERZQds2Vu5O1w7eOg8ooQH8eNKbNBUy4=
Subject: drivers/gpu/drm/radeon: move a dereference below a NULL test
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Dec 2009 23:44:30 +1100
Message-ID: <1261658670.3546.7.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a NULL value is possible, the dereference should only occur after the
NULL test.

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
diff --git a/drivers/gpu/drm/radeon/radeon_irq.c
b/drivers/gpu/drm/radeon/radeon_irq.c
index b79ecc4..2f349a3 100644
--- a/drivers/gpu/drm/radeon/radeon_irq.c
+++ b/drivers/gpu/drm/radeon/radeon_irq.c
@@ -289,16 +289,16 @@ int radeon_irq_emit(struct drm_device *dev, void
*data, struct drm_file *file_pr
 	drm_radeon_irq_emit_t *emit = data;
 	int result;
 
-	if ((dev_priv->flags & RADEON_FAMILY_MASK) >= CHIP_R600)
-		return -EINVAL;
-
-	LOCK_TEST_WITH_RETURN(dev, file_priv);
-
 	if (!dev_priv) {
 		DRM_ERROR("called with no initialization\n");
 		return -EINVAL;
 	}
 
+	if ((dev_priv->flags & RADEON_FAMILY_MASK) >= CHIP_R600)
+		return -EINVAL;
+
+	LOCK_TEST_WITH_RETURN(dev, file_priv);
+
 	result = radeon_emit_irq(dev);
 
 	if (DRM_COPY_TO_USER(emit->irq_seq, &result, sizeof(int))) {


