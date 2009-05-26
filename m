Return-Path: <linux-kernel-owner+w=401wt.eu-S1761836AbZE0ACb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761836AbZE0ACb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756389AbZEZXzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:55:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38640 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317AbZEZXy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:58 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 29/31] x86: MCE: Rename mce_notify_user to mce_notify_irq
Date: Wed, 27 May 2009 01:54:31 +0200
Message-Id: <7532f66f86301d6d2a192a306d0958f6ac1d0c2e.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <504bce650bbfaa513c9386cfd77edf5f5941654b.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
 <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
 <abf61c300dec40b8e93bb5ae7154a0633c682799.1243381848.git.ak@linux.intel.com>
 <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
 <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
 <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>
 <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com>
 <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com>
 <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com>
 <10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com>
 <a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com>
 <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com>
 <b55d8c3d2842ee10f4b06f17cc2658f81b4f7b4e.1243381848.git.ak@linux.intel.com>
 <7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com>
 <0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com>
 <314f7c278aaaa41854bf4f0837a4ca6126160fc8.1243381848.git.ak@linux.intel.com>
 <ecbed09ba385129558d6341f6a48c64edaa164b4.1243381848.git.ak@linux.intel.com>
 <d9664a5ed1cdbfcd7888c7c7114619494114d4ab.1243381848.git.ak@linux.intel.com>
 <172ffa34ba8bc6a493e26f7e97fb7239f906b4e8.1243381848.git.ak@linux.intel.com>
 <e224e71ae8e2b578d4b4a0a079eea963445eaf91.1243381848.git.ak@linux.intel.com>
 <650bd32edc1814f1f792a07de9c5efebefc9c0b3.1243381848.git.ak@linux.intel.com>
 <b464e1eb871500ad8f4f6e5e5f6d394aec97e037.1243381848.git.ak@linux.intel.com>
 <2a7abea3d00cb5a1508d54b45bdb7a94fead46ee.1243381848.git.ak@linux.intel.com>
 <504bce650bbfaa513c9386cfd77edf5f5941654b.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Impact: cleanup

Rename the mce_notify_user function to mce_notify_irq. The next
patch will split the wakeup handling of interrupt context
and of process context and it's better to give it a clearer
name for this.

Contains a fix from Ying Huang

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/mce.h                |    2 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c   |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c          |   10 +++++-----
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    2 +-
 arch/x86/kernel/signal.c                  |    2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 0cc8175..52dbac5 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -159,7 +159,7 @@ enum mcp_flags {
 };
 extern void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
 
-extern int mce_notify_user(void);
+extern int mce_notify_irq(void);
 
 DECLARE_PER_CPU(struct mce, injectm);
 extern struct file_operations mce_chrdev_ops;
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index e6cfa1a..9702f10 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -65,7 +65,7 @@ static void raise_mce(unsigned long data)
 		memset(&b, 0xff, sizeof(mce_banks_t));
 		printk(KERN_INFO "Starting machine check poll CPU %d\n", cpu);
 		machine_check_poll(0, &b);
-		mce_notify_user();
+		mce_notify_irq();
 		printk(KERN_INFO "Finished machine check poll on CPU %d\n",
 		       cpu);
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 9029aa0..a3470b3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -346,14 +346,14 @@ asmlinkage void smp_mce_self_interrupt(struct pt_regs *regs)
 	ack_APIC_irq();
 	exit_idle();
 	irq_enter();
-	mce_notify_user();
+	mce_notify_irq();
 	irq_exit();
 }
 
 static void mce_report_event(struct pt_regs *regs)
 {
 	if (regs->flags & (X86_VM_MASK|X86_EFLAGS_IF)) {
-		mce_notify_user();
+		mce_notify_irq();
 		return;
 	}
 
@@ -964,7 +964,7 @@ static void mcheck_timer(unsigned long data)
 	 * polling interval, otherwise increase the polling interval.
 	 */
 	n = &__get_cpu_var(next_interval);
-	if (mce_notify_user()) {
+	if (mce_notify_irq()) {
 		*n = max(*n/2, HZ/100);
 	} else {
 		*n = min(*n*2, (int)round_jiffies_relative(check_interval*HZ));
@@ -986,7 +986,7 @@ static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
  * Can be called from interrupt context, but not from machine check/NMI
  * context.
  */
-int mce_notify_user(void)
+int mce_notify_irq(void)
 {
 	/* Not more than two messages every minute */
 	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
@@ -1011,7 +1011,7 @@ int mce_notify_user(void)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(mce_notify_user);
+EXPORT_SYMBOL_GPL(mce_notify_irq);
 
 /*
  * Initialize Machine Checks for a CPU.
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index f28aa4c..be1abfb 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -78,7 +78,7 @@ static int cmci_supported(int *banks)
 static void intel_threshold_interrupt(void)
 {
 	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
-	mce_notify_user();
+	mce_notify_irq();
 }
 
 /*
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index d0851e3..d5dc15b 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -860,7 +860,7 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 #ifdef CONFIG_X86_NEW_MCE
 	/* notify userspace of pending MCEs */
 	if (thread_info_flags & _TIF_MCE_NOTIFY)
-		mce_notify_user();
+		mce_notify_irq();
 #endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
 
 	/* deal with pending signal delivery */
-- 
1.6.0.2

