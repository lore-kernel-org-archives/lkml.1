Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0BTAhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:37:21 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51052 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab0BTAhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:37:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q/Fh4FOPWi4OcFs/R6fUMbkvsCvWD+clrqmgozkzR09JbkY8wpGeNoxeqqdG47w2aT
         t4Lm4ONlBBBwRD0Wpor9wcYjLM3HGTT9kN7vrEaAGWA7OlXifh+Tm6/QwEZkgl/pnnRd
         DO6/zFXsT8/YK5raZAFLlYxlApRsLnw0jwlNQ=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 09/24] Rename .data..patch.xxx to .data..patch.xxx.
Date: Sat, 20 Feb 2010 01:37:11 +0100
Message-Id: <1266626233-25658-1-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/ia64/include/asm/asmmacro.h |   12 ++++++------
 arch/ia64/kernel/gate.S          |    8 ++++----
 arch/ia64/kernel/gate.lds.S      |   10 +++++-----
 arch/ia64/kernel/minstate.h      |    4 ++--
 arch/ia64/kernel/vmlinux.lds.S   |   16 ++++++++--------
 5 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/ia64/include/asm/asmmacro.h b/arch/ia64/include/asm/asmmacro.h
index c1642fd..3ab6d75 100644
--- a/arch/ia64/include/asm/asmmacro.h
+++ b/arch/ia64/include/asm/asmmacro.h
@@ -70,12 +70,12 @@ name:
  * path (ivt.S - TLB miss processing) or in places where it might not be
  * safe to use a "tpa" instruction (mca_asm.S - error recovery).
  */
-	.section ".data.patch.vtop", "a"	// declare section & section attributes
+	.section ".data..patch.vtop", "a"	// declare section & section attributes
 	.previous
 
 #define	LOAD_PHYSICAL(pr, reg, obj)		\
 [1:](pr)movl reg = obj;				\
-	.xdata4 ".data.patch.vtop", 1b-.
+	.xdata4 ".data..patch.vtop", 1b-.
 
 /*
  * For now, we always put in the McKinley E9 workaround.  On CPUs that don't need it,
@@ -84,11 +84,11 @@ name:
 #define DO_MCKINLEY_E9_WORKAROUND
 
 #ifdef DO_MCKINLEY_E9_WORKAROUND
-	.section ".data.patch.mckinley_e9", "a"
+	.section ".data..patch.mckinley_e9", "a"
 	.previous
 /* workaround for Itanium 2 Errata 9: */
 # define FSYS_RETURN					\
-	.xdata4 ".data.patch.mckinley_e9", 1f-.;	\
+	.xdata4 ".data..patch.mckinley_e9", 1f-.;	\
 1:{ .mib;						\
 	nop.m 0;					\
 	mov r16=ar.pfs;					\
@@ -107,11 +107,11 @@ name:
  * If physical stack register size is different from DEF_NUM_STACK_REG,
  * dynamically patch the kernel for correct size.
  */
-	.section ".data.patch.phys_stack_reg", "a"
+	.section ".data..patch.phys_stack_reg", "a"
 	.previous
 #define LOAD_PHYS_STACK_REG_SIZE(reg)			\
 [1:]	adds reg=IA64_NUM_PHYS_STACK_REG*8+8,r0;	\
-	.xdata4 ".data.patch.phys_stack_reg", 1b-.
+	.xdata4 ".data..patch.phys_stack_reg", 1b-.
 
 /*
  * Up until early 2004, use of .align within a function caused bad unwind info.
diff --git a/arch/ia64/kernel/gate.S b/arch/ia64/kernel/gate.S
index cf5e0a1..245d3e1 100644
--- a/arch/ia64/kernel/gate.S
+++ b/arch/ia64/kernel/gate.S
@@ -21,18 +21,18 @@
  * to targets outside the shared object) and to avoid multi-phase kernel builds, we
  * simply create minimalistic "patch lists" in special ELF sections.
  */
-	.section ".data.patch.fsyscall_table", "a"
+	.section ".data..patch.fsyscall_table", "a"
 	.previous
 #define LOAD_FSYSCALL_TABLE(reg)			\
 [1:]	movl reg=0;					\
-	.xdata4 ".data.patch.fsyscall_table", 1b-.
+	.xdata4 ".data..patch.fsyscall_table", 1b-.
 
-	.section ".data.patch.brl_fsys_bubble_down", "a"
+	.section ".data..patch.brl_fsys_bubble_down", "a"
 	.previous
 #define BRL_COND_FSYS_BUBBLE_DOWN(pr)			\
 [1:](pr)brl.cond.sptk 0;				\
 	;;						\
-	.xdata4 ".data.patch.brl_fsys_bubble_down", 1b-.
+	.xdata4 ".data..patch.brl_fsys_bubble_down", 1b-.
 
 GLOBAL_ENTRY(__kernel_syscall_via_break)
 	.prologue
diff --git a/arch/ia64/kernel/gate.lds.S b/arch/ia64/kernel/gate.lds.S
index 88c64ed..d32b085 100644
--- a/arch/ia64/kernel/gate.lds.S
+++ b/arch/ia64/kernel/gate.lds.S
@@ -33,21 +33,21 @@ SECTIONS
 	 */
 	. = GATE_ADDR + 0x600;
 
-	.data.patch		: {
+	.data..patch		: {
 		__paravirt_start_gate_mckinley_e9_patchlist = .;
-		*(.data.patch.mckinley_e9)
+		*(.data..patch.mckinley_e9)
 		__paravirt_end_gate_mckinley_e9_patchlist = .;
 
 		__paravirt_start_gate_vtop_patchlist = .;
-		*(.data.patch.vtop)
+		*(.data..patch.vtop)
 		__paravirt_end_gate_vtop_patchlist = .;
 
 		__paravirt_start_gate_fsyscall_patchlist = .;
-		*(.data.patch.fsyscall_table)
+		*(.data..patch.fsyscall_table)
 		__paravirt_end_gate_fsyscall_patchlist = .;
 
 		__paravirt_start_gate_brl_fsys_bubble_down_patchlist = .;
-		*(.data.patch.brl_fsys_bubble_down)
+		*(.data..patch.brl_fsys_bubble_down)
 		__paravirt_end_gate_brl_fsys_bubble_down_patchlist = .;
 	}						:readable
 
diff --git a/arch/ia64/kernel/minstate.h b/arch/ia64/kernel/minstate.h
index 292e214..d56753a 100644
--- a/arch/ia64/kernel/minstate.h
+++ b/arch/ia64/kernel/minstate.h
@@ -16,7 +16,7 @@
 #define ACCOUNT_SYS_ENTER
 #endif
 
-.section ".data.patch.rse", "a"
+.section ".data..patch.rse", "a"
 .previous
 
 /*
@@ -215,7 +215,7 @@
 (pUStk) extr.u r17=r18,3,6;			\
 (pUStk)	sub r16=r18,r22;			\
 [1:](pKStk)	br.cond.sptk.many 1f;		\
-	.xdata4 ".data.patch.rse",1b-.		\
+	.xdata4 ".data..patch.rse",1b-.		\
 	;;					\
 	cmp.ge p6,p7 = 33,r17;			\
 	;;					\
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 3e33809..b943eff 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -75,10 +75,10 @@ SECTIONS
 	  __stop___mca_table = .;
 	}
 
-  .data.patch.phys_stack_reg : AT(ADDR(.data.patch.phys_stack_reg) - LOAD_OFFSET)
+  .data..patch.phys_stack_reg : AT(ADDR(.data..patch.phys_stack_reg) - LOAD_OFFSET)
 	{
 	  __start___phys_stack_reg_patchlist = .;
-	  *(.data.patch.phys_stack_reg)
+	  *(.data..patch.phys_stack_reg)
 	  __end___phys_stack_reg_patchlist = .;
 	}
 
@@ -110,24 +110,24 @@ SECTIONS
   INIT_TEXT_SECTION(PAGE_SIZE)
   INIT_DATA_SECTION(16)
 
-  .data.patch.vtop : AT(ADDR(.data.patch.vtop) - LOAD_OFFSET)
+  .data..patch.vtop : AT(ADDR(.data..patch.vtop) - LOAD_OFFSET)
 	{
 	  __start___vtop_patchlist = .;
-	  *(.data.patch.vtop)
+	  *(.data..patch.vtop)
 	  __end___vtop_patchlist = .;
 	}
 
-  .data.patch.rse : AT(ADDR(.data.patch.rse) - LOAD_OFFSET)
+  .data..patch.rse : AT(ADDR(.data..patch.rse) - LOAD_OFFSET)
 	{
 	  __start___rse_patchlist = .;
-	  *(.data.patch.rse)
+	  *(.data..patch.rse)
 	  __end___rse_patchlist = .;
 	}
 
-  .data.patch.mckinley_e9 : AT(ADDR(.data.patch.mckinley_e9) - LOAD_OFFSET)
+  .data..patch.mckinley_e9 : AT(ADDR(.data..patch.mckinley_e9) - LOAD_OFFSET)
 	{
 	  __start___mckinley_e9_bundles = .;
-	  *(.data.patch.mckinley_e9)
+	  *(.data..patch.mckinley_e9)
 	  __end___mckinley_e9_bundles = .;
 	}
 
-- 
1.6.2.4

