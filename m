Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbZAFQ03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbZAFQ03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbZAFQ0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:26:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59691 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbZAFQ0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:26:07 -0500
Date: Tue, 6 Jan 2009 17:25:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [git pull] tracing updates/fixes
Message-ID: <20090106162543.GA19465@elte.hu>
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

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

The biggest item is the new kmemtrace tracer from the SLAB folks.

There's also tracing-core refactoring work included that still was OK for 
this merge window.

 Thanks,

	Ingo

------------------>
Eduard - Gabriel Munteanu (10):
      SLUB: Replace __builtin_return_address(0) with _RET_IP_.
      kmemtrace: Core implementation.
      kmemtrace: Additional documentation.
      kmemtrace: SLAB hooks.
      kmemtrace: SLOB hooks.
      kmemtrace: SLUB hooks.
      kmemtrace: Fix typos in documentation.
      kmemtrace: Better alternative to "kmemtrace: fix printk format warnings".
      kmemtrace: SLUB hooks for caller-tracking functions.
      kmemtrace: Remove the relay version of kmemtrace

Frederic Weisbecker (4):
      tracing/function-graph-tracer: strip ending newlines on comments
      tracing/ftrace: provide the base infrastructure for histogram tracing
      tracing/branch-tracer: adapt to the stat tracing API
      tracing/kmemtrace: normalize the raw tracer event to the unified tracing API

Ingo Molnar (8):
      tracing/ftrace: make trace_find_cmdline() generally available
      tracing/selftest: remove TRACE_CONT reference
      kmemtrace: move #include lines
      relayfs: replace BUG() with WARN_ON() in relay_late_setup_files()
      tracing, kvm: change MARKERS to select instead of depends on
      tracing/kmemtrace: export kmemtrace_mark_alloc_node() / kmemtrace_mark_free()
      tracing/kmemtrace: fix typo
      kmemtrace: add kmemtrace_init()

Pekka Enberg (3):
      kmemtrace: remove unnecessary casts
      kmemtrace: allow kmemtrace to be enabled after boot
      kmemtrace: remove config option for enabling tracing at boot

Randy Dunlap (1):
      sysrq: fix ftrace help msg & doc.

Steven Rostedt (3):
      ftrace: remove obsolete print continue functionality
      ftrace: set up trace event hash infrastructure
      ftrace: change trace.c to use registered events

Vegard Nossum (1):
      kmemtrace: add missing newline


 Documentation/ABI/testing/debugfs-kmemtrace |   71 +++
 Documentation/kernel-parameters.txt         |   10 +
 Documentation/sysrq.txt                     |    2 +
 Documentation/vm/kmemtrace.txt              |  126 ++++
 MAINTAINERS                                 |    6 +
 arch/x86/kvm/Kconfig                        |    3 +-
 drivers/char/sysrq.c                        |    2 +-
 include/linux/slab_def.h                    |   68 ++-
 include/linux/slob_def.h                    |    9 +-
 include/linux/slub_def.h                    |   53 ++-
 include/trace/kmemtrace.h                   |   75 +++
 init/main.c                                 |    2 +
 kernel/relay.c                              |    4 +-
 kernel/trace/Kconfig                        |   21 +
 kernel/trace/Makefile                       |    3 +
 kernel/trace/kmemtrace.c                    |  350 +++++++++++
 kernel/trace/trace.c                        |  741 ++----------------------
 kernel/trace/trace.h                        |   61 ++-
 kernel/trace/trace_boot.c                   |    1 +
 kernel/trace/trace_branch.c                 |  295 ++++++----
 kernel/trace/trace_functions_graph.c        |    8 +-
 kernel/trace/trace_hw_branches.c            |    1 +
 kernel/trace/trace_mmiotrace.c              |    4 +-
 kernel/trace/trace_output.c                 |  832 +++++++++++++++++++++++++++
 kernel/trace/trace_output.h                 |   59 ++
 kernel/trace/trace_power.c                  |    1 +
 kernel/trace/trace_selftest.c               |    1 -
 kernel/trace/trace_stat.c                   |  251 ++++++++
 mm/slab.c                                   |   71 ++-
 mm/slob.c                                   |   37 +-
 mm/slub.c                                   |   83 +++-
 31 files changed, 2374 insertions(+), 877 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-kmemtrace
 create mode 100644 Documentation/vm/kmemtrace.txt
 create mode 100644 include/trace/kmemtrace.h
 create mode 100644 kernel/trace/kmemtrace.c
 create mode 100644 kernel/trace/trace_output.c
 create mode 100644 kernel/trace/trace_output.h
 create mode 100644 kernel/trace/trace_stat.c

diff --git a/Documentation/ABI/testing/debugfs-kmemtrace b/Documentation/ABI/testing/debugfs-kmemtrace
new file mode 100644
index 0000000..5e6a92a
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-kmemtrace
@@ -0,0 +1,71 @@
+What:		/sys/kernel/debug/kmemtrace/
+Date:		July 2008
+Contact:	Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
+Description:
+
+In kmemtrace-enabled kernels, the following files are created:
+
+/sys/kernel/debug/kmemtrace/
+	cpu<n>		(0400)	Per-CPU tracing data, see below. (binary)
+	total_overruns	(0400)	Total number of bytes which were dropped from
+				cpu<n> files because of full buffer condition,
+				non-binary. (text)
+	abi_version	(0400)	Kernel's kmemtrace ABI version. (text)
+
+Each per-CPU file should be read according to the relay interface. That is,
+the reader should set affinity to that specific CPU and, as currently done by
+the userspace application (though there are other methods), use poll() with
+an infinite timeout before every read(). Otherwise, erroneous data may be
+read. The binary data has the following _core_ format:
+
+	Event ID	(1 byte)	Unsigned integer, one of:
+		0 - represents an allocation (KMEMTRACE_EVENT_ALLOC)
+		1 - represents a freeing of previously allocated memory
+		    (KMEMTRACE_EVENT_FREE)
+	Type ID		(1 byte)	Unsigned integer, one of:
+		0 - this is a kmalloc() / kfree()
+		1 - this is a kmem_cache_alloc() / kmem_cache_free()
+		2 - this is a __get_free_pages() et al.
+	Event size	(2 bytes)	Unsigned integer representing the
+					size of this event. Used to extend
+					kmemtrace. Discard the bytes you
+					don't know about.
+	Sequence number	(4 bytes)	Signed integer used to reorder data
+					logged on SMP machines. Wraparound
+					must be taken into account, although
+					it is unlikely.
+	Caller address	(8 bytes)	Return address to the caller.
+	Pointer to mem	(8 bytes)	Pointer to target memory area. Can be
+					NULL, but not all such calls might be
+					recorded.
+
+In case of KMEMTRACE_EVENT_ALLOC events, the next fields follow:
+
+	Requested bytes	(8 bytes)	Total number of requested bytes,
+					unsigned, must not be zero.
+	Allocated bytes (8 bytes)	Total number of actually allocated
+					bytes, unsigned, must not be lower
+					than requested bytes.
+	Requested flags	(4 bytes)	GFP flags supplied by the caller.
+	Target CPU	(4 bytes)	Signed integer, valid for event id 1.
+					If equal to -1, target CPU is the same
+					as origin CPU, but the reverse might
+					not be true.
+
+The data is made available in the same endianness the machine has.
+
+Other event ids and type ids may be defined and added. Other fields may be
+added by increasing event size, but see below for details.
+Every modification to the ABI, including new id definitions, are followed
+by bumping the ABI version by one.
+
+Adding new data to the packet (features) is done at the end of the mandatory
+data:
+	Feature size	(2 byte)
+	Feature ID	(1 byte)
+	Feature data	(Feature size - 3 bytes)
+
+
+Users:
+	kmemtrace-user - git://repo.or.cz/kmemtrace-user.git
+
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a2d8805..af600c0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -49,6 +49,7 @@ parameter is applicable:
 	ISAPNP	ISA PnP code is enabled.
 	ISDN	Appropriate ISDN support is enabled.
 	JOY	Appropriate joystick support is enabled.
+	KMEMTRACE kmemtrace is enabled.
 	LIBATA  Libata driver is enabled
 	LP	Printer support is enabled.
 	LOOP	Loopback device support is enabled.
@@ -1033,6 +1034,15 @@ and is between 256 and 4096 characters. It is defined in the file
 			use the HighMem zone if it exists, and the Normal
 			zone if it does not.
 
+	kmemtrace.enable=	[KNL,KMEMTRACE] Format: { yes | no }
+				Controls whether kmemtrace is enabled
+				at boot-time.
+
+	kmemtrace.subbufs=n	[KNL,KMEMTRACE] Overrides the number of
+			subbufs kmemtrace's relay channel has. Set this
+			higher than default (KMEMTRACE_N_SUBBUFS in code) if
+			you experience buffer overruns.
+
 	movablecore=nn[KMG]	[KNL,X86-32,IA-64,PPC,X86-64] This parameter
 			is similar to kernelcore except it specifies the
 			amount of memory used for migratable allocations.
diff --git a/Documentation/sysrq.txt b/Documentation/sysrq.txt
index 10a0263..56b53e0 100644
--- a/Documentation/sysrq.txt
+++ b/Documentation/sysrq.txt
@@ -114,6 +114,8 @@ On all -  write a character to /proc/sysrq-trigger.  e.g.:
 
 'x'	- Used by xmon interface on ppc/powerpc platforms.
 
+'z'	- Dump the ftrace buffer
+
 '0'-'9' - Sets the console log level, controlling which kernel messages
           will be printed to your console. ('0', for example would make
           it so that only emergency messages like PANICs or OOPSes would
diff --git a/Documentation/vm/kmemtrace.txt b/Documentation/vm/kmemtrace.txt
new file mode 100644
index 0000000..a956d9b
--- /dev/null
+++ b/Documentation/vm/kmemtrace.txt
@@ -0,0 +1,126 @@
+			kmemtrace - Kernel Memory Tracer
+
+			  by Eduard - Gabriel Munteanu
+			     <eduard.munteanu@linux360.ro>
+
+I. Introduction
+===============
+
+kmemtrace helps kernel developers figure out two things:
+1) how different allocators (SLAB, SLUB etc.) perform
+2) how kernel code allocates memory and how much
+
+To do this, we trace every allocation and export information to the userspace
+through the relay interface. We export things such as the number of requested
+bytes, the number of bytes actually allocated (i.e. including internal
+fragmentation), whether this is a slab allocation or a plain kmalloc() and so
+on.
+
+The actual analysis is performed by a userspace tool (see section III for
+details on where to get it from). It logs the data exported by the kernel,
+processes it and (as of writing this) can provide the following information:
+- the total amount of memory allocated and fragmentation per call-site
+- the amount of memory allocated and fragmentation per allocation
+- total memory allocated and fragmentation in the collected dataset
+- number of cross-CPU allocation and frees (makes sense in NUMA environments)
+
+Moreover, it can potentially find inconsistent and erroneous behavior in
+kernel code, such as using slab free functions on kmalloc'ed memory or
+allocating less memory than requested (but not truly failed allocations).
+
+kmemtrace also makes provisions for tracing on some arch and analysing the
+data on another.
+
+II. Design and goals
+====================
+
+kmemtrace was designed to handle rather large amounts of data. Thus, it uses
+the relay interface to export whatever is logged to userspace, which then
+stores it. Analysis and reporting is done asynchronously, that is, after the
+data is collected and stored. By design, it allows one to log and analyse
+on different machines and different arches.
+
+As of writing this, the ABI is not considered stable, though it might not
+change much. However, no guarantees are made about compatibility yet. When
+deemed stable, the ABI should still allow easy extension while maintaining
+backward compatibility. This is described further in Documentation/ABI.
+
+Summary of design goals:
+	- allow logging and analysis to be done across different machines
+	- be fast and anticipate usage in high-load environments (*)
+	- be reasonably extensible
+	- make it possible for GNU/Linux distributions to have kmemtrace
+	included in their repositories
+
+(*) - one of the reasons Pekka Enberg's original userspace data analysis
+    tool's code was rewritten from Perl to C (although this is more than a
+    simple conversion)
+
+
+III. Quick usage guide
+======================
+
+1) Get a kernel that supports kmemtrace and build it accordingly (i.e. enable
+CONFIG_KMEMTRACE).
+
+2) Get the userspace tool and build it:
+$ git-clone git://repo.or.cz/kmemtrace-user.git		# current repository
+$ cd kmemtrace-user/
+$ ./autogen.sh
+$ ./configure
+$ make
+
+3) Boot the kmemtrace-enabled kernel if you haven't, preferably in the
+'single' runlevel (so that relay buffers don't fill up easily), and run
+kmemtrace:
+# '$' does not mean user, but root here.
+$ mount -t debugfs none /sys/kernel/debug
+$ mount -t proc none /proc
+$ cd path/to/kmemtrace-user/
+$ ./kmemtraced
+Wait a bit, then stop it with CTRL+C.
+$ cat /sys/kernel/debug/kmemtrace/total_overruns	# Check if we didn't
+							# overrun, should
+							# be zero.
+$ (Optionally) [Run kmemtrace_check separately on each cpu[0-9]*.out file to
+		check its correctness]
+$ ./kmemtrace-report
+
+Now you should have a nice and short summary of how the allocator performs.
+
+IV. FAQ and known issues
+========================
+
+Q: 'cat /sys/kernel/debug/kmemtrace/total_overruns' is non-zero, how do I fix
+this? Should I worry?
+A: If it's non-zero, this affects kmemtrace's accuracy, depending on how
+large the number is. You can fix it by supplying a higher
+'kmemtrace.subbufs=N' kernel parameter.
+---
+
+Q: kmemtrace_check reports errors, how do I fix this? Should I worry?
+A: This is a bug and should be reported. It can occur for a variety of
+reasons:
+	- possible bugs in relay code
+	- possible misuse of relay by kmemtrace
+	- timestamps being collected unorderly
+Or you may fix it yourself and send us a patch.
+---
+
+Q: kmemtrace_report shows many errors, how do I fix this? Should I worry?
+A: This is a known issue and I'm working on it. These might be true errors
+in kernel code, which may have inconsistent behavior (e.g. allocating memory
+with kmem_cache_alloc() and freeing it with kfree()). Pekka Enberg pointed
+out this behavior may work with SLAB, but may fail with other allocators.
+
+It may also be due to lack of tracing in some unusual allocator functions.
+
+We don't want bug reports regarding this issue yet.
+---
+
+V. See also
+===========
+
+Documentation/kernel-parameters.txt
+Documentation/ABI/testing/debugfs-kmemtrace
+
diff --git a/MAINTAINERS b/MAINTAINERS
index 141aff6..ec2fd64 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2572,6 +2572,12 @@ M:	jason.wessel@windriver.com
 L:	kgdb-bugreport@lists.sourceforge.net
 S:	Maintained
 
+KMEMTRACE
+P:	Eduard - Gabriel Munteanu
+M:	eduard.munteanu@linux360.ro
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 KPROBES
 P:	Ananth N Mavinakayanahalli
 M:	ananth@in.ibm.com
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index b81125f..c7da368 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -55,7 +55,8 @@ config KVM_AMD
 
 config KVM_TRACE
 	bool "KVM trace support"
-	depends on KVM && MARKERS && SYSFS
+	depends on KVM && SYSFS
+	select MARKERS
 	select RELAY
 	select DEBUG_FS
 	default n
diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 94966ed..785a08e 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -283,7 +283,7 @@ static void sysrq_ftrace_dump(int key, struct tty_struct *tty)
 }
 static struct sysrq_key_op sysrq_ftrace_dump_op = {
 	.handler	= sysrq_ftrace_dump,
-	.help_msg	= "dumpZ-ftrace-buffer",
+	.help_msg	= "dump-ftrace-buffer(Z)",
 	.action_msg	= "Dump ftrace buffer",
 	.enable_mask	= SYSRQ_ENABLE_DUMP,
 };
diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 39c3a5e..455f9af 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -14,6 +14,7 @@
 #include <asm/page.h>		/* kmalloc_sizes.h needs PAGE_SIZE */
 #include <asm/cache.h>		/* kmalloc_sizes.h needs L1_CACHE_BYTES */
 #include <linux/compiler.h>
+#include <trace/kmemtrace.h>
 
 /* Size description struct for general caches. */
 struct cache_sizes {
@@ -28,8 +29,26 @@ extern struct cache_sizes malloc_sizes[];
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
-static inline void *kmalloc(size_t size, gfp_t flags)
+#ifdef CONFIG_KMEMTRACE
+extern void *kmem_cache_alloc_notrace(struct kmem_cache *cachep, gfp_t flags);
+extern size_t slab_buffer_size(struct kmem_cache *cachep);
+#else
+static __always_inline void *
+kmem_cache_alloc_notrace(struct kmem_cache *cachep, gfp_t flags)
 {
+	return kmem_cache_alloc(cachep, flags);
+}
+static inline size_t slab_buffer_size(struct kmem_cache *cachep)
+{
+	return 0;
+}
+#endif
+
+static __always_inline void *kmalloc(size_t size, gfp_t flags)
+{
+	struct kmem_cache *cachep;
+	void *ret;
+
 	if (__builtin_constant_p(size)) {
 		int i = 0;
 
@@ -50,10 +69,17 @@ static inline void *kmalloc(size_t size, gfp_t flags)
 found:
 #ifdef CONFIG_ZONE_DMA
 		if (flags & GFP_DMA)
-			return kmem_cache_alloc(malloc_sizes[i].cs_dmacachep,
-						flags);
+			cachep = malloc_sizes[i].cs_dmacachep;
+		else
 #endif
-		return kmem_cache_alloc(malloc_sizes[i].cs_cachep, flags);
+			cachep = malloc_sizes[i].cs_cachep;
+
+		ret = kmem_cache_alloc_notrace(cachep, flags);
+
+		kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
+				     size, slab_buffer_size(cachep), flags);
+
+		return ret;
 	}
 	return __kmalloc(size, flags);
 }
@@ -62,8 +88,25 @@ found:
 extern void *__kmalloc_node(size_t size, gfp_t flags, int node);
 extern void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 
-static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
+#ifdef CONFIG_KMEMTRACE
+extern void *kmem_cache_alloc_node_notrace(struct kmem_cache *cachep,
+					   gfp_t flags,
+					   int nodeid);
+#else
+static __always_inline void *
+kmem_cache_alloc_node_notrace(struct kmem_cache *cachep,
+			      gfp_t flags,
+			      int nodeid)
+{
+	return kmem_cache_alloc_node(cachep, flags, nodeid);
+}
+#endif
+
+static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
+	struct kmem_cache *cachep;
+	void *ret;
+
 	if (__builtin_constant_p(size)) {
 		int i = 0;
 
@@ -84,11 +127,18 @@ static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 found:
 #ifdef CONFIG_ZONE_DMA
 		if (flags & GFP_DMA)
-			return kmem_cache_alloc_node(malloc_sizes[i].cs_dmacachep,
-						flags, node);
+			cachep = malloc_sizes[i].cs_dmacachep;
+		else
 #endif
-		return kmem_cache_alloc_node(malloc_sizes[i].cs_cachep,
-						flags, node);
+			cachep = malloc_sizes[i].cs_cachep;
+
+		ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
+
+		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_,
+					  ret, size, slab_buffer_size(cachep),
+					  flags, node);
+
+		return ret;
 	}
 	return __kmalloc_node(size, flags, node);
 }
diff --git a/include/linux/slob_def.h b/include/linux/slob_def.h
index 59a3fa4..0ec00b3 100644
--- a/include/linux/slob_def.h
+++ b/include/linux/slob_def.h
@@ -3,14 +3,15 @@
 
 void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 
-static inline void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
+static __always_inline void *kmem_cache_alloc(struct kmem_cache *cachep,
+					      gfp_t flags)
 {
 	return kmem_cache_alloc_node(cachep, flags, -1);
 }
 
 void *__kmalloc_node(size_t size, gfp_t flags, int node);
 
-static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
+static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	return __kmalloc_node(size, flags, node);
 }
@@ -23,12 +24,12 @@ static inline void *kmalloc_node(size_t size, gfp_t flags, int node)
  * kmalloc is the normal method of allocating memory
  * in the kernel.
  */
-static inline void *kmalloc(size_t size, gfp_t flags)
+static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
 	return __kmalloc_node(size, flags, -1);
 }
 
-static inline void *__kmalloc(size_t size, gfp_t flags)
+static __always_inline void *__kmalloc(size_t size, gfp_t flags)
 {
 	return kmalloc(size, flags);
 }
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 2f5c16b..6b657f7 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -10,6 +10,7 @@
 #include <linux/gfp.h>
 #include <linux/workqueue.h>
 #include <linux/kobject.h>
+#include <trace/kmemtrace.h>
 
 enum stat_item {
 	ALLOC_FASTPATH,		/* Allocation from cpu slab */
@@ -204,13 +205,31 @@ static __always_inline struct kmem_cache *kmalloc_slab(size_t size)
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
+#ifdef CONFIG_KMEMTRACE
+extern void *kmem_cache_alloc_notrace(struct kmem_cache *s, gfp_t gfpflags);
+#else
+static __always_inline void *
+kmem_cache_alloc_notrace(struct kmem_cache *s, gfp_t gfpflags)
+{
+	return kmem_cache_alloc(s, gfpflags);
+}
+#endif
+
 static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
 {
-	return (void *)__get_free_pages(flags | __GFP_COMP, get_order(size));
+	unsigned int order = get_order(size);
+	void *ret = (void *) __get_free_pages(flags | __GFP_COMP, order);
+
+	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _THIS_IP_, ret,
+			     size, PAGE_SIZE << order, flags);
+
+	return ret;
 }
 
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
+	void *ret;
+
 	if (__builtin_constant_p(size)) {
 		if (size > PAGE_SIZE)
 			return kmalloc_large(size, flags);
@@ -221,7 +240,13 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 			if (!s)
 				return ZERO_SIZE_PTR;
 
-			return kmem_cache_alloc(s, flags);
+			ret = kmem_cache_alloc_notrace(s, flags);
+
+			kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC,
+					     _THIS_IP_, ret,
+					     size, s->size, flags);
+
+			return ret;
 		}
 	}
 	return __kmalloc(size, flags);
@@ -231,8 +256,24 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 void *__kmalloc_node(size_t size, gfp_t flags, int node);
 void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 
+#ifdef CONFIG_KMEMTRACE
+extern void *kmem_cache_alloc_node_notrace(struct kmem_cache *s,
+					   gfp_t gfpflags,
+					   int node);
+#else
+static __always_inline void *
+kmem_cache_alloc_node_notrace(struct kmem_cache *s,
+			      gfp_t gfpflags,
+			      int node)
+{
+	return kmem_cache_alloc_node(s, gfpflags, node);
+}
+#endif
+
 static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
+	void *ret;
+
 	if (__builtin_constant_p(size) &&
 		size <= PAGE_SIZE && !(flags & SLUB_DMA)) {
 			struct kmem_cache *s = kmalloc_slab(size);
@@ -240,7 +281,13 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 		if (!s)
 			return ZERO_SIZE_PTR;
 
-		return kmem_cache_alloc_node(s, flags, node);
+		ret = kmem_cache_alloc_node_notrace(s, flags, node);
+
+		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
+					  _THIS_IP_, ret,
+					  size, s->size, flags, node);
+
+		return ret;
 	}
 	return __kmalloc_node(size, flags, node);
 }
diff --git a/include/trace/kmemtrace.h b/include/trace/kmemtrace.h
new file mode 100644
index 0000000..ad8b785
--- /dev/null
+++ b/include/trace/kmemtrace.h
@@ -0,0 +1,75 @@
+/*
+ * Copyright (C) 2008 Eduard - Gabriel Munteanu
+ *
+ * This file is released under GPL version 2.
+ */
+
+#ifndef _LINUX_KMEMTRACE_H
+#define _LINUX_KMEMTRACE_H
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <linux/marker.h>
+
+enum kmemtrace_type_id {
+	KMEMTRACE_TYPE_KMALLOC = 0,	/* kmalloc() or kfree(). */
+	KMEMTRACE_TYPE_CACHE,		/* kmem_cache_*(). */
+	KMEMTRACE_TYPE_PAGES,		/* __get_free_pages() and friends. */
+};
+
+#ifdef CONFIG_KMEMTRACE
+
+extern void kmemtrace_init(void);
+
+extern void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
+					     unsigned long call_site,
+					     const void *ptr,
+					     size_t bytes_req,
+					     size_t bytes_alloc,
+					     gfp_t gfp_flags,
+					     int node);
+
+extern void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
+				       unsigned long call_site,
+				       const void *ptr);
+
+#else /* CONFIG_KMEMTRACE */
+
+static inline void kmemtrace_init(void)
+{
+}
+
+static inline void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
+					     unsigned long call_site,
+					     const void *ptr,
+					     size_t bytes_req,
+					     size_t bytes_alloc,
+					     gfp_t gfp_flags,
+					     int node)
+{
+}
+
+static inline void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
+				       unsigned long call_site,
+				       const void *ptr)
+{
+}
+
+#endif /* CONFIG_KMEMTRACE */
+
+static inline void kmemtrace_mark_alloc(enum kmemtrace_type_id type_id,
+					unsigned long call_site,
+					const void *ptr,
+					size_t bytes_req,
+					size_t bytes_alloc,
+					gfp_t gfp_flags)
+{
+	kmemtrace_mark_alloc_node(type_id, call_site, ptr,
+				  bytes_req, bytes_alloc, gfp_flags, -1);
+}
+
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_KMEMTRACE_H */
+
diff --git a/init/main.c b/init/main.c
index cd168eb..72a521c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -70,6 +70,7 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
+#include <trace/kmemtrace.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/smp.h>
@@ -642,6 +643,7 @@ asmlinkage void __init start_kernel(void)
 	enable_debug_pagealloc();
 	cpu_hotplug_init();
 	kmem_cache_init();
+	kmemtrace_init();
 	debug_objects_mem_init();
 	idr_init_cache();
 	setup_per_cpu_pageset();
diff --git a/kernel/relay.c b/kernel/relay.c
index 09ac200..d064506 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -675,9 +675,7 @@ int relay_late_setup_files(struct rchan *chan,
 	 */
 	for_each_online_cpu(i) {
 		if (unlikely(!chan->buf[i])) {
-			printk(KERN_ERR "relay_late_setup_files: CPU %u "
-					"has no buffer, it must have!\n", i);
-			BUG();
+			WARN_ONCE(1, KERN_ERR "CPU has no buffer!\n");
 			err = -EINVAL;
 			break;
 		}
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index e2a4ff6..1c0b750 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -264,6 +264,27 @@ config HW_BRANCH_TRACER
 	  This tracer records all branches on the system in a circular
 	  buffer giving access to the last N branches for each cpu.
 
+config KMEMTRACE
+	bool "Trace SLAB allocations"
+	select TRACING
+	help
+	  kmemtrace provides tracing for slab allocator functions, such as
+	  kmalloc, kfree, kmem_cache_alloc, kmem_cache_free etc.. Collected
+	  data is then fed to the userspace application in order to analyse
+	  allocation hotspots, internal fragmentation and so on, making it
+	  possible to see how well an allocator performs, as well as debug
+	  and profile kernel code.
+
+	  This requires an userspace application to use. See
+	  Documentation/vm/kmemtrace.txt for more information.
+
+	  Saying Y will make the kernel somewhat larger and slower. However,
+	  if you disable kmemtrace at run-time or boot-time, the performance
+	  impact is minimal (depending on the arch the kernel is built for).
+
+	  If unsure, say N.
+
+
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
 	depends on FUNCTION_TRACER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 349d5a9..05c9182 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -19,6 +19,8 @@ obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
 obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
 
 obj-$(CONFIG_TRACING) += trace.o
+obj-$(CONFIG_TRACING) += trace_output.o
+obj-$(CONFIG_TRACING) += trace_stat.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
 obj-$(CONFIG_SYSPROF_TRACER) += trace_sysprof.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace_functions.o
@@ -33,5 +35,6 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += trace_functions_graph.o
 obj-$(CONFIG_TRACE_BRANCH_PROFILING) += trace_branch.o
 obj-$(CONFIG_HW_BRANCH_TRACER) += trace_hw_branches.o
 obj-$(CONFIG_POWER_TRACER) += trace_power.o
+obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
new file mode 100644
index 0000000..faaa5ae
--- /dev/null
+++ b/kernel/trace/kmemtrace.c
@@ -0,0 +1,350 @@
+/*
+ * Memory allocator tracing
+ *
+ * Copyright (C) 2008 Eduard - Gabriel Munteanu
+ * Copyright (C) 2008 Pekka Enberg <penberg@cs.helsinki.fi>
+ * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
+ */
+
+#include <linux/dcache.h>
+#include <linux/debugfs.h>
+#include <linux/fs.h>
+#include <linux/seq_file.h>
+#include <trace/kmemtrace.h>
+
+#include "trace.h"
+#include "trace_output.h"
+
+/* Select an alternative, minimalistic output than the original one */
+#define TRACE_KMEM_OPT_MINIMAL	0x1
+
+static struct tracer_opt kmem_opts[] = {
+	/* Default disable the minimalistic output */
+	{ TRACER_OPT(kmem_minimalistic, TRACE_KMEM_OPT_MINIMAL) },
+	{ }
+};
+
+static struct tracer_flags kmem_tracer_flags = {
+	.val = 0,
+	.opts = kmem_opts
+};
+
+
+static bool kmem_tracing_enabled __read_mostly;
+static struct trace_array *kmemtrace_array;
+
+static int kmem_trace_init(struct trace_array *tr)
+{
+	int cpu;
+	kmemtrace_array = tr;
+
+	for_each_cpu_mask(cpu, cpu_possible_map)
+		tracing_reset(tr, cpu);
+
+	kmem_tracing_enabled = true;
+
+	return 0;
+}
+
+static void kmem_trace_reset(struct trace_array *tr)
+{
+	kmem_tracing_enabled = false;
+}
+
+static void kmemtrace_headers(struct seq_file *s)
+{
+	/* Don't need headers for the original kmemtrace output */
+	if (!(kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL))
+		return;
+
+	seq_printf(s, "#\n");
+	seq_printf(s, "# ALLOC  TYPE  REQ   GIVEN  FLAGS     "
+			"      POINTER         NODE    CALLER\n");
+	seq_printf(s, "# FREE   |      |     |       |       "
+			"       |   |            |        |\n");
+	seq_printf(s, "# |\n\n");
+}
+
+/*
+ * The two following functions give the original output from kmemtrace,
+ * or something close to....perhaps they need some missing things
+ */
+static enum print_line_t
+kmemtrace_print_alloc_original(struct trace_iterator *iter,
+				struct kmemtrace_alloc_entry *entry)
+{
+	struct trace_seq *s = &iter->seq;
+	int ret;
+
+	/* Taken from the old linux/kmemtrace.h */
+	ret = trace_seq_printf(s, "type_id %d call_site %lu ptr %lu "
+	  "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d\n",
+	   entry->type_id, entry->call_site, (unsigned long) entry->ptr,
+	   (unsigned long) entry->bytes_req, (unsigned long) entry->bytes_alloc,
+	   (unsigned long) entry->gfp_flags, entry->node);
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t
+kmemtrace_print_free_original(struct trace_iterator *iter,
+				struct kmemtrace_free_entry *entry)
+{
+	struct trace_seq *s = &iter->seq;
+	int ret;
+
+	/* Taken from the old linux/kmemtrace.h */
+	ret = trace_seq_printf(s, "type_id %d call_site %lu ptr %lu\n",
+	   entry->type_id, entry->call_site, (unsigned long) entry->ptr);
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
+
+/* The two other following provide a more minimalistic output */
+static enum print_line_t
+kmemtrace_print_alloc_compress(struct trace_iterator *iter,
+					struct kmemtrace_alloc_entry *entry)
+{
+	struct trace_seq *s = &iter->seq;
+	int ret;
+
+	/* Alloc entry */
+	ret = trace_seq_printf(s, "  +      ");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Type */
+	switch (entry->type_id) {
+	case KMEMTRACE_TYPE_KMALLOC:
+		ret = trace_seq_printf(s, "K   ");
+		break;
+	case KMEMTRACE_TYPE_CACHE:
+		ret = trace_seq_printf(s, "C   ");
+		break;
+	case KMEMTRACE_TYPE_PAGES:
+		ret = trace_seq_printf(s, "P   ");
+		break;
+	default:
+		ret = trace_seq_printf(s, "?   ");
+	}
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Requested */
+	ret = trace_seq_printf(s, "%4d   ", entry->bytes_req);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Allocated */
+	ret = trace_seq_printf(s, "%4d   ", entry->bytes_alloc);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Flags
+	 * TODO: would be better to see the name of the GFP flag names
+	 */
+	ret = trace_seq_printf(s, "%08x   ", entry->gfp_flags);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Pointer to allocated */
+	ret = trace_seq_printf(s, "0x%tx   ", (ptrdiff_t)entry->ptr);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Node */
+	ret = trace_seq_printf(s, "%4d   ", entry->node);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Call site */
+	ret = seq_print_ip_sym(s, entry->call_site, 0);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	if (!trace_seq_printf(s, "\n"))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t
+kmemtrace_print_free_compress(struct trace_iterator *iter,
+				struct kmemtrace_free_entry *entry)
+{
+	struct trace_seq *s = &iter->seq;
+	int ret;
+
+	/* Free entry */
+	ret = trace_seq_printf(s, "  -      ");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Type */
+	switch (entry->type_id) {
+	case KMEMTRACE_TYPE_KMALLOC:
+		ret = trace_seq_printf(s, "K     ");
+		break;
+	case KMEMTRACE_TYPE_CACHE:
+		ret = trace_seq_printf(s, "C     ");
+		break;
+	case KMEMTRACE_TYPE_PAGES:
+		ret = trace_seq_printf(s, "P     ");
+		break;
+	default:
+		ret = trace_seq_printf(s, "?     ");
+	}
+
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Skip requested/allocated/flags */
+	ret = trace_seq_printf(s, "                       ");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Pointer to allocated */
+	ret = trace_seq_printf(s, "0x%tx   ", (ptrdiff_t)entry->ptr);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Skip node */
+	ret = trace_seq_printf(s, "       ");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Call site */
+	ret = seq_print_ip_sym(s, entry->call_site, 0);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	if (!trace_seq_printf(s, "\n"))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
+static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
+{
+	struct trace_entry *entry = iter->ent;
+
+	switch (entry->type) {
+	case TRACE_KMEM_ALLOC: {
+		struct kmemtrace_alloc_entry *field;
+		trace_assign_type(field, entry);
+		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
+			return kmemtrace_print_alloc_compress(iter, field);
+		else
+			return kmemtrace_print_alloc_original(iter, field);
+	}
+
+	case TRACE_KMEM_FREE: {
+		struct kmemtrace_free_entry *field;
+		trace_assign_type(field, entry);
+		if (kmem_tracer_flags.val & TRACE_KMEM_OPT_MINIMAL)
+			return kmemtrace_print_free_compress(iter, field);
+		else
+			return kmemtrace_print_free_original(iter, field);
+	}
+
+	default:
+		return TRACE_TYPE_UNHANDLED;
+	}
+}
+
+/* Trace allocations */
+void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
+			     unsigned long call_site,
+			     const void *ptr,
+			     size_t bytes_req,
+			     size_t bytes_alloc,
+			     gfp_t gfp_flags,
+			     int node)
+{
+	struct ring_buffer_event *event;
+	struct kmemtrace_alloc_entry *entry;
+	struct trace_array *tr = kmemtrace_array;
+	unsigned long irq_flags;
+
+	if (!kmem_tracing_enabled)
+		return;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+
+	entry->ent.type = TRACE_KMEM_ALLOC;
+	entry->call_site = call_site;
+	entry->ptr = ptr;
+	entry->bytes_req = bytes_req;
+	entry->bytes_alloc = bytes_alloc;
+	entry->gfp_flags = gfp_flags;
+	entry->node	=	node;
+
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+}
+EXPORT_SYMBOL(kmemtrace_mark_alloc_node);
+
+void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
+		       unsigned long call_site,
+		       const void *ptr)
+{
+	struct ring_buffer_event *event;
+	struct kmemtrace_free_entry *entry;
+	struct trace_array *tr = kmemtrace_array;
+	unsigned long irq_flags;
+
+	if (!kmem_tracing_enabled)
+		return;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+
+	entry->ent.type = TRACE_KMEM_FREE;
+	entry->type_id	= type_id;
+	entry->call_site = call_site;
+	entry->ptr = ptr;
+
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+}
+EXPORT_SYMBOL(kmemtrace_mark_free);
+
+static struct tracer kmem_tracer __read_mostly = {
+	.name		= "kmemtrace",
+	.init		= kmem_trace_init,
+	.reset		= kmem_trace_reset,
+	.print_line	= kmemtrace_print_line,
+	.print_header = kmemtrace_headers,
+	.flags		= &kmem_tracer_flags
+};
+
+void kmemtrace_init(void)
+{
+	/* earliest opportunity to start kmem tracing */
+}
+
+static int __init init_kmem_tracer(void)
+{
+	return register_tracer(&kmem_tracer);
+}
+
+device_initcall(init_kmem_tracer);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c580233..0418fc3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -37,6 +37,7 @@
 #include <linux/irqflags.h>
 
 #include "trace.h"
+#include "trace_output.h"
 
 #define TRACE_BUFFER_FLAGS	(RB_FL_OVERWRITE)
 
@@ -329,132 +330,6 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	tracing_record_cmdline(current);
 }
 
-/**
- * trace_seq_printf - sequence printing of trace information
- * @s: trace sequence descriptor
- * @fmt: printf format string
- *
- * The tracer may use either sequence operations or its own
- * copy to user routines. To simplify formating of a trace
- * trace_seq_printf is used to store strings into a special
- * buffer (@s). Then the output may be either used by
- * the sequencer or pulled into another buffer.
- */
-int
-trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
-{
-	int len = (PAGE_SIZE - 1) - s->len;
-	va_list ap;
-	int ret;
-
-	if (!len)
-		return 0;
-
-	va_start(ap, fmt);
-	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
-	va_end(ap);
-
-	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len)
-		return 0;
-
-	s->len += ret;
-
-	return len;
-}
-
-/**
- * trace_seq_puts - trace sequence printing of simple string
- * @s: trace sequence descriptor
- * @str: simple string to record
- *
- * The tracer may use either the sequence operations or its own
- * copy to user routines. This function records a simple string
- * into a special buffer (@s) for later retrieval by a sequencer
- * or other mechanism.
- */
-static int
-trace_seq_puts(struct trace_seq *s, const char *str)
-{
-	int len = strlen(str);
-
-	if (len > ((PAGE_SIZE - 1) - s->len))
-		return 0;
-
-	memcpy(s->buffer + s->len, str, len);
-	s->len += len;
-
-	return len;
-}
-
-static int
-trace_seq_putc(struct trace_seq *s, unsigned char c)
-{
-	if (s->len >= (PAGE_SIZE - 1))
-		return 0;
-
-	s->buffer[s->len++] = c;
-
-	return 1;
-}
-
-static int
-trace_seq_putmem(struct trace_seq *s, void *mem, size_t len)
-{
-	if (len > ((PAGE_SIZE - 1) - s->len))
-		return 0;
-
-	memcpy(s->buffer + s->len, mem, len);
-	s->len += len;
-
-	return len;
-}
-
-#define MAX_MEMHEX_BYTES	8
-#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
-
-static int
-trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
-{
-	unsigned char hex[HEX_CHARS];
-	unsigned char *data = mem;
-	int i, j;
-
-#ifdef __BIG_ENDIAN
-	for (i = 0, j = 0; i < len; i++) {
-#else
-	for (i = len-1, j = 0; i >= 0; i--) {
-#endif
-		hex[j++] = hex_asc_hi(data[i]);
-		hex[j++] = hex_asc_lo(data[i]);
-	}
-	hex[j++] = ' ';
-
-	return trace_seq_putmem(s, hex, j);
-}
-
-static int
-trace_seq_path(struct trace_seq *s, struct path *path)
-{
-	unsigned char *p;
-
-	if (s->len >= (PAGE_SIZE - 1))
-		return 0;
-	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
-	if (!IS_ERR(p)) {
-		p = mangle_path(s->buffer + s->len, p, "\n");
-		if (p) {
-			s->len = p - s->buffer;
-			return 1;
-		}
-	} else {
-		s->buffer[s->len++] = '?';
-		return 1;
-	}
-
-	return 0;
-}
-
 static void
 trace_seq_reset(struct trace_seq *s)
 {
@@ -1472,154 +1347,6 @@ static void s_stop(struct seq_file *m, void *p)
 	mutex_unlock(&trace_types_lock);
 }
 
-#ifdef CONFIG_KRETPROBES
-static inline const char *kretprobed(const char *name)
-{
-	static const char tramp_name[] = "kretprobe_trampoline";
-	int size = sizeof(tramp_name);
-
-	if (strncmp(tramp_name, name, size) == 0)
-		return "[unknown/kretprobe'd]";
-	return name;
-}
-#else
-static inline const char *kretprobed(const char *name)
-{
-	return name;
-}
-#endif /* CONFIG_KRETPROBES */
-
-static int
-seq_print_sym_short(struct trace_seq *s, const char *fmt, unsigned long address)
-{
-#ifdef CONFIG_KALLSYMS
-	char str[KSYM_SYMBOL_LEN];
-	const char *name;
-
-	kallsyms_lookup(address, NULL, NULL, NULL, str);
-
-	name = kretprobed(str);
-
-	return trace_seq_printf(s, fmt, name);
-#endif
-	return 1;
-}
-
-static int
-seq_print_sym_offset(struct trace_seq *s, const char *fmt,
-		     unsigned long address)
-{
-#ifdef CONFIG_KALLSYMS
-	char str[KSYM_SYMBOL_LEN];
-	const char *name;
-
-	sprint_symbol(str, address);
-	name = kretprobed(str);
-
-	return trace_seq_printf(s, fmt, name);
-#endif
-	return 1;
-}
-
-#ifndef CONFIG_64BIT
-# define IP_FMT "%08lx"
-#else
-# define IP_FMT "%016lx"
-#endif
-
-int
-seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
-{
-	int ret;
-
-	if (!ip)
-		return trace_seq_printf(s, "0");
-
-	if (sym_flags & TRACE_ITER_SYM_OFFSET)
-		ret = seq_print_sym_offset(s, "%s", ip);
-	else
-		ret = seq_print_sym_short(s, "%s", ip);
-
-	if (!ret)
-		return 0;
-
-	if (sym_flags & TRACE_ITER_SYM_ADDR)
-		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
-	return ret;
-}
-
-static inline int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
-				    unsigned long ip, unsigned long sym_flags)
-{
-	struct file *file = NULL;
-	unsigned long vmstart = 0;
-	int ret = 1;
-
-	if (mm) {
-		const struct vm_area_struct *vma;
-
-		down_read(&mm->mmap_sem);
-		vma = find_vma(mm, ip);
-		if (vma) {
-			file = vma->vm_file;
-			vmstart = vma->vm_start;
-		}
-		if (file) {
-			ret = trace_seq_path(s, &file->f_path);
-			if (ret)
-				ret = trace_seq_printf(s, "[+0x%lx]", ip - vmstart);
-		}
-		up_read(&mm->mmap_sem);
-	}
-	if (ret && ((sym_flags & TRACE_ITER_SYM_ADDR) || !file))
-		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
-	return ret;
-}
-
-static int
-seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
-		      unsigned long sym_flags)
-{
-	struct mm_struct *mm = NULL;
-	int ret = 1;
-	unsigned int i;
-
-	if (trace_flags & TRACE_ITER_SYM_USEROBJ) {
-		struct task_struct *task;
-		/*
-		 * we do the lookup on the thread group leader,
-		 * since individual threads might have already quit!
-		 */
-		rcu_read_lock();
-		task = find_task_by_vpid(entry->ent.tgid);
-		if (task)
-			mm = get_task_mm(task);
-		rcu_read_unlock();
-	}
-
-	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
-		unsigned long ip = entry->caller[i];
-
-		if (ip == ULONG_MAX || !ret)
-			break;
-		if (i && ret)
-			ret = trace_seq_puts(s, " <- ");
-		if (!ip) {
-			if (ret)
-				ret = trace_seq_puts(s, "??");
-			continue;
-		}
-		if (!ret)
-			break;
-		if (ret)
-			ret = seq_print_user_ip(s, mm, ip, sym_flags);
-	}
-
-	if (mm)
-		mmput(mm);
-	return ret;
-}
-
 static void print_lat_help_header(struct seq_file *m)
 {
 	seq_puts(m, "#                  _------=> CPU#            \n");
@@ -1755,52 +1482,6 @@ lat_print_timestamp(struct trace_seq *s, u64 abs_usecs,
 		trace_seq_puts(s, " : ");
 }
 
-static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
-
-static int task_state_char(unsigned long state)
-{
-	int bit = state ? __ffs(state) + 1 : 0;
-
-	return bit < sizeof(state_to_char) - 1 ? state_to_char[bit] : '?';
-}
-
-/*
- * The message is supposed to contain an ending newline.
- * If the printing stops prematurely, try to add a newline of our own.
- */
-void trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
-{
-	struct trace_entry *ent;
-	struct trace_field_cont *cont;
-	bool ok = true;
-
-	ent = peek_next_entry(iter, iter->cpu, NULL);
-	if (!ent || ent->type != TRACE_CONT) {
-		trace_seq_putc(s, '\n');
-		return;
-	}
-
-	do {
-		cont = (struct trace_field_cont *)ent;
-		if (ok)
-			ok = (trace_seq_printf(s, "%s", cont->buf) > 0);
-
-		ftrace_disable_cpu();
-
-		if (iter->buffer_iter[iter->cpu])
-			ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
-		else
-			ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);
-
-		ftrace_enable_cpu();
-
-		ent = peek_next_entry(iter, iter->cpu, NULL);
-	} while (ent && ent->type == TRACE_CONT);
-
-	if (!ok)
-		trace_seq_putc(s, '\n');
-}
-
 static void test_cpu_buff_start(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
@@ -1824,17 +1505,14 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 	struct trace_seq *s = &iter->seq;
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
 	struct trace_entry *next_entry;
+	struct trace_event *event;
 	unsigned long verbose = (trace_flags & TRACE_ITER_VERBOSE);
 	struct trace_entry *entry = iter->ent;
 	unsigned long abs_usecs;
 	unsigned long rel_usecs;
 	u64 next_ts;
 	char *comm;
-	int S, T;
-	int i;
-
-	if (entry->type == TRACE_CONT)
-		return TRACE_TYPE_HANDLED;
+	int ret;
 
 	test_cpu_buff_start(iter);
 
@@ -1859,96 +1537,16 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 		lat_print_generic(s, entry, cpu);
 		lat_print_timestamp(s, abs_usecs, rel_usecs);
 	}
-	switch (entry->type) {
-	case TRACE_FN: {
-		struct ftrace_entry *field;
-
-		trace_assign_type(field, entry);
-
-		seq_print_ip_sym(s, field->ip, sym_flags);
-		trace_seq_puts(s, " (");
-		seq_print_ip_sym(s, field->parent_ip, sym_flags);
-		trace_seq_puts(s, ")\n");
-		break;
-	}
-	case TRACE_CTX:
-	case TRACE_WAKE: {
-		struct ctx_switch_entry *field;
-
-		trace_assign_type(field, entry);
-
-		T = task_state_char(field->next_state);
-		S = task_state_char(field->prev_state);
-		comm = trace_find_cmdline(field->next_pid);
-		trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
-				 field->prev_pid,
-				 field->prev_prio,
-				 S, entry->type == TRACE_CTX ? "==>" : "  +",
-				 field->next_cpu,
-				 field->next_pid,
-				 field->next_prio,
-				 T, comm);
-		break;
-	}
-	case TRACE_SPECIAL: {
-		struct special_entry *field;
-
-		trace_assign_type(field, entry);
-
-		trace_seq_printf(s, "# %ld %ld %ld\n",
-				 field->arg1,
-				 field->arg2,
-				 field->arg3);
-		break;
-	}
-	case TRACE_STACK: {
-		struct stack_entry *field;
-
-		trace_assign_type(field, entry);
-
-		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
-			if (i)
-				trace_seq_puts(s, " <= ");
-			seq_print_ip_sym(s, field->caller[i], sym_flags);
-		}
-		trace_seq_puts(s, "\n");
-		break;
-	}
-	case TRACE_PRINT: {
-		struct print_entry *field;
-
-		trace_assign_type(field, entry);
 
-		seq_print_ip_sym(s, field->ip, sym_flags);
-		trace_seq_printf(s, ": %s", field->buf);
-		if (entry->flags & TRACE_FLAG_CONT)
-			trace_seq_print_cont(s, iter);
-		break;
-	}
-	case TRACE_BRANCH: {
-		struct trace_branch *field;
-
-		trace_assign_type(field, entry);
-
-		trace_seq_printf(s, "[%s] %s:%s:%d\n",
-				 field->correct ? "  ok  " : " MISS ",
-				 field->func,
-				 field->file,
-				 field->line);
-		break;
+	event = ftrace_find_event(entry->type);
+	if (event && event->latency_trace) {
+		ret = event->latency_trace(s, entry, sym_flags);
+		if (ret)
+			return ret;
+		return TRACE_TYPE_HANDLED;
 	}
-	case TRACE_USER_STACK: {
-		struct userstack_entry *field;
-
-		trace_assign_type(field, entry);
 
-		seq_print_userip_objs(field, s, sym_flags);
-		trace_seq_putc(s, '\n');
-		break;
-	}
-	default:
-		trace_seq_printf(s, "Unknown type %d\n", entry->type);
-	}
+	trace_seq_printf(s, "Unknown type %d\n", entry->type);
 	return TRACE_TYPE_HANDLED;
 }
 
@@ -1957,19 +1555,15 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 	struct trace_seq *s = &iter->seq;
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
 	struct trace_entry *entry;
+	struct trace_event *event;
 	unsigned long usec_rem;
 	unsigned long long t;
 	unsigned long secs;
 	char *comm;
 	int ret;
-	int S, T;
-	int i;
 
 	entry = iter->ent;
 
-	if (entry->type == TRACE_CONT)
-		return TRACE_TYPE_HANDLED;
-
 	test_cpu_buff_start(iter);
 
 	comm = trace_find_cmdline(iter->ent->pid);
@@ -1988,129 +1582,17 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	switch (entry->type) {
-	case TRACE_FN: {
-		struct ftrace_entry *field;
-
-		trace_assign_type(field, entry);
-
-		ret = seq_print_ip_sym(s, field->ip, sym_flags);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		if ((sym_flags & TRACE_ITER_PRINT_PARENT) &&
-						field->parent_ip) {
-			ret = trace_seq_printf(s, " <-");
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-			ret = seq_print_ip_sym(s,
-					       field->parent_ip,
-					       sym_flags);
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
-		ret = trace_seq_printf(s, "\n");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		break;
-	}
-	case TRACE_CTX:
-	case TRACE_WAKE: {
-		struct ctx_switch_entry *field;
-
-		trace_assign_type(field, entry);
-
-		T = task_state_char(field->next_state);
-		S = task_state_char(field->prev_state);
-		ret = trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c\n",
-				       field->prev_pid,
-				       field->prev_prio,
-				       S,
-				       entry->type == TRACE_CTX ? "==>" : "  +",
-				       field->next_cpu,
-				       field->next_pid,
-				       field->next_prio,
-				       T);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		break;
-	}
-	case TRACE_SPECIAL: {
-		struct special_entry *field;
-
-		trace_assign_type(field, entry);
-
-		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
-				 field->arg1,
-				 field->arg2,
-				 field->arg3);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		break;
-	}
-	case TRACE_STACK: {
-		struct stack_entry *field;
-
-		trace_assign_type(field, entry);
-
-		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
-			if (i) {
-				ret = trace_seq_puts(s, " <= ");
-				if (!ret)
-					return TRACE_TYPE_PARTIAL_LINE;
-			}
-			ret = seq_print_ip_sym(s, field->caller[i],
-					       sym_flags);
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
-		ret = trace_seq_puts(s, "\n");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		break;
-	}
-	case TRACE_PRINT: {
-		struct print_entry *field;
-
-		trace_assign_type(field, entry);
-
-		seq_print_ip_sym(s, field->ip, sym_flags);
-		trace_seq_printf(s, ": %s", field->buf);
-		if (entry->flags & TRACE_FLAG_CONT)
-			trace_seq_print_cont(s, iter);
-		break;
-	}
-	case TRACE_GRAPH_RET: {
-		return print_graph_function(iter);
-	}
-	case TRACE_GRAPH_ENT: {
-		return print_graph_function(iter);
-	}
-	case TRACE_BRANCH: {
-		struct trace_branch *field;
-
-		trace_assign_type(field, entry);
-
-		trace_seq_printf(s, "[%s] %s:%s:%d\n",
-				 field->correct ? "  ok  " : " MISS ",
-				 field->func,
-				 field->file,
-				 field->line);
-		break;
+	event = ftrace_find_event(entry->type);
+	if (event && event->trace) {
+		ret = event->trace(s, entry, sym_flags);
+		if (ret)
+			return ret;
+		return TRACE_TYPE_HANDLED;
 	}
-	case TRACE_USER_STACK: {
-		struct userstack_entry *field;
-
-		trace_assign_type(field, entry);
+	ret = trace_seq_printf(s, "Unknown type %d\n", entry->type);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
 
-		ret = seq_print_userip_objs(field, s, sym_flags);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		ret = trace_seq_putc(s, '\n');
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		break;
-	}
-	}
 	return TRACE_TYPE_HANDLED;
 }
 
@@ -2118,152 +1600,47 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry;
+	struct trace_event *event;
 	int ret;
-	int S, T;
 
 	entry = iter->ent;
 
-	if (entry->type == TRACE_CONT)
-		return TRACE_TYPE_HANDLED;
-
 	ret = trace_seq_printf(s, "%d %d %llu ",
 		entry->pid, iter->cpu, iter->ts);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	switch (entry->type) {
-	case TRACE_FN: {
-		struct ftrace_entry *field;
-
-		trace_assign_type(field, entry);
-
-		ret = trace_seq_printf(s, "%x %x\n",
-					field->ip,
-					field->parent_ip);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		break;
-	}
-	case TRACE_CTX:
-	case TRACE_WAKE: {
-		struct ctx_switch_entry *field;
-
-		trace_assign_type(field, entry);
-
-		T = task_state_char(field->next_state);
-		S = entry->type == TRACE_WAKE ? '+' :
-			task_state_char(field->prev_state);
-		ret = trace_seq_printf(s, "%d %d %c %d %d %d %c\n",
-				       field->prev_pid,
-				       field->prev_prio,
-				       S,
-				       field->next_cpu,
-				       field->next_pid,
-				       field->next_prio,
-				       T);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		break;
-	}
-	case TRACE_SPECIAL:
-	case TRACE_USER_STACK:
-	case TRACE_STACK: {
-		struct special_entry *field;
-
-		trace_assign_type(field, entry);
-
-		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
-				 field->arg1,
-				 field->arg2,
-				 field->arg3);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		break;
+	event = ftrace_find_event(entry->type);
+	if (event && event->raw) {
+		ret = event->raw(s, entry, 0);
+		if (ret)
+			return ret;
+		return TRACE_TYPE_HANDLED;
 	}
-	case TRACE_PRINT: {
-		struct print_entry *field;
-
-		trace_assign_type(field, entry);
+	ret = trace_seq_printf(s, "%d ?\n", entry->type);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
 
-		trace_seq_printf(s, "# %lx %s", field->ip, field->buf);
-		if (entry->flags & TRACE_FLAG_CONT)
-			trace_seq_print_cont(s, iter);
-		break;
-	}
-	}
 	return TRACE_TYPE_HANDLED;
 }
 
-#define SEQ_PUT_FIELD_RET(s, x)				\
-do {							\
-	if (!trace_seq_putmem(s, &(x), sizeof(x)))	\
-		return 0;				\
-} while (0)
-
-#define SEQ_PUT_HEX_FIELD_RET(s, x)			\
-do {							\
-	BUILD_BUG_ON(sizeof(x) > MAX_MEMHEX_BYTES);	\
-	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
-		return 0;				\
-} while (0)
-
 static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	unsigned char newline = '\n';
 	struct trace_entry *entry;
-	int S, T;
+	struct trace_event *event;
 
 	entry = iter->ent;
 
-	if (entry->type == TRACE_CONT)
-		return TRACE_TYPE_HANDLED;
-
 	SEQ_PUT_HEX_FIELD_RET(s, entry->pid);
 	SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
 	SEQ_PUT_HEX_FIELD_RET(s, iter->ts);
 
-	switch (entry->type) {
-	case TRACE_FN: {
-		struct ftrace_entry *field;
+	event = ftrace_find_event(entry->type);
+	if (event && event->hex)
+		event->hex(s, entry, 0);
 
-		trace_assign_type(field, entry);
-
-		SEQ_PUT_HEX_FIELD_RET(s, field->ip);
-		SEQ_PUT_HEX_FIELD_RET(s, field->parent_ip);
-		break;
-	}
-	case TRACE_CTX:
-	case TRACE_WAKE: {
-		struct ctx_switch_entry *field;
-
-		trace_assign_type(field, entry);
-
-		T = task_state_char(field->next_state);
-		S = entry->type == TRACE_WAKE ? '+' :
-			task_state_char(field->prev_state);
-		SEQ_PUT_HEX_FIELD_RET(s, field->prev_pid);
-		SEQ_PUT_HEX_FIELD_RET(s, field->prev_prio);
-		SEQ_PUT_HEX_FIELD_RET(s, S);
-		SEQ_PUT_HEX_FIELD_RET(s, field->next_cpu);
-		SEQ_PUT_HEX_FIELD_RET(s, field->next_pid);
-		SEQ_PUT_HEX_FIELD_RET(s, field->next_prio);
-		SEQ_PUT_HEX_FIELD_RET(s, T);
-		break;
-	}
-	case TRACE_SPECIAL:
-	case TRACE_USER_STACK:
-	case TRACE_STACK: {
-		struct special_entry *field;
-
-		trace_assign_type(field, entry);
-
-		SEQ_PUT_HEX_FIELD_RET(s, field->arg1);
-		SEQ_PUT_HEX_FIELD_RET(s, field->arg2);
-		SEQ_PUT_HEX_FIELD_RET(s, field->arg3);
-		break;
-	}
-	}
 	SEQ_PUT_FIELD_RET(s, newline);
 
 	return TRACE_TYPE_HANDLED;
@@ -2282,9 +1659,6 @@ static enum print_line_t print_printk_msg_only(struct trace_iterator *iter)
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	if (entry->flags & TRACE_FLAG_CONT)
-		trace_seq_print_cont(s, iter);
-
 	return TRACE_TYPE_HANDLED;
 }
 
@@ -2292,53 +1666,19 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry;
+	struct trace_event *event;
 
 	entry = iter->ent;
 
-	if (entry->type == TRACE_CONT)
-		return TRACE_TYPE_HANDLED;
-
 	SEQ_PUT_FIELD_RET(s, entry->pid);
 	SEQ_PUT_FIELD_RET(s, entry->cpu);
 	SEQ_PUT_FIELD_RET(s, iter->ts);
 
-	switch (entry->type) {
-	case TRACE_FN: {
-		struct ftrace_entry *field;
-
-		trace_assign_type(field, entry);
-
-		SEQ_PUT_FIELD_RET(s, field->ip);
-		SEQ_PUT_FIELD_RET(s, field->parent_ip);
-		break;
-	}
-	case TRACE_CTX: {
-		struct ctx_switch_entry *field;
-
-		trace_assign_type(field, entry);
-
-		SEQ_PUT_FIELD_RET(s, field->prev_pid);
-		SEQ_PUT_FIELD_RET(s, field->prev_prio);
-		SEQ_PUT_FIELD_RET(s, field->prev_state);
-		SEQ_PUT_FIELD_RET(s, field->next_pid);
-		SEQ_PUT_FIELD_RET(s, field->next_prio);
-		SEQ_PUT_FIELD_RET(s, field->next_state);
-		break;
-	}
-	case TRACE_SPECIAL:
-	case TRACE_USER_STACK:
-	case TRACE_STACK: {
-		struct special_entry *field;
-
-		trace_assign_type(field, entry);
+	event = ftrace_find_event(entry->type);
+	if (event && event->binary)
+		event->binary(s, entry, 0);
 
-		SEQ_PUT_FIELD_RET(s, field->arg1);
-		SEQ_PUT_FIELD_RET(s, field->arg2);
-		SEQ_PUT_FIELD_RET(s, field->arg3);
-		break;
-	}
-	}
-	return 1;
+	return TRACE_TYPE_HANDLED;
 }
 
 static int trace_empty(struct trace_iterator *iter)
@@ -3013,6 +2353,7 @@ static int tracing_set_tracer(char *buf)
 		if (ret)
 			goto out;
 	}
+	init_tracer_stat(t);
 
 	trace_branch_enable(tr);
  out:
@@ -3877,7 +3218,7 @@ __init static int tracer_alloc_buffers(void)
 #else
 	current_trace = &nop_trace;
 #endif
-
+	init_tracer_stat(current_trace);
 	/* All seems OK, enable tracing */
 	tracing_disabled = 0;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4d3d381..94ed45e 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -9,6 +9,7 @@
 #include <linux/mmiotrace.h>
 #include <linux/ftrace.h>
 #include <trace/boot.h>
+#include <trace/kmemtrace.h>
 
 enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
@@ -16,7 +17,6 @@ enum trace_type {
 	TRACE_FN,
 	TRACE_CTX,
 	TRACE_WAKE,
-	TRACE_CONT,
 	TRACE_STACK,
 	TRACE_PRINT,
 	TRACE_SPECIAL,
@@ -29,9 +29,11 @@ enum trace_type {
 	TRACE_GRAPH_ENT,
 	TRACE_USER_STACK,
 	TRACE_HW_BRANCHES,
+	TRACE_KMEM_ALLOC,
+	TRACE_KMEM_FREE,
 	TRACE_POWER,
 
-	__TRACE_LAST_TYPE
+	__TRACE_LAST_TYPE,
 };
 
 /*
@@ -170,6 +172,24 @@ struct trace_power {
 	struct power_trace	state_data;
 };
 
+struct kmemtrace_alloc_entry {
+	struct trace_entry	ent;
+	enum kmemtrace_type_id type_id;
+	unsigned long call_site;
+	const void *ptr;
+	size_t bytes_req;
+	size_t bytes_alloc;
+	gfp_t gfp_flags;
+	int node;
+};
+
+struct kmemtrace_free_entry {
+	struct trace_entry	ent;
+	enum kmemtrace_type_id type_id;
+	unsigned long call_site;
+	const void *ptr;
+};
+
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
@@ -178,7 +198,6 @@ struct trace_power {
  *  NEED_RESCED		- reschedule is requested
  *  HARDIRQ		- inside an interrupt handler
  *  SOFTIRQ		- inside a softirq handler
- *  CONT		- multiple entries hold the trace item
  */
 enum trace_flag_type {
 	TRACE_FLAG_IRQS_OFF		= 0x01,
@@ -186,7 +205,6 @@ enum trace_flag_type {
 	TRACE_FLAG_NEED_RESCHED		= 0x04,
 	TRACE_FLAG_HARDIRQ		= 0x08,
 	TRACE_FLAG_SOFTIRQ		= 0x10,
-	TRACE_FLAG_CONT			= 0x20,
 };
 
 #define TRACE_BUF_SIZE		1024
@@ -262,7 +280,6 @@ extern void __ftrace_bad_type(void);
 	do {								\
 		IF_ASSIGN(var, ent, struct ftrace_entry, TRACE_FN);	\
 		IF_ASSIGN(var, ent, struct ctx_switch_entry, 0);	\
-		IF_ASSIGN(var, ent, struct trace_field_cont, TRACE_CONT); \
 		IF_ASSIGN(var, ent, struct stack_entry, TRACE_STACK);	\
 		IF_ASSIGN(var, ent, struct userstack_entry, TRACE_USER_STACK);\
 		IF_ASSIGN(var, ent, struct print_entry, TRACE_PRINT);	\
@@ -280,6 +297,10 @@ extern void __ftrace_bad_type(void);
 			  TRACE_GRAPH_RET);		\
 		IF_ASSIGN(var, ent, struct hw_branch_entry, TRACE_HW_BRANCHES);\
  		IF_ASSIGN(var, ent, struct trace_power, TRACE_POWER); \
+		IF_ASSIGN(var, ent, struct kmemtrace_alloc_entry,	\
+			  TRACE_KMEM_ALLOC);	\
+		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
+			  TRACE_KMEM_FREE);	\
 		__ftrace_bad_type();					\
 	} while (0)
 
@@ -340,6 +361,21 @@ struct tracer {
 	struct tracer		*next;
 	int			print_max;
 	struct tracer_flags 	*flags;
+
+	/*
+	 * If you change one of the following on tracing runtime, recall
+	 * init_tracer_stat()
+	 */
+
+	/* Iteration over statistic entries */
+	void			*(*stat_start)(void);
+	void			*(*stat_next)(void *prev, int idx);
+	/* Compare two entries for sorting (optional) for stats */
+	int			(*stat_cmp)(void *p1, void *p2);
+	/* Print a stat entry */
+	int			(*stat_show)(struct seq_file *s, void *p);
+	/* Print the headers of your stat entries */
+	int			(*stat_headers)(struct seq_file *s);
 };
 
 struct trace_seq {
@@ -425,6 +461,8 @@ void tracing_start_sched_switch_record(void);
 int register_tracer(struct tracer *type);
 void unregister_tracer(struct tracer *type);
 
+void init_tracer_stat(struct tracer *trace);
+
 extern unsigned long nsecs_to_usecs(unsigned long nsecs);
 
 extern unsigned long tracing_max_latency;
@@ -456,10 +494,10 @@ struct tracer_switch_ops {
 	void				*private;
 	struct tracer_switch_ops	*next;
 };
-
-char *trace_find_cmdline(int pid);
 #endif /* CONFIG_CONTEXT_SWITCH_TRACER */
 
+extern char *trace_find_cmdline(int pid);
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 extern unsigned long ftrace_update_tot_cnt;
 #define DYN_FTRACE_TEST_NAME trace_selftest_dynamic_test_func
@@ -488,15 +526,6 @@ extern int trace_selftest_startup_branch(struct tracer *trace,
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
 
 extern void *head_page(struct trace_array_cpu *data);
-extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
-extern void trace_seq_print_cont(struct trace_seq *s,
-				 struct trace_iterator *iter);
-
-extern int
-seq_print_ip_sym(struct trace_seq *s, unsigned long ip,
-		unsigned long sym_flags);
-extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
-				 size_t cnt);
 extern long ns2usecs(cycle_t nsec);
 extern int
 trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args);
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 366c8c3..0e94b3d 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -11,6 +11,7 @@
 #include <linux/kallsyms.h>
 
 #include "trace.h"
+#include "trace_output.h"
 
 static struct trace_array *boot_trace;
 static bool pre_initcalls_finished;
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 6c00feb..4785a3b 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -14,12 +14,17 @@
 #include <linux/hash.h>
 #include <linux/fs.h>
 #include <asm/local.h>
+
 #include "trace.h"
+#include "trace_output.h"
+
+static struct tracer branch_trace;
 
 #ifdef CONFIG_BRANCH_TRACER
 
 static int branch_tracing_enabled __read_mostly;
 static DEFINE_MUTEX(branch_tracing_mutex);
+
 static struct trace_array *branch_tracer;
 
 static void
@@ -142,22 +147,50 @@ static void branch_trace_reset(struct trace_array *tr)
 	stop_branch_trace(tr);
 }
 
-struct tracer branch_trace __read_mostly =
+static int
+trace_print_print(struct trace_seq *s, struct trace_entry *entry, int flags)
 {
-	.name		= "branch",
-	.init		= branch_trace_init,
-	.reset		= branch_trace_reset,
-#ifdef CONFIG_FTRACE_SELFTEST
-	.selftest	= trace_selftest_startup_branch,
-#endif
-};
+	struct print_entry *field;
 
-__init static int init_branch_trace(void)
+	trace_assign_type(field, entry);
+
+	if (seq_print_ip_sym(s, field->ip, flags))
+		goto partial;
+
+	if (trace_seq_printf(s, ": %s", field->buf))
+		goto partial;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static int
+trace_branch_print(struct trace_seq *s, struct trace_entry *entry, int flags)
 {
-	return register_tracer(&branch_trace);
+	struct trace_branch *field;
+
+	trace_assign_type(field, entry);
+
+	if (trace_seq_printf(s, "[%s] %s:%s:%d\n",
+			     field->correct ? "  ok  " : " MISS ",
+			     field->func,
+			     field->file,
+			     field->line))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return 0;
 }
 
-device_initcall(init_branch_trace);
+
+static struct trace_event trace_branch_event = {
+	.type	 	= TRACE_BRANCH,
+	.trace		= trace_branch_print,
+	.latency_trace	= trace_branch_print,
+	.raw		= trace_nop_print,
+	.hex		= trace_nop_print,
+	.binary		= trace_nop_print,
+};
+
 #else
 static inline
 void trace_likely_condition(struct ftrace_branch_data *f, int val, int expect)
@@ -183,66 +216,39 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect)
 }
 EXPORT_SYMBOL(ftrace_likely_update);
 
-struct ftrace_pointer {
-	void		*start;
-	void		*stop;
-	int		hit;
-};
+extern unsigned long __start_annotated_branch_profile[];
+extern unsigned long __stop_annotated_branch_profile[];
 
-static void *
-t_next(struct seq_file *m, void *v, loff_t *pos)
+static int annotated_branch_stat_headers(struct seq_file *m)
 {
-	const struct ftrace_pointer *f = m->private;
-	struct ftrace_branch_data *p = v;
-
-	(*pos)++;
-
-	if (v == (void *)1)
-		return f->start;
-
-	++p;
-
-	if ((void *)p >= (void *)f->stop)
-		return NULL;
-
-	return p;
+	seq_printf(m, " correct incorrect  %% ");
+	seq_printf(m, "       Function                "
+			      "  File              Line\n"
+			      " ------- ---------  - "
+			      "       --------                "
+			      "  ----              ----\n");
+	return 0;
 }
 
-static void *t_start(struct seq_file *m, loff_t *pos)
+static inline long get_incorrect_percent(struct ftrace_branch_data *p)
 {
-	void *t = (void *)1;
-	loff_t l = 0;
-
-	for (; t && l < *pos; t = t_next(m, t, &l))
-		;
+	long percent;
 
-	return t;
-}
+	if (p->correct) {
+		percent = p->incorrect * 100;
+		percent /= p->correct + p->incorrect;
+	} else
+		percent = p->incorrect ? 100 : -1;
 
-static void t_stop(struct seq_file *m, void *p)
-{
+	return percent;
 }
 
-static int t_show(struct seq_file *m, void *v)
+static int branch_stat_show(struct seq_file *m, void *v)
 {
-	const struct ftrace_pointer *fp = m->private;
 	struct ftrace_branch_data *p = v;
 	const char *f;
 	long percent;
 
-	if (v == (void *)1) {
-		if (fp->hit)
-			seq_printf(m, "   miss      hit    %% ");
-		else
-			seq_printf(m, " correct incorrect  %% ");
-		seq_printf(m, "       Function                "
-			      "  File              Line\n"
-			      " ------- ---------  - "
-			      "       --------                "
-			      "  ----              ----\n");
-		return 0;
-	}
-
 	/* Only print the file, not the path */
 	f = p->file + strlen(p->file);
 	while (f >= p->file && *f != '/')
@@ -252,11 +258,7 @@ static int t_show(struct seq_file *m, void *v)
 	/*
 	 * The miss is overlayed on correct, and hit on incorrect.
 	 */
-	if (p->correct) {
-		percent = p->incorrect * 100;
-		percent /= p->correct + p->incorrect;
-	} else
-		percent = p->incorrect ? 100 : -1;
+	percent = get_incorrect_percent(p);
 
 	seq_printf(m, "%8lu %8lu ",  p->correct, p->incorrect);
 	if (percent < 0)
@@ -267,76 +269,143 @@ static int t_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static struct seq_operations tracing_likely_seq_ops = {
-	.start		= t_start,
-	.next		= t_next,
-	.stop		= t_stop,
-	.show		= t_show,
-};
+static void *annotated_branch_stat_start(void)
+{
+	return __start_annotated_branch_profile;
+}
 
-static int tracing_branch_open(struct inode *inode, struct file *file)
+static void *
+annotated_branch_stat_next(void *v, int idx)
 {
-	int ret;
+	struct ftrace_branch_data *p = v;
 
-	ret = seq_open(file, &tracing_likely_seq_ops);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		m->private = (void *)inode->i_private;
-	}
+	++p;
 
-	return ret;
+	if ((void *)p >= (void *)__stop_annotated_branch_profile)
+		return NULL;
+
+	return p;
 }
 
-static const struct file_operations tracing_branch_fops = {
-	.open		= tracing_branch_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+static int annotated_branch_stat_cmp(void *p1, void *p2)
+{
+	struct ftrace_branch_data *a = p1;
+	struct ftrace_branch_data *b = p2;
+
+	long percent_a, percent_b;
+
+	percent_a = get_incorrect_percent(a);
+	percent_b = get_incorrect_percent(b);
+
+	if (percent_a < percent_b)
+		return -1;
+	if (percent_a > percent_b)
+		return 1;
+	else
+		return 0;
+}
 
 #ifdef CONFIG_PROFILE_ALL_BRANCHES
-extern unsigned long __start_branch_profile[];
-extern unsigned long __stop_branch_profile[];
+enum {
+	TRACE_BRANCH_OPT_ALL = 0x1
+};
 
-static const struct ftrace_pointer ftrace_branch_pos = {
-	.start			= __start_branch_profile,
-	.stop			= __stop_branch_profile,
-	.hit			= 1,
+static struct tracer_opt branch_opts[] = {
+	{ TRACER_OPT(stat_all_branch, TRACE_BRANCH_OPT_ALL) },
+	{ }
 };
 
-#endif /* CONFIG_PROFILE_ALL_BRANCHES */
+static struct tracer_flags branch_flags = {
+	.val = 0,
+	.opts = branch_opts
+};
 
-extern unsigned long __start_annotated_branch_profile[];
-extern unsigned long __stop_annotated_branch_profile[];
+extern unsigned long __start_branch_profile[];
+extern unsigned long __stop_branch_profile[];
 
-static const struct ftrace_pointer ftrace_annotated_branch_pos = {
-	.start			= __start_annotated_branch_profile,
-	.stop			= __stop_annotated_branch_profile,
-};
+static int all_branch_stat_headers(struct seq_file *m)
+{
+	seq_printf(m, "   miss      hit    %% ");
+	seq_printf(m, "       Function                "
+			      "  File              Line\n"
+			      " ------- ---------  - "
+			      "       --------                "
+			      "  ----              ----\n");
+	return 0;
+}
+
+static void *all_branch_stat_start(void)
+{
+	return __start_branch_profile;
+}
 
-static __init int ftrace_branch_init(void)
+static void *
+all_branch_stat_next(void *v, int idx)
 {
-	struct dentry *d_tracer;
-	struct dentry *entry;
+	struct ftrace_branch_data *p = v;
 
-	d_tracer = tracing_init_dentry();
+	++p;
 
-	entry = debugfs_create_file("profile_annotated_branch", 0444, d_tracer,
-				    (void *)&ftrace_annotated_branch_pos,
-				    &tracing_branch_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'profile_annotatet_branch' entry\n");
+	if ((void *)p >= (void *)__stop_branch_profile)
+		return NULL;
 
-#ifdef CONFIG_PROFILE_ALL_BRANCHES
-	entry = debugfs_create_file("profile_branch", 0444, d_tracer,
-				    (void *)&ftrace_branch_pos,
-				    &tracing_branch_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs"
-			   " 'profile_branch' entry\n");
-#endif
+	return p;
+}
 
+static int branch_set_flag(u32 old_flags, u32 bit, int set)
+{
+	if (bit == TRACE_BRANCH_OPT_ALL) {
+		if (set) {
+			branch_trace.stat_headers = all_branch_stat_headers;
+			branch_trace.stat_start = all_branch_stat_start;
+			branch_trace.stat_next = all_branch_stat_next;
+			branch_trace.stat_cmp = NULL;
+		} else {
+			branch_trace.stat_headers =
+				annotated_branch_stat_headers;
+			branch_trace.stat_start = annotated_branch_stat_start;
+			branch_trace.stat_next = annotated_branch_stat_next;
+			branch_trace.stat_cmp = annotated_branch_stat_cmp;
+		}
+		init_tracer_stat(&branch_trace);
+	}
 	return 0;
 }
 
-device_initcall(ftrace_branch_init);
+#endif /* CONFIG_PROFILE_ALL_BRANCHES */
+
+static struct tracer branch_trace __read_mostly =
+{
+	.name		= "branch",
+#ifdef CONFIG_BRANCH_TRACER
+	.init		= branch_trace_init,
+	.reset		= branch_trace_reset,
+#ifdef CONFIG_FTRACE_SELFTEST
+	.selftest	= trace_selftest_startup_branch,
+#endif /* CONFIG_FTRACE_SELFTEST */
+#endif /* CONFIG_BRANCH_TRACER */
+	.stat_start	=	annotated_branch_stat_start,
+	.stat_next	= annotated_branch_stat_next,
+	.stat_show	= branch_stat_show,
+	.stat_headers	= annotated_branch_stat_headers,
+	.stat_cmp	= annotated_branch_stat_cmp,
+#ifdef CONFIG_PROFILE_ALL_BRANCHES
+	.flags	= &branch_flags,
+	.set_flag	= branch_set_flag,
+#endif
+};
+
+__init static int init_branch_trace(void)
+{
+#ifdef CONFIG_BRANCH_TRACER
+	int ret;
+	ret = register_ftrace_event(&trace_branch_event);
+	if (!ret) {
+		printk(KERN_WARNING "Warning: could not register branch events\n");
+		return 1;
+	}
+#endif
+
+	return register_tracer(&branch_trace);
+}
+device_initcall(init_branch_trace);
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 930c08e..3c54598 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -12,6 +12,7 @@
 #include <linux/fs.h>
 
 #include "trace.h"
+#include "trace_output.h"
 
 #define TRACE_GRAPH_INDENT	2
 
@@ -589,8 +590,11 @@ print_graph_comment(struct print_entry *trace, struct trace_seq *s,
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	if (ent->flags & TRACE_FLAG_CONT)
-		trace_seq_print_cont(s, iter);
+	/* Strip ending newline */
+	if (s->buffer[s->len - 1] == '\n') {
+		s->buffer[s->len - 1] = '\0';
+		s->len--;
+	}
 
 	ret = trace_seq_printf(s, " */\n");
 	if (!ret)
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index 649df22..df21c1e 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -14,6 +14,7 @@
 #include <asm/ds.h>
 
 #include "trace.h"
+#include "trace_output.h"
 
 
 #define SIZEOF_BTS (1 << 13)
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index fffcb06..fcec59f 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -11,6 +11,7 @@
 #include <linux/pci.h>
 
 #include "trace.h"
+#include "trace_output.h"
 
 struct header_iter {
 	struct pci_dev *dev;
@@ -262,9 +263,6 @@ static enum print_line_t mmio_print_mark(struct trace_iterator *iter)
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	if (entry->flags & TRACE_FLAG_CONT)
-		trace_seq_print_cont(s, iter);
-
 	return TRACE_TYPE_HANDLED;
 }
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
new file mode 100644
index 0000000..df0c25c
--- /dev/null
+++ b/kernel/trace/trace_output.c
@@ -0,0 +1,832 @@
+/*
+ * trace_output.c
+ *
+ * Copyright (C) 2008 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/ftrace.h>
+
+#include "trace_output.h"
+
+/* must be a power of 2 */
+#define EVENT_HASHSIZE	128
+
+static DEFINE_MUTEX(trace_event_mutex);
+static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
+
+static int next_event_type = __TRACE_LAST_TYPE + 1;
+
+/**
+ * trace_seq_printf - sequence printing of trace information
+ * @s: trace sequence descriptor
+ * @fmt: printf format string
+ *
+ * The tracer may use either sequence operations or its own
+ * copy to user routines. To simplify formating of a trace
+ * trace_seq_printf is used to store strings into a special
+ * buffer (@s). Then the output may be either used by
+ * the sequencer or pulled into another buffer.
+ */
+int
+trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+{
+	int len = (PAGE_SIZE - 1) - s->len;
+	va_list ap;
+	int ret;
+
+	if (!len)
+		return 0;
+
+	va_start(ap, fmt);
+	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
+	va_end(ap);
+
+	/* If we can't write it all, don't bother writing anything */
+	if (ret >= len)
+		return 0;
+
+	s->len += ret;
+
+	return len;
+}
+
+/**
+ * trace_seq_puts - trace sequence printing of simple string
+ * @s: trace sequence descriptor
+ * @str: simple string to record
+ *
+ * The tracer may use either the sequence operations or its own
+ * copy to user routines. This function records a simple string
+ * into a special buffer (@s) for later retrieval by a sequencer
+ * or other mechanism.
+ */
+int trace_seq_puts(struct trace_seq *s, const char *str)
+{
+	int len = strlen(str);
+
+	if (len > ((PAGE_SIZE - 1) - s->len))
+		return 0;
+
+	memcpy(s->buffer + s->len, str, len);
+	s->len += len;
+
+	return len;
+}
+
+int trace_seq_putc(struct trace_seq *s, unsigned char c)
+{
+	if (s->len >= (PAGE_SIZE - 1))
+		return 0;
+
+	s->buffer[s->len++] = c;
+
+	return 1;
+}
+
+int trace_seq_putmem(struct trace_seq *s, void *mem, size_t len)
+{
+	if (len > ((PAGE_SIZE - 1) - s->len))
+		return 0;
+
+	memcpy(s->buffer + s->len, mem, len);
+	s->len += len;
+
+	return len;
+}
+
+int trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
+{
+	unsigned char hex[HEX_CHARS];
+	unsigned char *data = mem;
+	int i, j;
+
+#ifdef __BIG_ENDIAN
+	for (i = 0, j = 0; i < len; i++) {
+#else
+	for (i = len-1, j = 0; i >= 0; i--) {
+#endif
+		hex[j++] = hex_asc_hi(data[i]);
+		hex[j++] = hex_asc_lo(data[i]);
+	}
+	hex[j++] = ' ';
+
+	return trace_seq_putmem(s, hex, j);
+}
+
+int trace_seq_path(struct trace_seq *s, struct path *path)
+{
+	unsigned char *p;
+
+	if (s->len >= (PAGE_SIZE - 1))
+		return 0;
+	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
+	if (!IS_ERR(p)) {
+		p = mangle_path(s->buffer + s->len, p, "\n");
+		if (p) {
+			s->len = p - s->buffer;
+			return 1;
+		}
+	} else {
+		s->buffer[s->len++] = '?';
+		return 1;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_KRETPROBES
+static inline const char *kretprobed(const char *name)
+{
+	static const char tramp_name[] = "kretprobe_trampoline";
+	int size = sizeof(tramp_name);
+
+	if (strncmp(tramp_name, name, size) == 0)
+		return "[unknown/kretprobe'd]";
+	return name;
+}
+#else
+static inline const char *kretprobed(const char *name)
+{
+	return name;
+}
+#endif /* CONFIG_KRETPROBES */
+
+static int
+seq_print_sym_short(struct trace_seq *s, const char *fmt, unsigned long address)
+{
+#ifdef CONFIG_KALLSYMS
+	char str[KSYM_SYMBOL_LEN];
+	const char *name;
+
+	kallsyms_lookup(address, NULL, NULL, NULL, str);
+
+	name = kretprobed(str);
+
+	return trace_seq_printf(s, fmt, name);
+#endif
+	return 1;
+}
+
+static int
+seq_print_sym_offset(struct trace_seq *s, const char *fmt,
+		     unsigned long address)
+{
+#ifdef CONFIG_KALLSYMS
+	char str[KSYM_SYMBOL_LEN];
+	const char *name;
+
+	sprint_symbol(str, address);
+	name = kretprobed(str);
+
+	return trace_seq_printf(s, fmt, name);
+#endif
+	return 1;
+}
+
+#ifndef CONFIG_64BIT
+# define IP_FMT "%08lx"
+#else
+# define IP_FMT "%016lx"
+#endif
+
+int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
+		      unsigned long ip, unsigned long sym_flags)
+{
+	struct file *file = NULL;
+	unsigned long vmstart = 0;
+	int ret = 1;
+
+	if (mm) {
+		const struct vm_area_struct *vma;
+
+		down_read(&mm->mmap_sem);
+		vma = find_vma(mm, ip);
+		if (vma) {
+			file = vma->vm_file;
+			vmstart = vma->vm_start;
+		}
+		if (file) {
+			ret = trace_seq_path(s, &file->f_path);
+			if (ret)
+				ret = trace_seq_printf(s, "[+0x%lx]",
+						       ip - vmstart);
+		}
+		up_read(&mm->mmap_sem);
+	}
+	if (ret && ((sym_flags & TRACE_ITER_SYM_ADDR) || !file))
+		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
+	return ret;
+}
+
+int
+seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
+		      unsigned long sym_flags)
+{
+	struct mm_struct *mm = NULL;
+	int ret = 1;
+	unsigned int i;
+
+	if (trace_flags & TRACE_ITER_SYM_USEROBJ) {
+		struct task_struct *task;
+		/*
+		 * we do the lookup on the thread group leader,
+		 * since individual threads might have already quit!
+		 */
+		rcu_read_lock();
+		task = find_task_by_vpid(entry->ent.tgid);
+		if (task)
+			mm = get_task_mm(task);
+		rcu_read_unlock();
+	}
+
+	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
+		unsigned long ip = entry->caller[i];
+
+		if (ip == ULONG_MAX || !ret)
+			break;
+		if (i && ret)
+			ret = trace_seq_puts(s, " <- ");
+		if (!ip) {
+			if (ret)
+				ret = trace_seq_puts(s, "??");
+			continue;
+		}
+		if (!ret)
+			break;
+		if (ret)
+			ret = seq_print_user_ip(s, mm, ip, sym_flags);
+	}
+
+	if (mm)
+		mmput(mm);
+	return ret;
+}
+
+int
+seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
+{
+	int ret;
+
+	if (!ip)
+		return trace_seq_printf(s, "0");
+
+	if (sym_flags & TRACE_ITER_SYM_OFFSET)
+		ret = seq_print_sym_offset(s, "%s", ip);
+	else
+		ret = seq_print_sym_short(s, "%s", ip);
+
+	if (!ret)
+		return 0;
+
+	if (sym_flags & TRACE_ITER_SYM_ADDR)
+		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
+	return ret;
+}
+
+static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
+
+static int task_state_char(unsigned long state)
+{
+	int bit = state ? __ffs(state) + 1 : 0;
+
+	return bit < sizeof(state_to_char) - 1 ? state_to_char[bit] : '?';
+}
+
+/**
+ * ftrace_find_event - find a registered event
+ * @type: the type of event to look for
+ *
+ * Returns an event of type @type otherwise NULL
+ */
+struct trace_event *ftrace_find_event(int type)
+{
+	struct trace_event *event;
+	struct hlist_node *n;
+	unsigned key;
+
+	key = type & (EVENT_HASHSIZE - 1);
+
+	hlist_for_each_entry_rcu(event, n, &event_hash[key], node) {
+		if (event->type == type)
+			return event;
+	}
+
+	return NULL;
+}
+
+/**
+ * register_ftrace_event - register output for an event type
+ * @event: the event type to register
+ *
+ * Event types are stored in a hash and this hash is used to
+ * find a way to print an event. If the @event->type is set
+ * then it will use that type, otherwise it will assign a
+ * type to use.
+ *
+ * If you assign your own type, please make sure it is added
+ * to the trace_type enum in trace.h, to avoid collisions
+ * with the dynamic types.
+ *
+ * Returns the event type number or zero on error.
+ */
+int register_ftrace_event(struct trace_event *event)
+{
+	unsigned key;
+	int ret = 0;
+
+	mutex_lock(&trace_event_mutex);
+
+	if (!event->type)
+		event->type = next_event_type++;
+	else if (event->type > __TRACE_LAST_TYPE) {
+		printk(KERN_WARNING "Need to add type to trace.h\n");
+		WARN_ON(1);
+	}
+
+	if (ftrace_find_event(event->type))
+		goto out;
+
+	key = event->type & (EVENT_HASHSIZE - 1);
+
+	hlist_add_head_rcu(&event->node, &event_hash[key]);
+
+	ret = event->type;
+ out:
+	mutex_unlock(&trace_event_mutex);
+
+	return ret;
+}
+
+/**
+ * unregister_ftrace_event - remove a no longer used event
+ * @event: the event to remove
+ */
+int unregister_ftrace_event(struct trace_event *event)
+{
+	mutex_lock(&trace_event_mutex);
+	hlist_del(&event->node);
+	mutex_unlock(&trace_event_mutex);
+
+	return 0;
+}
+
+/*
+ * Standard events
+ */
+
+int
+trace_nop_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	return 0;
+}
+
+/* TRACE_FN */
+static int
+trace_fn_latency(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct ftrace_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (!seq_print_ip_sym(s, field->ip, flags))
+		goto partial;
+	if (!trace_seq_puts(s, " ("))
+		goto partial;
+	if (!seq_print_ip_sym(s, field->parent_ip, flags))
+		goto partial;
+	if (!trace_seq_puts(s, ")\n"))
+		goto partial;
+
+	return 0;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static int
+trace_fn_trace(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct ftrace_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (!seq_print_ip_sym(s, field->ip, flags))
+		goto partial;
+
+	if ((flags & TRACE_ITER_PRINT_PARENT) && field->parent_ip) {
+		if (!trace_seq_printf(s, " <-"))
+			goto partial;
+		if (!seq_print_ip_sym(s,
+				      field->parent_ip,
+				      flags))
+			goto partial;
+	}
+	if (!trace_seq_printf(s, "\n"))
+		goto partial;
+
+	return 0;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static int
+trace_fn_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct ftrace_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (trace_seq_printf(s, "%x %x\n",
+			     field->ip,
+			     field->parent_ip))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return 0;
+}
+
+static int
+trace_fn_hex(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct ftrace_entry *field;
+
+	trace_assign_type(field, entry);
+
+	SEQ_PUT_HEX_FIELD_RET(s, field->ip);
+	SEQ_PUT_HEX_FIELD_RET(s, field->parent_ip);
+
+	return 0;
+}
+
+static int
+trace_fn_bin(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct ftrace_entry *field;
+
+	trace_assign_type(field, entry);
+
+	SEQ_PUT_FIELD_RET(s, field->ip);
+	SEQ_PUT_FIELD_RET(s, field->parent_ip);
+
+	return 0;
+}
+
+static struct trace_event trace_fn_event = {
+	.type	 	= TRACE_FN,
+	.trace		= trace_fn_trace,
+	.latency_trace	= trace_fn_latency,
+	.raw		= trace_fn_raw,
+	.hex		= trace_fn_hex,
+	.binary		= trace_fn_bin,
+};
+
+/* TRACE_CTX an TRACE_WAKE */
+static int
+trace_ctxwake_print(struct trace_seq *s, struct trace_entry *entry, int flags,
+		    char *delim)
+{
+	struct ctx_switch_entry *field;
+	char *comm;
+	int S, T;
+
+	trace_assign_type(field, entry);
+
+	T = task_state_char(field->next_state);
+	S = task_state_char(field->prev_state);
+	comm = trace_find_cmdline(field->next_pid);
+	if (trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
+			     field->prev_pid,
+			     field->prev_prio,
+			     S, delim,
+			     field->next_cpu,
+			     field->next_pid,
+			     field->next_prio,
+			     T, comm))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return 0;
+}
+
+static int
+trace_ctx_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	return trace_ctxwake_print(s, entry, flags, "==>");
+}
+
+static int
+trace_wake_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	return trace_ctxwake_print(s, entry, flags, "  +");
+}
+
+static int
+trace_ctxwake_raw(struct trace_seq *s, struct trace_entry *entry, int flags,
+		  char S)
+{
+	struct ctx_switch_entry *field;
+	int T;
+
+	trace_assign_type(field, entry);
+
+	if (!S)
+		task_state_char(field->prev_state);
+	T = task_state_char(field->next_state);
+	if (trace_seq_printf(s, "%d %d %c %d %d %d %c\n",
+			     field->prev_pid,
+			     field->prev_prio,
+			     S,
+			     field->next_cpu,
+			     field->next_pid,
+			     field->next_prio,
+			     T))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return 0;
+}
+
+static int
+trace_ctx_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	return trace_ctxwake_raw(s, entry, flags, 0);
+}
+
+static int
+trace_wake_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	return trace_ctxwake_raw(s, entry, flags, '+');
+}
+
+
+static int
+trace_ctxwake_hex(struct trace_seq *s, struct trace_entry *entry, int flags,
+		  char S)
+{
+	struct ctx_switch_entry *field;
+	int T;
+
+	trace_assign_type(field, entry);
+
+	if (!S)
+		task_state_char(field->prev_state);
+	T = task_state_char(field->next_state);
+
+	SEQ_PUT_HEX_FIELD_RET(s, field->prev_pid);
+	SEQ_PUT_HEX_FIELD_RET(s, field->prev_prio);
+	SEQ_PUT_HEX_FIELD_RET(s, S);
+	SEQ_PUT_HEX_FIELD_RET(s, field->next_cpu);
+	SEQ_PUT_HEX_FIELD_RET(s, field->next_pid);
+	SEQ_PUT_HEX_FIELD_RET(s, field->next_prio);
+	SEQ_PUT_HEX_FIELD_RET(s, T);
+
+	return 0;
+}
+
+static int
+trace_ctx_hex(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	return trace_ctxwake_hex(s, entry, flags, 0);
+}
+
+static int
+trace_wake_hex(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	return trace_ctxwake_hex(s, entry, flags, '+');
+}
+
+static int
+trace_ctxwake_bin(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct ctx_switch_entry *field;
+
+	trace_assign_type(field, entry);
+
+	SEQ_PUT_FIELD_RET(s, field->prev_pid);
+	SEQ_PUT_FIELD_RET(s, field->prev_prio);
+	SEQ_PUT_FIELD_RET(s, field->prev_state);
+	SEQ_PUT_FIELD_RET(s, field->next_pid);
+	SEQ_PUT_FIELD_RET(s, field->next_prio);
+	SEQ_PUT_FIELD_RET(s, field->next_state);
+
+	return 0;
+}
+
+static struct trace_event trace_ctx_event = {
+	.type	 	= TRACE_CTX,
+	.trace		= trace_ctx_print,
+	.latency_trace	= trace_ctx_print,
+	.raw		= trace_ctx_raw,
+	.hex		= trace_ctx_hex,
+	.binary		= trace_ctxwake_bin,
+};
+
+static struct trace_event trace_wake_event = {
+	.type	 	= TRACE_WAKE,
+	.trace		= trace_wake_print,
+	.latency_trace	= trace_wake_print,
+	.raw		= trace_wake_raw,
+	.hex		= trace_wake_hex,
+	.binary		= trace_ctxwake_bin,
+};
+
+/* TRACE_SPECIAL */
+static int
+trace_special_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct special_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (trace_seq_printf(s, "# %ld %ld %ld\n",
+			     field->arg1,
+			     field->arg2,
+			     field->arg3))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return 0;
+}
+
+static int
+trace_special_hex(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct special_entry *field;
+
+	trace_assign_type(field, entry);
+
+	SEQ_PUT_HEX_FIELD_RET(s, field->arg1);
+	SEQ_PUT_HEX_FIELD_RET(s, field->arg2);
+	SEQ_PUT_HEX_FIELD_RET(s, field->arg3);
+
+	return 0;
+}
+
+static int
+trace_special_bin(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct special_entry *field;
+
+	trace_assign_type(field, entry);
+
+	SEQ_PUT_FIELD_RET(s, field->arg1);
+	SEQ_PUT_FIELD_RET(s, field->arg2);
+	SEQ_PUT_FIELD_RET(s, field->arg3);
+
+	return 0;
+}
+
+static struct trace_event trace_special_event = {
+	.type	 	= TRACE_SPECIAL,
+	.trace		= trace_special_print,
+	.latency_trace	= trace_special_print,
+	.raw		= trace_special_print,
+	.hex		= trace_special_hex,
+	.binary		= trace_special_bin,
+};
+
+/* TRACE_STACK */
+
+static int
+trace_stack_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct stack_entry *field;
+	int i;
+
+	trace_assign_type(field, entry);
+
+	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
+		if (i) {
+			if (trace_seq_puts(s, " <= "))
+				goto partial;
+
+			if (seq_print_ip_sym(s, field->caller[i], flags))
+				goto partial;
+		}
+		if (trace_seq_puts(s, "\n"))
+			goto partial;
+	}
+
+	return 0;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static struct trace_event trace_stack_event = {
+	.type	 	= TRACE_STACK,
+	.trace		= trace_stack_print,
+	.latency_trace	= trace_stack_print,
+	.raw		= trace_special_print,
+	.hex		= trace_special_hex,
+	.binary		= trace_special_bin,
+};
+
+/* TRACE_USER_STACK */
+static int
+trace_user_stack_print(struct trace_seq *s, struct trace_entry *entry,
+		       int flags)
+{
+	struct userstack_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (seq_print_userip_objs(field, s, flags))
+		goto partial;
+
+	if (trace_seq_putc(s, '\n'))
+		goto partial;
+
+	return 0;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static struct trace_event trace_user_stack_event = {
+	.type	 	= TRACE_USER_STACK,
+	.trace		= trace_user_stack_print,
+	.latency_trace	= trace_user_stack_print,
+	.raw		= trace_special_print,
+	.hex		= trace_special_hex,
+	.binary		= trace_special_bin,
+};
+
+/* TRACE_PRINT */
+static int
+trace_print_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct print_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (seq_print_ip_sym(s, field->ip, flags))
+		goto partial;
+
+	if (trace_seq_printf(s, ": %s", field->buf))
+		goto partial;
+
+	return 0;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static int
+trace_print_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct print_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (seq_print_ip_sym(s, field->ip, flags))
+		goto partial;
+
+	if (trace_seq_printf(s, "# %lx %s", field->ip, field->buf))
+		goto partial;
+
+	return 0;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static struct trace_event trace_print_event = {
+	.type	 	= TRACE_PRINT,
+	.trace		= trace_print_print,
+	.latency_trace	= trace_print_print,
+	.raw		= trace_print_raw,
+	.hex		= trace_nop_print,
+	.binary		= trace_nop_print,
+};
+
+static struct trace_event *events[] __initdata = {
+	&trace_fn_event,
+	&trace_ctx_event,
+	&trace_wake_event,
+	&trace_special_event,
+	&trace_stack_event,
+	&trace_user_stack_event,
+	&trace_print_event,
+	NULL
+};
+
+__init static int init_events(void)
+{
+	struct trace_event *event;
+	int i, ret;
+
+	for (i = 0; events[i]; i++) {
+		event = events[i];
+
+		ret = register_ftrace_event(event);
+		if (!ret) {
+			printk(KERN_WARNING "event %d failed to register\n",
+			       event->type);
+			WARN_ON_ONCE(1);
+		}
+	}
+
+	return 0;
+}
+device_initcall(init_events);
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
new file mode 100644
index 0000000..ecab4ea
--- /dev/null
+++ b/kernel/trace/trace_output.h
@@ -0,0 +1,59 @@
+#ifndef __TRACE_EVENTS_H
+#define __TRACE_EVENTS_H
+
+#include "trace.h"
+
+typedef int (*trace_print_func)(struct trace_seq *s, struct trace_entry *entry,
+				int flags);
+
+struct trace_event {
+	struct hlist_node	node;
+	int			type;
+	trace_print_func	trace;
+	trace_print_func	latency_trace;
+	trace_print_func	raw;
+	trace_print_func	hex;
+	trace_print_func	binary;
+};
+
+extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
+extern int
+seq_print_ip_sym(struct trace_seq *s, unsigned long ip,
+		unsigned long sym_flags);
+extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
+				 size_t cnt);
+int trace_seq_puts(struct trace_seq *s, const char *str);
+int trace_seq_putc(struct trace_seq *s, unsigned char c);
+int trace_seq_putmem(struct trace_seq *s, void *mem, size_t len);
+int trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len);
+int trace_seq_path(struct trace_seq *s, struct path *path);
+int seq_print_userip_objs(const struct userstack_entry *entry,
+			  struct trace_seq *s, unsigned long sym_flags);
+int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
+		      unsigned long ip, unsigned long sym_flags);
+
+struct trace_event *ftrace_find_event(int type);
+int register_ftrace_event(struct trace_event *event);
+int unregister_ftrace_event(struct trace_event *event);
+
+int
+trace_nop_print(struct trace_seq *s, struct trace_entry *entry, int flags);
+
+#define MAX_MEMHEX_BYTES	8
+#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
+
+#define SEQ_PUT_FIELD_RET(s, x)				\
+do {							\
+	if (!trace_seq_putmem(s, &(x), sizeof(x)))	\
+		return 0;				\
+} while (0)
+
+#define SEQ_PUT_HEX_FIELD_RET(s, x)			\
+do {							\
+	BUILD_BUG_ON(sizeof(x) > MAX_MEMHEX_BYTES);	\
+	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
+		return 0;				\
+} while (0)
+
+#endif
+
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index 7bda248..faa6ab7 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 
 #include "trace.h"
+#include "trace_output.h"
 
 static struct trace_array *power_trace;
 static int __read_mostly trace_power_enabled;
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 88c8eb7..5013812 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -9,7 +9,6 @@ static inline int trace_valid_entry(struct trace_entry *entry)
 	case TRACE_FN:
 	case TRACE_CTX:
 	case TRACE_WAKE:
-	case TRACE_CONT:
 	case TRACE_STACK:
 	case TRACE_PRINT:
 	case TRACE_SPECIAL:
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
new file mode 100644
index 0000000..6f194a3
--- /dev/null
+++ b/kernel/trace/trace_stat.c
@@ -0,0 +1,251 @@
+/*
+ * Infrastructure for statistic tracing (histogram output).
+ *
+ * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
+ *
+ * Based on the code from trace_branch.c which is
+ * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+
+
+#include <linux/list.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include "trace.h"
+
+
+/* List of stat entries from a tracer */
+struct trace_stat_list {
+	struct list_head list;
+	void *stat;
+};
+
+static struct trace_stat_list stat_list;
+
+/*
+ * This is a copy of the current tracer to avoid racy
+ * and dangerous output while the current tracer is
+ * switched.
+ */
+static struct tracer current_tracer;
+
+/*
+ * Protect both the current tracer and the global
+ * stat list.
+ */
+static DEFINE_MUTEX(stat_list_mutex);
+
+
+static void reset_stat_list(void)
+{
+	struct trace_stat_list *node;
+	struct list_head *next;
+
+	if (list_empty(&stat_list.list))
+		return;
+
+	node = list_entry(stat_list.list.next, struct trace_stat_list, list);
+	next = node->list.next;
+
+	while (&node->list != next) {
+		kfree(node);
+		node = list_entry(next, struct trace_stat_list, list);
+	}
+	kfree(node);
+
+	INIT_LIST_HEAD(&stat_list.list);
+}
+
+void init_tracer_stat(struct tracer *trace)
+{
+	mutex_lock(&stat_list_mutex);
+	current_tracer = *trace;
+	mutex_unlock(&stat_list_mutex);
+}
+
+/*
+ * For tracers that don't provide a stat_cmp callback.
+ * This one will force an immediate insertion on tail of
+ * the list.
+ */
+static int dummy_cmp(void *p1, void *p2)
+{
+	return 1;
+}
+
+/*
+ * Initialize the stat list at each trace_stat file opening.
+ * All of these copies and sorting are required on all opening
+ * since the stats could have changed between two file sessions.
+ */
+static int stat_seq_init(void)
+{
+	struct trace_stat_list *iter_entry, *new_entry;
+	void *prev_stat;
+	int ret = 0;
+	int i;
+
+	mutex_lock(&stat_list_mutex);
+	reset_stat_list();
+
+	if (!current_tracer.stat_start || !current_tracer.stat_next ||
+					!current_tracer.stat_show)
+		goto exit;
+
+	if (!current_tracer.stat_cmp)
+		current_tracer.stat_cmp = dummy_cmp;
+
+	/*
+	 * The first entry. Actually this is the second, but the first
+	 * one (the stat_list head) is pointless.
+	 */
+	new_entry = kmalloc(sizeof(struct trace_stat_list), GFP_KERNEL);
+	if (!new_entry) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	INIT_LIST_HEAD(&new_entry->list);
+	list_add(&new_entry->list, &stat_list.list);
+	new_entry->stat = current_tracer.stat_start();
+
+	prev_stat = new_entry->stat;
+
+	/*
+	 * Iterate over the tracer stat entries and store them in a sorted
+	 * list.
+	 */
+	for (i = 1; ; i++) {
+		new_entry = kmalloc(sizeof(struct trace_stat_list), GFP_KERNEL);
+		if (!new_entry) {
+			ret = -ENOMEM;
+			goto exit_free_list;
+		}
+
+		INIT_LIST_HEAD(&new_entry->list);
+		new_entry->stat = current_tracer.stat_next(prev_stat, i);
+
+		/* End of insertion */
+		if (!new_entry->stat)
+			break;
+
+		list_for_each_entry(iter_entry, &stat_list.list, list) {
+			/* Insertion with a descendent sorting */
+			if (current_tracer.stat_cmp(new_entry->stat,
+						iter_entry->stat) > 0) {
+
+				list_add_tail(&new_entry->list,
+						&iter_entry->list);
+				break;
+
+			/* The current smaller value */
+			} else if (list_is_last(&iter_entry->list,
+						&stat_list.list)) {
+				list_add(&new_entry->list, &iter_entry->list);
+				break;
+			}
+		}
+
+		prev_stat = new_entry->stat;
+	}
+exit:
+	mutex_unlock(&stat_list_mutex);
+	return ret;
+
+exit_free_list:
+	reset_stat_list();
+	mutex_unlock(&stat_list_mutex);
+	return ret;
+}
+
+
+static void *stat_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct trace_stat_list *l = (struct trace_stat_list *)s->private;
+
+	/* Prevent from tracer switch or stat_list modification */
+	mutex_lock(&stat_list_mutex);
+
+	/* If we are in the beginning of the file, print the headers */
+	if (!*pos && current_tracer.stat_headers)
+		current_tracer.stat_headers(s);
+
+	return seq_list_start(&l->list, *pos);
+}
+
+static void *stat_seq_next(struct seq_file *s, void *p, loff_t *pos)
+{
+	struct trace_stat_list *l = (struct trace_stat_list *)s->private;
+
+	return seq_list_next(p, &l->list, pos);
+}
+
+static void stat_seq_stop(struct seq_file *m, void *p)
+{
+	mutex_unlock(&stat_list_mutex);
+}
+
+static int stat_seq_show(struct seq_file *s, void *v)
+{
+	struct trace_stat_list *l = list_entry(v, struct trace_stat_list, list);
+	return current_tracer.stat_show(s, l->stat);
+}
+
+static const struct seq_operations trace_stat_seq_ops = {
+	.start = stat_seq_start,
+	.next = stat_seq_next,
+	.stop = stat_seq_stop,
+	.show = stat_seq_show
+};
+
+static int tracing_stat_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	ret = seq_open(file, &trace_stat_seq_ops);
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+		m->private = &stat_list;
+		ret = stat_seq_init();
+	}
+
+	return ret;
+}
+
+
+/*
+ * Avoid consuming memory with our now useless list.
+ */
+static int tracing_stat_release(struct inode *i, struct file *f)
+{
+	mutex_lock(&stat_list_mutex);
+	reset_stat_list();
+	mutex_unlock(&stat_list_mutex);
+	return 0;
+}
+
+static const struct file_operations tracing_stat_fops = {
+	.open		= tracing_stat_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= tracing_stat_release
+};
+
+static int __init tracing_stat_init(void)
+{
+	struct dentry *d_tracing;
+	struct dentry *entry;
+
+	INIT_LIST_HEAD(&stat_list.list);
+	d_tracing = tracing_init_dentry();
+
+	entry = debugfs_create_file("trace_stat", 0444, d_tracing,
+					NULL,
+				    &tracing_stat_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'trace_stat' entry\n");
+	return 0;
+}
+fs_initcall(tracing_stat_init);
diff --git a/mm/slab.c b/mm/slab.c
index ddc41f3..dae716b 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -102,6 +102,7 @@
 #include	<linux/cpu.h>
 #include	<linux/sysctl.h>
 #include	<linux/module.h>
+#include	<trace/kmemtrace.h>
 #include	<linux/rcupdate.h>
 #include	<linux/string.h>
 #include	<linux/uaccess.h>
@@ -568,6 +569,14 @@ static void **dbg_userword(struct kmem_cache *cachep, void *objp)
 
 #endif
 
+#ifdef CONFIG_KMEMTRACE
+size_t slab_buffer_size(struct kmem_cache *cachep)
+{
+	return cachep->buffer_size;
+}
+EXPORT_SYMBOL(slab_buffer_size);
+#endif
+
 /*
  * Do not go above this order unless 0 objects fit into the slab.
  */
@@ -3550,10 +3559,23 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp)
  */
 void *kmem_cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 {
-	return __cache_alloc(cachep, flags, __builtin_return_address(0));
+	void *ret = __cache_alloc(cachep, flags, __builtin_return_address(0));
+
+	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
+			     obj_size(cachep), cachep->buffer_size, flags);
+
+	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
+#ifdef CONFIG_KMEMTRACE
+void *kmem_cache_alloc_notrace(struct kmem_cache *cachep, gfp_t flags)
+{
+	return __cache_alloc(cachep, flags, __builtin_return_address(0));
+}
+EXPORT_SYMBOL(kmem_cache_alloc_notrace);
+#endif
+
 /**
  * kmem_ptr_validate - check if an untrusted pointer might be a slab entry.
  * @cachep: the cache we're checking against
@@ -3598,23 +3620,47 @@ out:
 #ifdef CONFIG_NUMA
 void *kmem_cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 {
-	return __cache_alloc_node(cachep, flags, nodeid,
-			__builtin_return_address(0));
+	void *ret = __cache_alloc_node(cachep, flags, nodeid,
+				       __builtin_return_address(0));
+
+	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
+				  obj_size(cachep), cachep->buffer_size,
+				  flags, nodeid);
+
+	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 
+#ifdef CONFIG_KMEMTRACE
+void *kmem_cache_alloc_node_notrace(struct kmem_cache *cachep,
+				    gfp_t flags,
+				    int nodeid)
+{
+	return __cache_alloc_node(cachep, flags, nodeid,
+				  __builtin_return_address(0));
+}
+EXPORT_SYMBOL(kmem_cache_alloc_node_notrace);
+#endif
+
 static __always_inline void *
 __do_kmalloc_node(size_t size, gfp_t flags, int node, void *caller)
 {
 	struct kmem_cache *cachep;
+	void *ret;
 
 	cachep = kmem_find_general_cachep(size, flags);
 	if (unlikely(ZERO_OR_NULL_PTR(cachep)))
 		return cachep;
-	return kmem_cache_alloc_node(cachep, flags, node);
+	ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
+
+	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
+				  (unsigned long) caller, ret,
+				  size, cachep->buffer_size, flags, node);
+
+	return ret;
 }
 
-#ifdef CONFIG_DEBUG_SLAB
+#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_KMEMTRACE)
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	return __do_kmalloc_node(size, flags, node,
@@ -3647,6 +3693,7 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
 					  void *caller)
 {
 	struct kmem_cache *cachep;
+	void *ret;
 
 	/* If you want to save a few bytes .text space: replace
 	 * __ with kmem_.
@@ -3656,11 +3703,17 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
 	cachep = __find_general_cachep(size, flags);
 	if (unlikely(ZERO_OR_NULL_PTR(cachep)))
 		return cachep;
-	return __cache_alloc(cachep, flags, caller);
+	ret = __cache_alloc(cachep, flags, caller);
+
+	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC,
+			     (unsigned long) caller, ret,
+			     size, cachep->buffer_size, flags);
+
+	return ret;
 }
 
 
-#ifdef CONFIG_DEBUG_SLAB
+#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_KMEMTRACE)
 void *__kmalloc(size_t size, gfp_t flags)
 {
 	return __do_kmalloc(size, flags, __builtin_return_address(0));
@@ -3699,6 +3752,8 @@ void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 		debug_check_no_obj_freed(objp, obj_size(cachep));
 	__cache_free(cachep, objp);
 	local_irq_restore(flags);
+
+	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, objp);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -3725,6 +3780,8 @@ void kfree(const void *objp)
 	debug_check_no_obj_freed(objp, obj_size(c));
 	__cache_free(c, (void *)objp);
 	local_irq_restore(flags);
+
+	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, objp);
 }
 EXPORT_SYMBOL(kfree);
 
diff --git a/mm/slob.c b/mm/slob.c
index bf7e8fc..4d1c0fc 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -65,6 +65,7 @@
 #include <linux/module.h>
 #include <linux/rcupdate.h>
 #include <linux/list.h>
+#include <trace/kmemtrace.h>
 #include <asm/atomic.h>
 
 /*
@@ -463,27 +464,38 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 {
 	unsigned int *m;
 	int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+	void *ret;
 
 	if (size < PAGE_SIZE - align) {
 		if (!size)
 			return ZERO_SIZE_PTR;
 
 		m = slob_alloc(size + align, gfp, align, node);
+
 		if (!m)
 			return NULL;
 		*m = size;
-		return (void *)m + align;
+		ret = (void *)m + align;
+
+		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
+					  _RET_IP_, ret,
+					  size, size + align, gfp, node);
 	} else {
-		void *ret;
+		unsigned int order = get_order(size);
 
-		ret = slob_new_page(gfp | __GFP_COMP, get_order(size), node);
+		ret = slob_new_page(gfp | __GFP_COMP, order, node);
 		if (ret) {
 			struct page *page;
 			page = virt_to_page(ret);
 			page->private = size;
 		}
-		return ret;
+
+		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
+					  _RET_IP_, ret,
+					  size, PAGE_SIZE << order, gfp, node);
 	}
+
+	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_node);
 
@@ -501,6 +513,8 @@ void kfree(const void *block)
 		slob_free(m, *m + align);
 	} else
 		put_page(&sp->page);
+
+	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, block);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -569,10 +583,19 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 {
 	void *b;
 
-	if (c->size < PAGE_SIZE)
+	if (c->size < PAGE_SIZE) {
 		b = slob_alloc(c->size, flags, c->align, node);
-	else
+		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE,
+					  _RET_IP_, b, c->size,
+					  SLOB_UNITS(c->size) * SLOB_UNIT,
+					  flags, node);
+	} else {
 		b = slob_new_page(flags, get_order(c->size), node);
+		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE,
+					  _RET_IP_, b, c->size,
+					  PAGE_SIZE << get_order(c->size),
+					  flags, node);
+	}
 
 	if (c->ctor)
 		c->ctor(b);
@@ -608,6 +631,8 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
 	} else {
 		__kmem_cache_free(b, c->size);
 	}
+
+	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, b);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
diff --git a/mm/slub.c b/mm/slub.c
index f0e2892..509e96f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <trace/kmemtrace.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/mempolicy.h>
@@ -1623,18 +1624,46 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
-	return slab_alloc(s, gfpflags, -1, _RET_IP_);
+	void *ret = slab_alloc(s, gfpflags, -1, _RET_IP_);
+
+	kmemtrace_mark_alloc(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
+			     s->objsize, s->size, gfpflags);
+
+	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
+#ifdef CONFIG_KMEMTRACE
+void *kmem_cache_alloc_notrace(struct kmem_cache *s, gfp_t gfpflags)
+{
+	return slab_alloc(s, gfpflags, -1, _RET_IP_);
+}
+EXPORT_SYMBOL(kmem_cache_alloc_notrace);
+#endif
+
 #ifdef CONFIG_NUMA
 void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
-	return slab_alloc(s, gfpflags, node, _RET_IP_);
+	void *ret = slab_alloc(s, gfpflags, node, _RET_IP_);
+
+	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_CACHE, _RET_IP_, ret,
+				  s->objsize, s->size, gfpflags, node);
+
+	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 #endif
 
+#ifdef CONFIG_KMEMTRACE
+void *kmem_cache_alloc_node_notrace(struct kmem_cache *s,
+				    gfp_t gfpflags,
+				    int node)
+{
+	return slab_alloc(s, gfpflags, node, _RET_IP_);
+}
+EXPORT_SYMBOL(kmem_cache_alloc_node_notrace);
+#endif
+
 /*
  * Slow patch handling. This may still be called frequently since objects
  * have a longer lifetime than the cpu slabs in most processing loads.
@@ -1742,6 +1771,8 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 	page = virt_to_head_page(x);
 
 	slab_free(s, page, x, _RET_IP_);
+
+	kmemtrace_mark_free(KMEMTRACE_TYPE_CACHE, _RET_IP_, x);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -2657,6 +2688,7 @@ static struct kmem_cache *get_slab(size_t size, gfp_t flags)
 void *__kmalloc(size_t size, gfp_t flags)
 {
 	struct kmem_cache *s;
+	void *ret;
 
 	if (unlikely(size > PAGE_SIZE))
 		return kmalloc_large(size, flags);
@@ -2666,7 +2698,12 @@ void *__kmalloc(size_t size, gfp_t flags)
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, flags, -1, _RET_IP_);
+	ret = slab_alloc(s, flags, -1, _RET_IP_);
+
+	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, ret,
+			     size, s->size, flags);
+
+	return ret;
 }
 EXPORT_SYMBOL(__kmalloc);
 
@@ -2685,16 +2722,30 @@ static void *kmalloc_large_node(size_t size, gfp_t flags, int node)
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	struct kmem_cache *s;
+	void *ret;
 
-	if (unlikely(size > PAGE_SIZE))
-		return kmalloc_large_node(size, flags, node);
+	if (unlikely(size > PAGE_SIZE)) {
+		ret = kmalloc_large_node(size, flags, node);
+
+		kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC,
+					  _RET_IP_, ret,
+					  size, PAGE_SIZE << get_order(size),
+					  flags, node);
+
+		return ret;
+	}
 
 	s = get_slab(size, flags);
 
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, flags, node, _RET_IP_);
+	ret = slab_alloc(s, flags, node, _RET_IP_);
+
+	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, ret,
+				  size, s->size, flags, node);
+
+	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
@@ -2752,6 +2803,8 @@ void kfree(const void *x)
 		return;
 	}
 	slab_free(page->slab, page, object, _RET_IP_);
+
+	kmemtrace_mark_free(KMEMTRACE_TYPE_KMALLOC, _RET_IP_, x);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -3221,6 +3274,7 @@ static struct notifier_block __cpuinitdata slab_notifier = {
 void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
 {
 	struct kmem_cache *s;
+	void *ret;
 
 	if (unlikely(size > PAGE_SIZE))
 		return kmalloc_large(size, gfpflags);
@@ -3230,13 +3284,20 @@ void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, gfpflags, -1, caller);
+	ret = slab_alloc(s, gfpflags, -1, caller);
+
+	/* Honor the call site pointer we recieved. */
+	kmemtrace_mark_alloc(KMEMTRACE_TYPE_KMALLOC, caller, ret, size,
+			     s->size, gfpflags);
+
+	return ret;
 }
 
 void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 					int node, unsigned long caller)
 {
 	struct kmem_cache *s;
+	void *ret;
 
 	if (unlikely(size > PAGE_SIZE))
 		return kmalloc_large_node(size, gfpflags, node);
@@ -3246,7 +3307,13 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 	if (unlikely(ZERO_OR_NULL_PTR(s)))
 		return s;
 
-	return slab_alloc(s, gfpflags, node, caller);
+	ret = slab_alloc(s, gfpflags, node, caller);
+
+	/* Honor the call site pointer we recieved. */
+	kmemtrace_mark_alloc_node(KMEMTRACE_TYPE_KMALLOC, caller, ret,
+				  size, s->size, gfpflags, node);
+
+	return ret;
 }
 
 #ifdef CONFIG_SLUB_DEBUG
