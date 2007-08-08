Return-Path: <linux-kernel-owner+w=401wt.eu-S936785AbXHHVIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936785AbXHHVIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763049AbXHHVI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:08:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46978 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755713AbXHHVI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:08:29 -0400
Date: Wed, 8 Aug 2007 17:08:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] hex_dump: add missing "const" qualifiers
Message-ID: <Pine.LNX.4.44L0.0708081650370.2737-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as956) adds a couple of missing "const" qualifiers to the
print_hex_dump library routines.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Is this suitable for merging right away?  It should be safe enough.

Alan Stern



Index: usb-2.6/include/linux/kernel.h
===================================================================
--- usb-2.6.orig/include/linux/kernel.h
+++ usb-2.6/include/linux/kernel.h
@@ -224,9 +224,9 @@ extern void hex_dump_to_buffer(const voi
 				char *linebuf, size_t linebuflen, bool ascii);
 extern void print_hex_dump(const char *level, const char *prefix_str,
 				int prefix_type, int rowsize, int groupsize,
-				void *buf, size_t len, bool ascii);
+				const void *buf, size_t len, bool ascii);
 extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
-			void *buf, size_t len);
+			const void *buf, size_t len);
 #define hex_asc(x)	"0123456789abcdef"[x]
 
 #ifdef DEBUG
Index: usb-2.6/lib/hexdump.c
===================================================================
--- usb-2.6.orig/lib/hexdump.c
+++ usb-2.6/lib/hexdump.c
@@ -145,9 +145,9 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
  */
 void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
 			int rowsize, int groupsize,
-			void *buf, size_t len, bool ascii)
+			const void *buf, size_t len, bool ascii)
 {
-	u8 *ptr = buf;
+	const u8 *ptr = buf;
 	int i, linelen, remaining = len;
 	unsigned char linebuf[200];
 
@@ -189,7 +189,7 @@ EXPORT_SYMBOL(print_hex_dump);
  * rowsize of 16, groupsize of 1, and ASCII output included.
  */
 void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
-			void *buf, size_t len)
+			const void *buf, size_t len)
 {
 	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, 16, 1,
 			buf, len, 1);

