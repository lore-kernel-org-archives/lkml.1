Return-Path: <linux-kernel-owner+w=401wt.eu-S932107AbZJEAzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbZJEAzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbZJEAzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:55:20 -0400
Received: from mail.perches.com ([173.55.12.10]:1726 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758246AbZJEAzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:55:18 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 09/21] arch/x86/kernel/setup_percpu.c: use pr_<level> and add pr_fmt(fmt)
Date: Sun,  4 Oct 2009 17:53:36 -0700
Message-Id: <bef21f0f5f89cbfd17e061b7f6402fc01ecbb41a.1254701151.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Stripped PERCPU: from a pr_warning

Signed-off-by: Joe Perches <joe@perches.com>
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
-- 
1.6.3.1.10.g659a0.dirty

