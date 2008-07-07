Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbYGGXLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbYGGXLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757969AbYGGXLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:11:11 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:2565 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbYGGXLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:11:10 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080708110.487722491@firstfloor.org>
In-Reply-To: <20080708110.487722491@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/10] MCE: Rename mce_dont_init on 64bit to mce_disabled
Message-Id: <20080707231007.98F8C1B4315@basil.firstfloor.org>
Date: Tue,  8 Jul 2008 01:10:07 +0200 (CEST)
X-OriginalArrivalTime: 07 Jul 2008 23:02:43.0510 (UTC) FILETIME=[903ABD60:01C8E085]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This way they are the same between 32bit and 64bit and no special
cases needed. The semantics were always the same.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    8 ++++----
 include/asm-x86/mce.h               |    2 --
 2 files changed, 4 insertions(+), 6 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -35,7 +35,7 @@
 
 atomic_t mce_entry;
 
-static int mce_dont_init;
+int mce_disabled __cpuinitdata;
 
 /*
  * Tolerant levels:
@@ -535,7 +535,7 @@ void __cpuinit mcheck_init(struct cpuinf
 
 	mce_cpu_quirks(c);
 
-	if (mce_dont_init ||
+	if (mce_disabled ||
 	    cpu_test_and_set(smp_processor_id(), mce_cpus) ||
 	    !mce_available(c))
 		return;
@@ -722,7 +722,7 @@ void __init restart_mce(void)
  */
 static int __init mcheck_disable(char *str)
 {
-	mce_dont_init = 1;
+	mce_disabled = 1;
 	return 1;
 }
 
@@ -734,7 +734,7 @@ static int __init mcheck_disable(char *s
 static int __init mcheck_enable(char *str)
 {
 	if (!strcmp(str, "off"))
-		mce_dont_init = 1;
+		mce_disabled = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str,"nobootlog"))
 		mce_bootlog = str[0] == 'b';
 	else if (isdigit(str[0]))
Index: linux/include/asm-x86/mce.h
===================================================================
--- linux.orig/include/asm-x86/mce.h
+++ linux/include/asm-x86/mce.h
@@ -84,9 +84,7 @@ struct mce_log {
 
 #ifdef __KERNEL__
 
-#ifdef CONFIG_X86_32
 extern int mce_disabled;
-#else /* CONFIG_X86_32 */
 
 #include <asm/atomic.h>
 
