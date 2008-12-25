Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbYLYNlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbYLYNlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 08:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYLYNlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 08:41:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50733 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbYLYNk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 08:40:58 -0500
Date: Thu, 25 Dec 2008 14:40:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [git pull] kmemcheck for v2.6.29
Message-ID: <20081225134030.GA12665@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Linus,

the kmemcheck-for-linus git tree can be pulled from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git kmemcheck-for-linus

Kmemcheck has been more than a year in the making and it narrowly missed 
the last merge window. Kmemcheck is a high-runtime-cost debug feature, but 
it is able to catch subtle bugs that no other debug mechanism can catch.

"git log v2.6.28 | grep -i kmemcheck" shows a couple of cases where 
kmemcheck caught real upstream bugs. (which is pretty good IMO, despite 
its understandably narrow testing exposure so far. There are a few more 
fixes as well where kmemcheck pointed out a bug but it did not get 
credited in the changelog.)

You had reservations about kmemcheck's complexity in the past - if the 
current complexity and track record looks more acceptable then please 
consider this version for inclusion. It has the acks of the SLAB folks and 
the x86 maintainers are happy with it too.

 Thanks,

	Ingo

------------------>
Ingo Molnar (2):
      kmemcheck: export kmemcheck_mark_initialized
      kmemcheck: build fix

Pekka Enberg (5):
      x86: __show_registers() and __show_regs() API unification
      slab: move struct kmem_cache to headers
      kmemcheck: add Vegard and Pekka to MAINTAINERS
      x86: add hooks for kmemcheck on x86_64
      slab: add hooks for kmemcheck

Randy Dunlap (1):
      kmemcheck: include module.h to prevent warnings

Vegard Nossum (39):
      x86: add save_stack_trace_bp() for tracing from a specific stack frame
      stacktrace: add forward-declaration struct task_struct
      tasklets: new tasklet scheduling function
      kmemcheck: add the kmemcheck core
      x86: add hooks for kmemcheck
      kmemcheck: add mm functions
      slub: add hooks for kmemcheck
      kmemcheck: enable in the x86 Kconfig
      kmemcheck: fix sparse warnings
      softirq: raise the right softirq
      kmemcheck: use the proper comment style
      kmemcheck: fix use of uninitialized spinlock
      kmemcheck: constrain tracking to non-debugged caches
      kmemcheck: mark SMP support BROKEN
      kmemcheck: use capital Y/N in kconfig help-texts
      kmemcheck: remove unnecessary tests in the slab allocator
      kmemcheck: add DMA hooks
      kmemcheck: work with sizes in terms of bytes instead of bits
      kmemcheck: allow memory accesses that cross page boundaries
      kmemcheck: add some more documentation
      kmemcheck: add some comments
      kmemcheck: save memory contents on use of uninitialized memory
      kmemcheck: implement REP MOVS/STOS emulation
      kmemcheck: hide/show pages in each iteration of a REP instruction
      kmemcheck: rip out the optimized memset()
      kmemcheck: rip out SMP code
      kmemcheck: hide/show pages in each iteration of a REP instruction #2
      kmemcheck: lazy checking for MOVS instructions
      Revert "kmemcheck: use set_memory_4k() instead of disabling PSE"
      x86: use REP MOVS instruction for memcpy if kmemcheck is enabled
      kmemcheck: use set_memory_4k() on x86_64 only
      kmemcheck: fix crash in PnP BIOS calls
      kmemcheck: tag warning printks
      kmemcheck: (finally) use 4k pages for identity mapping
      x86: fix mis-merge
      kmemcheck: fix mis-merge in sysctl table
      kmemcheck: update documentation
      kmemcheck: update Kconfig help text
      kmemcheck: document the shadow member of struct page


 Documentation/kmemcheck.txt        |  129 ++++++
 MAINTAINERS                        |    8 +
 arch/x86/Kconfig.debug             |   88 +++++
 arch/x86/Makefile                  |    5 +
 arch/x86/include/asm/dma-mapping.h |    2 +
 arch/x86/include/asm/pgtable.h     |    4 +-
 arch/x86/include/asm/pgtable_32.h  |    6 +
 arch/x86/include/asm/pgtable_64.h  |    6 +
 arch/x86/include/asm/string_32.h   |    8 +
 arch/x86/include/asm/string_64.h   |    8 +
 arch/x86/kernel/head_32.S          |    2 +-
 arch/x86/kernel/process.c          |    2 +-
 arch/x86/kernel/stacktrace.c       |    7 +
 arch/x86/kernel/traps.c            |    5 +
 arch/x86/mm/Makefile               |    2 +
 arch/x86/mm/fault.c                |   18 +-
 arch/x86/mm/init_32.c              |    4 +-
 arch/x86/mm/init_64.c              |    2 +-
 arch/x86/mm/kmemcheck/Makefile     |    1 +
 arch/x86/mm/kmemcheck/error.c      |  229 +++++++++++
 arch/x86/mm/kmemcheck/error.h      |   15 +
 arch/x86/mm/kmemcheck/kmemcheck.c  |  752 ++++++++++++++++++++++++++++++++++++
 arch/x86/mm/kmemcheck/opcode.c     |   90 +++++
 arch/x86/mm/kmemcheck/opcode.h     |   10 +
 arch/x86/mm/kmemcheck/pte.c        |   22 +
 arch/x86/mm/kmemcheck/pte.h        |   10 +
 arch/x86/mm/kmemcheck/shadow.c     |  124 ++++++
 arch/x86/mm/kmemcheck/shadow.h     |   16 +
 include/asm-x86/kmemcheck.h        |   42 ++
 include/linux/gfp.h                |    3 +-
 include/linux/interrupt.h          |   14 +
 include/linux/kmemcheck.h          |   86 ++++
 include/linux/mm_types.h           |    8 +
 include/linux/slab.h               |    7 +
 include/linux/slab_def.h           |   81 ++++
 include/linux/stacktrace.h         |    3 +
 init/main.c                        |    4 +
 kernel/fork.c                      |   16 +-
 kernel/softirq.c                   |   11 +
 kernel/sysctl.c                    |   11 +
 mm/Makefile                        |    1 +
 mm/kmemcheck.c                     |  103 +++++
 mm/slab.c                          |  101 +----
 mm/slub.c                          |   20 +-
 44 files changed, 1982 insertions(+), 104 deletions(-)
 create mode 100644 Documentation/kmemcheck.txt
 create mode 100644 arch/x86/mm/kmemcheck/Makefile
 create mode 100644 arch/x86/mm/kmemcheck/error.c
 create mode 100644 arch/x86/mm/kmemcheck/error.h
 create mode 100644 arch/x86/mm/kmemcheck/kmemcheck.c
 create mode 100644 arch/x86/mm/kmemcheck/opcode.c
 create mode 100644 arch/x86/mm/kmemcheck/opcode.h
 create mode 100644 arch/x86/mm/kmemcheck/pte.c
 create mode 100644 arch/x86/mm/kmemcheck/pte.h
 create mode 100644 arch/x86/mm/kmemcheck/shadow.c
 create mode 100644 arch/x86/mm/kmemcheck/shadow.h
 create mode 100644 include/asm-x86/kmemcheck.h
 create mode 100644 include/linux/kmemcheck.h
 create mode 100644 mm/kmemcheck.c

diff --git a/Documentation/kmemcheck.txt b/Documentation/kmemcheck.txt
new file mode 100644
index 0000000..a848d49
--- /dev/null
+++ b/Documentation/kmemcheck.txt
@@ -0,0 +1,129 @@
+Contents
+========
+
+  1. How to use
+  2. Technical description
+  3. Changes to the slab allocators
+  4. Problems
+  5. Parameters
+  6. Future enhancements
+
+
+How to use (IMPORTANT)
+======================
+
+Always remember this: kmemcheck _will_ give false positives. So don't enable
+it and spam the mailing list with its reports; you are not going to be heard,
+and it will make people's skins thicker for when the real errors are found.
+
+Instead, I encourage maintainers and developers to find errors in _their_
+_own_ code. And if you find false positives, you can try to work around them,
+try to figure out if it's a real bug or not, or simply ignore them. Most
+developers know their own code and will quickly and efficiently determine the
+root cause of a kmemcheck report. This is therefore also the most efficient
+way to work with kmemcheck.
+
+If you still want to run kmemcheck to inspect others' code, the rule of thumb
+should be: If it's not obvious (to you), don't tell us about it either. Most
+likely the code is correct and you'll only waste our time. If you can work
+out the error, please do send the maintainer a heads up and/or a patch, but
+don't expect him/her to fix something that wasn't wrong in the first place.
+
+
+Technical description
+=====================
+
+kmemcheck works by marking memory pages non-present. This means that whenever
+somebody attempts to access the page, a page fault is generated. The page
+fault handler notices that the page was in fact only hidden, and so it calls
+on the kmemcheck code to make further investigations.
+
+When the investigations are completed, kmemcheck "shows" the page by marking
+it present (as it would be under normal circumstances). This way, the
+interrupted code can continue as usual.
+
+But after the instruction has been executed, we should hide the page again, so
+that we can catch the next access too! Now kmemcheck makes use of a debugging
+feature of the processor, namely single-stepping. When the processor has
+finished the one instruction that generated the memory access, a debug
+exception is raised. From here, we simply hide the page again and continue
+execution, this time with the single-stepping feature turned off.
+
+
+Changes to the slab allocators
+==============================
+
+kmemcheck requires some assistance from the memory allocator in order to work.
+The memory allocator needs to
+
+1. Tell kmemcheck about newly allocated pages and pages that are about to
+   be freed. This allows kmemcheck to set up and tear down the shadow memory
+   for the pages in question. The shadow memory stores the status of each byte
+   in the allocation proper, e.g. whether it is initialized or uninitialized.
+2. Tell kmemcheck which parts of memory should be marked uninitialized. There
+   are actually a few more states, such as "not yet allocated" and "recently
+   freed".
+
+If a slab cache is set up using the SLAB_NOTRACK flag, it will never return
+memory that can take page faults because of kmemcheck.
+
+If a slab cache is NOT set up using the SLAB_NOTRACK flag, callers can still
+request memory with the __GFP_NOTRACK flag. This does not prevent the page
+faults from occurring, however, but marks the object in question as being
+initialized so that no warnings will ever be produced for this object.
+
+Currently, the SLAB and SLUB allocators are supported by kmemcheck.
+
+
+Problems
+========
+
+The most prominent problem seems to be that of bit-fields. kmemcheck can only
+track memory with byte granularity. Therefore, when gcc generates code to
+access only one bit in a bit-field, there is really no way for kmemcheck to
+know which of the other bits will be used or thrown away. Consequently, there
+may be bogus warnings for bit-field accesses. We have added a "bitfields" API
+to get around this problem. See include/linux/kmemcheck.h for detailed
+instructions!
+
+
+Parameters
+==========
+
+In addition to enabling CONFIG_KMEMCHECK before the kernel is compiled, the
+parameter kmemcheck=1 must be passed to the kernel when it is started in order
+to actually do the tracking. So by default, there is only a very small
+(probably negligible) overhead for enabling the config option.
+
+Similarly, kmemcheck may be turned on or off at run-time using, respectively:
+
+echo 1 > /proc/sys/kernel/kmemcheck
+	and
+echo 0 > /proc/sys/kernel/kmemcheck
+
+Note that this is a lazy setting; once turned off, the old allocations will
+still have to take a single page fault exception before tracking is turned off
+for that particular page. Enabling kmemcheck on will only enable tracking for
+allocations made from that point onwards.
+
+The default mode is the one-shot mode, where only the first error is reported
+before kmemcheck is disabled. This mode can be enabled by passing kmemcheck=2
+to the kernel at boot, or running
+
+echo 2 > /proc/sys/kernel/kmemcheck
+
+when the kernel is already running.
+
+
+Future enhancements
+===================
+
+There is already some preliminary support for catching use-after-free errors.
+What still needs to be done is delaying kfree() so that memory is not
+reallocated immediately after freeing it. [Suggested by Pekka Enberg.]
+
+It should be possible to allow SMP systems by duplicating the page tables for
+each processor in the system. This is probably extremely difficult, however.
+[Suggested by Ingo Molnar.]
+
+Support for instruction set extensions like XMM, SSE2, etc.
diff --git a/MAINTAINERS b/MAINTAINERS
index fbc8fa5..c9cc45b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2566,6 +2566,14 @@ M:	jason.wessel@windriver.com
 L:	kgdb-bugreport@lists.sourceforge.net
 S:	Maintained
 
+KMEMCHECK
+P:	Vegard Nossum
+M:	vegardno@ifi.uio.no
+P	Pekka Enberg
+M:	penberg@cs.helsinki.fi
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 KPROBES
 P:	Ananth N Mavinakayanahalli
 M:	ananth@in.ibm.com
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 2a3dfbd..73cc0d3 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -287,6 +287,94 @@ config DEFAULT_IO_DELAY_TYPE
 	default IO_DELAY_TYPE_NONE
 endif
 
+menuconfig KMEMCHECK
+	bool "kmemcheck: trap use of uninitialized memory"
+	depends on X86
+	depends on !X86_USE_3DNOW
+	depends on SLUB || (SLAB && !DEBUG_SLAB)
+	depends on !CC_OPTIMIZE_FOR_SIZE
+	depends on !DEBUG_PAGEALLOC
+	select FRAME_POINTER
+	select STACKTRACE
+	default n
+	help
+	  This option enables tracing of dynamically allocated kernel memory
+	  to see if memory is used before it has been given an initial value.
+	  Be aware that this requires half of your memory for bookkeeping and
+	  will insert extra code at *every* read and write to tracked memory
+	  thus slow down the kernel code (but user code is unaffected).
+
+	  The kernel may be started with kmemcheck=0 or kmemcheck=1 to disable
+	  or enable kmemcheck at boot-time. If the kernel is started with
+	  kmemcheck=0, the large memory and CPU overhead is not incurred.
+
+choice
+	prompt "kmemcheck: default mode at boot"
+	depends on KMEMCHECK
+	default KMEMCHECK_ONESHOT_BY_DEFAULT
+	help
+	  This option controls the default behaviour of kmemcheck when the
+	  kernel boots and no kmemcheck= parameter is given.
+
+config KMEMCHECK_DISABLED_BY_DEFAULT
+	bool "disabled"
+	depends on KMEMCHECK
+
+config KMEMCHECK_ENABLED_BY_DEFAULT
+	bool "enabled"
+	depends on KMEMCHECK
+
+config KMEMCHECK_ONESHOT_BY_DEFAULT
+	bool "one-shot"
+	depends on KMEMCHECK
+	help
+	  In one-shot mode, only the first error detected is reported before
+	  kmemcheck is disabled.
+
+endchoice
+
+config KMEMCHECK_QUEUE_SIZE
+	int "kmemcheck: error queue size"
+	depends on KMEMCHECK
+	default 64
+	help
+	  Select the maximum number of errors to store in the queue. Since
+	  errors can occur virtually anywhere and in any context, we need a
+	  temporary storage area which is guarantueed not to generate any
+	  other faults. The queue will be emptied as soon as a tasklet may
+	  be scheduled. If the queue is full, new error reports will be
+	  lost.
+
+config KMEMCHECK_SHADOW_COPY_SHIFT
+	int "kmemcheck: shadow copy size (5 => 32 bytes, 6 => 64 bytes)"
+	depends on KMEMCHECK
+	range 2 8
+	default 5
+	help
+	  Select the number of shadow bytes to save along with each entry of
+	  the queue. These bytes indicate what parts of an allocation are
+	  initialized, uninitialized, etc. and will be displayed when an
+	  error is detected to help the debugging of a particular problem.
+
+config KMEMCHECK_PARTIAL_OK
+	bool "kmemcheck: allow partially uninitialized memory"
+	depends on KMEMCHECK
+	default y
+	help
+	  This option works around certain GCC optimizations that produce
+	  32-bit reads from 16-bit variables where the upper 16 bits are
+	  thrown away afterwards. This may of course also hide some real
+	  bugs.
+
+config KMEMCHECK_BITOPS_OK
+	bool "kmemcheck: allow bit-field manipulation"
+	depends on KMEMCHECK
+	default n
+	help
+	  This option silences warnings that would be generated for bit-field
+	  accesses where not all the bits are initialized at the same time.
+	  This may also hide some real bugs.
+
 config DEBUG_BOOT_PARAMS
 	bool "Debug boot parameters"
 	depends on DEBUG_KERNEL
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index d1a47ad..1d33108 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -80,6 +80,11 @@ else
         KBUILD_CFLAGS += $(stackp-y)
 endif
 
+# Don't unroll struct assignments with kmemcheck enabled
+ifeq ($(CONFIG_KMEMCHECK),y)
+	KBUILD_CFLAGS += $(call cc-option,-fno-builtin-memcpy)
+endif
+
 # Stackpointer is addressed different for 32 bit and 64 bit x86
 sp-$(CONFIG_X86_32) := esp
 sp-$(CONFIG_X86_64) := rsp
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 097794f..ecf8eaf 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -6,6 +6,7 @@
  * documentation.
  */
 
+#include <linux/kmemcheck.h>
 #include <linux/scatterlist.h>
 #include <asm/io.h>
 #include <asm/swiotlb.h>
@@ -97,6 +98,7 @@ dma_map_single(struct device *hwdev, void *ptr, size_t size,
 	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
 	BUG_ON(!valid_dma_direction(direction));
+	kmemcheck_mark_initialized(ptr, size);
 	return ops->map_single(hwdev, virt_to_phys(ptr), size, direction);
 }
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index c012f3b..c1de422 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -16,7 +16,7 @@
 #define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
 #define _PAGE_BIT_UNUSED1	9	/* available for programmer */
 #define _PAGE_BIT_IOMAP		10	/* flag used to indicate IO mapping */
-#define _PAGE_BIT_UNUSED3	11
+#define _PAGE_BIT_HIDDEN	11	/* hidden by kmemcheck */
 #define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */
 #define _PAGE_BIT_SPECIAL	_PAGE_BIT_UNUSED1
 #define _PAGE_BIT_CPA_TEST	_PAGE_BIT_UNUSED1
@@ -33,7 +33,7 @@
 #define _PAGE_GLOBAL	(_AT(pteval_t, 1) << _PAGE_BIT_GLOBAL)
 #define _PAGE_UNUSED1	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED1)
 #define _PAGE_IOMAP	(_AT(pteval_t, 1) << _PAGE_BIT_IOMAP)
-#define _PAGE_UNUSED3	(_AT(pteval_t, 1) << _PAGE_BIT_UNUSED3)
+#define _PAGE_HIDDEN	(_AT(pteval_t, 1) << _PAGE_BIT_HIDDEN)
 #define _PAGE_PAT	(_AT(pteval_t, 1) << _PAGE_BIT_PAT)
 #define _PAGE_PAT_LARGE (_AT(pteval_t, 1) << _PAGE_BIT_PAT_LARGE)
 #define _PAGE_SPECIAL	(_AT(pteval_t, 1) << _PAGE_BIT_SPECIAL)
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index f9d5889..23f6447 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -87,6 +87,12 @@ extern unsigned long pg0[];
 
 #define pte_present(x)	((x).pte_low & (_PAGE_PRESENT | _PAGE_PROTNONE))
 
+#ifdef CONFIG_KMEMCHECK
+#define pte_hidden(x)	((x).pte_low & (_PAGE_HIDDEN))
+#else
+#define pte_hidden(x)	0
+#endif
+
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val((x)))
 #define pmd_present(x)	(pmd_val((x)) & _PAGE_PRESENT)
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 545a0e0..862b3ee 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -174,6 +174,12 @@ static inline int pmd_bad(pmd_t pmd)
 #define pte_none(x)	(!pte_val((x)))
 #define pte_present(x)	(pte_val((x)) & (_PAGE_PRESENT | _PAGE_PROTNONE))
 
+#ifdef CONFIG_KMEMCHECK
+#define pte_hidden(x)	(pte_val((x)) & (_PAGE_HIDDEN))
+#else
+#define pte_hidden(x)	0
+#endif
+
 #define pages_to_mb(x)	((x) >> (20 - PAGE_SHIFT))   /* FIXME: is this right? */
 
 /*
diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
index 0e0e3ba..c86f452 100644
--- a/arch/x86/include/asm/string_32.h
+++ b/arch/x86/include/asm/string_32.h
@@ -177,10 +177,18 @@ static inline void *__memcpy3d(void *to, const void *from, size_t len)
  *	No 3D Now!
  */
 
+#ifndef CONFIG_KMEMCHECK
 #define memcpy(t, f, n)				\
 	(__builtin_constant_p((n))		\
 	 ? __constant_memcpy((t), (f), (n))	\
 	 : __memcpy((t), (f), (n)))
+#else
+/*
+ * kmemcheck becomes very happy if we use the REP instructions unconditionally,
+ * because it means that we know both memory operands in advance.
+ */
+#define memcpy(t, f, n) __memcpy((t), (f), (n))
+#endif
 
 #endif
 
diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 2afe164..19e2c46 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -27,6 +27,7 @@ static __always_inline void *__inline_memcpy(void *to, const void *from, size_t
    function. */
 
 #define __HAVE_ARCH_MEMCPY 1
+#ifndef CONFIG_KMEMCHECK
 #if (__GNUC__ == 4 && __GNUC_MINOR__ >= 3) || __GNUC__ > 4
 extern void *memcpy(void *to, const void *from, size_t len);
 #else
@@ -42,6 +43,13 @@ extern void *__memcpy(void *to, const void *from, size_t len);
 	__ret;							\
 })
 #endif
+#else
+/*
+ * kmemcheck becomes very happy if we use the REP instructions unconditionally,
+ * because it means that we know both memory operands in advance.
+ */
+#define memcpy(dst, src, len) __inline_memcpy((dst), (src), (len))
+#endif
 
 #define __HAVE_ARCH_MEMSET
 void *memset(void *s, int c, size_t n);
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index e835b4e..eb7515c 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -60,7 +60,7 @@ LOW_PAGES = 1<<(32-PAGE_SHIFT_asm)
  * pagetables from above the 16MB DMA limit, so we'll have to set
  * up pagetables 16MB more (worst-case):
  */
-#ifdef CONFIG_DEBUG_PAGEALLOC
+#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
 LOW_PAGES = LOW_PAGES + 0x1000000
 #endif
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c622772..3468131 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -49,7 +49,7 @@ void arch_task_cache_init(void)
         task_xstate_cachep =
         	kmem_cache_create("task_xstate", xstate_size,
 				  __alignof__(union thread_xstate),
-				  SLAB_PANIC, NULL);
+				  SLAB_PANIC | SLAB_NOTRACK, NULL);
 }
 
 /*
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index a03e7f6..d1d850a 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -76,6 +76,13 @@ void save_stack_trace(struct stack_trace *trace)
 }
 EXPORT_SYMBOL_GPL(save_stack_trace);
 
+void save_stack_trace_bp(struct stack_trace *trace, unsigned long bp)
+{
+	dump_trace(current, NULL, NULL, bp, &save_stack_ops, trace);
+	if (trace->nr_entries < trace->max_entries)
+		trace->entries[trace->nr_entries++] = ULONG_MAX;
+}
+
 void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
 	dump_trace(tsk, NULL, NULL, 0, &save_stack_ops_nosched, trace);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 04d242a..47f6041 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -47,6 +47,7 @@
 #endif
 
 #include <asm/stacktrace.h>
+#include <asm/kmemcheck.h>
 #include <asm/processor.h>
 #include <asm/debugreg.h>
 #include <asm/atomic.h>
@@ -578,6 +579,10 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	get_debugreg(condition, 6);
 
+	/* Catch kmemcheck conditions first of all! */
+	if (condition & DR_STEP && kmemcheck_trap(regs))
+		return;
+
 	/*
 	 * The processor cleared BTF, so don't mark that we need it set.
 	 */
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index fea4565..7e4f4eb 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -8,6 +8,8 @@ obj-$(CONFIG_X86_PTDUMP)	+= dump_pagetables.o
 
 obj-$(CONFIG_HIGHMEM)		+= highmem_32.o
 
+obj-$(CONFIG_KMEMCHECK)		+= kmemcheck/
+
 obj-$(CONFIG_MMIOTRACE_HOOKS)	+= kmmio.o
 obj-$(CONFIG_MMIOTRACE)		+= mmiotrace.o
 mmiotrace-y			:= pf_in.o mmio-mod.o
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 31e8730..d85e075 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -34,6 +34,7 @@
 #include <asm/smp.h>
 #include <asm/tlbflush.h>
 #include <asm/proto.h>
+#include <asm/kmemcheck.h>
 #include <asm-generic/sections.h>
 #include <asm/traps.h>
 
@@ -601,6 +602,13 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 
 	si_code = SEGV_MAPERR;
 
+	/*
+	 * Detect and handle instructions that would cause a page fault for
+	 * both a tracked kernel page and a userspace page.
+	 */
+	if(kmemcheck_active(regs))
+		kmemcheck_hide(regs);
+
 	if (notify_page_fault(regs))
 		return;
 	if (unlikely(kmmio_fault(regs, address)))
@@ -624,9 +632,13 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 #else
 	if (unlikely(address >= TASK_SIZE64)) {
 #endif
-		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
-		    vmalloc_fault(address) >= 0)
-			return;
+		if (!(error_code & (PF_RSVD | PF_USER | PF_PROT))) {
+			if (vmalloc_fault(address) >= 0)
+				return;
+
+			if (kmemcheck_fault(regs, address, error_code))
+				return;
+		}
 
 		/* Can handle a stale RO->RW TLB */
 		if (spurious_fault(address, error_code))
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c483f42..8d4ed5a 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -120,7 +120,7 @@ static pte_t * __init one_page_table_init(pmd_t *pmd)
 		pte_t *page_table = NULL;
 
 		if (after_init_bootmem) {
-#ifdef CONFIG_DEBUG_PAGEALLOC
+#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
 			page_table = (pte_t *) alloc_bootmem_pages(PAGE_SIZE);
 #endif
 			if (!page_table)
@@ -824,7 +824,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	pgd_t *pgd_base = swapper_pg_dir;
 	unsigned long start_pfn, end_pfn;
 	unsigned long big_page_start;
-#ifdef CONFIG_DEBUG_PAGEALLOC
+#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
 	/*
 	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
 	 * This will simplify cpa(), which otherwise needs to support splitting
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 9db01db..49569de 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -689,7 +689,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (!after_bootmem)
 		init_gbpages();
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
+#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
 	/*
 	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
 	 * This will simplify cpa(), which otherwise needs to support splitting
diff --git a/arch/x86/mm/kmemcheck/Makefile b/arch/x86/mm/kmemcheck/Makefile
new file mode 100644
index 0000000..4666b7a
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/Makefile
@@ -0,0 +1 @@
+obj-y := error.o kmemcheck.o opcode.o pte.o shadow.o
diff --git a/arch/x86/mm/kmemcheck/error.c b/arch/x86/mm/kmemcheck/error.c
new file mode 100644
index 0000000..5ec9f5a
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/error.c
@@ -0,0 +1,229 @@
+#include <linux/interrupt.h>
+#include <linux/kdebug.h>
+#include <linux/kmemcheck.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/stacktrace.h>
+#include <linux/string.h>
+
+#include "error.h"
+#include "shadow.h"
+
+enum kmemcheck_error_type {
+	KMEMCHECK_ERROR_INVALID_ACCESS,
+	KMEMCHECK_ERROR_BUG,
+};
+
+#define SHADOW_COPY_SIZE (1 << CONFIG_KMEMCHECK_SHADOW_COPY_SHIFT)
+
+struct kmemcheck_error {
+	enum kmemcheck_error_type type;
+
+	union {
+		/* KMEMCHECK_ERROR_INVALID_ACCESS */
+		struct {
+			/* Kind of access that caused the error */
+			enum kmemcheck_shadow state;
+			/* Address and size of the erroneous read */
+			unsigned long	address;
+			unsigned int	size;
+		};
+	};
+
+	struct pt_regs		regs;
+	struct stack_trace	trace;
+	unsigned long		trace_entries[32];
+
+	/* We compress it to a char. */
+	unsigned char		shadow_copy[SHADOW_COPY_SIZE];
+	unsigned char		memory_copy[SHADOW_COPY_SIZE];
+};
+
+/*
+ * Create a ring queue of errors to output. We can't call printk() directly
+ * from the kmemcheck traps, since this may call the console drivers and
+ * result in a recursive fault.
+ */
+static struct kmemcheck_error error_fifo[CONFIG_KMEMCHECK_QUEUE_SIZE];
+static unsigned int error_count;
+static unsigned int error_rd;
+static unsigned int error_wr;
+static unsigned int error_missed_count;
+
+static struct kmemcheck_error *error_next_wr(void)
+{
+	struct kmemcheck_error *e;
+
+	if (error_count == ARRAY_SIZE(error_fifo)) {
+		++error_missed_count;
+		return NULL;
+	}
+
+	e = &error_fifo[error_wr];
+	if (++error_wr == ARRAY_SIZE(error_fifo))
+		error_wr = 0;
+	++error_count;
+	return e;
+}
+
+static struct kmemcheck_error *error_next_rd(void)
+{
+	struct kmemcheck_error *e;
+
+	if (error_count == 0)
+		return NULL;
+
+	e = &error_fifo[error_rd];
+	if (++error_rd == ARRAY_SIZE(error_fifo))
+		error_rd = 0;
+	--error_count;
+	return e;
+}
+
+static void do_wakeup(unsigned long);
+static DECLARE_TASKLET(kmemcheck_tasklet, &do_wakeup, 0);
+
+/*
+ * Save the context of an error report.
+ */
+void kmemcheck_error_save(enum kmemcheck_shadow state,
+	unsigned long address, unsigned int size, struct pt_regs *regs)
+{
+	static unsigned long prev_ip;
+
+	struct kmemcheck_error *e;
+	void *shadow_copy;
+	void *memory_copy;
+
+	/* Don't report several adjacent errors from the same EIP. */
+	if (regs->ip == prev_ip)
+		return;
+	prev_ip = regs->ip;
+
+	e = error_next_wr();
+	if (!e)
+		return;
+
+	e->type = KMEMCHECK_ERROR_INVALID_ACCESS;
+
+	e->state = state;
+	e->address = address;
+	e->size = size;
+
+	/* Save regs */
+	memcpy(&e->regs, regs, sizeof(*regs));
+
+	/* Save stack trace */
+	e->trace.nr_entries = 0;
+	e->trace.entries = e->trace_entries;
+	e->trace.max_entries = ARRAY_SIZE(e->trace_entries);
+	e->trace.skip = 0;
+	save_stack_trace_bp(&e->trace, regs->bp);
+
+	/* Round address down to nearest 16 bytes */
+	shadow_copy = kmemcheck_shadow_lookup(address
+		& ~(SHADOW_COPY_SIZE - 1));
+	BUG_ON(!shadow_copy);
+
+	memcpy(e->shadow_copy, shadow_copy, SHADOW_COPY_SIZE);
+
+	kmemcheck_show_addr(address);
+	memory_copy = (void *) (address & ~(SHADOW_COPY_SIZE - 1));
+	memcpy(e->memory_copy, memory_copy, SHADOW_COPY_SIZE);
+	kmemcheck_hide_addr(address);
+
+	tasklet_hi_schedule_first(&kmemcheck_tasklet);
+}
+
+/*
+ * Save the context of a kmemcheck bug.
+ */
+void kmemcheck_error_save_bug(struct pt_regs *regs)
+{
+	struct kmemcheck_error *e;
+
+	e = error_next_wr();
+	if (!e)
+		return;
+
+	e->type = KMEMCHECK_ERROR_BUG;
+
+	memcpy(&e->regs, regs, sizeof(*regs));
+
+	e->trace.nr_entries = 0;
+	e->trace.entries = e->trace_entries;
+	e->trace.max_entries = ARRAY_SIZE(e->trace_entries);
+	e->trace.skip = 1;
+	save_stack_trace(&e->trace);
+
+	tasklet_hi_schedule_first(&kmemcheck_tasklet);
+}
+
+void kmemcheck_error_recall(void)
+{
+	static const char *desc[] = {
+		[KMEMCHECK_SHADOW_UNALLOCATED]		= "unallocated",
+		[KMEMCHECK_SHADOW_UNINITIALIZED]	= "uninitialized",
+		[KMEMCHECK_SHADOW_INITIALIZED]		= "initialized",
+		[KMEMCHECK_SHADOW_FREED]		= "freed",
+	};
+
+	static const char short_desc[] = {
+		[KMEMCHECK_SHADOW_UNALLOCATED]		= 'a',
+		[KMEMCHECK_SHADOW_UNINITIALIZED]	= 'u',
+		[KMEMCHECK_SHADOW_INITIALIZED]		= 'i',
+		[KMEMCHECK_SHADOW_FREED]		= 'f',
+	};
+
+	struct kmemcheck_error *e;
+	unsigned int i;
+
+	e = error_next_rd();
+	if (!e)
+		return;
+
+	switch (e->type) {
+	case KMEMCHECK_ERROR_INVALID_ACCESS:
+		printk(KERN_ERR  "WARNING: kmemcheck: Caught %d-bit read "
+			"from %s memory (%p)\n",
+			8 * e->size, e->state < ARRAY_SIZE(desc) ?
+				desc[e->state] : "(invalid shadow state)",
+			(void *) e->address);
+
+		printk(KERN_INFO);
+		for (i = 0; i < SHADOW_COPY_SIZE; ++i)
+			printk("%02x", e->memory_copy[i]);
+		printk("\n");
+
+		printk(KERN_INFO);
+		for (i = 0; i < SHADOW_COPY_SIZE; ++i) {
+			if (e->shadow_copy[i] < ARRAY_SIZE(short_desc))
+				printk(" %c", short_desc[e->shadow_copy[i]]);
+			else
+				printk(" ?");
+		}
+		printk("\n");
+		printk(KERN_INFO "%*c\n", 2 + 2
+			* (int) (e->address & (SHADOW_COPY_SIZE - 1)), '^');
+		break;
+	case KMEMCHECK_ERROR_BUG:
+		printk(KERN_EMERG "ERROR: kmemcheck: Fatal error\n");
+		break;
+	}
+
+	__show_regs(&e->regs, 1);
+	print_stack_trace(&e->trace, 0);
+}
+
+static void do_wakeup(unsigned long data)
+{
+	while (error_count > 0)
+		kmemcheck_error_recall();
+
+	if (error_missed_count > 0) {
+		printk(KERN_WARNING "kmemcheck: Lost %d error reports because "
+			"the queue was too small\n", error_missed_count);
+		error_missed_count = 0;
+	}
+}
diff --git a/arch/x86/mm/kmemcheck/error.h b/arch/x86/mm/kmemcheck/error.h
new file mode 100644
index 0000000..0efc2e8
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/error.h
@@ -0,0 +1,15 @@
+#ifndef ARCH__X86__MM__KMEMCHECK__ERROR_H
+#define ARCH__X86__MM__KMEMCHECK__ERROR_H
+
+#include <linux/ptrace.h>
+
+#include "shadow.h"
+
+void kmemcheck_error_save(enum kmemcheck_shadow state,
+	unsigned long address, unsigned int size, struct pt_regs *regs);
+
+void kmemcheck_error_save_bug(struct pt_regs *regs);
+
+void kmemcheck_error_recall(void);
+
+#endif
diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
new file mode 100644
index 0000000..056b4f1
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -0,0 +1,752 @@
+/**
+ * kmemcheck - a heavyweight memory checker for the linux kernel
+ * Copyright (C) 2007, 2008  Vegard Nossum <vegardno@ifi.uio.no>
+ * (With a lot of help from Ingo Molnar and Pekka Enberg.)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2) as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kallsyms.h>
+#include <linux/kernel.h>
+#include <linux/kmemcheck.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/page-flags.h>
+#include <linux/percpu.h>
+#include <linux/ptrace.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include <asm/cacheflush.h>
+#include <asm/kmemcheck.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+
+#include "error.h"
+#include "opcode.h"
+#include "pte.h"
+#include "shadow.h"
+
+void __init kmemcheck_init(void)
+{
+	printk(KERN_INFO "kmemcheck: \"Bugs, beware!\"\n");
+
+#ifdef CONFIG_SMP
+	/*
+	 * Limit SMP to use a single CPU. We rely on the fact that this code
+	 * runs before SMP is set up.
+	 */
+	if (setup_max_cpus > 1) {
+		printk(KERN_INFO
+			"kmemcheck: Limiting number of CPUs to 1.\n");
+		setup_max_cpus = 1;
+	}
+#endif
+}
+
+#ifdef CONFIG_KMEMCHECK_DISABLED_BY_DEFAULT
+int kmemcheck_enabled = 0;
+#endif
+
+#ifdef CONFIG_KMEMCHECK_ENABLED_BY_DEFAULT
+int kmemcheck_enabled = 1;
+#endif
+
+#ifdef CONFIG_KMEMCHECK_ONESHOT_BY_DEFAULT
+int kmemcheck_enabled = 2;
+#endif
+
+/*
+ * We need to parse the kmemcheck= option before any memory is allocated.
+ */
+static int __init param_kmemcheck(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	sscanf(str, "%d", &kmemcheck_enabled);
+	return 0;
+}
+
+early_param("kmemcheck", param_kmemcheck);
+
+int kmemcheck_show_addr(unsigned long address)
+{
+	pte_t *pte;
+
+	pte = kmemcheck_pte_lookup(address);
+	if (!pte)
+		return 0;
+
+	set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
+	__flush_tlb_one(address);
+	return 1;
+}
+
+int kmemcheck_hide_addr(unsigned long address)
+{
+	pte_t *pte;
+
+	pte = kmemcheck_pte_lookup(address);
+	if (!pte)
+		return 0;
+
+	set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
+	__flush_tlb_one(address);
+	return 1;
+}
+
+struct kmemcheck_context {
+	bool busy;
+	int balance;
+
+	/*
+	 * There can be at most two memory operands to an instruction, but
+	 * each address can cross a page boundary -- so we may need up to
+	 * four addresses that must be hidden/revealed for each fault.
+	 */
+	unsigned long addr[4];
+	unsigned long n_addrs;
+	unsigned long flags;
+
+	/*
+	 * The address of the REP prefix if we are currently emulating a
+	 * REP instruction; otherwise 0.
+	 */
+	const uint8_t *rep;
+
+	/* The address of the REX prefix. */
+	const uint8_t *rex;
+
+	/* Address of the primary instruction opcode. */
+	const uint8_t *insn;
+
+	/* Data size of the instruction that caused a fault. */
+	unsigned int size;
+};
+
+static DEFINE_PER_CPU(struct kmemcheck_context, kmemcheck_context);
+
+bool kmemcheck_active(struct pt_regs *regs)
+{
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+
+	return data->balance > 0;
+}
+
+/* Save an address that needs to be shown/hidden */
+static void kmemcheck_save_addr(unsigned long addr)
+{
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+
+	data->addr[data->n_addrs++] = addr;
+
+	BUG_ON(data->n_addrs >= ARRAY_SIZE(data->addr));
+}
+
+static unsigned int kmemcheck_show_all(void)
+{
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	unsigned int i;
+	unsigned int n;
+
+	n = 0;
+	for (i = 0; i < data->n_addrs; ++i)
+		n += kmemcheck_show_addr(data->addr[i]);
+
+	return n;
+}
+
+static unsigned int kmemcheck_hide_all(void)
+{
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	unsigned int i;
+	unsigned int n;
+
+	n = 0;
+	for (i = 0; i < data->n_addrs; ++i)
+		n += kmemcheck_hide_addr(data->addr[i]);
+
+	return n;
+}
+
+/*
+ * Called from the #PF handler.
+ */
+void kmemcheck_show(struct pt_regs *regs)
+{
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+
+	BUG_ON(!irqs_disabled());
+
+	if (unlikely(data->balance != 0)) {
+		kmemcheck_show_all();
+		kmemcheck_error_save_bug(regs);
+		data->balance = 0;
+		return;
+	}
+
+	/*
+	 * None of the addresses actually belonged to kmemcheck. Note that
+	 * this is not an error.
+	 */
+	if (kmemcheck_show_all() == 0)
+		return;
+
+	++data->balance;
+
+	/*
+	 * The IF needs to be cleared as well, so that the faulting
+	 * instruction can run "uninterrupted". Otherwise, we might take
+	 * an interrupt and start executing that before we've had a chance
+	 * to hide the page again.
+	 *
+	 * NOTE: In the rare case of multiple faults, we must not override
+	 * the original flags:
+	 */
+	if (!(regs->flags & X86_EFLAGS_TF))
+		data->flags = regs->flags;
+
+	regs->flags |= X86_EFLAGS_TF;
+	regs->flags &= ~X86_EFLAGS_IF;
+}
+
+/*
+ * Called from the #DB handler.
+ */
+void kmemcheck_hide(struct pt_regs *regs)
+{
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	int n;
+
+	BUG_ON(!irqs_disabled());
+
+	if (data->balance == 0)
+		return;
+
+	if (unlikely(data->balance != 1)) {
+		kmemcheck_show_all();
+		kmemcheck_error_save_bug(regs);
+		data->n_addrs = 0;
+		data->balance = 0;
+
+		if (!(data->flags & X86_EFLAGS_TF))
+			regs->flags &= ~X86_EFLAGS_TF;
+		if (data->flags & X86_EFLAGS_IF)
+			regs->flags |= X86_EFLAGS_IF;
+		return;
+	}
+
+	if (data->rep) {
+		/* Save state and take it up later. */
+		regs->ip = (unsigned long) data->rep;
+		data->rep = NULL;
+	}
+
+	if (kmemcheck_enabled)
+		n = kmemcheck_hide_all();
+	else
+		n = kmemcheck_show_all();
+
+	if (n == 0)
+		return;
+
+	--data->balance;
+
+	data->n_addrs = 0;
+
+	if (!(data->flags & X86_EFLAGS_TF))
+		regs->flags &= ~X86_EFLAGS_TF;
+	if (data->flags & X86_EFLAGS_IF)
+		regs->flags |= X86_EFLAGS_IF;
+}
+
+void kmemcheck_show_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; ++i) {
+		unsigned long address;
+		pte_t *pte;
+		unsigned int level;
+
+		address = (unsigned long) page_address(&p[i]);
+		pte = lookup_address(address, &level);
+		BUG_ON(!pte);
+		BUG_ON(level != PG_LEVEL_4K);
+
+		set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
+		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_HIDDEN));
+		__flush_tlb_one(address);
+	}
+}
+
+bool kmemcheck_page_is_tracked(struct page *p)
+{
+	/* This will also check the "hidden" flag of the PTE. */
+	return kmemcheck_pte_lookup((unsigned long) page_address(p));
+}
+
+void kmemcheck_hide_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; ++i) {
+		unsigned long address;
+		pte_t *pte;
+		unsigned int level;
+
+		address = (unsigned long) page_address(&p[i]);
+		pte = lookup_address(address, &level);
+		BUG_ON(!pte);
+		BUG_ON(level != PG_LEVEL_4K);
+
+		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
+		set_pte(pte, __pte(pte_val(*pte) | _PAGE_HIDDEN));
+		__flush_tlb_one(address);
+	}
+}
+
+/* Access may NOT cross page boundary */
+static void kmemcheck_read_strict(struct pt_regs *regs,
+	unsigned long addr, unsigned int size)
+{
+	void *shadow;
+	enum kmemcheck_shadow status;
+
+	shadow = kmemcheck_shadow_lookup(addr);
+	if (!shadow)
+		return;
+
+	kmemcheck_save_addr(addr);
+	status = kmemcheck_shadow_test(shadow, size);
+	if (status == KMEMCHECK_SHADOW_INITIALIZED)
+		return;
+
+	if (kmemcheck_enabled)
+		kmemcheck_error_save(status, addr, size, regs);
+
+	if (kmemcheck_enabled == 2)
+		kmemcheck_enabled = 0;
+
+	/* Don't warn about it again. */
+	kmemcheck_shadow_set(shadow, size);
+}
+
+/* Access may cross page boundary */
+static void kmemcheck_read(struct pt_regs *regs,
+	unsigned long addr, unsigned int size)
+{
+	unsigned long page = addr & PAGE_MASK;
+	unsigned long next_addr = addr + size - 1;
+	unsigned long next_page = next_addr & PAGE_MASK;
+
+	if (likely(page == next_page)) {
+		kmemcheck_read_strict(regs, addr, size);
+		return;
+	}
+
+	/*
+	 * What we do is basically to split the access across the
+	 * two pages and handle each part separately. Yes, this means
+	 * that we may now see reads that are 3 + 5 bytes, for
+	 * example (and if both are uninitialized, there will be two
+	 * reports), but it makes the code a lot simpler.
+	 */
+	kmemcheck_read_strict(regs, addr, next_page - addr);
+	kmemcheck_read_strict(regs, next_page, next_addr - next_page);
+}
+
+static void kmemcheck_write_strict(struct pt_regs *regs,
+	unsigned long addr, unsigned int size)
+{
+	void *shadow;
+
+	shadow = kmemcheck_shadow_lookup(addr);
+	if (!shadow)
+		return;
+
+	kmemcheck_save_addr(addr);
+	kmemcheck_shadow_set(shadow, size);
+}
+
+static void kmemcheck_write(struct pt_regs *regs,
+	unsigned long addr, unsigned int size)
+{
+	unsigned long page = addr & PAGE_MASK;
+	unsigned long next_addr = addr + size - 1;
+	unsigned long next_page = next_addr & PAGE_MASK;
+
+	if (likely(page == next_page)) {
+		kmemcheck_write_strict(regs, addr, size);
+		return;
+	}
+
+	/* See comment in kmemcheck_read(). */
+	kmemcheck_write_strict(regs, addr, next_page - addr);
+	kmemcheck_write_strict(regs, next_page, next_addr - next_page);
+}
+
+/*
+ * Copying is hard. We have two addresses, each of which may be split across
+ * a page (and each page will have different shadow addresses).
+ */
+static void kmemcheck_copy(struct pt_regs *regs,
+	unsigned long src_addr, unsigned long dst_addr, unsigned int size)
+{
+	uint8_t shadow[8];
+	enum kmemcheck_shadow status;
+
+	unsigned long page;
+	unsigned long next_addr;
+	unsigned long next_page;
+
+	uint8_t *x;
+	unsigned int i;
+	unsigned int n;
+
+	BUG_ON(size > sizeof(shadow));
+
+	page = src_addr & PAGE_MASK;
+	next_addr = src_addr + size - 1;
+	next_page = next_addr & PAGE_MASK;
+
+	if (likely(page == next_page)) {
+		/* Same page */
+		x = kmemcheck_shadow_lookup(src_addr);
+		if (x) {
+			kmemcheck_save_addr(src_addr);
+			for (i = 0; i < size; ++i)
+				shadow[i] = x[i];
+		} else {
+			for (i = 0; i < size; ++i)
+				shadow[i] = KMEMCHECK_SHADOW_INITIALIZED;
+		}
+	} else {
+		n = next_page - src_addr;
+		BUG_ON(n > sizeof(shadow));
+
+		/* First page */
+		x = kmemcheck_shadow_lookup(src_addr);
+		if (x) {
+			kmemcheck_save_addr(src_addr);
+			for (i = 0; i < n; ++i)
+				shadow[i] = x[i];
+		} else {
+			/* Not tracked */
+			for (i = 0; i < n; ++i)
+				shadow[i] = KMEMCHECK_SHADOW_INITIALIZED;
+		}
+
+		/* Second page */
+		x = kmemcheck_shadow_lookup(next_page);
+		if (x) {
+			kmemcheck_save_addr(next_page);
+			for (i = n; i < size; ++i)
+				shadow[i] = x[i - n];
+		} else {
+			/* Not tracked */
+			for (i = n; i < size; ++i)
+				shadow[i] = KMEMCHECK_SHADOW_INITIALIZED;
+		}
+	}
+
+	page = dst_addr & PAGE_MASK;
+	next_addr = dst_addr + size - 1;
+	next_page = next_addr & PAGE_MASK;
+
+	if (likely(page == next_page)) {
+		/* Same page */
+		x = kmemcheck_shadow_lookup(dst_addr);
+		if (x) {
+			kmemcheck_save_addr(dst_addr);
+			for (i = 0; i < size; ++i) {
+				x[i] = shadow[i];
+				shadow[i] = KMEMCHECK_SHADOW_INITIALIZED;
+			}
+		}
+	} else {
+		n = next_page - dst_addr;
+		BUG_ON(n > sizeof(shadow));
+
+		/* First page */
+		x = kmemcheck_shadow_lookup(dst_addr);
+		if (x) {
+			kmemcheck_save_addr(dst_addr);
+			for (i = 0; i < n; ++i) {
+				x[i] = shadow[i];
+				shadow[i] = KMEMCHECK_SHADOW_INITIALIZED;
+			}
+		}
+
+		/* Second page */
+		x = kmemcheck_shadow_lookup(next_page);
+		if (x) {
+			kmemcheck_save_addr(next_page);
+			for (i = n; i < size; ++i) {
+				x[i - n] = shadow[i];
+				shadow[i] = KMEMCHECK_SHADOW_INITIALIZED;
+			}
+		}
+	}
+
+	status = kmemcheck_shadow_test(shadow, size);
+	if (status == KMEMCHECK_SHADOW_INITIALIZED)
+		return;
+
+	if (kmemcheck_enabled)
+		kmemcheck_error_save(status, src_addr, size, regs);
+
+	if (kmemcheck_enabled == 2)
+		kmemcheck_enabled = 0;
+}
+
+enum kmemcheck_method {
+	KMEMCHECK_READ,
+	KMEMCHECK_WRITE,
+};
+
+static void kmemcheck_access(struct pt_regs *regs,
+	unsigned long fallback_address, enum kmemcheck_method fallback_method)
+{
+	const uint8_t *rep_prefix;
+	const uint8_t *rex_prefix;
+	const uint8_t *insn;
+	const uint8_t *insn_primary;
+	unsigned int size;
+
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+
+	/* Recursive fault -- ouch. */
+	if (data->busy) {
+		kmemcheck_show_addr(fallback_address);
+		kmemcheck_error_save_bug(regs);
+		return;
+	}
+
+	data->busy = true;
+
+	insn = (const uint8_t *) regs->ip;
+	insn_primary = kmemcheck_opcode_get_primary(insn);
+
+	kmemcheck_opcode_decode(insn, &rep_prefix, &rex_prefix, &size);
+
+	if (rep_prefix && *rep_prefix == 0xf3) {
+		/*
+		 * Due to an incredibly silly Intel bug, REP MOVS and
+		 * REP STOS instructions may generate just one single-
+		 * stepping trap on Pentium 4 CPUs. Other CPUs, including
+		 * AMDs, seem to generate traps after each repetition.
+		 *
+		 * What we do is really a very ugly hack; we increment the
+		 * instruction pointer before returning so that the next
+		 * time around we'll hit an ordinary MOVS or STOS
+		 * instruction. Now, in the debug exception, we know that
+		 * the instruction is really a REP MOVS/STOS, so instead
+		 * of clearing the single-stepping flag, we just continue
+		 * single-stepping the instruction until we're done.
+		 *
+		 * We currently don't handle REP MOVS/STOS instructions
+		 * which have other (additional) instruction prefixes in
+		 * front of REP, so we BUG on those.
+		 */
+		switch (insn_primary[0]) {
+			/* REP MOVS */
+		case 0xa4:
+		case 0xa5:
+			BUG_ON(regs->ip != (unsigned long) rep_prefix);
+
+			kmemcheck_copy(regs, regs->si, regs->di, size);
+			data->rep = rep_prefix;
+			data->rex = rex_prefix;
+			data->insn = insn_primary;
+			data->size = size;
+			regs->ip = (unsigned long) data->rep + 1;
+			goto out;
+
+			/* REP STOS */
+		case 0xaa:
+		case 0xab:
+			BUG_ON(regs->ip != (unsigned long) rep_prefix);
+
+			kmemcheck_write(regs, regs->di, size);
+			data->rep = rep_prefix;
+			data->rex = rex_prefix;
+			data->insn = insn_primary;
+			data->size = size;
+			regs->ip = (unsigned long) data->rep + 1;
+			goto out;
+		}
+	}
+
+	switch (insn_primary[0]) {
+#ifdef CONFIG_KMEMCHECK_BITOPS_OK
+		/* AND, OR, XOR */
+		/*
+		 * Unfortunately, these instructions have to be excluded from
+		 * our regular checking since they access only some (and not
+		 * all) bits. This clears out "bogus" bitfield-access warnings.
+		 */
+	case 0x80:
+	case 0x81:
+	case 0x82:
+	case 0x83:
+		switch ((insn_primary[1] >> 3) & 7) {
+			/* OR */
+		case 1:
+			/* AND */
+		case 4:
+			/* XOR */
+		case 6:
+			kmemcheck_write(regs, fallback_address, size);
+			goto out;
+
+			/* ADD */
+		case 0:
+			/* ADC */
+		case 2:
+			/* SBB */
+		case 3:
+			/* SUB */
+		case 5:
+			/* CMP */
+		case 7:
+			break;
+		}
+		break;
+#endif
+
+		/* MOVS, MOVSB, MOVSW, MOVSD */
+	case 0xa4:
+	case 0xa5:
+		/*
+		 * These instructions are special because they take two
+		 * addresses, but we only get one page fault.
+		 */
+		kmemcheck_copy(regs, regs->si, regs->di, size);
+		goto out;
+
+		/* CMPS, CMPSB, CMPSW, CMPSD */
+	case 0xa6:
+	case 0xa7:
+		kmemcheck_read(regs, regs->si, size);
+		kmemcheck_read(regs, regs->di, size);
+		goto out;
+	}
+
+	/*
+	 * If the opcode isn't special in any way, we use the data from the
+	 * page fault handler to determine the address and type of memory
+	 * access.
+	 */
+	switch (fallback_method) {
+	case KMEMCHECK_READ:
+		kmemcheck_read(regs, fallback_address, size);
+		goto out;
+	case KMEMCHECK_WRITE:
+		kmemcheck_write(regs, fallback_address, size);
+		goto out;
+	}
+
+out:
+	data->busy = false;
+}
+
+bool kmemcheck_fault(struct pt_regs *regs, unsigned long address,
+	unsigned long error_code)
+{
+	pte_t *pte;
+	unsigned int level;
+
+	/*
+	 * XXX: Is it safe to assume that memory accesses from virtual 86
+	 * mode or non-kernel code segments will _never_ access kernel
+	 * memory (e.g. tracked pages)? For now, we need this to avoid
+	 * invoking kmemcheck for PnP BIOS calls.
+	 */
+	if (regs->flags & X86_VM_MASK)
+		return false;
+	if (regs->cs != __KERNEL_CS)
+		return false;
+
+	pte = lookup_address(address, &level);
+	if (!pte)
+		return false;
+	if (level != PG_LEVEL_4K)
+		return false;
+	if (!pte_hidden(*pte))
+		return false;
+
+	if (error_code & 2)
+		kmemcheck_access(regs, address, KMEMCHECK_WRITE);
+	else
+		kmemcheck_access(regs, address, KMEMCHECK_READ);
+
+	kmemcheck_show(regs);
+	return true;
+}
+
+bool kmemcheck_trap(struct pt_regs *regs)
+{
+	struct kmemcheck_context *data = &__get_cpu_var(kmemcheck_context);
+	unsigned long cx;
+#ifdef CONFIG_X86_64
+	uint32_t ecx;
+#endif
+
+	if (!kmemcheck_active(regs))
+		return false;
+
+	if (!data->rep) {
+		kmemcheck_hide(regs);
+		return true;
+	}
+
+	/*
+	 * We're emulating a REP MOVS/STOS instruction. Are we done yet?
+	 * Of course, 64-bit needs to handle CX/ECX/RCX differently...
+	 */
+#ifdef CONFIG_X86_64
+	if (data->rex && data->rex[0] & 0x08) {
+		cx = regs->cx - 1;
+		regs->cx = cx;
+	} else {
+		/* Without REX, 64-bit wants to use %ecx by default. */
+		ecx = regs->cx - 1;
+		cx = ecx;
+		regs->cx = (regs->cx & ~((1UL << 32) - 1)) | ecx;
+	}
+#else
+	cx = regs->cx - 1;
+	regs->cx = cx;
+#endif
+	if (cx) {
+		unsigned long rep = (unsigned long) data->rep;
+		kmemcheck_hide(regs);
+		/* Without the REP prefix, we have to do this ourselves... */
+		data->rep = (void *) rep;
+		regs->ip = rep + 1;
+
+		switch (data->insn[0]) {
+		case 0xa4:
+		case 0xa5:
+			kmemcheck_copy(regs, regs->si, regs->di, data->size);
+			break;
+		case 0xaa:
+		case 0xab:
+			kmemcheck_write(regs, regs->di, data->size);
+			break;
+		}
+
+		kmemcheck_show(regs);
+		return true;
+	}
+
+	/* We're done. */
+	kmemcheck_hide(regs);
+	return true;
+}
diff --git a/arch/x86/mm/kmemcheck/opcode.c b/arch/x86/mm/kmemcheck/opcode.c
new file mode 100644
index 0000000..88a9662
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/opcode.c
@@ -0,0 +1,90 @@
+#include <linux/types.h>
+
+#include "opcode.h"
+
+static bool opcode_is_prefix(uint8_t b)
+{
+	return
+		/* Group 1 */
+		b == 0xf0 || b == 0xf2 || b == 0xf3
+		/* Group 2 */
+		|| b == 0x2e || b == 0x36 || b == 0x3e || b == 0x26
+		|| b == 0x64 || b == 0x65 || b == 0x2e || b == 0x3e
+		/* Group 3 */
+		|| b == 0x66
+		/* Group 4 */
+		|| b == 0x67;
+}
+
+static bool opcode_is_rex_prefix(uint8_t b)
+{
+	return (b & 0xf0) == 0x40;
+}
+
+/*
+ * This is a VERY crude opcode decoder. We only need to find the size of the
+ * load/store that caused our #PF and this should work for all the opcodes
+ * that we care about. Moreover, the ones who invented this instruction set
+ * should be shot.
+ */
+void kmemcheck_opcode_decode(const uint8_t *op,
+	const uint8_t **rep_prefix, const uint8_t **rex_prefix,
+	unsigned int *size)
+{
+	/* Default operand size */
+	int operand_size_override = 4;
+
+	*rep_prefix = NULL;
+
+	/* prefixes */
+	for (; opcode_is_prefix(*op); ++op) {
+		if (*op == 0xf2 || *op == 0xf3)
+			*rep_prefix = op;
+		if (*op == 0x66)
+			operand_size_override = 2;
+	}
+
+	*rex_prefix = NULL;
+
+#ifdef CONFIG_X86_64
+	/* REX prefix */
+	if (opcode_is_rex_prefix(*op)) {
+		*rex_prefix = op;
+
+		if (*op & 0x08) {
+			*size = 8;
+			return;
+		}
+
+		++op;
+	}
+#endif
+
+	/* escape opcode */
+	if (*op == 0x0f) {
+		++op;
+
+		if (*op == 0xb6) {
+			*size = 1;
+			return;
+		}
+
+		if (*op == 0xb7) {
+			*size = 2;
+			return;
+		}
+	}
+
+	*size = (*op & 1) ? operand_size_override : 1;
+}
+
+const uint8_t *kmemcheck_opcode_get_primary(const uint8_t *op)
+{
+	/* skip prefixes */
+	while (opcode_is_prefix(*op))
+		++op;
+	if (opcode_is_rex_prefix(*op))
+		++op;
+	return op;
+}
+
diff --git a/arch/x86/mm/kmemcheck/opcode.h b/arch/x86/mm/kmemcheck/opcode.h
new file mode 100644
index 0000000..f744d8e
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/opcode.h
@@ -0,0 +1,10 @@
+#ifndef ARCH__X86__MM__KMEMCHECK__OPCODE_H
+#define ARCH__X86__MM__KMEMCHECK__OPCODE_H
+
+#include <linux/types.h>
+
+void kmemcheck_opcode_decode(const uint8_t *op,
+	const uint8_t **rep_pfx, const uint8_t **rex_pfx, unsigned int *size);
+const uint8_t *kmemcheck_opcode_get_primary(const uint8_t *op);
+
+#endif
diff --git a/arch/x86/mm/kmemcheck/pte.c b/arch/x86/mm/kmemcheck/pte.c
new file mode 100644
index 0000000..4ead26e
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/pte.c
@@ -0,0 +1,22 @@
+#include <linux/mm.h>
+
+#include <asm/pgtable.h>
+
+#include "pte.h"
+
+pte_t *kmemcheck_pte_lookup(unsigned long address)
+{
+	pte_t *pte;
+	unsigned int level;
+
+	pte = lookup_address(address, &level);
+	if (!pte)
+		return NULL;
+	if (level != PG_LEVEL_4K)
+		return NULL;
+	if (!pte_hidden(*pte))
+		return NULL;
+
+	return pte;
+}
+
diff --git a/arch/x86/mm/kmemcheck/pte.h b/arch/x86/mm/kmemcheck/pte.h
new file mode 100644
index 0000000..9f59664
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/pte.h
@@ -0,0 +1,10 @@
+#ifndef ARCH__X86__MM__KMEMCHECK__PTE_H
+#define ARCH__X86__MM__KMEMCHECK__PTE_H
+
+#include <linux/mm.h>
+
+#include <asm/pgtable.h>
+
+pte_t *kmemcheck_pte_lookup(unsigned long address);
+
+#endif
diff --git a/arch/x86/mm/kmemcheck/shadow.c b/arch/x86/mm/kmemcheck/shadow.c
new file mode 100644
index 0000000..196dddc
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/shadow.c
@@ -0,0 +1,124 @@
+#include <linux/kmemcheck.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+#include "pte.h"
+#include "shadow.h"
+
+/*
+ * Return the shadow address for the given address. Returns NULL if the
+ * address is not tracked.
+ *
+ * We need to be extremely careful not to follow any invalid pointers,
+ * because this function can be called for *any* possible address.
+ */
+void *kmemcheck_shadow_lookup(unsigned long address)
+{
+	pte_t *pte;
+	struct page *page;
+
+	if (!virt_addr_valid(address))
+		return NULL;
+
+	pte = kmemcheck_pte_lookup(address);
+	if (!pte)
+		return NULL;
+
+	page = virt_to_page(address);
+	if (!page->shadow)
+		return NULL;
+	return page->shadow + (address & (PAGE_SIZE - 1));
+}
+
+static void mark_shadow(void *address, unsigned int n,
+	enum kmemcheck_shadow status)
+{
+	void *shadow;
+
+	shadow = kmemcheck_shadow_lookup((unsigned long) address);
+	if (!shadow)
+		return;
+	memset(shadow, status, n);
+}
+
+void kmemcheck_mark_unallocated(void *address, unsigned int n)
+{
+	mark_shadow(address, n, KMEMCHECK_SHADOW_UNALLOCATED);
+}
+
+void kmemcheck_mark_uninitialized(void *address, unsigned int n)
+{
+	mark_shadow(address, n, KMEMCHECK_SHADOW_UNINITIALIZED);
+}
+
+/*
+ * Fill the shadow memory of the given address such that the memory at that
+ * address is marked as being initialized.
+ */
+void kmemcheck_mark_initialized(void *address, unsigned int n)
+{
+	mark_shadow(address, n, KMEMCHECK_SHADOW_INITIALIZED);
+}
+EXPORT_SYMBOL_GPL(kmemcheck_mark_initialized);
+
+void kmemcheck_mark_freed(void *address, unsigned int n)
+{
+	mark_shadow(address, n, KMEMCHECK_SHADOW_FREED);
+}
+
+void kmemcheck_mark_unallocated_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; ++i)
+		kmemcheck_mark_unallocated(page_address(&p[i]), PAGE_SIZE);
+}
+
+void kmemcheck_mark_uninitialized_pages(struct page *p, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; ++i)
+		kmemcheck_mark_uninitialized(page_address(&p[i]), PAGE_SIZE);
+}
+
+enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size)
+{
+	uint8_t *x;
+	unsigned int i;
+
+	x = shadow;
+
+#ifdef CONFIG_KMEMCHECK_PARTIAL_OK
+	/*
+	 * Make sure _some_ bytes are initialized. Gcc frequently generates
+	 * code to access neighboring bytes.
+	 */
+	for (i = 0; i < size; ++i) {
+		if (x[i] == KMEMCHECK_SHADOW_INITIALIZED)
+			return x[i];
+	}
+#else
+	/* All bytes must be initialized. */
+	for (i = 0; i < size; ++i) {
+		if (x[i] != KMEMCHECK_SHADOW_INITIALIZED)
+			return x[i];
+	}
+#endif
+
+	return x[0];
+}
+
+void kmemcheck_shadow_set(void *shadow, unsigned int size)
+{
+	uint8_t *x;
+	unsigned int i;
+
+	x = shadow;
+	for (i = 0; i < size; ++i)
+		x[i] = KMEMCHECK_SHADOW_INITIALIZED;
+}
diff --git a/arch/x86/mm/kmemcheck/shadow.h b/arch/x86/mm/kmemcheck/shadow.h
new file mode 100644
index 0000000..af46d9a
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/shadow.h
@@ -0,0 +1,16 @@
+#ifndef ARCH__X86__MM__KMEMCHECK__SHADOW_H
+#define ARCH__X86__MM__KMEMCHECK__SHADOW_H
+
+enum kmemcheck_shadow {
+	KMEMCHECK_SHADOW_UNALLOCATED,
+	KMEMCHECK_SHADOW_UNINITIALIZED,
+	KMEMCHECK_SHADOW_INITIALIZED,
+	KMEMCHECK_SHADOW_FREED,
+};
+
+void *kmemcheck_shadow_lookup(unsigned long address);
+
+enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size);
+void kmemcheck_shadow_set(void *shadow, unsigned int size);
+
+#endif
diff --git a/include/asm-x86/kmemcheck.h b/include/asm-x86/kmemcheck.h
new file mode 100644
index 0000000..ed01518
--- /dev/null
+++ b/include/asm-x86/kmemcheck.h
@@ -0,0 +1,42 @@
+#ifndef ASM_X86_KMEMCHECK_H
+#define ASM_X86_KMEMCHECK_H
+
+#include <linux/types.h>
+#include <asm/ptrace.h>
+
+#ifdef CONFIG_KMEMCHECK
+bool kmemcheck_active(struct pt_regs *regs);
+
+void kmemcheck_show(struct pt_regs *regs);
+void kmemcheck_hide(struct pt_regs *regs);
+
+bool kmemcheck_fault(struct pt_regs *regs,
+	unsigned long address, unsigned long error_code);
+bool kmemcheck_trap(struct pt_regs *regs);
+#else
+static inline bool kmemcheck_active(struct pt_regs *regs)
+{
+	return false;
+}
+
+static inline void kmemcheck_show(struct pt_regs *regs)
+{
+}
+
+static inline void kmemcheck_hide(struct pt_regs *regs)
+{
+}
+
+static inline bool kmemcheck_fault(struct pt_regs *regs,
+	unsigned long address, unsigned long error_code)
+{
+	return false;
+}
+
+static inline bool kmemcheck_trap(struct pt_regs *regs)
+{
+	return false;
+}
+#endif /* CONFIG_KMEMCHECK */
+
+#endif
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index e8003af..0d55e44 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -50,8 +50,9 @@ struct vm_area_struct;
 #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
 #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
 #define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
+#define __GFP_NOTRACK	((__force gfp_t)0x200000u)  /* Don't track with kmemcheck */
 
-#define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
+#define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /* This equals 0, but use constants in case they ever change */
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index f58a0cf..9fc6026 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -376,6 +376,20 @@ static inline void tasklet_hi_schedule(struct tasklet_struct *t)
 		__tasklet_hi_schedule(t);
 }
 
+extern void __tasklet_hi_schedule_first(struct tasklet_struct *t);
+
+/*
+ * This version avoids touching any other tasklets. Needed for kmemcheck
+ * in order not to take any page faults while enqueueing this tasklet;
+ * consider VERY carefully whether you really need this or
+ * tasklet_hi_schedule()...
+ */
+static inline void tasklet_hi_schedule_first(struct tasklet_struct *t)
+{
+	if (!test_and_set_bit(TASKLET_STATE_SCHED, &t->state))
+		__tasklet_hi_schedule_first(t);
+}
+
 
 static inline void tasklet_disable_nosync(struct tasklet_struct *t)
 {
diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
new file mode 100644
index 0000000..57bb125
--- /dev/null
+++ b/include/linux/kmemcheck.h
@@ -0,0 +1,86 @@
+#ifndef LINUX_KMEMCHECK_H
+#define LINUX_KMEMCHECK_H
+
+#include <linux/mm_types.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_KMEMCHECK
+extern int kmemcheck_enabled;
+
+void kmemcheck_init(void);
+
+/* The slab-related functions. */
+void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
+			    struct page *page, int order);
+void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order);
+void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object,
+			  size_t size);
+void kmemcheck_slab_free(struct kmem_cache *s, void *object, size_t size);
+
+void kmemcheck_show_pages(struct page *p, unsigned int n);
+void kmemcheck_hide_pages(struct page *p, unsigned int n);
+
+bool kmemcheck_page_is_tracked(struct page *p);
+
+void kmemcheck_mark_unallocated(void *address, unsigned int n);
+void kmemcheck_mark_uninitialized(void *address, unsigned int n);
+void kmemcheck_mark_initialized(void *address, unsigned int n);
+void kmemcheck_mark_freed(void *address, unsigned int n);
+
+void kmemcheck_mark_unallocated_pages(struct page *p, unsigned int n);
+void kmemcheck_mark_uninitialized_pages(struct page *p, unsigned int n);
+
+int kmemcheck_show_addr(unsigned long address);
+int kmemcheck_hide_addr(unsigned long address);
+#else
+#define kmemcheck_enabled 0
+
+static inline void kmemcheck_init(void)
+{
+}
+
+static inline void
+kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
+		       struct page *page, int order)
+{
+}
+
+static inline void
+kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order)
+{
+}
+
+static inline void
+kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object,
+		     size_t size)
+{
+}
+
+static inline void kmemcheck_slab_free(struct kmem_cache *s, void *object,
+				       size_t size)
+{
+}
+
+static inline bool kmemcheck_page_is_tracked(struct page *p)
+{
+	return false;
+}
+
+static inline void kmemcheck_mark_unallocated(void *address, unsigned int n)
+{
+}
+
+static inline void kmemcheck_mark_uninitialized(void *address, unsigned int n)
+{
+}
+
+static inline void kmemcheck_mark_initialized(void *address, unsigned int n)
+{
+}
+
+static inline void kmemcheck_mark_freed(void *address, unsigned int n)
+{
+}
+#endif /* CONFIG_KMEMCHECK */
+
+#endif /* LINUX_KMEMCHECK_H */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index fe82547..0a48058 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -94,6 +94,14 @@ struct page {
 	void *virtual;			/* Kernel virtual address (NULL if
 					   not kmapped, ie. highmem) */
 #endif /* WANT_PAGE_VIRTUAL */
+
+#ifdef CONFIG_KMEMCHECK
+	/*
+	 * kmemcheck wants to track the status of each byte in a page; this
+	 * is a pointer to such a status block. NULL if not tracked.
+	 */
+	void *shadow;
+#endif
 };
 
 /*
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 000da12..a524397 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -62,6 +62,13 @@
 # define SLAB_DEBUG_OBJECTS	0x00000000UL
 #endif
 
+/* Don't track use of uninitialized memory */
+#ifdef CONFIG_KMEMCHECK
+# define SLAB_NOTRACK		0x00800000UL
+#else
+# define SLAB_NOTRACK		0x00000000UL
+#endif
+
 /* The following flags affect the page allocator grouping pages by mobility */
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 39c3a5e..7905c34 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -15,6 +15,87 @@
 #include <asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
 #include <linux/compiler.h>
 
+/*
+ * struct kmem_cache
+ *
+ * manages a cache.
+ */
+
+struct kmem_cache {
+/* 1) per-cpu data, touched during every alloc/free */
+	struct array_cache *array[NR_CPUS];
+/* 2) Cache tunables. Protected by cache_chain_mutex */
+	unsigned int batchcount;
+	unsigned int limit;
+	unsigned int shared;
+
+	unsigned int buffer_size;
+	u32 reciprocal_buffer_size;
+/* 3) touched by every alloc & free from the backend */
+
+	unsigned int flags;		/* constant flags */
+	unsigned int num;		/* # of objs per slab */
+
+/* 4) cache_grow/shrink */
+	/* order of pgs per slab (2^n) */
+	unsigned int gfporder;
+
+	/* force GFP flags, e.g. GFP_DMA */
+	gfp_t gfpflags;
+
+	size_t colour;			/* cache colouring range */
+	unsigned int colour_off;	/* colour offset */
+	struct kmem_cache *slabp_cache;
+	unsigned int slab_size;
+	unsigned int dflags;		/* dynamic flags */
+
+	/* constructor func */
+	void (*ctor)(void *obj);
+
+/* 5) cache creation/removal */
+	const char *name;
+	struct list_head next;
+
+/* 6) statistics */
+#ifdef CONFIG_DEBUG_SLAB
+	unsigned long num_active;
+	unsigned long num_allocations;
+	unsigned long high_mark;
+	unsigned long grown;
+	unsigned long reaped;
+	unsigned long errors;
+	unsigned long max_freeable;
+	unsigned long node_allocs;
+	unsigned long node_frees;
+	unsigned long node_overflow;
+	atomic_t allochit;
+	atomic_t allocmiss;
+	atomic_t freehit;
+	atomic_t freemiss;
+
+	/*
+	 * If debugging is enabled, then the allocator can add additional
+	 * fields and/or padding to every object. buffer_size contains the total
+	 * object size including these internal fields, the following two
+	 * variables contain the offset to the user object and its size.
+	 */
+	int obj_offset;
+	int obj_size;
+#endif /* CONFIG_DEBUG_SLAB */
+
+	/*
+	 * We put nodelists[] at the end of kmem_cache, because we want to size
+	 * this array to nr_node_ids slots instead of MAX_NUMNODES
+	 * (see kmem_cache_init())
+	 * We still use [MAX_NUMNODES] and not [1] or [0] because cache_cache
+	 * is statically defined, so we reserve the max number of nodes.
+	 */
+	struct kmem_list3 *nodelists[MAX_NUMNODES];
+	/*
+	 * Do not add fields after nodelists[]
+	 */
+};
+
 /* Size description struct for general caches. */
 struct cache_sizes {
 	size_t		 	cs_size;
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index b106fd8..6b8e54a 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -4,6 +4,8 @@
 struct task_struct;
 
 #ifdef CONFIG_STACKTRACE
+struct task_struct;
+
 struct stack_trace {
 	unsigned int nr_entries, max_entries;
 	unsigned long *entries;
@@ -11,6 +13,7 @@ struct stack_trace {
 };
 
 extern void save_stack_trace(struct stack_trace *trace);
+extern void save_stack_trace_bp(struct stack_trace *trace, unsigned long bp);
 extern void save_stack_trace_tsk(struct task_struct *tsk,
 				struct stack_trace *trace);
 
diff --git a/init/main.c b/init/main.c
index 7e117a2..ee6fb0b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -62,6 +62,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
+#include <linux/kmemcheck.h>
 #include <linux/ftrace.h>
 
 #include <asm/io.h>
@@ -779,6 +780,9 @@ static void __init do_pre_smp_initcalls(void)
 {
 	initcall_t *call;
 
+	/* kmemcheck must initialize before all early initcalls: */
+	kmemcheck_init();
+
 	for (call = __initcall_start; call < __early_initcall_end; call++)
 		do_one_initcall(*call);
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index 495da2e..cefcfad 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -173,7 +173,7 @@ void __init fork_init(unsigned long mempages)
 	/* create a slab on which task_structs can be allocated */
 	task_struct_cachep =
 		kmem_cache_create("task_struct", sizeof(struct task_struct),
-			ARCH_MIN_TASKALIGN, SLAB_PANIC, NULL);
+			ARCH_MIN_TASKALIGN, SLAB_PANIC | SLAB_NOTRACK, NULL);
 #endif
 
 	/* do the arch specific task caches init */
@@ -1454,23 +1454,23 @@ void __init proc_caches_init(void)
 {
 	sighand_cachep = kmem_cache_create("sighand_cache",
 			sizeof(struct sighand_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_DESTROY_BY_RCU,
-			sighand_ctor);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_DESTROY_BY_RCU|
+			SLAB_NOTRACK, sighand_ctor);
 	signal_cachep = kmem_cache_create("signal_cache",
 			sizeof(struct signal_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
 	files_cachep = kmem_cache_create("files_cache",
 			sizeof(struct files_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
 	fs_cachep = kmem_cache_create("fs_cache",
 			sizeof(struct fs_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
 	vm_area_cachep = kmem_cache_create("vm_area_struct",
 			sizeof(struct vm_area_struct), 0,
-			SLAB_PANIC, NULL);
+			SLAB_PANIC|SLAB_NOTRACK, NULL);
 	mm_cachep = kmem_cache_create("mm_struct",
 			sizeof(struct mm_struct), ARCH_MIN_MMSTRUCT_ALIGN,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
 }
 
 /*
diff --git a/kernel/softirq.c b/kernel/softirq.c
index e7c69a7..7c13ac1 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -374,6 +374,17 @@ void __tasklet_hi_schedule(struct tasklet_struct *t)
 
 EXPORT_SYMBOL(__tasklet_hi_schedule);
 
+void __tasklet_hi_schedule_first(struct tasklet_struct *t)
+{
+	BUG_ON(!irqs_disabled());
+
+	t->next = __get_cpu_var(tasklet_hi_vec).head;
+	__get_cpu_var(tasklet_hi_vec).head = t;
+	__raise_softirq_irqoff(HI_SOFTIRQ);
+}
+
+EXPORT_SYMBOL(__tasklet_hi_schedule_first);
+
 static void tasklet_action(struct softirq_action *a)
 {
 	struct tasklet_struct *list;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3d56fe7..ea4d26d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -27,6 +27,7 @@
 #include <linux/security.h>
 #include <linux/ctype.h>
 #include <linux/utsname.h>
+#include <linux/kmemcheck.h>
 #include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/init.h>
@@ -846,6 +847,16 @@ static struct ctl_table kern_table[] = {
 		.proc_handler   = &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_KMEMCHECK
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "kmemcheck",
+		.data		= &kmemcheck_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 #ifdef CONFIG_UNEVICTABLE_LRU
 	{
 		.ctl_name	= CTL_UNNUMBERED,
diff --git a/mm/Makefile b/mm/Makefile
index c06b45a..399aaf1 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
 obj-$(CONFIG_SLAB) += slab.o
 obj-$(CONFIG_SLUB) += slub.o
+obj-$(CONFIG_KMEMCHECK) += kmemcheck.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
diff --git a/mm/kmemcheck.c b/mm/kmemcheck.c
new file mode 100644
index 0000000..eaa41b8
--- /dev/null
+++ b/mm/kmemcheck.c
@@ -0,0 +1,103 @@
+#include <linux/mm_types.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/kmemcheck.h>
+
+void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
+			   struct page *page, int order)
+{
+	struct page *shadow;
+	int pages;
+	int i;
+
+	pages = 1 << order;
+
+	/*
+	 * With kmemcheck enabled, we need to allocate a memory area for the
+	 * shadow bits as well.
+	 */
+	shadow = alloc_pages_node(node, flags, order);
+	if (!shadow) {
+		if (printk_ratelimit())
+			printk(KERN_ERR "kmemcheck: failed to allocate "
+				"shadow bitmap\n");
+		return;
+	}
+
+	for(i = 0; i < pages; ++i)
+		page[i].shadow = page_address(&shadow[i]);
+
+	/*
+	 * Mark it as non-present for the MMU so that our accesses to
+	 * this memory will trigger a page fault and let us analyze
+	 * the memory accesses.
+	 */
+	kmemcheck_hide_pages(page, pages);
+
+	/*
+	 * Objects from caches that have a constructor don't get
+	 * cleared when they're allocated, so we need to do it here.
+	 */
+	if (s->ctor)
+		kmemcheck_mark_uninitialized_pages(page, pages);
+	else
+		kmemcheck_mark_unallocated_pages(page, pages);
+}
+
+void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order)
+{
+	struct page *shadow;
+	int pages;
+	int i;
+
+	pages = 1 << order;
+
+	kmemcheck_show_pages(page, pages);
+
+	shadow = virt_to_page(page[0].shadow);
+
+	for(i = 0; i < pages; ++i)
+		page[i].shadow = NULL;
+
+	__free_pages(shadow, order);
+}
+
+void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object,
+			  size_t size)
+{
+	/*
+	 * Has already been memset(), which initializes the shadow for us
+	 * as well.
+	 */
+	if (gfpflags & __GFP_ZERO)
+		return;
+
+	/* No need to initialize the shadow of a non-tracked slab. */
+	if (s->flags & SLAB_NOTRACK)
+		return;
+
+	if (!kmemcheck_enabled || gfpflags & __GFP_NOTRACK) {
+		/*
+		 * Allow notracked objects to be allocated from
+		 * tracked caches. Note however that these objects
+		 * will still get page faults on access, they just
+		 * won't ever be flagged as uninitialized. If page
+		 * faults are not acceptable, the slab cache itself
+		 * should be marked NOTRACK.
+		 */
+		kmemcheck_mark_initialized(object, size);
+	} else if (!s->ctor) {
+		/*
+		 * New objects should be marked uninitialized before
+		 * they're returned to the called.
+		 */
+		kmemcheck_mark_uninitialized(object, size);
+	}
+}
+
+void kmemcheck_slab_free(struct kmem_cache *s, void *object, size_t size)
+{
+	/* TODO: RCU freeing is unsupported for now; hide false positives. */
+	if (!s->ctor && !(s->flags & SLAB_DESTROY_BY_RCU))
+		kmemcheck_mark_freed(object, size);
+}
diff --git a/mm/slab.c b/mm/slab.c
index 0918751..37deade 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -112,6 +112,7 @@
 #include	<linux/rtmutex.h>
 #include	<linux/reciprocal_div.h>
 #include	<linux/debugobjects.h>
+#include	<linux/kmemcheck.h>
 
 #include	<asm/cacheflush.h>
 #include	<asm/tlbflush.h>
@@ -177,13 +178,13 @@
 			 SLAB_STORE_USER | \
 			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD | \
-			 SLAB_DEBUG_OBJECTS)
+			 SLAB_DEBUG_OBJECTS | SLAB_NOTRACK)
 #else
 # define CREATE_MASK	(SLAB_HWCACHE_ALIGN | \
 			 SLAB_CACHE_DMA | \
 			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD | \
-			 SLAB_DEBUG_OBJECTS)
+			 SLAB_DEBUG_OBJECTS | SLAB_NOTRACK)
 #endif
 
 /*
@@ -372,87 +373,6 @@ static void kmem_list3_init(struct kmem_list3 *parent)
 	MAKE_LIST((cachep), (&(ptr)->slabs_free), slabs_free, nodeid);	\
 	} while (0)
 
-/*
- * struct kmem_cache
- *
- * manages a cache.
- */
-
-struct kmem_cache {
-/* 1) per-cpu data, touched during every alloc/free */
-	struct array_cache *array[NR_CPUS];
-/* 2) Cache tunables. Protected by cache_chain_mutex */
-	unsigned int batchcount;
-	unsigned int limit;
-	unsigned int shared;
-
-	unsigned int buffer_size;
-	u32 reciprocal_buffer_size;
-/* 3) touched by every alloc & free from the backend */
-
-	unsigned int flags;		/* constant flags */
-	unsigned int num;		/* # of objs per slab */
-
-/* 4) cache_grow/shrink */
-	/* order of pgs per slab (2^n) */
-	unsigned int gfporder;
-
-	/* force GFP flags, e.g. GFP_DMA */
-	gfp_t gfpflags;
-
-	size_t colour;			/* cache colouring range */
-	unsigned int colour_off;	/* colour offset */
-	struct kmem_cache *slabp_cache;
-	unsigned int slab_size;
-	unsigned int dflags;		/* dynamic flags */
-
-	/* constructor func */
-	void (*ctor)(void *obj);
-
-/* 5) cache creation/removal */
-	const char *name;
-	struct list_head next;
-
-/* 6) statistics */
-#if STATS
-	unsigned long num_active;
-	unsigned long num_allocations;
-	unsigned long high_mark;
-	unsigned long grown;
-	unsigned long reaped;
-	unsigned long errors;
-	unsigned long max_freeable;
-	unsigned long node_allocs;
-	unsigned long node_frees;
-	unsigned long node_overflow;
-	atomic_t allochit;
-	atomic_t allocmiss;
-	atomic_t freehit;
-	atomic_t freemiss;
-#endif
-#if DEBUG
-	/*
-	 * If debugging is enabled, then the allocator can add additional
-	 * fields and/or padding to every object. buffer_size contains the total
-	 * object size including these internal fields, the following two
-	 * variables contain the offset to the user object and its size.
-	 */
-	int obj_offset;
-	int obj_size;
-#endif
-	/*
-	 * We put nodelists[] at the end of kmem_cache, because we want to size
-	 * this array to nr_node_ids slots instead of MAX_NUMNODES
-	 * (see kmem_cache_init())
-	 * We still use [MAX_NUMNODES] and not [1] or [0] because cache_cache
-	 * is statically defined, so we reserve the max number of nodes.
-	 */
-	struct kmem_list3 *nodelists[MAX_NUMNODES];
-	/*
-	 * Do not add fields after nodelists[]
-	 */
-};
-
 #define CFLGS_OFF_SLAB		(0x80000000UL)
 #define	OFF_SLAB(x)	((x)->flags & CFLGS_OFF_SLAB)
 
@@ -1693,6 +1613,10 @@ static void *kmem_getpages(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 			NR_SLAB_UNRECLAIMABLE, nr_pages);
 	for (i = 0; i < nr_pages; i++)
 		__SetPageSlab(page + i);
+
+	if (kmemcheck_enabled && !(cachep->flags & SLAB_NOTRACK))
+		kmemcheck_alloc_shadow(cachep, flags, nodeid, page, cachep->gfporder);
+
 	return page_address(page);
 }
 
@@ -1705,6 +1629,9 @@ static void kmem_freepages(struct kmem_cache *cachep, void *addr)
 	struct page *page = virt_to_page(addr);
 	const unsigned long nr_freed = i;
 
+	if (kmemcheck_page_is_tracked(page))
+		kmemcheck_free_shadow(cachep, page, cachep->gfporder);
+
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		sub_zone_page_state(page_zone(page),
 				NR_SLAB_RECLAIMABLE, nr_freed);
@@ -3413,6 +3340,9 @@ __cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
 	local_irq_restore(save_flags);
 	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
 
+	if (likely(ptr))
+		kmemcheck_slab_alloc(cachep, flags, ptr, obj_size(cachep));
+
 	if (unlikely((flags & __GFP_ZERO) && ptr))
 		memset(ptr, 0, obj_size(cachep));
 
@@ -3467,6 +3397,9 @@ __cache_alloc(struct kmem_cache *cachep, gfp_t flags, void *caller)
 	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
 	prefetchw(objp);
 
+	if (likely(objp))
+		kmemcheck_slab_alloc(cachep, flags, objp, obj_size(cachep));
+
 	if (unlikely((flags & __GFP_ZERO) && objp))
 		memset(objp, 0, obj_size(cachep));
 
@@ -3582,6 +3515,8 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp)
 	check_irq_off();
 	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
 
+	kmemcheck_slab_free(cachep, objp, obj_size(cachep));
+
 	/*
 	 * Skip calling cache_free_alien() when the platform is not numa.
 	 * This will avoid cache misses that happen while accessing slabp (which
diff --git a/mm/slub.c b/mm/slub.c
index a2cd47d..df12f28 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -24,6 +24,7 @@
 #include <linux/kallsyms.h>
 #include <linux/memory.h>
 #include <linux/math64.h>
+#include <linux/kmemcheck.h>
 
 /*
  * Lock order:
@@ -143,7 +144,7 @@
 		SLAB_TRACE | SLAB_DESTROY_BY_RCU)
 
 #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
-		SLAB_CACHE_DMA)
+		SLAB_CACHE_DMA | SLAB_NOTRACK)
 
 #ifndef ARCH_KMALLOC_MINALIGN
 #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
@@ -1090,6 +1091,13 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 
 		stat(get_cpu_slab(s, raw_smp_processor_id()), ORDER_FALLBACK);
 	}
+
+	if (kmemcheck_enabled
+		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS)))
+	{
+		kmemcheck_alloc_shadow(s, flags, node, page, compound_order(page));
+	}
+
 	page->objects = oo_objects(oo);
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
@@ -1163,6 +1171,9 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 		__ClearPageSlubDebug(page);
 	}
 
+	if (kmemcheck_page_is_tracked(page))
+		kmemcheck_free_shadow(s, page, compound_order(page));
+
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
@@ -1608,6 +1619,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
 		memset(object, 0, objsize);
 
+	kmemcheck_slab_alloc(s, gfpflags, object, c->objsize);
 	return object;
 }
 
@@ -1712,6 +1724,7 @@ static __always_inline void slab_free(struct kmem_cache *s,
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
+	kmemcheck_slab_free(s, object, c->objsize);
 	debug_check_no_locks_freed(object, c->objsize);
 	if (!(s->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(object, s->objsize);
@@ -2576,7 +2589,8 @@ static noinline struct kmem_cache *dma_kmalloc_cache(int index, gfp_t flags)
 
 	if (!s || !text || !kmem_cache_open(s, flags, text,
 			realsize, ARCH_KMALLOC_MINALIGN,
-			SLAB_CACHE_DMA|__SYSFS_ADD_DEFERRED, NULL)) {
+			SLAB_CACHE_DMA|SLAB_NOTRACK|__SYSFS_ADD_DEFERRED,
+			NULL)) {
 		kfree(s);
 		kfree(text);
 		goto unlock_out;
@@ -4283,6 +4297,8 @@ static char *create_unique_id(struct kmem_cache *s)
 		*p++ = 'a';
 	if (s->flags & SLAB_DEBUG_FREE)
 		*p++ = 'F';
+	if (!(s->flags & SLAB_NOTRACK))
+		*p++ = 't';
 	if (p != name + 1)
 		*p++ = '-';
 	p += sprintf(p, "%07d", s->size);
