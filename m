Return-Path: <linux-kernel-owner+w=401wt.eu-S933537AbYD2Pbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbYD2Pbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933265AbYD2Pb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:31:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:58173 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933257AbYD2PbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:31:24 -0400
Date: Tue, 29 Apr 2008 10:25:48 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Greg KH <greg@kroah.com>
cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
       Andrew Morton <akpm@osdl.org>,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@ozlabs.org>,
       lkml Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH][RESEND] devres: support addresses greater than an unsigned
 long via dev_ioremap
In-Reply-To: <20080429152331.GC11329@kroah.com>
Message-ID: <Pine.LNX.4.64.0804291025140.25102@blarg.am.freescale.net>
References: <Pine.LNX.4.64.0804290122210.10928@blarg.am.freescale.net>
 <4816C094.6030601@gmail.com> <4816C214.60806@pobox.com>
 <C415A4D5-CE5A-4E48-B5D5-0B9A6C7A5CA6@kernel.crashing.org>
 <20080429152331.GC11329@kroah.com>
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

For GregKH to actually get the patch.

- k

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

