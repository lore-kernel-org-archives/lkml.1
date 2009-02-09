Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbZBINlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbZBINlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZBINkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:40:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:37794 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856AbZBINki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:40:38 -0500
From: Tejun Heo <tj@kernel.org>
To: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/11] x86: include correct %gs in a.out core dump
Date: Mon,  9 Feb 2009 22:39:48 +0900
Message-Id: <1234186798-16820-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234186798-16820-1-git-send-email-tj@kernel.org>
References: <1234186798-16820-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 09 Feb 2009 13:40:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: dump the correct %gs into a.out core dump

aout_dump_thread() read %gs but didn't include it in core dump.  Fix
it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/a.out-core.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/a.out-core.h b/arch/x86/include/asm/a.out-core.h
index 3782220..3c601f8 100644
--- a/arch/x86/include/asm/a.out-core.h
+++ b/arch/x86/include/asm/a.out-core.h
@@ -23,8 +23,6 @@
  */
 static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
 {
-	u16 gs;
-
 /* changed the size calculations - should hopefully work better. lbt */
 	dump->magic = CMAGIC;
 	dump->start_code = 0;
@@ -57,7 +55,7 @@ static inline void aout_dump_thread(struct pt_regs *regs, struct user *dump)
 	dump->regs.ds = (u16)regs->ds;
 	dump->regs.es = (u16)regs->es;
 	dump->regs.fs = (u16)regs->fs;
-	savesegment(gs, gs);
+	savesegment(gs, dump->regs.gs);
 	dump->regs.orig_ax = regs->orig_ax;
 	dump->regs.ip = regs->ip;
 	dump->regs.cs = (u16)regs->cs;
-- 
1.6.0.2

