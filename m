Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbYLRWrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbYLRWrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:47:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYLRWqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:46:54 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:49040 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbYLRWqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:46:53 -0500
Message-ID: <494AD2DC.5090402@ct.jp.nec.com>
Date: Thu, 18 Dec 2008 14:46:52 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: asm-offset_64: use rt_sigframe_ia32
References: <494AD216.1050002@ct.jp.nec.com>
In-Reply-To: <494AD216.1050002@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Use rt_sigframe_ia32 instead of rt_sigframe32.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/asm-offsets_64.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 7fcf63d..1d41d3f 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -20,6 +20,8 @@
 
 #include <xen/interface/xen.h>
 
+#include <asm/sigframe.h>
+
 #define __NO_STUBS 1
 #undef __SYSCALL
 #undef _ASM_X86_UNISTD_64_H
@@ -87,7 +89,7 @@ int main(void)
 	BLANK();
 #undef ENTRY
 	DEFINE(IA32_RT_SIGFRAME_sigcontext,
-	       offsetof (struct rt_sigframe32, uc.uc_mcontext));
+	       offsetof (struct rt_sigframe_ia32, uc.uc_mcontext));
 	BLANK();
 #endif
 	DEFINE(pbe_address, offsetof(struct pbe, address));
-- 
1.6.0.4

