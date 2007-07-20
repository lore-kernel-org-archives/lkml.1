Return-Path: <linux-kernel-owner+w=401wt.eu-S936052AbXGTAGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936052AbXGTAGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761280AbXGTAGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:06:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60821 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761279AbXGTAGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:06:34 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] use __val in __get_unaligned
Date: Thu, 19 Jul 2007 20:06:40 -0400
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707192006.40884.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses "__val" rather than "val" in the __get_unaligned macro in
asm-generic/unaligned.h.  This way gcc wont warn if you happen to also name
something in the same scope "val".

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/asm-generic/unaligned.h b/include/asm-generic/unaligned.h
index 16a466e..2fe1b2e 100644
--- a/include/asm-generic/unaligned.h
+++ b/include/asm-generic/unaligned.h
@@ -79,24 +79,24 @@ static inline void __ustw(__u16 val, __u16 *addr)
 
 #define __get_unaligned(ptr, size) ({		\
 	const void *__gu_p = ptr;		\
-	__u64 val;				\
+	__u64 __val;				\
 	switch (size) {				\
 	case 1:					\
-		val = *(const __u8 *)__gu_p;	\
+		__val = *(const __u8 *)__gu_p;	\
 		break;				\
 	case 2:					\
-		val = __uldw(__gu_p);		\
+		__val = __uldw(__gu_p);		\
 		break;				\
 	case 4:					\
-		val = __uldl(__gu_p);		\
+		__val = __uldl(__gu_p);		\
 		break;				\
 	case 8:					\
-		val = __uldq(__gu_p);		\
+		__val = __uldq(__gu_p);		\
 		break;				\
 	default:				\
 		bad_unaligned_access_length();	\
 	};					\
-	(__force __typeof__(*(ptr)))val;	\
+	(__force __typeof__(*(ptr)))__val;	\
 })
 
 #define __put_unaligned(val, ptr, size)		\
