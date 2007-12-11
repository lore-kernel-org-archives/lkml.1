Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbXLKWYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbXLKWYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbXLKWWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:22:49 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38521 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756822AbXLKWWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:22:42 -0500
Date: Tue, 11 Dec 2007 23:22:42 +0100
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86 smpboot_32.c section fixes
Message-ID: <20071211222242.GR14204@stusta.de>
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
WARNING: vmlinux.o(.text+0x22c60): Section mismatch: reference to .init.data:cpu_idle_tasks (between 'do_boot_cpu' and 'do_warm_boot_cpu')
WARNING: vmlinux.o(.text+0x22c99): Section mismatch: reference to .init.data:cpu_idle_tasks (between 'do_boot_cpu' and 'do_warm_boot_cpu')
WARNING: vmlinux.o(.text+0x2359b): Section mismatch: reference to .init.data:smp_b_stepping (between 'smp_store_cpu_info' and 'cpu_exit_clear')
WARNING: vmlinux.o(.text+0x235a0): Section mismatch: reference to .init.data:smp_b_stepping (between 'smp_store_cpu_info' and 'cpu_exit_clear')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/kernel/smpboot_32.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

b031bee4469bf6e7590601c70d6e5b662667b6b1 
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 383b2d1..d769812 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -60,7 +60,7 @@
 #include <asm/mtrr.h>
 
 /* Set if we find a B stepping CPU */
-static int __devinitdata smp_b_stepping;
+static int __cpuinitdata smp_b_stepping;
 
 /* Number of siblings per CPU package */
 int smp_num_siblings = 1;
@@ -743,8 +743,8 @@ static inline int alloc_cpu_id(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static struct task_struct * __devinitdata cpu_idle_tasks[NR_CPUS];
-static inline struct task_struct * alloc_idle_task(int cpu)
+static struct task_struct * __cpuinitdata cpu_idle_tasks[NR_CPUS];
+static inline struct task_struct * __cpuinit alloc_idle_task(int cpu)
 {
 	struct task_struct *idle;
 

