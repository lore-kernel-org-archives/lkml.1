Return-Path: <linux-kernel-owner+w=401wt.eu-S1763090AbXGEXXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763090AbXGEXXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762663AbXGEXWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:22:22 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52129 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762641AbXGEXWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:22:20 -0400
Date: Fri, 6 Jul 2007 01:22:50 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] i386: no need to make enable_cpu_hotplug a variable
Message-ID: <20070705232249.GW3492@stusta.de>
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

