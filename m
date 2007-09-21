Return-Path: <linux-kernel-owner+w=401wt.eu-S1765342AbXIUU4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765342AbXIUU4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763427AbXIUUp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:29 -0400
Received: from ns2.suse.de ([195.135.220.15]:33019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762461AbXIUUpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:18 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: bunk@stusta.de, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [34/45] i386: no need to make enable_cpu_hotplug a variable
Message-Id: <20070921204517.0BA6214EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

As long as there's no write access to this variable there's no reason to let
gcc check it at runtime.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/topology.c |    2 --
 include/asm-i386/cpu.h      |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

Index: linux/arch/i386/kernel/topology.c
===================================================================
--- linux.orig/arch/i386/kernel/topology.c
+++ linux/arch/i386/kernel/topology.c
@@ -51,8 +51,6 @@ int arch_register_cpu(int num)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-int enable_cpu_hotplug = 1;
-
 void arch_unregister_cpu(int num) {
 	return unregister_cpu(&cpu_devices[num].cpu);
 }
Index: linux/include/asm-i386/cpu.h
===================================================================
--- linux.orig/include/asm-i386/cpu.h
+++ linux/include/asm-i386/cpu.h
@@ -13,7 +13,7 @@ struct i386_cpu {
 extern int arch_register_cpu(int num);
 #ifdef CONFIG_HOTPLUG_CPU
 extern void arch_unregister_cpu(int);
-extern int enable_cpu_hotplug;
+#define enable_cpu_hotplug	1
 #else
 #define enable_cpu_hotplug	0
 #endif
