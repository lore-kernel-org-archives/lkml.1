Return-Path: <linux-kernel-owner+w=401wt.eu-S936032AbXGZQog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936032AbXGZQog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935848AbXGZQnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:43:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57207 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935856AbXGZQnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:43:00 -0400
Date: Thu, 26 Jul 2007 17:42:59 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] m68k {in,out}_le{16,32} endianness misannotation
Message-ID: <20070726164259.GN27237@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/include/asm-m68k/raw_io.h b/include/asm-m68k/raw_io.h
index 91c623f..d9eb983 100644
--- a/include/asm-m68k/raw_io.h
+++ b/include/asm-m68k/raw_io.h
@@ -36,15 +36,15 @@ extern void __iounmap(void *addr, unsigned long size);
 #define in_be32(addr) \
     ({ u32 __v = (*(__force volatile u32 *) (addr)); __v; })
 #define in_le16(addr) \
-    ({ u16 __v = le16_to_cpu(*(__force volatile u16 *) (addr)); __v; })
+    ({ u16 __v = le16_to_cpu(*(__force volatile __le16 *) (addr)); __v; })
 #define in_le32(addr) \
-    ({ u32 __v = le32_to_cpu(*(__force volatile u32 *) (addr)); __v; })
+    ({ u32 __v = le32_to_cpu(*(__force volatile __le32 *) (addr)); __v; })
 
 #define out_8(addr,b) (void)((*(__force volatile u8 *) (addr)) = (b))
 #define out_be16(addr,w) (void)((*(__force volatile u16 *) (addr)) = (w))
 #define out_be32(addr,l) (void)((*(__force volatile u32 *) (addr)) = (l))
-#define out_le16(addr,w) (void)((*(__force volatile u16 *) (addr)) = cpu_to_le16(w))
-#define out_le32(addr,l) (void)((*(__force volatile u32 *) (addr)) = cpu_to_le32(l))
+#define out_le16(addr,w) (void)((*(__force volatile __le16 *) (addr)) = cpu_to_le16(w))
+#define out_le32(addr,l) (void)((*(__force volatile __le32 *) (addr)) = cpu_to_le32(l))
 
 #define raw_inb in_8
 #define raw_inw in_be16
