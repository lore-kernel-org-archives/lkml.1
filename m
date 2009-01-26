Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbZAZGSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbZAZGSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 01:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbZAZGPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 01:15:45 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:35843 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbZAZGPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 01:15:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZPAjsDAUNvzGFo0dKy9H5SbexXPf2E7wKRTlA/2nzsKp9t8nAqpmGBff2fv962QtP9
         3tX7DR9utqkGDrzPEYuUqQl0ASG0HdNBIoHt7LRVNseXhTG9P8pcjP81hTUoA6wQYmxy
         SFUI3g7GZzRD46jq+EWMZaUst+MdOw8ILclBU=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] x86: Don't assume boot cpu is #0
Date: Mon, 26 Jan 2009 01:15:28 -0500
Message-Id: <1232950532-22923-8-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
References: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: minor cleanup

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/setup_percpu.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 36c2e81..be77f1a 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -15,6 +15,7 @@
 #include <asm/highmem.h>
 #include <asm/proto.h>
 #include <asm/cpumask.h>
+#include <asm/cpu.h>
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 # define DBG(x...) printk(KERN_DEBUG x)
@@ -37,7 +38,7 @@ EXPORT_PER_CPU_SYMBOL(this_cpu_off);
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
-	[0] = BOOT_PERCPU_OFFSET,
+	[0 ... NR_CPUS-1] = BOOT_PERCPU_OFFSET,
 };
 EXPORT_SYMBOL(__per_cpu_offset);
 
@@ -101,10 +102,10 @@ void __init setup_per_cpu_areas(void)
 				early_per_cpu_map(x86_cpu_to_node_map, cpu);
 #endif
 		/*
-		 * Up to this point, CPU0 has been using .data.init
-		 * area.  Reload %gs offset for CPU0.
+		 * Up to this point, the boot CPU has been using .data.init
+		 * area.  Reload %gs offset for the boot CPU.
 		 */
-		if (cpu == 0)
+		if (cpu == boot_cpu_id)
 			load_gs_base(cpu);
 #endif
 
-- 
1.6.1

