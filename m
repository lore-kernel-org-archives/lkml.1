Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbYJPNve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbYJPNve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 09:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYJPNvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 09:51:24 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:36234 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbYJPNvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 09:51:23 -0400
Subject: [GIT PULL] SET_PERSONALITY cleanup.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 16 Oct 2008 15:45:04 +0200
Message-Id: <1224164705.9617.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'personality' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git personality

to receive the following updates:

Martin Schwidefsky (1):
      remove unused ibcs2/PER_SVR4 in SET_PERSONALITY

 arch/alpha/include/asm/elf.h      |    4 ++--
 arch/arm/include/asm/elf.h        |    2 +-
 arch/avr32/include/asm/elf.h      |    2 +-
 arch/blackfin/include/asm/elf.h   |    2 +-
 arch/h8300/include/asm/elf.h      |    2 +-
 arch/ia64/ia32/binfmt_elf32.c     |    2 +-
 arch/ia64/ia32/ia32priv.h         |    4 ++--
 arch/ia64/include/asm/elf.h       |    2 +-
 arch/m68knommu/include/asm/elf.h  |    2 +-
 arch/mips/include/asm/elf.h       |   10 +++-------
 arch/parisc/kernel/binfmt_elf32.c |    2 +-
 arch/powerpc/include/asm/elf.h    |    4 ++--
 arch/s390/include/asm/elf.h       |    8 +++-----
 arch/sh/include/asm/elf.h         |    2 +-
 arch/sparc/include/asm/elf_32.h   |    2 +-
 arch/sparc/include/asm/elf_64.h   |    6 ++----
 fs/binfmt_elf.c                   |    6 +++---
 include/asm-cris/elf.h            |    2 +-
 include/asm-frv/elf.h             |    2 +-
 include/asm-m32r/elf.h            |    2 +-
 include/asm-m68k/elf.h            |    2 +-
 include/asm-mn10300/elf.h         |    2 +-
 include/asm-parisc/elf.h          |    2 +-
 include/asm-um/elf-i386.h         |    2 +-
 include/asm-um/elf-ppc.h          |    2 +-
 include/asm-um/elf-x86_64.h       |    2 +-
 include/asm-x86/elf.h             |    4 ++--
 include/asm-xtensa/elf.h          |    2 +-
 28 files changed, 39 insertions(+), 47 deletions(-)

diff --git a/arch/alpha/include/asm/elf.h b/arch/alpha/include/asm/elf.h
index fc1002e..5c75c1b 100644
--- a/arch/alpha/include/asm/elf.h
+++ b/arch/alpha/include/asm/elf.h
@@ -144,9 +144,9 @@ extern int dump_elf_task_fp(elf_fpreg_t *dest, struct task_struct *task);
 	: amask (AMASK_CIX) ? "ev6" : "ev67");	\
 })
 
-#define SET_PERSONALITY(EX, IBCS2)				\
+#define SET_PERSONALITY(EX)					\
 	set_personality(((EX).e_flags & EF_ALPHA_32BIT)		\
-	   ? PER_LINUX_32BIT : (IBCS2) ? PER_SVR4 : PER_LINUX)
+	   ? PER_LINUX_32BIT : PER_LINUX)
 
 extern int alpha_l1i_cacheshape;
 extern int alpha_l1d_cacheshape;
diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index 5be0169..a58378c 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -107,6 +107,6 @@ extern int arm_elf_read_implies_exec(const struct elf32_hdr *, int);
 #define ELF_PLAT_INIT(_r, load_addr)	(_r)->ARM_r0 = 0
 
 extern void elf_set_personality(const struct elf32_hdr *);
-#define SET_PERSONALITY(ex, ibcs2)	elf_set_personality(&(ex))
+#define SET_PERSONALITY(ex)	elf_set_personality(&(ex))
 
 #endif
diff --git a/arch/avr32/include/asm/elf.h b/arch/avr32/include/asm/elf.h
index 64ce40e..d5d1d41 100644
--- a/arch/avr32/include/asm/elf.h
+++ b/arch/avr32/include/asm/elf.h
@@ -103,6 +103,6 @@ typedef struct user_fpu_struct elf_fpregset_t;
 
 #define ELF_PLATFORM  (NULL)
 
-#define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX_32BIT)
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX_32BIT)
 
 #endif /* __ASM_AVR32_ELF_H */
diff --git a/arch/blackfin/include/asm/elf.h b/arch/blackfin/include/asm/elf.h
index 67a03a8..cdbfcfc 100644
--- a/arch/blackfin/include/asm/elf.h
+++ b/arch/blackfin/include/asm/elf.h
@@ -122,6 +122,6 @@ do {											\
 
 #define ELF_PLATFORM  (NULL)
 
-#define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
 
 #endif
diff --git a/arch/h8300/include/asm/elf.h b/arch/h8300/include/asm/elf.h
index a8b57d1..94e2284 100644
--- a/arch/h8300/include/asm/elf.h
+++ b/arch/h8300/include/asm/elf.h
@@ -55,7 +55,7 @@ typedef unsigned long elf_fpregset_t;
 
 #define ELF_PLATFORM  (NULL)
 
-#define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX)
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
 
 #define R_H8_NONE       0
 #define R_H8_DIR32      1
diff --git a/arch/ia64/ia32/binfmt_elf32.c b/arch/ia64/ia32/binfmt_elf32.c
index 4f0c30c..f92bdaa 100644
--- a/arch/ia64/ia32/binfmt_elf32.c
+++ b/arch/ia64/ia32/binfmt_elf32.c
@@ -41,7 +41,7 @@ randomize_stack_top(unsigned long stack_top);
 #define elf_map				elf32_map
 
 #undef SET_PERSONALITY
-#define SET_PERSONALITY(ex, ibcs2)	elf32_set_personality()
+#define SET_PERSONALITY(ex)	elf32_set_personality()
 
 #define elf_read_implies_exec(ex, have_pt_gnu_stack)	(!(have_pt_gnu_stack))
 
diff --git a/arch/ia64/ia32/ia32priv.h b/arch/ia64/ia32/ia32priv.h
index dd0c536..0f15349 100644
--- a/arch/ia64/ia32/ia32priv.h
+++ b/arch/ia64/ia32/ia32priv.h
@@ -332,8 +332,8 @@ void ia64_elf32_init(struct pt_regs *regs);
 #define ELF_PLATFORM	NULL
 
 #ifdef __KERNEL__
-# define SET_PERSONALITY(EX,IBCS2)				\
-	(current->personality = (IBCS2) ? PER_SVR4 : PER_LINUX)
+# define SET_PERSONALITY(EX)				\
+	(current->personality = PER_LINUX)
 #endif
 
 #define IA32_EFLAG	0x200
diff --git a/arch/ia64/include/asm/elf.h b/arch/ia64/include/asm/elf.h
index 2acb6b6..86eddee 100644
--- a/arch/ia64/include/asm/elf.h
+++ b/arch/ia64/include/asm/elf.h
@@ -202,7 +202,7 @@ extern void ia64_elf_core_copy_regs (struct pt_regs *src, elf_gregset_t dst);
    relevant until we have real hardware to play with... */
 #define ELF_PLATFORM	NULL
 
-#define SET_PERSONALITY(ex, ibcs2)	set_personality(PER_LINUX)
+#define SET_PERSONALITY(ex)	set_personality(PER_LINUX)
 #define elf_read_implies_exec(ex, executable_stack)					\
 	((executable_stack!=EXSTACK_DISABLE_X) && ((ex).e_flags & EF_IA_64_LINUX_EXECUTABLE_STACK) != 0)
 
diff --git a/arch/m68knommu/include/asm/elf.h b/arch/m68knommu/include/asm/elf.h
index 27f0ec7..b804683 100644
--- a/arch/m68knommu/include/asm/elf.h
+++ b/arch/m68knommu/include/asm/elf.h
@@ -105,6 +105,6 @@ typedef struct user_m68kfp_struct elf_fpregset_t;
 
 #define ELF_PLATFORM  (NULL)
 
-#define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
 
 #endif
diff --git a/arch/mips/include/asm/elf.h b/arch/mips/include/asm/elf.h
index f69f7ac..a8eac16 100644
--- a/arch/mips/include/asm/elf.h
+++ b/arch/mips/include/asm/elf.h
@@ -247,10 +247,8 @@ extern struct mips_abi mips_abi_n32;
 
 #ifdef CONFIG_32BIT
 
-#define SET_PERSONALITY(ex, ibcs2)					\
+#define SET_PERSONALITY(ex)						\
 do {									\
-	if (ibcs2)							\
-		set_personality(PER_SVR4);				\
 	set_personality(PER_LINUX);					\
 									\
 	current->thread.abi = &mips_abi;				\
@@ -296,7 +294,7 @@ do {									\
 #define __SET_PERSONALITY32(ex)	do { } while (0)
 #endif
 
-#define SET_PERSONALITY(ex, ibcs2)					\
+#define SET_PERSONALITY(ex)						\
 do {									\
 	clear_thread_flag(TIF_32BIT_REGS);				\
 	clear_thread_flag(TIF_32BIT_ADDR);				\
@@ -306,9 +304,7 @@ do {									\
 	else								\
 		current->thread.abi = &mips_abi;			\
 									\
-	if (ibcs2)							\
-		set_personality(PER_SVR4);				\
-	else if (current->personality != PER_LINUX32)			\
+	if (current->personality != PER_LINUX32)			\
 		set_personality(PER_LINUX);				\
 } while (0)
 
diff --git a/arch/parisc/kernel/binfmt_elf32.c b/arch/parisc/kernel/binfmt_elf32.c
index ecb10a4..f61692d 100644
--- a/arch/parisc/kernel/binfmt_elf32.c
+++ b/arch/parisc/kernel/binfmt_elf32.c
@@ -85,7 +85,7 @@ struct elf_prpsinfo32
  * could set a processor dependent flag in the thread_struct.
  */
 
-#define SET_PERSONALITY(ex, ibcs2) \
+#define SET_PERSONALITY(ex) \
 	set_thread_flag(TIF_32BIT); \
 	current->thread.map_base = DEFAULT_MAP_BASE32; \
 	current->thread.task_size = DEFAULT_TASK_SIZE32 \
diff --git a/arch/powerpc/include/asm/elf.h b/arch/powerpc/include/asm/elf.h
index 64c6ee2..d812929 100644
--- a/arch/powerpc/include/asm/elf.h
+++ b/arch/powerpc/include/asm/elf.h
@@ -232,7 +232,7 @@ typedef elf_vrregset_t elf_fpxregset_t;
 #endif /* __powerpc64__ */
 
 #ifdef __powerpc64__
-# define SET_PERSONALITY(ex, ibcs2)				\
+# define SET_PERSONALITY(ex)					\
 do {								\
 	unsigned long new_flags = 0;				\
 	if ((ex).e_ident[EI_CLASS] == ELFCLASS32)		\
@@ -256,7 +256,7 @@ do {								\
 # define elf_read_implies_exec(ex, exec_stk) (test_thread_flag(TIF_32BIT) ? \
 		(exec_stk != EXSTACK_DISABLE_X) : 0)
 #else 
-# define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
+# define SET_PERSONALITY(ex) set_personality(PER_LINUX)
 #endif /* __powerpc64__ */
 
 extern int dcache_bsize;
diff --git a/arch/s390/include/asm/elf.h b/arch/s390/include/asm/elf.h
index 3cad569..261785a 100644
--- a/arch/s390/include/asm/elf.h
+++ b/arch/s390/include/asm/elf.h
@@ -166,13 +166,11 @@ extern char elf_platform[];
 #define ELF_PLATFORM (elf_platform)
 
 #ifndef __s390x__
-#define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
 #else /* __s390x__ */
-#define SET_PERSONALITY(ex, ibcs2)			\
+#define SET_PERSONALITY(ex)				\
 do {							\
-	if (ibcs2)					\
-		set_personality(PER_SVR4);		\
-	else if (current->personality != PER_LINUX32)	\
+	if (current->personality != PER_LINUX32)	\
 		set_personality(PER_LINUX);		\
 	if ((ex).e_ident[EI_CLASS] == ELFCLASS32)	\
 		set_thread_flag(TIF_31BIT);		\
diff --git a/arch/sh/include/asm/elf.h b/arch/sh/include/asm/elf.h
index f01449a..ee02db1 100644
--- a/arch/sh/include/asm/elf.h
+++ b/arch/sh/include/asm/elf.h
@@ -189,7 +189,7 @@ do {									\
 } while (0)
 #endif
 
-#define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX_32BIT)
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX_32BIT)
 struct task_struct;
 extern int dump_task_regs (struct task_struct *, elf_gregset_t *);
 extern int dump_task_fpu (struct task_struct *, elf_fpregset_t *);
diff --git a/arch/sparc/include/asm/elf_32.h b/arch/sparc/include/asm/elf_32.h
index b7ab605..381a1b5 100644
--- a/arch/sparc/include/asm/elf_32.h
+++ b/arch/sparc/include/asm/elf_32.h
@@ -137,6 +137,6 @@ typedef struct {
 
 #define ELF_PLATFORM	(NULL)
 
-#define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
 
 #endif /* !(__ASMSPARC_ELF_H) */
diff --git a/arch/sparc/include/asm/elf_64.h b/arch/sparc/include/asm/elf_64.h
index 0818a13..425c2f9 100644
--- a/arch/sparc/include/asm/elf_64.h
+++ b/arch/sparc/include/asm/elf_64.h
@@ -195,7 +195,7 @@ static inline unsigned int sparc64_elf_hwcap(void)
 
 #define ELF_PLATFORM	(NULL)
 
-#define SET_PERSONALITY(ex, ibcs2)			\
+#define SET_PERSONALITY(ex)				\
 do {	unsigned long new_flags = current_thread_info()->flags; \
 	new_flags &= _TIF_32BIT;			\
 	if ((ex).e_ident[EI_CLASS] == ELFCLASS32)	\
@@ -208,9 +208,7 @@ do {	unsigned long new_flags = current_thread_info()->flags; \
 	else						\
 		clear_thread_flag(TIF_ABI_PENDING);	\
 	/* flush_thread will update pgd cache */	\
-	if (ibcs2)					\
-		set_personality(PER_SVR4);		\
-	else if (current->personality != PER_LINUX32)	\
+	if (current->personality != PER_LINUX32)	\
 		set_personality(PER_LINUX);		\
 } while (0)
 
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 655ed8d..c76afa2 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -683,7 +683,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 			 * switch really is going to happen - do this in
 			 * flush_thread().	- akpm
 			 */
-			SET_PERSONALITY(loc->elf_ex, 0);
+			SET_PERSONALITY(loc->elf_ex);
 
 			interpreter = open_exec(elf_interpreter);
 			retval = PTR_ERR(interpreter);
@@ -734,7 +734,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 			goto out_free_dentry;
 	} else {
 		/* Executables without an interpreter also need a personality  */
-		SET_PERSONALITY(loc->elf_ex, 0);
+		SET_PERSONALITY(loc->elf_ex);
 	}
 
 	/* Flush all traces of the currently running executable */
@@ -748,7 +748,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	/* Do this immediately, since STACK_TOP as used in setup_arg_pages
 	   may depend on the personality.  */
-	SET_PERSONALITY(loc->elf_ex, 0);
+	SET_PERSONALITY(loc->elf_ex);
 	if (elf_read_implies_exec(loc->elf_ex, executable_stack))
 		current->personality |= READ_IMPLIES_EXEC;
 
diff --git a/include/asm-cris/elf.h b/include/asm-cris/elf.h
index 001f64a..f0d17fb 100644
--- a/include/asm-cris/elf.h
+++ b/include/asm-cris/elf.h
@@ -88,6 +88,6 @@ typedef unsigned long elf_fpregset_t;
 
 #define ELF_PLATFORM  (NULL)
 
-#define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
 
 #endif
diff --git a/include/asm-frv/elf.h b/include/asm-frv/elf.h
index 9fb946b..7279ec0 100644
--- a/include/asm-frv/elf.h
+++ b/include/asm-frv/elf.h
@@ -137,6 +137,6 @@ do {											\
 
 #define ELF_PLATFORM  (NULL)
 
-#define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
 
 #endif
diff --git a/include/asm-m32r/elf.h b/include/asm-m32r/elf.h
index 67bcd77..0cc34c9 100644
--- a/include/asm-m32r/elf.h
+++ b/include/asm-m32r/elf.h
@@ -129,6 +129,6 @@ typedef elf_fpreg_t elf_fpregset_t;
    intent than poking at uname or /proc/cpuinfo.  */
 #define ELF_PLATFORM	(NULL)
 
-#define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX)
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
 
 #endif  /* _ASM_M32R__ELF_H */
diff --git a/include/asm-m68k/elf.h b/include/asm-m68k/elf.h
index 14ea421..0b0f49e 100644
--- a/include/asm-m68k/elf.h
+++ b/include/asm-m68k/elf.h
@@ -114,6 +114,6 @@ typedef struct user_m68kfp_struct elf_fpregset_t;
 
 #define ELF_PLATFORM  (NULL)
 
-#define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
 
 #endif
diff --git a/include/asm-mn10300/elf.h b/include/asm-mn10300/elf.h
index 256a704..bf09f8b 100644
--- a/include/asm-mn10300/elf.h
+++ b/include/asm-mn10300/elf.h
@@ -141,7 +141,7 @@ do {						\
 #define ELF_PLATFORM  (NULL)
 
 #ifdef __KERNEL__
-#define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX)
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
 #endif
 
 #endif /* _ASM_ELF_H */
diff --git a/include/asm-parisc/elf.h b/include/asm-parisc/elf.h
index d0a4a82..7fa6757 100644
--- a/include/asm-parisc/elf.h
+++ b/include/asm-parisc/elf.h
@@ -236,7 +236,7 @@ typedef unsigned long elf_greg_t;
 
 #define ELF_PLATFORM  ("PARISC\0")
 
-#define SET_PERSONALITY(ex, ibcs2) \
+#define SET_PERSONALITY(ex) \
 	current->personality = PER_LINUX; \
 	current->thread.map_base = DEFAULT_MAP_BASE; \
 	current->thread.task_size = DEFAULT_TASK_SIZE \
diff --git a/include/asm-um/elf-i386.h b/include/asm-um/elf-i386.h
index 23d6893..d0da9d7 100644
--- a/include/asm-um/elf-i386.h
+++ b/include/asm-um/elf-i386.h
@@ -86,7 +86,7 @@ extern long elf_aux_hwcap;
 extern char * elf_aux_platform;
 #define ELF_PLATFORM (elf_aux_platform)
 
-#define SET_PERSONALITY(ex, ibcs2) do { } while (0)
+#define SET_PERSONALITY(ex) do { } while (0)
 
 extern unsigned long vsyscall_ehdr;
 extern unsigned long vsyscall_end;
diff --git a/include/asm-um/elf-ppc.h b/include/asm-um/elf-ppc.h
index d3b90b7..af9463c 100644
--- a/include/asm-um/elf-ppc.h
+++ b/include/asm-um/elf-ppc.h
@@ -5,7 +5,7 @@
 extern long elf_aux_hwcap;
 #define ELF_HWCAP (elf_aux_hwcap)
 
-#define SET_PERSONALITY(ex, ibcs2) do ; while(0)
+#define SET_PERSONALITY(ex) do ; while(0)
 
 #define ELF_EXEC_PAGESIZE 4096
 
diff --git a/include/asm-um/elf-x86_64.h b/include/asm-um/elf-x86_64.h
index 3b2d522..6e8a919 100644
--- a/include/asm-um/elf-x86_64.h
+++ b/include/asm-um/elf-x86_64.h
@@ -114,6 +114,6 @@ extern long elf_aux_hwcap;
 
 #define ELF_PLATFORM "x86_64"
 
-#define SET_PERSONALITY(ex, ibcs2) do ; while(0)
+#define SET_PERSONALITY(ex) do ; while(0)
 
 #endif
diff --git a/include/asm-x86/elf.h b/include/asm-x86/elf.h
index 5c4745b..26bc15f 100644
--- a/include/asm-x86/elf.h
+++ b/include/asm-x86/elf.h
@@ -186,7 +186,7 @@ do {							\
 	set_fs(USER_DS);				\
 } while (0)
 
-#define COMPAT_SET_PERSONALITY(ex, ibcs2)		\
+#define COMPAT_SET_PERSONALITY(ex)			\
 do {							\
 	if (test_thread_flag(TIF_IA32))			\
 		clear_thread_flag(TIF_ABI_PENDING);	\
@@ -267,7 +267,7 @@ extern int force_personality32;
    For the moment, we have only optimizations for the Intel generations,
    but that could change... */
 
-#define SET_PERSONALITY(ex, ibcs2) set_personality_64bit()
+#define SET_PERSONALITY(ex) set_personality_64bit()
 
 /*
  * An executable for which elf_read_implies_exec() returns TRUE will
diff --git a/include/asm-xtensa/elf.h b/include/asm-xtensa/elf.h
index ca6e510..c3f53e7 100644
--- a/include/asm-xtensa/elf.h
+++ b/include/asm-xtensa/elf.h
@@ -189,7 +189,7 @@ typedef struct {
 #endif
 } elf_xtregs_t;
 
-#define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX_32BIT)
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX_32BIT)
 
 struct task_struct;
 


