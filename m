Return-Path: <linux-kernel-owner+w=401wt.eu-S1763938AbYA1XIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763938AbYA1XIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763531AbYA1XHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:07:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:30734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763486AbYA1XHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:07:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=nc9+uQhe+4YYVnrhWJj9pOY+XVPlXPgNFX0dsfp7CT/494H/VRcxW4BQMrThB49wuNUUWg/tGBFa1r8CI3eMW4YXT8NxXktoCAgddNwERd1+Uo/Dhpax9dfBkiw7YOoYR2znXPauCbUyPTiz1SeJd0oZ1N2y+hU3hNhuX/yEj/8=
Date: Tue, 29 Jan 2008 00:07:31 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] X86: Remove dead code
Message-ID: <20080129000731.3258f58f@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dead code 

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/math-emu/errors.c |   37 -------------------------------------
 1 files changed, 0 insertions(+), 37 deletions(-)

diff --git a/arch/x86/math-emu/errors.c b/arch/x86/math-emu/errors.c
index a1b0d22..ece95cd 100644
--- a/arch/x86/math-emu/errors.c
+++ b/arch/x86/math-emu/errors.c
@@ -34,43 +34,6 @@
 /* */
 
 
-#if 0
-void Un_impl(void)
-{
-  u_char byte1, FPU_modrm;
-  unsigned long address = FPU_ORIG_EIP;
-
-  RE_ENTRANT_CHECK_OFF;
-  /* No need to check access_ok(), we have previously fetched these bytes. */
-  printk("Unimplemented FPU Opcode at eip=%p : ", (void __user *) address);
-  if ( FPU_CS == __USER_CS )
-    {
-      while ( 1 )
-	{
-	  FPU_get_user(byte1, (u_char __user *) address);
-	  if ( (byte1 & 0xf8) == 0xd8 ) break;
-	  printk("[%02x]", byte1);
-	  address++;
-	}
-      printk("%02x ", byte1);
-      FPU_get_user(FPU_modrm, 1 + (u_char __user *) address);
-      
-      if (FPU_modrm >= 0300)
-	printk("%02x (%02x+%d)\n", FPU_modrm, FPU_modrm & 0xf8, FPU_modrm & 7);
-      else
-	printk("/%d\n", (FPU_modrm >> 3) & 7);
-    }
-  else
-    {
-      printk("cs selector = %04x\n", FPU_CS);
-    }
-
-  RE_ENTRANT_CHECK_ON;
-
-  EXCEPTION(EX_Invalid);
-
-}
-#endif  /*  0  */
 
 
 /*
-- 
1.5.4.rc3

