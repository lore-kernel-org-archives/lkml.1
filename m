Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbYAZL5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbYAZL5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 06:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbYAZLzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 06:55:44 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:13649 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468AbYAZLzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 06:55:41 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 26 Jan 2008 11:54:12 +0000
Message-Id: <a14f8ca682837cfb369e54a93c2fe5d79d0836d8.1201348185.git.ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <5c9a53dfa2ac6835d88bbdde15eb54f0b68d126e.1201348185.git.ijc@hellion.org.uk>
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
 <6a16d4a8c094a684aa76e898adf1d3e127daeedf.1201348185.git.ijc@hellion.org.uk>
 <d4158549e6497ee261ed220d9cbc8ca8fced8ba7.1201348185.git.ijc@hellion.org.uk>
 <b639de14dbe3cf77f61a9ec0f9e23c50f179c18d.1201348185.git.ijc@hellion.org.uk>
 <25c98f11d5811cdee328b2e6c400a36c875bc9b8.1201348185.git.ijc@hellion.org.uk>
 <f6e06e6103414914cd9e198abb69dc206d3deed9.1201348185.git.ijc@hellion.org.uk>
 <5c9a53dfa2ac6835d88bbdde15eb54f0b68d126e.1201348185.git.ijc@hellion.org.uk>
In-Reply-To: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH 8/9] x86: Unify variable names in arch/x86/boot/compressed/misc_??.c
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
index 7522b64..9f963af 100644
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

