Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYAZLzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYAZLzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 06:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbYAZLzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 06:55:01 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:40318 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755382AbYAZLy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 06:54:58 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 26 Jan 2008 11:54:10 +0000
Message-Id: <f6e06e6103414914cd9e198abb69dc206d3deed9.1201348185.git.ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <25c98f11d5811cdee328b2e6c400a36c875bc9b8.1201348185.git.ijc@hellion.org.uk>
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
 <6a16d4a8c094a684aa76e898adf1d3e127daeedf.1201348185.git.ijc@hellion.org.uk>
 <d4158549e6497ee261ed220d9cbc8ca8fced8ba7.1201348185.git.ijc@hellion.org.uk>
 <b639de14dbe3cf77f61a9ec0f9e23c50f179c18d.1201348185.git.ijc@hellion.org.uk>
 <25c98f11d5811cdee328b2e6c400a36c875bc9b8.1201348185.git.ijc@hellion.org.uk>
In-Reply-To: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
References: <ff184a8ea93f18a787bb9bd0c860036219b83ee0.1201348185.git.ijc@hellion.org.uk>
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH 6/9] x86: Unify whitespace and comments in arch/x86/boot/compressed/misc_??.c
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
 arch/x86/boot/compressed/misc_32.c |   20 +++++++++++++-------
 arch/x86/boot/compressed/misc_64.c |   13 +++++++------
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/x86/boot/compressed/misc_32.c b/arch/x86/boot/compressed/misc_32.c
index 5a0281c..b659776 100644
--- a/arch/x86/boot/compressed/misc_32.c
+++ b/arch/x86/boot/compressed/misc_32.c
@@ -1,7 +1,7 @@
 /*
  * misc.c
- * 
- * This is a collection of several routines from gzip-1.0.3 
+ *
+ * This is a collection of several routines from gzip-1.0.3
  * adapted for Linux.
  *
  * malloc by Hannu Savolainen 1993 and Matthias Urlichs 1994
@@ -9,6 +9,11 @@
  * High loaded stuff by Hans Lermen & Werner Almesberger, Feb. 1996
  */
 
+/*
+ * we have to be careful, because no indirections are allowed here, and
+ * paravirt_ops is a kind of one. As it will only run in baremetal anyway,
+ * we just keep it from happening
+ */
 #undef CONFIG_PARAVIRT
 #include <linux/linkage.h>
 #include <linux/vmalloc.h>
@@ -261,7 +266,7 @@ static void putstr(const char *s)
 				y--;
 			}
 		} else {
-			vidmem [ ( x + cols * y ) * 2 ] = c;
+			vidmem [(x + cols * y) * 2] = c;
 			if ( ++x >= cols ) {
 				x = 0;
 				if ( ++y >= lines ) {
@@ -345,7 +350,8 @@ static void error(char *x)
 }
 
 asmlinkage void decompress_kernel(void *rmode, unsigned long end,
-			uch *input_data, unsigned long input_len, uch *output)
+				  uch *input_data, unsigned long input_len,
+				  uch *output)
 {
 	real_mode = rmode;
 
@@ -360,10 +366,10 @@ asmlinkage void decompress_kernel(void *rmode, unsigned long end,
 	lines = RM_SCREEN_INFO.orig_video_lines;
 	cols = RM_SCREEN_INFO.orig_video_cols;
 
-	window = output;  	/* Output buffer (Normally at 1M) */
-	free_mem_ptr     = end;	/* Heap  */
+	window = output;		/* Output buffer (Normally at 1M) */
+	free_mem_ptr     = end;		/* Heap */
 	free_mem_end_ptr = end + HEAP_SIZE;
-	inbuf  = input_data;	/* Input buffer */
+	inbuf  = input_data;		/* Input buffer */
 	insize = input_len;
 	inptr  = 0;
 
diff --git a/arch/x86/boot/compressed/misc_64.c b/arch/x86/boot/compressed/misc_64.c
index bd822b7..b627e00 100644
--- a/arch/x86/boot/compressed/misc_64.c
+++ b/arch/x86/boot/compressed/misc_64.c
@@ -1,7 +1,7 @@
 /*
  * misc.c
- * 
- * This is a collection of several routines from gzip-1.0.3 
+ *
+ * This is a collection of several routines from gzip-1.0.3
  * adapted for Linux.
  *
  * malloc by Hannu Savolainen 1993 and Matthias Urlichs 1994
@@ -260,7 +260,7 @@ static void putstr(const char *s)
 				y--;
 			}
 		} else {
-			vidmem [ ( x + cols * y ) * 2 ] = c; 
+			vidmem [(x + cols * y) * 2] = c;
 			if ( ++x >= cols ) {
 				x = 0;
 				if ( ++y >= lines ) {
@@ -344,7 +344,8 @@ static void error(char *x)
 }
 
 asmlinkage void decompress_kernel(void *rmode, unsigned long heap,
-	uch *input_data, unsigned long input_len, uch *output)
+				  uch *input_data, unsigned long input_len,
+				  uch *output)
 {
 	real_mode = rmode;
 
@@ -359,8 +360,8 @@ asmlinkage void decompress_kernel(void *rmode, unsigned long heap,
 	lines = RM_SCREEN_INFO.orig_video_lines;
 	cols = RM_SCREEN_INFO.orig_video_cols;
 
-	window = output;  		/* Output buffer (Normally at 1M) */
-	free_mem_ptr     = heap;	/* Heap  */
+	window = output;		/* Output buffer (Normally at 1M) */
+	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + HEAP_SIZE;
 	inbuf  = input_data;		/* Input buffer */
 	insize = input_len;
-- 
1.5.3.8

