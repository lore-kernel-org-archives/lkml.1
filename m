Return-Path: <linux-kernel-owner+w=401wt.eu-S1750777AbXBKSUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750777AbXBKSUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 13:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbXBKSUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 13:20:41 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:32780 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbXBKSUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 13:20:41 -0500
Date: Sun, 11 Feb 2007 18:20:38 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] add missing io...._rep() on sparc32
Message-ID: <20070211182038.GA4095@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

same as on sparc64

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-sparc/io.h |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/include/asm-sparc/io.h b/include/asm-sparc/io.h
index cab0b85..c23e74a 100644
--- a/include/asm-sparc/io.h
+++ b/include/asm-sparc/io.h
@@ -256,6 +256,35 @@ extern void iounmap(volatile void __iomem *addr);
 #define iowrite16(val,X)		writew(val,X)
 #define iowrite32(val,X)		writel(val,X)
 
+static inline void ioread8_rep(void __iomem *port, void *buf, unsigned long count)
+{
+	insb((unsigned long __force)port, buf, count);
+}
+static inline void ioread16_rep(void __iomem *port, void *buf, unsigned long count)
+{
+	insw((unsigned long __force)port, buf, count);
+}
+
+static inline void ioread32_rep(void __iomem *port, void *buf, unsigned long count)
+{
+	insl((unsigned long __force)port, buf, count);
+}
+
+static inline void iowrite8_rep(void __iomem *port, const void *buf, unsigned long count)
+{
+	outsb((unsigned long __force)port, buf, count);
+}
+
+static inline void iowrite16_rep(void __iomem *port, const void *buf, unsigned long count)
+{
+	outsw((unsigned long __force)port, buf, count);
+}
+
+static inline void iowrite32_rep(void __iomem *port, const void *buf, unsigned long count)
+{
+	outsl((unsigned long __force)port, buf, count);
+}
+
 /* Create a virtual mapping cookie for an IO port range */
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
 extern void ioport_unmap(void __iomem *);
-- 
1.5.0-rc2.GIT

