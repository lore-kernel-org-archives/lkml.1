Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbYCCRPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbYCCRPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYCCRON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:14:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293AbYCCROH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:07 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 05/52] move smp_ops extern declaration to common header
Date: Mon,  3 Mar 2008 14:12:33 -0300
Message-Id: <1204564400-17636-6-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-5-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the smp_ops symbol is temporarily defined in smp_64.c, but it will soon
be unified

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smp_64.c |    2 ++
 include/asm-x86/smp.h    |    3 +++
 include/asm-x86/smp_32.h |    2 --
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index 2fd74b0..80dba12 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -528,3 +528,5 @@ asmlinkage void smp_call_function_interrupt(void)
 	}
 }
 
+struct smp_ops smp_ops;
+EXPORT_SYMBOL_GPL(smp_ops);
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index d11b92b..ee98bee 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -21,6 +21,9 @@ struct smp_ops {
 				      int wait);
 };
 
+#ifdef CONFIG_SMP
+extern struct smp_ops smp_ops;
+#endif
 
 #ifdef CONFIG_X86_32
 # include "smp_32.h"
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 72faad6..74755e8 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -39,8 +39,6 @@ extern void remove_siblinginfo(int cpu);
 extern void set_cpu_sibling_map(int cpu);
 
 #ifdef CONFIG_SMP
-extern struct smp_ops smp_ops;
-
 static inline void smp_prepare_boot_cpu(void)
 {
 	smp_ops.smp_prepare_boot_cpu();
-- 
1.5.0.6

