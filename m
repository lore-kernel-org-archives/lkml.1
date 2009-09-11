Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbZIKTmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbZIKTmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263AbZIKTma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:42:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42250 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262AbZIKTm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:42:26 -0400
Date: Fri, 11 Sep 2009 21:42:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86/cpu for v2.6.32
Message-ID: <20090911194206.GA28578@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cpu-for-linus

 Thanks,

	Ingo

------------------>
Andreas Herrmann (4):
      x86: Fix CPU llc_shared_map information for AMD Magny-Cours
      x86, cacheinfo: Fixup L3 cache information for AMD multi-node processors
      x86, mcheck: Use correct cpumask for shared bank4
      x86, sched: Workaround broken sched domain creation for AMD Magny-Cours

Ben Hutchings (1):
      x86: Fix code patching for paravirt-alternatives on 486

Borislav Petkov (3):
      x86, msr: Add rd/wrmsr interfaces with preset registers
      x86, msr: Rewrite AMD rd/wrmsr variants
      x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM CPUID bit

H. Peter Anvin (8):
      x86, asm: Add 32-bit versions of the combined CFI macros
      x86, asm: Make _ASM_EXTABLE() usable from assembly code
      x86, msr: CFI annotations, cleanups for msr-reg.S
      x86, msr: Have the _safe MSR functions return -EIO, not -EFAULT
      x86, msr: Create _on_cpu helpers for {rw,wr}msr_safe_regs()
      x86, msr: Export the register-setting MSR functions via /dev/*/msr
      x86, msr: fix msr-reg.S compilation with gas 2.16.1
      x86, msr: change msr-reg.o to obj-y, and export its symbols

Huang Ying (1):
      x86: Move kernel_fpu_using to irq_fpu_usable in asm/i387.h

Ingo Molnar (1):
      x86, msr: Fix msr-reg.S compilation with gas 2.16.1, on 32-bit too

Jaswinder Singh Rajput (1):
      x86, cpu: cpu/proc.c display cache alignment and address sizes for 32 bit

Jeremy Fitzhardinge (1):
      x86/paravirt: split paravirt definitions into paravirt_types.h

Tobias Doerffel (1):
      x86: add specific support for Intel Atom architecture

Yinghai Lu (1):
      x86: Use hard_smp_processor_id() to get apic id for AMD K8 cpus


 Documentation/ioctl/ioctl-number.txt  |    1 +
 arch/x86/Kconfig.cpu                  |   19 +-
 arch/x86/Makefile                     |    2 +
 arch/x86/Makefile_32.cpu              |    2 +
 arch/x86/crypto/aesni-intel_glue.c    |   17 +-
 arch/x86/include/asm/asm.h            |   10 +-
 arch/x86/include/asm/cpufeature.h     |    1 +
 arch/x86/include/asm/dwarf2.h         |   18 +-
 arch/x86/include/asm/i387.h           |    8 +
 arch/x86/include/asm/module.h         |    2 +
 arch/x86/include/asm/msr.h            |   75 +++-
 arch/x86/include/asm/paravirt.h       |  746 ++-------------------------------
 arch/x86/include/asm/paravirt_types.h |  721 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/processor.h      |   16 +-
 arch/x86/kernel/alternative.c         |    2 +-
 arch/x86/kernel/cpu/amd.c             |   80 ++++-
 arch/x86/kernel/cpu/intel_cacheinfo.c |   32 +-
 arch/x86/kernel/cpu/mcheck/mce_amd.c  |    8 +-
 arch/x86/kernel/cpu/proc.c            |    2 -
 arch/x86/kernel/msr.c                 |   61 +++-
 arch/x86/kernel/paravirt.c            |    3 +-
 arch/x86/kernel/smpboot.c             |    3 +-
 arch/x86/lib/Makefile                 |    2 +
 arch/x86/lib/msr-reg-export.c         |    5 +
 arch/x86/lib/msr-reg.S                |  102 +++++
 arch/x86/lib/msr.c                    |   49 +++
 arch/x86/xen/enlighten.c              |    2 +-
 27 files changed, 1203 insertions(+), 786 deletions(-)
 create mode 100644 arch/x86/include/asm/paravirt_types.h
 create mode 100644 arch/x86/lib/msr-reg-export.c
 create mode 100644 arch/x86/lib/msr-reg.S

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index dbea4f9..1c058b5 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -121,6 +121,7 @@ Code	Seq#	Include File		Comments
 'c'	00-7F	linux/comstats.h	conflict!
 'c'	00-7F	linux/coda.h		conflict!
 'c'	80-9F	arch/s390/include/asm/chsc.h
+'c'	A0-AF   arch/x86/include/asm/msr.h
 'd'	00-FF	linux/char/drm/drm/h	conflict!
 'd'	F0-FF	linux/digi1.h
 'e'	all	linux/digi1.h		conflict!
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 8130334..527519b 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -262,6 +262,15 @@ config MCORE2
 	  family in /proc/cpuinfo. Newer ones have 6 and older ones 15
 	  (not a typo)
 
+config MATOM
+	bool "Intel Atom"
+	---help---
+
+	  Select this for the Intel Atom platform. Intel Atom CPUs have an
+	  in-order pipelining architecture and thus can benefit from
+	  accordingly optimized code. Use a recent GCC with specific Atom
+	  support in order to fully benefit from selecting this option.
+
 config GENERIC_CPU
 	bool "Generic-x86-64"
 	depends on X86_64
@@ -295,7 +304,7 @@ config X86_CPU
 config X86_L1_CACHE_BYTES
 	int
 	default "128" if MPSC
-	default "64" if GENERIC_CPU || MK8 || MCORE2 || X86_32
+	default "64" if GENERIC_CPU || MK8 || MCORE2 || MATOM || X86_32
 
 config X86_INTERNODE_CACHE_BYTES
 	int
@@ -310,7 +319,7 @@ config X86_L1_CACHE_SHIFT
 	default "7" if MPENTIUM4 || MPSC
 	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
-	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7 || X86_GENERIC || GENERIC_CPU
+	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
 
 config X86_XADD
 	def_bool y
@@ -359,7 +368,7 @@ config X86_INTEL_USERCOPY
 
 config X86_USE_PPRO_CHECKSUM
 	def_bool y
-	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2
+	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2 || MATOM
 
 config X86_USE_3DNOW
 	def_bool y
@@ -387,7 +396,7 @@ config X86_P6_NOP
 
 config X86_TSC
 	def_bool y
-	depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ) || X86_64
+	depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2 || MATOM) && !X86_NUMAQ) || X86_64
 
 config X86_CMPXCHG64
 	def_bool y
@@ -397,7 +406,7 @@ config X86_CMPXCHG64
 # generates cmov.
 config X86_CMOV
 	def_bool y
-	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64)
+	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64 || MATOM)
 
 config X86_MINIMUM_CPU_FAMILY
 	int
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1b68659..8a4c24c 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -55,6 +55,8 @@ else
 
         cflags-$(CONFIG_MCORE2) += \
                 $(call cc-option,-march=core2,$(call cc-option,-mtune=generic))
+	cflags-$(CONFIG_MATOM) += $(call cc-option,-march=atom) \
+		$(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
         cflags-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=generic)
         KBUILD_CFLAGS += $(cflags-y)
 
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index 80177ec..30e9a26 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -33,6 +33,8 @@ cflags-$(CONFIG_MCYRIXIII)	+= $(call cc-option,-march=c3,-march=i486) $(align)-f
 cflags-$(CONFIG_MVIAC3_2)	+= $(call cc-option,-march=c3-2,-march=i686)
 cflags-$(CONFIG_MVIAC7)		+= -march=i686
 cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call tune,core2)
+cflags-$(CONFIG_MATOM)		+= $(call cc-option,-march=atom,$(call cc-option,-march=core2,-march=i686)) \
+	$(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
 
 # AMD Elan support
 cflags-$(CONFIG_X86_ELAN)	+= -march=i486
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index c580c5e..7667235 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -59,13 +59,6 @@ asmlinkage void aesni_cbc_enc(struct crypto_aes_ctx *ctx, u8 *out,
 asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
-static inline int kernel_fpu_using(void)
-{
-	if (in_interrupt() && !(read_cr0() & X86_CR0_TS))
-		return 1;
-	return 0;
-}
-
 static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
 {
 	unsigned long addr = (unsigned long)raw_ctx;
@@ -89,7 +82,7 @@ static int aes_set_key_common(struct crypto_tfm *tfm, void *raw_ctx,
 		return -EINVAL;
 	}
 
-	if (kernel_fpu_using())
+	if (irq_fpu_usable())
 		err = crypto_aes_expand_key(ctx, in_key, key_len);
 	else {
 		kernel_fpu_begin();
@@ -110,7 +103,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
 
-	if (kernel_fpu_using())
+	if (irq_fpu_usable())
 		crypto_aes_encrypt_x86(ctx, dst, src);
 	else {
 		kernel_fpu_begin();
@@ -123,7 +116,7 @@ static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
 
-	if (kernel_fpu_using())
+	if (irq_fpu_usable())
 		crypto_aes_decrypt_x86(ctx, dst, src);
 	else {
 		kernel_fpu_begin();
@@ -349,7 +342,7 @@ static int ablk_encrypt(struct ablkcipher_request *req)
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct async_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 
-	if (kernel_fpu_using()) {
+	if (irq_fpu_usable()) {
 		struct ablkcipher_request *cryptd_req =
 			ablkcipher_request_ctx(req);
 		memcpy(cryptd_req, req, sizeof(*req));
@@ -370,7 +363,7 @@ static int ablk_decrypt(struct ablkcipher_request *req)
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct async_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 
-	if (kernel_fpu_using()) {
+	if (irq_fpu_usable()) {
 		struct ablkcipher_request *cryptd_req =
 			ablkcipher_request_ctx(req);
 		memcpy(cryptd_req, req, sizeof(*req));
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 56be78f..b3ed1e1 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -3,7 +3,7 @@
 
 #ifdef __ASSEMBLY__
 # define __ASM_FORM(x)	x
-# define __ASM_EX_SEC	.section __ex_table
+# define __ASM_EX_SEC	.section __ex_table, "a"
 #else
 # define __ASM_FORM(x)	" " #x " "
 # define __ASM_EX_SEC	" .section __ex_table,\"a\"\n"
@@ -38,10 +38,18 @@
 #define _ASM_DI		__ASM_REG(di)
 
 /* Exception table entry */
+#ifdef __ASSEMBLY__
+# define _ASM_EXTABLE(from,to)	    \
+	__ASM_EX_SEC ;		    \
+	_ASM_ALIGN ;		    \
+	_ASM_PTR from , to ;	    \
+	.previous
+#else
 # define _ASM_EXTABLE(from,to) \
 	__ASM_EX_SEC	\
 	_ASM_ALIGN "\n" \
 	_ASM_PTR #from "," #to "\n" \
 	" .previous\n"
+#endif
 
 #endif /* _ASM_X86_ASM_H */
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4a28d22..847fee6 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -95,6 +95,7 @@
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
 #define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with monitor */
 #define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
+#define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index 3afc5e8..ae6253a 100644
--- a/arch/x86/include/asm/dwarf2.h
+++ b/arch/x86/include/asm/dwarf2.h
@@ -87,9 +87,25 @@
 	CFI_RESTORE \reg
 	.endm
 #else /*!CONFIG_X86_64*/
+	.macro pushl_cfi reg
+	pushl \reg
+	CFI_ADJUST_CFA_OFFSET 4
+	.endm
 
-	/* 32bit defenitions are missed yet */
+	.macro popl_cfi reg
+	popl \reg
+	CFI_ADJUST_CFA_OFFSET -4
+	.endm
 
+	.macro movl_cfi reg offset=0
+	movl %\reg, \offset(%esp)
+	CFI_REL_OFFSET \reg, \offset
+	.endm
+
+	.macro movl_cfi_restore offset reg
+	movl \offset(%esp), %\reg
+	CFI_RESTORE \reg
+	.endm
 #endif /*!CONFIG_X86_64*/
 #endif /*__ASSEMBLY__*/
 
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 175adf5..fb7f0d6 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -301,6 +301,14 @@ static inline void kernel_fpu_end(void)
 	preempt_enable();
 }
 
+static inline bool irq_fpu_usable(void)
+{
+	struct pt_regs *regs;
+
+	return !in_interrupt() || !(regs = get_irq_regs()) || \
+		user_mode(regs) || (read_cr0() & X86_CR0_TS);
+}
+
 /*
  * Some instructions like VIA's padlock instructions generate a spurious
  * DNA fault but don't modify SSE registers. And these instructions
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index 47d6274..e959c4a 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -28,6 +28,8 @@ struct mod_arch_specific {};
 #define MODULE_PROC_FAMILY "586MMX "
 #elif defined CONFIG_MCORE2
 #define MODULE_PROC_FAMILY "CORE2 "
+#elif defined CONFIG_MATOM
+#define MODULE_PROC_FAMILY "ATOM "
 #elif defined CONFIG_M686
 #define MODULE_PROC_FAMILY "686 "
 #elif defined CONFIG_MPENTIUMII
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 48ad9d2..7e2b6ba 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -3,10 +3,16 @@
 
 #include <asm/msr-index.h>
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define X86_IOC_RDMSR_REGS	_IOWR('c', 0xA0, __u32[8])
+#define X86_IOC_WRMSR_REGS	_IOWR('c', 0xA1, __u32[8])
+
+#ifdef __KERNEL__
+
 #include <asm/asm.h>
 #include <asm/errno.h>
 #include <asm/cpumask.h>
@@ -67,23 +73,7 @@ static inline unsigned long long native_read_msr_safe(unsigned int msr,
 		     ".previous\n\t"
 		     _ASM_EXTABLE(2b, 3b)
 		     : [err] "=r" (*err), EAX_EDX_RET(val, low, high)
-		     : "c" (msr), [fault] "i" (-EFAULT));
-	return EAX_EDX_VAL(val, low, high);
-}
-
-static inline unsigned long long native_read_msr_amd_safe(unsigned int msr,
-						      int *err)
-{
-	DECLARE_ARGS(val, low, high);
-
-	asm volatile("2: rdmsr ; xor %0,%0\n"
-		     "1:\n\t"
-		     ".section .fixup,\"ax\"\n\t"
-		     "3:  mov %3,%0 ; jmp 1b\n\t"
-		     ".previous\n\t"
-		     _ASM_EXTABLE(2b, 3b)
-		     : "=r" (*err), EAX_EDX_RET(val, low, high)
-		     : "c" (msr), "D" (0x9c5a203a), "i" (-EFAULT));
+		     : "c" (msr), [fault] "i" (-EIO));
 	return EAX_EDX_VAL(val, low, high);
 }
 
@@ -106,13 +96,16 @@ notrace static inline int native_write_msr_safe(unsigned int msr,
 		     _ASM_EXTABLE(2b, 3b)
 		     : [err] "=a" (err)
 		     : "c" (msr), "0" (low), "d" (high),
-		       [fault] "i" (-EFAULT)
+		       [fault] "i" (-EIO)
 		     : "memory");
 	return err;
 }
 
 extern unsigned long long native_read_tsc(void);
 
+extern int native_rdmsr_safe_regs(u32 regs[8]);
+extern int native_wrmsr_safe_regs(u32 regs[8]);
+
 static __always_inline unsigned long long __native_read_tsc(void)
 {
 	DECLARE_ARGS(val, low, high);
@@ -181,14 +174,44 @@ static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
 	*p = native_read_msr_safe(msr, &err);
 	return err;
 }
+
 static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
 {
+	u32 gprs[8] = { 0 };
 	int err;
 
-	*p = native_read_msr_amd_safe(msr, &err);
+	gprs[1] = msr;
+	gprs[7] = 0x9c5a203a;
+
+	err = native_rdmsr_safe_regs(gprs);
+
+	*p = gprs[0] | ((u64)gprs[2] << 32);
+
 	return err;
 }
 
+static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
+{
+	u32 gprs[8] = { 0 };
+
+	gprs[0] = (u32)val;
+	gprs[1] = msr;
+	gprs[2] = val >> 32;
+	gprs[7] = 0x9c5a203a;
+
+	return native_wrmsr_safe_regs(gprs);
+}
+
+static inline int rdmsr_safe_regs(u32 regs[8])
+{
+	return native_rdmsr_safe_regs(regs);
+}
+
+static inline int wrmsr_safe_regs(u32 regs[8])
+{
+	return native_wrmsr_safe_regs(regs);
+}
+
 #define rdtscl(low)						\
 	((low) = (u32)__native_read_tsc())
 
@@ -228,6 +251,8 @@ void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
 void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs);
 int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
+int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8]);
+int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8]);
 #else  /*  CONFIG_SMP  */
 static inline int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
 {
@@ -258,7 +283,15 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 {
 	return wrmsr_safe(msr_no, l, h);
 }
+static inline int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8])
+{
+	return rdmsr_safe_regs(regs);
+}
+static inline int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8])
+{
+	return wrmsr_safe_regs(regs);
+}
 #endif  /* CONFIG_SMP */
-#endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
+#endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_MSR_H */
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 4fb37c8..40d6586 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -7,689 +7,11 @@
 #include <asm/pgtable_types.h>
 #include <asm/asm.h>
 
-/* Bitmask of what can be clobbered: usually at least eax. */
-#define CLBR_NONE 0
-#define CLBR_EAX  (1 << 0)
-#define CLBR_ECX  (1 << 1)
-#define CLBR_EDX  (1 << 2)
-#define CLBR_EDI  (1 << 3)
-
-#ifdef CONFIG_X86_32
-/* CLBR_ANY should match all regs platform has. For i386, that's just it */
-#define CLBR_ANY  ((1 << 4) - 1)
-
-#define CLBR_ARG_REGS	(CLBR_EAX | CLBR_EDX | CLBR_ECX)
-#define CLBR_RET_REG	(CLBR_EAX | CLBR_EDX)
-#define CLBR_SCRATCH	(0)
-#else
-#define CLBR_RAX  CLBR_EAX
-#define CLBR_RCX  CLBR_ECX
-#define CLBR_RDX  CLBR_EDX
-#define CLBR_RDI  CLBR_EDI
-#define CLBR_RSI  (1 << 4)
-#define CLBR_R8   (1 << 5)
-#define CLBR_R9   (1 << 6)
-#define CLBR_R10  (1 << 7)
-#define CLBR_R11  (1 << 8)
-
-#define CLBR_ANY  ((1 << 9) - 1)
-
-#define CLBR_ARG_REGS	(CLBR_RDI | CLBR_RSI | CLBR_RDX | \
-			 CLBR_RCX | CLBR_R8 | CLBR_R9)
-#define CLBR_RET_REG	(CLBR_RAX)
-#define CLBR_SCRATCH	(CLBR_R10 | CLBR_R11)
-
-#include <asm/desc_defs.h>
-#endif /* X86_64 */
-
-#define CLBR_CALLEE_SAVE ((CLBR_ARG_REGS | CLBR_SCRATCH) & ~CLBR_RET_REG)
+#include <asm/paravirt_types.h>
 
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 #include <linux/cpumask.h>
-#include <asm/kmap_types.h>
-#include <asm/desc_defs.h>
-
-struct page;
-struct thread_struct;
-struct desc_ptr;
-struct tss_struct;
-struct mm_struct;
-struct desc_struct;
-struct task_struct;
-
-/*
- * Wrapper type for pointers to code which uses the non-standard
- * calling convention.  See PV_CALL_SAVE_REGS_THUNK below.
- */
-struct paravirt_callee_save {
-	void *func;
-};
-
-/* general info */
-struct pv_info {
-	unsigned int kernel_rpl;
-	int shared_kernel_pmd;
-	int paravirt_enabled;
-	const char *name;
-};
-
-struct pv_init_ops {
-	/*
-	 * Patch may replace one of the defined code sequences with
-	 * arbitrary code, subject to the same register constraints.
-	 * This generally means the code is not free to clobber any
-	 * registers other than EAX.  The patch function should return
-	 * the number of bytes of code generated, as we nop pad the
-	 * rest in generic code.
-	 */
-	unsigned (*patch)(u8 type, u16 clobber, void *insnbuf,
-			  unsigned long addr, unsigned len);
-
-	/* Basic arch-specific setup */
-	void (*arch_setup)(void);
-	char *(*memory_setup)(void);
-	void (*post_allocator_init)(void);
-
-	/* Print a banner to identify the environment */
-	void (*banner)(void);
-};
-
-
-struct pv_lazy_ops {
-	/* Set deferred update mode, used for batching operations. */
-	void (*enter)(void);
-	void (*leave)(void);
-};
-
-struct pv_time_ops {
-	void (*time_init)(void);
-
-	/* Set and set time of day */
-	unsigned long (*get_wallclock)(void);
-	int (*set_wallclock)(unsigned long);
-
-	unsigned long long (*sched_clock)(void);
-	unsigned long (*get_tsc_khz)(void);
-};
-
-struct pv_cpu_ops {
-	/* hooks for various privileged instructions */
-	unsigned long (*get_debugreg)(int regno);
-	void (*set_debugreg)(int regno, unsigned long value);
-
-	void (*clts)(void);
-
-	unsigned long (*read_cr0)(void);
-	void (*write_cr0)(unsigned long);
-
-	unsigned long (*read_cr4_safe)(void);
-	unsigned long (*read_cr4)(void);
-	void (*write_cr4)(unsigned long);
-
-#ifdef CONFIG_X86_64
-	unsigned long (*read_cr8)(void);
-	void (*write_cr8)(unsigned long);
-#endif
-
-	/* Segment descriptor handling */
-	void (*load_tr_desc)(void);
-	void (*load_gdt)(const struct desc_ptr *);
-	void (*load_idt)(const struct desc_ptr *);
-	void (*store_gdt)(struct desc_ptr *);
-	void (*store_idt)(struct desc_ptr *);
-	void (*set_ldt)(const void *desc, unsigned entries);
-	unsigned long (*store_tr)(void);
-	void (*load_tls)(struct thread_struct *t, unsigned int cpu);
-#ifdef CONFIG_X86_64
-	void (*load_gs_index)(unsigned int idx);
-#endif
-	void (*write_ldt_entry)(struct desc_struct *ldt, int entrynum,
-				const void *desc);
-	void (*write_gdt_entry)(struct desc_struct *,
-				int entrynum, const void *desc, int size);
-	void (*write_idt_entry)(gate_desc *,
-				int entrynum, const gate_desc *gate);
-	void (*alloc_ldt)(struct desc_struct *ldt, unsigned entries);
-	void (*free_ldt)(struct desc_struct *ldt, unsigned entries);
-
-	void (*load_sp0)(struct tss_struct *tss, struct thread_struct *t);
-
-	void (*set_iopl_mask)(unsigned mask);
-
-	void (*wbinvd)(void);
-	void (*io_delay)(void);
-
-	/* cpuid emulation, mostly so that caps bits can be disabled */
-	void (*cpuid)(unsigned int *eax, unsigned int *ebx,
-		      unsigned int *ecx, unsigned int *edx);
-
-	/* MSR, PMC and TSR operations.
-	   err = 0/-EFAULT.  wrmsr returns 0/-EFAULT. */
-	u64 (*read_msr_amd)(unsigned int msr, int *err);
-	u64 (*read_msr)(unsigned int msr, int *err);
-	int (*write_msr)(unsigned int msr, unsigned low, unsigned high);
-
-	u64 (*read_tsc)(void);
-	u64 (*read_pmc)(int counter);
-	unsigned long long (*read_tscp)(unsigned int *aux);
-
-	/*
-	 * Atomically enable interrupts and return to userspace.  This
-	 * is only ever used to return to 32-bit processes; in a
-	 * 64-bit kernel, it's used for 32-on-64 compat processes, but
-	 * never native 64-bit processes.  (Jump, not call.)
-	 */
-	void (*irq_enable_sysexit)(void);
-
-	/*
-	 * Switch to usermode gs and return to 64-bit usermode using
-	 * sysret.  Only used in 64-bit kernels to return to 64-bit
-	 * processes.  Usermode register state, including %rsp, must
-	 * already be restored.
-	 */
-	void (*usergs_sysret64)(void);
-
-	/*
-	 * Switch to usermode gs and return to 32-bit usermode using
-	 * sysret.  Used to return to 32-on-64 compat processes.
-	 * Other usermode register state, including %esp, must already
-	 * be restored.
-	 */
-	void (*usergs_sysret32)(void);
-
-	/* Normal iret.  Jump to this with the standard iret stack
-	   frame set up. */
-	void (*iret)(void);
-
-	void (*swapgs)(void);
-
-	void (*start_context_switch)(struct task_struct *prev);
-	void (*end_context_switch)(struct task_struct *next);
-};
-
-struct pv_irq_ops {
-	void (*init_IRQ)(void);
-
-	/*
-	 * Get/set interrupt state.  save_fl and restore_fl are only
-	 * expected to use X86_EFLAGS_IF; all other bits
-	 * returned from save_fl are undefined, and may be ignored by
-	 * restore_fl.
-	 *
-	 * NOTE: These functions callers expect the callee to preserve
-	 * more registers than the standard C calling convention.
-	 */
-	struct paravirt_callee_save save_fl;
-	struct paravirt_callee_save restore_fl;
-	struct paravirt_callee_save irq_disable;
-	struct paravirt_callee_save irq_enable;
-
-	void (*safe_halt)(void);
-	void (*halt)(void);
-
-#ifdef CONFIG_X86_64
-	void (*adjust_exception_frame)(void);
-#endif
-};
-
-struct pv_apic_ops {
-#ifdef CONFIG_X86_LOCAL_APIC
-	void (*setup_boot_clock)(void);
-	void (*setup_secondary_clock)(void);
-
-	void (*startup_ipi_hook)(int phys_apicid,
-				 unsigned long start_eip,
-				 unsigned long start_esp);
-#endif
-};
-
-struct pv_mmu_ops {
-	/*
-	 * Called before/after init_mm pagetable setup. setup_start
-	 * may reset %cr3, and may pre-install parts of the pagetable;
-	 * pagetable setup is expected to preserve any existing
-	 * mapping.
-	 */
-	void (*pagetable_setup_start)(pgd_t *pgd_base);
-	void (*pagetable_setup_done)(pgd_t *pgd_base);
-
-	unsigned long (*read_cr2)(void);
-	void (*write_cr2)(unsigned long);
-
-	unsigned long (*read_cr3)(void);
-	void (*write_cr3)(unsigned long);
-
-	/*
-	 * Hooks for intercepting the creation/use/destruction of an
-	 * mm_struct.
-	 */
-	void (*activate_mm)(struct mm_struct *prev,
-			    struct mm_struct *next);
-	void (*dup_mmap)(struct mm_struct *oldmm,
-			 struct mm_struct *mm);
-	void (*exit_mmap)(struct mm_struct *mm);
-
-
-	/* TLB operations */
-	void (*flush_tlb_user)(void);
-	void (*flush_tlb_kernel)(void);
-	void (*flush_tlb_single)(unsigned long addr);
-	void (*flush_tlb_others)(const struct cpumask *cpus,
-				 struct mm_struct *mm,
-				 unsigned long va);
-
-	/* Hooks for allocating and freeing a pagetable top-level */
-	int  (*pgd_alloc)(struct mm_struct *mm);
-	void (*pgd_free)(struct mm_struct *mm, pgd_t *pgd);
-
-	/*
-	 * Hooks for allocating/releasing pagetable pages when they're
-	 * attached to a pagetable
-	 */
-	void (*alloc_pte)(struct mm_struct *mm, unsigned long pfn);
-	void (*alloc_pmd)(struct mm_struct *mm, unsigned long pfn);
-	void (*alloc_pmd_clone)(unsigned long pfn, unsigned long clonepfn, unsigned long start, unsigned long count);
-	void (*alloc_pud)(struct mm_struct *mm, unsigned long pfn);
-	void (*release_pte)(unsigned long pfn);
-	void (*release_pmd)(unsigned long pfn);
-	void (*release_pud)(unsigned long pfn);
-
-	/* Pagetable manipulation functions */
-	void (*set_pte)(pte_t *ptep, pte_t pteval);
-	void (*set_pte_at)(struct mm_struct *mm, unsigned long addr,
-			   pte_t *ptep, pte_t pteval);
-	void (*set_pmd)(pmd_t *pmdp, pmd_t pmdval);
-	void (*pte_update)(struct mm_struct *mm, unsigned long addr,
-			   pte_t *ptep);
-	void (*pte_update_defer)(struct mm_struct *mm,
-				 unsigned long addr, pte_t *ptep);
-
-	pte_t (*ptep_modify_prot_start)(struct mm_struct *mm, unsigned long addr,
-					pte_t *ptep);
-	void (*ptep_modify_prot_commit)(struct mm_struct *mm, unsigned long addr,
-					pte_t *ptep, pte_t pte);
-
-	struct paravirt_callee_save pte_val;
-	struct paravirt_callee_save make_pte;
-
-	struct paravirt_callee_save pgd_val;
-	struct paravirt_callee_save make_pgd;
-
-#if PAGETABLE_LEVELS >= 3
-#ifdef CONFIG_X86_PAE
-	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
-	void (*pte_clear)(struct mm_struct *mm, unsigned long addr,
-			  pte_t *ptep);
-	void (*pmd_clear)(pmd_t *pmdp);
-
-#endif	/* CONFIG_X86_PAE */
-
-	void (*set_pud)(pud_t *pudp, pud_t pudval);
-
-	struct paravirt_callee_save pmd_val;
-	struct paravirt_callee_save make_pmd;
-
-#if PAGETABLE_LEVELS == 4
-	struct paravirt_callee_save pud_val;
-	struct paravirt_callee_save make_pud;
-
-	void (*set_pgd)(pgd_t *pudp, pgd_t pgdval);
-#endif	/* PAGETABLE_LEVELS == 4 */
-#endif	/* PAGETABLE_LEVELS >= 3 */
-
-#ifdef CONFIG_HIGHPTE
-	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
-#endif
-
-	struct pv_lazy_ops lazy_mode;
-
-	/* dom0 ops */
-
-	/* Sometimes the physical address is a pfn, and sometimes its
-	   an mfn.  We can tell which is which from the index. */
-	void (*set_fixmap)(unsigned /* enum fixed_addresses */ idx,
-			   phys_addr_t phys, pgprot_t flags);
-};
-
-struct raw_spinlock;
-struct pv_lock_ops {
-	int (*spin_is_locked)(struct raw_spinlock *lock);
-	int (*spin_is_contended)(struct raw_spinlock *lock);
-	void (*spin_lock)(struct raw_spinlock *lock);
-	void (*spin_lock_flags)(struct raw_spinlock *lock, unsigned long flags);
-	int (*spin_trylock)(struct raw_spinlock *lock);
-	void (*spin_unlock)(struct raw_spinlock *lock);
-};
-
-/* This contains all the paravirt structures: we get a convenient
- * number for each function using the offset which we use to indicate
- * what to patch. */
-struct paravirt_patch_template {
-	struct pv_init_ops pv_init_ops;
-	struct pv_time_ops pv_time_ops;
-	struct pv_cpu_ops pv_cpu_ops;
-	struct pv_irq_ops pv_irq_ops;
-	struct pv_apic_ops pv_apic_ops;
-	struct pv_mmu_ops pv_mmu_ops;
-	struct pv_lock_ops pv_lock_ops;
-};
-
-extern struct pv_info pv_info;
-extern struct pv_init_ops pv_init_ops;
-extern struct pv_time_ops pv_time_ops;
-extern struct pv_cpu_ops pv_cpu_ops;
-extern struct pv_irq_ops pv_irq_ops;
-extern struct pv_apic_ops pv_apic_ops;
-extern struct pv_mmu_ops pv_mmu_ops;
-extern struct pv_lock_ops pv_lock_ops;
-
-#define PARAVIRT_PATCH(x)					\
-	(offsetof(struct paravirt_patch_template, x) / sizeof(void *))
-
-#define paravirt_type(op)				\
-	[paravirt_typenum] "i" (PARAVIRT_PATCH(op)),	\
-	[paravirt_opptr] "i" (&(op))
-#define paravirt_clobber(clobber)		\
-	[paravirt_clobber] "i" (clobber)
-
-/*
- * Generate some code, and mark it as patchable by the
- * apply_paravirt() alternate instruction patcher.
- */
-#define _paravirt_alt(insn_string, type, clobber)	\
-	"771:\n\t" insn_string "\n" "772:\n"		\
-	".pushsection .parainstructions,\"a\"\n"	\
-	_ASM_ALIGN "\n"					\
-	_ASM_PTR " 771b\n"				\
-	"  .byte " type "\n"				\
-	"  .byte 772b-771b\n"				\
-	"  .short " clobber "\n"			\
-	".popsection\n"
-
-/* Generate patchable code, with the default asm parameters. */
-#define paravirt_alt(insn_string)					\
-	_paravirt_alt(insn_string, "%c[paravirt_typenum]", "%c[paravirt_clobber]")
-
-/* Simple instruction patching code. */
-#define DEF_NATIVE(ops, name, code) 					\
-	extern const char start_##ops##_##name[], end_##ops##_##name[];	\
-	asm("start_" #ops "_" #name ": " code "; end_" #ops "_" #name ":")
-
-unsigned paravirt_patch_nop(void);
-unsigned paravirt_patch_ident_32(void *insnbuf, unsigned len);
-unsigned paravirt_patch_ident_64(void *insnbuf, unsigned len);
-unsigned paravirt_patch_ignore(unsigned len);
-unsigned paravirt_patch_call(void *insnbuf,
-			     const void *target, u16 tgt_clobbers,
-			     unsigned long addr, u16 site_clobbers,
-			     unsigned len);
-unsigned paravirt_patch_jmp(void *insnbuf, const void *target,
-			    unsigned long addr, unsigned len);
-unsigned paravirt_patch_default(u8 type, u16 clobbers, void *insnbuf,
-				unsigned long addr, unsigned len);
-
-unsigned paravirt_patch_insns(void *insnbuf, unsigned len,
-			      const char *start, const char *end);
-
-unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
-		      unsigned long addr, unsigned len);
-
-int paravirt_disable_iospace(void);
-
-/*
- * This generates an indirect call based on the operation type number.
- * The type number, computed in PARAVIRT_PATCH, is derived from the
- * offset into the paravirt_patch_template structure, and can therefore be
- * freely converted back into a structure offset.
- */
-#define PARAVIRT_CALL	"call *%c[paravirt_opptr];"
-
-/*
- * These macros are intended to wrap calls through one of the paravirt
- * ops structs, so that they can be later identified and patched at
- * runtime.
- *
- * Normally, a call to a pv_op function is a simple indirect call:
- * (pv_op_struct.operations)(args...).
- *
- * Unfortunately, this is a relatively slow operation for modern CPUs,
- * because it cannot necessarily determine what the destination
- * address is.  In this case, the address is a runtime constant, so at
- * the very least we can patch the call to e a simple direct call, or
- * ideally, patch an inline implementation into the callsite.  (Direct
- * calls are essentially free, because the call and return addresses
- * are completely predictable.)
- *
- * For i386, these macros rely on the standard gcc "regparm(3)" calling
- * convention, in which the first three arguments are placed in %eax,
- * %edx, %ecx (in that order), and the remaining arguments are placed
- * on the stack.  All caller-save registers (eax,edx,ecx) are expected
- * to be modified (either clobbered or used for return values).
- * X86_64, on the other hand, already specifies a register-based calling
- * conventions, returning at %rax, with parameteres going on %rdi, %rsi,
- * %rdx, and %rcx. Note that for this reason, x86_64 does not need any
- * special handling for dealing with 4 arguments, unlike i386.
- * However, x86_64 also have to clobber all caller saved registers, which
- * unfortunately, are quite a bit (r8 - r11)
- *
- * The call instruction itself is marked by placing its start address
- * and size into the .parainstructions section, so that
- * apply_paravirt() in arch/i386/kernel/alternative.c can do the
- * appropriate patching under the control of the backend pv_init_ops
- * implementation.
- *
- * Unfortunately there's no way to get gcc to generate the args setup
- * for the call, and then allow the call itself to be generated by an
- * inline asm.  Because of this, we must do the complete arg setup and
- * return value handling from within these macros.  This is fairly
- * cumbersome.
- *
- * There are 5 sets of PVOP_* macros for dealing with 0-4 arguments.
- * It could be extended to more arguments, but there would be little
- * to be gained from that.  For each number of arguments, there are
- * the two VCALL and CALL variants for void and non-void functions.
- *
- * When there is a return value, the invoker of the macro must specify
- * the return type.  The macro then uses sizeof() on that type to
- * determine whether its a 32 or 64 bit value, and places the return
- * in the right register(s) (just %eax for 32-bit, and %edx:%eax for
- * 64-bit). For x86_64 machines, it just returns at %rax regardless of
- * the return value size.
- *
- * 64-bit arguments are passed as a pair of adjacent 32-bit arguments
- * i386 also passes 64-bit arguments as a pair of adjacent 32-bit arguments
- * in low,high order
- *
- * Small structures are passed and returned in registers.  The macro
- * calling convention can't directly deal with this, so the wrapper
- * functions must do this.
- *
- * These PVOP_* macros are only defined within this header.  This
- * means that all uses must be wrapped in inline functions.  This also
- * makes sure the incoming and outgoing types are always correct.
- */
-#ifdef CONFIG_X86_32
-#define PVOP_VCALL_ARGS				\
-	unsigned long __eax = __eax, __edx = __edx, __ecx = __ecx
-#define PVOP_CALL_ARGS			PVOP_VCALL_ARGS
-
-#define PVOP_CALL_ARG1(x)		"a" ((unsigned long)(x))
-#define PVOP_CALL_ARG2(x)		"d" ((unsigned long)(x))
-#define PVOP_CALL_ARG3(x)		"c" ((unsigned long)(x))
-
-#define PVOP_VCALL_CLOBBERS		"=a" (__eax), "=d" (__edx),	\
-					"=c" (__ecx)
-#define PVOP_CALL_CLOBBERS		PVOP_VCALL_CLOBBERS
-
-#define PVOP_VCALLEE_CLOBBERS		"=a" (__eax), "=d" (__edx)
-#define PVOP_CALLEE_CLOBBERS		PVOP_VCALLEE_CLOBBERS
-
-#define EXTRA_CLOBBERS
-#define VEXTRA_CLOBBERS
-#else  /* CONFIG_X86_64 */
-#define PVOP_VCALL_ARGS					\
-	unsigned long __edi = __edi, __esi = __esi,	\
-		__edx = __edx, __ecx = __ecx
-#define PVOP_CALL_ARGS		PVOP_VCALL_ARGS, __eax
-
-#define PVOP_CALL_ARG1(x)		"D" ((unsigned long)(x))
-#define PVOP_CALL_ARG2(x)		"S" ((unsigned long)(x))
-#define PVOP_CALL_ARG3(x)		"d" ((unsigned long)(x))
-#define PVOP_CALL_ARG4(x)		"c" ((unsigned long)(x))
-
-#define PVOP_VCALL_CLOBBERS	"=D" (__edi),				\
-				"=S" (__esi), "=d" (__edx),		\
-				"=c" (__ecx)
-#define PVOP_CALL_CLOBBERS	PVOP_VCALL_CLOBBERS, "=a" (__eax)
-
-#define PVOP_VCALLEE_CLOBBERS	"=a" (__eax)
-#define PVOP_CALLEE_CLOBBERS	PVOP_VCALLEE_CLOBBERS
-
-#define EXTRA_CLOBBERS	 , "r8", "r9", "r10", "r11"
-#define VEXTRA_CLOBBERS	 , "rax", "r8", "r9", "r10", "r11"
-#endif	/* CONFIG_X86_32 */
-
-#ifdef CONFIG_PARAVIRT_DEBUG
-#define PVOP_TEST_NULL(op)	BUG_ON(op == NULL)
-#else
-#define PVOP_TEST_NULL(op)	((void)op)
-#endif
-
-#define ____PVOP_CALL(rettype, op, clbr, call_clbr, extra_clbr,		\
-		      pre, post, ...)					\
-	({								\
-		rettype __ret;						\
-		PVOP_CALL_ARGS;						\
-		PVOP_TEST_NULL(op);					\
-		/* This is 32-bit specific, but is okay in 64-bit */	\
-		/* since this condition will never hold */		\
-		if (sizeof(rettype) > sizeof(unsigned long)) {		\
-			asm volatile(pre				\
-				     paravirt_alt(PARAVIRT_CALL)	\
-				     post				\
-				     : call_clbr			\
-				     : paravirt_type(op),		\
-				       paravirt_clobber(clbr),		\
-				       ##__VA_ARGS__			\
-				     : "memory", "cc" extra_clbr);	\
-			__ret = (rettype)((((u64)__edx) << 32) | __eax); \
-		} else {						\
-			asm volatile(pre				\
-				     paravirt_alt(PARAVIRT_CALL)	\
-				     post				\
-				     : call_clbr			\
-				     : paravirt_type(op),		\
-				       paravirt_clobber(clbr),		\
-				       ##__VA_ARGS__			\
-				     : "memory", "cc" extra_clbr);	\
-			__ret = (rettype)__eax;				\
-		}							\
-		__ret;							\
-	})
-
-#define __PVOP_CALL(rettype, op, pre, post, ...)			\
-	____PVOP_CALL(rettype, op, CLBR_ANY, PVOP_CALL_CLOBBERS,	\
-		      EXTRA_CLOBBERS, pre, post, ##__VA_ARGS__)
-
-#define __PVOP_CALLEESAVE(rettype, op, pre, post, ...)			\
-	____PVOP_CALL(rettype, op.func, CLBR_RET_REG,			\
-		      PVOP_CALLEE_CLOBBERS, ,				\
-		      pre, post, ##__VA_ARGS__)
-
-
-#define ____PVOP_VCALL(op, clbr, call_clbr, extra_clbr, pre, post, ...)	\
-	({								\
-		PVOP_VCALL_ARGS;					\
-		PVOP_TEST_NULL(op);					\
-		asm volatile(pre					\
-			     paravirt_alt(PARAVIRT_CALL)		\
-			     post					\
-			     : call_clbr				\
-			     : paravirt_type(op),			\
-			       paravirt_clobber(clbr),			\
-			       ##__VA_ARGS__				\
-			     : "memory", "cc" extra_clbr);		\
-	})
-
-#define __PVOP_VCALL(op, pre, post, ...)				\
-	____PVOP_VCALL(op, CLBR_ANY, PVOP_VCALL_CLOBBERS,		\
-		       VEXTRA_CLOBBERS,					\
-		       pre, post, ##__VA_ARGS__)
-
-#define __PVOP_VCALLEESAVE(rettype, op, pre, post, ...)			\
-	____PVOP_CALL(rettype, op.func, CLBR_RET_REG,			\
-		      PVOP_VCALLEE_CLOBBERS, ,				\
-		      pre, post, ##__VA_ARGS__)
-
-
-
-#define PVOP_CALL0(rettype, op)						\
-	__PVOP_CALL(rettype, op, "", "")
-#define PVOP_VCALL0(op)							\
-	__PVOP_VCALL(op, "", "")
-
-#define PVOP_CALLEE0(rettype, op)					\
-	__PVOP_CALLEESAVE(rettype, op, "", "")
-#define PVOP_VCALLEE0(op)						\
-	__PVOP_VCALLEESAVE(op, "", "")
-
-
-#define PVOP_CALL1(rettype, op, arg1)					\
-	__PVOP_CALL(rettype, op, "", "", PVOP_CALL_ARG1(arg1))
-#define PVOP_VCALL1(op, arg1)						\
-	__PVOP_VCALL(op, "", "", PVOP_CALL_ARG1(arg1))
-
-#define PVOP_CALLEE1(rettype, op, arg1)					\
-	__PVOP_CALLEESAVE(rettype, op, "", "", PVOP_CALL_ARG1(arg1))
-#define PVOP_VCALLEE1(op, arg1)						\
-	__PVOP_VCALLEESAVE(op, "", "", PVOP_CALL_ARG1(arg1))
-
-
-#define PVOP_CALL2(rettype, op, arg1, arg2)				\
-	__PVOP_CALL(rettype, op, "", "", PVOP_CALL_ARG1(arg1),		\
-		    PVOP_CALL_ARG2(arg2))
-#define PVOP_VCALL2(op, arg1, arg2)					\
-	__PVOP_VCALL(op, "", "", PVOP_CALL_ARG1(arg1),			\
-		     PVOP_CALL_ARG2(arg2))
-
-#define PVOP_CALLEE2(rettype, op, arg1, arg2)				\
-	__PVOP_CALLEESAVE(rettype, op, "", "", PVOP_CALL_ARG1(arg1),	\
-			  PVOP_CALL_ARG2(arg2))
-#define PVOP_VCALLEE2(op, arg1, arg2)					\
-	__PVOP_VCALLEESAVE(op, "", "", PVOP_CALL_ARG1(arg1),		\
-			   PVOP_CALL_ARG2(arg2))
-
-
-#define PVOP_CALL3(rettype, op, arg1, arg2, arg3)			\
-	__PVOP_CALL(rettype, op, "", "", PVOP_CALL_ARG1(arg1),		\
-		    PVOP_CALL_ARG2(arg2), PVOP_CALL_ARG3(arg3))
-#define PVOP_VCALL3(op, arg1, arg2, arg3)				\
-	__PVOP_VCALL(op, "", "", PVOP_CALL_ARG1(arg1),			\
-		     PVOP_CALL_ARG2(arg2), PVOP_CALL_ARG3(arg3))
-
-/* This is the only difference in x86_64. We can make it much simpler */
-#ifdef CONFIG_X86_32
-#define PVOP_CALL4(rettype, op, arg1, arg2, arg3, arg4)			\
-	__PVOP_CALL(rettype, op,					\
-		    "push %[_arg4];", "lea 4(%%esp),%%esp;",		\
-		    PVOP_CALL_ARG1(arg1), PVOP_CALL_ARG2(arg2),		\
-		    PVOP_CALL_ARG3(arg3), [_arg4] "mr" ((u32)(arg4)))
-#define PVOP_VCALL4(op, arg1, arg2, arg3, arg4)				\
-	__PVOP_VCALL(op,						\
-		    "push %[_arg4];", "lea 4(%%esp),%%esp;",		\
-		    "0" ((u32)(arg1)), "1" ((u32)(arg2)),		\
-		    "2" ((u32)(arg3)), [_arg4] "mr" ((u32)(arg4)))
-#else
-#define PVOP_CALL4(rettype, op, arg1, arg2, arg3, arg4)			\
-	__PVOP_CALL(rettype, op, "", "",				\
-		    PVOP_CALL_ARG1(arg1), PVOP_CALL_ARG2(arg2),		\
-		    PVOP_CALL_ARG3(arg3), PVOP_CALL_ARG4(arg4))
-#define PVOP_VCALL4(op, arg1, arg2, arg3, arg4)				\
-	__PVOP_VCALL(op, "", "",					\
-		     PVOP_CALL_ARG1(arg1), PVOP_CALL_ARG2(arg2),	\
-		     PVOP_CALL_ARG3(arg3), PVOP_CALL_ARG4(arg4))
-#endif
 
 static inline int paravirt_enabled(void)
 {
@@ -820,15 +142,22 @@ static inline u64 paravirt_read_msr(unsigned msr, int *err)
 {
 	return PVOP_CALL2(u64, pv_cpu_ops.read_msr, msr, err);
 }
-static inline u64 paravirt_read_msr_amd(unsigned msr, int *err)
+
+static inline int paravirt_rdmsr_regs(u32 *regs)
 {
-	return PVOP_CALL2(u64, pv_cpu_ops.read_msr_amd, msr, err);
+	return PVOP_CALL1(int, pv_cpu_ops.rdmsr_regs, regs);
 }
+
 static inline int paravirt_write_msr(unsigned msr, unsigned low, unsigned high)
 {
 	return PVOP_CALL3(int, pv_cpu_ops.write_msr, msr, low, high);
 }
 
+static inline int paravirt_wrmsr_regs(u32 *regs)
+{
+	return PVOP_CALL1(int, pv_cpu_ops.wrmsr_regs, regs);
+}
+
 /* These should all do BUG_ON(_err), but our headers are too tangled. */
 #define rdmsr(msr, val1, val2)			\
 do {						\
@@ -862,6 +191,9 @@ do {						\
 	_err;					\
 })
 
+#define rdmsr_safe_regs(regs)	paravirt_rdmsr_regs(regs)
+#define wrmsr_safe_regs(regs)	paravirt_wrmsr_regs(regs)
+
 static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
 {
 	int err;
@@ -871,12 +203,31 @@ static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
 }
 static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
 {
+	u32 gprs[8] = { 0 };
 	int err;
 
-	*p = paravirt_read_msr_amd(msr, &err);
+	gprs[1] = msr;
+	gprs[7] = 0x9c5a203a;
+
+	err = paravirt_rdmsr_regs(gprs);
+
+	*p = gprs[0] | ((u64)gprs[2] << 32);
+
 	return err;
 }
 
+static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
+{
+	u32 gprs[8] = { 0 };
+
+	gprs[0] = (u32)val;
+	gprs[1] = msr;
+	gprs[2] = val >> 32;
+	gprs[7] = 0x9c5a203a;
+
+	return paravirt_wrmsr_regs(gprs);
+}
+
 static inline u64 paravirt_read_tsc(void)
 {
 	return PVOP_CALL0(u64, pv_cpu_ops.read_tsc);
@@ -1393,20 +744,6 @@ static inline void pmd_clear(pmd_t *pmdp)
 }
 #endif	/* CONFIG_X86_PAE */
 
-/* Lazy mode for batching updates / context switch */
-enum paravirt_lazy_mode {
-	PARAVIRT_LAZY_NONE,
-	PARAVIRT_LAZY_MMU,
-	PARAVIRT_LAZY_CPU,
-};
-
-enum paravirt_lazy_mode paravirt_get_lazy_mode(void);
-void paravirt_start_context_switch(struct task_struct *prev);
-void paravirt_end_context_switch(struct task_struct *next);
-
-void paravirt_enter_lazy_mmu(void);
-void paravirt_leave_lazy_mmu(void);
-
 #define  __HAVE_ARCH_START_CONTEXT_SWITCH
 static inline void arch_start_context_switch(struct task_struct *prev)
 {
@@ -1437,12 +774,6 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 	pv_mmu_ops.set_fixmap(idx, phys, flags);
 }
 
-void _paravirt_nop(void);
-u32 _paravirt_ident_32(u32);
-u64 _paravirt_ident_64(u64);
-
-#define paravirt_nop	((void *)_paravirt_nop)
-
 #if defined(CONFIG_SMP) && defined(CONFIG_PARAVIRT_SPINLOCKS)
 
 static inline int __raw_spin_is_locked(struct raw_spinlock *lock)
@@ -1479,17 +810,6 @@ static __always_inline void __raw_spin_unlock(struct raw_spinlock *lock)
 
 #endif
 
-/* These all sit in the .parainstructions section to tell us what to patch. */
-struct paravirt_patch_site {
-	u8 *instr; 		/* original instructions */
-	u8 instrtype;		/* type of this instruction */
-	u8 len;			/* length of original instruction */
-	u16 clobbers;		/* what registers you may clobber */
-};
-
-extern struct paravirt_patch_site __parainstructions[],
-	__parainstructions_end[];
-
 #ifdef CONFIG_X86_32
 #define PV_SAVE_REGS "pushl %ecx; pushl %edx;"
 #define PV_RESTORE_REGS "popl %edx; popl %ecx;"
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
new file mode 100644
index 0000000..25402d0
--- /dev/null
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -0,0 +1,721 @@
+#ifndef _ASM_X86_PARAVIRT_TYPES_H
+#define _ASM_X86_PARAVIRT_TYPES_H
+
+/* Bitmask of what can be clobbered: usually at least eax. */
+#define CLBR_NONE 0
+#define CLBR_EAX  (1 << 0)
+#define CLBR_ECX  (1 << 1)
+#define CLBR_EDX  (1 << 2)
+#define CLBR_EDI  (1 << 3)
+
+#ifdef CONFIG_X86_32
+/* CLBR_ANY should match all regs platform has. For i386, that's just it */
+#define CLBR_ANY  ((1 << 4) - 1)
+
+#define CLBR_ARG_REGS	(CLBR_EAX | CLBR_EDX | CLBR_ECX)
+#define CLBR_RET_REG	(CLBR_EAX | CLBR_EDX)
+#define CLBR_SCRATCH	(0)
+#else
+#define CLBR_RAX  CLBR_EAX
+#define CLBR_RCX  CLBR_ECX
+#define CLBR_RDX  CLBR_EDX
+#define CLBR_RDI  CLBR_EDI
+#define CLBR_RSI  (1 << 4)
+#define CLBR_R8   (1 << 5)
+#define CLBR_R9   (1 << 6)
+#define CLBR_R10  (1 << 7)
+#define CLBR_R11  (1 << 8)
+
+#define CLBR_ANY  ((1 << 9) - 1)
+
+#define CLBR_ARG_REGS	(CLBR_RDI | CLBR_RSI | CLBR_RDX | \
+			 CLBR_RCX | CLBR_R8 | CLBR_R9)
+#define CLBR_RET_REG	(CLBR_RAX)
+#define CLBR_SCRATCH	(CLBR_R10 | CLBR_R11)
+
+#endif /* X86_64 */
+
+#define CLBR_CALLEE_SAVE ((CLBR_ARG_REGS | CLBR_SCRATCH) & ~CLBR_RET_REG)
+
+#ifndef __ASSEMBLY__
+
+#include <asm/desc_defs.h>
+#include <asm/kmap_types.h>
+
+struct page;
+struct thread_struct;
+struct desc_ptr;
+struct tss_struct;
+struct mm_struct;
+struct desc_struct;
+struct task_struct;
+struct cpumask;
+
+/*
+ * Wrapper type for pointers to code which uses the non-standard
+ * calling convention.  See PV_CALL_SAVE_REGS_THUNK below.
+ */
+struct paravirt_callee_save {
+	void *func;
+};
+
+/* general info */
+struct pv_info {
+	unsigned int kernel_rpl;
+	int shared_kernel_pmd;
+	int paravirt_enabled;
+	const char *name;
+};
+
+struct pv_init_ops {
+	/*
+	 * Patch may replace one of the defined code sequences with
+	 * arbitrary code, subject to the same register constraints.
+	 * This generally means the code is not free to clobber any
+	 * registers other than EAX.  The patch function should return
+	 * the number of bytes of code generated, as we nop pad the
+	 * rest in generic code.
+	 */
+	unsigned (*patch)(u8 type, u16 clobber, void *insnbuf,
+			  unsigned long addr, unsigned len);
+
+	/* Basic arch-specific setup */
+	void (*arch_setup)(void);
+	char *(*memory_setup)(void);
+	void (*post_allocator_init)(void);
+
+	/* Print a banner to identify the environment */
+	void (*banner)(void);
+};
+
+
+struct pv_lazy_ops {
+	/* Set deferred update mode, used for batching operations. */
+	void (*enter)(void);
+	void (*leave)(void);
+};
+
+struct pv_time_ops {
+	void (*time_init)(void);
+
+	/* Set and set time of day */
+	unsigned long (*get_wallclock)(void);
+	int (*set_wallclock)(unsigned long);
+
+	unsigned long long (*sched_clock)(void);
+	unsigned long (*get_tsc_khz)(void);
+};
+
+struct pv_cpu_ops {
+	/* hooks for various privileged instructions */
+	unsigned long (*get_debugreg)(int regno);
+	void (*set_debugreg)(int regno, unsigned long value);
+
+	void (*clts)(void);
+
+	unsigned long (*read_cr0)(void);
+	void (*write_cr0)(unsigned long);
+
+	unsigned long (*read_cr4_safe)(void);
+	unsigned long (*read_cr4)(void);
+	void (*write_cr4)(unsigned long);
+
+#ifdef CONFIG_X86_64
+	unsigned long (*read_cr8)(void);
+	void (*write_cr8)(unsigned long);
+#endif
+
+	/* Segment descriptor handling */
+	void (*load_tr_desc)(void);
+	void (*load_gdt)(const struct desc_ptr *);
+	void (*load_idt)(const struct desc_ptr *);
+	void (*store_gdt)(struct desc_ptr *);
+	void (*store_idt)(struct desc_ptr *);
+	void (*set_ldt)(const void *desc, unsigned entries);
+	unsigned long (*store_tr)(void);
+	void (*load_tls)(struct thread_struct *t, unsigned int cpu);
+#ifdef CONFIG_X86_64
+	void (*load_gs_index)(unsigned int idx);
+#endif
+	void (*write_ldt_entry)(struct desc_struct *ldt, int entrynum,
+				const void *desc);
+	void (*write_gdt_entry)(struct desc_struct *,
+				int entrynum, const void *desc, int size);
+	void (*write_idt_entry)(gate_desc *,
+				int entrynum, const gate_desc *gate);
+	void (*alloc_ldt)(struct desc_struct *ldt, unsigned entries);
+	void (*free_ldt)(struct desc_struct *ldt, unsigned entries);
+
+	void (*load_sp0)(struct tss_struct *tss, struct thread_struct *t);
+
+	void (*set_iopl_mask)(unsigned mask);
+
+	void (*wbinvd)(void);
+	void (*io_delay)(void);
+
+	/* cpuid emulation, mostly so that caps bits can be disabled */
+	void (*cpuid)(unsigned int *eax, unsigned int *ebx,
+		      unsigned int *ecx, unsigned int *edx);
+
+	/* MSR, PMC and TSR operations.
+	   err = 0/-EFAULT.  wrmsr returns 0/-EFAULT. */
+	u64 (*read_msr)(unsigned int msr, int *err);
+	int (*rdmsr_regs)(u32 *regs);
+	int (*write_msr)(unsigned int msr, unsigned low, unsigned high);
+	int (*wrmsr_regs)(u32 *regs);
+
+	u64 (*read_tsc)(void);
+	u64 (*read_pmc)(int counter);
+	unsigned long long (*read_tscp)(unsigned int *aux);
+
+	/*
+	 * Atomically enable interrupts and return to userspace.  This
+	 * is only ever used to return to 32-bit processes; in a
+	 * 64-bit kernel, it's used for 32-on-64 compat processes, but
+	 * never native 64-bit processes.  (Jump, not call.)
+	 */
+	void (*irq_enable_sysexit)(void);
+
+	/*
+	 * Switch to usermode gs and return to 64-bit usermode using
+	 * sysret.  Only used in 64-bit kernels to return to 64-bit
+	 * processes.  Usermode register state, including %rsp, must
+	 * already be restored.
+	 */
+	void (*usergs_sysret64)(void);
+
+	/*
+	 * Switch to usermode gs and return to 32-bit usermode using
+	 * sysret.  Used to return to 32-on-64 compat processes.
+	 * Other usermode register state, including %esp, must already
+	 * be restored.
+	 */
+	void (*usergs_sysret32)(void);
+
+	/* Normal iret.  Jump to this with the standard iret stack
+	   frame set up. */
+	void (*iret)(void);
+
+	void (*swapgs)(void);
+
+	void (*start_context_switch)(struct task_struct *prev);
+	void (*end_context_switch)(struct task_struct *next);
+};
+
+struct pv_irq_ops {
+	void (*init_IRQ)(void);
+
+	/*
+	 * Get/set interrupt state.  save_fl and restore_fl are only
+	 * expected to use X86_EFLAGS_IF; all other bits
+	 * returned from save_fl are undefined, and may be ignored by
+	 * restore_fl.
+	 *
+	 * NOTE: These functions callers expect the callee to preserve
+	 * more registers than the standard C calling convention.
+	 */
+	struct paravirt_callee_save save_fl;
+	struct paravirt_callee_save restore_fl;
+	struct paravirt_callee_save irq_disable;
+	struct paravirt_callee_save irq_enable;
+
+	void (*safe_halt)(void);
+	void (*halt)(void);
+
+#ifdef CONFIG_X86_64
+	void (*adjust_exception_frame)(void);
+#endif
+};
+
+struct pv_apic_ops {
+#ifdef CONFIG_X86_LOCAL_APIC
+	void (*setup_boot_clock)(void);
+	void (*setup_secondary_clock)(void);
+
+	void (*startup_ipi_hook)(int phys_apicid,
+				 unsigned long start_eip,
+				 unsigned long start_esp);
+#endif
+};
+
+struct pv_mmu_ops {
+	/*
+	 * Called before/after init_mm pagetable setup. setup_start
+	 * may reset %cr3, and may pre-install parts of the pagetable;
+	 * pagetable setup is expected to preserve any existing
+	 * mapping.
+	 */
+	void (*pagetable_setup_start)(pgd_t *pgd_base);
+	void (*pagetable_setup_done)(pgd_t *pgd_base);
+
+	unsigned long (*read_cr2)(void);
+	void (*write_cr2)(unsigned long);
+
+	unsigned long (*read_cr3)(void);
+	void (*write_cr3)(unsigned long);
+
+	/*
+	 * Hooks for intercepting the creation/use/destruction of an
+	 * mm_struct.
+	 */
+	void (*activate_mm)(struct mm_struct *prev,
+			    struct mm_struct *next);
+	void (*dup_mmap)(struct mm_struct *oldmm,
+			 struct mm_struct *mm);
+	void (*exit_mmap)(struct mm_struct *mm);
+
+
+	/* TLB operations */
+	void (*flush_tlb_user)(void);
+	void (*flush_tlb_kernel)(void);
+	void (*flush_tlb_single)(unsigned long addr);
+	void (*flush_tlb_others)(const struct cpumask *cpus,
+				 struct mm_struct *mm,
+				 unsigned long va);
+
+	/* Hooks for allocating and freeing a pagetable top-level */
+	int  (*pgd_alloc)(struct mm_struct *mm);
+	void (*pgd_free)(struct mm_struct *mm, pgd_t *pgd);
+
+	/*
+	 * Hooks for allocating/releasing pagetable pages when they're
+	 * attached to a pagetable
+	 */
+	void (*alloc_pte)(struct mm_struct *mm, unsigned long pfn);
+	void (*alloc_pmd)(struct mm_struct *mm, unsigned long pfn);
+	void (*alloc_pmd_clone)(unsigned long pfn, unsigned long clonepfn, unsigned long start, unsigned long count);
+	void (*alloc_pud)(struct mm_struct *mm, unsigned long pfn);
+	void (*release_pte)(unsigned long pfn);
+	void (*release_pmd)(unsigned long pfn);
+	void (*release_pud)(unsigned long pfn);
+
+	/* Pagetable manipulation functions */
+	void (*set_pte)(pte_t *ptep, pte_t pteval);
+	void (*set_pte_at)(struct mm_struct *mm, unsigned long addr,
+			   pte_t *ptep, pte_t pteval);
+	void (*set_pmd)(pmd_t *pmdp, pmd_t pmdval);
+	void (*pte_update)(struct mm_struct *mm, unsigned long addr,
+			   pte_t *ptep);
+	void (*pte_update_defer)(struct mm_struct *mm,
+				 unsigned long addr, pte_t *ptep);
+
+	pte_t (*ptep_modify_prot_start)(struct mm_struct *mm, unsigned long addr,
+					pte_t *ptep);
+	void (*ptep_modify_prot_commit)(struct mm_struct *mm, unsigned long addr,
+					pte_t *ptep, pte_t pte);
+
+	struct paravirt_callee_save pte_val;
+	struct paravirt_callee_save make_pte;
+
+	struct paravirt_callee_save pgd_val;
+	struct paravirt_callee_save make_pgd;
+
+#if PAGETABLE_LEVELS >= 3
+#ifdef CONFIG_X86_PAE
+	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
+	void (*pte_clear)(struct mm_struct *mm, unsigned long addr,
+			  pte_t *ptep);
+	void (*pmd_clear)(pmd_t *pmdp);
+
+#endif	/* CONFIG_X86_PAE */
+
+	void (*set_pud)(pud_t *pudp, pud_t pudval);
+
+	struct paravirt_callee_save pmd_val;
+	struct paravirt_callee_save make_pmd;
+
+#if PAGETABLE_LEVELS == 4
+	struct paravirt_callee_save pud_val;
+	struct paravirt_callee_save make_pud;
+
+	void (*set_pgd)(pgd_t *pudp, pgd_t pgdval);
+#endif	/* PAGETABLE_LEVELS == 4 */
+#endif	/* PAGETABLE_LEVELS >= 3 */
+
+#ifdef CONFIG_HIGHPTE
+	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
+#endif
+
+	struct pv_lazy_ops lazy_mode;
+
+	/* dom0 ops */
+
+	/* Sometimes the physical address is a pfn, and sometimes its
+	   an mfn.  We can tell which is which from the index. */
+	void (*set_fixmap)(unsigned /* enum fixed_addresses */ idx,
+			   phys_addr_t phys, pgprot_t flags);
+};
+
+struct raw_spinlock;
+struct pv_lock_ops {
+	int (*spin_is_locked)(struct raw_spinlock *lock);
+	int (*spin_is_contended)(struct raw_spinlock *lock);
+	void (*spin_lock)(struct raw_spinlock *lock);
+	void (*spin_lock_flags)(struct raw_spinlock *lock, unsigned long flags);
+	int (*spin_trylock)(struct raw_spinlock *lock);
+	void (*spin_unlock)(struct raw_spinlock *lock);
+};
+
+/* This contains all the paravirt structures: we get a convenient
+ * number for each function using the offset which we use to indicate
+ * what to patch. */
+struct paravirt_patch_template {
+	struct pv_init_ops pv_init_ops;
+	struct pv_time_ops pv_time_ops;
+	struct pv_cpu_ops pv_cpu_ops;
+	struct pv_irq_ops pv_irq_ops;
+	struct pv_apic_ops pv_apic_ops;
+	struct pv_mmu_ops pv_mmu_ops;
+	struct pv_lock_ops pv_lock_ops;
+};
+
+extern struct pv_info pv_info;
+extern struct pv_init_ops pv_init_ops;
+extern struct pv_time_ops pv_time_ops;
+extern struct pv_cpu_ops pv_cpu_ops;
+extern struct pv_irq_ops pv_irq_ops;
+extern struct pv_apic_ops pv_apic_ops;
+extern struct pv_mmu_ops pv_mmu_ops;
+extern struct pv_lock_ops pv_lock_ops;
+
+#define PARAVIRT_PATCH(x)					\
+	(offsetof(struct paravirt_patch_template, x) / sizeof(void *))
+
+#define paravirt_type(op)				\
+	[paravirt_typenum] "i" (PARAVIRT_PATCH(op)),	\
+	[paravirt_opptr] "i" (&(op))
+#define paravirt_clobber(clobber)		\
+	[paravirt_clobber] "i" (clobber)
+
+/*
+ * Generate some code, and mark it as patchable by the
+ * apply_paravirt() alternate instruction patcher.
+ */
+#define _paravirt_alt(insn_string, type, clobber)	\
+	"771:\n\t" insn_string "\n" "772:\n"		\
+	".pushsection .parainstructions,\"a\"\n"	\
+	_ASM_ALIGN "\n"					\
+	_ASM_PTR " 771b\n"				\
+	"  .byte " type "\n"				\
+	"  .byte 772b-771b\n"				\
+	"  .short " clobber "\n"			\
+	".popsection\n"
+
+/* Generate patchable code, with the default asm parameters. */
+#define paravirt_alt(insn_string)					\
+	_paravirt_alt(insn_string, "%c[paravirt_typenum]", "%c[paravirt_clobber]")
+
+/* Simple instruction patching code. */
+#define DEF_NATIVE(ops, name, code) 					\
+	extern const char start_##ops##_##name[], end_##ops##_##name[];	\
+	asm("start_" #ops "_" #name ": " code "; end_" #ops "_" #name ":")
+
+unsigned paravirt_patch_nop(void);
+unsigned paravirt_patch_ident_32(void *insnbuf, unsigned len);
+unsigned paravirt_patch_ident_64(void *insnbuf, unsigned len);
+unsigned paravirt_patch_ignore(unsigned len);
+unsigned paravirt_patch_call(void *insnbuf,
+			     const void *target, u16 tgt_clobbers,
+			     unsigned long addr, u16 site_clobbers,
+			     unsigned len);
+unsigned paravirt_patch_jmp(void *insnbuf, const void *target,
+			    unsigned long addr, unsigned len);
+unsigned paravirt_patch_default(u8 type, u16 clobbers, void *insnbuf,
+				unsigned long addr, unsigned len);
+
+unsigned paravirt_patch_insns(void *insnbuf, unsigned len,
+			      const char *start, const char *end);
+
+unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
+		      unsigned long addr, unsigned len);
+
+int paravirt_disable_iospace(void);
+
+/*
+ * This generates an indirect call based on the operation type number.
+ * The type number, computed in PARAVIRT_PATCH, is derived from the
+ * offset into the paravirt_patch_template structure, and can therefore be
+ * freely converted back into a structure offset.
+ */
+#define PARAVIRT_CALL	"call *%c[paravirt_opptr];"
+
+/*
+ * These macros are intended to wrap calls through one of the paravirt
+ * ops structs, so that they can be later identified and patched at
+ * runtime.
+ *
+ * Normally, a call to a pv_op function is a simple indirect call:
+ * (pv_op_struct.operations)(args...).
+ *
+ * Unfortunately, this is a relatively slow operation for modern CPUs,
+ * because it cannot necessarily determine what the destination
+ * address is.  In this case, the address is a runtime constant, so at
+ * the very least we can patch the call to e a simple direct call, or
+ * ideally, patch an inline implementation into the callsite.  (Direct
+ * calls are essentially free, because the call and return addresses
+ * are completely predictable.)
+ *
+ * For i386, these macros rely on the standard gcc "regparm(3)" calling
+ * convention, in which the first three arguments are placed in %eax,
+ * %edx, %ecx (in that order), and the remaining arguments are placed
+ * on the stack.  All caller-save registers (eax,edx,ecx) are expected
+ * to be modified (either clobbered or used for return values).
+ * X86_64, on the other hand, already specifies a register-based calling
+ * conventions, returning at %rax, with parameteres going on %rdi, %rsi,
+ * %rdx, and %rcx. Note that for this reason, x86_64 does not need any
+ * special handling for dealing with 4 arguments, unlike i386.
+ * However, x86_64 also have to clobber all caller saved registers, which
+ * unfortunately, are quite a bit (r8 - r11)
+ *
+ * The call instruction itself is marked by placing its start address
+ * and size into the .parainstructions section, so that
+ * apply_paravirt() in arch/i386/kernel/alternative.c can do the
+ * appropriate patching under the control of the backend pv_init_ops
+ * implementation.
+ *
+ * Unfortunately there's no way to get gcc to generate the args setup
+ * for the call, and then allow the call itself to be generated by an
+ * inline asm.  Because of this, we must do the complete arg setup and
+ * return value handling from within these macros.  This is fairly
+ * cumbersome.
+ *
+ * There are 5 sets of PVOP_* macros for dealing with 0-4 arguments.
+ * It could be extended to more arguments, but there would be little
+ * to be gained from that.  For each number of arguments, there are
+ * the two VCALL and CALL variants for void and non-void functions.
+ *
+ * When there is a return value, the invoker of the macro must specify
+ * the return type.  The macro then uses sizeof() on that type to
+ * determine whether its a 32 or 64 bit value, and places the return
+ * in the right register(s) (just %eax for 32-bit, and %edx:%eax for
+ * 64-bit). For x86_64 machines, it just returns at %rax regardless of
+ * the return value size.
+ *
+ * 64-bit arguments are passed as a pair of adjacent 32-bit arguments
+ * i386 also passes 64-bit arguments as a pair of adjacent 32-bit arguments
+ * in low,high order
+ *
+ * Small structures are passed and returned in registers.  The macro
+ * calling convention can't directly deal with this, so the wrapper
+ * functions must do this.
+ *
+ * These PVOP_* macros are only defined within this header.  This
+ * means that all uses must be wrapped in inline functions.  This also
+ * makes sure the incoming and outgoing types are always correct.
+ */
+#ifdef CONFIG_X86_32
+#define PVOP_VCALL_ARGS				\
+	unsigned long __eax = __eax, __edx = __edx, __ecx = __ecx
+#define PVOP_CALL_ARGS			PVOP_VCALL_ARGS
+
+#define PVOP_CALL_ARG1(x)		"a" ((unsigned long)(x))
+#define PVOP_CALL_ARG2(x)		"d" ((unsigned long)(x))
+#define PVOP_CALL_ARG3(x)		"c" ((unsigned long)(x))
+
+#define PVOP_VCALL_CLOBBERS		"=a" (__eax), "=d" (__edx),	\
+					"=c" (__ecx)
+#define PVOP_CALL_CLOBBERS		PVOP_VCALL_CLOBBERS
+
+#define PVOP_VCALLEE_CLOBBERS		"=a" (__eax), "=d" (__edx)
+#define PVOP_CALLEE_CLOBBERS		PVOP_VCALLEE_CLOBBERS
+
+#define EXTRA_CLOBBERS
+#define VEXTRA_CLOBBERS
+#else  /* CONFIG_X86_64 */
+#define PVOP_VCALL_ARGS					\
+	unsigned long __edi = __edi, __esi = __esi,	\
+		__edx = __edx, __ecx = __ecx
+#define PVOP_CALL_ARGS		PVOP_VCALL_ARGS, __eax
+
+#define PVOP_CALL_ARG1(x)		"D" ((unsigned long)(x))
+#define PVOP_CALL_ARG2(x)		"S" ((unsigned long)(x))
+#define PVOP_CALL_ARG3(x)		"d" ((unsigned long)(x))
+#define PVOP_CALL_ARG4(x)		"c" ((unsigned long)(x))
+
+#define PVOP_VCALL_CLOBBERS	"=D" (__edi),				\
+				"=S" (__esi), "=d" (__edx),		\
+				"=c" (__ecx)
+#define PVOP_CALL_CLOBBERS	PVOP_VCALL_CLOBBERS, "=a" (__eax)
+
+#define PVOP_VCALLEE_CLOBBERS	"=a" (__eax)
+#define PVOP_CALLEE_CLOBBERS	PVOP_VCALLEE_CLOBBERS
+
+#define EXTRA_CLOBBERS	 , "r8", "r9", "r10", "r11"
+#define VEXTRA_CLOBBERS	 , "rax", "r8", "r9", "r10", "r11"
+#endif	/* CONFIG_X86_32 */
+
+#ifdef CONFIG_PARAVIRT_DEBUG
+#define PVOP_TEST_NULL(op)	BUG_ON(op == NULL)
+#else
+#define PVOP_TEST_NULL(op)	((void)op)
+#endif
+
+#define ____PVOP_CALL(rettype, op, clbr, call_clbr, extra_clbr,		\
+		      pre, post, ...)					\
+	({								\
+		rettype __ret;						\
+		PVOP_CALL_ARGS;						\
+		PVOP_TEST_NULL(op);					\
+		/* This is 32-bit specific, but is okay in 64-bit */	\
+		/* since this condition will never hold */		\
+		if (sizeof(rettype) > sizeof(unsigned long)) {		\
+			asm volatile(pre				\
+				     paravirt_alt(PARAVIRT_CALL)	\
+				     post				\
+				     : call_clbr			\
+				     : paravirt_type(op),		\
+				       paravirt_clobber(clbr),		\
+				       ##__VA_ARGS__			\
+				     : "memory", "cc" extra_clbr);	\
+			__ret = (rettype)((((u64)__edx) << 32) | __eax); \
+		} else {						\
+			asm volatile(pre				\
+				     paravirt_alt(PARAVIRT_CALL)	\
+				     post				\
+				     : call_clbr			\
+				     : paravirt_type(op),		\
+				       paravirt_clobber(clbr),		\
+				       ##__VA_ARGS__			\
+				     : "memory", "cc" extra_clbr);	\
+			__ret = (rettype)__eax;				\
+		}							\
+		__ret;							\
+	})
+
+#define __PVOP_CALL(rettype, op, pre, post, ...)			\
+	____PVOP_CALL(rettype, op, CLBR_ANY, PVOP_CALL_CLOBBERS,	\
+		      EXTRA_CLOBBERS, pre, post, ##__VA_ARGS__)
+
+#define __PVOP_CALLEESAVE(rettype, op, pre, post, ...)			\
+	____PVOP_CALL(rettype, op.func, CLBR_RET_REG,			\
+		      PVOP_CALLEE_CLOBBERS, ,				\
+		      pre, post, ##__VA_ARGS__)
+
+
+#define ____PVOP_VCALL(op, clbr, call_clbr, extra_clbr, pre, post, ...)	\
+	({								\
+		PVOP_VCALL_ARGS;					\
+		PVOP_TEST_NULL(op);					\
+		asm volatile(pre					\
+			     paravirt_alt(PARAVIRT_CALL)		\
+			     post					\
+			     : call_clbr				\
+			     : paravirt_type(op),			\
+			       paravirt_clobber(clbr),			\
+			       ##__VA_ARGS__				\
+			     : "memory", "cc" extra_clbr);		\
+	})
+
+#define __PVOP_VCALL(op, pre, post, ...)				\
+	____PVOP_VCALL(op, CLBR_ANY, PVOP_VCALL_CLOBBERS,		\
+		       VEXTRA_CLOBBERS,					\
+		       pre, post, ##__VA_ARGS__)
+
+#define __PVOP_VCALLEESAVE(rettype, op, pre, post, ...)			\
+	____PVOP_CALL(rettype, op.func, CLBR_RET_REG,			\
+		      PVOP_VCALLEE_CLOBBERS, ,				\
+		      pre, post, ##__VA_ARGS__)
+
+
+
+#define PVOP_CALL0(rettype, op)						\
+	__PVOP_CALL(rettype, op, "", "")
+#define PVOP_VCALL0(op)							\
+	__PVOP_VCALL(op, "", "")
+
+#define PVOP_CALLEE0(rettype, op)					\
+	__PVOP_CALLEESAVE(rettype, op, "", "")
+#define PVOP_VCALLEE0(op)						\
+	__PVOP_VCALLEESAVE(op, "", "")
+
+
+#define PVOP_CALL1(rettype, op, arg1)					\
+	__PVOP_CALL(rettype, op, "", "", PVOP_CALL_ARG1(arg1))
+#define PVOP_VCALL1(op, arg1)						\
+	__PVOP_VCALL(op, "", "", PVOP_CALL_ARG1(arg1))
+
+#define PVOP_CALLEE1(rettype, op, arg1)					\
+	__PVOP_CALLEESAVE(rettype, op, "", "", PVOP_CALL_ARG1(arg1))
+#define PVOP_VCALLEE1(op, arg1)						\
+	__PVOP_VCALLEESAVE(op, "", "", PVOP_CALL_ARG1(arg1))
+
+
+#define PVOP_CALL2(rettype, op, arg1, arg2)				\
+	__PVOP_CALL(rettype, op, "", "", PVOP_CALL_ARG1(arg1),		\
+		    PVOP_CALL_ARG2(arg2))
+#define PVOP_VCALL2(op, arg1, arg2)					\
+	__PVOP_VCALL(op, "", "", PVOP_CALL_ARG1(arg1),			\
+		     PVOP_CALL_ARG2(arg2))
+
+#define PVOP_CALLEE2(rettype, op, arg1, arg2)				\
+	__PVOP_CALLEESAVE(rettype, op, "", "", PVOP_CALL_ARG1(arg1),	\
+			  PVOP_CALL_ARG2(arg2))
+#define PVOP_VCALLEE2(op, arg1, arg2)					\
+	__PVOP_VCALLEESAVE(op, "", "", PVOP_CALL_ARG1(arg1),		\
+			   PVOP_CALL_ARG2(arg2))
+
+
+#define PVOP_CALL3(rettype, op, arg1, arg2, arg3)			\
+	__PVOP_CALL(rettype, op, "", "", PVOP_CALL_ARG1(arg1),		\
+		    PVOP_CALL_ARG2(arg2), PVOP_CALL_ARG3(arg3))
+#define PVOP_VCALL3(op, arg1, arg2, arg3)				\
+	__PVOP_VCALL(op, "", "", PVOP_CALL_ARG1(arg1),			\
+		     PVOP_CALL_ARG2(arg2), PVOP_CALL_ARG3(arg3))
+
+/* This is the only difference in x86_64. We can make it much simpler */
+#ifdef CONFIG_X86_32
+#define PVOP_CALL4(rettype, op, arg1, arg2, arg3, arg4)			\
+	__PVOP_CALL(rettype, op,					\
+		    "push %[_arg4];", "lea 4(%%esp),%%esp;",		\
+		    PVOP_CALL_ARG1(arg1), PVOP_CALL_ARG2(arg2),		\
+		    PVOP_CALL_ARG3(arg3), [_arg4] "mr" ((u32)(arg4)))
+#define PVOP_VCALL4(op, arg1, arg2, arg3, arg4)				\
+	__PVOP_VCALL(op,						\
+		    "push %[_arg4];", "lea 4(%%esp),%%esp;",		\
+		    "0" ((u32)(arg1)), "1" ((u32)(arg2)),		\
+		    "2" ((u32)(arg3)), [_arg4] "mr" ((u32)(arg4)))
+#else
+#define PVOP_CALL4(rettype, op, arg1, arg2, arg3, arg4)			\
+	__PVOP_CALL(rettype, op, "", "",				\
+		    PVOP_CALL_ARG1(arg1), PVOP_CALL_ARG2(arg2),		\
+		    PVOP_CALL_ARG3(arg3), PVOP_CALL_ARG4(arg4))
+#define PVOP_VCALL4(op, arg1, arg2, arg3, arg4)				\
+	__PVOP_VCALL(op, "", "",					\
+		     PVOP_CALL_ARG1(arg1), PVOP_CALL_ARG2(arg2),	\
+		     PVOP_CALL_ARG3(arg3), PVOP_CALL_ARG4(arg4))
+#endif
+
+/* Lazy mode for batching updates / context switch */
+enum paravirt_lazy_mode {
+	PARAVIRT_LAZY_NONE,
+	PARAVIRT_LAZY_MMU,
+	PARAVIRT_LAZY_CPU,
+};
+
+enum paravirt_lazy_mode paravirt_get_lazy_mode(void);
+void paravirt_start_context_switch(struct task_struct *prev);
+void paravirt_end_context_switch(struct task_struct *next);
+
+void paravirt_enter_lazy_mmu(void);
+void paravirt_leave_lazy_mmu(void);
+
+void _paravirt_nop(void);
+u32 _paravirt_ident_32(u32);
+u64 _paravirt_ident_64(u64);
+
+#define paravirt_nop	((void *)_paravirt_nop)
+
+/* These all sit in the .parainstructions section to tell us what to patch. */
+struct paravirt_patch_site {
+	u8 *instr; 		/* original instructions */
+	u8 instrtype;		/* type of this instruction */
+	u8 len;			/* length of original instruction */
+	u16 clobbers;		/* what registers you may clobber */
+};
+
+extern struct paravirt_patch_site __parainstructions[],
+	__parainstructions_end[];
+
+#endif	/* __ASSEMBLY__ */
+
+#endif	/* _ASM_X86_PARAVIRT_TYPES_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c776826..2db56c5 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -703,13 +703,23 @@ static inline void cpu_relax(void)
 	rep_nop();
 }
 
-/* Stop speculative execution: */
+/* Stop speculative execution and prefetching of modified code. */
 static inline void sync_core(void)
 {
 	int tmp;
 
-	asm volatile("cpuid" : "=a" (tmp) : "0" (1)
-		     : "ebx", "ecx", "edx", "memory");
+#if defined(CONFIG_M386) || defined(CONFIG_M486)
+	if (boot_cpu_data.x86 < 5)
+		/* There is no speculative execution.
+		 * jmp is a barrier to prefetching. */
+		asm volatile("jmp 1f\n1:\n" ::: "memory");
+	else
+#endif
+		/* cpuid is a barrier to speculative execution.
+		 * Prefetched instructions are automatically
+		 * invalidated when modified. */
+		asm volatile("cpuid" : "=a" (tmp) : "0" (1)
+			     : "ebx", "ecx", "edx", "memory");
 }
 
 static inline void __monitor(const void *eax, unsigned long ecx,
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index f576587..b8ebd0b 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -490,8 +490,8 @@ void *text_poke_early(void *addr, const void *opcode, size_t len)
 	unsigned long flags;
 	local_irq_save(flags);
 	memcpy(addr, opcode, len);
-	local_irq_restore(flags);
 	sync_core();
+	local_irq_restore(flags);
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
 	return addr;
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 63fddcd..e1600c7 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -251,6 +251,64 @@ static int __cpuinit nearby_node(int apicid)
 #endif
 
 /*
+ * Fixup core topology information for AMD multi-node processors.
+ * Assumption 1: Number of cores in each internal node is the same.
+ * Assumption 2: Mixed systems with both single-node and dual-node
+ *               processors are not supported.
+ */
+#ifdef CONFIG_X86_HT
+static void __cpuinit amd_fixup_dcm(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_PCI
+	u32 t, cpn;
+	u8 n, n_id;
+	int cpu = smp_processor_id();
+
+	/* fixup topology information only once for a core */
+	if (cpu_has(c, X86_FEATURE_AMD_DCM))
+		return;
+
+	/* check for multi-node processor on boot cpu */
+	t = read_pci_config(0, 24, 3, 0xe8);
+	if (!(t & (1 << 29)))
+		return;
+
+	set_cpu_cap(c, X86_FEATURE_AMD_DCM);
+
+	/* cores per node: each internal node has half the number of cores */
+	cpn = c->x86_max_cores >> 1;
+
+	/* even-numbered NB_id of this dual-node processor */
+	n = c->phys_proc_id << 1;
+
+	/*
+	 * determine internal node id and assign cores fifty-fifty to
+	 * each node of the dual-node processor
+	 */
+	t = read_pci_config(0, 24 + n, 3, 0xe8);
+	n = (t>>30) & 0x3;
+	if (n == 0) {
+		if (c->cpu_core_id < cpn)
+			n_id = 0;
+		else
+			n_id = 1;
+	} else {
+		if (c->cpu_core_id < cpn)
+			n_id = 1;
+		else
+			n_id = 0;
+	}
+
+	/* compute entire NodeID, use llc_shared_map to store sibling info */
+	per_cpu(cpu_llc_id, cpu) = (c->phys_proc_id << 1) + n_id;
+
+	/* fixup core id to be in range from 0 to cpn */
+	c->cpu_core_id = c->cpu_core_id % cpn;
+#endif
+}
+#endif
+
+/*
  * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
  * Assumes number of cores is a power of two.
  */
@@ -267,6 +325,9 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 	c->phys_proc_id = c->initial_apicid >> bits;
 	/* use socket ID also for last level cache */
 	per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
+	/* fixup topology information on multi-node processors */
+	if ((c->x86 == 0x10) && (c->x86_model == 9))
+		amd_fixup_dcm(c);
 #endif
 }
 
@@ -275,9 +336,10 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	int cpu = smp_processor_id();
 	int node;
-	unsigned apicid = cpu_has_apic ? hard_smp_processor_id() : c->apicid;
+	unsigned apicid = c->apicid;
+
+	node = per_cpu(cpu_llc_id, cpu);
 
-	node = c->phys_proc_id;
 	if (apicid_to_node[apicid] != NUMA_NO_NODE)
 		node = apicid_to_node[apicid];
 	if (!node_online(node)) {
@@ -404,12 +466,24 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		/*
 		 * Some BIOSes incorrectly force this feature, but only K8
 		 * revision D (model = 0x14) and later actually support it.
+		 * (AMD Erratum #110, docId: 25759).
 		 */
-		if (c->x86_model < 0x14)
+		if (c->x86_model < 0x14 && cpu_has(c, X86_FEATURE_LAHF_LM)) {
+			u64 val;
+
 			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
+			if (!rdmsrl_amd_safe(0xc001100d, &val)) {
+				val &= ~(1ULL << 32);
+				wrmsrl_amd_safe(0xc001100d, val);
+			}
+		}
+
 	}
 	if (c->x86 == 0x10 || c->x86 == 0x11)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+
+	/* get apicid instead of initial apic id from cpuid */
+	c->apicid = hard_smp_processor_id();
 #else
 
 	/*
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 789efe2..cb98a73 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -241,7 +241,7 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 	case 0:
 		if (!l1->val)
 			return;
-		assoc = l1->assoc;
+		assoc = assocs[l1->assoc];
 		line_size = l1->line_size;
 		lines_per_tag = l1->lines_per_tag;
 		size_in_kb = l1->size_in_kb;
@@ -249,7 +249,7 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 	case 2:
 		if (!l2.val)
 			return;
-		assoc = l2.assoc;
+		assoc = assocs[l2.assoc];
 		line_size = l2.line_size;
 		lines_per_tag = l2.lines_per_tag;
 		/* cpu_data has errata corrections for K7 applied */
@@ -258,10 +258,14 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 	case 3:
 		if (!l3.val)
 			return;
-		assoc = l3.assoc;
+		assoc = assocs[l3.assoc];
 		line_size = l3.line_size;
 		lines_per_tag = l3.lines_per_tag;
 		size_in_kb = l3.size_encoded * 512;
+		if (boot_cpu_has(X86_FEATURE_AMD_DCM)) {
+			size_in_kb = size_in_kb >> 1;
+			assoc = assoc >> 1;
+		}
 		break;
 	default:
 		return;
@@ -270,18 +274,14 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 	eax->split.is_self_initializing = 1;
 	eax->split.type = types[leaf];
 	eax->split.level = levels[leaf];
-	if (leaf == 3)
-		eax->split.num_threads_sharing =
-			current_cpu_data.x86_max_cores - 1;
-	else
-		eax->split.num_threads_sharing = 0;
+	eax->split.num_threads_sharing = 0;
 	eax->split.num_cores_on_die = current_cpu_data.x86_max_cores - 1;
 
 
-	if (assoc == 0xf)
+	if (assoc == 0xffff)
 		eax->split.is_fully_associative = 1;
 	ebx->split.coherency_line_size = line_size - 1;
-	ebx->split.ways_of_associativity = assocs[assoc] - 1;
+	ebx->split.ways_of_associativity = assoc - 1;
 	ebx->split.physical_line_partition = lines_per_tag - 1;
 	ecx->split.number_of_sets = (size_in_kb * 1024) / line_size /
 		(ebx->split.ways_of_associativity + 1) - 1;
@@ -522,6 +522,18 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
 	int index_msb, i;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
+	if ((index == 3) && (c->x86_vendor == X86_VENDOR_AMD)) {
+		struct cpuinfo_x86 *d;
+		for_each_online_cpu(i) {
+			if (!per_cpu(cpuid4_info, i))
+				continue;
+			d = &cpu_data(i);
+			this_leaf = CPUID4_INFO_IDX(i, index);
+			cpumask_copy(to_cpumask(this_leaf->shared_cpu_map),
+				     d->llc_shared_map);
+		}
+		return;
+	}
 	this_leaf = CPUID4_INFO_IDX(cpu, index);
 	num_threads_sharing = 1 + this_leaf->eax.split.num_threads_sharing;
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index ddae216..1fecba4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -489,12 +489,14 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	int i, err = 0;
 	struct threshold_bank *b = NULL;
 	char name[32];
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
 
 	sprintf(name, "threshold_bank%i", bank);
 
 #ifdef CONFIG_SMP
 	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
-		i = cpumask_first(cpu_core_mask(cpu));
+		i = cpumask_first(c->llc_shared_map);
 
 		/* first core not up yet */
 		if (cpu_data(i).cpu_core_id)
@@ -514,7 +516,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		if (err)
 			goto out;
 
-		cpumask_copy(b->cpus, cpu_core_mask(cpu));
+		cpumask_copy(b->cpus, c->llc_shared_map);
 		per_cpu(threshold_banks, cpu)[bank] = b;
 
 		goto out;
@@ -539,7 +541,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 #ifndef CONFIG_SMP
 	cpumask_setall(b->cpus);
 #else
-	cpumask_copy(b->cpus, cpu_core_mask(cpu));
+	cpumask_copy(b->cpus, c->llc_shared_map);
 #endif
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index d5e3039..f82706a 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -116,11 +116,9 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		seq_printf(m, "TLB size\t: %d 4K pages\n", c->x86_tlbsize);
 #endif
 	seq_printf(m, "clflush size\t: %u\n", c->x86_clflush_size);
-#ifdef CONFIG_X86_64
 	seq_printf(m, "cache_alignment\t: %d\n", c->x86_cache_alignment);
 	seq_printf(m, "address sizes\t: %u bits physical, %u bits virtual\n",
 		   c->x86_phys_bits, c->x86_virt_bits);
-#endif
 
 	seq_printf(m, "power management:");
 	for (i = 0; i < 32; i++) {
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 98fd6cd..7dd9500 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -1,6 +1,7 @@
 /* ----------------------------------------------------------------------- *
  *
  *   Copyright 2000-2008 H. Peter Anvin - All Rights Reserved
+ *   Copyright 2009 Intel Corporation; author: H. Peter Anvin
  *
  *   This program is free software; you can redistribute it and/or modify
  *   it under the terms of the GNU General Public License as published by
@@ -80,11 +81,8 @@ static ssize_t msr_read(struct file *file, char __user *buf,
 
 	for (; count; count -= 8) {
 		err = rdmsr_safe_on_cpu(cpu, reg, &data[0], &data[1]);
-		if (err) {
-			if (err == -EFAULT) /* Fix idiotic error code */
-				err = -EIO;
+		if (err)
 			break;
-		}
 		if (copy_to_user(tmp, &data, 8)) {
 			err = -EFAULT;
 			break;
@@ -115,11 +113,8 @@ static ssize_t msr_write(struct file *file, const char __user *buf,
 			break;
 		}
 		err = wrmsr_safe_on_cpu(cpu, reg, data[0], data[1]);
-		if (err) {
-			if (err == -EFAULT) /* Fix idiotic error code */
-				err = -EIO;
+		if (err)
 			break;
-		}
 		tmp += 2;
 		bytes += 8;
 	}
@@ -127,6 +122,54 @@ static ssize_t msr_write(struct file *file, const char __user *buf,
 	return bytes ? bytes : err;
 }
 
+static long msr_ioctl(struct file *file, unsigned int ioc, unsigned long arg)
+{
+	u32 __user *uregs = (u32 __user *)arg;
+	u32 regs[8];
+	int cpu = iminor(file->f_path.dentry->d_inode);
+	int err;
+
+	switch (ioc) {
+	case X86_IOC_RDMSR_REGS:
+		if (!(file->f_mode & FMODE_READ)) {
+			err = -EBADF;
+			break;
+		}
+		if (copy_from_user(&regs, uregs, sizeof regs)) {
+			err = -EFAULT;
+			break;
+		}
+		err = rdmsr_safe_regs_on_cpu(cpu, regs);
+		if (err)
+			break;
+		if (copy_to_user(uregs, &regs, sizeof regs))
+			err = -EFAULT;
+		break;
+
+	case X86_IOC_WRMSR_REGS:
+		if (!(file->f_mode & FMODE_WRITE)) {
+			err = -EBADF;
+			break;
+		}
+		if (copy_from_user(&regs, uregs, sizeof regs)) {
+			err = -EFAULT;
+			break;
+		}
+		err = wrmsr_safe_regs_on_cpu(cpu, regs);
+		if (err)
+			break;
+		if (copy_to_user(uregs, &regs, sizeof regs))
+			err = -EFAULT;
+		break;
+
+	default:
+		err = -ENOTTY;
+		break;
+	}
+
+	return err;
+}
+
 static int msr_open(struct inode *inode, struct file *file)
 {
 	unsigned int cpu = iminor(file->f_path.dentry->d_inode);
@@ -157,6 +200,8 @@ static const struct file_operations msr_fops = {
 	.read = msr_read,
 	.write = msr_write,
 	.open = msr_open,
+	.unlocked_ioctl = msr_ioctl,
+	.compat_ioctl = msr_ioctl,
 };
 
 static int __cpuinit msr_device_create(int cpu)
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 70ec9b9..f5b0b4a 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -362,8 +362,9 @@ struct pv_cpu_ops pv_cpu_ops = {
 #endif
 	.wbinvd = native_wbinvd,
 	.read_msr = native_read_msr_safe,
-	.read_msr_amd = native_read_msr_amd_safe,
+	.rdmsr_regs = native_rdmsr_safe_regs,
 	.write_msr = native_write_msr_safe,
+	.wrmsr_regs = native_wrmsr_safe_regs,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 	.read_tscp = native_read_tscp,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2fecda6..c36cc14 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -434,7 +434,8 @@ const struct cpumask *cpu_coregroup_mask(int cpu)
 	 * For perf, we return last level cache shared map.
 	 * And for power savings, we return cpu_core_map
 	 */
-	if (sched_mc_power_savings || sched_smt_power_savings)
+	if ((sched_mc_power_savings || sched_smt_power_savings) &&
+	    !(cpu_has(c, X86_FEATURE_AMD_DCM)))
 		return cpu_core_mask(cpu);
 	else
 		return c->llc_shared_map;
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 07c3189..9e60920 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -9,6 +9,8 @@ lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 
+obj-y += msr-reg.o msr-reg-export.o
+
 ifeq ($(CONFIG_X86_32),y)
         obj-y += atomic64_32.o
         lib-y += checksum_32.o
diff --git a/arch/x86/lib/msr-reg-export.c b/arch/x86/lib/msr-reg-export.c
new file mode 100644
index 0000000..a311cc5
--- /dev/null
+++ b/arch/x86/lib/msr-reg-export.c
@@ -0,0 +1,5 @@
+#include <linux/module.h>
+#include <asm/msr.h>
+
+EXPORT_SYMBOL(native_rdmsr_safe_regs);
+EXPORT_SYMBOL(native_wrmsr_safe_regs);
diff --git a/arch/x86/lib/msr-reg.S b/arch/x86/lib/msr-reg.S
new file mode 100644
index 0000000..69fa106
--- /dev/null
+++ b/arch/x86/lib/msr-reg.S
@@ -0,0 +1,102 @@
+#include <linux/linkage.h>
+#include <linux/errno.h>
+#include <asm/dwarf2.h>
+#include <asm/asm.h>
+#include <asm/msr.h>
+
+#ifdef CONFIG_X86_64
+/*
+ * int native_{rdmsr,wrmsr}_safe_regs(u32 gprs[8]);
+ *
+ * reg layout: u32 gprs[eax, ecx, edx, ebx, esp, ebp, esi, edi]
+ *
+ */
+.macro op_safe_regs op
+ENTRY(native_\op\()_safe_regs)
+	CFI_STARTPROC
+	pushq_cfi %rbx
+	pushq_cfi %rbp
+	movq	%rdi, %r10	/* Save pointer */
+	xorl	%r11d, %r11d	/* Return value */
+	movl    (%rdi), %eax
+	movl    4(%rdi), %ecx
+	movl    8(%rdi), %edx
+	movl    12(%rdi), %ebx
+	movl    20(%rdi), %ebp
+	movl    24(%rdi), %esi
+	movl    28(%rdi), %edi
+	CFI_REMEMBER_STATE
+1:	\op
+2:	movl    %eax, (%r10)
+	movl	%r11d, %eax	/* Return value */
+	movl    %ecx, 4(%r10)
+	movl    %edx, 8(%r10)
+	movl    %ebx, 12(%r10)
+	movl    %ebp, 20(%r10)
+	movl    %esi, 24(%r10)
+	movl    %edi, 28(%r10)
+	popq_cfi %rbp
+	popq_cfi %rbx
+	ret
+3:
+	CFI_RESTORE_STATE
+	movl    $-EIO, %r11d
+	jmp     2b
+
+	_ASM_EXTABLE(1b, 3b)
+	CFI_ENDPROC
+ENDPROC(native_\op\()_safe_regs)
+.endm
+
+#else /* X86_32 */
+
+.macro op_safe_regs op
+ENTRY(native_\op\()_safe_regs)
+	CFI_STARTPROC
+	pushl_cfi %ebx
+	pushl_cfi %ebp
+	pushl_cfi %esi
+	pushl_cfi %edi
+	pushl_cfi $0              /* Return value */
+	pushl_cfi %eax
+	movl    4(%eax), %ecx
+	movl    8(%eax), %edx
+	movl    12(%eax), %ebx
+	movl    20(%eax), %ebp
+	movl    24(%eax), %esi
+	movl    28(%eax), %edi
+	movl    (%eax), %eax
+	CFI_REMEMBER_STATE
+1:	\op
+2:	pushl_cfi %eax
+	movl    4(%esp), %eax
+	popl_cfi (%eax)
+	addl    $4, %esp
+	CFI_ADJUST_CFA_OFFSET -4
+	movl    %ecx, 4(%eax)
+	movl    %edx, 8(%eax)
+	movl    %ebx, 12(%eax)
+	movl    %ebp, 20(%eax)
+	movl    %esi, 24(%eax)
+	movl    %edi, 28(%eax)
+	popl_cfi %eax
+	popl_cfi %edi
+	popl_cfi %esi
+	popl_cfi %ebp
+	popl_cfi %ebx
+	ret
+3:
+	CFI_RESTORE_STATE
+	movl    $-EIO, 4(%esp)
+	jmp     2b
+
+	_ASM_EXTABLE(1b, 3b)
+	CFI_ENDPROC
+ENDPROC(native_\op\()_safe_regs)
+.endm
+
+#endif
+
+op_safe_regs rdmsr
+op_safe_regs wrmsr
+
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index caa24ac..33a1e3c 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -175,3 +175,52 @@ int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 	return err ? err : rv.err;
 }
 EXPORT_SYMBOL(wrmsr_safe_on_cpu);
+
+/*
+ * These variants are significantly slower, but allows control over
+ * the entire 32-bit GPR set.
+ */
+struct msr_regs_info {
+	u32 *regs;
+	int err;
+};
+
+static void __rdmsr_safe_regs_on_cpu(void *info)
+{
+	struct msr_regs_info *rv = info;
+
+	rv->err = rdmsr_safe_regs(rv->regs);
+}
+
+static void __wrmsr_safe_regs_on_cpu(void *info)
+{
+	struct msr_regs_info *rv = info;
+
+	rv->err = wrmsr_safe_regs(rv->regs);
+}
+
+int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
+{
+	int err;
+	struct msr_regs_info rv;
+
+	rv.regs   = regs;
+	rv.err    = -EIO;
+	err = smp_call_function_single(cpu, __rdmsr_safe_regs_on_cpu, &rv, 1);
+
+	return err ? err : rv.err;
+}
+EXPORT_SYMBOL(rdmsr_safe_regs_on_cpu);
+
+int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
+{
+	int err;
+	struct msr_regs_info rv;
+
+	rv.regs = regs;
+	rv.err  = -EIO;
+	err = smp_call_function_single(cpu, __wrmsr_safe_regs_on_cpu, &rv, 1);
+
+	return err ? err : rv.err;
+}
+EXPORT_SYMBOL(wrmsr_safe_regs_on_cpu);
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 0a1700a..a8432d8 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -713,7 +713,7 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
 	set:
 		base = ((u64)high << 32) | low;
 		if (HYPERVISOR_set_segment_base(which, base) != 0)
-			ret = -EFAULT;
+			ret = -EIO;
 		break;
 #endif
 
