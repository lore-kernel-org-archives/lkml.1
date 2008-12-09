Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbYLIDSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbYLIDSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 22:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYLIDSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 22:18:41 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:58772 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYLIDSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 22:18:40 -0500
Message-ID: <493DE38E.60505@ct.jp.nec.com>
Date: Mon, 08 Dec 2008 19:18:38 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: uaccess: return value of __{get|put}_user() can be int
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

The type of return value of __{get|put}_user() can be int.
There is no user to refer the return value of __{get|put}_user() as long.
This reduces code size a bit on 64-bit.

$ size vmlinux.*
   text	   data	    bss	    dec	    hex	filename
4509265	 479988	 673588	5662841	 566879	vmlinux.new
4511462	 479988	 673588	5665038	 56710e	vmlinux.old

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/uaccess.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 99192bb..4340055 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -352,14 +352,14 @@ do {									\
 
 #define __put_user_nocheck(x, ptr, size)			\
 ({								\
-	long __pu_err;						\
+	int __pu_err;						\
 	__put_user_size((x), (ptr), (size), __pu_err, -EFAULT);	\
 	__pu_err;						\
 })
 
 #define __get_user_nocheck(x, ptr, size)				\
 ({									\
-	long __gu_err;							\
+	int __gu_err;							\
 	unsigned long __gu_val;						\
 	__get_user_size(__gu_val, (ptr), (size), __gu_err, -EFAULT);	\
 	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
-- 
1.6.0.4

