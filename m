Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbZHZRcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbZHZRcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZHZRci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:32:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:57613 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbZHZRce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:32:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Chen Liqin (Gmail)" <liqin.gnu@gmail.com>
Subject: Re: [GIT PULL, v4] S+core architecture (arch/score) support
Date: Wed, 26 Aug 2009 19:31:52 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
References: <1251266324.16454.10.camel@ad3ser01>
In-Reply-To: <1251266324.16454.10.camel@ad3ser01>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200908261931.52645.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+2X9M4OwijxcYMx3nwg8kuIGtBmDrf2YzEgbl
 t3f8byIGnHRAFbnIneRSGp/rakk+PaX34cKLkydXsAx7m1SYOk
 6eUI/xJ44wazdKdB2peoQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 August 2009, Chen Liqin (Gmail) wrote:
> Hi Linus,
> 
> We had setup a git server at gitserver.sunplusct.com,
> This repository contains Linux support for S+core CPU.
> it's base on Linux 2.6.31-rc7 and Arnd asm-generic repository.

Hi Liqin,

Great to hear that you have finally managed to set up your own
git repository!

This is a good time to send out the code for review, but it's not
the time for a merge request, because we are still fixing bugs
in 2.6.31. Please send a merge request again shortly after Linus
has released 2.6.31 and has opened the 2.6.32 merge window.

Similarly, the split of your patches is good for review, but it
is useless to have 33 commits in your changelog with just the
file names listed in the history text.

What is missing OTOH is a description of changes you made since
the last version you posted, which would be needed to help
people that have already reviewed your code before.
Also, you have dropped the descriptions of changes that I
contributed, committing the changed files as your own. If you
see a need to do that next time, please ask before you do it,
or find a way to keep the original commit logs.

For what it's worth, I've done a diff between your last version
in my tree and the version in your for-linus branch, in case
people want to see the changes, see below.

What is the status of the port now? Do you have a working glibc
and LTP test results, or are do you still need to fix more
bugs that got introduced in the 2.6.30 port?

If you have a glibc port with the asm-generic version of the
user ABI, that would be nice to share, because other ports
that are converting to it (NIOS2 will be next, there might
be more that I'm not aware of) need to do the same.

	Arnd <><

---
 Kconfig.debug           |    3
 Makefile                |    2
 include/asm/elf.h       |   18 +-
 include/asm/irq.h       |   12 -
 include/asm/irq_regs.h  |    7
 include/asm/irqflags.h  |    2
 include/asm/linkage.h   |    3
 include/asm/page.h      |    4
 include/asm/pgalloc.h   |    2
 include/asm/pgtable.h   |   31 ++--
 include/asm/ptrace.h    |    8 -
 include/asm/setup.h     |    3
 include/asm/syscalls.h  |    6
 include/asm/uaccess.h   |    4
 include/asm/ucontext.h  |    1
 include/asm/unistd.h    |    1
 include/asm/user.h      |   17 ++
 kernel/Makefile         |    3
 kernel/entry.S          |   47 ------
 kernel/init_task.c      |    2
 kernel/irq.c            |   33 +++-
 kernel/module.c         |   13 -
 kernel/process.c        |    3
 kernel/ptrace.c         |  213 ++++++++++++----------------
 kernel/setup.c          |   32 ++--
 kernel/signal.c         |   38 ++--
 kernel/sys_call_table.c |   12 +
 kernel/sys_score.c      |   37 +---
 kernel/time.c           |    2
 lib/string.S            |   12 -
 mm/init.c               |   38 +---
 mm/pgtable.c            |   10 -
 32 files changed, 292 insertions(+), 327 deletions(-)

diff --git a/arch/score/Kconfig.debug b/arch/score/Kconfig.debug
index 451ed54..c2863be 100644
--- a/arch/score/Kconfig.debug
+++ b/arch/score/Kconfig.debug
@@ -1,8 +1,7 @@
 menu "Kernel hacking"
 
 config TRACE_IRQFLAGS_SUPPORT
-	bool
-	default y
+	def_bool y
 
 source "lib/Kconfig.debug"
 
diff --git a/arch/score/Makefile b/arch/score/Makefile
index 68e0cd0..40a5b19 100644
--- a/arch/score/Makefile
+++ b/arch/score/Makefile
@@ -12,7 +12,7 @@ CROSS_COMPILE := score-linux-
 #
 # CPU-dependent compiler/assembler options for optimization.
 #
-cflags-y += -G0 -pipe -mel -mnhwloop -D__SCOREEL__ \
+cflags-y += -g -G0 -pipe -mel -mnhwloop -D__SCOREEL__ \
 	-D__linux__ -ffunction-sections -ffreestanding
 
 #
diff --git a/arch/score/include/asm/elf.h b/arch/score/include/asm/elf.h
index 8324363..43526d9 100644
--- a/arch/score/include/asm/elf.h
+++ b/arch/score/include/asm/elf.h
@@ -1,9 +1,8 @@
 #ifndef _ASM_SCORE_ELF_H
 #define _ASM_SCORE_ELF_H
 
-/* ELF register definitions */
-#define ELF_NGREG	45
-#define ELF_NFPREG	33
+#include <linux/ptrace.h>
+
 #define EM_SCORE7	135
 
 /* Relocation types. */
@@ -30,11 +29,15 @@
 #define R_SCORE_IMM30		20
 #define R_SCORE_IMM32		21
 
-typedef unsigned long elf_greg_t;
-typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+/* ELF register definitions */
+typedef unsigned long	elf_greg_t;
+
+#define ELF_NGREG	(sizeof(struct pt_regs) / sizeof(elf_greg_t))
+typedef elf_greg_t	elf_gregset_t[ELF_NGREG];
 
-typedef double elf_fpreg_t;
-typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
+/* Score does not have fp regs. */
+typedef double		elf_fpreg_t;
+typedef elf_fpreg_t	elf_fpregset_t;
 
 #define elf_check_arch(x)	((x)->e_machine == EM_SCORE7)
 
@@ -57,6 +60,7 @@ do {								\
 struct task_struct;
 struct pt_regs;
 
+#define CORE_DUMP_USE_REGSET
 #define USE_ELF_CORE_DUMP
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
diff --git a/arch/score/include/asm/irq.h b/arch/score/include/asm/irq.h
index 401f670..c883f3d 100644
--- a/arch/score/include/asm/irq.h
+++ b/arch/score/include/asm/irq.h
@@ -18,16 +18,8 @@
 
 #define irq_canonicalize(irq)	(irq)
 
-#define P_INT_PNDL		0x95F50000
-#define P_INT_PNDH		0x95F50004
-#define P_INT_PRIORITY_M	0x95F50008
-#define P_INT_PRIORITY_SG0	0x95F50010
-#define P_INT_PRIORITY_SG1	0x95F50014
-#define P_INT_PRIORITY_SG2	0x95F50018
-#define P_INT_PRIORITY_SG3	0x95F5001C
-#define P_INT_MASKL		0x95F50020
-#define P_INT_MASKH		0x95F50024
-
 #define IRQ_TIMER (7)		/* Timer IRQ number of SPCT6600 */
 
+extern void interrupt_exception_vector(void);
+
 #endif /* _ASM_SCORE_IRQ_H */
diff --git a/arch/score/include/asm/irq_regs.h b/arch/score/include/asm/irq_regs.h
index 905b7b0..b8e881c 100644
--- a/arch/score/include/asm/irq_regs.h
+++ b/arch/score/include/asm/irq_regs.h
@@ -1,6 +1,11 @@
 #ifndef _ASM_SCORE_IRQ_REGS_H
 #define _ASM_SCORE_IRQ_REGS_H
 
-#include <asm-generic/irq_regs.h>
+#include <linux/thread_info.h>
+
+static inline struct pt_regs *get_irq_regs(void)
+{
+	return current_thread_info()->regs;
+}
 
 #endif /* _ASM_SCORE_IRQ_REGS_H */
diff --git a/arch/score/include/asm/irqflags.h b/arch/score/include/asm/irqflags.h
index 92eeb33..690a6ca 100644
--- a/arch/score/include/asm/irqflags.h
+++ b/arch/score/include/asm/irqflags.h
@@ -17,8 +17,6 @@
 		"nop;"				\
 		"nop;"				\
 		"nop;"				\
-		"ldi	r9, 0x1;"		\
-		"and	%0, %0, r9;"		\
 		: "=r" (x)			\
 		:				\
 		: "r8", "r9"			\
diff --git a/arch/score/include/asm/linkage.h b/arch/score/include/asm/linkage.h
index 2580fbb..2323a8e 100644
--- a/arch/score/include/asm/linkage.h
+++ b/arch/score/include/asm/linkage.h
@@ -1,4 +1,7 @@
 #ifndef _ASM_SCORE_LINKAGE_H
 #define _ASM_SCORE_LINKAGE_H
 
+#define __ALIGN .align 2
+#define __ALIGN_STR ".align 2"
+
 #endif /* _ASM_SCORE_LINKAGE_H */
diff --git a/arch/score/include/asm/page.h b/arch/score/include/asm/page.h
index 67e9820..ee58210 100644
--- a/arch/score/include/asm/page.h
+++ b/arch/score/include/asm/page.h
@@ -57,8 +57,8 @@ extern unsigned long max_low_pfn;
 extern unsigned long min_low_pfn;
 extern unsigned long max_pfn;
 
-#define __pa(vaddr)		((unsigned long) (vaddr))
-#define __va(paddr)		((void *) (paddr))
+#define __pa(x)		((unsigned long)(x) - PAGE_OFFSET)
+#define __va(x)		((void *)((unsigned long) (x) + PAGE_OFFSET))
 
 #define phys_to_pfn(phys)	(PFN_DOWN(phys))
 #define pfn_to_phys(pfn)	(PFN_PHYS(pfn))
diff --git a/arch/score/include/asm/pgalloc.h b/arch/score/include/asm/pgalloc.h
index 28dacc1..059a61b 100644
--- a/arch/score/include/asm/pgalloc.h
+++ b/arch/score/include/asm/pgalloc.h
@@ -72,7 +72,7 @@ static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
 	__free_pages(pte, PTE_ORDER);
 }
 
-#define __pte_free_tlb(tlb, pte)			\
+#define __pte_free_tlb(tlb, pte, buf)			\
 do {							\
 	pgtable_page_dtor(pte);				\
 	tlb_remove_page((tlb), pte);			\
diff --git a/arch/score/include/asm/pgtable.h b/arch/score/include/asm/pgtable.h
index 5e913e5..674934b 100644
--- a/arch/score/include/asm/pgtable.h
+++ b/arch/score/include/asm/pgtable.h
@@ -106,7 +106,8 @@ static inline void pmd_clear(pmd_t *pmdp)
 	((swp_entry_t) { pte_val(pte)})
 #define __swp_entry_to_pte(x)	((pte_t) {(x).val})
 
-#define pmd_page(pmd) virt_to_page(__va(pmd_val(pmd)))
+#define pmd_phys(pmd)		__pa((void *)pmd_val(pmd))
+#define pmd_page(pmd)		(pfn_to_page(pmd_phys(pmd) >> PAGE_SHIFT))
 #define mk_pte(page, prot)	pfn_pte(page_to_pfn(page), prot)
 static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
 
@@ -129,14 +130,11 @@ static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
 #define pgd_clear(pgdp)		do { } while (0)
 
 #define kern_addr_valid(addr)	(1)
-#define	pmd_offset(a, b)	((void *) 0)
 #define pmd_page_vaddr(pmd)	pmd_val(pmd)
 
 #define pte_none(pte)		(!(pte_val(pte) & ~_PAGE_GLOBAL))
 #define pte_present(pte)	(pte_val(pte) & _PAGE_PRESENT)
 
-#define pud_offset(pgd, address) ((pud_t *) pgd)
-
 #define PAGE_NONE	__pgprot(_PAGE_PRESENT | _PAGE_CACHE)
 #define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_READ | _PAGE_WRITE | \
 				_PAGE_CACHE)
@@ -165,15 +163,27 @@ static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
 #define __S110	PAGE_SHARED
 #define __S111	PAGE_SHARED
 
-#define pgprot_noncached(x)	(x)
+#define pgprot_noncached pgprot_noncached
+
+static inline pgprot_t pgprot_noncached(pgprot_t _prot)
+{
+	unsigned long prot = pgprot_val(_prot);
+
+	prot = (prot & ~_CACHE_MASK);
+
+	return __pgprot(prot);
+}
 
-#define __swp_type(x)		(0)
-#define __swp_offset(x)		(0)
-#define __swp_entry(typ, off)	((swp_entry_t) { ((typ) | ((off) << 7)) })
+#define __swp_type(x)		((x).val & 0x1f)
+#define __swp_offset(x) 	((x).val >> 11)
+#define __swp_entry(type, offset) ((swp_entry_t){(type) | ((offset) << 11)})
 
-#define ZERO_PAGE(vaddr)	({ BUG(); NULL; })
+extern unsigned long empty_zero_page;
+extern unsigned long zero_page_mask;
 
-#define swapper_pg_dir ((pgd_t *) NULL)
+#define ZERO_PAGE(vaddr) \
+	(virt_to_page((void *)(empty_zero_page + \
+	 (((unsigned long)(vaddr)) & zero_page_mask))))
 
 #define pgtable_cache_init()	do {} while (0)
 
@@ -248,6 +258,7 @@ static inline pte_t pte_mkyoung(pte_t pte)
 #define pte_present(pte)	(pte_val(pte) & _PAGE_PRESENT)
 
 extern unsigned long pgd_current;
+extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern void paging_init(void);
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
diff --git a/arch/score/include/asm/ptrace.h b/arch/score/include/asm/ptrace.h
index 66b14c8..d40e691 100644
--- a/arch/score/include/asm/ptrace.h
+++ b/arch/score/include/asm/ptrace.h
@@ -51,9 +51,11 @@
  * system call/exception. As usual the registers k0/k1 aren't being saved.
  */
 struct pt_regs {
-	unsigned long pad0[6];
+	unsigned long pad0[6];	/* stack arguments */
 	unsigned long orig_r4;
 	unsigned long orig_r7;
+	long is_syscall;
+
 	unsigned long regs[32];
 
 	unsigned long cel;
@@ -68,12 +70,12 @@ struct pt_regs {
 	unsigned long cp0_psr;
 	unsigned long cp0_ecr;
 	unsigned long cp0_condition;
-
-	long is_syscall;
 };
 
 #ifdef __KERNEL__
 
+struct task_struct;
+
 /*
  * Does the process account for user or for system time?
  */
diff --git a/arch/score/include/asm/setup.h b/arch/score/include/asm/setup.h
index de89eff..3cb944d 100644
--- a/arch/score/include/asm/setup.h
+++ b/arch/score/include/asm/setup.h
@@ -2,7 +2,8 @@
 #define _ASM_SCORE_SETUP_H
 
 #define COMMAND_LINE_SIZE	256
-#define MEM_SIZE		0x2000000
+#define MEMORY_START		0
+#define MEMORY_SIZE		0x2000000
 
 #ifdef __KERNEL__
 
diff --git a/arch/score/include/asm/syscalls.h b/arch/score/include/asm/syscalls.h
index 00c28e0..1dd5e0d 100644
--- a/arch/score/include/asm/syscalls.h
+++ b/arch/score/include/asm/syscalls.h
@@ -1,8 +1,10 @@
 #ifndef _ASM_SCORE_SYSCALLS_H
 #define _ASM_SCORE_SYSCALLS_H
 
-asmlinkage long sys_clone(int flags, unsigned long stack, struct pt_regs *regs);
-#define sys_clone sys_clone
+asmlinkage long score_clone(struct pt_regs *regs);
+asmlinkage long score_execve(struct pt_regs *regs);
+asmlinkage long score_sigaltstack(struct pt_regs *regs);
+asmlinkage long score_rt_sigreturn(struct pt_regs *regs);
 
 #include <asm-generic/syscalls.h>
 
diff --git a/arch/score/include/asm/uaccess.h b/arch/score/include/asm/uaccess.h
index 43ce28a..6f09e2b 100644
--- a/arch/score/include/asm/uaccess.h
+++ b/arch/score/include/asm/uaccess.h
@@ -13,9 +13,9 @@ extern int fixup_exception(struct pt_regs *regs);
 #ifndef __ASSEMBLY__
 
 #define __range_ok(addr, size)					\
-	((((unsigned long)(addr) >= 0x80000000)			\
+	((((unsigned long __force)(addr) >= 0x80000000)			\
 	|| ((unsigned long)(size) > 0x80000000)			\
-	|| (((unsigned long)(addr) + (unsigned long)(size)) > 0x80000000)))
+	|| (((unsigned long __force)(addr) + (unsigned long)(size)) > 0x80000000)))
 
 #define __access_ok(addr, size) \
 	(__range_ok((addr), (size)) == 0)
diff --git a/arch/score/include/asm/ucontext.h b/arch/score/include/asm/ucontext.h
new file mode 100644
index 0000000..9bc07b9
--- /dev/null
+++ b/arch/score/include/asm/ucontext.h
@@ -0,0 +1 @@
+#include <asm-generic/ucontext.h>
diff --git a/arch/score/include/asm/unistd.h b/arch/score/include/asm/unistd.h
index f0f84de..0d98b72 100644
--- a/arch/score/include/asm/unistd.h
+++ b/arch/score/include/asm/unistd.h
@@ -2,7 +2,6 @@
 #define _ASM_SCORE_UNISTD_H
 
 #define __ARCH_HAVE_MMU
-#define __ARCH_WANT_IPC_PARSE_VERSION
 
 #include <asm-generic/unistd.h>
 
diff --git a/arch/score/include/asm/user.h b/arch/score/include/asm/user.h
index 3cf7572..7bfb8e2 100644
--- a/arch/score/include/asm/user.h
+++ b/arch/score/include/asm/user.h
@@ -1,4 +1,21 @@
 #ifndef _ASM_SCORE_USER_H
 #define _ASM_SCORE_USER_H
 
+struct user_regs_struct {
+	unsigned long regs[32];
+
+	unsigned long cel;
+	unsigned long ceh;
+
+	unsigned long sr0;	/* cnt */
+	unsigned long sr1;	/* lcr */
+	unsigned long sr2;	/* scr */
+
+	unsigned long cp0_epc;
+	unsigned long cp0_ema;
+	unsigned long cp0_psr;
+	unsigned long cp0_ecr;
+	unsigned long cp0_condition;
+};
+
 #endif /* _ASM_SCORE_USER_H */
diff --git a/arch/score/kernel/Makefile b/arch/score/kernel/Makefile
index 1e5de89..f218673 100644
--- a/arch/score/kernel/Makefile
+++ b/arch/score/kernel/Makefile
@@ -5,6 +5,7 @@
 extra-y	:= head.o vmlinux.lds
 
 obj-y += entry.o init_task.o irq.o process.o ptrace.o \
-	setup.o signal.o sys_score.o time.o traps.o
+	setup.o signal.o sys_score.o time.o traps.o \
+	sys_call_table.o
 
 obj-$(CONFIG_MODULES) += module.o
diff --git a/arch/score/kernel/entry.S b/arch/score/kernel/entry.S
index 0af89b2..10e859d 100644
--- a/arch/score/kernel/entry.S
+++ b/arch/score/kernel/entry.S
@@ -395,6 +395,8 @@ ENTRY(resume)
 
 ENTRY(handle_sys)
 	SAVE_ALL
+	sw	r8, [r0, 16]		# argument 5 from user r8
+	sw	r9, [r0, 20]		# argument 6 from user r9
 	enable_irq
 
 	sw	r4, [r0, PT_ORIG_R4]	#for restart syscall
@@ -408,19 +410,14 @@ ENTRY(handle_sys)
 	cmpi.c	r27, __NR_syscalls 	# check syscall number
 	bgtu	illegal_syscall
 
-	slli	r8, r27, 3		# get syscall routine
+	slli	r8, r27, 2		# get syscall routine
 	la	r11, sys_call_table
 	add	r11, r11, r8
 	lw	r10, [r11]		# get syscall entry
-	lw	r11, [r11, 4]		# get number of args
 
 	cmpz.c	r10
 	beq	illegal_syscall
 
-	cmpi.c	r11, 4			# more than 4 arguments?
-	bgtu	stackargs
-
-stack_done:
 	lw	r8, [r28, TI_FLAGS]
 	li	r9, _TIF_SYSCALL_TRACE
 	and.c	r8, r8, r9
@@ -475,44 +472,6 @@ syscall_trace_entry:
 1:	sw	r4, [r0, PT_R2]		# result
 	j	syscall_exit
 
-stackargs:
-	lw	r8, [r0, PT_R0]
-	andri.c	r9, r8, 3		# test whether user sp is align a word
-	bne	bad_stack
-	subi	r11, 5
-	slli	r9, r11, 2
-	add.c	r9, r9, r8
-
-	bmi	bad_stack
-	la	r9, 3f			# calculate branch address
-	slli	r11, r11, 3
-	sub	r9, r9, r11
-	br	r9
-
-2:	lw	r9, [r8, 20]		# argument 6 from usp
-	sw	r9, [r0, 20]
-
-3:	lw	r9, [r8, 16]		# argument 5 from usp
-	sw	r9, [r0, 16]
-	j	stack_done
-
-	.section __ex_table,"a"
-	.word	2b, bad_stack
-	.word	3b, bad_stack
-	.previous
-
-	/*
-	 * The stackpointer for a call with more than 4 arguments is bad.
-	 * We probably should handle this case a bit more drastic.
-	 */
-bad_stack:
-	neg	r27, r27		# error
-	sw	r27, [r0, PT_ORIG_R4]
-	sw	r27, [r0, PT_R4]
-	ldi	r8, 1			# set error flag
-	sw	r8, [r0, PT_R7]
-	j	syscall_return
-
 illegal_syscall:
 	ldi	r4, -ENOSYS		# error
 	sw	r4, [r0, PT_ORIG_R4]
diff --git a/arch/score/kernel/init_task.c b/arch/score/kernel/init_task.c
index 9eecde0..54d9552 100644
--- a/arch/score/kernel/init_task.c
+++ b/arch/score/kernel/init_task.c
@@ -26,8 +26,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-EXPORT_SYMBOL(init_mm);
 
 /*
  * Initial thread structure.
diff --git a/arch/score/kernel/irq.c b/arch/score/kernel/irq.c
index 55474e8..47647dd 100644
--- a/arch/score/kernel/irq.c
+++ b/arch/score/kernel/irq.c
@@ -29,6 +29,19 @@
 
 #include <asm/io.h>
 
+/* the interrupt controller is hardcoded at this address */
+#define SCORE_PIC		((u32 __iomem __force *)0x95F50000)
+
+#define INT_PNDL		0
+#define INT_PNDH		1
+#define INT_PRIORITY_M		2
+#define INT_PRIORITY_SG0	4
+#define INT_PRIORITY_SG1	5
+#define INT_PRIORITY_SG2	6
+#define INT_PRIORITY_SG3	7
+#define INT_MASKL		8
+#define INT_MASKH		9
+
 /*
  * handles all normal device IRQs
  */
@@ -44,11 +57,11 @@ static void score_mask(unsigned int irq_nr)
 	unsigned int irq_source = 63 - irq_nr;
 
 	if (irq_source < 32)
-		__raw_writel((__raw_readl((void *)P_INT_MASKL) | \
-			(1 << irq_source)), (void *)P_INT_MASKL);
+		__raw_writel((__raw_readl(SCORE_PIC + INT_MASKL) | \
+			(1 << irq_source)), SCORE_PIC + INT_MASKL);
 	else
-		__raw_writel((__raw_readl((void *)P_INT_MASKH) | \
-			(1 << (irq_source - 32))), (void *)P_INT_MASKH);
+		__raw_writel((__raw_readl(SCORE_PIC + INT_MASKH) | \
+			(1 << (irq_source - 32))), SCORE_PIC + INT_MASKH);
 }
 
 static void score_unmask(unsigned int irq_nr)
@@ -56,11 +69,11 @@ static void score_unmask(unsigned int irq_nr)
 	unsigned int irq_source = 63 - irq_nr;
 
 	if (irq_source < 32)
-		__raw_writel((__raw_readl((void *)P_INT_MASKL) & \
-			~(1 << irq_source)), (void *)P_INT_MASKL);
+		__raw_writel((__raw_readl(SCORE_PIC + INT_MASKL) & \
+			~(1 << irq_source)), SCORE_PIC + INT_MASKL);
 	else
-		__raw_writel((__raw_readl((void *)P_INT_MASKH) & \
-			~(1 << (irq_source - 32))), (void *)P_INT_MASKH);
+		__raw_writel((__raw_readl(SCORE_PIC + INT_MASKH) & \
+			~(1 << (irq_source - 32))), SCORE_PIC + INT_MASKH);
 }
 
 struct irq_chip score_irq_chip = {
@@ -88,8 +101,8 @@ void __init init_IRQ(void)
 		memcpy((void *)target_addr, \
 			interrupt_exception_vector, IRQ_VECTOR_SIZE);
 
-	__raw_writel(0xffffffff, (void *)P_INT_MASKL);
-	__raw_writel(0xffffffff, (void *)P_INT_MASKH);
+	__raw_writel(0xffffffff, SCORE_PIC + INT_MASKL);
+	__raw_writel(0xffffffff, SCORE_PIC + INT_MASKH);
 
 	__asm__ __volatile__(
 		"mtcr	%0, cr3\n\t"
diff --git a/arch/score/kernel/module.c b/arch/score/kernel/module.c
index 4ffce7f..4de8d47 100644
--- a/arch/score/kernel/module.c
+++ b/arch/score/kernel/module.c
@@ -23,6 +23,7 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <linux/moduleloader.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 
@@ -56,17 +57,17 @@ int apply_relocate(Elf_Shdr *sechdrs, const char *strtab,
 	for (i = 0; i < relsec->sh_size / sizeof(Elf32_Rel); i++, rel++) {
 		unsigned long loc;
 		Elf32_Sym *sym;
-		s32 offset;
+		s32 r_offset;
 
-		offset = ELF32_R_SYM(rel->r_info);
-		if ((offset < 0) ||
-		    (offset > (symsec->sh_size / sizeof(Elf32_Sym)))) {
+		r_offset = ELF32_R_SYM(rel->r_info);
+		if ((r_offset < 0) ||
+		    (r_offset > (symsec->sh_size / sizeof(Elf32_Sym)))) {
 			printk(KERN_ERR "%s: bad relocation, section %d reloc %d\n",
 				me->name, relindex, i);
 				return -ENOEXEC;
 		}
 
-		sym = ((Elf32_Sym *)symsec->sh_addr) + offset;
+		sym = ((Elf32_Sym *)symsec->sh_addr) + r_offset;
 
 		if ((rel->r_offset < 0) ||
 		    (rel->r_offset > dstsec->sh_size - sizeof(u32))) {
@@ -151,7 +152,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 /* Given an address, look for it in the module exception tables. */
 const struct exception_table_entry *search_module_dbetables(unsigned long addr)
 {
-	return 0;
+	return NULL;
 }
 
 /* Put in dbe list if necessary. */
diff --git a/arch/score/kernel/process.c b/arch/score/kernel/process.c
index d93966f..25d0803 100644
--- a/arch/score/kernel/process.c
+++ b/arch/score/kernel/process.c
@@ -24,6 +24,9 @@
  */
 
 #include <linux/module.h>
+#include <linux/reboot.h>
+#include <linux/elfcore.h>
+#include <linux/pm.h>
 
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
diff --git a/arch/score/kernel/ptrace.c b/arch/score/kernel/ptrace.c
index 19911e3..174c642 100644
--- a/arch/score/kernel/ptrace.c
+++ b/arch/score/kernel/ptrace.c
@@ -23,11 +23,100 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <linux/elf.h>
 #include <linux/kernel.h>
+#include <linux/mm.h>
 #include <linux/ptrace.h>
+#include <linux/regset.h>
 
 #include <asm/uaccess.h>
 
+/*
+ * retrieve the contents of SCORE userspace general registers
+ */
+static int genregs_get(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       void *kbuf, void __user *ubuf)
+{
+	const struct pt_regs *regs = task_pt_regs(target);
+	int ret;
+
+	/* skip 9 * sizeof(unsigned long) not use for pt_regs */
+	ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+					0, offsetof(struct pt_regs, regs));
+
+	/* r0 - r31, cel, ceh, sr0, sr1, sr2, epc, ema, psr, ecr, condition */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  regs->regs,
+				  offsetof(struct pt_regs, regs),
+				  offsetof(struct pt_regs, cp0_condition));
+
+	if (!ret)
+		ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+						sizeof(struct pt_regs), -1);
+
+	return ret;
+}
+
+/*
+ * update the contents of the SCORE userspace general registers
+ */
+static int genregs_set(struct task_struct *target,
+		       const struct user_regset *regset,
+		       unsigned int pos, unsigned int count,
+		       const void *kbuf, const void __user *ubuf)
+{
+	struct pt_regs *regs = task_pt_regs(target);
+	int ret;
+
+	/* skip 9 * sizeof(unsigned long) */
+	ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					0, offsetof(struct pt_regs, regs));
+
+	/* r0 - r31, cel, ceh, sr0, sr1, sr2, epc, ema, psr, ecr, condition */
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				  regs->regs,
+				  offsetof(struct pt_regs, regs),
+				  offsetof(struct pt_regs, cp0_condition));
+
+	if (!ret)
+		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+						sizeof(struct pt_regs), -1);
+
+	return ret;
+}
+
+/*
+ * Define the register sets available on the score7 under Linux
+ */
+enum score7_regset {
+	REGSET_GENERAL,
+};
+
+static const struct user_regset score7_regsets[] = {
+	[REGSET_GENERAL] = {
+		.core_note_type	= NT_PRSTATUS,
+		.n		= ELF_NGREG,
+		.size		= sizeof(long),
+		.align		= sizeof(long),
+		.get		= genregs_get,
+		.set		= genregs_set,
+	},
+};
+
+static const struct user_regset_view user_score_native_view = {
+	.name		= "score7",
+	.e_machine	= EM_SCORE7,
+	.regsets	= score7_regsets,
+	.n		= ARRAY_SIZE(score7_regsets),
+};
+
+const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+{
+	return &user_score_native_view;
+}
+
 static int is_16bitinsn(unsigned long insn)
 {
 	if ((insn & INSN32_MASK) == INSN32_MASK)
@@ -80,34 +169,6 @@ write_tsk_long(struct task_struct *child,
 	return copied != sizeof(val) ? -EIO : 0;
 }
 
-/*
- * Get all user integer registers.
- */
-static int ptrace_getregs(struct task_struct *tsk, void __user *uregs)
-{
-	struct pt_regs *regs = task_pt_regs(tsk);
-
-	return copy_to_user(uregs, regs, sizeof(struct pt_regs)) ? -EFAULT : 0;
-}
-
-/*
- * Set all user integer registers.
- */
-static int ptrace_setregs(struct task_struct *tsk, void __user *uregs)
-{
-	struct pt_regs newregs;
-	int ret;
-
-	ret = -EFAULT;
-	if (copy_from_user(&newregs, uregs, sizeof(struct pt_regs)) == 0) {
-		struct pt_regs *regs = task_pt_regs(tsk);
-		*regs = newregs;
-		ret = 0;
-	}
-
-	return ret;
-}
-
 void user_enable_single_step(struct task_struct *child)
 {
 	/* far_epc is the target of branch */
@@ -267,99 +328,21 @@ long
 arch_ptrace(struct task_struct *child, long request, long addr, long data)
 {
 	int ret;
+	unsigned long __user *datap = (void __user *)data;
 
 	switch (request) {
-	/* Read the word at location addr in the USER area.  */
-	case PTRACE_PEEKUSR: {
-		struct pt_regs *regs;
-		unsigned long tmp;
-
-		regs = task_pt_regs(child);
-
-		tmp = 0;  /* Default return value. */
-		switch (addr) {
-		case 0 ... 31:
-			tmp = regs->regs[addr];
-			break;
-		case PC:
-			tmp = regs->cp0_epc;
-			break;
-		case ECR:
-			tmp = regs->cp0_ecr;
-			break;
-		case EMA:
-			tmp = regs->cp0_ema;
-			break;
-		case CEH:
-			tmp = regs->ceh;
-			break;
-		case CEL:
-			tmp = regs->cel;
-			break;
-		case CONDITION:
-			tmp = regs->cp0_condition;
-			break;
-		case PSR:
-			tmp = regs->cp0_psr;
-			break;
-		case COUNTER:
-			tmp = regs->sr0;
-			break;
-		case LDCR:
-			tmp = regs->sr1;
-			break;
-		case STCR:
-			tmp = regs->sr2;
-			break;
-		default:
-			tmp = 0;
-			return -EIO;
-		}
-
-		ret = put_user(tmp, (unsigned long *) data);
-		return ret;
-	}
-
-	case PTRACE_POKEUSR: {
-		struct pt_regs *regs;
-		ret = 0;
-		regs = task_pt_regs(child);
-
-		switch (addr) {
-		case 0 ... 31:
-			regs->regs[addr] = data;
-			break;
-		case PC:
-			regs->cp0_epc = data;
-			break;
-		case CEH:
-			regs->ceh = data;
-			break;
-		case CEL:
-			regs->cel = data;
-			break;
-		case CONDITION:
-			regs->cp0_condition = data;
-			break;
-		case PSR:
-		case COUNTER:
-		case STCR:
-		case LDCR:
-			break; /* user can't write the reg */
-		default:
-			/* The rest are not allowed. */
-			ret = -EIO;
-			break;
-		}
-		break;
-	}
-
 	case PTRACE_GETREGS:
-		ret = ptrace_getregs(child, (void __user *)data);
+		ret = copy_regset_to_user(child, &user_score_native_view,
+						REGSET_GENERAL,
+						0, sizeof(struct pt_regs),
+						(void __user *)datap);
 		break;
 
 	case PTRACE_SETREGS:
-		ret = ptrace_setregs(child, (void __user *)data);
+		ret = copy_regset_from_user(child, &user_score_native_view,
+						REGSET_GENERAL,
+						0, sizeof(struct pt_regs),
+						(const void __user *)datap);
 		break;
 
 	default:
diff --git a/arch/score/kernel/setup.c b/arch/score/kernel/setup.c
index a172ce1..6a2503c 100644
--- a/arch/score/kernel/setup.c
+++ b/arch/score/kernel/setup.c
@@ -26,10 +26,12 @@
 #include <linux/bootmem.h>
 #include <linux/initrd.h>
 #include <linux/ioport.h>
+#include <linux/mm.h>
 #include <linux/seq_file.h>
 #include <linux/screen_info.h>
 
 #include <asm-generic/sections.h>
+#include <asm/setup.h>
 
 struct screen_info screen_info;
 unsigned long kernelsp;
@@ -40,25 +42,25 @@ static struct resource data_resource = { .name = "Kernel data",};
 
 static void __init bootmem_init(void)
 {
-	unsigned long reserved_end, bootmap_size;
+	unsigned long start_pfn, bootmap_size;
 	unsigned long size = initrd_end - initrd_start;
 
-	reserved_end = (unsigned long)_end;
+	start_pfn = PFN_UP(__pa(&_end));
 
-	min_low_pfn = 0;
-	max_low_pfn = MEM_SIZE / PAGE_SIZE;
+	min_low_pfn = PFN_UP(MEMORY_START);
+	max_low_pfn = PFN_UP(MEMORY_START + MEMORY_SIZE);
 
 	/* Initialize the boot-time allocator with low memory only. */
-	bootmap_size = init_bootmem_node(NODE_DATA(0), reserved_end,
+	bootmap_size = init_bootmem_node(NODE_DATA(0), start_pfn,
 					 min_low_pfn, max_low_pfn);
 	add_active_range(0, min_low_pfn, max_low_pfn);
 
-	free_bootmem(PFN_PHYS(reserved_end),
-		     (max_low_pfn - reserved_end) << PAGE_SHIFT);
-	memory_present(0, reserved_end, max_low_pfn);
+	free_bootmem(PFN_PHYS(start_pfn),
+		     (max_low_pfn - start_pfn) << PAGE_SHIFT);
+	memory_present(0, start_pfn, max_low_pfn);
 
 	/* Reserve space for the bootmem bitmap. */
-	reserve_bootmem(PFN_PHYS(reserved_end), bootmap_size, BOOTMEM_DEFAULT);
+	reserve_bootmem(PFN_PHYS(start_pfn), bootmap_size, BOOTMEM_DEFAULT);
 
 	if (size == 0) {
 		printk(KERN_INFO "Initrd not found or empty");
@@ -87,15 +89,15 @@ static void __init resource_init(void)
 {
 	struct resource *res;
 
-	code_resource.start = (unsigned long)_text;
-	code_resource.end = (unsigned long)_etext - 1;
-	data_resource.start = (unsigned long)_etext;
-	data_resource.end = (unsigned long)_edata - 1;
+	code_resource.start = __pa(&_text);
+	code_resource.end = __pa(&_etext) - 1;
+	data_resource.start = __pa(&_etext);
+	data_resource.end = __pa(&_edata) - 1;
 
 	res = alloc_bootmem(sizeof(struct resource));
 	res->name = "System RAM";
-	res->start = 0;
-	res->end = MEM_SIZE - 1;
+	res->start = MEMORY_START;
+	res->end = MEMORY_START + MEMORY_SIZE - 1;
 	res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 	request_resource(&iomem_resource, res);
 
diff --git a/arch/score/kernel/signal.c b/arch/score/kernel/signal.c
index 5c00408..950f87c 100644
--- a/arch/score/kernel/signal.c
+++ b/arch/score/kernel/signal.c
@@ -27,7 +27,9 @@
 #include <linux/signal.h>
 #include <linux/unistd.h>
 #include <linux/uaccess.h>
-#include <asm-generic/ucontext.h>
+
+#include <asm/syscalls.h>
+#include <asm/ucontext.h>
 
 #include <asm/cacheflush.h>
 
@@ -40,7 +42,7 @@ struct rt_sigframe {
 	struct ucontext rs_uc;
 };
 
-int setup_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
+static int setup_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
 {
 	int err = 0;
 	unsigned long reg;
@@ -74,7 +76,7 @@ int setup_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
 	return err;
 }
 
-int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
+static int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
 {
 	int err = 0;
 	u32 reg;
@@ -116,8 +118,8 @@ int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
 /*
  * Determine which stack to use..
  */
-void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
-			size_t frame_size)
+static void __user *get_sigframe(struct k_sigaction *ka,
+			struct pt_regs *regs, size_t frame_size)
 {
 	unsigned long sp;
 
@@ -129,19 +131,21 @@ void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 	if ((ka->sa.sa_flags & SA_ONSTACK) && (!on_sig_stack(sp)))
 		sp = current->sas_ss_sp + current->sas_ss_size;
 
-	return (void *)((sp - frame_size) & ~7);
+	return (void __user*)((sp - frame_size) & ~7);
 }
 
-int score_sigaltstack(struct pt_regs *regs)
+asmlinkage long
+score_sigaltstack(struct pt_regs *regs)
 {
-	const stack_t *uss = (const stack_t *) regs->regs[4];
-	stack_t *uoss = (stack_t *) regs->regs[5];
+	const stack_t __user *uss = (const stack_t __user *) regs->regs[4];
+	stack_t __user *uoss = (stack_t __user *) regs->regs[5];
 	unsigned long usp = regs->regs[0];
 
 	return do_sigaltstack(uss, uoss, usp);
 }
 
-void score_rt_sigreturn(struct pt_regs *regs)
+asmlinkage long
+score_rt_sigreturn(struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	sigset_t set;
@@ -181,12 +185,14 @@ void score_rt_sigreturn(struct pt_regs *regs)
 
 badframe:
 	force_sig(SIGSEGV, current);
+
+	return 0;
 }
 
-int setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
+static int setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
 		int signr, sigset_t *set, siginfo_t *info)
 {
-	struct rt_sigframe *frame;
+	struct rt_sigframe __user *frame;
 	int err = 0;
 
 	frame = get_sigframe(ka, regs, sizeof(*frame));
@@ -206,8 +212,8 @@ int setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
 
 	err |= copy_siginfo_to_user(&frame->rs_info, info);
 	err |= __put_user(0, &frame->rs_uc.uc_flags);
-	err |= __put_user(0, &frame->rs_uc.uc_link);
-	err |= __put_user((void *)current->sas_ss_sp,
+	err |= __put_user(NULL, &frame->rs_uc.uc_link);
+	err |= __put_user((void __user *)current->sas_ss_sp,
 				&frame->rs_uc.uc_stack.ss_sp);
 	err |= __put_user(sas_ss_flags(regs->regs[0]),
 				&frame->rs_uc.uc_stack.ss_flags);
@@ -236,7 +242,7 @@ give_sigsegv:
 	return -EFAULT;
 }
 
-int handle_signal(unsigned long sig, siginfo_t *info,
+static int handle_signal(unsigned long sig, siginfo_t *info,
 	struct k_sigaction *ka, sigset_t *oldset, struct pt_regs *regs)
 {
 	int ret;
@@ -276,7 +282,7 @@ int handle_signal(unsigned long sig, siginfo_t *info,
 	return ret;
 }
 
-void do_signal(struct pt_regs *regs)
+static void do_signal(struct pt_regs *regs)
 {
 	struct k_sigaction ka;
 	sigset_t *oldset;
diff --git a/arch/score/kernel/sys_call_table.c b/arch/score/kernel/sys_call_table.c
new file mode 100644
index 0000000..287369b
--- /dev/null
+++ b/arch/score/kernel/sys_call_table.c
@@ -0,0 +1,12 @@
+#include <linux/syscalls.h>
+#include <linux/signal.h>
+#include <linux/unistd.h>
+
+#include <asm/syscalls.h>
+
+#undef __SYSCALL
+#define __SYSCALL(nr, call) [nr] = (call),
+
+void *sys_call_table[__NR_syscalls] = {
+#include <asm/unistd.h>
+};
diff --git a/arch/score/kernel/sys_score.c b/arch/score/kernel/sys_score.c
index 68655f4..61aff8a 100644
--- a/arch/score/kernel/sys_score.c
+++ b/arch/score/kernel/sys_score.c
@@ -28,11 +28,10 @@
 #include <linux/mman.h>
 #include <linux/module.h>
 #include <linux/unistd.h>
+#include <linux/syscalls.h>
+#include <asm/syscalls.h>
 
-unsigned long shm_align_mask = PAGE_SIZE - 1;
-EXPORT_SYMBOL(shm_align_mask);
-
-asmlinkage unsigned long
+asmlinkage long 
 sys_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
 	  unsigned long flags, unsigned long fd, unsigned long pgoff)
 {
@@ -64,7 +63,8 @@ sys_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
  * Clone a task - this clones the calling program thread.
  * This is called indirectly via a small wrapper
  */
-int score_clone(struct pt_regs *regs)
+asmlinkage long
+score_clone(struct pt_regs *regs)
 {
 	unsigned long clone_flags;
 	unsigned long newsp;
@@ -75,14 +75,7 @@ int score_clone(struct pt_regs *regs)
 	if (!newsp)
 		newsp = regs->regs[0];
 	parent_tidptr = (int __user *)regs->regs[6];
-
-	child_tidptr = NULL;
-	if (clone_flags & (CLONE_CHILD_SETTID | CLONE_CHILD_CLEARTID)) {
-		int __user *__user *usp = (int __user *__user *)regs->regs[0];
-
-		if (get_user(child_tidptr, &usp[4]))
-			return -EFAULT;
-	}
+	child_tidptr = (int __user *)regs->regs[8];
 
 	return do_fork(clone_flags, newsp, regs, 0,
 			parent_tidptr, child_tidptr);
@@ -92,33 +85,25 @@ int score_clone(struct pt_regs *regs)
  * sys_execve() executes a new program.
  * This is called indirectly via a small wrapper
  */
-int score_execve(struct pt_regs *regs)
+asmlinkage long
+score_execve(struct pt_regs *regs)
 {
 	int error;
 	char *filename;
 
-	filename = getname((char *) (long) regs->regs[4]);
+	filename = getname((char __user*)regs->regs[4]);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		return error;
 
-	error = do_execve(filename, (char **) (long) regs->regs[5],
-			  (char **) (long) regs->regs[6], regs);
+	error = do_execve(filename, (char __user *__user*)regs->regs[5],
+			  (char __user *__user *) regs->regs[6], regs);
 
 	putname(filename);
 	return error;
 }
 
 /*
- * If we ever come here the user sp is bad.  Zap the process right away.
- * Due to the bad stack signaling wouldn't work.
- */
-void bad_stack(void)
-{
-	do_exit(SIGSEGV);
-}
-
-/*
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
diff --git a/arch/score/kernel/time.c b/arch/score/kernel/time.c
index cd66ba3..f0a43af 100644
--- a/arch/score/kernel/time.c
+++ b/arch/score/kernel/time.c
@@ -28,7 +28,7 @@
 
 #include <asm/scoreregs.h>
 
-irqreturn_t timer_interrupt(int irq, void *dev_id)
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 	struct clock_event_device *evdev = dev_id;
 
diff --git a/arch/score/lib/string.S b/arch/score/lib/string.S
index 943d091..00b7d3a 100644
--- a/arch/score/lib/string.S
+++ b/arch/score/lib/string.S
@@ -182,15 +182,3 @@ ENTRY(__clear_user)
 99:
 	.word	0b, 99b
 	.previous
-
-	.align	2
-ENTRY(__put_user_unknown)
-	.set volatile
-	ldi	r4, -EFAULT
-	br	r3
-
-	.align	2
-ENTRY(__get_user_unknown)
-	ldi	r5, 0
-	ldi	r4, -EFAULT
-	br	r3
diff --git a/arch/score/mm/init.c b/arch/score/mm/init.c
index 7780eec..4e3dcd0 100644
--- a/arch/score/mm/init.c
+++ b/arch/score/mm/init.c
@@ -32,44 +32,30 @@
 #include <linux/pagemap.h>
 #include <linux/proc_fs.h>
 #include <linux/sched.h>
-#include <asm-generic/sections.h>
+#include <linux/initrd.h>
 
+#include <asm/sections.h>
 #include <asm/tlb.h>
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-/*
- * We have up to 8 empty zeroed pages so we can map one of the right colour
- * when needed.
- */
-unsigned long zero_page_mask;
 unsigned long empty_zero_page;
 EXPORT_SYMBOL_GPL(empty_zero_page);
 
 static struct kcore_list kcore_mem, kcore_vmalloc;
 
-unsigned long setup_zero_pages(void)
+static unsigned long setup_zero_page(void)
 {
-	unsigned int order = 0;
-	unsigned long size;
 	struct page *page;
 
-	empty_zero_page = __get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
+	empty_zero_page = __get_free_pages(GFP_KERNEL | __GFP_ZERO, 0);
 	if (!empty_zero_page)
 		panic("Oh boy, that early out of memory?");
 
 	page = virt_to_page((void *) empty_zero_page);
-	split_page(page, order);
-	while (page < virt_to_page((void *) (empty_zero_page +
-					     (PAGE_SIZE << order)))) {
-		SetPageReserved(page);
-		page++;
-	}
-
-	size = PAGE_SIZE << order;
-	zero_page_mask = (size - 1) & PAGE_MASK;
+	SetPageReserved(page);
 
-	return 1UL << order;
+	return 1UL;
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -100,7 +86,7 @@ void __init mem_init(void)
 	max_mapnr = max_low_pfn;
 	high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
 	totalram_pages += free_all_bootmem();
-	totalram_pages -= setup_zero_pages();	/* Setup zeroed pages. */
+	totalram_pages -= setup_zero_page();	/* Setup zeroed pages. */
 	reservedpages = 0;
 
 	for (tmp = 0; tmp < max_low_pfn; tmp++)
@@ -129,7 +115,7 @@ void __init mem_init(void)
 }
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
-void free_init_pages(const char *what, unsigned long begin, unsigned long end)
+static void free_init_pages(const char *what, unsigned long begin, unsigned long end)
 {
 	unsigned long pfn;
 
@@ -150,15 +136,16 @@ void free_init_pages(const char *what, unsigned long begin, unsigned long end)
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
 	free_init_pages("initrd memory",
-	virt_to_phys((void *) start),
-	virt_to_phys((void *) end));
+		virt_to_phys((void *) start),
+		virt_to_phys((void *) end));
 }
 #endif
 
 void __init_refok free_initmem(void)
 {
 	free_init_pages("unused kernel memory",
-	    (unsigned long)__init_begin, (unsigned long)__init_end);
+	__pa(&__init_begin),
+	__pa(&__init_end));
 }
 
 unsigned long pgd_current;
@@ -170,4 +157,5 @@ unsigned long pgd_current;
  * are constants.  So we use the variants from asm-offset.h until that gcc
  * will officially be retired.
  */
+pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned(PTE_ORDER);
 pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned(PTE_ORDER);
diff --git a/arch/score/mm/pgtable.c b/arch/score/mm/pgtable.c
index 10b0962..6408bb7 100644
--- a/arch/score/mm/pgtable.c
+++ b/arch/score/mm/pgtable.c
@@ -47,14 +47,6 @@ void pgd_init(unsigned long page)
 
 void __init pagetable_init(void)
 {
-	unsigned long vaddr;
-	pgd_t *pgd_base;
-
 	/* Initialize the entire pgd. */
-	pgd_init((unsigned long) swapper_pg_dir);
-	pgd_init((unsigned long) swapper_pg_dir
-		+ sizeof(pgd_t) * USER_PTRS_PER_PGD);
-
-	pgd_base = swapper_pg_dir;
-	vaddr = __fix_to_virt(__end_of_fixed_addresses - 1) & PMD_MASK;
+	pgd_init((unsigned long)swapper_pg_dir);
 }
