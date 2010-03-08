Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab0CHQb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:31:26 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:46989 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab0CHQbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:31:15 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] asm-generic/io.h: add big endian versions of io{read,write}{16,32}
Date: Mon,  8 Mar 2010 11:34:31 -0500
Message-Id: <1268066071-26711-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The asm-generic/iomap.h provides these functions already, but the
non-generic fallback defines do not.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/asm-generic/io.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 1003bd1..4644c9a 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -244,11 +244,15 @@ static inline void writesb(const void __iomem *addr, const void *buf, int len)
 #ifndef CONFIG_GENERIC_IOMAP
 #define ioread8(addr)		readb(addr)
 #define ioread16(addr)		readw(addr)
+#define ioread16be(addr)	be16_to_cpu(ioread16(addr))
 #define ioread32(addr)		readl(addr)
+#define ioread32be(addr)	be32_to_cpu(ioread32(addr))
 
 #define iowrite8(v, addr)	writeb((v), (addr))
 #define iowrite16(v, addr)	writew((v), (addr))
+#define iowrite16be(v, addr)	iowrite16(be16_to_cpu(v), (addr))
 #define iowrite32(v, addr)	writel((v), (addr))
+#define iowrite32be(v, addr)	iowrite32(be32_to_cpu(v), (addr))
 
 #define ioread8_rep(p, dst, count) \
 	insb((unsigned long) (p), (dst), (count))
-- 
1.7.0

