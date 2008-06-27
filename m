Return-Path: <linux-kernel-owner+w=401wt.eu-S1764273AbYF0VjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764273AbYF0VjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761539AbYF0VhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764201AbYF0VhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:15 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 11/39] Don't use word-size specifiers on getuser_64
Date: Fri, 27 Jun 2008 18:34:18 -0300
Message-Id: <1214602486-17080-12-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-11-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The instructions access registers, so the size is unambiguous.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/getuser_64.S |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/lib/getuser_64.S b/arch/x86/lib/getuser_64.S
index 0ec7890..6134752 100644
--- a/arch/x86/lib/getuser_64.S
+++ b/arch/x86/lib/getuser_64.S
@@ -37,57 +37,57 @@
 ENTRY(__get_user_1)
 	CFI_STARTPROC
 	GET_THREAD_INFO(%rdx)
-	cmpq TI_addr_limit(%rdx),%rax
+	cmp TI_addr_limit(%rdx),%rax
 	jae bad_get_user
 1:	movzb (%rax),%edx
-	xorl %eax,%eax
+	xor %eax,%eax
 	ret
 	CFI_ENDPROC
 ENDPROC(__get_user_1)
 
 ENTRY(__get_user_2)
 	CFI_STARTPROC
-	addq $1,%rax
+	add $1,%rax
 	jc bad_get_user
 	GET_THREAD_INFO(%rdx)
-	cmpq TI_addr_limit(%rdx),%rax
+	cmp TI_addr_limit(%rdx),%rax
 	jae bad_get_user
 2:	movzwl -1(%rax),%edx
-	xorl %eax,%eax
+	xor %eax,%eax
 	ret
 	CFI_ENDPROC
 ENDPROC(__get_user_2)
 
 ENTRY(__get_user_4)
 	CFI_STARTPROC
-	addq $3,%rax
+	add $3,%rax
 	jc bad_get_user
 	GET_THREAD_INFO(%rdx)
-	cmpq TI_addr_limit(%rdx),%rax
+	cmp TI_addr_limit(%rdx),%rax
 	jae bad_get_user
-3:	movl -3(%rax),%edx
-	xorl %eax,%eax
+3:	mov -3(%rax),%edx
+	xor %eax,%eax
 	ret
 	CFI_ENDPROC
 ENDPROC(__get_user_4)
 
 ENTRY(__get_user_8)
 	CFI_STARTPROC
-	addq $7,%rax
+	add $7,%rax
 	jc bad_get_user
 	GET_THREAD_INFO(%rdx)
-	cmpq TI_addr_limit(%rdx),%rax
+	cmp TI_addr_limit(%rdx),%rax
 	jae	bad_get_user
 4:	movq -7(%rax),%rdx
-	xorl %eax,%eax
+	xor %eax,%eax
 	ret
 	CFI_ENDPROC
 ENDPROC(__get_user_8)
 
 bad_get_user:
 	CFI_STARTPROC
-	xorl %edx,%edx
-	movq $(-EFAULT),%rax
+	xor %edx,%edx
+	mov $(-EFAULT),%rax
 	ret
 	CFI_ENDPROC
 END(bad_get_user)
-- 
1.5.5.1

