Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbYCCSJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbYCCSJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbYCCSJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:09:00 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51595 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574AbYCCSI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:08:59 -0500
Date: Mon, 3 Mar 2008 20:07:22 +0200
From: Adrian Bunk <bunk@kernel.org>
To: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix ia64 kprobes compilation
Message-ID: <20080303180722.GG26072@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error with a recent gcc:

<--  snip  -->

...
  CC      kernel/kprobes.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/kprobes.c:1066: error: __ksymtab_jprobe_return causes a section type conflict
make[2]: *** [kernel/kprobes.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/ia64/kernel/kprobes.c |    5 +++++
 include/asm-ia64/kprobes.h |    4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

20bd2855f85dd0ac9d76df414aeef8c82d2ec668 foobar
diff --git a/arch/ia64/kernel/kprobes.c b/arch/ia64/kernel/kprobes.c
index b618487..615c3d2 100644
--- a/arch/ia64/kernel/kprobes.c
+++ b/arch/ia64/kernel/kprobes.c
@@ -1001,6 +1001,11 @@ int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	return 1;
 }
 
+/* ia64 does not need this */
+void __kprobes jprobe_return(void)
+{
+}
+
 int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
diff --git a/include/asm-ia64/kprobes.h b/include/asm-ia64/kprobes.h
index a93ce9e..49684b6 100644
--- a/include/asm-ia64/kprobes.h
+++ b/include/asm-ia64/kprobes.h
@@ -122,10 +122,6 @@ extern int kprobes_fault_handler(struct pt_regs *regs, int trapnr);
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
 
-/* ia64 does not need this */
-static inline void jprobe_return(void)
-{
-}
 extern void invalidate_stacked_regs(void);
 extern void flush_register_stack(void);
 extern void arch_remove_kprobe(struct kprobe *p);

