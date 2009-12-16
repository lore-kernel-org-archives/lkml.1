Return-Path: <linux-kernel-owner+w=401wt.eu-S934699AbZLPIKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934699AbZLPIKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761778AbZLPIJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:09:19 -0500
Received: from mail.perches.com ([173.55.12.10]:1197 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZLPIJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:09:15 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] kernel.h: Checkpatch cleaning
Date: Wed, 16 Dec 2009 00:09:01 -0800
Message-Id: <770a8481530ed545561cda315cf43fbb77a3e26f.1260949674.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1260949674.git.joe@perches.com>
References: <cover.1260949674.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The warnings and errors still generated aren't interesting

was:	total: 43 errors, 8 warnings, 756 lines checked
is:	total: 3 errors, 7 warnings, 766 lines checked

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |  127 ++++++++++++++++++++++++------------------------
 1 files changed, 64 insertions(+), 63 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index c9cdfca..2cc6d70 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -16,56 +16,54 @@
 #include <linux/log2.h>
 #include <linux/typecheck.h>
 #include <linux/dynamic_debug.h>
+#include <linux/bug.h>
 #include <asm/byteorder.h>
-#include <asm/bug.h>
 
 #define USHORT_MAX	((u16)(~0U))
-#define SHORT_MAX	((s16)(USHORT_MAX>>1))
+#define SHORT_MAX	((s16)(USHORT_MAX >> 1))
 #define SHORT_MIN	(-SHORT_MAX - 1)
-#define INT_MAX		((int)(~0U>>1))
+#define INT_MAX		((int)(~0U >> 1))
 #define INT_MIN		(-INT_MAX - 1)
 #define UINT_MAX	(~0U)
 #define LONG_MAX	((long)(~0UL>>1))
 #define LONG_MIN	(-LONG_MAX - 1)
 #define ULONG_MAX	(~0UL)
-#define LLONG_MAX	((long long)(~0ULL>>1))
+#define LLONG_MAX	((long long)(~0ULL >> 1))
 #define LLONG_MIN	(-LLONG_MAX - 1)
 #define ULLONG_MAX	(~0ULL)
 
 #define STACK_MAGIC	0xdeadbeef
 
-#define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
-#define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
+#define __ALIGN_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+#define ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a) - 1)
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
-#define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
+#define IS_ALIGNED(x, a)	(((x) & ((typeof(x))(a) - 1)) == 0)
 
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+#define ARRAY_SIZE(arr)		(sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+#define FIELD_SIZEOF(t, f)	(sizeof(((t *)0)->f))
 
-#define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
-#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
-#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
-#define DIV_ROUND_CLOSEST(x, divisor)(			\
-{							\
+#define roundup(x, y)		((((x) + ((y) - 1)) / (y)) * (y))
+#define DIV_ROUND_UP(n, d)	(((n) + (d) - 1) / (d))
+#define DIV_ROUND_CLOSEST(x, divisor)			\
+({							\
 	typeof(divisor) __divisor = divisor;		\
 	(((x) + ((__divisor) / 2)) / (__divisor));	\
-}							\
-)
+})
 
-#define _RET_IP_		(unsigned long)__builtin_return_address(0)
-#define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
+#define _RET_IP_	(unsigned long)__builtin_return_address(0)
+#define _THIS_IP_	({ __label__ __here; __here: (unsigned long)&&__here; })
 
 #ifdef CONFIG_LBDAF
 # include <asm/div64.h>
 # define sector_div(a, b) do_div(a, b)
 #else
-# define sector_div(n, b)( \
-{ \
-	int _res; \
-	_res = (n) % (b); \
-	(n) /= (b); \
-	_res; \
-} \
-)
+# define sector_div(n, b)	\
+({				\
+	int _res;		\
+	_res = (n) % (b);	\
+	(n) /= (b);		\
+	_res;			\
+})
 #endif
 
 /**
@@ -76,13 +74,13 @@
  * the "right shift count >= width of type" warning when that quantity is
  * 32-bits.
  */
-#define upper_32_bits(n) ((u32)(((n) >> 16) >> 16))
+#define upper_32_bits(n)	((u32)(((n) >> 16) >> 16))
 
 /**
  * lower_32_bits - return bits 0-31 of a number
  * @n: the number we're accessing
  */
-#define lower_32_bits(n) ((u32)(n))
+#define lower_32_bits(n)	((u32)(n))
 
 struct completion;
 struct pt_regs;
@@ -96,7 +94,7 @@ extern int _cond_resched(void);
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
-  void __might_sleep(char *file, int line, int preempt_offset);
+void __might_sleep(char *file, int line, int preempt_offset);
 /**
  * might_sleep - annotation for functions that can sleep
  *
@@ -116,10 +114,11 @@ extern int _cond_resched(void);
 
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
 
-#define abs(x) ({				\
-		long __x = (x);			\
-		(__x < 0) ? -__x : __x;		\
-	})
+#define abs(x)				\
+({					\
+	long __x = (x);			\
+	(__x < 0) ? -__x : __x;		\
+})
 
 #ifdef CONFIG_PROVE_LOCKING
 void might_fault(void);
@@ -132,7 +131,7 @@ static inline void might_fault(void)
 
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
-NORET_TYPE void panic(const char * fmt, ...)
+NORET_TYPE void panic(const char *fmt, ...)
 	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
 extern void oops_enter(void);
 extern void oops_exit(void);
@@ -141,23 +140,23 @@ NORET_TYPE void do_exit(long error_code)
 	ATTRIB_NORET;
 NORET_TYPE void complete_and_exit(struct completion *, long)
 	ATTRIB_NORET;
-extern unsigned long simple_strtoul(const char *,char **,unsigned int);
-extern long simple_strtol(const char *,char **,unsigned int);
-extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
-extern long long simple_strtoll(const char *,char **,unsigned int);
+extern unsigned long simple_strtoul(const char *, char **, unsigned int);
+extern long simple_strtol(const char *, char **, unsigned int);
+extern unsigned long long simple_strtoull(const char *, char **, unsigned int);
+extern long long simple_strtoll(const char *, char **, unsigned int);
 extern int strict_strtoul(const char *, unsigned int, unsigned long *);
 extern int strict_strtol(const char *, unsigned int, long *);
 extern int strict_strtoull(const char *, unsigned int, unsigned long long *);
 extern int strict_strtoll(const char *, unsigned int, long long *);
-extern int sprintf(char * buf, const char * fmt, ...)
+extern int sprintf(char *buf, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 extern int vsprintf(char *buf, const char *, va_list)
 	__attribute__ ((format (printf, 2, 0)));
-extern int snprintf(char * buf, size_t size, const char * fmt, ...)
+extern int snprintf(char *buf, size_t size, const char *fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
 extern int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 	__attribute__ ((format (printf, 3, 0)));
-extern int scnprintf(char * buf, size_t size, const char * fmt, ...)
+extern int scnprintf(char *buf, size_t size, const char *fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
 extern int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
 	__attribute__ ((format (printf, 3, 0)));
@@ -270,8 +269,8 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 	typeof(max) __max = (max);		\
 	(void) (&__val == &__min);		\
 	(void) (&__val == &__max);		\
-	__val = __val < __min ? __min: __val;	\
-	__val > __max ? __max: __val; })
+	__val = __val < __min ? __min : __val;	\
+	__val > __max ? __max : __val; })
 
 /*
  * ..and if you can't take the strict
@@ -282,12 +281,12 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 #define min_t(type, x, y) ({			\
 	type __min1 = (x);			\
 	type __min2 = (y);			\
-	__min1 < __min2 ? __min1: __min2; })
+	__min1 < __min2 ? __min1 : __min2; })
 
 #define max_t(type, x, y) ({			\
 	type __max1 = (x);			\
 	type __max2 = (y);			\
-	__max1 > __max2 ? __max1: __max2; })
+	__max1 > __max2 ? __max1 : __max2; })
 
 /**
  * clamp_t - return a value clamped to a given range using a given type
@@ -303,8 +302,8 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 	type __val = (val);			\
 	type __min = (min);			\
 	type __max = (max);			\
-	__val = __val < __min ? __min: __val;	\
-	__val > __max ? __max: __val; })
+	__val = __val < __min ? __min : __val;	\
+	__val > __max ? __max : __val; })
 
 /**
  * clamp_val - return a value clamped to a given range using val's type
@@ -321,8 +320,8 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 	typeof(val) __val = (val);		\
 	typeof(val) __min = (min);		\
 	typeof(val) __max = (max);		\
-	__val = __val < __min ? __min: __val;	\
-	__val > __max ? __max: __val; })
+	__val = __val < __min ? __min : __val;	\
+	__val > __max ? __max : __val; })
 
 
 /*
@@ -339,8 +338,8 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
  *
  */
 #define container_of(ptr, type, member) ({			\
-	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
-	(type *)( (char *)__mptr - offsetof(type,member) );	\
+	const typeof(((type *)0)->member) *__mptr = (ptr);	\
+	(type *)((char *)__mptr - offsetof(type, member));	\
 })
 
 struct sysinfo;
@@ -385,7 +384,7 @@ extern int console_printk[];
  * should be able to fix this issue or at least get a concrete idea of the
  * problem by reading your message without the need of looking at the kernel
  * code.
- * 
+ *
  * Use it for definite and high priority BIOS bugs.
  *
  * FW_WARN
@@ -405,7 +404,7 @@ extern int console_printk[];
 #ifdef CONFIG_PRINTK
 asmlinkage int vprintk(const char *fmt, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
-asmlinkage int printk(const char * fmt, ...)
+asmlinkage int printk(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
 
 extern int __printk_ratelimit(const char *func);
@@ -469,7 +468,9 @@ static inline void console_verbose(void)
 
 extern void bust_spinlocks(int yes);
 extern void wake_up_klogd(void);
-extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
+
+/* If set, an oops, panic(), BUG() or die() is in progress */
+extern int oops_in_progress;
 
 extern void dump_stack(void) __cold;
 
@@ -493,19 +494,19 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 #endif
 
 #define pr_emerg(fmt, ...) \
-        printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_alert(fmt, ...) \
-        printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_crit(fmt, ...) \
-        printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_err(fmt, ...) \
-        printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_warning(fmt, ...) \
-        printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_notice(fmt, ...) \
-        printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info(fmt, ...) \
-        printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
@@ -738,14 +739,14 @@ struct sysinfo {
 #define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
 
 /* Force a compilation error if condition is constant and true */
-#define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
+#define MAYBE_BUILD_BUG_ON(cond)	((void)sizeof(char[1 - 2 * !!(cond)]))
 
 /* Force a compilation error if condition is true, but also produce a
    result (of value 0 and type size_t), so the expression can be used
    e.g. in a structure initializer (or where-ever else comma expressions
    aren't permitted). */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
-#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
+#define BUILD_BUG_ON_ZERO(e)	(sizeof(struct { int:-!!(e); }))
+#define BUILD_BUG_ON_NULL(e)	((void *)sizeof(struct { int:-!!(e); }))
 
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
-- 
1.6.6.rc0.57.gad7a

