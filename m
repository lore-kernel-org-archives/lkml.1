Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYKLM3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYKLM3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:29:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYKLM1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:27:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39787 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYKLM1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:27:42 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20081112145.328971960@firstfloor.org>
In-Reply-To: <20081112145.328971960@firstfloor.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: [PATCH] [4/4] SCHED: Use a lookup array in sd_level_to_string
Message-Id: <20081112124512.6EEF63E6610@basil.firstfloor.org>
Date: Wed, 12 Nov 2008 13:45:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Generates better/shorter code. Doesn't matter much because it's only
a SCHED_DEBUG function. 

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/sched.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

Index: linux-2.6.28-rc4-test/kernel/sched.c
===================================================================
--- linux-2.6.28-rc4-test.orig/kernel/sched.c	2008-11-12 12:36:23.000000000 +0100
+++ linux-2.6.28-rc4-test/kernel/sched.c	2008-11-12 12:43:58.000000000 +0100
@@ -6629,24 +6629,17 @@
 
 static inline const char *sd_level_to_string(enum sched_domain_level lvl)
 {
-	switch (lvl) {
-	case SD_LV_NONE:
-			return "NONE";
-	case SD_LV_SIBLING:
-			return "SIBLING";
-	case SD_LV_MC:
-			return "MC";
-	case SD_LV_CPU:
-			return "CPU";
-	case SD_LV_NODE:
-			return "NODE";
-	case SD_LV_ALLNODES:
-			return "ALLNODES";
-	case SD_LV_MAX:
-			return "MAX";
-
-	}
-	return "MAX";
+	static const char *lva[] = {
+#define T(x) [SD_LV_ ## x ] = #T
+		T(NONE),
+		T(SIBLING),
+		T(MC),
+		T(CPU),
+		T(NODE),
+		T(ALLNODES),
+#undef T
+	};
+	return (unsigned)lvl < ARRAY_SIZE(lva) ? lva[lvl] : "MAX";
 }
 
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
