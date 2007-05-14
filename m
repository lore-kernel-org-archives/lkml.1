Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbXENIT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbXENIT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 04:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbXENITV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 04:19:21 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:45919 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbXENITU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 04:19:20 -0400
Date: Mon, 14 May 2007 17:18:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] nommu: add ioremap_page_range().
Message-ID: <20070514081844.GA9468@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lib/ioremap.c is presently only built in if CONFIG_MMU is set. While
this is reasonable, platforms that support both CONFIG_MMU=y or n
need to be able to call in to this regardless.

As none of the current nommu platforms do anything special with
ioremap(), we assume that it's always successful.

This fixes the SH-4 build with CONFIG_MMU=n.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 include/linux/io.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/io.h b/include/linux/io.h
index 09d3512..8423dd3 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -27,8 +27,16 @@ struct device;
 void __iowrite32_copy(void __iomem *to, const void *from, size_t count);
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count);
 
+#ifdef CONFIG_MMU
 int ioremap_page_range(unsigned long addr, unsigned long end,
 		       unsigned long phys_addr, pgprot_t prot);
+#else
+static inline int ioremap_page_range(unsigned long addr, unsigned long end,
+				     unsigned long phys_addr, pgprot_t prot)
+{
+	return 0;
+}
+#endif
 
 /*
  * Managed iomap interface
