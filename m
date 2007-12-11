Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbXLKWYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbXLKWYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbXLKWWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:22:36 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38517 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756751AbXLKWWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:22:35 -0500
Date: Tue, 11 Dec 2007 23:22:35 +0100
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86_32: select_idle_routine() must be __cpuinit
Message-ID: <20071211222235.GQ14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch with CONFIG_HOTPLUG=n,
CONFIG_HOTPLUG_CPU=y:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0x1199a): Section mismatch: reference to .init.text.5:select_idle_routine (between 'init_intel' and 'init_nexgen')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
897e76d379d0743bd2241989c0e1391ad21e500f 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7b89958..9663c2a 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -261,7 +261,7 @@ static void mwait_idle(void)
 	mwait_idle_with_hints(0, 0);
 }
 
-void __devinit select_idle_routine(const struct cpuinfo_x86 *c)
+void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_MWAIT)) {
 		printk("monitor/mwait feature present.\n");

