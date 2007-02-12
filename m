Return-Path: <linux-kernel-owner+w=401wt.eu-S965017AbXBLQzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965017AbXBLQzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965015AbXBLQzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:55:12 -0500
Received: from mail.suse.de ([195.135.220.2]:47948 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964994AbXBLQvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:39 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [17/29] x86: Add new CPUID bits for AMD Family 10 CPUs in /proc/cpuinfo
Message-Id: <20070212165137.AD85913E1B@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Just various new acronyms. The new popcnt bit is in the middle
of Intel space. This looks a little weird, but I've been assured
it's ok.

Also I fixed RDTSCP for i386 which was at the wrong place.

For i386 and x86-64.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/proc.c |   14 +++++++++-----
 arch/x86_64/kernel/setup.c  |   14 ++++++++++----
 2 files changed, 19 insertions(+), 9 deletions(-)

Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -942,7 +942,8 @@ static int show_cpuinfo(struct seq_file 
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, "syscall", NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, "nx", NULL, "mmxext", NULL,
-		NULL, "fxsr_opt", NULL, "rdtscp", NULL, "lm", "3dnowext", "3dnow",
+		NULL, "fxsr_opt", "pdpe1gb", "rdtscp", NULL, "lm",
+		"3dnowext", "3dnow",
 
 		/* Transmeta-defined */
 		"recovery", "longrun", NULL, "lrti", NULL, NULL, NULL, NULL,
@@ -960,7 +961,7 @@ static int show_cpuinfo(struct seq_file 
 		/* Intel-defined (#2) */
 		"pni", NULL, NULL, "monitor", "ds_cpl", "vmx", "smx", "est",
 		"tm2", "ssse3", "cid", NULL, NULL, "cx16", "xtpr", NULL,
-		NULL, NULL, "dca", NULL, NULL, NULL, NULL, NULL,
+		NULL, NULL, "dca", NULL, NULL, NULL, NULL, "popcnt",
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 		/* VIA/Cyrix/Centaur-defined */
@@ -970,8 +971,10 @@ static int show_cpuinfo(struct seq_file 
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 		/* AMD-defined (#2) */
-		"lahf_lm", "cmp_legacy", "svm", NULL, "cr8_legacy", NULL, NULL, NULL,
-		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		"lahf_lm", "cmp_legacy", "svm", "extapic", "cr8_legacy",
+		"altmovcr8", "abm", "sse4a",
+		"misalignsse", "3dnowprefetch",
+		"osvw", "ibs", NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 	};
@@ -982,6 +985,9 @@ static int show_cpuinfo(struct seq_file 
 		"ttp",  /* thermal trip */
 		"tm",
 		"stc",
+		"100mhzsteps",
+		"hwpstate",
+		NULL,	/* tsc invariant mapped to constant_tsc */
 		NULL,
 		/* nothing */	/* constant_tsc - moved to flags */
 	};
Index: linux/arch/i386/kernel/cpu/proc.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/proc.c
+++ linux/arch/i386/kernel/cpu/proc.c
@@ -29,7 +29,7 @@ static int show_cpuinfo(struct seq_file 
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, "syscall", NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, "mp", "nx", NULL, "mmxext", NULL,
-		NULL, "fxsr_opt", "rdtscp", NULL, NULL, "lm", "3dnowext", "3dnow",
+		NULL, "fxsr_opt", "pdpe1gb", "rdtscp", NULL, "lm", "3dnowext", "3dnow",
 
 		/* Transmeta-defined */
 		"recovery", "longrun", NULL, "lrti", NULL, NULL, NULL, NULL,
@@ -47,7 +47,7 @@ static int show_cpuinfo(struct seq_file 
 		/* Intel-defined (#2) */
 		"pni", NULL, NULL, "monitor", "ds_cpl", "vmx", "smx", "est",
 		"tm2", "ssse3", "cid", NULL, NULL, "cx16", "xtpr", NULL,
-		NULL, NULL, "dca", NULL, NULL, NULL, NULL, NULL,
+		NULL, NULL, "dca", NULL, NULL, NULL, NULL, "popcnt",
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 		/* VIA/Cyrix/Centaur-defined */
@@ -57,8 +57,9 @@ static int show_cpuinfo(struct seq_file 
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 		/* AMD-defined (#2) */
-		"lahf_lm", "cmp_legacy", "svm", NULL, "cr8legacy", NULL, NULL, NULL,
-		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		"lahf_lm", "cmp_legacy", "svm", "extapic", "cr8legacy", "abm",
+		"sse4a", "misalignsse",
+		"3dnowprefetch", "osvw", "ibs", NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 	};
@@ -69,8 +70,11 @@ static int show_cpuinfo(struct seq_file 
 		"ttp",  /* thermal trip */
 		"tm",
 		"stc",
+		"100mhzsteps",
+		"hwpstate",
 		NULL,
-		/* nothing */	/* constant_tsc - moved to flags */
+		NULL,	/* constant_tsc - moved to flags */
+		/* nothing */
 	};
 	struct cpuinfo_x86 *c = v;
 	int i, n = c - cpu_data;
