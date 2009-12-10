Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbZLJInS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbZLJInS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758242AbZLJInR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:43:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:51681 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749AbZLJInL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:43:11 -0500
Date: Thu, 10 Dec 2009 08:42:49 GMT
From: tip-bot for Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joe@perches.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <7ead24eccbea8f2b11795abad3e2893a98e1e111.1260383912.git.joe@perches.com>
References: <7ead24eccbea8f2b11795abad3e2893a98e1e111.1260383912.git.joe@perches.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: setup_percpu.c: Use pr_<level> and add pr_fmt(fmt)
Message-ID: <tip-40685236b3161b80030a4df34bcbc5941ea59876@git.kernel.org>
Git-Commit-ID: 40685236b3161b80030a4df34bcbc5941ea59876
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40685236b3161b80030a4df34bcbc5941ea59876
Gitweb:     http://git.kernel.org/tip/40685236b3161b80030a4df34bcbc5941ea59876
Author:     Joe Perches <joe@perches.com>
AuthorDate: Wed, 9 Dec 2009 10:45:34 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 08:57:50 +0100

x86: setup_percpu.c: Use pr_<level> and add pr_fmt(fmt)

- Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 - Stripped PERCPU: from a pr_warning

Signed-off-by: Joe Perches <joe@perches.com>
LKML-Reference: <7ead24eccbea8f2b11795abad3e2893a98e1e111.1260383912.git.joe@perches.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup_percpu.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index d559af9..35abcb8 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -20,9 +22,9 @@
 #include <asm/stackprotector.h>
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
-# define DBG(x...) printk(KERN_DEBUG x)
+# define DBG(fmt, ...) pr_dbg(fmt, ##__VA_ARGS__)
 #else
-# define DBG(x...)
+# define DBG(fmt, ...) do { if (0) pr_dbg(fmt, ##__VA_ARGS__); } while (0)
 #endif
 
 DEFINE_PER_CPU(int, cpu_number);
@@ -116,8 +118,8 @@ static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size,
 	} else {
 		ptr = __alloc_bootmem_node_nopanic(NODE_DATA(node),
 						   size, align, goal);
-		pr_debug("per cpu data for cpu%d %lu bytes on node%d at "
-			 "%016lx\n", cpu, size, node, __pa(ptr));
+		pr_debug("per cpu data for cpu%d %lu bytes on node%d at %016lx\n",
+			 cpu, size, node, __pa(ptr));
 	}
 	return ptr;
 #else
@@ -198,8 +200,7 @@ void __init setup_per_cpu_areas(void)
 					    pcpu_cpu_distance,
 					    pcpu_fc_alloc, pcpu_fc_free);
 		if (rc < 0)
-			pr_warning("PERCPU: %s allocator failed (%d), "
-				   "falling back to page size\n",
+			pr_warning("%s allocator failed (%d), falling back to page size\n",
 				   pcpu_fc_names[pcpu_chosen_fc], rc);
 	}
 	if (rc < 0)
