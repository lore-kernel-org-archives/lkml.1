Return-Path: <linux-kernel-owner+w=401wt.eu-S936264AbZLQEGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936264AbZLQEGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936252AbZLQEGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:06:30 -0500
Received: from kroah.org ([198.145.64.141]:52330 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936236AbZLQEGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:06:02 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:57:02 2009
Message-Id: <20091217035702.569126308@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tony Luck <tony.luck@intel.com>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [151/151] implement early_io{re,un}map for ia64
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luck, Tony <tony.luck@intel.com>

commit cd7bcf32d42b15891620b3f1387a00178b54291a upstream.

Needed for commit 2c992208 ("intel-iommu: Detect DMAR in hyperspace at
probe time.) to build on IA64.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/include/asm/io.h |    2 ++
 arch/ia64/mm/ioremap.c     |   11 +++++++++++
 2 files changed, 13 insertions(+)

--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -424,6 +424,8 @@ __writeq (unsigned long val, volatile vo
 extern void __iomem * ioremap(unsigned long offset, unsigned long size);
 extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
 extern void iounmap (volatile void __iomem *addr);
+extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size);
+extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
 
 /*
  * String version of IO memory access ops:
--- a/arch/ia64/mm/ioremap.c
+++ b/arch/ia64/mm/ioremap.c
@@ -22,6 +22,12 @@ __ioremap (unsigned long phys_addr)
 }
 
 void __iomem *
+early_ioremap (unsigned long phys_addr, unsigned long size)
+{
+	return __ioremap(phys_addr);
+}
+
+void __iomem *
 ioremap (unsigned long phys_addr, unsigned long size)
 {
 	void __iomem *addr;
@@ -102,6 +108,11 @@ ioremap_nocache (unsigned long phys_addr
 EXPORT_SYMBOL(ioremap_nocache);
 
 void
+early_iounmap (volatile void __iomem *addr, unsigned long size)
+{
+}
+
+void
 iounmap (volatile void __iomem *addr)
 {
 	if (REGION_NUMBER(addr) == RGN_GATE)


