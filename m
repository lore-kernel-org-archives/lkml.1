Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbXKGCwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbXKGCwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 21:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbXKGCwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 21:52:24 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:34334 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbXKGCwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 21:52:23 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Anthony Liguori <aliguori@us.ibm.com>,
       Rusty Russell <rusty@rusycorp.com.au>, virtualization@lists.osdl.org
Subject: [PATCH][VIRTIO] Fix vring_init() ring computations
Date: Tue,  6 Nov 2007 20:52:29 -0600
Message-Id: <11944039492411-git-send-email-aliguori@us.ibm.com>
X-Mailer: git-send-email 1.5.2.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a typo in vring_init().  This happens to work today in lguest
because the sizeof(struct vring_desc) is 16 and struct vring contains 3
pointers and an unsigned int so on 32-bit
sizeof(struct vring_desc) == sizeof(struct vring).  However, this is no longer
true on 64-bit where the bug is exposed.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>

diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index ac69e7b..5b88d21 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -92,8 +92,8 @@ static inline void vring_init(struct vring *vr, unsigned int num, void *p)
 {
 	vr->num = num;
 	vr->desc = p;
-	vr->avail = p + num*sizeof(struct vring);
-	vr->used = p + (num+1)*(sizeof(struct vring) + sizeof(__u16));
+	vr->avail = p + num*sizeof(struct vring_desc);
+	vr->used = p + (num+1)*(sizeof(struct vring_desc) + sizeof(__u16));
 }
 
 static inline unsigned vring_size(unsigned int num)
