Return-Path: <linux-kernel-owner+w=401wt.eu-S1752317AbZCZXoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbZCZXoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759113AbZCZXnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:43:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:46579 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839AbZCZXnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vTUd8IlJIx4pgLz/ranspGrkdvvPo+0cXW3ZdRNRHKpjnyar0kPtXZRLy5aM/vGooA
         pcrkMZbEddKsQH36BOrbwErPnb30D+qobjHHVaGzcskNENmz5Tqi+7F7hikv7hAFa++q
         dm82WUVVM82ZcbcK8bPHKjGo4uEBwV6cY/HaQ=
Date: Fri, 27 Mar 2009 02:51:16 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Consolidate init_mm definition
Message-ID: <20090326235116.GA26129@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* create mm/init-mm.c, move init_mm there
* remove INIT_MM, initialize init_mm with C99 initializer
* unexport init_mm on all arches:

  init_mm is already unexported on x86.

  One strange place is some OMAP driver (drivers/video/omap/) which
  won't build modular, but it's already wants get_vm_area() export.
  Somebody should look there.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/alpha/kernel/init_task.c     |    3 ---
 arch/arm/kernel/init_task.c       |    4 ----
 arch/avr32/kernel/init_task.c     |    4 ----
 arch/blackfin/kernel/init_task.c  |    4 ----
 arch/cris/kernel/process.c        |    4 ----
 arch/frv/kernel/init_task.c       |    4 ----
 arch/h8300/kernel/init_task.c     |    4 ----
 arch/ia64/kernel/init_task.c      |    4 ----
 arch/m32r/kernel/init_task.c      |    4 ----
 arch/m68k/kernel/process.c        |    4 ----
 arch/m68knommu/kernel/init_task.c |    4 ----
 arch/mips/kernel/init_task.c      |    4 ----
 arch/mn10300/kernel/init_task.c   |    3 ---
 arch/parisc/kernel/init_task.c    |    4 ----
 arch/powerpc/kernel/init_task.c   |    4 ----
 arch/s390/kernel/init_task.c      |    4 ----
 arch/sh/kernel/init_task.c        |    3 ---
 arch/sparc/kernel/init_task.c     |    3 ---
 arch/um/kernel/init_task.c        |    3 ---
 arch/x86/kernel/init_task.c       |    1 -
 arch/xtensa/kernel/init_task.c    |    4 ----
 include/linux/init_task.h         |   12 ------------
 mm/Makefile                       |    1 +
 mm/init-mm.c                      |   13 +++++++++++++
 24 files changed, 14 insertions(+), 88 deletions(-)

--- a/arch/alpha/kernel/init_task.c
+++ b/arch/alpha/kernel/init_task.c
@@ -10,10 +10,7 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
 struct task_struct init_task = INIT_TASK(init_task);
-
-EXPORT_SYMBOL(init_mm);
 EXPORT_SYMBOL(init_task);
 
 union thread_union init_thread_union
--- a/arch/arm/kernel/init_task.c
+++ b/arch/arm/kernel/init_task.c
@@ -14,10 +14,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
--- a/arch/avr32/kernel/init_task.c
+++ b/arch/avr32/kernel/init_task.c
@@ -15,10 +15,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure. Must be aligned on an 8192-byte boundary.
  */
--- a/arch/blackfin/kernel/init_task.c
+++ b/arch/blackfin/kernel/init_task.c
@@ -35,10 +35,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-
-struct mm_struct init_mm = INIT_MM(init_mm);
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial task structure.
  *
--- a/arch/cris/kernel/process.c
+++ b/arch/cris/kernel/process.c
@@ -39,10 +39,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
--- a/arch/frv/kernel/init_task.c
+++ b/arch/frv/kernel/init_task.c
@@ -12,10 +12,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
--- a/arch/h8300/kernel/init_task.c
+++ b/arch/h8300/kernel/init_task.c
@@ -14,10 +14,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial task structure.
  *
--- a/arch/ia64/kernel/init_task.c
+++ b/arch/ia64/kernel/init_task.c
@@ -19,10 +19,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial task structure.
  *
--- a/arch/m32r/kernel/init_task.c
+++ b/arch/m32r/kernel/init_task.c
@@ -13,10 +13,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -42,10 +42,6 @@
  */
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 union thread_union init_thread_union
 __attribute__((section(".data.init_task"), aligned(THREAD_SIZE)))
        = { INIT_THREAD_INFO(init_task) };
--- a/arch/m68knommu/kernel/init_task.c
+++ b/arch/m68knommu/kernel/init_task.c
@@ -14,10 +14,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial task structure.
  *
--- a/arch/mips/kernel/init_task.c
+++ b/arch/mips/kernel/init_task.c
@@ -11,10 +11,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
--- a/arch/mn10300/kernel/init_task.c
+++ b/arch/mn10300/kernel/init_task.c
@@ -20,9 +20,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
--- a/arch/parisc/kernel/init_task.c
+++ b/arch/parisc/kernel/init_task.c
@@ -36,10 +36,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial task structure.
  *
--- a/arch/powerpc/kernel/init_task.c
+++ b/arch/powerpc/kernel/init_task.c
@@ -9,10 +9,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
--- a/arch/s390/kernel/init_task.c
+++ b/arch/s390/kernel/init_task.c
@@ -18,10 +18,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
--- a/arch/sh/kernel/init_task.c
+++ b/arch/sh/kernel/init_task.c
@@ -10,9 +10,6 @@
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct pt_regs fake_swapper_regs;
-struct mm_struct init_mm = INIT_MM(init_mm);
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial thread structure.
  *
--- a/arch/sparc/kernel/init_task.c
+++ b/arch/sparc/kernel/init_task.c
@@ -10,10 +10,7 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
 struct task_struct init_task = INIT_TASK(init_task);
-
-EXPORT_SYMBOL(init_mm);
 EXPORT_SYMBOL(init_task);
 
 /* .text section in head.S is aligned at 8k boundary and this gets linked
--- a/arch/um/kernel/init_task.c
+++ b/arch/um/kernel/init_task.c
@@ -10,11 +10,8 @@
 #include "linux/mqueue.h"
 #include "asm/uaccess.h"
 
-struct mm_struct init_mm = INIT_MM(init_mm);
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-EXPORT_SYMBOL(init_mm);
-
 /*
  * Initial task structure.
  *
--- a/arch/x86/kernel/init_task.c
+++ b/arch/x86/kernel/init_task.c
@@ -12,7 +12,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
 
 /*
  * Initial thread structure.
--- a/arch/xtensa/kernel/init_task.c
+++ b/arch/xtensa/kernel/init_task.c
@@ -23,10 +23,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-
-EXPORT_SYMBOL(init_mm);
-
 union thread_union init_thread_union
 	__attribute__((__section__(".data.init_task"))) =
 { INIT_THREAD_INFO(init_task) };
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -14,18 +14,6 @@
 extern struct files_struct init_files;
 extern struct fs_struct init_fs;
 
-#define INIT_MM(name) \
-{			 					\
-	.mm_rb		= RB_ROOT,				\
-	.pgd		= swapper_pg_dir, 			\
-	.mm_users	= ATOMIC_INIT(2), 			\
-	.mm_count	= ATOMIC_INIT(1), 			\
-	.mmap_sem	= __RWSEM_INITIALIZER(name.mmap_sem),	\
-	.page_table_lock =  __SPIN_LOCK_UNLOCKED(name.page_table_lock),	\
-	.mmlist		= LIST_HEAD_INIT(name.mmlist),		\
-	.cpu_vm_mask	= CPU_MASK_ALL,				\
-}
-
 #define INIT_SIGNALS(sig) {						\
 	.count		= ATOMIC_INIT(1), 				\
 	.wait_chldexit	= __WAIT_QUEUE_HEAD_INITIALIZER(sig.wait_chldexit),\
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -12,6 +12,7 @@ obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o mm_init.o $(mmu-y)
+obj-y += init-mm.o
 
 obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
 obj-$(CONFIG_BOUNCE)	+= bounce.o
new file mode 100644
--- /dev/null
+++ b/mm/init-mm.c
@@ -0,0 +1,13 @@
+#include <linux/mm_types.h>
+#include <asm/pgtable.h>
+
+struct mm_struct init_mm = {
+	.mm_rb		= RB_ROOT,
+	.pgd		= swapper_pg_dir,
+	.mm_users	= ATOMIC_INIT(2),
+	.mm_count	= ATOMIC_INIT(1),
+	.mmap_sem	= __RWSEM_INITIALIZER(init_mm.mmap_sem),
+	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
+	.mmlist		= LIST_HEAD_INIT(init_mm.mmlist),
+	.cpu_vm_mask	= CPU_MASK_ALL,
+};
