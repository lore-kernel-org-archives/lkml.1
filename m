Return-Path: <linux-kernel-owner+w=401wt.eu-S1751938AbZL3BQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbZL3BQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbZL3BQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:16:43 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:37433 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbZL3BQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:16:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=wUCc2MmdRw5AuTpr9K5olfk/8T/7jWCL38MErrvPTNO+uT7mQvf0cHsIF5jkjFT/bB
         o46SvLy+yPPpMroGsQUStdXE8cBIjPKRP2AiTZHa7r0ZQIns1ZaW1osdZnWVi22yPI2s
         jT3u4Z7t2WsOwZH04Mhx78PyjBOhWCXtfvAPA=
Subject: [PATCH] gpu/drm/radeon/radeon_irq.c: move a dereference below a
 NULL test
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 12:16:35 +1100
Message-ID: <1262135795.8733.21.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a NULL value is possible, the dereference should only occur after the
NULL test. 


Coverity CID: 13338

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com> 

diff --git drivers/gpu/drm/radeon/radeon_irq.c drivers/gpu/drm/radeon/radeon_irq.c
index b79ecc4..2f349a3 100644
--- drivers/gpu/drm/radeon/radeon_irq.c
+++ drivers/gpu/drm/radeon/radeon_irq.c
@@ -289,16 +289,16 @@ int radeon_irq_emit(struct drm_device *dev, void *data, struct drm_file *file_pr
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


