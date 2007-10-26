Return-Path: <linux-kernel-owner+w=401wt.eu-S1764685AbXJZSa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764685AbXJZSa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbXJZSaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:30:22 -0400
Received: from www.tglx.de ([62.245.132.106]:58723 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141AbXJZSaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:30:21 -0400
Date: Fri, 26 Oct 2007 20:30:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, James Bottomley <jejb@steeleye.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [Git pull] x86 bugfixes
Message-ID: <alpine.LFD.0.9999.0710262010030.3186@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull x86 bugfixes from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Thanks

	tglx


Thomas Gleixner (2):
      Revert "i386: export i386 smp_call_function_mask() to modules"
      x86: export smp_ops to allow modular build of KVM

 arch/x86/kernel/smp_32.c |    8 +-------
 include/asm-x86/smp_32.h |    9 ++++++---
 2 files changed, 7 insertions(+), 10 deletions(-)
diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index f321153..fcaa026 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -708,10 +708,4 @@ struct smp_ops smp_ops = {
 	.smp_send_reschedule = native_smp_send_reschedule,
 	.smp_call_function_mask = native_smp_call_function_mask,
 };
-
-int smp_call_function_mask(cpumask_t mask, void (*func) (void *info),
-			   void *info, int wait)
-{
-	return smp_ops.smp_call_function_mask(mask, func, info, wait);
-}
-EXPORT_SYMBOL(smp_call_function_mask);
+EXPORT_SYMBOL_GPL(smp_ops);
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 7056d86..e10b7af 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -94,9 +94,12 @@ static inline void smp_send_reschedule(int cpu)
 {
 	smp_ops.smp_send_reschedule(cpu);
 }
-extern int smp_call_function_mask(cpumask_t mask,
-				  void (*func) (void *info), void *info,
-				  int wait);
+static inline int smp_call_function_mask(cpumask_t mask,
+					 void (*func) (void *info), void *info,
+					 int wait)
+{
+	return smp_ops.smp_call_function_mask(mask, func, info, wait);
+}
 
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
