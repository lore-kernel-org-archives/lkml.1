Return-Path: <linux-kernel-owner+w=401wt.eu-S933609AbXC3LAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbXC3LAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 07:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXC3LAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 07:00:33 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4156 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbXC3LAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 07:00:32 -0400
Date: Fri, 30 Mar 2007 12:00:22 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] Provide dummy devm_ioport_* if !HAS_IOPORT
Message-ID: <20070330110022.GA21653@flint.arm.linux.org.uk>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an dummy implementation of devm_ioport_map() and
devm_ioport_unmap() to allow drivers (eg, pata_platform) to build for
platforms where CONFIG_NO_IOPORT is selected.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 include/linux/io.h |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/io.h b/include/linux/io.h
index c244a0c..8cf8df6 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -33,9 +33,22 @@ int ioremap_page_range(unsigned long addr, unsigned long end,
 /*
  * Managed iomap interface
  */
+#ifdef CONFIG_HAS_IOPORT
 void __iomem * devm_ioport_map(struct device *dev, unsigned long port,
 			       unsigned int nr);
 void devm_ioport_unmap(struct device *dev, void __iomem *addr);
+#else
+static inline void __iomem * devm_ioport_map(struct device *dev,
+					     unsigned long port,
+					     unsigned int nr)
+{
+	return NULL;
+}
+
+static inline void devm_ioport_unmap(struct device *dev, void __iomem *addr)
+{
+}
+#endif
 
 void __iomem * devm_ioremap(struct device *dev, unsigned long offset,
 			    unsigned long size);

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
