Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbZFYNge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbZFYNge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZFYNg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:36:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39373 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752683AbZFYNg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:36:26 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] kfifo: Use "const" definitions
To: linux-kernel@vger.kernel.org
Date: Thu, 25 Jun 2009 15:34:54 +0100
Message-ID: <20090625143444.4098.35534.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Currently kfifo cannot be used by parts of the kernel that use "const"
properly as kfifo itself does not use const for passed data blocks which
are indeed const.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 include/linux/kfifo.h |    4 ++--
 kernel/kfifo.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 29f62e1..ad6bdf5 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -38,7 +38,7 @@ extern struct kfifo *kfifo_alloc(unsigned int size, gfp_t gfp_mask,
 				 spinlock_t *lock);
 extern void kfifo_free(struct kfifo *fifo);
 extern unsigned int __kfifo_put(struct kfifo *fifo,
-				unsigned char *buffer, unsigned int len);
+				const unsigned char *buffer, unsigned int len);
 extern unsigned int __kfifo_get(struct kfifo *fifo,
 				unsigned char *buffer, unsigned int len);
 
@@ -77,7 +77,7 @@ static inline void kfifo_reset(struct kfifo *fifo)
  * bytes copied.
  */
 static inline unsigned int kfifo_put(struct kfifo *fifo,
-				     unsigned char *buffer, unsigned int len)
+				const unsigned char *buffer, unsigned int len)
 {
 	unsigned long flags;
 	unsigned int ret;
diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index 26539e3..3765ff3 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -117,7 +117,7 @@ EXPORT_SYMBOL(kfifo_free);
  * writer, you don't need extra locking to use these functions.
  */
 unsigned int __kfifo_put(struct kfifo *fifo,
-			 unsigned char *buffer, unsigned int len)
+			const unsigned char *buffer, unsigned int len)
 {
 	unsigned int l;
 

