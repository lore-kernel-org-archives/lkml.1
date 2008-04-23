Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbYDWP4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbYDWP4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 11:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbYDWP4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 11:56:40 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41714 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbYDWP4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 11:56:40 -0400
Date: Wed, 23 Apr 2008 18:55:59 +0300
From: Adrian Bunk <bunk@kernel.org>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] asm-mips/mach-ip27/topology.h must #include
	<asm-generic/topology.h>
Message-ID: <20080423155559.GR28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error:

<--  snip  -->

...
  CC      kernel/sched.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/sched.c: In function 'find_next_best_node':
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/sched.c:7015: error: implicit declaration of function 'node_to_cpumask_ptr'
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/sched.c:7015: error: '__tmp__' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/sched.c:7015: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/sched.c:7015: error: for each function it appears in.)
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/sched.c: In function 'sched_domain_node_span':
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/sched.c:7047: error: 'nodemask' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/sched.c:7048: warning: ISO C90 forbids mixed declarations and code
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/sched.c:7059: error: implicit declaration of function 'node_to_cpumask_ptr_next'
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/sched.c: In function '__build_sched_domains':
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/sched.c:7605: error: 'pnodemask' undeclared (first use in this function)
make[2]: *** [kernel/sched.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
95146e0f305fd55f05b24d26dd671b5b0a1f657c diff --git a/include/asm-mips/mach-ip27/topology.h b/include/asm-mips/mach-ip27/topology.h
index 372291f..7785bec 100644
--- a/include/asm-mips/mach-ip27/topology.h
+++ b/include/asm-mips/mach-ip27/topology.h
@@ -54,4 +54,6 @@ extern unsigned char __node_distances[MAX_COMPACT_NODES][MAX_COMPACT_NODES];
 	.nr_balance_failed	= 0,			\
 }
 
+#include <asm-generic/topology.h>
+
 #endif /* _ASM_MACH_TOPOLOGY_H */

