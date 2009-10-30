Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbZJ3Nyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbZJ3Nyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 09:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbZJ3Nyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 09:54:43 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:51441 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbZJ3Nyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 09:54:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CeqEQpw1vIBkS3h4MuFz/hgc5Mj5YD/1Hw92jdg0tIW/S8V0gnk8Yaw4YYNKpGoqAa
         nIpUi6MnL5INOvqZmqdLVF9jIx6Nk6ikHkmiuKNbZbDCq9OcTsJOXPqNY9oqa+8oRaZn
         dAWRV6ifjSw2ORMJceT5TlCKsAZ/0vKP7XvSo=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, otus-devel@venema.h4ckr.net, Luis.Rodriguez@atheros.com,
       Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH] staging/otus: fix checkpatch warnings on wrap_buf
Date: Fri, 30 Oct 2009 09:54:24 -0400
Message-Id: <1256910864-6192-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.5.1.61.ge79999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bunch of warnings like "foo* bar" which should be "foo *bar".

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/staging/otus/wrap_buf.c |   33 ++++++++++++---------------------
 1 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/otus/wrap_buf.c b/drivers/staging/otus/wrap_buf.c
index a0f677a..6b11193 100644
--- a/drivers/staging/otus/wrap_buf.c
+++ b/drivers/staging/otus/wrap_buf.c
@@ -27,57 +27,49 @@
 #include "oal_dt.h"
 #include "usbdrv.h"
 
-
 #include <linux/netlink.h>
 
 #include <net/iw_handler.h>
 
-
 /* Called to allocate buffer, must return a continue buffer space */
-zbuf_t* zfwBufAllocate(zdev_t* dev, u16_t len)
+zbuf_t *zfwBufAllocate(zdev_t *dev, u16_t len)
 {
-    zbuf_t* buf;
+    zbuf_t *buf;
 
-    /* Allocate SKB for packet*/
+    /* Allocate SKB for packet */
     buf = dev_alloc_skb(len);
 
     return buf;
 }
 
-
 /* Called to free buffer, replace below 3 functions */
-void zfwBufFree(zdev_t* dev, zbuf_t* buf, u16_t status)
+void zfwBufFree(zdev_t *dev, zbuf_t *buf, u16_t status)
 {
     dev_kfree_skb_any(buf);
 }
 
 /* Called to adjust buffer size and head pointer */
-u16_t zfwBufRemoveHead(zdev_t* dev, zbuf_t* buf, u16_t size)
+u16_t zfwBufRemoveHead(zdev_t *dev, zbuf_t *buf, u16_t size)
 {
-    //zm_assert(buf->len > size);
+    /* zm_assert(buf->len > size); */
 
     buf->data += size;
     buf->len -= size;
     return 0;
 }
 
-
-
-
 /* return tail if head==NULL, called to chain multiple buffer together */
 /* Used to chain Rx buffer to form a frame. if the prepared Rx buffer  */
-/* is greater than an ethernet frame(1518+32 byte), then this function    */
+/* is greater than an ethernet frame(1518+32 byte), then this function */
 /* will only be called with head=NULL.                                 */
-u16_t zfwBufChain(zdev_t* dev, zbuf_t** head, zbuf_t* tail)
+u16_t zfwBufChain(zdev_t *dev, zbuf_t **head, zbuf_t *tail)
 {
-
     *head = tail;
     return 0;
 }
 
-
 /* Called when doing infra-bss forwarding */
-u16_t zfwBufCopy(zdev_t* dev, zbuf_t* dst, zbuf_t* src)
+u16_t zfwBufCopy(zdev_t *dev, zbuf_t *dst, zbuf_t *src)
 {
     memcpy(dst->data, src->data, src->len);
     dst->tail = dst->data;
@@ -85,9 +77,8 @@ u16_t zfwBufCopy(zdev_t* dev, zbuf_t* dst, zbuf_t* src)
     return 0;
 }
 
-
 /* Called to adjust buffer size and tail pointer */
-u16_t zfwBufSetSize(zdev_t* dev, zbuf_t* buf, u16_t size)
+u16_t zfwBufSetSize(zdev_t *dev, zbuf_t *buf, u16_t size)
 {
 #ifdef NET_SKBUFF_DATA_USES_OFFSET
     buf->tail = 0;
@@ -101,11 +92,11 @@ u16_t zfwBufSetSize(zdev_t* dev, zbuf_t* buf, u16_t size)
     return 0;
 }
 
-u16_t zfwBufGetSize(zdev_t* dev, zbuf_t* buf)
+u16_t zfwBufGetSize(zdev_t *dev, zbuf_t *buf)
 {
     return buf->len;
 }
 
-void zfwCopyBufContext(zdev_t* dev, zbuf_t* source, zbuf_t* dst)
+void zfwCopyBufContext(zdev_t *dev, zbuf_t *source, zbuf_t *dst)
 {
 }
-- 
1.6.5.1.61.ge79999

