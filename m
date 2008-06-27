Return-Path: <linux-kernel-owner+w=401wt.eu-S1764617AbYF0Vjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764617AbYF0Vjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761437AbYF0VhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:37:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764203AbYF0VhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:37:15 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 08/39] don't use word-size specifiers
Date: Fri, 27 Jun 2008 18:34:15 -0300
Message-Id: <1214602486-17080-9-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-8-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
 <1214602486-17080-4-git-send-email-gcosta@redhat.com>
 <1214602486-17080-5-git-send-email-gcosta@redhat.com>
 <1214602486-17080-6-git-send-email-gcosta@redhat.com>
 <1214602486-17080-7-git-send-email-gcosta@redhat.com>
 <1214602486-17080-8-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

since the instructions refer to registers, they'll be able
to figure it out.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/getuser_32.S |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/lib/getuser_32.S b/arch/x86/lib/getuser_32.S
index 6d84b53..8200fde 100644
--- a/arch/x86/lib/getuser_32.S
+++ b/arch/x86/lib/getuser_32.S
@@ -29,44 +29,44 @@
 ENTRY(__get_user_1)
 	CFI_STARTPROC
 	GET_THREAD_INFO(%edx)
-	cmpl TI_addr_limit(%edx),%eax
+	cmp TI_addr_limit(%edx),%eax
 	jae bad_get_user
-1:	movzbl (%eax),%edx
-	xorl %eax,%eax
+1:	movzb (%eax),%edx
+	xor %eax,%eax
 	ret
 	CFI_ENDPROC
 ENDPROC(__get_user_1)
 
 ENTRY(__get_user_2)
 	CFI_STARTPROC
-	addl $1,%eax
+	add $1,%eax
 	jc bad_get_user
 	GET_THREAD_INFO(%edx)
-	cmpl TI_addr_limit(%edx),%eax
+	cmp TI_addr_limit(%edx),%eax
 	jae bad_get_user
 2:	movzwl -1(%eax),%edx
-	xorl %eax,%eax
+	xor %eax,%eax
 	ret
 	CFI_ENDPROC
 ENDPROC(__get_user_2)
 
 ENTRY(__get_user_4)
 	CFI_STARTPROC
-	addl $3,%eax
+	add $3,%eax
 	jc bad_get_user
 	GET_THREAD_INFO(%edx)
-	cmpl TI_addr_limit(%edx),%eax
+	cmp TI_addr_limit(%edx),%eax
 	jae bad_get_user
-3:	movl -3(%eax),%edx
-	xorl %eax,%eax
+3:	mov -3(%eax),%edx
+	xor %eax,%eax
 	ret
 	CFI_ENDPROC
 ENDPROC(__get_user_4)
 
 bad_get_user:
 	CFI_STARTPROC
-	xorl %edx,%edx
-	movl $-14,%eax
+	xor %edx,%edx
+	mov $-14,%eax
 	ret
 	CFI_ENDPROC
 END(bad_get_user)
-- 
1.5.5.1

