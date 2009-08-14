Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZHNKUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZHNKUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 06:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZHNKUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 06:20:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:44867 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbZHNKUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 06:20:18 -0400
Subject: [PATCH] X86: Fix x86_cache_size value
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 15:49:09 +0530
Message-Id: <1250245149.9062.3.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently x86_cache_size is showing partial value: L1 or L2 or L3.
It should add all caches like L1 + L2 + L3.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/common.c          |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 5ce60a8..581fe17 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -422,7 +422,7 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 		return;		/* Again, no L2 cache is possible */
 #endif
 
-	c->x86_cache_size = l2size;
+	c->x86_cache_size += l2size;
 
 	printk(KERN_INFO "CPU: L2 Cache: %dK (%d bytes/line)\n",
 			l2size, ecx & 0xFF);
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 789efe2..473c75e 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -503,7 +503,7 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 	if (l3)
 		printk(KERN_INFO "CPU: L3 cache: %dK\n", l3);
 
-	c->x86_cache_size = l3 ? l3 : (l2 ? l2 : (l1i+l1d));
+	c->x86_cache_size = l3 + l2 + l1i + l1d;
 
 	return l2;
 }
-- 
1.6.0.6


