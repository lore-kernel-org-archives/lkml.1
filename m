Return-Path: <linux-kernel-owner+w=401wt.eu-S1423614AbXEAEJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423614AbXEAEJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946597AbXEAEAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:00:45 -0400
Received: from ns1.suse.de ([195.135.220.2]:60949 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbXEAD6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:19 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [20/30] i386: Remove copy_*_user BUG_ONs for (size < 0)
Message-Id: <20070501035818.72C4913CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


access_ok checks this case anyways, no need to check twice.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/lib/usercopy.c |    7 -------
 1 file changed, 7 deletions(-)

Index: linux/arch/i386/lib/usercopy.c
===================================================================
--- linux.orig/arch/i386/lib/usercopy.c
+++ linux/arch/i386/lib/usercopy.c
@@ -716,7 +716,6 @@ do {									\
 unsigned long __copy_to_user_ll(void __user *to, const void *from,
 				unsigned long n)
 {
-	BUG_ON((long) n < 0);
 #ifndef CONFIG_X86_WP_WORKS_OK
 	if (unlikely(boot_cpu_data.wp_works_ok == 0) &&
 			((unsigned long )to) < TASK_SIZE) {
@@ -785,7 +784,6 @@ EXPORT_SYMBOL(__copy_to_user_ll);
 unsigned long __copy_from_user_ll(void *to, const void __user *from,
 					unsigned long n)
 {
-	BUG_ON((long)n < 0);
 	if (movsl_is_ok(to, from, n))
 		__copy_user_zeroing(to, from, n);
 	else
@@ -797,7 +795,6 @@ EXPORT_SYMBOL(__copy_from_user_ll);
 unsigned long __copy_from_user_ll_nozero(void *to, const void __user *from,
 					 unsigned long n)
 {
-	BUG_ON((long)n < 0);
 	if (movsl_is_ok(to, from, n))
 		__copy_user(to, from, n);
 	else
@@ -810,7 +807,6 @@ EXPORT_SYMBOL(__copy_from_user_ll_nozero
 unsigned long __copy_from_user_ll_nocache(void *to, const void __user *from,
 					unsigned long n)
 {
-	BUG_ON((long)n < 0);
 #ifdef CONFIG_X86_INTEL_USERCOPY
 	if ( n > 64 && cpu_has_xmm2)
                 n = __copy_user_zeroing_intel_nocache(to, from, n);
@@ -825,7 +821,6 @@ unsigned long __copy_from_user_ll_nocach
 unsigned long __copy_from_user_ll_nocache_nozero(void *to, const void __user *from,
 					unsigned long n)
 {
-	BUG_ON((long)n < 0);
 #ifdef CONFIG_X86_INTEL_USERCOPY
 	if ( n > 64 && cpu_has_xmm2)
                 n = __copy_user_intel_nocache(to, from, n);
@@ -853,7 +848,6 @@ unsigned long __copy_from_user_ll_nocach
 unsigned long
 copy_to_user(void __user *to, const void *from, unsigned long n)
 {
-	BUG_ON((long) n < 0);
 	if (access_ok(VERIFY_WRITE, to, n))
 		n = __copy_to_user(to, from, n);
 	return n;
@@ -879,7 +873,6 @@ EXPORT_SYMBOL(copy_to_user);
 unsigned long
 copy_from_user(void *to, const void __user *from, unsigned long n)
 {
-	BUG_ON((long) n < 0);
 	if (access_ok(VERIFY_READ, from, n))
 		n = __copy_from_user(to, from, n);
 	else
