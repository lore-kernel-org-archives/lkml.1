Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbYDZRud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbYDZRud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYDZRuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:50:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56627 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbYDZRuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:50:22 -0400
Date: Sat, 26 Apr 2008 19:50:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com
Subject: [git pull] generic bitops, take 3
Message-ID: <20080426175002.GA20770@elte.hu>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu> <20080426172843.GA20534@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426172843.GA20534@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> So i checked the patch below. [...]

> so i guess this is the way to go?

i think it is. I just put these fixes into the bitops tree and 64-bit 
UML seems unaffected and properly picks up these symbols from the x86 
Kconfig.cpu file. I pushed out the v3 tree to:

  git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-generic-bitops-v3.git for-linus

find the shortlog and diff below.

this is against your very latest tree (which i rebased against to pick 
up the VFS fix). 5 successful build+bootup tests done with this fresh 
tree:

 #0, Sat_Apr_26_19_35_34_CEST_2008
 #1, Sat_Apr_26_19_37_02_CEST_2008
 #2, Sat_Apr_26_19_38_48_CEST_2008
 #3, Sat_Apr_26_19_41_36_CEST_2008
 #4, Sat_Apr_26_19_43_28_CEST_2008

on x86, mixed 32-bit/64-bit.

	Ingo

------------------>
Alexander van Heukelum (13):
      x86: change x86 to use generic find_next_bit
      x86, uml: fix uml with generic find_next_bit for x86
      x86, generic: optimize find_next_(zero_)bit for small constant-size bitmaps
      x86: merge the simple bitops and move them to bitops.h
      generic: introduce a generic __fls implementation
      generic: implement __fls on all 64-bit archs
      bitops: use __fls for fls64 on 64-bit archs
      x86: generic versions of find_first_(zero_)bit, convert i386
      x86: switch 64-bit to generic find_first_bit
      x86: optimize find_first_bit for small bitmaps
      x86, UML: remove x86-specific implementations of find_first_bit
      x86: finalize bitops unification
      x86, bitops: select the generic bitmap search functions

Ingo Molnar (2):
      uml: fix build error
      uml: Kconfig cleanup

Joe Perches (1):
      x86: include/asm-x86/pgalloc.h/bitops.h: checkpatch cleanups - formatting only

 arch/um/Kconfig.x86_64             |    7 ++
 arch/um/os-Linux/helper.c          |    1 +
 arch/um/sys-i386/Makefile          |    2 +-
 arch/um/sys-x86_64/Makefile        |    2 +-
 arch/x86/Kconfig.cpu               |    7 ++-
 arch/x86/lib/Makefile              |    3 +-
 arch/x86/lib/bitops_32.c           |   70 --------------
 arch/x86/lib/bitops_64.c           |  175 ------------------------------------
 include/asm-alpha/bitops.h         |    5 +
 include/asm-generic/bitops/__fls.h |   43 +++++++++
 include/asm-generic/bitops/find.h  |    2 +
 include/asm-generic/bitops/fls64.h |   22 +++++
 include/asm-ia64/bitops.h          |   16 ++++
 include/asm-mips/bitops.h          |    5 +
 include/asm-parisc/bitops.h        |    1 +
 include/asm-powerpc/bitops.h       |    5 +
 include/asm-s390/bitops.h          |    1 +
 include/asm-sh/bitops.h            |    1 +
 include/asm-sparc64/bitops.h       |    1 +
 include/asm-x86/bitops.h           |  149 ++++++++++++++++++++++++++++---
 include/asm-x86/bitops_32.h        |  166 ----------------------------------
 include/asm-x86/bitops_64.h        |  162 ---------------------------------
 include/linux/bitops.h             |  140 ++++++++++++++++++++++++++++
 lib/Kconfig                        |    6 ++
 lib/Makefile                       |    1 +
 lib/find_next_bit.c                |   77 +++++++++++++---
 26 files changed, 467 insertions(+), 603 deletions(-)
 delete mode 100644 arch/x86/lib/bitops_32.c
 delete mode 100644 arch/x86/lib/bitops_64.c
 create mode 100644 include/asm-generic/bitops/__fls.h
 delete mode 100644 include/asm-x86/bitops_32.h
 delete mode 100644 include/asm-x86/bitops_64.h

diff --git a/arch/um/Kconfig.x86_64 b/arch/um/Kconfig.x86_64
index 3fbe69e..5696e7b 100644
--- a/arch/um/Kconfig.x86_64
+++ b/arch/um/Kconfig.x86_64
@@ -1,3 +1,10 @@
+
+menu "Host processor type and features"
+
+source "arch/x86/Kconfig.cpu"
+
+endmenu
+
 config UML_X86
 	bool
 	default y
diff --git a/arch/um/os-Linux/helper.c b/arch/um/os-Linux/helper.c
index f4bd349..f25c29a 100644
--- a/arch/um/os-Linux/helper.c
+++ b/arch/um/os-Linux/helper.c
@@ -14,6 +14,7 @@
 #include "os.h"
 #include "um_malloc.h"
 #include "user.h"
+#include <linux/limits.h>
 
 struct helper_data {
 	void (*pre_exec)(void*);
diff --git a/arch/um/sys-i386/Makefile b/arch/um/sys-i386/Makefile
index 964dc1a..598b5c1 100644
--- a/arch/um/sys-i386/Makefile
+++ b/arch/um/sys-i386/Makefile
@@ -6,7 +6,7 @@ obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
 	ptrace_user.o setjmp.o signal.o stub.o stub_segv.o syscalls.o sysrq.o \
 	sys_call_table.o tls.o
 
-subarch-obj-y = lib/bitops_32.o lib/semaphore_32.o lib/string_32.o
+subarch-obj-y = lib/semaphore_32.o lib/string_32.o
 subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module_32.o
 
diff --git a/arch/um/sys-x86_64/Makefile b/arch/um/sys-x86_64/Makefile
index 3c22de5..c8b4cce 100644
--- a/arch/um/sys-x86_64/Makefile
+++ b/arch/um/sys-x86_64/Makefile
@@ -10,7 +10,7 @@ obj-y = bug.o bugs.o delay.o fault.o ldt.o mem.o ptrace.o ptrace_user.o \
 
 obj-$(CONFIG_MODULES) += um_module.o
 
-subarch-obj-y = lib/bitops_64.o lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o
+subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module_64.o
 
 ldt-y = ../sys-i386/ldt.o
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 4da3cdb..7ef18b0 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -278,6 +278,11 @@ config GENERIC_CPU
 
 endchoice
 
+config X86_CPU
+	def_bool y
+	select GENERIC_FIND_FIRST_BIT
+	select GENERIC_FIND_NEXT_BIT
+
 config X86_GENERIC
 	bool "Generic x86 support"
 	depends on X86_32
@@ -398,7 +403,7 @@ config X86_TSC
 # generates cmov.
 config X86_CMOV
 	def_bool y
-	depends on (MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7)
+	depends on (MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || X86_64)
 
 config X86_MINIMUM_CPU_FAMILY
 	int
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 25df1c1..76f60f5 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -11,7 +11,7 @@ lib-y += memcpy_$(BITS).o
 ifeq ($(CONFIG_X86_32),y)
         lib-y += checksum_32.o
         lib-y += strstr_32.o
-        lib-y += bitops_32.o semaphore_32.o string_32.o
+        lib-y += semaphore_32.o string_32.o
 
         lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
 else
@@ -21,7 +21,6 @@ else
 
         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
-        lib-y += bitops_64.o
         lib-y += memmove_64.o memset_64.o
         lib-y += copy_user_64.o rwlock_64.o copy_user_nocache_64.o
 endif
diff --git a/arch/x86/lib/bitops_32.c b/arch/x86/lib/bitops_32.c
deleted file mode 100644
index b654404..0000000
--- a/arch/x86/lib/bitops_32.c
+++ /dev/null
@@ -1,70 +0,0 @@
-#include <linux/bitops.h>
-#include <linux/module.h>
-
-/**
- * find_next_bit - find the next set bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The maximum size to search
- */
-int find_next_bit(const unsigned long *addr, int size, int offset)
-{
-	const unsigned long *p = addr + (offset >> 5);
-	int set = 0, bit = offset & 31, res;
-
-	if (bit) {
-		/*
-		 * Look for nonzero in the first 32 bits:
-		 */
-		__asm__("bsfl %1,%0\n\t"
-			"jne 1f\n\t"
-			"movl $32, %0\n"
-			"1:"
-			: "=r" (set)
-			: "r" (*p >> bit));
-		if (set < (32 - bit))
-			return set + offset;
-		set = 32 - bit;
-		p++;
-	}
-	/*
-	 * No set bit yet, search remaining full words for a bit
-	 */
-	res = find_first_bit (p, size - 32 * (p - addr));
-	return (offset + set + res);
-}
-EXPORT_SYMBOL(find_next_bit);
-
-/**
- * find_next_zero_bit - find the first zero bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The maximum size to search
- */
-int find_next_zero_bit(const unsigned long *addr, int size, int offset)
-{
-	const unsigned long *p = addr + (offset >> 5);
-	int set = 0, bit = offset & 31, res;
-
-	if (bit) {
-		/*
-		 * Look for zero in the first 32 bits.
-		 */
-		__asm__("bsfl %1,%0\n\t"
-			"jne 1f\n\t"
-			"movl $32, %0\n"
-			"1:"
-			: "=r" (set)
-			: "r" (~(*p >> bit)));
-		if (set < (32 - bit))
-			return set + offset;
-		set = 32 - bit;
-		p++;
-	}
-	/*
-	 * No zero yet, search remaining full bytes for a zero
-	 */
-	res = find_first_zero_bit(p, size - 32 * (p - addr));
-	return (offset + set + res);
-}
-EXPORT_SYMBOL(find_next_zero_bit);
diff --git a/arch/x86/lib/bitops_64.c b/arch/x86/lib/bitops_64.c
deleted file mode 100644
index 0e8f491..0000000
--- a/arch/x86/lib/bitops_64.c
+++ /dev/null
@@ -1,175 +0,0 @@
-#include <linux/bitops.h>
-
-#undef find_first_zero_bit
-#undef find_next_zero_bit
-#undef find_first_bit
-#undef find_next_bit
-
-static inline long
-__find_first_zero_bit(const unsigned long * addr, unsigned long size)
-{
-	long d0, d1, d2;
-	long res;
-
-	/*
-	 * We must test the size in words, not in bits, because
-	 * otherwise incoming sizes in the range -63..-1 will not run
-	 * any scasq instructions, and then the flags used by the je
-	 * instruction will have whatever random value was in place
-	 * before.  Nobody should call us like that, but
-	 * find_next_zero_bit() does when offset and size are at the
-	 * same word and it fails to find a zero itself.
-	 */
-	size += 63;
-	size >>= 6;
-	if (!size)
-		return 0;
-	asm volatile(
-		"  repe; scasq\n"
-		"  je 1f\n"
-		"  xorq -8(%%rdi),%%rax\n"
-		"  subq $8,%%rdi\n"
-		"  bsfq %%rax,%%rdx\n"
-		"1:  subq %[addr],%%rdi\n"
-		"  shlq $3,%%rdi\n"
-		"  addq %%rdi,%%rdx"
-		:"=d" (res), "=&c" (d0), "=&D" (d1), "=&a" (d2)
-		:"0" (0ULL), "1" (size), "2" (addr), "3" (-1ULL),
-		 [addr] "S" (addr) : "memory");
-	/*
-	 * Any register would do for [addr] above, but GCC tends to
-	 * prefer rbx over rsi, even though rsi is readily available
-	 * and doesn't have to be saved.
-	 */
-	return res;
-}
-
-/**
- * find_first_zero_bit - find the first zero bit in a memory region
- * @addr: The address to start the search at
- * @size: The maximum size to search
- *
- * Returns the bit-number of the first zero bit, not the number of the byte
- * containing a bit.
- */
-long find_first_zero_bit(const unsigned long * addr, unsigned long size)
-{
-	return __find_first_zero_bit (addr, size);
-}
-
-/**
- * find_next_zero_bit - find the next zero bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The maximum size to search
- */
-long find_next_zero_bit (const unsigned long * addr, long size, long offset)
-{
-	const unsigned long * p = addr + (offset >> 6);
-	unsigned long set = 0;
-	unsigned long res, bit = offset&63;
-
-	if (bit) {
-		/*
-		 * Look for zero in first word
-		 */
-		asm("bsfq %1,%0\n\t"
-		    "cmoveq %2,%0"
-		    : "=r" (set)
-		    : "r" (~(*p >> bit)), "r"(64L));
-		if (set < (64 - bit))
-			return set + offset;
-		set = 64 - bit;
-		p++;
-	}
-	/*
-	 * No zero yet, search remaining full words for a zero
-	 */
-	res = __find_first_zero_bit (p, size - 64 * (p - addr));
-
-	return (offset + set + res);
-}
-
-static inline long
-__find_first_bit(const unsigned long * addr, unsigned long size)
-{
-	long d0, d1;
-	long res;
-
-	/*
-	 * We must test the size in words, not in bits, because
-	 * otherwise incoming sizes in the range -63..-1 will not run
-	 * any scasq instructions, and then the flags used by the jz
-	 * instruction will have whatever random value was in place
-	 * before.  Nobody should call us like that, but
-	 * find_next_bit() does when offset and size are at the same
-	 * word and it fails to find a one itself.
-	 */
-	size += 63;
-	size >>= 6;
-	if (!size)
-		return 0;
-	asm volatile(
-		"   repe; scasq\n"
-		"   jz 1f\n"
-		"   subq $8,%%rdi\n"
-		"   bsfq (%%rdi),%%rax\n"
-		"1: subq %[addr],%%rdi\n"
-		"   shlq $3,%%rdi\n"
-		"   addq %%rdi,%%rax"
-		:"=a" (res), "=&c" (d0), "=&D" (d1)
-		:"0" (0ULL), "1" (size), "2" (addr),
-		 [addr] "r" (addr) : "memory");
-	return res;
-}
-
-/**
- * find_first_bit - find the first set bit in a memory region
- * @addr: The address to start the search at
- * @size: The maximum size to search
- *
- * Returns the bit-number of the first set bit, not the number of the byte
- * containing a bit.
- */
-long find_first_bit(const unsigned long * addr, unsigned long size)
-{
-	return __find_first_bit(addr,size);
-}
-
-/**
- * find_next_bit - find the first set bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The maximum size to search
- */
-long find_next_bit(const unsigned long * addr, long size, long offset)
-{
-	const unsigned long * p = addr + (offset >> 6);
-	unsigned long set = 0, bit = offset & 63, res;
-
-	if (bit) {
-		/*
-		 * Look for nonzero in the first 64 bits:
-		 */
-		asm("bsfq %1,%0\n\t"
-		    "cmoveq %2,%0\n\t"
-		    : "=r" (set)
-		    : "r" (*p >> bit), "r" (64L));
-		if (set < (64 - bit))
-			return set + offset;
-		set = 64 - bit;
-		p++;
-	}
-	/*
-	 * No set bit yet, search remaining full words for a bit
-	 */
-	res = __find_first_bit (p, size - 64 * (p - addr));
-	return (offset + set + res);
-}
-
-#include <linux/module.h>
-
-EXPORT_SYMBOL(find_next_bit);
-EXPORT_SYMBOL(find_first_bit);
-EXPORT_SYMBOL(find_first_zero_bit);
-EXPORT_SYMBOL(find_next_zero_bit);
diff --git a/include/asm-alpha/bitops.h b/include/asm-alpha/bitops.h
index 9e19a70..15f3ae2 100644
--- a/include/asm-alpha/bitops.h
+++ b/include/asm-alpha/bitops.h
@@ -388,6 +388,11 @@ static inline int fls64(unsigned long x)
 }
 #endif
 
+static inline unsigned long __fls(unsigned long x)
+{
+	return fls64(x) - 1;
+}
+
 static inline int fls(int x)
 {
 	return fls64((unsigned int) x);
diff --git a/include/asm-generic/bitops/__fls.h b/include/asm-generic/bitops/__fls.h
new file mode 100644
index 0000000..be24465
--- /dev/null
+++ b/include/asm-generic/bitops/__fls.h
@@ -0,0 +1,43 @@
+#ifndef _ASM_GENERIC_BITOPS___FLS_H_
+#define _ASM_GENERIC_BITOPS___FLS_H_
+
+#include <asm/types.h>
+
+/**
+ * __fls - find last (most-significant) set bit in a long word
+ * @word: the word to search
+ *
+ * Undefined if no set bit exists, so code should check against 0 first.
+ */
+static inline unsigned long __fls(unsigned long word)
+{
+	int num = BITS_PER_LONG - 1;
+
+#if BITS_PER_LONG == 64
+	if (!(word & (~0ul << 32))) {
+		num -= 32;
+		word <<= 32;
+	}
+#endif
+	if (!(word & (~0ul << (BITS_PER_LONG-16)))) {
+		num -= 16;
+		word <<= 16;
+	}
+	if (!(word & (~0ul << (BITS_PER_LONG-8)))) {
+		num -= 8;
+		word <<= 8;
+	}
+	if (!(word & (~0ul << (BITS_PER_LONG-4)))) {
+		num -= 4;
+		word <<= 4;
+	}
+	if (!(word & (~0ul << (BITS_PER_LONG-2)))) {
+		num -= 2;
+		word <<= 2;
+	}
+	if (!(word & (~0ul << (BITS_PER_LONG-1))))
+		num -= 1;
+	return num;
+}
+
+#endif /* _ASM_GENERIC_BITOPS___FLS_H_ */
diff --git a/include/asm-generic/bitops/find.h b/include/asm-generic/bitops/find.h
index 72a51e5..1914e97 100644
--- a/include/asm-generic/bitops/find.h
+++ b/include/asm-generic/bitops/find.h
@@ -1,11 +1,13 @@
 #ifndef _ASM_GENERIC_BITOPS_FIND_H_
 #define _ASM_GENERIC_BITOPS_FIND_H_
 
+#ifndef CONFIG_GENERIC_FIND_NEXT_BIT
 extern unsigned long find_next_bit(const unsigned long *addr, unsigned long
 		size, unsigned long offset);
 
 extern unsigned long find_next_zero_bit(const unsigned long *addr, unsigned
 		long size, unsigned long offset);
+#endif
 
 #define find_first_bit(addr, size) find_next_bit((addr), (size), 0)
 #define find_first_zero_bit(addr, size) find_next_zero_bit((addr), (size), 0)
diff --git a/include/asm-generic/bitops/fls64.h b/include/asm-generic/bitops/fls64.h
index 1b6b17c..86d403f 100644
--- a/include/asm-generic/bitops/fls64.h
+++ b/include/asm-generic/bitops/fls64.h
@@ -3,6 +3,18 @@
 
 #include <asm/types.h>
 
+/**
+ * fls64 - find last set bit in a 64-bit word
+ * @x: the word to search
+ *
+ * This is defined in a similar way as the libc and compiler builtin
+ * ffsll, but returns the position of the most significant set bit.
+ *
+ * fls64(value) returns 0 if value is 0 or the position of the last
+ * set bit if value is nonzero. The last (most significant) bit is
+ * at position 64.
+ */
+#if BITS_PER_LONG == 32
 static inline int fls64(__u64 x)
 {
 	__u32 h = x >> 32;
@@ -10,5 +22,15 @@ static inline int fls64(__u64 x)
 		return fls(h) + 32;
 	return fls(x);
 }
+#elif BITS_PER_LONG == 64
+static inline int fls64(__u64 x)
+{
+	if (x == 0)
+		return 0;
+	return __fls(x) + 1;
+}
+#else
+#error BITS_PER_LONG not 32 or 64
+#endif
 
 #endif /* _ASM_GENERIC_BITOPS_FLS64_H_ */
diff --git a/include/asm-ia64/bitops.h b/include/asm-ia64/bitops.h
index 953d3df..e2ca800 100644
--- a/include/asm-ia64/bitops.h
+++ b/include/asm-ia64/bitops.h
@@ -407,6 +407,22 @@ fls (int t)
 	return ia64_popcnt(x);
 }
 
+/*
+ * Find the last (most significant) bit set.  Undefined for x==0.
+ * Bits are numbered from 0..63 (e.g., __fls(9) == 3).
+ */
+static inline unsigned long
+__fls (unsigned long x)
+{
+	x |= x >> 1;
+	x |= x >> 2;
+	x |= x >> 4;
+	x |= x >> 8;
+	x |= x >> 16;
+	x |= x >> 32;
+	return ia64_popcnt(x) - 1;
+}
+
 #include <asm-generic/bitops/fls64.h>
 
 /*
diff --git a/include/asm-mips/bitops.h b/include/asm-mips/bitops.h
index ec75ce4..c2bd126 100644
--- a/include/asm-mips/bitops.h
+++ b/include/asm-mips/bitops.h
@@ -591,6 +591,11 @@ static inline int __ilog2(unsigned long x)
 	return 63 - lz;
 }
 
+static inline unsigned long __fls(unsigned long x)
+{
+	return __ilog2(x);
+}
+
 #if defined(CONFIG_CPU_MIPS32) || defined(CONFIG_CPU_MIPS64)
 
 /*
diff --git a/include/asm-parisc/bitops.h b/include/asm-parisc/bitops.h
index f8eebcb..7a6ea10 100644
--- a/include/asm-parisc/bitops.h
+++ b/include/asm-parisc/bitops.h
@@ -210,6 +210,7 @@ static __inline__ int fls(int x)
 	return ret;
 }
 
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
diff --git a/include/asm-powerpc/bitops.h b/include/asm-powerpc/bitops.h
index a99a749..897eade 100644
--- a/include/asm-powerpc/bitops.h
+++ b/include/asm-powerpc/bitops.h
@@ -313,6 +313,11 @@ static __inline__ int fls(unsigned int x)
 	return 32 - lz;
 }
 
+static __inline__ unsigned long __fls(unsigned long x)
+{
+	return __ilog2(x);
+}
+
 /*
  * 64-bit can do this using one cntlzd (count leading zeroes doubleword)
  * instruction; for 32-bit we use the generic version, which does two
diff --git a/include/asm-s390/bitops.h b/include/asm-s390/bitops.h
index 965394e..b4eb24a 100644
--- a/include/asm-s390/bitops.h
+++ b/include/asm-s390/bitops.h
@@ -769,6 +769,7 @@ static inline int sched_find_first_bit(unsigned long *b)
 }
 
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #include <asm-generic/bitops/hweight.h>
diff --git a/include/asm-sh/bitops.h b/include/asm-sh/bitops.h
index b6ba5a6..d7d382f 100644
--- a/include/asm-sh/bitops.h
+++ b/include/asm-sh/bitops.h
@@ -95,6 +95,7 @@ static inline unsigned long ffz(unsigned long word)
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #endif /* __KERNEL__ */
diff --git a/include/asm-sparc64/bitops.h b/include/asm-sparc64/bitops.h
index 982ce89..11f9d81 100644
--- a/include/asm-sparc64/bitops.h
+++ b/include/asm-sparc64/bitops.h
@@ -34,6 +34,7 @@ extern void change_bit(unsigned long nr, volatile unsigned long *addr);
 #include <asm-generic/bitops/ffz.h>
 #include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #ifdef __KERNEL__
diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
index 1ae7b27..b81a4d4 100644
--- a/include/asm-x86/bitops.h
+++ b/include/asm-x86/bitops.h
@@ -62,12 +62,9 @@ static inline void set_bit(int nr, volatile void *addr)
  */
 static inline void __set_bit(int nr, volatile void *addr)
 {
-	asm volatile("bts %1,%0"
-		     : ADDR
-		     : "Ir" (nr) : "memory");
+	asm volatile("bts %1,%0" : ADDR : "Ir" (nr) : "memory");
 }
 
-
 /**
  * clear_bit - Clears a bit in memory
  * @nr: Bit to clear
@@ -297,19 +294,145 @@ static inline int variable_test_bit(int nr, volatile const void *addr)
 static int test_bit(int nr, const volatile unsigned long *addr);
 #endif
 
-#define test_bit(nr,addr)			\
-	(__builtin_constant_p(nr) ?		\
-	 constant_test_bit((nr),(addr)) :	\
-	 variable_test_bit((nr),(addr)))
+#define test_bit(nr, addr)			\
+	(__builtin_constant_p((nr))		\
+	 ? constant_test_bit((nr), (addr))	\
+	 : variable_test_bit((nr), (addr)))
+
+/**
+ * __ffs - find first set bit in word
+ * @word: The word to search
+ *
+ * Undefined if no bit exists, so code should check against 0 first.
+ */
+static inline unsigned long __ffs(unsigned long word)
+{
+	asm("bsf %1,%0"
+		: "=r" (word)
+		: "rm" (word));
+	return word;
+}
+
+/**
+ * ffz - find first zero bit in word
+ * @word: The word to search
+ *
+ * Undefined if no zero exists, so code should check against ~0UL first.
+ */
+static inline unsigned long ffz(unsigned long word)
+{
+	asm("bsf %1,%0"
+		: "=r" (word)
+		: "r" (~word));
+	return word;
+}
+
+/*
+ * __fls: find last set bit in word
+ * @word: The word to search
+ *
+ * Undefined if no zero exists, so code should check against ~0UL first.
+ */
+static inline unsigned long __fls(unsigned long word)
+{
+	asm("bsr %1,%0"
+	    : "=r" (word)
+	    : "rm" (word));
+	return word;
+}
+
+#ifdef __KERNEL__
+/**
+ * ffs - find first set bit in word
+ * @x: the word to search
+ *
+ * This is defined the same way as the libc and compiler builtin ffs
+ * routines, therefore differs in spirit from the other bitops.
+ *
+ * ffs(value) returns 0 if value is 0 or the position of the first
+ * set bit if value is nonzero. The first (least significant) bit
+ * is at position 1.
+ */
+static inline int ffs(int x)
+{
+	int r;
+#ifdef CONFIG_X86_CMOV
+	asm("bsfl %1,%0\n\t"
+	    "cmovzl %2,%0"
+	    : "=r" (r) : "rm" (x), "r" (-1));
+#else
+	asm("bsfl %1,%0\n\t"
+	    "jnz 1f\n\t"
+	    "movl $-1,%0\n"
+	    "1:" : "=r" (r) : "rm" (x));
+#endif
+	return r + 1;
+}
+
+/**
+ * fls - find last set bit in word
+ * @x: the word to search
+ *
+ * This is defined in a similar way as the libc and compiler builtin
+ * ffs, but returns the position of the most significant set bit.
+ *
+ * fls(value) returns 0 if value is 0 or the position of the last
+ * set bit if value is nonzero. The last (most significant) bit is
+ * at position 32.
+ */
+static inline int fls(int x)
+{
+	int r;
+#ifdef CONFIG_X86_CMOV
+	asm("bsrl %1,%0\n\t"
+	    "cmovzl %2,%0"
+	    : "=&r" (r) : "rm" (x), "rm" (-1));
+#else
+	asm("bsrl %1,%0\n\t"
+	    "jnz 1f\n\t"
+	    "movl $-1,%0\n"
+	    "1:" : "=r" (r) : "rm" (x));
+#endif
+	return r + 1;
+}
+#endif /* __KERNEL__ */
 
 #undef BASE_ADDR
 #undef BIT_ADDR
 #undef ADDR
 
-#ifdef CONFIG_X86_32
-# include "bitops_32.h"
-#else
-# include "bitops_64.h"
-#endif
+static inline void set_bit_string(unsigned long *bitmap,
+		unsigned long i, int len)
+{
+	unsigned long end = i + len;
+	while (i < end) {
+		__set_bit(i, bitmap);
+		i++;
+	}
+}
+
+#ifdef __KERNEL__
+
+#include <asm-generic/bitops/sched.h>
+
+#define ARCH_HAS_FAST_MULTIPLIER 1
+
+#include <asm-generic/bitops/hweight.h>
+
+#endif /* __KERNEL__ */
+
+#include <asm-generic/bitops/fls64.h>
+
+#ifdef __KERNEL__
+
+#include <asm-generic/bitops/ext2-non-atomic.h>
+
+#define ext2_set_bit_atomic(lock, nr, addr)			\
+	test_and_set_bit((nr), (unsigned long *)(addr))
+#define ext2_clear_bit_atomic(lock, nr, addr)			\
+	test_and_clear_bit((nr), (unsigned long *)(addr))
+
+#include <asm-generic/bitops/minix.h>
 
+#endif /* __KERNEL__ */
 #endif	/* _ASM_X86_BITOPS_H */
diff --git a/include/asm-x86/bitops_32.h b/include/asm-x86/bitops_32.h
deleted file mode 100644
index 2513a81..0000000
--- a/include/asm-x86/bitops_32.h
+++ /dev/null
@@ -1,166 +0,0 @@
-#ifndef _I386_BITOPS_H
-#define _I386_BITOPS_H
-
-/*
- * Copyright 1992, Linus Torvalds.
- */
-
-/**
- * find_first_zero_bit - find the first zero bit in a memory region
- * @addr: The address to start the search at
- * @size: The maximum size to search
- *
- * Returns the bit number of the first zero bit, not the number of the byte
- * containing a bit.
- */
-static inline int find_first_zero_bit(const unsigned long *addr, unsigned size)
-{
-	int d0, d1, d2;
-	int res;
-
-	if (!size)
-		return 0;
-	/* This looks at memory.
-	 * Mark it volatile to tell gcc not to move it around
-	 */
-	asm volatile("movl $-1,%%eax\n\t"
-		     "xorl %%edx,%%edx\n\t"
-		     "repe; scasl\n\t"
-		     "je 1f\n\t"
-		     "xorl -4(%%edi),%%eax\n\t"
-		     "subl $4,%%edi\n\t"
-		     "bsfl %%eax,%%edx\n"
-		     "1:\tsubl %%ebx,%%edi\n\t"
-		     "shll $3,%%edi\n\t"
-		     "addl %%edi,%%edx"
-		     : "=d" (res), "=&c" (d0), "=&D" (d1), "=&a" (d2)
-		     : "1" ((size + 31) >> 5), "2" (addr),
-		       "b" (addr) : "memory");
-	return res;
-}
-
-/**
- * find_next_zero_bit - find the first zero bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bit number to start searching at
- * @size: The maximum size to search
- */
-int find_next_zero_bit(const unsigned long *addr, int size, int offset);
-
-/**
- * __ffs - find first bit in word.
- * @word: The word to search
- *
- * Undefined if no bit exists, so code should check against 0 first.
- */
-static inline unsigned long __ffs(unsigned long word)
-{
-	__asm__("bsfl %1,%0"
-		:"=r" (word)
-		:"rm" (word));
-	return word;
-}
-
-/**
- * find_first_bit - find the first set bit in a memory region
- * @addr: The address to start the search at
- * @size: The maximum size to search
- *
- * Returns the bit number of the first set bit, not the number of the byte
- * containing a bit.
- */
-static inline unsigned find_first_bit(const unsigned long *addr, unsigned size)
-{
-	unsigned x = 0;
-
-	while (x < size) {
-		unsigned long val = *addr++;
-		if (val)
-			return __ffs(val) + x;
-		x += sizeof(*addr) << 3;
-	}
-	return x;
-}
-
-/**
- * find_next_bit - find the first set bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bit number to start searching at
- * @size: The maximum size to search
- */
-int find_next_bit(const unsigned long *addr, int size, int offset);
-
-/**
- * ffz - find first zero in word.
- * @word: The word to search
- *
- * Undefined if no zero exists, so code should check against ~0UL first.
- */
-static inline unsigned long ffz(unsigned long word)
-{
-	__asm__("bsfl %1,%0"
-		:"=r" (word)
-		:"r" (~word));
-	return word;
-}
-
-#ifdef __KERNEL__
-
-#include <asm-generic/bitops/sched.h>
-
-/**
- * ffs - find first bit set
- * @x: the word to search
- *
- * This is defined the same way as
- * the libc and compiler builtin ffs routines, therefore
- * differs in spirit from the above ffz() (man ffs).
- */
-static inline int ffs(int x)
-{
-	int r;
-
-	__asm__("bsfl %1,%0\n\t"
-		"jnz 1f\n\t"
-		"movl $-1,%0\n"
-		"1:" : "=r" (r) : "rm" (x));
-	return r+1;
-}
-
-/**
- * fls - find last bit set
- * @x: the word to search
- *
- * This is defined the same way as ffs().
- */
-static inline int fls(int x)
-{
-	int r;
-
-	__asm__("bsrl %1,%0\n\t"
-		"jnz 1f\n\t"
-		"movl $-1,%0\n"
-		"1:" : "=r" (r) : "rm" (x));
-	return r+1;
-}
-
-#include <asm-generic/bitops/hweight.h>
-
-#endif /* __KERNEL__ */
-
-#include <asm-generic/bitops/fls64.h>
-
-#ifdef __KERNEL__
-
-#include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(lock, nr, addr)			\
-	test_and_set_bit((nr), (unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock, nr, addr)			\
-	test_and_clear_bit((nr), (unsigned long *)(addr))
-
-#include <asm-generic/bitops/minix.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* _I386_BITOPS_H */
diff --git a/include/asm-x86/bitops_64.h b/include/asm-x86/bitops_64.h
deleted file mode 100644
index 365f820..0000000
--- a/include/asm-x86/bitops_64.h
+++ /dev/null
@@ -1,162 +0,0 @@
-#ifndef _X86_64_BITOPS_H
-#define _X86_64_BITOPS_H
-
-/*
- * Copyright 1992, Linus Torvalds.
- */
-
-extern long find_first_zero_bit(const unsigned long *addr, unsigned long size);
-extern long find_next_zero_bit(const unsigned long *addr, long size, long offset);
-extern long find_first_bit(const unsigned long *addr, unsigned long size);
-extern long find_next_bit(const unsigned long *addr, long size, long offset);
-
-/* return index of first bet set in val or max when no bit is set */
-static inline long __scanbit(unsigned long val, unsigned long max)
-{
-	asm("bsfq %1,%0 ; cmovz %2,%0" : "=&r" (val) : "r" (val), "r" (max));
-	return val;
-}
-
-#define find_next_bit(addr,size,off) \
-((__builtin_constant_p(size) && (size) <= BITS_PER_LONG ? 	  \
-  ((off) + (__scanbit((*(unsigned long *)addr) >> (off),(size)-(off)))) : \
-	find_next_bit(addr,size,off)))
-
-#define find_next_zero_bit(addr,size,off) \
-((__builtin_constant_p(size) && (size) <= BITS_PER_LONG ? 	  \
-  ((off)+(__scanbit(~(((*(unsigned long *)addr)) >> (off)),(size)-(off)))) : \
-	find_next_zero_bit(addr,size,off)))
-
-#define find_first_bit(addr, size)					\
-	((__builtin_constant_p((size)) && (size) <= BITS_PER_LONG	\
-	  ? (__scanbit(*(unsigned long *)(addr), (size)))		\
-	  : find_first_bit((addr), (size))))
-
-#define find_first_zero_bit(addr, size)					\
-	((__builtin_constant_p((size)) && (size) <= BITS_PER_LONG	\
-	  ? (__scanbit(~*(unsigned long *)(addr), (size)))		\
-	  : find_first_zero_bit((addr), (size))))
-
-static inline void set_bit_string(unsigned long *bitmap, unsigned long i,
-				  int len)
-{
-	unsigned long end = i + len;
-	while (i < end) {
-		__set_bit(i, bitmap);
-		i++;
-	}
-}
-
-/**
- * ffz - find first zero in word.
- * @word: The word to search
- *
- * Undefined if no zero exists, so code should check against ~0UL first.
- */
-static inline unsigned long ffz(unsigned long word)
-{
-	__asm__("bsfq %1,%0"
-		:"=r" (word)
-		:"r" (~word));
-	return word;
-}
-
-/**
- * __ffs - find first bit in word.
- * @word: The word to search
- *
- * Undefined if no bit exists, so code should check against 0 first.
- */
-static inline unsigned long __ffs(unsigned long word)
-{
-	__asm__("bsfq %1,%0"
-		:"=r" (word)
-		:"rm" (word));
-	return word;
-}
-
-/*
- * __fls: find last bit set.
- * @word: The word to search
- *
- * Undefined if no zero exists, so code should check against ~0UL first.
- */
-static inline unsigned long __fls(unsigned long word)
-{
-	__asm__("bsrq %1,%0"
-		:"=r" (word)
-		:"rm" (word));
-	return word;
-}
-
-#ifdef __KERNEL__
-
-#include <asm-generic/bitops/sched.h>
-
-/**
- * ffs - find first bit set
- * @x: the word to search
- *
- * This is defined the same way as
- * the libc and compiler builtin ffs routines, therefore
- * differs in spirit from the above ffz (man ffs).
- */
-static inline int ffs(int x)
-{
-	int r;
-
-	__asm__("bsfl %1,%0\n\t"
-		"cmovzl %2,%0" 
-		: "=r" (r) : "rm" (x), "r" (-1));
-	return r+1;
-}
-
-/**
- * fls64 - find last bit set in 64 bit word
- * @x: the word to search
- *
- * This is defined the same way as fls.
- */
-static inline int fls64(__u64 x)
-{
-	if (x == 0)
-		return 0;
-	return __fls(x) + 1;
-}
-
-/**
- * fls - find last bit set
- * @x: the word to search
- *
- * This is defined the same way as ffs.
- */
-static inline int fls(int x)
-{
-	int r;
-
-	__asm__("bsrl %1,%0\n\t"
-		"cmovzl %2,%0"
-		: "=&r" (r) : "rm" (x), "rm" (-1));
-	return r+1;
-}
-
-#define ARCH_HAS_FAST_MULTIPLIER 1
-
-#include <asm-generic/bitops/hweight.h>
-
-#endif /* __KERNEL__ */
-
-#ifdef __KERNEL__
-
-#include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(lock, nr, addr)			\
-	test_and_set_bit((nr), (unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock, nr, addr)			\
-	test_and_clear_bit((nr), (unsigned long *)(addr))
-
-#include <asm-generic/bitops/minix.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* _X86_64_BITOPS_H */
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 40d5473..48bde60 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -112,4 +112,144 @@ static inline unsigned fls_long(unsigned long l)
 	return fls64(l);
 }
 
+#ifdef __KERNEL__
+#ifdef CONFIG_GENERIC_FIND_FIRST_BIT
+extern unsigned long __find_first_bit(const unsigned long *addr,
+		unsigned long size);
+
+/**
+ * find_first_bit - find the first set bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum size to search
+ *
+ * Returns the bit number of the first set bit.
+ */
+static __always_inline unsigned long
+find_first_bit(const unsigned long *addr, unsigned long size)
+{
+	/* Avoid a function call if the bitmap size is a constant */
+	/* and not bigger than BITS_PER_LONG. */
+
+	/* insert a sentinel so that __ffs returns size if there */
+	/* are no set bits in the bitmap */
+	if (__builtin_constant_p(size) && (size < BITS_PER_LONG))
+		return __ffs((*addr) | (1ul << size));
+
+	/* the result of __ffs(0) is undefined, so it needs to be */
+	/* handled separately */
+	if (__builtin_constant_p(size) && (size == BITS_PER_LONG))
+		return ((*addr) == 0) ? BITS_PER_LONG : __ffs(*addr);
+
+	/* size is not constant or too big */
+	return __find_first_bit(addr, size);
+}
+
+extern unsigned long __find_first_zero_bit(const unsigned long *addr,
+		unsigned long size);
+
+/**
+ * find_first_zero_bit - find the first cleared bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum size to search
+ *
+ * Returns the bit number of the first cleared bit.
+ */
+static __always_inline unsigned long
+find_first_zero_bit(const unsigned long *addr, unsigned long size)
+{
+	/* Avoid a function call if the bitmap size is a constant */
+	/* and not bigger than BITS_PER_LONG. */
+
+	/* insert a sentinel so that __ffs returns size if there */
+	/* are no set bits in the bitmap */
+	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
+		return __ffs(~(*addr) | (1ul << size));
+	}
+
+	/* the result of __ffs(0) is undefined, so it needs to be */
+	/* handled separately */
+	if (__builtin_constant_p(size) && (size == BITS_PER_LONG))
+		return (~(*addr) == 0) ? BITS_PER_LONG : __ffs(~(*addr));
+
+	/* size is not constant or too big */
+	return __find_first_zero_bit(addr, size);
+}
+#endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
+
+#ifdef CONFIG_GENERIC_FIND_NEXT_BIT
+extern unsigned long __find_next_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset);
+
+/**
+ * find_next_bit - find the next set bit in a memory region
+ * @addr: The address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The bitmap size in bits
+ */
+static __always_inline unsigned long
+find_next_bit(const unsigned long *addr, unsigned long size,
+		unsigned long offset)
+{
+	unsigned long value;
+
+	/* Avoid a function call if the bitmap size is a constant */
+	/* and not bigger than BITS_PER_LONG. */
+
+	/* insert a sentinel so that __ffs returns size if there */
+	/* are no set bits in the bitmap */
+	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
+		value = (*addr) & ((~0ul) << offset);
+		value |= (1ul << size);
+		return __ffs(value);
+	}
+
+	/* the result of __ffs(0) is undefined, so it needs to be */
+	/* handled separately */
+	if (__builtin_constant_p(size) && (size == BITS_PER_LONG)) {
+		value = (*addr) & ((~0ul) << offset);
+		return (value == 0) ? BITS_PER_LONG : __ffs(value);
+	}
+
+	/* size is not constant or too big */
+	return __find_next_bit(addr, size, offset);
+}
+
+extern unsigned long __find_next_zero_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset);
+
+/**
+ * find_next_zero_bit - find the next cleared bit in a memory region
+ * @addr: The address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The bitmap size in bits
+ */
+static __always_inline unsigned long
+find_next_zero_bit(const unsigned long *addr, unsigned long size,
+		unsigned long offset)
+{
+	unsigned long value;
+
+	/* Avoid a function call if the bitmap size is a constant */
+	/* and not bigger than BITS_PER_LONG. */
+
+	/* insert a sentinel so that __ffs returns size if there */
+	/* are no set bits in the bitmap */
+	if (__builtin_constant_p(size) && (size < BITS_PER_LONG)) {
+		value = (~(*addr)) & ((~0ul) << offset);
+		value |= (1ul << size);
+		return __ffs(value);
+	}
+
+	/* the result of __ffs(0) is undefined, so it needs to be */
+	/* handled separately */
+	if (__builtin_constant_p(size) && (size == BITS_PER_LONG)) {
+		value = (~(*addr)) & ((~0ul) << offset);
+		return (value == 0) ? BITS_PER_LONG : __ffs(value);
+	}
+
+	/* size is not constant or too big */
+	return __find_next_zero_bit(addr, size, offset);
+}
+#endif /* CONFIG_GENERIC_FIND_NEXT_BIT */
+#endif /* __KERNEL__ */
 #endif
diff --git a/lib/Kconfig b/lib/Kconfig
index 2d53dc0..8cc8e87 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -7,6 +7,12 @@ menu "Library routines"
 config BITREVERSE
 	tristate
 
+config GENERIC_FIND_FIRST_BIT
+	def_bool n
+
+config GENERIC_FIND_NEXT_BIT
+	def_bool n
+
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
diff --git a/lib/Makefile b/lib/Makefile
index bf8000f..2d7001b 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
+lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
diff --git a/lib/find_next_bit.c b/lib/find_next_bit.c
index 78ccd73..d3f5784 100644
--- a/lib/find_next_bit.c
+++ b/lib/find_next_bit.c
@@ -16,14 +16,12 @@
 
 #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
 
-/**
- * find_next_bit - find the next set bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The maximum size to search
+#ifdef CONFIG_GENERIC_FIND_NEXT_BIT
+/*
+ * Find the next set bit in a memory region.
  */
-unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
-		unsigned long offset)
+unsigned long __find_next_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset)
 {
 	const unsigned long *p = addr + BITOP_WORD(offset);
 	unsigned long result = offset & ~(BITS_PER_LONG-1);
@@ -60,15 +58,14 @@ found_first:
 found_middle:
 	return result + __ffs(tmp);
 }
-
-EXPORT_SYMBOL(find_next_bit);
+EXPORT_SYMBOL(__find_next_bit);
 
 /*
  * This implementation of find_{first,next}_zero_bit was stolen from
  * Linus' asm-alpha/bitops.h.
  */
-unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
-		unsigned long offset)
+unsigned long __find_next_zero_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset)
 {
 	const unsigned long *p = addr + BITOP_WORD(offset);
 	unsigned long result = offset & ~(BITS_PER_LONG-1);
@@ -105,8 +102,64 @@ found_first:
 found_middle:
 	return result + ffz(tmp);
 }
+EXPORT_SYMBOL(__find_next_zero_bit);
+#endif /* CONFIG_GENERIC_FIND_NEXT_BIT */
+
+#ifdef CONFIG_GENERIC_FIND_FIRST_BIT
+/*
+ * Find the first set bit in a memory region.
+ */
+unsigned long __find_first_bit(const unsigned long *addr,
+		unsigned long size)
+{
+	const unsigned long *p = addr;
+	unsigned long result = 0;
+	unsigned long tmp;
 
-EXPORT_SYMBOL(find_next_zero_bit);
+	while (size & ~(BITS_PER_LONG-1)) {
+		if ((tmp = *(p++)))
+			goto found;
+		result += BITS_PER_LONG;
+		size -= BITS_PER_LONG;
+	}
+	if (!size)
+		return result;
+
+	tmp = (*p) & (~0UL >> (BITS_PER_LONG - size));
+	if (tmp == 0UL)		/* Are any bits set? */
+		return result + size;	/* Nope. */
+found:
+	return result + __ffs(tmp);
+}
+EXPORT_SYMBOL(__find_first_bit);
+
+/*
+ * Find the first cleared bit in a memory region.
+ */
+unsigned long __find_first_zero_bit(const unsigned long *addr,
+		unsigned long size)
+{
+	const unsigned long *p = addr;
+	unsigned long result = 0;
+	unsigned long tmp;
+
+	while (size & ~(BITS_PER_LONG-1)) {
+		if (~(tmp = *(p++)))
+			goto found;
+		result += BITS_PER_LONG;
+		size -= BITS_PER_LONG;
+	}
+	if (!size)
+		return result;
+
+	tmp = (*p) | (~0UL << size);
+	if (tmp == ~0UL)	/* Are any bits zero? */
+		return result + size;	/* Nope. */
+found:
+	return result + ffz(tmp);
+}
+EXPORT_SYMBOL(__find_first_zero_bit);
+#endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifdef __BIG_ENDIAN
 
