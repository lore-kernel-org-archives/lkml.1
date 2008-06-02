Return-Path: <linux-kernel-owner+w=401wt.eu-S1758991AbYFBKAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991AbYFBKAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYFBJ7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:59:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32974 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYFBJ7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:59:05 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] celleb_scc_pciex endianness misannotations
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-Id: <E1K36og-0007Yr-HC@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 02 Jun 2008 10:59:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/powerpc/platforms/cell/celleb_scc_pciex.c b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
index 31da84c..0e04f8f 100644
--- a/arch/powerpc/platforms/cell/celleb_scc_pciex.c
+++ b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
@@ -217,7 +217,7 @@ static u##size scc_pciex_in##name(unsigned long port)			\
 static void scc_pciex_ins##name(unsigned long p, void *b, unsigned long c) \
 {									\
 	struct iowa_bus *bus = iowa_pio_find_bus(p);			\
-	u##size *dst = b;						\
+	__le##size *dst = b;						\
 	for (; c != 0; c--, dst++)					\
 		*dst = cpu_to_le##size(__scc_pciex_in##name(bus->phb, p)); \
 	scc_pciex_io_flush(bus);					\
@@ -231,10 +231,11 @@ static void scc_pciex_outs##name(unsigned long p, const void *b,	\
 				 unsigned long c)			\
 {									\
 	struct iowa_bus *bus = iowa_pio_find_bus(p);			\
-	const u##size *src = b;						\
+	const __le##size *src = b;					\
 	for (; c != 0; c--, src++)					\
 		__scc_pciex_out##name(bus->phb, le##size##_to_cpu(*src), p); \
 }
+#define __le8 u8
 #define cpu_to_le8(x) (x)
 #define le8_to_cpu(x) (x)
 PCIEX_PIO_FUNC(8, b)
