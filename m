Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbXFYKrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbXFYKrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 06:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbXFYKrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 06:47:49 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:52658 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbXFYKrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 06:47:48 -0400
X-Originating-Ip: 74.102.207.204
Date: Mon, 25 Jun 2007 06:43:37 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] X86: Update alignment when 4K stacks are used.
Message-ID: <Pine.LNX.4.64.0706250642050.3880@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  it's not clear from MAINTAINERS who's responsible for something this
generic.

diff --git a/arch/i386/kernel/irq.c b/arch/i386/kernel/irq.c
index d2daf67..504f134 100644
--- a/arch/i386/kernel/irq.c
+++ b/arch/i386/kernel/irq.c
@@ -149,15 +149,11 @@ fastcall unsigned int do_IRQ(struct pt_regs *regs)

 #ifdef CONFIG_4KSTACKS

-/*
- * These should really be __section__(".bss.page_aligned") as well, but
- * gcc's 3.0 and earlier don't handle that correctly.
- */
 static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__aligned__(THREAD_SIZE)));
+		__attribute__((__section__(".bss.page_aligned")));

 static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__aligned__(THREAD_SIZE)));
+		__attribute__((__section__(".bss.page_aligned")));

 /*
  * allocate per-cpu stacks for hardirq and for softirq processing
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
