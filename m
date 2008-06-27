Return-Path: <linux-kernel-owner+w=401wt.eu-S1765020AbYF0Voy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765020AbYF0Voy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763903AbYF0Vhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764111AbYF0Vhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:50 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 20/39] replace function headers by macros
Date: Fri, 27 Jun 2008 18:34:27 -0300
Message-Id: <1214602486-17080-21-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-20-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in putuser_64.S, do it the i386 way, and replace the code
in beginning and end of functions with macros, since it's
always the same thing. Save lines.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/putuser_64.S |   32 ++++++++++++++------------------
 1 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/arch/x86/lib/putuser_64.S b/arch/x86/lib/putuser_64.S
index a96bd8a..6d7513b 100644
--- a/arch/x86/lib/putuser_64.S
+++ b/arch/x86/lib/putuser_64.S
@@ -31,62 +31,58 @@
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
 
+#define ENTER   CFI_STARTPROC ; \
+                GET_THREAD_INFO(%rbx)
+#define EXIT    ret ; \
+                CFI_ENDPROC
+
 	.text
 ENTRY(__put_user_1)
-	CFI_STARTPROC
-	GET_THREAD_INFO(%rbx)
+	ENTER
 	cmpq TI_addr_limit(%rbx),%rcx
 	jae bad_put_user
 1:	movb %al,(%rcx)
 	xorl %eax,%eax
-	ret
-	CFI_ENDPROC
+	EXIT
 ENDPROC(__put_user_1)
 
 ENTRY(__put_user_2)
-	CFI_STARTPROC
-	GET_THREAD_INFO(%rbx)
+	ENTER
 	mov TI_addr_limit(%rbx),%rbx
 	sub  $1, %rbx
 	cmpq %rbx ,%rcx
 	jae  bad_put_user
 2:	movw %ax,(%rcx)
 	xorl %eax,%eax
-	ret
-	CFI_ENDPROC
+	EXIT
 ENDPROC(__put_user_2)
 
 ENTRY(__put_user_4)
-	CFI_STARTPROC
-	GET_THREAD_INFO(%rbx)
+	ENTER
 	mov TI_addr_limit(%rbx),%rbx
 	sub  $3, %rbx
 	cmp  %rbx, %rcx
 	jae bad_put_user
 3:	movl %eax,(%rcx)
 	xorl %eax,%eax
-	ret
-	CFI_ENDPROC
+	EXIT
 ENDPROC(__put_user_4)
 
 ENTRY(__put_user_8)
-	CFI_STARTPROC
-	GET_THREAD_INFO(%rbx)
+	ENTER
 	mov TI_addr_limit(%rbx),%rbx
 	sub  $7, %rbx
 	cmp  %rbx, %rcx
 	jae bad_put_user
 4:	movq %rax,(%rcx)
 	xorl %eax,%eax
-	ret
-	CFI_ENDPROC
+	EXIT
 ENDPROC(__put_user_8)
 
 bad_put_user:
 	CFI_STARTPROC
 	movq $(-EFAULT),%rax
-	ret
-	CFI_ENDPROC
+	EXIT
 END(bad_put_user)
 
 .section __ex_table,"a"
-- 
1.5.5.1

