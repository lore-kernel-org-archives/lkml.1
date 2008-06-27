Return-Path: <linux-kernel-owner+w=401wt.eu-S1764813AbYF0VoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764813AbYF0VoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764105AbYF0Vho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764253AbYF0Vhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:42 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 18/39] pass argument to putuser_64 functions in ax register.
Date: Fri, 27 Jun 2008 18:34:25 -0300
Message-Id: <1214602486-17080-19-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-18-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is consistent with i386 usage.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/putuser_64.S    |    8 ++++----
 include/asm-x86/uaccess_64.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/lib/putuser_64.S b/arch/x86/lib/putuser_64.S
index 0702885..ce5fcd5 100644
--- a/arch/x86/lib/putuser_64.S
+++ b/arch/x86/lib/putuser_64.S
@@ -37,7 +37,7 @@ ENTRY(__put_user_1)
 	GET_THREAD_INFO(%rbx)
 	cmpq TI_addr_limit(%rbx),%rcx
 	jae bad_put_user
-1:	movb %dl,(%rcx)
+1:	movb %al,(%rcx)
 	xorl %eax,%eax
 	ret
 	CFI_ENDPROC
@@ -51,7 +51,7 @@ ENTRY(__put_user_2)
 	cmpq TI_addr_limit(%rbx),%rcx
 	jae 20f
 	decq %rcx
-2:	movw %dx,(%rcx)
+2:	movw %ax,(%rcx)
 	xorl %eax,%eax
 	ret
 20:	decq %rcx
@@ -67,7 +67,7 @@ ENTRY(__put_user_4)
 	cmpq TI_addr_limit(%rbx),%rcx
 	jae 30f
 	subq $3,%rcx
-3:	movl %edx,(%rcx)
+3:	movl %eax,(%rcx)
 	xorl %eax,%eax
 	ret
 30:	subq $3,%rcx
@@ -83,7 +83,7 @@ ENTRY(__put_user_8)
 	cmpq TI_addr_limit(%rbx),%rcx
 	jae 40f
 	subq $7,%rcx
-4:	movq %rdx,(%rcx)
+4:	movq %rax,(%rcx)
 	xorl %eax,%eax
 	ret
 40:	subq $7,%rcx
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index 8933ddb..05bb246 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -130,7 +130,7 @@ extern void __put_user_bad(void);
 #define __put_user_x(size, ret, x, ptr)					\
 	asm volatile("call __put_user_" #size				\
 		     :"=a" (ret)					\
-		     :"c" (ptr),"d" (x)					\
+		     :"c" (ptr),"a" (x)					\
 		     :"ebx")
 
 #define put_user(x, ptr)						\
-- 
1.5.5.1

