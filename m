Return-Path: <linux-kernel-owner+w=401wt.eu-S1765069AbYF0Vpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765069AbYF0Vpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761766AbYF0ViC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764300AbYF0ViA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:00 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 22/39] use macros from asm.h
Date: Fri, 27 Jun 2008 18:34:29 -0300
Message-Id: <1214602486-17080-23-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-22-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
 <1214602486-17080-4-git-send-email-gcosta@redhat.com>
 <1214602486-17080-5-git-send-email-gcosta@redhat.com>
 <1214602486-17080-6-git-send-email-gcosta@redhat.com>
 <1214602486-17080-7-git-send-email-gcosta@redhat.com>
 <1214602486-17080-8-git-send-email-gcosta@redhat.com>
 <1214602486-17080-9-git-send-email-gcosta@redhat.com>
 <1214602486-17080-10-git-send-email-gcosta@redhat.com>
 <1214602486-17080-11-git-send-email-gcosta@redhat.com>
 <1214602486-17080-12-git-send-email-gcosta@redhat.com>
 <1214602486-17080-13-git-send-email-gcosta@redhat.com>
 <1214602486-17080-14-git-send-email-gcosta@redhat.com>
 <1214602486-17080-15-git-send-email-gcosta@redhat.com>
 <1214602486-17080-16-git-send-email-gcosta@redhat.com>
 <1214602486-17080-17-git-send-email-gcosta@redhat.com>
 <1214602486-17080-18-git-send-email-gcosta@redhat.com>
 <1214602486-17080-19-git-send-email-gcosta@redhat.com>
 <1214602486-17080-20-git-send-email-gcosta@redhat.com>
 <1214602486-17080-21-git-send-email-gcosta@redhat.com>
 <1214602486-17080-22-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In putuser_32.S and putuser_64.S, replace things like .quad, .long,
and explicit references to [r|e]ax for the apropriate macros
in asm/asm.h.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/putuser_32.S |   43 ++++++++++++++++++++++---------------------
 arch/x86/lib/putuser_64.S |   41 +++++++++++++++++++++--------------------
 include/asm-x86/asm.h     |    2 ++
 3 files changed, 45 insertions(+), 41 deletions(-)

diff --git a/arch/x86/lib/putuser_32.S b/arch/x86/lib/putuser_32.S
index b67a37c..e7eda34 100644
--- a/arch/x86/lib/putuser_32.S
+++ b/arch/x86/lib/putuser_32.S
@@ -11,6 +11,7 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 #include <asm/thread_info.h>
+#include <asm/asm.h>
 
 
 /*
@@ -26,50 +27,50 @@
  */
 
 #define ENTER	CFI_STARTPROC ; \
-		GET_THREAD_INFO(%ebx)
+		GET_THREAD_INFO(%_ASM_BX)
 #define EXIT	ret ; \
 		CFI_ENDPROC
 
 .text
 ENTRY(__put_user_1)
 	ENTER
-	cmp TI_addr_limit(%ebx),%ecx
+	cmp TI_addr_limit(%_ASM_BX),%_ASM_CX
 	jae bad_put_user
-1:	movb %al,(%ecx)
+1:	movb %al,(%_ASM_CX)
 	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_1)
 
 ENTRY(__put_user_2)
 	ENTER
-	mov TI_addr_limit(%ebx),%ebx
-	sub $1,%ebx
-	cmp %ebx,%ecx
+	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
+	sub $1,%_ASM_BX
+	cmp %_ASM_BX,%_ASM_CX
 	jae bad_put_user
-2:	movw %ax,(%ecx)
+2:	movw %ax,(%_ASM_CX)
 	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_2)
 
 ENTRY(__put_user_4)
 	ENTER
-	mov TI_addr_limit(%ebx),%ebx
-	sub $3,%ebx
-	cmp %ebx,%ecx
+	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
+	sub $3,%_ASM_BX
+	cmp %_ASM_BX,%_ASM_CX
 	jae bad_put_user
-3:	movl %eax,(%ecx)
+3:	movl %eax,(%_ASM_CX)
 	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_4)
 
 ENTRY(__put_user_8)
 	ENTER
-	mov TI_addr_limit(%ebx),%ebx
-	sub $7,%ebx
-	cmp %ebx,%ecx
+	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
+	sub $7,%_ASM_BX
+	cmp %_ASM_BX,%_ASM_CX
 	jae bad_put_user
-4:	movl %eax,(%ecx)
-5:	movl %edx,4(%ecx)
+4:	movl %_ASM_AX,(%_ASM_CX)
+5:	movl %edx,4(%_ASM_CX)
 	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_8)
@@ -81,9 +82,9 @@ bad_put_user:
 END(bad_put_user)
 
 .section __ex_table,"a"
-	.long 1b,bad_put_user
-	.long 2b,bad_put_user
-	.long 3b,bad_put_user
-	.long 4b,bad_put_user
-	.long 5b,bad_put_user
+	_ASM_PTR 1b,bad_put_user
+	_ASM_PTR 2b,bad_put_user
+	_ASM_PTR 3b,bad_put_user
+	_ASM_PTR 4b,bad_put_user
+	_ASM_PTR 5b,bad_put_user
 .previous
diff --git a/arch/x86/lib/putuser_64.S b/arch/x86/lib/putuser_64.S
index c18fc0f..d496cc8 100644
--- a/arch/x86/lib/putuser_64.S
+++ b/arch/x86/lib/putuser_64.S
@@ -30,64 +30,65 @@
 #include <asm/errno.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
+#include <asm/asm.h>
 
 #define ENTER   CFI_STARTPROC ; \
-                GET_THREAD_INFO(%rbx)
+                GET_THREAD_INFO(%_ASM_BX)
 #define EXIT    ret ; \
                 CFI_ENDPROC
 
 	.text
 ENTRY(__put_user_1)
 	ENTER
-	cmp TI_addr_limit(%rbx),%rcx
+	cmp TI_addr_limit(%_ASM_BX),%_ASM_CX
 	jae bad_put_user
-1:	movb %al,(%rcx)
+1:	movb %al,(%_ASM_CX)
 	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_1)
 
 ENTRY(__put_user_2)
 	ENTER
-	mov TI_addr_limit(%rbx),%rbx
-	sub  $1, %rbx
-	cmp %rbx ,%rcx
+	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
+	sub  $1, %_ASM_BX
+	cmp %_ASM_BX ,%_ASM_CX
 	jae  bad_put_user
-2:	movw %ax,(%rcx)
+2:	movw %ax,(%_ASM_CX)
 	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_2)
 
 ENTRY(__put_user_4)
 	ENTER
-	mov TI_addr_limit(%rbx),%rbx
-	sub  $3, %rbx
-	cmp  %rbx, %rcx
+	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
+	sub  $3, %_ASM_BX
+	cmp  %_ASM_BX, %_ASM_CX
 	jae bad_put_user
-3:	movl %eax,(%rcx)
+3:	movl %eax,(%_ASM_CX)
 	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_4)
 
 ENTRY(__put_user_8)
 	ENTER
-	mov TI_addr_limit(%rbx),%rbx
-	sub  $7, %rbx
-	cmp  %rbx, %rcx
+	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
+	sub  $7, %_ASM_BX
+	cmp  %_ASM_BX, %_ASM_CX
 	jae bad_put_user
-4:	movq %rax,(%rcx)
+4:	movq %_ASM_AX,(%_ASM_CX)
 	xor %eax,%eax
 	EXIT
 ENDPROC(__put_user_8)
 
 bad_put_user:
 	CFI_STARTPROC
-	mov $(-EFAULT),%rax
+	mov $(-EFAULT),%eax
 	EXIT
 END(bad_put_user)
 
 .section __ex_table,"a"
-	.quad 1b,bad_put_user
-	.quad 2b,bad_put_user
-	.quad 3b,bad_put_user
-	.quad 4b,bad_put_user
+	_ASM_PTR 1b,bad_put_user
+	_ASM_PTR 2b,bad_put_user
+	_ASM_PTR 3b,bad_put_user
+	_ASM_PTR 4b,bad_put_user
 .previous
diff --git a/include/asm-x86/asm.h b/include/asm-x86/asm.h
index 57750a9..9722032 100644
--- a/include/asm-x86/asm.h
+++ b/include/asm-x86/asm.h
@@ -28,6 +28,8 @@
 #define _ASM_SUB	__ASM_SIZE(sub)
 #define _ASM_XADD	__ASM_SIZE(xadd)
 #define _ASM_AX		__ASM_REG(ax)
+#define _ASM_BX		__ASM_REG(bx)
+#define _ASM_CX		__ASM_REG(cx)
 #define _ASM_DX		__ASM_REG(dx)
 
 /* Exception table entry */
-- 
1.5.5.1

