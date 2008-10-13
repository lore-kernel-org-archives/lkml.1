Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbYJMUKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbYJMUKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbYJMUF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:05:58 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:34697 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbYJMUFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:05:43 -0400
Message-Id: <20081013195921.308778386@mail.of.borg>
References: <20081013195846.674654386@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Mon, 13 Oct 2008 21:59:01 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 15/18] m68k: init_irq_proc depends on CONFIG_PROC_FS
Content-Disposition: inline; filename=m68k-init_irq_proc-depends-on-CONFIG_PROC_FS.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

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

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

