Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbYD2G1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbYD2G1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbYD2G1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:27:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:45071 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbYD2G1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:27:04 -0400
Date: Tue, 29 Apr 2008 01:22:31 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: htejun@gmail.com, Andrew Morton <akpm@osdl.org>, jgarzik@pobox.com
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] devres: support addresses greater than an unsigned long via
 dev_ioremap
Message-ID: <Pine.LNX.4.64.0804290122210.10928@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a resource_size_t instead of unsigned long since some arch's are
capable of having ioremap deal with addresses greater than the size of a
unsigned long.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 include/linux/io.h |    4 ++--
 lib/devres.c       |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/io.h b/include/linux/io.h
index e3b2dda..831f57c 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -58,9 +58,9 @@ static inline void devm_ioport_unmap(struct device *dev, void __iomem *addr)
 }
 #endif

-void __iomem * devm_ioremap(struct device *dev, unsigned long offset,
+void __iomem * devm_ioremap(struct device *dev, resource_size_t offset,
 			    unsigned long size);
-void __iomem * devm_ioremap_nocache(struct device *dev, unsigned long offset,
+void __iomem * devm_ioremap_nocache(struct device *dev, resource_size_t offset,
 				    unsigned long size);
 void devm_iounmap(struct device *dev, void __iomem *addr);
 int check_signature(const volatile void __iomem *io_addr,
diff --git a/lib/devres.c b/lib/devres.c
index edc27a5..26c87c4 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -20,7 +20,7 @@ static int devm_ioremap_match(struct device *dev, void *res, void *match_data)
  *
  * Managed ioremap().  Map is automatically unmapped on driver detach.
  */
-void __iomem *devm_ioremap(struct device *dev, unsigned long offset,
+void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
 			   unsigned long size)
 {
 	void __iomem **ptr, *addr;
@@ -49,7 +49,7 @@ EXPORT_SYMBOL(devm_ioremap);
  * Managed ioremap_nocache().  Map is automatically unmapped on driver
  * detach.
  */
-void __iomem *devm_ioremap_nocache(struct device *dev, unsigned long offset,
+void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
 				   unsigned long size)
 {
 	void __iomem **ptr, *addr;
-- 
1.5.4.1

