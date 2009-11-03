Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbZKCA5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbZKCA5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 19:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbZKCA5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 19:57:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:48821 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbZKCA5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 19:57:50 -0500
Date: Mon, 2 Nov 2009 16:59:15 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH] x86: Make sure we also print a Code: line for show_regs()
Message-ID: <20091102165915.4a980fc0@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c560acdd03d28d3dc55ed9c19d42d4567caab1d8 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 2 Nov 2009 16:50:04 -0800
Subject: [PATCH] x86: Make sure we also print a Code: line for show_regs()

show_regs() is called as a mini BUG() equivalent in some places,
specifically for the "scheduling while atomic" case.

Unfortunately right now it does not print a Code: like unlike
a real bug/oops.

This patch changes the x86 implementation of show_regs() so that
it calls the same function as oopses do to print the registers
as well as the Code: line.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/process_32.c |    2 +-
 arch/x86/kernel/process_64.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index f2cb086..b124f2f 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -189,7 +189,7 @@ void __show_regs(struct pt_regs *regs, int all)
 
 void show_regs(struct pt_regs *regs)
 {
-	__show_regs(regs, 1);
+	show_registers(regs);
 	show_trace(NULL, regs, &regs->sp, regs->bp);
 }
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 959b062..e53e66f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -228,8 +228,7 @@ void __show_regs(struct pt_regs *regs, int all)
 
 void show_regs(struct pt_regs *regs)
 {
-	printk(KERN_INFO "CPU %d:", smp_processor_id());
-	__show_regs(regs, 1);
+	show_registers(regs);
 	show_trace(NULL, regs, (void *)(regs + 1), regs->bp);
 }
 
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
