Return-Path: <linux-kernel-owner+w=401wt.eu-S1761170AbZCZUvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761170AbZCZUvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbZCZUvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:51:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33495 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756226AbZCZUvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:51:12 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] x86: Fix a header leak from headers_check
To: linux-kernel@vger.kernel.org, mingo@redhat.com
Date: Thu, 26 Mar 2009 20:51:49 +0000
Message-ID: <20090326205142.5190.76510.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One less warning (and many of the others are header check script bugs)

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 arch/x86/include/asm/prctl.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/arch/x86/include/asm/prctl.h b/arch/x86/include/asm/prctl.h
index a889464..ecd18fd 100644
--- a/arch/x86/include/asm/prctl.h
+++ b/arch/x86/include/asm/prctl.h
@@ -6,8 +6,10 @@
 #define ARCH_GET_FS 0x1003
 #define ARCH_GET_GS 0x1004
 
+#ifdef __KERNEL__
 #ifdef CONFIG_X86_64
 extern long sys_arch_prctl(int, unsigned long);
 #endif /* CONFIG_X86_64 */
+#endif
 
 #endif /* _ASM_X86_PRCTL_H */

