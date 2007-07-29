Return-Path: <linux-kernel-owner+w=401wt.eu-S934407AbXG2PUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934407AbXG2PUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765022AbXG2PDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:03:40 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47944 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764488AbXG2PDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:03:12 -0400
Date: Sun, 29 Jul 2007 17:02:48 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] i386: no need to make enable_cpu_hotplug a variable
Message-ID: <20070729150248.GA16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As long as there's no write access to this variable there's no reason 
to let gcc check it at runtime.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 6 Jul 2007

 arch/i386/kernel/topology.c |    2 --
 include/asm-i386/cpu.h      |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

--- linux-2.6.22-rc6-mm1/include/asm-i386/cpu.h.old	2007-07-04 20:29:25.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/asm-i386/cpu.h	2007-07-04 20:36:33.000000000 +0200
@@ -13,7 +13,7 @@
 extern int arch_register_cpu(int num);
 #ifdef CONFIG_HOTPLUG_CPU
 extern void arch_unregister_cpu(int);
-extern int enable_cpu_hotplug;
+#define enable_cpu_hotplug	1
 #else
 #define enable_cpu_hotplug	0
 #endif
--- linux-2.6.22-rc6-mm1/arch/i386/kernel/topology.c.old	2007-07-04 20:30:12.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/i386/kernel/topology.c	2007-07-04 20:35:56.000000000 +0200
@@ -51,8 +51,6 @@
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-int enable_cpu_hotplug = 1;
-
 void arch_unregister_cpu(int num) {
 	return unregister_cpu(&cpu_devices[num].cpu);
 }

