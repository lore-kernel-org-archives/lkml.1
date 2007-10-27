Return-Path: <linux-kernel-owner+w=401wt.eu-S1761009AbXJ0BG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761009AbXJ0BG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 21:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbXJ0BGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 21:06:21 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33033 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752189AbXJ0BGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 21:06:20 -0400
Date: Sat, 27 Oct 2007 03:06:41 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] move more stuff into compiler-gcc.h
Message-ID: <20071027010641.GM30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stuff that is unconditional in both compiler-gcc3.h and compiler-gcc4.h 
belongs into compiler-gcc.h.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/compiler-gcc.h  |    8 ++++++++
 include/linux/compiler-gcc3.h |    8 --------
 include/linux/compiler-gcc4.h |    7 -------
 3 files changed, 8 insertions(+), 15 deletions(-)

commit 13893bca73ac361f0c1c937f83b30ed9c2f8f64a
Author: Adrian Bunk <bunk@kernel.org>
Date:   Fri Oct 26 03:50:51 2007 +0200

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index fe23792..d224fc2 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -31,6 +31,7 @@
 #define inline		inline		__attribute__((always_inline))
 #define __inline__	__inline__	__attribute__((always_inline))
 #define __inline	__inline	__attribute__((always_inline))
+#define __always_inline	inline		__attribute__((always_inline))
 #define __deprecated			__attribute__((deprecated))
 #define __packed			__attribute__((packed))
 #define __weak				__attribute__((weak))
@@ -53,3 +54,10 @@
 #define  noinline			__attribute__((noinline))
 #define __attribute_const__		__attribute__((__const__))
 #define __maybe_unused			__attribute__((unused))
+
+
+/*
+ * A trick to suppress uninitialized variable warning without generating any
+ * code
+ */
+#define uninitialized_var(x) x = x
diff --git a/include/linux/compiler-gcc3.h b/include/linux/compiler-gcc3.h
index 2d8c0f4..812bb89 100644
--- a/include/linux/compiler-gcc3.h
+++ b/include/linux/compiler-gcc3.h
@@ -16,11 +16,3 @@
 #if __GNUC_MINOR__ >= 4
 #define __must_check		__attribute__((warn_unused_result))
 #endif
-
-/*
- * A trick to suppress uninitialized variable warning without generating any
- * code
- */
-#define uninitialized_var(x) x = x
-
-#define __always_inline		inline __attribute__((always_inline))
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index ee7ca5d..4e01891 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -18,13 +18,6 @@
 #define __attribute_used__	__used			/* deprecated */
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
-#define __always_inline		inline __attribute__((always_inline))
-
-/*
- * A trick to suppress uninitialized variable warning without generating any
- * code
- */
-#define uninitialized_var(x) x = x
 
 #if !(__GNUC__ == 4 && __GNUC_MINOR__ < 3)
 /* Mark functions as cold. gcc will assume any path leading to a call



















