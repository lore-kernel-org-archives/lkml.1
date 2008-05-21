Return-Path: <linux-kernel-owner+w=401wt.eu-S936712AbYEUS65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936712AbYEUS65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764812AbYEUS6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:58:30 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.144]:43830 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763269AbYEUS63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:58:29 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <48346C45.1050608@avtrex.com>
Date: Wed, 21 May 2008 11:39:01 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mips: Remove board_watchpoint_handler.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2008 18:58:12.0106 (UTC) FILETIME=[9DF9E6A0:01C8BB74]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mips: Remove board_watchpoint_handler.

It is not used anywhere in tree.

Signed-off-by: David Daney <ddaney@avtrex.com>
---
 arch/mips/kernel/traps.c |    6 ------
 include/asm-mips/traps.h |    1 -
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index f9165d1..6e7e4a2 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -71,7 +71,6 @@ extern asmlinkage void handle_reserved(void);
 extern int fpu_emulator_cop1Handler(struct pt_regs *xcp,
 	struct mips_fpu_struct *ctx, int has_fpu);
 
-void (*board_watchpoint_handler)(struct pt_regs *regs);
 void (*board_be_init)(void);
 int (*board_be_handler)(struct pt_regs *regs, int is_fixup);
 void (*board_nmi_handler_setup)(void);
@@ -892,11 +891,6 @@ asmlinkage void do_mdmx(struct pt_regs *regs)
 
 asmlinkage void do_watch(struct pt_regs *regs)
 {
-	if (board_watchpoint_handler) {
-		(*board_watchpoint_handler)(regs);
-		return;
-	}
-
 	/*
 	 * We use the watch exception where available to detect stack
 	 * overflows.
diff --git a/include/asm-mips/traps.h b/include/asm-mips/traps.h
index e5dbde6..90ff2f4 100644
--- a/include/asm-mips/traps.h
+++ b/include/asm-mips/traps.h
@@ -24,6 +24,5 @@ extern int (*board_be_handler)(struct pt_regs *regs, int is_fixup);
 extern void (*board_nmi_handler_setup)(void);
 extern void (*board_ejtag_handler_setup)(void);
 extern void (*board_bind_eic_interrupt)(int irq, int regset);
-extern void (*board_watchpoint_handler)(struct pt_regs *regs);
 
 #endif /* _ASM_TRAPS_H */
-- 
1.5.4.5

