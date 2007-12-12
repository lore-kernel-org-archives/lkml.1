Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbXLLVx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbXLLVx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbXLLVxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:53:46 -0500
Received: from ro-out-1112.google.com ([72.14.202.179]:34030 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbXLLVxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:53:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rgFs3J2/rsC7URdOrW94sRO/9m1uTxqGb6n/ia5pwMjgRsquL9DUp/50x8Zz7K3vB8FnsrYk2D+uwUFN6Zy2nqUZkHcwVciEG6VVWN6qfEHItUf1SbRThP6Vrg66VkScrD6Ga6af4o+M28MxkX8OLZbhF6n/3f/RD8S8RRaIzqE=
Subject: [PATCH] asm-generic: remove fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 13:53:42 -0800
Message-Id: <1197496422.21291.39.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-generic/iomap.h      |   32 ++++++++++++++++----------------
 include/asm-generic/mutex-dec.h  |    6 +++---
 include/asm-generic/mutex-xchg.h |    6 +++---
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index cde592f..67dc84c 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -25,17 +25,17 @@
  * in the low address range. Architectures for which this is not
  * true can't use this generic implementation.
  */
-extern unsigned int fastcall ioread8(void __iomem *);
-extern unsigned int fastcall ioread16(void __iomem *);
-extern unsigned int fastcall ioread16be(void __iomem *);
-extern unsigned int fastcall ioread32(void __iomem *);
-extern unsigned int fastcall ioread32be(void __iomem *);
+extern unsigned int ioread8(void __iomem *);
+extern unsigned int ioread16(void __iomem *);
+extern unsigned int ioread16be(void __iomem *);
+extern unsigned int ioread32(void __iomem *);
+extern unsigned int ioread32be(void __iomem *);
 
-extern void fastcall iowrite8(u8, void __iomem *);
-extern void fastcall iowrite16(u16, void __iomem *);
-extern void fastcall iowrite16be(u16, void __iomem *);
-extern void fastcall iowrite32(u32, void __iomem *);
-extern void fastcall iowrite32be(u32, void __iomem *);
+extern void iowrite8(u8, void __iomem *);
+extern void iowrite16(u16, void __iomem *);
+extern void iowrite16be(u16, void __iomem *);
+extern void iowrite32(u32, void __iomem *);
+extern void iowrite32be(u32, void __iomem *);
 
 /*
  * "string" versions of the above. Note that they
@@ -48,13 +48,13 @@ extern void fastcall iowrite32be(u32, void __iomem *);
  * memory across multiple ports, use "memcpy_toio()"
  * and friends.
  */
-extern void fastcall ioread8_rep(void __iomem *port, void *buf, unsigned long count);
-extern void fastcall ioread16_rep(void __iomem *port, void *buf, unsigned long count);
-extern void fastcall ioread32_rep(void __iomem *port, void *buf, unsigned long count);
+extern void ioread8_rep(void __iomem *port, void *buf, unsigned long count);
+extern void ioread16_rep(void __iomem *port, void *buf, unsigned long count);
+extern void ioread32_rep(void __iomem *port, void *buf, unsigned long count);
 
-extern void fastcall iowrite8_rep(void __iomem *port, const void *buf, unsigned long count);
-extern void fastcall iowrite16_rep(void __iomem *port, const void *buf, unsigned long count);
-extern void fastcall iowrite32_rep(void __iomem *port, const void *buf, unsigned long count);
+extern void iowrite8_rep(void __iomem *port, const void *buf, unsigned long count);
+extern void iowrite16_rep(void __iomem *port, const void *buf, unsigned long count);
+extern void iowrite32_rep(void __iomem *port, const void *buf, unsigned long count);
 
 /* Create a virtual mapping cookie for an IO port range */
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
diff --git a/include/asm-generic/mutex-dec.h b/include/asm-generic/mutex-dec.h
index 0134151..ed108be 100644
--- a/include/asm-generic/mutex-dec.h
+++ b/include/asm-generic/mutex-dec.h
@@ -18,7 +18,7 @@
  * 1 even when the "1" assertion wasn't true.
  */
 static inline void
-__mutex_fastpath_lock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_dec_return(count) < 0))
 		fail_fn(count);
@@ -37,7 +37,7 @@ __mutex_fastpath_lock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
  * or anything the slow path function returns.
  */
 static inline int
-__mutex_fastpath_lock_retval(atomic_t *count, fastcall int (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_dec_return(count) < 0))
 		return fail_fn(count);
@@ -61,7 +61,7 @@ __mutex_fastpath_lock_retval(atomic_t *count, fastcall int (*fail_fn)(atomic_t *
  * to return 0 otherwise.
  */
 static inline void
-__mutex_fastpath_unlock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
+__mutex_fastpath_unlock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	smp_mb();
 	if (unlikely(atomic_inc_return(count) <= 0))
diff --git a/include/asm-generic/mutex-xchg.h b/include/asm-generic/mutex-xchg.h
index 6a7e8c1..7b9cd2c 100644
--- a/include/asm-generic/mutex-xchg.h
+++ b/include/asm-generic/mutex-xchg.h
@@ -23,7 +23,7 @@
  * even when the "1" assertion wasn't true.
  */
 static inline void
-__mutex_fastpath_lock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_xchg(count, 0) != 1))
 		fail_fn(count);
@@ -42,7 +42,7 @@ __mutex_fastpath_lock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
  * or anything the slow path function returns
  */
 static inline int
-__mutex_fastpath_lock_retval(atomic_t *count, fastcall int (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_xchg(count, 0) != 1))
 		return fail_fn(count);
@@ -65,7 +65,7 @@ __mutex_fastpath_lock_retval(atomic_t *count, fastcall int (*fail_fn)(atomic_t *
  * to return 0 otherwise.
  */
 static inline void
-__mutex_fastpath_unlock(atomic_t *count, fastcall void (*fail_fn)(atomic_t *))
+__mutex_fastpath_unlock(atomic_t *count, void (*fail_fn)(atomic_t *))
 {
 	smp_mb();
 	if (unlikely(atomic_xchg(count, 1) != 0))
-- 
1.5.3.7.2212.gd092



