Return-Path: <linux-kernel-owner+w=401wt.eu-S1763789AbXJNSi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763789AbXJNSi2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763276AbXJNSgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:36:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60295 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763468AbXJNSgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:36:01 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] endianness annotations in arm io.h
Cc: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Message-Id: <E1Ih8Jk-00044H-7a@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:36:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-arm/io.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-arm/io.h b/include/asm-arm/io.h
index 1d3caa4..eebe56e 100644
--- a/include/asm-arm/io.h
+++ b/include/asm-arm/io.h
@@ -228,12 +228,12 @@ extern void _memset_io(volatile void __iomem *, int, size_t);
  */
 #ifndef ioread8
 #define ioread8(p)	({ unsigned int __v = __raw_readb(p); __v; })
-#define ioread16(p)	({ unsigned int __v = le16_to_cpu(__raw_readw(p)); __v; })
-#define ioread32(p)	({ unsigned int __v = le32_to_cpu(__raw_readl(p)); __v; })
+#define ioread16(p)	({ unsigned int __v = le16_to_cpu((__force __le16)__raw_readw(p)); __v; })
+#define ioread32(p)	({ unsigned int __v = le32_to_cpu((__force __le32)__raw_readl(p)); __v; })
 
 #define iowrite8(v,p)	__raw_writeb(v, p)
-#define iowrite16(v,p)	__raw_writew(cpu_to_le16(v), p)
-#define iowrite32(v,p)	__raw_writel(cpu_to_le32(v), p)
+#define iowrite16(v,p)	__raw_writew((__force __u16)cpu_to_le16(v), p)
+#define iowrite32(v,p)	__raw_writel((__force __u32)cpu_to_le32(v), p)
 
 #define ioread8_rep(p,d,c)	__raw_readsb(p,d,c)
 #define ioread16_rep(p,d,c)	__raw_readsw(p,d,c)
-- 
1.5.3.GIT


