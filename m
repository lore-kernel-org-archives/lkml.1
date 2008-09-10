Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbYIJATB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbYIJATB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 20:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYIJASw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 20:18:52 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:33545 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYIJASv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 20:18:51 -0400
Message-ID: <48C7126A.5010304@ct.jp.nec.com>
Date: Tue, 09 Sep 2008 17:18:50 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86_64: signal: clean up signal_fault()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

clean up and make signal_fault() same as 32bit.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_64.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 8fbdd23..552a331 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -473,12 +473,14 @@ void do_notify_resume(struct pt_regs *regs, void *unused,
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
 {
 	struct task_struct *me = current;
+
 	if (show_unhandled_signals && printk_ratelimit()) {
-		printk("%s[%d] bad frame in %s frame:%p ip:%lx sp:%lx orax:%lx",
-	       me->comm, me->pid, where, frame, regs->ip,
-		   regs->sp, regs->orig_ax);
+		printk(KERN_INFO
+		       "%s[%d] bad frame in %s frame:%p ip:%lx sp:%lx orax:%lx",
+		       me->comm, me->pid, where, frame,
+		       regs->ip, regs->sp, regs->orig_ax);
 		print_vma_addr(" in ", regs->ip);
-		printk("\n");
+		printk(KERN_CONT "\n");
 	}
 
 	force_sig(SIGSEGV, me);
-- 
1.5.6

