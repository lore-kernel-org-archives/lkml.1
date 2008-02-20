Return-Path: <linux-kernel-owner+w=401wt.eu-S934916AbYBTXTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934916AbYBTXTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934148AbYBTXTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:19:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:50568 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764449AbYBTXTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:19:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=NxmMlW2f6MnTt+SOkGWhLCgZSMAS4wpDW5teVh7Pam3PZc3qqxL6so5gn78Vuz9nKNp7zOamACEMk8B5zyGcyFo3bSfrCWhbLRpkTAyVJ68ch0dlHxRK1JNdSBBJ8J8/kbO0pHb1fdWQy3ilIQYiwReQjOXmHhLlzj0HQ+Vl3UM=
Date: Thu, 21 Feb 2008 00:19:10 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] x86 Coding style fixes to
 arch/x86/boot/compressed/misc.c
Message-ID: <20080221001910.73cecace@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix lot of errors and warnings.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/boot/compressed/misc.c |   66 ++++++++++++++++++++-------------------
 1 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 69aec2f..50d054c 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -127,7 +127,8 @@ typedef unsigned char  uch;
 typedef unsigned short ush;
 typedef unsigned long  ulg;
 
-#define WSIZE 0x80000000	/* Window size must be at least 32k,
+#define WSIZE 0x80000000	/*
+				 * Window size must be at least 32k,
 				 * and a power of two
 				 * We don't actually have a window just
 				 * a huge output buffer so I report
@@ -152,22 +153,22 @@ static unsigned outcnt;  /* bytes in output buffer */
 #define RESERVED     0xC0 /* bit 6,7:   reserved */
 
 #define get_byte()  (inptr < insize ? inbuf[inptr++] : fill_inbuf())
-		
+
 /* Diagnostic functions */
 #ifdef DEBUG
-#  define Assert(cond,msg) {if(!(cond)) error(msg);}
+#  define Assert(cond, msg) {if(!(cond)) error(msg); }
 #  define Trace(x) fprintf x
-#  define Tracev(x) {if (verbose) fprintf x ;}
-#  define Tracevv(x) {if (verbose>1) fprintf x ;}
-#  define Tracec(c,x) {if (verbose && (c)) fprintf x ;}
-#  define Tracecv(c,x) {if (verbose>1 && (c)) fprintf x ;}
+#  define Tracev(x) {if (verbose) fprintf x ; }
+#  define Tracevv(x) {if (verbose > 1) fprintf x ; }
+#  define Tracec(c, x) {if (verbose && (c)) fprintf x ; }
+#  define Tracecv(c, x) {if (verbose > 1 && (c)) fprintf x ; }
 #else
-#  define Assert(cond,msg)
+#  define Assert(cond, msg)
 #  define Trace(x)
 #  define Tracev(x)
 #  define Tracevv(x)
-#  define Tracec(c,x)
-#  define Tracecv(c,x)
+#  define Tracec(c, x)
+#  define Tracecv(c, x)
 #endif
 
 static int  fill_inbuf(void);
@@ -175,7 +176,7 @@ static void flush_window(void);
 static void error(char *m);
 static void gzip_mark(void **);
 static void gzip_release(void **);
-  
+
 /*
  * This is set up by the setup-routine at boot-time
  */
@@ -190,7 +191,7 @@ static unsigned char *real_mode; /* Pointer to real-mode data */
 extern unsigned char input_data[];
 extern int input_len;
 
-static long bytes_out = 0;
+static long bytes_out;
 
 static void *malloc(int size);
 static void free(void *where);
@@ -229,8 +230,10 @@ static void *malloc(int size)
 {
 	void *p;
 
-	if (size <0) error("Malloc error");
-	if (free_mem_ptr <= 0) error("Memory error");
+	if (size < 0)
+		error("Malloc error");
+	if (free_mem_ptr <= 0)
+		error("Memory error");
 
 	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
 
@@ -256,19 +259,19 @@ static void gzip_release(void **ptr)
 {
 	free_mem_ptr = (memptr) *ptr;
 }
- 
+
 static void scroll(void)
 {
 	int i;
 
-	memcpy ( vidmem, vidmem + cols * 2, ( lines - 1 ) * cols * 2 );
-	for ( i = ( lines - 1 ) * cols * 2; i < lines * cols * 2; i += 2 )
+	memcpy(vidmem, vidmem + cols * 2, (lines - 1) * cols * 2);
+	for (i = (lines - 1) * cols * 2; i < lines * cols * 2; i += 2)
 		vidmem[i] = ' ';
 }
 
 static void putstr(const char *s)
 {
-	int x,y,pos;
+	int x, y, pos;
 	char c;
 
 #ifdef CONFIG_X86_32
@@ -279,18 +282,18 @@ static void putstr(const char *s)
 	x = RM_SCREEN_INFO.orig_x;
 	y = RM_SCREEN_INFO.orig_y;
 
-	while ( ( c = *s++ ) != '\0' ) {
-		if ( c == '\n' ) {
+	while ((c = *s++) != '\0') {
+		if (c == '\n') {
 			x = 0;
-			if ( ++y >= lines ) {
+			if (++y >= lines) {
 				scroll();
 				y--;
 			}
 		} else {
 			vidmem [(x + cols * y) * 2] = c;
-			if ( ++x >= cols ) {
+			if (++x >= cols) {
 				x = 0;
-				if ( ++y >= lines ) {
+				if (++y >= lines) {
 					scroll();
 					y--;
 				}
@@ -308,22 +311,22 @@ static void putstr(const char *s)
 	outb(0xff & (pos >> 1), vidport+1);
 }
 
-static void* memset(void* s, int c, unsigned n)
+static void *memset(void *s, int c, unsigned n)
 {
 	int i;
 	char *ss = s;
 
-	for (i=0;i<n;i++) ss[i] = c;
+	for (i = 0; i < n; i++) ss[i] = c;
 	return s;
 }
 
-static void* memcpy(void* dest, const void* src, unsigned n)
+static void *memcpy(void *dest, const void *src, unsigned n)
 {
 	int i;
 	const char *s = src;
 	char *d = dest;
 
-	for (i=0;i<n;i++) d[i] = s[i];
+	for (i = 0; i < n; i++) d[i] = s[i];
 	return dest;
 }
 
@@ -383,11 +386,10 @@ static void parse_elf(void *output)
 	int i;
 
 	memcpy(&ehdr, output, sizeof(ehdr));
-	if(ehdr.e_ident[EI_MAG0] != ELFMAG0 ||
+	if (ehdr.e_ident[EI_MAG0] != ELFMAG0 ||
 	   ehdr.e_ident[EI_MAG1] != ELFMAG1 ||
 	   ehdr.e_ident[EI_MAG2] != ELFMAG2 ||
-	   ehdr.e_ident[EI_MAG3] != ELFMAG3)
-	{
+	   ehdr.e_ident[EI_MAG3] != ELFMAG3) {
 		error("Kernel is not a valid ELF file");
 		return;
 	}
@@ -400,7 +402,7 @@ static void parse_elf(void *output)
 
 	memcpy(phdrs, output + ehdr.e_phoff, sizeof(*phdrs) * ehdr.e_phnum);
 
-	for (i=0; i<ehdr.e_phnum; i++) {
+	for (i = 0; i < ehdr.e_phnum; i++) {
 		phdr = &phdrs[i];
 
 		switch (phdr->p_type) {
@@ -409,7 +411,7 @@ static void parse_elf(void *output)
 			dest = output;
 			dest += (phdr->p_paddr - LOAD_PHYSICAL_ADDR);
 #else
-			dest = (void*)(phdr->p_paddr);
+			dest = (void *)(phdr->p_paddr);
 #endif
 			memcpy(dest,
 			       output + phdr->p_offset,
-- 
1.5.4.1.183.gf873

