Return-Path: <linux-kernel-owner+w=401wt.eu-S934634AbXEVRhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934634AbXEVRhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758139AbXEVRh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:37:28 -0400
Received: from [216.16.235.2] ([216.16.235.2]:33682 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757901AbXEVRh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:37:26 -0400
X-Originating-Ip: 72.143.65.211
Date: Tue, 22 May 2007 13:35:50 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Delete every useless reference to NORET_TYPE in the tree.
Message-ID: <Pine.LNX.4.64.0705221321390.17073@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Delete every reference to NORET_TYPE in the tree, based on the
explanation found here:

  http://www.ussg.iu.edu/hypermail/linux/kernel/9605/1957.html

which shows that that macro hasn't had a value since gcc-2.2.5, when
it was defined to equal "__volatile__".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  while there may be other cleanups that can be done at the same time
in the vicinity of the patches below, i'd really like to just go with
this for now to keep this as one logical patch that (theoretically)
has no effect on the actual build of the tree.  other kinds of cleanup
will be submitted as future patches.

  (simply assuming that developers were using NORET_TYPE to mean
__noreturn can't be right, as there are cases where you can see that
some developers were using both NORET_TYPE and ATTRIB_NORET at the
same time.  so i'm just not going down that road right now.)

  this patch was compile-tested with "make allyesconfig", and the
output between the two builds was "diff"ed to show that the only
difference from the original build to the patched one was the
following:

7524,7531c7524,7531
< c01543a9 02612e01   R_386_32 c1a690a0  __stop___ksymtab_unused
< c01543ae 024d5701   R_386_32 c1a690a0  __start___ksymtab_unused
< c01543cc 024d5701   R_386_32 c1a690a0  __start___ksymtab_unused
< c01543d3 02582001   R_386_32 c1a6fe40  __start___kcrctab_unused
< c01543e7 02917801   R_386_32 c1a690a0  __stop___ksymtab_unused_gpl
< c01543ec 0230c301   R_386_32 c1a690a0  __start___ksymtab_unused_gpl
< c0154407 0230c301   R_386_32 c1a690a0  __start___ksymtab_unused_gpl
< c015440e 02356901   R_386_32 c1a6fe40  __start___kcrctab_unused_gpl
---
> c01543a9 02612e01   R_386_32 c1a690a4  __stop___ksymtab_unused
> c01543ae 024d5701   R_386_32 c1a690a4  __start___ksymtab_unused
> c01543cc 024d5701   R_386_32 c1a690a4  __start___ksymtab_unused
> c01543d3 02582001   R_386_32 c1a6fe44  __start___kcrctab_unused
> c01543e7 02917801   R_386_32 c1a690a4  __stop___ksymtab_unused_gpl
> c01543ec 0230c301   R_386_32 c1a690a4  __start___ksymtab_unused_gpl
> c0154407 0230c301   R_386_32 c1a690a4  __start___ksymtab_unused_gpl
> c015440e 02356901   R_386_32 c1a6fe44  __start___kcrctab_unused_gpl
7543c7543
< System is 15369 kB
---
> System is 15370 kB

  am i safe to assume that that's only the difference in the symbol
table due to the removal of that macro?  'cuz if it's anything more
significant, then i'm confused.


 arch/arm/kernel/traps.c                |    2 +-
 arch/arm26/kernel/traps.c              |    2 +-
 arch/avr32/kernel/traps.c              |    2 +-
 arch/i386/kernel/machine_kexec.c       |    2 +-
 arch/ia64/kernel/machine_kexec.c       |    2 +-
 arch/m68k/amiga/config.c               |    2 +-
 arch/mips/kernel/traps.c               |    2 +-
 arch/powerpc/kernel/machine_kexec.c    |    2 +-
 arch/powerpc/kernel/machine_kexec_32.c |    2 +-
 arch/powerpc/kernel/machine_kexec_64.c |    2 +-
 arch/ppc/amiga/config.c                |    2 +-
 arch/ppc/kernel/machine_kexec.c        |    4 ++--
 arch/sh/kernel/machine_kexec.c         |    4 ++--
 arch/x86_64/kernel/machine_kexec.c     |    2 +-
 drivers/s390/s390mach.c                |    2 +-
 include/asm-avr32/system.h             |    2 +-
 include/asm-i386/kexec.h               |    2 +-
 include/asm-mips/ptrace.h              |    2 +-
 include/asm-x86_64/kexec.h             |    2 +-
 include/linux/ext3_fs.h                |    1 -
 include/linux/ext4_fs.h                |    1 -
 include/linux/kernel.h                 |    6 +++---
 include/linux/kexec.h                  |    2 +-
 include/linux/linkage.h                |    1 -
 include/linux/sched.h                  |    2 +-
 kernel/exit.c                          |    6 +++---
 kernel/panic.c                         |    2 +-
 27 files changed, 30 insertions(+), 33 deletions(-)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 10ff36e..d6033a6 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -228,7 +228,7 @@ DEFINE_SPINLOCK(die_lock);
 /*
  * This function is protected against re-entrancy.
  */
-NORET_TYPE void die(const char *str, struct pt_regs *regs, int err)
+void die(const char *str, struct pt_regs *regs, int err)
 {
 	struct thread_info *thread = current_thread_info();

diff --git a/arch/arm26/kernel/traps.c b/arch/arm26/kernel/traps.c
index d594fb5..5ab058d 100644
--- a/arch/arm26/kernel/traps.c
+++ b/arch/arm26/kernel/traps.c
@@ -175,7 +175,7 @@ DEFINE_SPINLOCK(die_lock);
 /*
  * This function is protected against re-entrancy.
  */
-NORET_TYPE void die(const char *str, struct pt_regs *regs, int err)
+void die(const char *str, struct pt_regs *regs, int err)
 {
 	struct task_struct *tsk = current;

diff --git a/arch/avr32/kernel/traps.c b/arch/avr32/kernel/traps.c
index 86d1075..4a06745 100644
--- a/arch/avr32/kernel/traps.c
+++ b/arch/avr32/kernel/traps.c
@@ -22,7 +22,7 @@

 static DEFINE_SPINLOCK(die_lock);

-void NORET_TYPE die(const char *str, struct pt_regs *regs, long err)
+void die(const char *str, struct pt_regs *regs, long err)
 {
 	static int die_counter;

diff --git a/arch/i386/kernel/machine_kexec.c b/arch/i386/kernel/machine_kexec.c
index 91966ba..2a1e5ff 100644
--- a/arch/i386/kernel/machine_kexec.c
+++ b/arch/i386/kernel/machine_kexec.c
@@ -101,7 +101,7 @@ void machine_kexec_cleanup(struct kimage *image)
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
diff --git a/arch/ia64/kernel/machine_kexec.c b/arch/ia64/kernel/machine_kexec.c
index 4f0f3b8..8756d0c 100644
--- a/arch/ia64/kernel/machine_kexec.c
+++ b/arch/ia64/kernel/machine_kexec.c
@@ -20,7 +20,7 @@
 #include <asm/delay.h>
 #include <asm/meminit.h>

-typedef NORET_TYPE void (*relocate_new_kernel_t)(
+typedef void (*relocate_new_kernel_t)(
 					unsigned long indirection_page,
 					unsigned long start_address,
 					struct ia64_boot_param *boot_param,
diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index 3574853..f6c54d7 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -674,7 +674,7 @@ static unsigned int amiga_get_ss(void)
 	return s;
 }

-static NORET_TYPE void amiga_reset(void)
+static void amiga_reset(void)
     ATTRIB_NORET;

 static void amiga_reset(void)
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 200de02..b6047ec 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -310,7 +310,7 @@ void show_registers(struct pt_regs *regs)

 static DEFINE_SPINLOCK(die_lock);

-NORET_TYPE void ATTRIB_NORET die(const char * str, struct pt_regs * regs)
+void ATTRIB_NORET die(const char * str, struct pt_regs * regs)
 {
 	static int die_counter;
 #ifdef CONFIG_MIPS_MT_SMTC
diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
index e60a0c5..f6928d3 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -47,7 +47,7 @@ void machine_kexec_cleanup(struct kimage *image)
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	if (ppc_md.machine_kexec)
 		ppc_md.machine_kexec(image);
diff --git a/arch/powerpc/kernel/machine_kexec_32.c b/arch/powerpc/kernel/machine_kexec_32.c
index cbaa341..6242e1a 100644
--- a/arch/powerpc/kernel/machine_kexec_32.c
+++ b/arch/powerpc/kernel/machine_kexec_32.c
@@ -16,7 +16,7 @@
 #include <asm/hw_irq.h>
 #include <asm/io.h>

-typedef NORET_TYPE void (*relocate_new_kernel_t)(
+typedef void (*relocate_new_kernel_t)(
 				unsigned long indirection_page,
 				unsigned long reboot_code_buffer,
 				unsigned long start_address) ATTRIB_NORET;
diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index 704375b..b997779 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -253,7 +253,7 @@ union thread_union kexec_stack
 	__attribute__((__section__(".data.init_task"))) = { };

 /* Our assembly helper, in kexec_stub.S */
-extern NORET_TYPE void kexec_sequence(void *newstack, unsigned long start,
+extern void kexec_sequence(void *newstack, unsigned long start,
 					void *image, void *control,
 					void (*clear_all)(void)) ATTRIB_NORET;

diff --git a/arch/ppc/amiga/config.c b/arch/ppc/amiga/config.c
index bc50ed1..6a47651 100644
--- a/arch/ppc/amiga/config.c
+++ b/arch/ppc/amiga/config.c
@@ -694,7 +694,7 @@ static int amiga_set_clock_mmss (unsigned long nowtime)
 	return 0;
 }

-static NORET_TYPE void amiga_reset( void )
+static void amiga_reset( void )
     ATTRIB_NORET;

 static void amiga_reset (void)
diff --git a/arch/ppc/kernel/machine_kexec.c b/arch/ppc/kernel/machine_kexec.c
index a469ba4..94084d0 100644
--- a/arch/ppc/kernel/machine_kexec.c
+++ b/arch/ppc/kernel/machine_kexec.c
@@ -20,7 +20,7 @@
 #include <asm/cacheflush.h>
 #include <asm/machdep.h>

-typedef NORET_TYPE void (*relocate_new_kernel_t)(
+typedef void (*relocate_new_kernel_t)(
 				unsigned long indirection_page,
 				unsigned long reboot_code_buffer,
 				unsigned long start_address) ATTRIB_NORET;
@@ -66,7 +66,7 @@ void machine_kexec_cleanup(struct kimage *image)
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	if (ppc_md.machine_kexec)
 		ppc_md.machine_kexec(image);
diff --git a/arch/sh/kernel/machine_kexec.c b/arch/sh/kernel/machine_kexec.c
index 790ed69..01b0e50 100644
--- a/arch/sh/kernel/machine_kexec.c
+++ b/arch/sh/kernel/machine_kexec.c
@@ -19,7 +19,7 @@
 #include <asm/io.h>
 #include <asm/cacheflush.h>

-typedef NORET_TYPE void (*relocate_new_kernel_t)(
+typedef void (*relocate_new_kernel_t)(
 				unsigned long indirection_page,
 				unsigned long reboot_code_buffer,
 				unsigned long start_address,
@@ -70,7 +70,7 @@ static void kexec_info(struct kimage *image)
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {

 	unsigned long page_list;
diff --git a/arch/x86_64/kernel/machine_kexec.c b/arch/x86_64/kernel/machine_kexec.c
index c3a5547..52336fa 100644
--- a/arch/x86_64/kernel/machine_kexec.c
+++ b/arch/x86_64/kernel/machine_kexec.c
@@ -178,7 +178,7 @@ void machine_kexec_cleanup(struct kimage *image)
  * Do not allocate memory (or fail in any way) in machine_kexec().
  * We are past the point of no return, committed to rebooting now.
  */
-NORET_TYPE void machine_kexec(struct kimage *image)
+void machine_kexec(struct kimage *image)
 {
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
diff --git a/drivers/s390/s390mach.c b/drivers/s390/s390mach.c
index 644a06e..4e069d5 100644
--- a/drivers/s390/s390mach.c
+++ b/drivers/s390/s390mach.c
@@ -26,7 +26,7 @@

 static struct semaphore m_sem;

-static NORET_TYPE void
+static void
 s390_handle_damage(char *msg)
 {
 #ifdef CONFIG_SMP
diff --git a/include/asm-avr32/system.h b/include/asm-avr32/system.h
index a8236ba..a784107 100644
--- a/include/asm-avr32/system.h
+++ b/include/asm-avr32/system.h
@@ -141,7 +141,7 @@ static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
 				   sizeof(*(ptr))))

 struct pt_regs;
-void NORET_TYPE die(const char *str, struct pt_regs *regs, long err);
+void die(const char *str, struct pt_regs *regs, long err);
 void _exception(long signr, struct pt_regs *regs, int code,
 		unsigned long addr);

diff --git a/include/asm-i386/kexec.h b/include/asm-i386/kexec.h
index 4b9dc9e..1367868 100644
--- a/include/asm-i386/kexec.h
+++ b/include/asm-i386/kexec.h
@@ -88,7 +88,7 @@ static inline void crash_setup_regs(struct pt_regs *newregs,
                newregs->eip = (unsigned long)current_text_addr();
        }
 }
-asmlinkage NORET_TYPE void
+asmlinkage void
 relocate_kernel(unsigned long indirection_page,
 		unsigned long control_page,
 		unsigned long start_address,
diff --git a/include/asm-mips/ptrace.h b/include/asm-mips/ptrace.h
index 1906938..de5237f 100644
--- a/include/asm-mips/ptrace.h
+++ b/include/asm-mips/ptrace.h
@@ -86,7 +86,7 @@ struct pt_regs {

 extern asmlinkage void do_syscall_trace(struct pt_regs *regs, int entryexit);

-extern NORET_TYPE void die(const char *, struct pt_regs *);
+extern void die(const char *, struct pt_regs *);

 static inline void die_if_kernel(const char *str, struct pt_regs *regs)
 {
diff --git a/include/asm-x86_64/kexec.h b/include/asm-x86_64/kexec.h
index 738e581..e8b27f1 100644
--- a/include/asm-x86_64/kexec.h
+++ b/include/asm-x86_64/kexec.h
@@ -84,7 +84,7 @@ static inline void crash_setup_regs(struct pt_regs *newregs,
 	}
 }

-NORET_TYPE void
+void
 relocate_kernel(unsigned long indirection_page,
 		unsigned long page_list,
 		unsigned long start_address) ATTRIB_NORET;
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index ece49a8..fda6ea0 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -753,7 +753,6 @@ ext3_group_first_block_no(struct super_block *sb, unsigned long group_no)
  * Ok, these declarations are also in <linux/kernel.h> but none of the
  * ext3 source programs needs to include it so they are duplicated here.
  */
-# define NORET_TYPE    /**/
 # define ATTRIB_NORET  __attribute__((noreturn))
 # define NORET_AND     noreturn,

diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 54c576d..0ea7862 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -780,7 +780,6 @@ void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
  * Ok, these declarations are also in <linux/kernel.h> but none of the
  * ext4 source programs needs to include it so they are duplicated here.
  */
-# define NORET_TYPE    /**/
 # define ATTRIB_NORET  __attribute__((noreturn))
 # define NORET_AND     noreturn,

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 45353d7..01fd7fa 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -105,14 +105,14 @@ extern int cond_resched(void);

 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
-NORET_TYPE void panic(const char * fmt, ...)
+void panic(const char * fmt, ...)
 	__attribute__ ((NORET_AND format (printf, 1, 2)));
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
-fastcall NORET_TYPE void do_exit(long error_code)
+fastcall void do_exit(long error_code)
 	ATTRIB_NORET;
-NORET_TYPE void complete_and_exit(struct completion *, long)
+void complete_and_exit(struct completion *, long)
 	ATTRIB_NORET;
 extern unsigned long simple_strtoul(const char *,char **,unsigned int);
 extern long simple_strtol(const char *,char **,unsigned int);
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 8c2c7fc..55ee447 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -103,7 +103,7 @@ struct kimage {


 /* kexec interface functions */
-extern NORET_TYPE void machine_kexec(struct kimage *image) ATTRIB_NORET;
+extern void machine_kexec(struct kimage *image) ATTRIB_NORET;
 extern int machine_kexec_prepare(struct kimage *image);
 extern void machine_kexec_cleanup(struct kimage *image);
 extern asmlinkage long sys_kexec_load(unsigned long entry,
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 6c9873f..3ef4315 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -55,7 +55,6 @@

 #endif

-#define NORET_TYPE    /**/
 #define ATTRIB_NORET  __attribute__((noreturn))
 #define NORET_AND     noreturn,

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a81897e..8c27b13 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1424,7 +1424,7 @@ extern void __cleanup_signal(struct signal_struct *);
 extern void __cleanup_sighand(struct sighand_struct *);
 extern void exit_itimers(struct signal_struct *);

-extern NORET_TYPE void do_group_exit(int);
+extern void do_group_exit(int);

 extern void daemonize(const char *, ...);
 extern int allow_signal(int);
diff --git a/kernel/exit.c b/kernel/exit.c
index c6d14b8..86bda1c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -862,7 +862,7 @@ static void exit_notify(struct task_struct *tsk)
 		release_task(tsk);
 }

-fastcall NORET_TYPE void do_exit(long code)
+fastcall void do_exit(long code)
 {
 	struct task_struct *tsk = current;
 	int group_dead;
@@ -988,7 +988,7 @@ fastcall NORET_TYPE void do_exit(long code)

 EXPORT_SYMBOL_GPL(do_exit);

-NORET_TYPE void complete_and_exit(struct completion *comp, long code)
+void complete_and_exit(struct completion *comp, long code)
 {
 	if (comp)
 		complete(comp);
@@ -1007,7 +1007,7 @@ asmlinkage long sys_exit(int error_code)
  * Take down every thread in the group.  This is called by fatal signals
  * as well as by sys_exit_group (below).
  */
-NORET_TYPE void
+void
 do_group_exit(int exit_code)
 {
 	BUG_ON(exit_code & 0x80); /* core dumps don't get here */
diff --git a/kernel/panic.c b/kernel/panic.c
index 623d182..2103434 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -57,7 +57,7 @@ EXPORT_SYMBOL(panic_blink);
  *	This function never returns.
  */

-NORET_TYPE void panic(const char * fmt, ...)
+void panic(const char * fmt, ...)
 {
 	long i;
 	static char buf[1024];

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
