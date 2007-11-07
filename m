Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbXKGVtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbXKGVtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 16:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbXKGVtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 16:49:11 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:46641 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbXKGVtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 16:49:10 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Anthony Liguori <aliguori@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org
Subject: [PATCH] Fix used_idx wrap-around in virtio
Date: Wed,  7 Nov 2007 15:49:24 -0600
Message-Id: <11944721642196-git-send-email-aliguori@us.ibm.com>
X-Mailer: git-send-email 1.5.2.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The more_used() function compares the vq->vring.used->idx with last_used_idx.
Since vq->vring.used->idx is a 16-bit integer, and last_used_idx is an
unsigned int, this results in unpredictable behavior when vq->vring.used->idx
wraps around.

This patch corrects this by changing last_used_idx to the correct type.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 0e4baca..0e1bf05 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -53,7 +53,7 @@ struct vring_virtqueue
 	unsigned int num_added;
 
 	/* Last used index we've seen. */
-	unsigned int last_used_idx;
+	u16 last_used_idx;
 
 	/* How to notify other side. FIXME: commonalize hcalls! */
 	void (*notify)(struct virtqueue *vq);
