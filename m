Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbZAVPzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbZAVPzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 10:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZAVPzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 10:55:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:43441 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZAVPzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 10:55:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=xU9GyRkT62t2KLSVLGThqS9tcN5OJC2s8Z37OvtLeSu3rUJ+7Zzi6n7GUUBck0MLCN
         aM9nf0ZKiYne/L1/7U/96ttLqXhQ8U1hB6gDPKVrYBCVXqNo/8k1szTiN5BHGJCF8x0a
         GYRByGX0fMtvFaGi+5WExFQ2MuUM8B2srp6iQ=
Message-ID: <497896D1.3090703@gmail.com>
Date: Thu, 22 Jan 2009 16:54:57 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: airlied@linux.ie
CC: dri-devel@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] drm: fix LOCK_TEST_WITH_RETURN macro
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix LOCK_TEST_WITH_RETURN macro:

When this macro isn't called with 'file_priv' this will result in a
build failure.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index afb7858..7437927 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -237,15 +237,15 @@ struct drm_device;
  * \param dev DRM device.
  * \param filp file pointer of the caller.
  */
-#define LOCK_TEST_WITH_RETURN( dev, file_priv )				\
-do {									\
-	if (!_DRM_LOCK_IS_HELD(file_priv->master->lock.hw_lock->lock) ||		\
-	    file_priv->master->lock.file_priv != file_priv)	{			\
+#define LOCK_TEST_WITH_RETURN( dev, _file_priv )				\
+do {										\
+	if (!_DRM_LOCK_IS_HELD(_file_priv->master->lock.hw_lock->lock) ||	\
+	    _file_priv->master->lock.file_priv != _file_priv)	{		\
 		DRM_ERROR( "%s called without lock held, held  %d owner %p %p\n",\
-			   __func__, _DRM_LOCK_IS_HELD(file_priv->master->lock.hw_lock->lock),\
-			   file_priv->master->lock.file_priv, file_priv);		\
-		return -EINVAL;						\
-	}								\
+			   __func__, _DRM_LOCK_IS_HELD(_file_priv->master->lock.hw_lock->lock),\
+			   _file_priv->master->lock.file_priv, _file_priv);	\
+		return -EINVAL;							\
+	}									\
 } while (0)
 
 /**
