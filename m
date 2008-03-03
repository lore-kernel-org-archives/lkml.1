Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbYCCBjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbYCCBjn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 20:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757066AbYCCBiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 20:38:04 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:43137 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648AbYCCBiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 20:38:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HzNqCnI7e7pM3p2ZzMsyFIwEg3DMs4lqV8NXuO2yi7SiW/QxKDNlywUW4LpgKFS/Z5ycPDP25cGfA8acN7IIT2WBfXz9AEqsoBFNSYrlErp3iXXwENfNrfWPI1EPn79tlaI5phCuTQ7YEWLsBL79+5HfP66l5RvkVUVUlEk4prI=
Subject: [RFC PATCH 3/5] crypto: replace remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 02 Mar 2008 17:37:57 -0800
Message-Id: <1204508277.3266.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION_ is gcc specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 crypto/async_tx/async_memcpy.c |    6 +++---
 crypto/async_tx/async_memset.c |    6 +++---
 crypto/async_tx/async_tx.c     |    6 +++---
 crypto/async_tx/async_xor.c    |   12 ++++++------
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 0f62822..84caa4e 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -66,11 +66,11 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 	}
 
 	if (tx) {
-		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
+		pr_debug("%s: (async) len: %zu\n", __func__, len);
 		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
 	} else {
 		void *dest_buf, *src_buf;
-		pr_debug("%s: (sync) len: %zu\n", __FUNCTION__, len);
+		pr_debug("%s: (sync) len: %zu\n", __func__, len);
 
 		/* wait for any prerequisite operations */
 		if (depend_tx) {
@@ -80,7 +80,7 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 			BUG_ON(depend_tx->ack);
 			if (dma_wait_for_async_tx(depend_tx) == DMA_ERROR)
 				panic("%s: DMA_ERROR waiting for depend_tx\n",
-					__FUNCTION__);
+					__func__);
 		}
 
 		dest_buf = kmap_atomic(dest, KM_USER0) + dest_offset;
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index 09c0e83..f5ff390 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -63,11 +63,11 @@ async_memset(struct page *dest, int val, unsigned int offset,
 	}
 
 	if (tx) {
-		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
+		pr_debug("%s: (async) len: %zu\n", __func__, len);
 		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
 	} else { /* run the memset synchronously */
 		void *dest_buf;
-		pr_debug("%s: (sync) len: %zu\n", __FUNCTION__, len);
+		pr_debug("%s: (sync) len: %zu\n", __func__, len);
 
 		dest_buf = (void *) (((char *) page_address(dest)) + offset);
 
@@ -79,7 +79,7 @@ async_memset(struct page *dest, int val, unsigned int offset,
 			BUG_ON(depend_tx->ack);
 			if (dma_wait_for_async_tx(depend_tx) == DMA_ERROR)
 				panic("%s: DMA_ERROR waiting for depend_tx\n",
-					__FUNCTION__);
+					__func__);
 		}
 
 		memset(dest_buf, val, len);
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 5628821..2be3bae 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -472,11 +472,11 @@ async_trigger_callback(enum async_tx_flags flags,
 		tx = NULL;
 
 	if (tx) {
-		pr_debug("%s: (async)\n", __FUNCTION__);
+		pr_debug("%s: (async)\n", __func__);
 
 		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
 	} else {
-		pr_debug("%s: (sync)\n", __FUNCTION__);
+		pr_debug("%s: (sync)\n", __func__);
 
 		/* wait for any prerequisite operations */
 		if (depend_tx) {
@@ -486,7 +486,7 @@ async_trigger_callback(enum async_tx_flags flags,
 			BUG_ON(depend_tx->ack);
 			if (dma_wait_for_async_tx(depend_tx) == DMA_ERROR)
 				panic("%s: DMA_ERROR waiting for depend_tx\n",
-					__FUNCTION__);
+					__func__);
 		}
 
 		async_tx_sync_epilog(flags, depend_tx, cb_fn, cb_param);
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 2259a4f..7a9db35 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -47,7 +47,7 @@ do_async_xor(struct dma_device *device,
 	int i;
 	unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
 
-	pr_debug("%s: len: %zu\n", __FUNCTION__, len);
+	pr_debug("%s: len: %zu\n", __func__, len);
 
 	dma_dest = dma_map_page(device->dev, dest, offset, len,
 				DMA_FROM_DEVICE);
@@ -86,7 +86,7 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
 	void *_dest;
 	int i;
 
-	pr_debug("%s: len: %zu\n", __FUNCTION__, len);
+	pr_debug("%s: len: %zu\n", __func__, len);
 
 	/* reuse the 'src_list' array to convert to buffer pointers */
 	for (i = 0; i < src_cnt; i++)
@@ -196,7 +196,7 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 					DMA_ERROR)
 					panic("%s: DMA_ERROR waiting for "
 						"depend_tx\n",
-						__FUNCTION__);
+						__func__);
 			}
 
 			do_sync_xor(dest, &src_list[src_off], offset,
@@ -276,7 +276,7 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 		unsigned long dma_prep_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
 		int i;
 
-		pr_debug("%s: (async) len: %zu\n", __FUNCTION__, len);
+		pr_debug("%s: (async) len: %zu\n", __func__, len);
 
 		for (i = 0; i < src_cnt; i++)
 			dma_src[i] = dma_map_page(device->dev, src_list[i],
@@ -299,7 +299,7 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 	} else {
 		unsigned long xor_flags = flags;
 
-		pr_debug("%s: (sync) len: %zu\n", __FUNCTION__, len);
+		pr_debug("%s: (sync) len: %zu\n", __func__, len);
 
 		xor_flags |= ASYNC_TX_XOR_DROP_DST;
 		xor_flags &= ~ASYNC_TX_ACK;
@@ -310,7 +310,7 @@ async_xor_zero_sum(struct page *dest, struct page **src_list,
 		if (tx) {
 			if (dma_wait_for_async_tx(tx) == DMA_ERROR)
 				panic("%s: DMA_ERROR waiting for tx\n",
-					__FUNCTION__);
+					__func__);
 			async_tx_ack(tx);
 		}
 
-- 
1.5.4.3.409.g8811


