Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbZFLN3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbZFLN3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760254AbZFLNZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:25:59 -0400
Received: from ozlabs.org ([203.10.76.45]:54990 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759169AbZFLNZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:57 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:04 +0930
Subject: [PATCH 6/17] cpumask: remove dangerous CPU_MASK_ALL_PTR
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mike Travis <travis@sgi.com>
Message-Id: <20090612132558.F3B4DDDDA1@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Thanks to Al Viro for reminding me of this, via Ingo)

CPU_MASK_ALL is the (deprecated) "all bits set" cpumask, defined as so:

	#define CPU_MASK_ALL (cpumask_t) { { ... } }

Taking the address of such a temporary is questionable at best,
unfortunately 321a8e9d (cpumask: add CPU_MASK_ALL_PTR macro) added
CPU_MASK_ALL_PTR:

	#define CPU_MASK_ALL_PTR (&CPU_MASK_ALL)

Which formalizes this practice.  One day gcc could bite us over this
usage (though we seem to have gotten away with it so far).

Now all callers are removed, we kill it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Ingo Molnar <mingo@elte.hu>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -324,8 +324,6 @@ static inline const struct cpumask *get_
 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
 } }
 
-#define CPU_MASK_ALL_PTR	(&CPU_MASK_ALL)
-
 #else
 
 #define CPU_MASK_ALL							\
@@ -333,7 +331,6 @@ static inline const struct cpumask *get_
 
 /* cpu_mask_all is in init/main.c */
 extern cpumask_t cpu_mask_all;
-#define CPU_MASK_ALL_PTR	(&cpu_mask_all)
 
 #endif
 

