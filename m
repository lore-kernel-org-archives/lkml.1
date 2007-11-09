Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbXKIGFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbXKIGFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 01:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbXKIGDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 01:03:51 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52872 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751859AbXKIGDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 01:03:50 -0500
Date: Fri, 9 Nov 2007 07:03:26 +0100
From: Adrian Bunk <bunk@kernel.org>
To: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86 kprobes_64.c: make 3 functions static
Message-ID: <20071109060326.GV26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- kprobe_handler()
- trampoline_probe_handler()
- post_kprobe_handler()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/kernel/kprobes_64.c |    7 ++++---
 include/asm-x86/kprobes_64.h |    2 --
 2 files changed, 4 insertions(+), 5 deletions(-)

dec0510a1f75dce9dbdb75458fd870fba14bd7b4 
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index 3db3611..7abfc8a 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -278,7 +278,7 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 	*sara = (unsigned long) &kretprobe_trampoline;
 }
 
-int __kprobes kprobe_handler(struct pt_regs *regs)
+static int __kprobes kprobe_handler(struct pt_regs *regs)
 {
 	struct kprobe *p;
 	int ret = 0;
@@ -395,7 +395,8 @@ no_kprobe:
 /*
  * Called when we hit the probe point at kretprobe_trampoline
  */
-int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
+static int __kprobes trampoline_probe_handler(struct kprobe *p,
+					      struct pt_regs *regs)
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
@@ -536,7 +537,7 @@ static void __kprobes resume_execution(struct kprobe *p,
 	}
 }
 
-int __kprobes post_kprobe_handler(struct pt_regs *regs)
+static int __kprobes post_kprobe_handler(struct pt_regs *regs)
 {
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
diff --git a/include/asm-x86/kprobes_64.h b/include/asm-x86/kprobes_64.h
index 53f4d85..497dad1 100644
--- a/include/asm-x86/kprobes_64.h
+++ b/include/asm-x86/kprobes_64.h
@@ -81,9 +81,7 @@ static inline void restore_interrupts(struct pt_regs *regs)
 		local_irq_enable();
 }
 
-extern int post_kprobe_handler(struct pt_regs *regs);
 extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
-extern int kprobe_handler(struct pt_regs *regs);
 
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);

