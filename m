Return-Path: <linux-kernel-owner+w=401wt.eu-S1761009AbZATAhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761009AbZATAhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbZATAhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:37:43 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:8379 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbZATAhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:37:43 -0500
Message-ID: <49751CD5.1060902@ct.jp.nec.com>
Date: Mon, 19 Jan 2009 16:37:41 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: uaccess: rename __put_user_u64() to __put_user_asm_u64()
References: <49751C12.1030104@ct.jp.nec.com>
In-Reply-To: <49751C12.1030104@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

rename __put_user_u64() to __put_user_asm_u64() like __get_user_asm_u64().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/uaccess.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index aeb3c1b..69d2757 100644
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
 		__put_user_asm(x, ptr, retval, "l", "k", "ir", errret);	\
 		break;							\
 	case 8:								\
-		__put_user_u64((__typeof__(*ptr))(x), ptr, retval);	\
+		__put_user_asm_u64((__typeof__(*ptr))(x), ptr, retval);	\
 		break;							\
 	default:							\
 		__put_user_bad();					\
-- 
1.6.0.4

