Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZAVPnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZAVPnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 10:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbZAVPnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 10:43:01 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:44016 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbZAVPnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 10:43:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=DyO5iGdiJzU8YjiJaGC3jkOxVYP7PuSSMRqgdxpZrrjToQ/yWtosDAf5cOlQnsBmRz
         dIs0t6WIh91+ihY8Ned8lFVqA7oJF9qLv3ELKOlMb5e0ynJM2MkBfDtV+kC0urdPu80q
         cLyGRX4KmIcQjwWpLIbS9EJETWiYb45jyjYGE=
Message-ID: <49789401.8080108@gmail.com>
Date: Thu, 22 Jan 2009 16:42:57 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: rusty@rustcorp.com.au, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] virtio: fix BAD_RING, START_US and END_USE macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix BAD_RING, START_US and END_USE macros

When these macros aren't called with a variable named vq as first
argument, this would result in a build failure.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 5777196..12273bf 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -23,15 +23,15 @@
 
 #ifdef DEBUG
 /* For development, we want to crash whenever the ring is screwed. */
-#define BAD_RING(vq, fmt...)			\
-	do { dev_err(&vq->vq.vdev->dev, fmt); BUG(); } while(0)
-#define START_USE(vq) \
-	do { if ((vq)->in_use) panic("in_use = %i\n", (vq)->in_use); (vq)->in_use = __LINE__; mb(); } while(0)
-#define END_USE(vq) \
-	do { BUG_ON(!(vq)->in_use); (vq)->in_use = 0; mb(); } while(0)
+#define BAD_RING(_vq, fmt...)			\
+	do { dev_err(&_vq->vq.vdev->dev, fmt); BUG(); } while(0)
+#define START_USE(_vq) \
+	do { if ((_vq)->in_use) panic("in_use = %i\n", (_vq)->in_use); (_vq)->in_use = __LINE__; mb(); } while(0)
+#define END_USE(_vq) \
+	do { BUG_ON(!(_vq)->in_use); (_vq)->in_use = 0; mb(); } while(0)
 #else
-#define BAD_RING(vq, fmt...)			\
-	do { dev_err(&vq->vq.vdev->dev, fmt); (vq)->broken = true; } while(0)
+#define BAD_RING(_vq, fmt...)			\
+	do { dev_err(&_vq->vq.vdev->dev, fmt); (_vq)->broken = true; } while(0)
 #define START_USE(vq)
 #define END_USE(vq)
 #endif
