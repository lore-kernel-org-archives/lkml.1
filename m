Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYHOAZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYHOAZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 20:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYHOAZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 20:25:40 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:59235 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYHOAZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 20:25:40 -0400
Message-ID: <48A4CD01.9080805@ct.jp.nec.com>
Date: Thu, 14 Aug 2008 17:25:37 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Jeff Dike <jdike@addtoit.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -tip] x86_64: uml: fix rename header guard
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

In unistd_64.h, the guard macro _ASM_X86_64_UNISTD_H_ is renamed to
ASM_X86__UNISTD_64_H.

This change should be applied to arch/um/sys-x86_64/syscall_table.c.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/um/sys-x86_64/syscall_table.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/sys-x86_64/syscall_table.c b/arch/um/sys-x86_64/syscall_table.c
index c128eb8..32f5fbe 100644
--- a/arch/um/sys-x86_64/syscall_table.c
+++ b/arch/um/sys-x86_64/syscall_table.c
@@ -41,12 +41,12 @@
 #define stub_rt_sigreturn sys_rt_sigreturn
 
 #define __SYSCALL(nr, sym) extern asmlinkage void sym(void) ;
-#undef _ASM_X86_64_UNISTD_H_
+#undef ASM_X86__UNISTD_64_H
 #include <asm-x86/unistd_64.h>
 
 #undef __SYSCALL
 #define __SYSCALL(nr, sym) [ nr ] = sym,
-#undef _ASM_X86_64_UNISTD_H_
+#undef ASM_X86__UNISTD_64_H
 
 typedef void (*sys_call_ptr_t)(void);
 
-- 
1.5.6

