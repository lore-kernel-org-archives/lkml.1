Return-Path: <linux-kernel-owner+w=401wt.eu-S1761790AbZLPIMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761790AbZLPIMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761754AbZLPILr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:11:47 -0500
Received: from mail.perches.com ([173.55.12.10]:1205 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761750AbZLPIJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:09:16 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] kernel.h: Group math and limits functions, indent function args
Date: Wed, 16 Dec 2009 00:09:07 -0800
Message-Id: <7a986a800663694158db56205375768cc1e473af.1260949674.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1260949674.git.joe@perches.com>
References: <cover.1260949674.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a bit more standardized statement expression format

Signed-off-by:; Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |   72 +++++++++++++++++++++++++++++------------------
 1 files changed, 44 insertions(+), 28 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 1764d2d..97c80c7 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -115,12 +115,6 @@ void __might_sleep(char *file, int line, int preempt_offset);
 
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
 
-#define abs(x)				\
-({					\
-	long __x = (x);			\
-	(__x < 0) ? -__x : __x;		\
-})
-
 #ifdef CONFIG_PROVE_LOCKING
 void might_fault(void);
 #else
@@ -240,21 +234,36 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 }
 
 /*
+ * stdlib - limits and maths
+ */
+#define abs(x)					\
+({						\
+	long __x = (x);				\
+	(__x < 0) ? -__x : __x;			\
+})
+
+unsigned long int_sqrt(unsigned long);
+
+/*
  * min()/max()/clamp() macros that also do
  * strict type-checking.. See the
  * "unnecessary" pointer comparison.
  */
-#define min(x, y) ({				\
+#define min(x, y)				\
+({						\
 	typeof(x) _min1 = (x);			\
 	typeof(y) _min2 = (y);			\
 	(void) (&_min1 == &_min2);		\
-	_min1 < _min2 ? _min1 : _min2; })
+	_min1 < _min2 ? _min1 : _min2;		\
+})
 
-#define max(x, y) ({				\
+#define max(x, y)				\
+({						\
 	typeof(x) _max1 = (x);			\
 	typeof(y) _max2 = (y);			\
 	(void) (&_max1 == &_max2);		\
-	_max1 > _max2 ? _max1 : _max2; })
+	_max1 > _max2 ? _max1 : _max2;		\
+})
 
 /**
  * clamp - return a value clamped to a given range with strict typechecking
@@ -265,14 +274,16 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
  * This macro does strict typechecking of min/max to make sure they are of the
  * same type as val.  See the unnecessary pointer comparisons.
  */
-#define clamp(val, min, max) ({			\
+#define clamp(val, min, max)			\
+({						\
 	typeof(val) __val = (val);		\
 	typeof(min) __min = (min);		\
 	typeof(max) __max = (max);		\
 	(void) (&__val == &__min);		\
 	(void) (&__val == &__max);		\
 	__val = __val < __min ? __min : __val;	\
-	__val > __max ? __max : __val; })
+	__val > __max ? __max : __val;		\
+})
 
 /*
  * ..and if you can't take the strict
@@ -280,15 +291,19 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
  *
  * Or not use min/max/clamp at all, of course.
  */
-#define min_t(type, x, y) ({			\
+#define min_t(type, x, y)			\
+({						\
 	type __min1 = (x);			\
 	type __min2 = (y);			\
-	__min1 < __min2 ? __min1 : __min2; })
+	__min1 < __min2 ? __min1 : __min2;	\
+})
 
-#define max_t(type, x, y) ({			\
+#define max_t(type, x, y)			\
+({						\
 	type __max1 = (x);			\
 	type __max2 = (y);			\
-	__max1 > __max2 ? __max1 : __max2; })
+	__max1 > __max2 ? __max1 : __max2;	\
+})
 
 /**
  * clamp_t - return a value clamped to a given range using a given type
@@ -300,12 +315,14 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
  * This macro does no typechecking and uses temporary variables of type
  * 'type' to make all the comparisons.
  */
-#define clamp_t(type, val, min, max) ({		\
+#define clamp_t(type, val, min, max)		\
+({						\
 	type __val = (val);			\
 	type __min = (min);			\
 	type __max = (max);			\
 	__val = __val < __min ? __min : __val;	\
-	__val > __max ? __max : __val; })
+	__val > __max ? __max : __val;		\
+})
 
 /**
  * clamp_val - return a value clamped to a given range using val's type
@@ -318,13 +335,14 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
  * type and min and max are literals that will otherwise be assigned a signed
  * integer type.
  */
-#define clamp_val(val, min, max) ({		\
+#define clamp_val(val, min, max)		\
+({						\
 	typeof(val) __val = (val);		\
 	typeof(val) __min = (min);		\
 	typeof(val) __max = (max);		\
 	__val = __val < __min ? __min : __val;	\
-	__val > __max ? __max : __val; })
-
+	__val > __max ? __max : __val;		\
+})
 
 /*
  * swap - swap value of @a and @b
@@ -458,8 +476,6 @@ extern void printk_tick(void);
 extern void asmlinkage __attribute__((format(printf, 1, 2)))
 	early_printk(const char *fmt, ...);
 
-unsigned long int_sqrt(unsigned long);
-
 static inline void console_silent(void)
 {
 	console_loglevel = 0;
@@ -485,13 +501,13 @@ enum {
 	DUMP_PREFIX_OFFSET
 };
 extern void hex_dump_to_buffer(const void *buf, size_t len,
-				int rowsize, int groupsize,
-				char *linebuf, size_t linebuflen, bool ascii);
+			       int rowsize, int groupsize,
+			       char *linebuf, size_t linebuflen, bool ascii);
 extern void print_hex_dump(const char *level, const char *prefix_str,
-				int prefix_type, int rowsize, int groupsize,
-				const void *buf, size_t len, bool ascii);
+			   int prefix_type, int rowsize, int groupsize,
+			   const void *buf, size_t len, bool ascii);
 extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
-			const void *buf, size_t len);
+				 const void *buf, size_t len);
 
 
 #ifndef pr_fmt
-- 
1.6.6.rc0.57.gad7a

