Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbYKLMW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbYKLMW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYKLMWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:22:36 -0500
Received: from ozlabs.org ([203.10.76.45]:36458 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbYKLMWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:22:34 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 12 Nov 2008 06:22:31 -0600
Cc: Hollis Blanchard <hollisb@us.ibm.com>, aliguori@us.ibm.com,
       markmc@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 2/7] virtio: rename 'pagesize' arg to vring_init/vring_size
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122252.31397.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's really the alignment desired for consumer/producer separation;
historically this x86 pagesize, but with PowerPC it'll still be x86
pagesize.  And in theory lguest could choose a different value.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/virtio_ring.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -r c6761450d706 include/linux/virtio_ring.h
--- a/include/linux/virtio_ring.h	Wed Nov 12 21:47:57 2008 +1030
+++ b/include/linux/virtio_ring.h	Wed Nov 12 21:51:09 2008 +1030
@@ -83,7 +83,7 @@
  *	__u16 avail_idx;
  *	__u16 available[num];
  *
- *	// Padding to the next page boundary.
+ *	// Padding to the next align boundary.
  *	char pad[];
  *
  *	// A ring of used descriptor heads with free-running index.
@@ -93,19 +93,19 @@
  * };
  */
 static inline void vring_init(struct vring *vr, unsigned int num, void *p,
-			      unsigned long pagesize)
+			      unsigned long align)
 {
 	vr->num = num;
 	vr->desc = p;
 	vr->avail = p + num*sizeof(struct vring_desc);
-	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + pagesize-1)
-			    & ~(pagesize - 1));
+	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + align-1)
+			    & ~(align - 1));
 }
 
-static inline unsigned vring_size(unsigned int num, unsigned long pagesize)
+static inline unsigned vring_size(unsigned int num, unsigned long align)
 {
 	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (2 + num)
-		 + pagesize - 1) & ~(pagesize - 1))
+		 + align - 1) & ~(align - 1))
 		+ sizeof(__u16) * 2 + sizeof(struct vring_used_elem) * num;
 }
 


