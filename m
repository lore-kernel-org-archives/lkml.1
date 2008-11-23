Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbYKWLyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbYKWLyB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 06:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757810AbYKWLxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 06:53:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:37739 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478AbYKWLxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 06:53:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Vdtvq8JtVNuuBW7ixsI8Dv9xcA6sDEg40zt8q6PUnhKVDHEEotJdH+LoBKPZ/Gfcf3
         YFm79c0vXIuS+11iK0lXz/bnjP+qk+v8pmlJTDikvmildd/trhoJ69gCupVNxhiAZsds
         rOsW6g+yvVAlUpA83db5nqKYwwLQkbY/zrmV8=
Date: Sun, 23 Nov 2008 14:53:43 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86: move dwarf2 related macro to dwarf2.h
Message-ID: <20081123115343.GF24818@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Move recently introduced dwarf2 macros to dwarf2.h file.
It allow us to not duplicate them in assembly files.

Active usage of _cfi macros don't make assembly files
more obvious to understand but we already has a lot of
macros there which requires to search the definitions
of them *anyway*. But at least it make every cfi usage
one line shorter.

Also some code alignment is done.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 arch/x86/include/asm/dwarf2.h |   97 ++++++++++++++++++++++++++++--------------
 arch/x86/kernel/entry_64.S    |   23 ---------
 2 files changed, 66 insertions(+), 54 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/dwarf2.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/dwarf2.h
+++ linux-2.6.git/arch/x86/include/asm/dwarf2.h
@@ -6,56 +6,91 @@
 #endif
 
 /*
-   Macros for dwarf2 CFI unwind table entries.
-   See "as.info" for details on these pseudo ops. Unfortunately
-   they are only supported in very new binutils, so define them
-   away for older version.
+ * Macros for dwarf2 CFI unwind table entries.
+ * See "as.info" for details on these pseudo ops. Unfortunately
+ * they are only supported in very new binutils, so define them
+ * away for older version.
  */
 
 #ifdef CONFIG_AS_CFI
 
-#define CFI_STARTPROC .cfi_startproc
-#define CFI_ENDPROC .cfi_endproc
-#define CFI_DEF_CFA .cfi_def_cfa
-#define CFI_DEF_CFA_REGISTER .cfi_def_cfa_register
-#define CFI_DEF_CFA_OFFSET .cfi_def_cfa_offset
-#define CFI_ADJUST_CFA_OFFSET .cfi_adjust_cfa_offset
-#define CFI_OFFSET .cfi_offset
-#define CFI_REL_OFFSET .cfi_rel_offset
-#define CFI_REGISTER .cfi_register
-#define CFI_RESTORE .cfi_restore
-#define CFI_REMEMBER_STATE .cfi_remember_state
-#define CFI_RESTORE_STATE .cfi_restore_state
-#define CFI_UNDEFINED .cfi_undefined
+#define CFI_STARTPROC		.cfi_startproc
+#define CFI_ENDPROC		.cfi_endproc
+#define CFI_DEF_CFA		.cfi_def_cfa
+#define CFI_DEF_CFA_REGISTER	.cfi_def_cfa_register
+#define CFI_DEF_CFA_OFFSET	.cfi_def_cfa_offset
+#define CFI_ADJUST_CFA_OFFSET	.cfi_adjust_cfa_offset
+#define CFI_OFFSET		.cfi_offset
+#define CFI_REL_OFFSET		.cfi_rel_offset
+#define CFI_REGISTER		.cfi_register
+#define CFI_RESTORE		.cfi_restore
+#define CFI_REMEMBER_STATE	.cfi_remember_state
+#define CFI_RESTORE_STATE	.cfi_restore_state
+#define CFI_UNDEFINED		.cfi_undefined
 
 #ifdef CONFIG_AS_CFI_SIGNAL_FRAME
-#define CFI_SIGNAL_FRAME .cfi_signal_frame
+#define CFI_SIGNAL_FRAME	.cfi_signal_frame
 #else
 #define CFI_SIGNAL_FRAME
 #endif
 
 #else
 
-/* Due to the structure of pre-exisiting code, don't use assembler line
-   comment character # to ignore the arguments. Instead, use a dummy macro. */
+/*
+ * Due to the structure of pre-exisiting code, don't use assembler line
+ * comment character # to ignore the arguments. Instead, use a dummy macro.
+ */
 .macro cfi_ignore a=0, b=0, c=0, d=0
 .endm
 
-#define CFI_STARTPROC	cfi_ignore
-#define CFI_ENDPROC	cfi_ignore
-#define CFI_DEF_CFA	cfi_ignore
+#define CFI_STARTPROC		cfi_ignore
+#define CFI_ENDPROC		cfi_ignore
+#define CFI_DEF_CFA		cfi_ignore
 #define CFI_DEF_CFA_REGISTER	cfi_ignore
 #define CFI_DEF_CFA_OFFSET	cfi_ignore
 #define CFI_ADJUST_CFA_OFFSET	cfi_ignore
-#define CFI_OFFSET	cfi_ignore
-#define CFI_REL_OFFSET	cfi_ignore
-#define CFI_REGISTER	cfi_ignore
-#define CFI_RESTORE	cfi_ignore
-#define CFI_REMEMBER_STATE cfi_ignore
-#define CFI_RESTORE_STATE cfi_ignore
-#define CFI_UNDEFINED cfi_ignore
-#define CFI_SIGNAL_FRAME cfi_ignore
+#define CFI_OFFSET		cfi_ignore
+#define CFI_REL_OFFSET		cfi_ignore
+#define CFI_REGISTER		cfi_ignore
+#define CFI_RESTORE		cfi_ignore
+#define CFI_REMEMBER_STATE	cfi_ignore
+#define CFI_RESTORE_STATE	cfi_ignore
+#define CFI_UNDEFINED		cfi_ignore
+#define CFI_SIGNAL_FRAME	cfi_ignore
 
 #endif
 
+/*
+ * An attempt to make CFI annotations more or less
+ * correct and shorter. It is implied that you know
+ * what you're doing if you use them.
+ */
+#ifdef __ASSEMBLY__
+#ifdef CONFIG_X86_64
+	.macro pushq_cfi reg
+	pushq \reg
+	CFI_ADJUST_CFA_OFFSET 8
+	.endm
+
+	.macro popq_cfi reg
+	popq \reg
+	CFI_ADJUST_CFA_OFFSET -8
+	.endm
+
+	.macro movq_cfi reg offset=0
+	movq %\reg, \offset(%rsp)
+	CFI_REL_OFFSET \reg, \offset
+	.endm
+
+	.macro movq_cfi_restore offset reg
+	movq \offset(%rsp), %\reg
+	CFI_RESTORE \reg
+	.endm
+#else /*!CONFIG_X86_64*/
+
+	/* 32bit defenitions are missed yet */
+
+#endif /*!CONFIG_X86_64*/
+#endif /*__ASSEMBLY__*/
+
 #endif /* _ASM_X86_DWARF2_H */
Index: linux-2.6.git/arch/x86/kernel/entry_64.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/entry_64.S
+++ linux-2.6.git/arch/x86/kernel/entry_64.S
@@ -60,29 +60,6 @@
 #define __AUDIT_ARCH_LE	   0x40000000
 
 	.code64
-/*
- * Some macro's to hide the most frequently occuring CFI annotations.
- */
-	.macro pushq_cfi reg
-	pushq \reg
-	CFI_ADJUST_CFA_OFFSET 8
-	.endm
-
-	.macro popq_cfi reg
-	popq \reg
-	CFI_ADJUST_CFA_OFFSET -8
-	.endm
-
-	.macro movq_cfi reg offset=0
-	movq %\reg, \offset(%rsp)
-	CFI_REL_OFFSET \reg, \offset
-	.endm
-
-	.macro movq_cfi_restore offset reg
-	movq \offset(%rsp), %\reg
-	CFI_RESTORE \reg
-	.endm
-
 #ifdef CONFIG_FUNCTION_TRACER
 #ifdef CONFIG_DYNAMIC_FTRACE
 ENTRY(mcount)
