Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbZFLNcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbZFLNcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932223AbZFLN0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:26:05 -0400
Received: from ozlabs.org ([203.10.76.45]:55001 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761723AbZFLN0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:26:00 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:04 +0930
Subject: [PATCH 12/17] cpumask: remove the deprecated smp_call_function_mask()
Message-Id: <20090612132602.3C972DDDB6@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Everyone is now using smp_call_function_many().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/smp.h |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -72,15 +72,6 @@ int smp_call_function(void(*func)(void *
 int smp_call_function(void(*func)(void *info), void *info, int wait);
 void smp_call_function_many(const struct cpumask *mask,
 			    void (*func)(void *info), void *info, bool wait);
-
-/* Deprecated: Use smp_call_function_many which takes a pointer to the mask. */
-static inline int
-smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
-		       int wait)
-{
-	smp_call_function_many(&mask, func, info, wait);
-	return 0;
-}
 
 void __smp_call_function_single(int cpuid, struct call_single_data *data,
 				int wait);
@@ -144,8 +135,6 @@ static inline void smp_send_reschedule(i
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
-#define smp_call_function_mask(mask, func, info, wait) \
-			(up_smp_call_function(func, info))
 #define smp_call_function_many(mask, func, info, wait) \
 			(up_smp_call_function(func, info))
 static inline void init_call_single_data(void)

