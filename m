Return-Path: <linux-kernel-owner+w=401wt.eu-S1751325Ab0AWI4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab0AWI4A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 03:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857Ab0AWIz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 03:55:58 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:54992 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab0AWIz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 03:55:58 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ollie Wild <aaw@google.com>, x86@kernel.org
Subject: [PATCH 1/1] x86: ia32_aout, do not kill argument mapping
Date: Sat, 23 Jan 2010 09:55:51 +0100
Message-Id: <1264236951-16459-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
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
index 2a4d073..652e80f 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -326,7 +326,6 @@ static int load_aout_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	current->mm->free_area_cache = TASK_UNMAPPED_BASE;
 	current->mm->cached_hole_size = 0;
 
-	current->mm->mmap = NULL;
 	install_exec_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 
-- 
1.6.5.7

