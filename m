Return-Path: <linux-kernel-owner+w=401wt.eu-S934823AbXJOSoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934823AbXJOSoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933946AbXJOSev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:34:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:47976 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933948AbXJOSer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:34:47 -0400
Message-ID: <4713B295.9010600@windriver.com>
Date: Mon, 15 Oct 2007 13:33:57 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ralf@linux-mips.org
Subject: [PATCH 19/21] KGDB: pad pt_regs on MIPS64 for function arguments
 in an exception
Content-Type: multipart/mixed;
 boundary="------------080301050505020703030302"
X-OriginalArrivalTime: 15 Oct 2007 18:34:40.0923 (UTC) FILETIME=[0C6136B0:01C80F5A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080301050505020703030302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

--------------080301050505020703030302
Content-Type: text/x-patch;
 name="mips64_pt_regs_padding.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mips64_pt_regs_padding.patch"

mips64_pt_regs_padding.patch

From: Jason Wessel <jason.wessel@windriver.com>
CC: ralf@linux-mips.org
Subject: [PATCH] pad pt_regs on MIPS64 for function arguments in an exception


When using KGDB the pt_regs structure has the function arguments saved
to the stack.  48 bytes are required for MIPS 64 for this purpose.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 include/asm-mips/ptrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21.1/include/asm-mips/ptrace.h
===================================================================
--- linux-2.6.21.1.orig/include/asm-mips/ptrace.h
+++ linux-2.6.21.1/include/asm-mips/ptrace.h
@@ -28,7 +28,7 @@
  * system call/exception. As usual the registers k0/k1 aren't being saved.
  */
 struct pt_regs {
-#ifdef CONFIG_32BIT
+#if defined(CONFIG_32BIT) || defined(CONFIG_KGDB)
 	/* Pad bytes for argument save space on the stack. */
 	unsigned long pad0[6];
 #endif

--------------080301050505020703030302--
