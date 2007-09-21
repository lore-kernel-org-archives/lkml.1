Return-Path: <linux-kernel-owner+w=401wt.eu-S932658AbXIUWmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbXIUWmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763861AbXIUWcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:35 -0400
Received: from mx1.suse.de ([195.135.220.2]:57063 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763631AbXIUWc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:26 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: Laurent.Vivier@bull.net, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [26/50] i386: export i386 smp_call_function_mask() to modules
Message-Id: <20070921223225.88F691479D@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Laurent Vivier <Laurent.Vivier@bull.net>

This patch export i386 smp_call_function_mask() with EXPORT_SYMBOL().

This function is needed by KVM to call a function on a set of CPUs.

 arch/i386/kernel/smp.c |    7 +++++++
 include/asm-i386/smp.h |    9 +++------
 2 files changed, 10 insertions(+), 6 deletions(-)

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>


Index: linux/arch/i386/kernel/smp.c
===================================================================
--- linux.orig/arch/i386/kernel/smp.c
+++ linux/arch/i386/kernel/smp.c
@@ -708,3 +708,10 @@ struct smp_ops smp_ops = {
 	.smp_send_reschedule = native_smp_send_reschedule,
 	.smp_call_function_mask = native_smp_call_function_mask,
 };
+
+int smp_call_function_mask(cpumask_t mask, void (*func) (void *info),
+			   void *info, int wait)
+{
+	return smp_ops.smp_call_function_mask(mask, func, info, wait);
+}
+EXPORT_SYMBOL(smp_call_function_mask);
Index: linux/include/asm-i386/smp.h
===================================================================
--- linux.orig/include/asm-i386/smp.h
+++ linux/include/asm-i386/smp.h
@@ -92,12 +92,9 @@ static inline void smp_send_reschedule(i
 {
 	smp_ops.smp_send_reschedule(cpu);
 }
-static inline int smp_call_function_mask(cpumask_t mask,
-					 void (*func) (void *info), void *info,
-					 int wait)
-{
-	return smp_ops.smp_call_function_mask(mask, func, info, wait);
-}
+extern int smp_call_function_mask(cpumask_t mask,
+				  void (*func) (void *info), void *info,
+				  int wait);
 
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
