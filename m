Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbXLKWZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbXLKWZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbXLKWXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:23:00 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38530 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756926AbXLKWW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:22:57 -0500
Date: Tue, 11 Dec 2007 23:22:58 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/timer.c section fixes
Message-ID: <20071211222258.GU14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatches with CONFIG_HOTPLUG=n,
CONFIG_HOTPLUG_CPU=y:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0x41cd3): Section mismatch: reference to .init.data:tvec_base_done.22610 (between 'timer_cpu_notify' and 'run_timer_softirq')
WARNING: vmlinux.o(.text+0x41d67): Section mismatch: reference to .init.data:tvec_base_done.22610 (between 'timer_cpu_notify' and 'run_timer_softirq')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
5898f1ca82c5a536b65b3ee26099b67316549664 
diff --git a/kernel/timer.c b/kernel/timer.c
index a05817c..d4527dc 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1219,11 +1219,11 @@ asmlinkage long sys_sysinfo(struct sysinfo __user *info)
  */
 static struct lock_class_key base_lock_keys[NR_CPUS];
 
-static int __devinit init_timers_cpu(int cpu)
+static int __cpuinit init_timers_cpu(int cpu)
 {
 	int j;
 	tvec_base_t *base;
-	static char __devinitdata tvec_base_done[NR_CPUS];
+	static char __cpuinitdata tvec_base_done[NR_CPUS];
 
 	if (!tvec_base_done[cpu]) {
 		static char boot_done;

