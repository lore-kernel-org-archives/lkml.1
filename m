Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbZISVkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbZISVkD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbZISVjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:39:55 -0400
Received: from kroah.org ([198.145.64.141]:50963 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbZISVjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:39:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/79] kfifo: Use "const" definitions
Date: Sat, 19 Sep 2009 14:36:27 -0700
Message-Id: <1253396244-7885-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Currently kfifo cannot be used by parts of the kernel that use "const"
properly as kfifo itself does not use const for passed data blocks which
are indeed const.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
 
-- 
1.6.4.2

