Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0BJTzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 14:55:24 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:35563 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab0BJTzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 14:55:23 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mingo@elte.hu
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ollie Wild <aaw@google.com>,
       x86@kernel.org
Subject: [PATCH -resend 1/1] x86: ia32_aout, do not kill argument mapping
Date: Wed, 10 Feb 2010 20:55:16 +0100
Message-Id: <1265831716-7668-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not set current->mm->mmap to NULL in 32-bit emulation on 64-bit
load_aout_binary after flush_old_exec as it would destroy already
set brpm mapping with arguments.

Introduced by b6a2fea39318e43fee84fa7b0b90d68bed92d2ba
mm: variable length argument support
where the argument mapping in bprm was added.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ollie Wild <aaw@google.com>
Cc: x86@kernel.org
---
 arch/x86/ia32/ia32_aout.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 9046e4a..280c019 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -327,7 +327,6 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	current->mm->free_area_cache = TASK_UNMAPPED_BASE;
 	current->mm->cached_hole_size = 0;
 
-	current->mm->mmap = NULL;
 	install_exec_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 
-- 
1.6.6.1

