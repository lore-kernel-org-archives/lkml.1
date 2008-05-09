Return-Path: <linux-kernel-owner+w=401wt.eu-S1759975AbYEIWn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975AbYEIWn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 18:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbYEIWnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 18:43:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbYEIWns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 18:43:48 -0400
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] x86 user_regset_view table fix for ia32 on 64-bit
X-Zippy-Says: My LESLIE GORE record is BROKEN..
Message-Id: <20080509224344.152FD26FA85@magilla.localdomain>
Date: Fri,  9 May 2008 15:43:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user_regset_view table for the 32-bit regsets on the 64-bit build had
the wrong sizes for the FP regsets.  This bug had no user-visible effect
(just on kernel modules using the user_regset interfaces and the like).
But the fix is trivial and risk-free.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/ptrace.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index fb03ef3..a7835f2 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1303,6 +1303,9 @@ static const struct user_regset_view user_x86_64_view = {
 #define genregs32_get		genregs_get
 #define genregs32_set		genregs_set
 
+#define user_i387_ia32_struct	user_i387_struct
+#define user32_fxsr_struct	user_fxsr_struct
+
 #endif	/* CONFIG_X86_64 */
 
 #if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
@@ -1315,13 +1318,13 @@ static const struct user_regset x86_32_regsets[] = {
 	},
 	[REGSET_FP] = {
 		.core_note_type = NT_PRFPREG,
-		.n = sizeof(struct user_i387_struct) / sizeof(u32),
+		.n = sizeof(struct user_i387_ia32_struct) / sizeof(u32),
 		.size = sizeof(u32), .align = sizeof(u32),
 		.active = fpregs_active, .get = fpregs_get, .set = fpregs_set
 	},
 	[REGSET_XFP] = {
 		.core_note_type = NT_PRXFPREG,
-		.n = sizeof(struct user_i387_struct) / sizeof(u32),
+		.n = sizeof(struct user32_fxsr_struct) / sizeof(u32),
 		.size = sizeof(u32), .align = sizeof(u32),
 		.active = xfpregs_active, .get = xfpregs_get, .set = xfpregs_set
 	},
