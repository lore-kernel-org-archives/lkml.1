Return-Path: <linux-kernel-owner+w=401wt.eu-S1761852AbXHPNTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761852AbXHPNTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 09:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760831AbXHPNTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 09:19:30 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1267 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131AbXHPNT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 09:19:29 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>,
       Andy Whitcroft <apw@shadowen.org>, Andy Whitcroft <apw@shadowen.org>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH 1/6] mips: irix_getcontext will always fail EFAULT
References: <exportbomb.1187270320@pinky>
InReply-To: <exportbomb.1187270320@pinky>
Message-ID: <0b4bc89aa61d97708ca0f79ba02f6e60@pinky>
Date: Thu, 16 Aug 2007 14:18:45 +0100
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Seems that a trailing ';' has slipped onto the end of the access_ok
check here, such that we will always return -EFAULT.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/kernel/irixsig.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
diff --git a/arch/mips/kernel/irixsig.c b/arch/mips/kernel/irixsig.c
index 6980deb..28b2a8f 100644
--- a/arch/mips/kernel/irixsig.c
+++ b/arch/mips/kernel/irixsig.c
@@ -725,7 +725,7 @@ asmlinkage int irix_getcontext(struct pt_regs *regs)
 	       current->comm, current->pid, ctx);
 #endif
 
-	if (!access_ok(VERIFY_WRITE, ctx, sizeof(*ctx)));
+	if (!access_ok(VERIFY_WRITE, ctx, sizeof(*ctx)))
 		return -EFAULT;
 
 	error = __put_user(current->thread.irix_oldctx, &ctx->link);
