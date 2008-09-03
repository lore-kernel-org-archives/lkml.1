Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbYICHSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbYICHSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 03:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbYICHSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 03:18:13 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:49076 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYICHSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 03:18:11 -0400
Message-Id: <20080903071741.128202703@mail.of.borg>
References: <20080903071542.615137611@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 09:15:43 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/8] m68k: Use new printk() extension %pS to print symbols
Content-Disposition: inline; filename=m68k-use-percent-pS-infrastructure.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

This changes the oops and backtrace code to use the new `%pS' printk()
extension to print out symbols rather than manually calling print_symbol.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/traps.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -883,8 +883,7 @@ void show_trace(unsigned long *stack)
 			if (i % 5 == 0)
 				printk("\n       ");
 #endif
-			printk(" [<%08lx>]", addr);
-			print_symbol(" %s\n", addr);
+			printk(" [<%08lx>] %pS\n", addr, (void *)addr);
 			i++;
 		}
 	}
@@ -900,10 +899,8 @@ void show_registers(struct pt_regs *regs
 	int i;
 
 	print_modules();
-	printk("PC: [<%08lx>]",regs->pc);
-	print_symbol(" %s", regs->pc);
-	printk("\nSR: %04x  SP: %p  a2: %08lx\n",
-	       regs->sr, regs, regs->a2);
+	printk("PC: [<%08lx>] %pS\n", regs->pc, (void *)regs->pc);
+	printk("SR: %04x  SP: %p  a2: %08lx\n", regs->sr, regs, regs->a2);
 	printk("d0: %08lx    d1: %08lx    d2: %08lx    d3: %08lx\n",
 	       regs->d0, regs->d1, regs->d2, regs->d3);
 	printk("d4: %08lx    d5: %08lx    a0: %08lx    a1: %08lx\n",

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

