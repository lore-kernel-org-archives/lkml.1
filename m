Return-Path: <linux-kernel-owner+w=401wt.eu-S1764161AbYA1XLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764161AbYA1XLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbYA1XIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:08:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:30734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763344AbYA1XII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:08:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=UHeu1CRxzBkzq92KO+URPGfOWPbfdusVcMVJDyzDn36bCemckl5DFZrRiSBbllaBJ5ww3MDw8iOSEmfTuuAB7XfefurPZHZpgB494OUR2IzXUe8+NdivXa4Jh4/vkTt39d0LspYQTiNLpMz4WzPEGNCFais0uQ8VLaUtXZaFfyo=
Date: Tue, 29 Jan 2008 00:08:03 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] X86:  include missing KERN_ facility level
Message-ID: <20080129000803.69b54c7e@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include missing KERN_ facility level

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/math-emu/errors.c |   52 ++++++++++++++++++++++----------------------
 1 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/x86/math-emu/errors.c b/arch/x86/math-emu/errors.c
index 6102fe0..569a62e 100644
--- a/arch/x86/math-emu/errors.c
+++ b/arch/x86/math-emu/errors.c
@@ -57,65 +57,65 @@ void FPU_printall(void)
 
   RE_ENTRANT_CHECK_OFF;
   /* No need to check access_ok(), we have previously fetched these bytes. */
-  printk("At %p:", (void *) address);
+  printk(KERN_ERR "At %p:", (void *) address);
   if (FPU_CS == __USER_CS) {
 #define MAX_PRINTED_BYTES 20
       for (i = 0; i < MAX_PRINTED_BYTES; i++) {
 	  FPU_get_user(byte1, (u_char __user *) address);
 	  if ((byte1 & 0xf8) == 0xd8) {
-	      printk(" %02x", byte1);
+	      printk(KERN_ERR " %02x", byte1);
 	      break;
 	    }
-	  printk(" [%02x]", byte1);
+	  printk(KERN_ERR " [%02x]", byte1);
 	  address++;
 	}
       if (i == MAX_PRINTED_BYTES)
-	printk(" [more..]\n");
+	printk(KERN_ERR " [more..]\n");
       else {
 	  FPU_get_user(FPU_modrm, 1 + (u_char __user *) address);
 
 	  if (FPU_modrm >= 0300)
-	    printk(" %02x (%02x+%d)\n", FPU_modrm, FPU_modrm & 0xf8, FPU_modrm & 7);
+	    printk(KERN_ERR " %02x (%02x+%d)\n", FPU_modrm, FPU_modrm & 0xf8, FPU_modrm & 7);
 	  else
-	    printk(" /%d, mod=%d rm=%d\n",
+	    printk(KERN_ERR " /%d, mod=%d rm=%d\n",
 		   (FPU_modrm >> 3) & 7, (FPU_modrm >> 6) & 3, FPU_modrm & 7);
 	}
     }
   else
-      printk("%04x\n", FPU_CS);
+      printk(KERN_ERR "%04x\n", FPU_CS);
 
   partial_status = status_word();
 
 #ifdef DEBUGGING
 if (partial_status & SW_Backward)
-printk("SW: backward compatibility\n");
+printk(KERN_ERR "SW: backward compatibility\n");
 if (partial_status & SW_C3)
-printk("SW: condition bit 3\n");
+printk(KERN_ERR "SW: condition bit 3\n");
 if (partial_status & SW_C2)
-printk("SW: condition bit 2\n");
+printk(KERN_ERR "SW: condition bit 2\n");
 if (partial_status & SW_C1)
-printk("SW: condition bit 1\n");
+printk(KERN_ERR "SW: condition bit 1\n");
 if (partial_status & SW_C0)
-printk("SW: condition bit 0\n");
+printk(KERN_ERR "SW: condition bit 0\n");
 if (partial_status & SW_Summary)
-printk("SW: exception summary\n");
+printk(KERN_ERR "SW: exception summary\n");
 if (partial_status & SW_Stack_Fault)
-printk("SW: stack fault\n");
+printk(KERN_ERR "SW: stack fault\n");
 if (partial_status & SW_Precision)
-printk("SW: loss of precision\n");
+printk(KERN_ERR "SW: loss of precision\n");
 if (partial_status & SW_Underflow)
-printk("SW: underflow\n");
+printk(KERN_ERR "SW: underflow\n");
 if (partial_status & SW_Overflow)
-printk("SW: overflow\n");
+printk(KERN_ERR "SW: overflow\n");
 if (partial_status & SW_Zero_Div)
-printk("SW: divide by zero\n");
+printk(KERN_ERR "SW: divide by zero\n");
 if (partial_status & SW_Denorm_Op)
-printk("SW: denormalized operand\n");
+printk(KERN_ERR "SW: denormalized operand\n");
 if (partial_status & SW_Invalid)
-printk("SW: invalid operation\n");
+printk(KERN_ERR "SW: invalid operation\n");
 #endif /* DEBUGGING */
 
-  printk(" SW: b=%d st=%ld es=%d sf=%d cc=%d%d%d%d ef=%d%d%d%d%d%d\n",
+  printk(KERN_ERR " SW: b=%d st=%ld es=%d sf=%d cc=%d%d%d%d ef=%d%d%d%d%d%d\n",
 	 partial_status & 0x8000 ? 1 : 0,   /* busy */
 	 (partial_status & 0x3800) >> 11,   /* stack top pointer */
 	 partial_status & 0x80 ? 1 : 0,     /* Error summary status */
@@ -126,7 +126,7 @@ printk("SW: invalid operation\n");
 	 partial_status & SW_Overflow?1:0, partial_status & SW_Zero_Div?1:0,
 	 partial_status & SW_Denorm_Op?1:0, partial_status & SW_Invalid?1:0);
 
-printk(" CW: ic=%d rc=%ld%ld pc=%ld%ld iem=%d     ef=%d%d%d%d%d%d\n",
+printk(KERN_ERR " CW: ic=%d rc=%ld%ld pc=%ld%ld iem=%d     ef=%d%d%d%d%d%d\n",
 	 control_word & 0x1000 ? 1 : 0,
 	 (control_word & 0x800) >> 11, (control_word & 0x400) >> 10,
 	 (control_word & 0x200) >> 9, (control_word & 0x100) >> 8,
@@ -146,7 +146,7 @@ printk(" CW: ic=%d rc=%ld%ld pc=%ld%ld iem=%d     ef=%d%d%d%d%d%d\n",
 	case TAG_Special:
 	  tagi = FPU_Special(r);
 	case TAG_Valid:
-	  printk("st(%d)  %c .%04lx %04lx %04lx %04lx e%+-6d ", i,
+	  printk(KERN_ERR "st(%d)  %c .%04lx %04lx %04lx %04lx e%+-6d ", i,
 		 getsign(r) ? '-' : '+',
 		 (long)(r->sigh >> 16),
 		 (long)(r->sigh & 0xFFFF),
@@ -302,14 +302,14 @@ asmlinkage void FPU_exception(int n)
 
       if (exception_names[i].type) {
 #ifdef PRINT_MESSAGES
-	  printk("FP Exception: %s!\n", exception_names[i].name);
+	  printk(KERN_ERR "FP Exception: %s!\n", exception_names[i].name);
 #endif /* PRINT_MESSAGES */
 	}
       else
-	printk("FPU emulator: Unknown Exception: 0x%04x!\n", n);
+	printk(KERN_ERR "FPU emulator: Unknown Exception: 0x%04x!\n", n);
 
       if (n == EX_INTERNAL) {
-	  printk("FPU emulator: Internal error type 0x%04x\n", int_type);
+	  printk(KERN_ERR "FPU emulator: Internal error type 0x%04x\n", int_type);
 	  FPU_printall();
 	}
 #ifdef PRINT_MESSAGES
-- 
1.5.4.rc3

