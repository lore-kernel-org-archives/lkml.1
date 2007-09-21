Return-Path: <linux-kernel-owner+w=401wt.eu-S1765580AbXIUU5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765580AbXIUU5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763057AbXIUUpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:36 -0400
Received: from ns.suse.de ([195.135.220.2]:50097 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763374AbXIUUpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:22 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: bunk@stusta.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [38/45] i386: setup_trampoline() must be __cpuinit
Message-Id: <20070921204521.4193314EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

WARNING: arch/i386/kernel/built-in.o(.text+0xf201): Section mismatch: reference to .init.data:trampoline_end (between 'setup_trampoline' and 'cpu_coregroup_map')
WARNING: arch/i386/kernel/built-in.o(.text+0xf207): Section mismatch: reference to .init.data:trampoline_data (between 'setup_trampoline' and 'cpu_coregroup_map')
WARNING: arch/i386/kernel/built-in.o(.text+0xf21a): Section mismatch: reference to .init.data:trampoline_data (between 'setup_trampoline' and 'cpu_coregroup_map')

Harmless but annoying warnings present when building an i386 SMP kernel
with CONFIG_HOTPLUG_CPU=n and gcc < 4.0 .

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/smpboot.c
===================================================================
--- linux.orig/arch/i386/kernel/smpboot.c
+++ linux/arch/i386/kernel/smpboot.c
@@ -118,7 +118,7 @@ DEFINE_PER_CPU(int, cpu_state) = { 0 };
  * has made sure it's suitably aligned.
  */
 
-static unsigned long __devinit setup_trampoline(void)
+static unsigned long __cpuinit setup_trampoline(void)
 {
 	memcpy(trampoline_base, trampoline_data, trampoline_end - trampoline_data);
 	return virt_to_phys(trampoline_base);
