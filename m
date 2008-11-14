Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYKNCGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYKNCGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 21:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbYKNCGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 21:06:08 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:59874 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbYKNCGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 21:06:06 -0500
Message-ID: <491CDD0C.60405@ct.jp.nec.com>
Date: Thu, 13 Nov 2008 18:06:04 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: uaccess_64: fix return value in __copy_from_user()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

__copy_from_user() will return invalid value 16 when it fails to
access user space and the size is 10.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/uaccess_64.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 543ba88..84210c4 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -48,7 +48,7 @@ int __copy_from_user(void *dst, const void __user *src, unsigned size)
 		return ret;
 	case 10:
 		__get_user_asm(*(u64 *)dst, (u64 __user *)src,
-			       ret, "q", "", "=r", 16);
+			       ret, "q", "", "=r", 10);
 		if (unlikely(ret))
 			return ret;
 		__get_user_asm(*(u16 *)(8 + (char *)dst),
-- 
1.5.6

