Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYLWFWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYLWFWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 00:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYLWFWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 00:22:24 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:51990 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYLWFWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 00:22:23 -0500
Message-ID: <4950758D.2000707@ct.jp.nec.com>
Date: Mon, 22 Dec 2008 21:22:21 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC -tip 1/4] x86: uaccess: rename __put_user_u64() to __put_user_asm_u64()
References: <49507534.5080401@ct.jp.nec.com>
In-Reply-To: <49507534.5080401@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Rename __put_user_u64() to __put_user_asm_u64() like __get_user_asm_u64().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/uaccess.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 4340055..1a38180 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -186,7 +186,7 @@ extern int __get_user_bad(void);
 
 
 #ifdef CONFIG_X86_32
-#define __put_user_u64(x, addr, err)					\
+#define __put_user_asm_u64(x, addr, err)				\
 	asm volatile("1:	movl %%eax,0(%2)\n"			\
 		     "2:	movl %%edx,4(%2)\n"			\
 		     "3:\n"						\
@@ -203,7 +203,7 @@ extern int __get_user_bad(void);
 	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
 		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 #else
-#define __put_user_u64(x, ptr, retval) \
+#define __put_user_asm_u64(x, ptr, retval) \
 	__put_user_asm(x, ptr, retval, "q", "", "Zr", -EFAULT)
 #define __put_user_x8(x, ptr, __ret_pu) __put_user_x(8, x, ptr, __ret_pu)
 #endif
@@ -279,7 +279,7 @@ do {									\
 		__put_user_asm(x, ptr, retval, "l", "k",  "ir", errret);\
 		break;							\
 	case 8:								\
-		__put_user_u64((__typeof__(*ptr))(x), ptr, retval);	\
+		__put_user_asm_u64((__typeof__(*ptr))(x), ptr, retval);	\
 		break;							\
 	default:							\
 		__put_user_bad();					\
-- 
1.6.0.4

