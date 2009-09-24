Return-Path: <linux-kernel-owner+w=401wt.eu-S1752533AbZIXMTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbZIXMTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZIXMTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:19:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:53385 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbZIXMT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:19:28 -0400
Date: Thu, 24 Sep 2009 12:18:52 GMT
From: tip-bot for Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, torvalds@linux-foundation.org,
       rusty@rustcorp.com.au, jbarnes@virtuousgeek.org, gregkh@suse.de,
       tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au,
       torvalds@linux-foundation.org, jbarnes@virtuousgeek.org, gregkh@suse.de,
       tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200909241748.45629.rusty@rustcorp.com.au>
References: <200909241748.45629.rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Remove redundant non-NUMA topology functions
Message-ID: <tip-b0c6fbe458183cc7e1cab17be6efcbe7e435bad3@git.kernel.org>
Git-Commit-ID: b0c6fbe458183cc7e1cab17be6efcbe7e435bad3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 12:18:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0c6fbe458183cc7e1cab17be6efcbe7e435bad3
Gitweb:     http://git.kernel.org/tip/b0c6fbe458183cc7e1cab17be6efcbe7e435bad3
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Thu, 24 Sep 2009 17:48:44 +0930
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Sep 2009 14:16:15 +0200

x86: Remove redundant non-NUMA topology functions

arch/x86/include/asm/topology.h declares inline fns cpu_to_node and
cpumask_of_node for !NUMA, even though they are then declared as
macros by asm-generic/topology.h, which is #included just below.

The macros (which are the same) end up being used; these functions
are just confusing.

Noticed-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
LKML-Reference: <200909241748.45629.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/topology.h |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 6f0695d..25a9284 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -165,21 +165,11 @@ static inline int numa_node_id(void)
 	return 0;
 }
 
-static inline int cpu_to_node(int cpu)
-{
-	return 0;
-}
-
 static inline int early_cpu_to_node(int cpu)
 {
 	return 0;
 }
 
-static inline const struct cpumask *cpumask_of_node(int node)
-{
-	return cpu_online_mask;
-}
-
 static inline void setup_node_to_cpumask_map(void) { }
 
 #endif
