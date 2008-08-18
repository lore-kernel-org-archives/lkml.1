Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbYHREQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbYHREQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 00:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYHREQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 00:16:26 -0400
Received: from ozlabs.org ([203.10.76.45]:46806 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbYHREQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 00:16:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] Remove deprecated stop_machine_run
Date: Mon, 18 Aug 2008 14:15:01 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
References: <200808181414.11164.rusty@rustcorp.com.au>
In-Reply-To: <200808181414.11164.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181415.01344.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Everyone should be using stop_machine() now.  The staged API
transition helped life in linux-next.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/stop_machine.h |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff -r 80bd8b4418f0 include/linux/stop_machine.h
--- a/include/linux/stop_machine.h	Wed Aug 13 15:55:29 2008 +1000
+++ b/include/linux/stop_machine.h	Wed Aug 13 15:57:08 2008 +1000
@@ -3,15 +3,12 @@
 /* "Bogolock": stop the entire machine, disable interrupts.  This is a
    very heavy lock, which is equivalent to grabbing every spinlock
    (and more).  So the "read" side to such a lock is anything which
-   diables preeempt. */
+   disables preeempt. */
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
 #include <asm/system.h>
 
 #if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
-
-/* Deprecated, but useful for transition. */
-#define ALL_CPUS ~0U
 
 /**
  * stop_machine: freeze the machine on all CPUs and run this function
@@ -50,18 +47,4 @@ static inline int stop_machine(int (*fn)
 	return ret;
 }
 #endif /* CONFIG_SMP */
-
-static inline int __deprecated stop_machine_run(int (*fn)(void *), void *data,
-						unsigned int cpu)
-{
-	/* If they don't care which cpu fn runs on, just pick one. */
-	if (cpu == NR_CPUS)
-		return stop_machine(fn, data, NULL);
-	else if (cpu == ~0U)
-		return stop_machine(fn, data, &cpu_possible_map);
-	else {
-		cpumask_t cpus = cpumask_of_cpu(cpu);
-		return stop_machine(fn, data, &cpus);
-	}
-}
 #endif /* _LINUX_STOP_MACHINE */
