Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbYA1ItS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbYA1ItS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYA1IrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:47:15 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:56277 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758303AbYA1IrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:47:13 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 28 Jan 2008 08:45:48 +0000
Message-Id: <1201509949-3285-9-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201509949-3285-8-git-send-email-ijc@hellion.org.uk>
References: <1201509949-3285-1-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-2-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-3-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-4-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-5-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-6-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-7-git-send-email-ijc@hellion.org.uk>
 <1201509949-3285-8-git-send-email-ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCHv2 8/9] x86: Unify variable names in arch/x86/boot/compressed/misc_??.c
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

size reports no change in arch/x86/boot/compressed/vmlinux.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/misc_32.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/misc_32.c b/arch/x86/boot/compressed/misc_32.c
index ad0528a..2b1c22d 100644
--- a/arch/x86/boot/compressed/misc_32.c
+++ b/arch/x86/boot/compressed/misc_32.c
@@ -348,7 +348,7 @@ static void error(char *x)
 		asm("hlt");
 }
 
-asmlinkage void decompress_kernel(void *rmode, unsigned long end,
+asmlinkage void decompress_kernel(void *rmode, unsigned long heap,
 				  uch *input_data, unsigned long input_len,
 				  uch *output)
 {
@@ -366,15 +366,15 @@ asmlinkage void decompress_kernel(void *rmode, unsigned long end,
 	cols = RM_SCREEN_INFO.orig_video_cols;
 
 	window = output;		/* Output buffer (Normally at 1M) */
-	free_mem_ptr     = end;		/* Heap */
-	free_mem_end_ptr = end + HEAP_SIZE;
+	free_mem_ptr     = heap;	/* Heap */
+	free_mem_end_ptr = heap + HEAP_SIZE;
 	inbuf  = input_data;		/* Input buffer */
 	insize = input_len;
 	inptr  = 0;
 
 	if ((u32)output & (CONFIG_PHYSICAL_ALIGN -1))
 		error("Destination address not CONFIG_PHYSICAL_ALIGN aligned");
-	if (end > ((-__PAGE_OFFSET-(512 <<20)-1) & 0x7fffffff))
+	if (heap > ((-__PAGE_OFFSET-(512<<20)-1) & 0x7fffffff))
 		error("Destination address too large");
 #ifndef CONFIG_RELOCATABLE
 	if ((u32)output != LOAD_PHYSICAL_ADDR)
-- 
1.5.3.8

