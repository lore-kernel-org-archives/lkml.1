Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbYAODWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbYAODWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 22:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYAODWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 22:22:15 -0500
Received: from mail.vyatta.com ([216.93.170.194]:42681 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbYAODWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 22:22:14 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.549
Date: Mon, 14 Jan 2008 19:21:55 -0800
From: Stephen Hemminger <stephen.hemminger@vyatta.com>
To: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kprobe: missing cast
Message-ID: <20080114192155.2d6982ea@speedy>
Organization: Vyatta
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warning from missing cast, maybe a result of the x86 merge?

Signed-off-by: Stephen Hemminger <stephen.hemminger@vyatta.com>

  CC      arch/x86/kernel/kprobes_32.o
arch/x86/kernel/kprobes_32.c: In function ‘longjmp_break_handler’:
arch/x86/kernel/kprobes_32.c:729: warning: comparison of distinct pointer types lacks a cast

--- a/arch/x86/kernel/kprobes_32.c	2008-01-14 19:18:01.000000000 -0800
+++ b/arch/x86/kernel/kprobes_32.c	2008-01-14 19:18:08.000000000 -0800
@@ -726,7 +726,7 @@ int __kprobes longjmp_break_handler(stru
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
 
 	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
-		if (&regs->esp != kcb->jprobe_saved_esp) {
+		if ((unsigned long *) &regs->esp != kcb->jprobe_saved_esp) {
 			struct pt_regs *saved_regs = &kcb->jprobe_saved_regs;
 			printk("current esp %p does not match saved esp %p\n",
 			       &regs->esp, kcb->jprobe_saved_esp);
