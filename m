Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbXG0NYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbXG0NYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 09:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbXG0NYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 09:24:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46795 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbXG0NYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 09:24:34 -0400
Date: Fri, 27 Jul 2007 14:24:33 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] rip some includes from linux/interrupt.h
Message-ID: <20070727132433.GB27237@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 0a3c2eb..5523f19 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -11,8 +11,6 @@
 #include <linux/hardirq.h>
 #include <linux/sched.h>
 #include <linux/irqflags.h>
-#include <linux/bottom_half.h>
-#include <linux/device.h>
 #include <asm/atomic.h>
 #include <asm/ptrace.h>
 #include <asm/system.h>
@@ -97,6 +95,8 @@ extern int __must_check request_irq(unsigned int, irq_handler_t handler,
 		       unsigned long, const char *, void *);
 extern void free_irq(unsigned int, void *);
 
+struct device;
+
 extern int __must_check devm_request_irq(struct device *dev, unsigned int irq,
 			    irq_handler_t handler, unsigned long irqflags,
 			    const char *devname, void *dev_id);
diff --git a/kernel/irq/devres.c b/kernel/irq/devres.c
index d8ee241..6d9204f 100644
--- a/kernel/irq/devres.c
+++ b/kernel/irq/devres.c
@@ -1,5 +1,6 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/device.h>
 
 /*
  * Device resource management aware IRQ request/free implementation.
