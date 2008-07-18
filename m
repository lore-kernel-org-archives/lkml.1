Return-Path: <linux-kernel-owner+w=401wt.eu-S1760709AbYGRRJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbYGRRJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbYGRRJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:09:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:36267 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957AbYGRRJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:09:40 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/3] kgdb, mips: pad pt_regs on MIPS64 for function arguments in an exception
Date: Fri, 18 Jul 2008 12:08:48 -0500
Message-Id: <1216400928-29097-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1216400928-29097-3-git-send-email-jason.wessel@windriver.com>
References: <1216400928-29097-1-git-send-email-jason.wessel@windriver.com>
 <1216400928-29097-2-git-send-email-jason.wessel@windriver.com>
 <1216400928-29097-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 18 Jul 2008 17:08:48.0301 (UTC) FILETIME=[F19A3DD0:01C8E8F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using KGDB the pt_regs structure has the function arguments saved
to the stack.  48 bytes are required for MIPS 64 for this purpose.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/asm-mips/ptrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-mips/ptrace.h b/include/asm-mips/ptrace.h
index 786f7e3..c3f535f 100644
--- a/include/asm-mips/ptrace.h
+++ b/include/asm-mips/ptrace.h
@@ -28,7 +28,7 @@
  * system call/exception. As usual the registers k0/k1 aren't being saved.
  */
 struct pt_regs {
-#ifdef CONFIG_32BIT
+#if defined(CONFIG_32BIT) || defined(CONFIG_KGDB)
 	/* Pad bytes for argument save space on the stack. */
 	unsigned long pad0[6];
 #endif
-- 
1.5.5.1

