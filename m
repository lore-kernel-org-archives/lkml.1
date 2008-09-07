Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYIGIpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYIGIpG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 04:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYIGIoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 04:44:54 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:59389 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbYIGIox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 04:44:53 -0400
Date: Sun, 7 Sep 2008 10:44:48 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.28] m68k: init_irq_proc depends on CONFIG_PROC_FS
Message-ID: <Pine.LNX.4.64.0809071044020.948@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_PROC_FS is not set, I get:

| arch/m68k/kernel/ints.c:433: error: redefinition of 'init_irq_proc'
| include/linux/interrupt.h:438: error: previous definition of 'init_irq_proc' was here

This was introduced by commit 6168a702ab0be181e5e57a0b2d0e7376f7a47f0b
("Declare init_irq_proc before we use it."), which replaced the #ifdef
protection of the init_irq_proc() call by a static inline dummy if
CONFIG_PROC_FS is not set.

Make init_irq_proc() depend on CONFIG_PROC_FS to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/ints.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -429,8 +429,9 @@ int show_interrupts(struct seq_file *p, 
 	return 0;
 }
 
+#ifdef CONFIG_PROC_FS
 void init_irq_proc(void)
 {
 	/* Insert /proc/irq driver here */
 }
-
+#endif

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
