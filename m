Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbXLDStX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbXLDStX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXLDSs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:48:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbXLDSs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:48:26 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 2/10] unify msr smp funcs
Date: Tue,  4 Dec 2007 14:03:52 -0200
Message-Id: <11967842531735-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11967842482873-git-send-email-gcosta@redhat.com>
References: 20071204140939.GA16328@elte.hu <11967842402729-git-send-email-gcosta@redhat.com> <11967842482873-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions under #ifdef CONFIG_SMP in msr.h are the same
for both x86_64 and i386, and this patches removes one of them,
putting them in a single location

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/msr.h |   33 +++++++--------------------------
 1 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index ba4b314..b3cd509 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -135,29 +135,6 @@ static inline int wrmsr_safe(u32 __msr, u32 __low, u32 __high)
 	} while(0)
 #endif	/* !CONFIG_PARAVIRT */
 
-#ifdef CONFIG_SMP
-void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
-void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
-int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
-int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
-#else  /*  CONFIG_SMP  */
-static inline void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
-{
-	rdmsr(msr_no, *l, *h);
-}
-static inline void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
-{
-	wrmsr(msr_no, l, h);
-}
-static inline int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
-{
-	return rdmsr_safe(msr_no, l, h);
-}
-static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
-{
-	return wrmsr_safe(msr_no, l, h);
-}
-#endif  /*  CONFIG_SMP  */
 #endif  /* ! __ASSEMBLY__ */
 #endif  /* __KERNEL__ */
 
@@ -320,6 +297,12 @@ static inline unsigned int cpuid_edx(unsigned int op)
 	return edx;
 }
 
+#endif  /* __ASSEMBLY__ */
+
+#endif  /* !__i386__ */
+
+#ifndef __ASSEMBLY__
+
 #ifdef CONFIG_SMP
 void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
@@ -343,8 +326,6 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 	return wrmsr_safe(msr_no, l, h);
 }
 #endif  /* CONFIG_SMP */
-#endif  /* __ASSEMBLY__ */
-
-#endif  /* !__i386__ */
+#endif /* __ASSEMBLY__ */
 
 #endif
-- 
1.4.4.2

