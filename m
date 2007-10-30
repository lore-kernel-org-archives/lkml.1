Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbXJ3Xum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbXJ3Xum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbXJ3Xu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:50:27 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35808 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752383AbXJ3XuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:50:22 -0400
Date: Wed, 31 Oct 2007 00:50:19 +0100
From: Adrian Bunk <bunk@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove __attribute_used__
Message-ID: <20071030235019.GS7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the deprecated __attribute_used__.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/alpha/lib/dec_and_lock.c           |    3 +--
 arch/powerpc/boot/Makefile              |    2 +-
 arch/powerpc/kernel/sysfs.c             |    2 +-
 arch/powerpc/oprofile/op_model_power4.c |    6 +++---
 arch/sparc64/kernel/unaligned.c         |    2 +-
 arch/um/include/init.h                  |   18 +++++++++---------
 drivers/rapidio/rio.h                   |    2 +-
 fs/compat_ioctl.c                       |    2 +-
 include/asm-avr32/setup.h               |    2 +-
 include/asm-ia64/gcc_intrin.h           |    2 +-
 include/asm-sh/machvec.h                |    2 +-
 include/asm-sh/thread_info.h            |    2 +-
 include/asm-x86/thread_info_32.h        |    2 +-
 include/linux/compiler-gcc3.h           |    2 --
 include/linux/compiler-gcc4.h           |    1 -
 include/linux/compiler.h                |    4 ----
 include/linux/elfnote.h                 |    2 +-
 include/linux/init.h                    |   12 ++++++------
 include/linux/module.h                  |    4 ++--
 include/linux/moduleparam.h             |    4 ++--
 include/linux/pci.h                     |    2 +-
 scripts/mod/modpost.c                   |    4 ++--
 22 files changed, 37 insertions(+), 45 deletions(-)

56299ac728f8c241e292c09947ff582b1af58013 
diff --git a/arch/alpha/lib/dec_and_lock.c b/arch/alpha/lib/dec_and_lock.c
index 6ae2500..0f5520d 100644
--- a/arch/alpha/lib/dec_and_lock.c
+++ b/arch/alpha/lib/dec_and_lock.c
@@ -30,8 +30,7 @@ _atomic_dec_and_lock:				\n\
 	.previous				\n\
 	.end _atomic_dec_and_lock");
 
-static int __attribute_used__
-atomic_dec_and_lock_1(atomic_t *atomic, spinlock_t *lock)
+static int __used atomic_dec_and_lock_1(atomic_t *atomic, spinlock_t *lock)
 {
 	/* Slow path */
 	spin_lock(lock);
diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 18e3271..4b1d98b 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -65,7 +65,7 @@ obj-wlib := $(addsuffix .o, $(basename $(addprefix $(obj)/, $(src-wlib))))
 obj-plat := $(addsuffix .o, $(basename $(addprefix $(obj)/, $(src-plat))))
 
 quiet_cmd_copy_zlib = COPY    $@
-      cmd_copy_zlib = sed "s@__attribute_used__@@;s@<linux/\([^>]*\).*@\"\1\"@" $< > $@
+      cmd_copy_zlib = sed "s@__used@@;s@<linux/\([^>]*\).*@\"\1\"@" $< > $@
 
 quiet_cmd_copy_zlibheader = COPY    $@
       cmd_copy_zlibheader = sed "s@<linux/\([^>]*\).*@\"\1\"@" $< > $@
diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index 25d9a96..c8127f8 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -158,7 +158,7 @@ static ssize_t show_##NAME(struct sys_device *dev, char *buf) \
 	unsigned long val = run_on_cpu(cpu->sysdev.id, read_##NAME, 0); \
 	return sprintf(buf, "%lx\n", val); \
 } \
-static ssize_t __attribute_used__ \
+static ssize_t __used \
 	store_##NAME(struct sys_device *dev, const char *buf, size_t count) \
 { \
 	struct cpu *cpu = container_of(dev, struct cpu, sysdev); \
diff --git a/arch/powerpc/oprofile/op_model_power4.c b/arch/powerpc/oprofile/op_model_power4.c
index cddc250..446a8bb 100644
--- a/arch/powerpc/oprofile/op_model_power4.c
+++ b/arch/powerpc/oprofile/op_model_power4.c
@@ -172,15 +172,15 @@ static void power4_stop(void)
 }
 
 /* Fake functions used by canonicalize_pc */
-static void __attribute_used__ hypervisor_bucket(void)
+static void __used hypervisor_bucket(void)
 {
 }
 
-static void __attribute_used__ rtas_bucket(void)
+static void __used rtas_bucket(void)
 {
 }
 
-static void __attribute_used__ kernel_unknown_bucket(void)
+static void __used kernel_unknown_bucket(void)
 {
 }
 
diff --git a/arch/sparc64/kernel/unaligned.c b/arch/sparc64/kernel/unaligned.c
index 953be81..dc7bf1b 100644
--- a/arch/sparc64/kernel/unaligned.c
+++ b/arch/sparc64/kernel/unaligned.c
@@ -175,7 +175,7 @@ unsigned long compute_effective_address(struct pt_regs *regs,
 }
 
 /* This is just to make gcc think die_if_kernel does return... */
-static void __attribute_used__ unaligned_panic(char *str, struct pt_regs *regs)
+static void __used unaligned_panic(char *str, struct pt_regs *regs)
 {
 	die_if_kernel(str, regs);
 }
diff --git a/arch/um/include/init.h b/arch/um/include/init.h
index d4de7c0..513f010 100644
--- a/arch/um/include/init.h
+++ b/arch/um/include/init.h
@@ -45,12 +45,12 @@ typedef void (*exitcall_t)(void);
 #define __init		__attribute__ ((__section__ (".init.text")))
 #define __initdata	__attribute__ ((__section__ (".init.data")))
 #define __exitdata	__attribute__ ((__section__(".exit.data")))
-#define __exit_call	__attribute_used__ __attribute__ ((__section__ (".exitcall.exit")))
+#define __exit_call	__used __attribute__ ((__section__ (".exitcall.exit")))
 
 #ifdef MODULE
 #define __exit		__attribute__ ((__section__(".exit.text")))
 #else
-#define __exit		__attribute_used__ __attribute__ ((__section__(".exit.text")))
+#define __exit		__used __attribute__ ((__section__(".exit.text")))
 #endif
 
 #endif
@@ -103,16 +103,16 @@ extern struct uml_param __uml_setup_start, __uml_setup_end;
  * Mark functions and data as being only used at initialization
  * or exit time.
  */
-#define __uml_init_setup	__attribute_used__ __attribute__ ((__section__ (".uml.setup.init")))
-#define __uml_setup_help	__attribute_used__ __attribute__ ((__section__ (".uml.help.init")))
-#define __uml_init_call		__attribute_used__ __attribute__ ((__section__ (".uml.initcall.init")))
-#define __uml_postsetup_call	__attribute_used__ __attribute__ ((__section__ (".uml.postsetup.init")))
-#define __uml_exit_call		__attribute_used__ __attribute__ ((__section__ (".uml.exitcall.exit")))
+#define __uml_init_setup	__used __attribute__ ((__section__ (".uml.setup.init")))
+#define __uml_setup_help	__used __attribute__ ((__section__ (".uml.help.init")))
+#define __uml_init_call		__used __attribute__ ((__section__ (".uml.initcall.init")))
+#define __uml_postsetup_call	__used __attribute__ ((__section__ (".uml.postsetup.init")))
+#define __uml_exit_call		__used __attribute__ ((__section__ (".uml.exitcall.exit")))
 
 #ifndef __KERNEL__
 
 #define __define_initcall(level,fn) \
-	static initcall_t __initcall_##fn __attribute_used__ \
+	static initcall_t __initcall_##fn __used \
 	__attribute__((__section__(".initcall" level ".init"))) = fn
 
 /* Userspace initcalls shouldn't depend on anything in the kernel, so we'll
@@ -122,7 +122,7 @@ extern struct uml_param __uml_setup_start, __uml_setup_end;
 
 #define __exitcall(fn) static exitcall_t __exitcall_##fn __exit_call = fn
 
-#define __init_call	__attribute_used__ __attribute__ ((__section__ (".initcall.init")))
+#define __init_call	__used __attribute__ ((__section__ (".initcall.init")))
 
 #endif
 
diff --git a/drivers/rapidio/rio.h b/drivers/rapidio/rio.h
index b242cee..6fe8ad7 100644
--- a/drivers/rapidio/rio.h
+++ b/drivers/rapidio/rio.h
@@ -31,7 +31,7 @@ extern struct rio_route_ops __end_rio_route_ops[];
 
 /* Helpers internal to the RIO core code */
 #define DECLARE_RIO_ROUTE_SECTION(section, vid, did, add_hook, get_hook)  \
-        static struct rio_route_ops __rio_route_ops __attribute_used__   \
+        static struct rio_route_ops __rio_route_ops __used   \
 	        __attribute__((__section__(#section))) = { vid, did, add_hook, get_hook };
 
 /**
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index a4284cc..3230aee 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1374,7 +1374,7 @@ static int do_atm_ioctl(unsigned int fd, unsigned int cmd32, unsigned long arg)
         return -EINVAL;
 }
 
-static __attribute_used__ int 
+static __used int
 ret_einval(unsigned int fd, unsigned int cmd, unsigned long arg)
 {
 	return -EINVAL;
diff --git a/include/asm-avr32/setup.h b/include/asm-avr32/setup.h
index b0828d4..ea3070f 100644
--- a/include/asm-avr32/setup.h
+++ b/include/asm-avr32/setup.h
@@ -110,7 +110,7 @@ struct tagtable {
 	int	(*parse)(struct tag *);
 };
 
-#define __tag __attribute_used__ __attribute__((__section__(".taglist.init")))
+#define __tag __used __attribute__((__section__(".taglist.init")))
 #define __tagtable(tag, fn)						\
 	static struct tagtable __tagtable_##fn __tag = { tag, fn }
 
diff --git a/include/asm-ia64/gcc_intrin.h b/include/asm-ia64/gcc_intrin.h
index 4fb4e43..d84d3f6 100644
--- a/include/asm-ia64/gcc_intrin.h
+++ b/include/asm-ia64/gcc_intrin.h
@@ -24,7 +24,7 @@
 extern void ia64_bad_param_for_setreg (void);
 extern void ia64_bad_param_for_getreg (void);
 
-register unsigned long ia64_r13 asm ("r13") __attribute_used__;
+register unsigned long ia64_r13 asm ("r13") __used;
 
 #define ia64_setreg(regnum, val)						\
 ({										\
diff --git a/include/asm-sh/machvec.h b/include/asm-sh/machvec.h
index 088698b..1d65cef 100644
--- a/include/asm-sh/machvec.h
+++ b/include/asm-sh/machvec.h
@@ -68,6 +68,6 @@ extern struct sh_machine_vector sh_mv;
 #define get_system_type()	sh_mv.mv_name
 
 #define __initmv \
-	__attribute_used__ __attribute__((__section__ (".machvec.init")))
+	__used __attribute__((__section__ (".machvec.init")))
 
 #endif /* _ASM_SH_MACHVEC_H */
diff --git a/include/asm-sh/thread_info.h b/include/asm-sh/thread_info.h
index 1f7e1de..89dbed0 100644
--- a/include/asm-sh/thread_info.h
+++ b/include/asm-sh/thread_info.h
@@ -68,7 +68,7 @@ struct thread_info {
 #define init_stack		(init_thread_union.stack)
 
 /* how to get the current stack pointer from C */
-register unsigned long current_stack_pointer asm("r15") __attribute_used__;
+register unsigned long current_stack_pointer asm("r15") __used;
 
 /* how to get the thread information struct from C */
 static inline struct thread_info *current_thread_info(void)
diff --git a/include/asm-x86/thread_info_32.h b/include/asm-x86/thread_info_32.h
index 22a8cbc..705abf2 100644
--- a/include/asm-x86/thread_info_32.h
+++ b/include/asm-x86/thread_info_32.h
@@ -85,7 +85,7 @@ struct thread_info {
 
 
 /* how to get the current stack pointer from C */
-register unsigned long current_stack_pointer asm("esp") __attribute_used__;
+register unsigned long current_stack_pointer asm("esp") __used;
 
 /* how to get the thread information struct from C */
 static inline struct thread_info *current_thread_info(void)
diff --git a/include/linux/compiler-gcc3.h b/include/linux/compiler-gcc3.h
index 2d8c0f4..e5eb795 100644
--- a/include/linux/compiler-gcc3.h
+++ b/include/linux/compiler-gcc3.h
@@ -7,10 +7,8 @@
 
 #if __GNUC_MINOR__ >= 3
 # define __used			__attribute__((__used__))
-# define __attribute_used__	__used				/* deprecated */
 #else
 # define __used			__attribute__((__unused__))
-# define __attribute_used__	__used				/* deprecated */
 #endif
 
 #if __GNUC_MINOR__ >= 4
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index ee7ca5d..0ab3a32 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -15,7 +15,6 @@
 #endif
 
 #define __used			__attribute__((__used__))
-#define __attribute_used__	__used			/* deprecated */
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
 #define __always_inline		inline __attribute__((always_inline))
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index c68b67b..a9707c3 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -126,10 +126,6 @@ extern void __chk_io_ptr(const volatile void __iomem *);
  * Mark functions that are referenced only in inline assembly as __used so
  * the code is emitted even though it appears to be unreferenced.
  */
-#ifndef __attribute_used__
-# define __attribute_used__	/* deprecated */
-#endif
-
 #ifndef __used
 # define __used			/* unimplemented */
 #endif
diff --git a/include/linux/elfnote.h b/include/linux/elfnote.h
index e831759..278e3ef 100644
--- a/include/linux/elfnote.h
+++ b/include/linux/elfnote.h
@@ -76,7 +76,7 @@
 		typeof(desc) _desc					\
 			     __attribute__((aligned(sizeof(Elf##size##_Word)))); \
 	} _ELFNOTE_PASTE(_note_, unique)				\
-		__attribute_used__					\
+		__used							\
 		__attribute__((section(".note." name),			\
 			       aligned(sizeof(Elf##size##_Word)),	\
 			       unused)) = {				\
diff --git a/include/linux/init.h b/include/linux/init.h
index 5141381..7e1b55a 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -43,7 +43,7 @@
 #define __init		__attribute__ ((__section__ (".init.text"))) __cold
 #define __initdata	__attribute__ ((__section__ (".init.data")))
 #define __exitdata	__attribute__ ((__section__(".exit.data")))
-#define __exit_call	__attribute_used__ __attribute__ ((__section__ (".exitcall.exit")))
+#define __exit_call	__used __attribute__ ((__section__ (".exitcall.exit")))
 
 /* modpost check for section mismatches during the kernel build.
  * A section mismatch happens when there are references from a
@@ -62,7 +62,7 @@
 #ifdef MODULE
 #define __exit		__attribute__ ((__section__(".exit.text"))) __cold
 #else
-#define __exit		__attribute_used__ __attribute__ ((__section__(".exit.text"))) __cold
+#define __exit		__used __attribute__ ((__section__(".exit.text"))) __cold
 #endif
 
 /* For assembly routines */
@@ -108,7 +108,7 @@ void prepare_namespace(void);
  */
 
 #define __define_initcall(level,fn,id) \
-	static initcall_t __initcall_##fn##id __attribute_used__ \
+	static initcall_t __initcall_##fn##id __used \
 	__attribute__((__section__(".initcall" level ".init"))) = fn
 
 /*
@@ -142,11 +142,11 @@ void prepare_namespace(void);
 
 #define console_initcall(fn) \
 	static initcall_t __initcall_##fn \
-	__attribute_used__ __attribute__((__section__(".con_initcall.init")))=fn
+	__used __attribute__((__section__(".con_initcall.init")))=fn
 
 #define security_initcall(fn) \
 	static initcall_t __initcall_##fn \
-	__attribute_used__ __attribute__((__section__(".security_initcall.init"))) = fn
+	__used __attribute__((__section__(".security_initcall.init"))) = fn
 
 struct obs_kernel_param {
 	const char *str;
@@ -163,7 +163,7 @@ struct obs_kernel_param {
 #define __setup_param(str, unique_id, fn, early)			\
 	static char __setup_str_##unique_id[] __initdata __aligned(1) = str; \
 	static struct obs_kernel_param __setup_##unique_id	\
-		__attribute_used__				\
+		__used						\
 		__attribute__((__section__(".init.setup")))	\
 		__attribute__((aligned((sizeof(long)))))	\
 		= { __setup_str_##unique_id, fn, early }
diff --git a/include/linux/module.h b/include/linux/module.h
index 2cbc0b8..e6b6294 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -178,7 +178,7 @@ void *__symbol_get_gpl(const char *symbol);
 #define __CRC_SYMBOL(sym, sec)					\
 	extern void *__crc_##sym __attribute__((weak));		\
 	static const unsigned long __kcrctab_##sym		\
-	__attribute_used__					\
+	__used							\
 	__attribute__((section("__kcrctab" sec), unused))	\
 	= (unsigned long) &__crc_##sym;
 #else
@@ -193,7 +193,7 @@ void *__symbol_get_gpl(const char *symbol);
 	__attribute__((section("__ksymtab_strings")))		\
 	= MODULE_SYMBOL_PREFIX #sym;                    	\
 	static const struct kernel_symbol __ksymtab_##sym	\
-	__attribute_used__					\
+	__used							\
 	__attribute__((section("__ksymtab" sec), unused))	\
 	= { (unsigned long)&sym, __kstrtab_##sym }
 
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 13410b2..8126e55 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -18,7 +18,7 @@
 #define __module_cat(a,b) ___module_cat(a,b)
 #define __MODULE_INFO(tag, name, info)					  \
 static const char __module_cat(name,__LINE__)[]				  \
-  __attribute_used__							  \
+  __used								  \
   __attribute__((section(".modinfo"),unused)) = __stringify(tag) "=" info
 #else  /* !MODULE */
 #define __MODULE_INFO(tag, name, info)
@@ -72,7 +72,7 @@ struct kparam_array
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2));	\
 	static const char __param_str_##name[] = prefix #name;		\
 	static struct kernel_param const __param_##name			\
-	__attribute_used__						\
+	__used								\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
 	= { __param_str_##name, perm, set, get, { arg } }
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5d2281f..38e721d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -857,7 +857,7 @@ enum pci_fixup_pass {
 
 /* Anonymous variables would be nice... */
 #define DECLARE_PCI_FIXUP_SECTION(section, name, vendor, device, hook)	\
-	static const struct pci_fixup __pci_fixup_##name __attribute_used__ \
+	static const struct pci_fixup __pci_fixup_##name __used		\
 	__attribute__((__section__(#section))) = { vendor, device, hook };
 #define DECLARE_PCI_FIXUP_EARLY(vendor, device, hook)			\
 	DECLARE_PCI_FIXUP_SECTION(.pci_fixup_early,			\
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 93ac52a..82d16dc 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1458,7 +1458,7 @@ static int add_versions(struct buffer *b, struct module *mod)
 
 	buf_printf(b, "\n");
 	buf_printf(b, "static const struct modversion_info ____versions[]\n");
-	buf_printf(b, "__attribute_used__\n");
+	buf_printf(b, "__used\n");
 	buf_printf(b, "__attribute__((section(\"__versions\"))) = {\n");
 
 	for (s = mod->unres; s; s = s->next) {
@@ -1491,7 +1491,7 @@ static void add_depends(struct buffer *b, struct module *mod,
 
 	buf_printf(b, "\n");
 	buf_printf(b, "static const char __module_depends[]\n");
-	buf_printf(b, "__attribute_used__\n");
+	buf_printf(b, "__used\n");
 	buf_printf(b, "__attribute__((section(\".modinfo\"))) =\n");
 	buf_printf(b, "\"depends=");
 	for (s = mod->unres; s; s = s->next) {

