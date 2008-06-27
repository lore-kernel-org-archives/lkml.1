Return-Path: <linux-kernel-owner+w=401wt.eu-S1760554AbYF0VwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554AbYF0VwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762002AbYF0Vim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764403AbYF0Vil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:41 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 34/39] Be more explicit in __put_user_x
Date: Fri, 27 Jun 2008 18:34:41 -0300
Message-Id: <1214602486-17080-35-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-34-git-send-email-gcosta@redhat.com>
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
 <1214602486-17080-23-git-send-email-gcosta@redhat.com>
 <1214602486-17080-24-git-send-email-gcosta@redhat.com>
 <1214602486-17080-25-git-send-email-gcosta@redhat.com>
 <1214602486-17080-26-git-send-email-gcosta@redhat.com>
 <1214602486-17080-27-git-send-email-gcosta@redhat.com>
 <1214602486-17080-28-git-send-email-gcosta@redhat.com>
 <1214602486-17080-29-git-send-email-gcosta@redhat.com>
 <1214602486-17080-30-git-send-email-gcosta@redhat.com>
 <1214602486-17080-31-git-send-email-gcosta@redhat.com>
 <1214602486-17080-32-git-send-email-gcosta@redhat.com>
 <1214602486-17080-33-git-send-email-gcosta@redhat.com>
 <1214602486-17080-34-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For both __put_user_x and __put_user_8 macros, pass the error
variable explicitly.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess_32.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index ebfe6b2..2c90673 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -31,11 +31,11 @@ extern void __put_user_2(void);
 extern void __put_user_4(void);
 extern void __put_user_8(void);
 
-#define __put_user_x(size, x, ptr)				\
+#define __put_user_x(size, x, ptr, __ret_pu)			\
 	asm volatile("call __put_user_" #size : "=a" (__ret_pu)	\
 		     :"0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 
-#define __put_user_8(x, ptr)					\
+#define __put_user_8(x, ptr, __ret_pu)				\
 	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
 		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 
@@ -66,19 +66,19 @@ extern void __put_user_8(void);
 	__pu_val = x;						\
 	switch (sizeof(*(ptr))) {				\
 	case 1:							\
-		__put_user_x(1, __pu_val, ptr);			\
+		__put_user_x(1, __pu_val, ptr, __ret_pu);	\
 		break;						\
 	case 2:							\
-		__put_user_x(2, __pu_val, ptr);			\
+		__put_user_x(2, __pu_val, ptr, __ret_pu);	\
 		break;						\
 	case 4:							\
-		__put_user_x(4, __pu_val, ptr);			\
+		__put_user_x(4, __pu_val, ptr, __ret_pu);	\
 		break;						\
 	case 8:							\
-		__put_user_8(__pu_val, ptr);			\
+		__put_user_8(__pu_val, ptr, __ret_pu);		\
 		break;						\
 	default:						\
-		__put_user_x(X, __pu_val, ptr);			\
+		__put_user_x(X, __pu_val, ptr, __ret_pu);	\
 		break;						\
 	}							\
 	__ret_pu;						\
-- 
1.5.5.1

