Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbZEMDOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbZEMDOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbZEMDGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:25 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36237
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755937AbZEMDGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:06:11 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 10/10] xen/swiotlb: define xen_wants_swiotlb when PCI_XEN is not enabled
Date: Tue, 12 May 2009 14:50:51 -0700
Message-Id: <1242165051-6636-11-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242165051-6636-1-git-send-email-jeremy@goop.org>
References: <1242165051-6636-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

If CONFIG_PCI is disabled, CONFIG_SWIOTLB can still be enabled on x86-64,
which calls xen_wants_swiotlb().  Define a stub version when CONFIG_PCI
(and, implicitly, CONFIG_PCI_XEN) is not enabled.

[ Impact: compile fix with !CONFIG_PCI ]
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/xen/swiotlb.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/xen/swiotlb.h b/include/xen/swiotlb.h
index f35183b..75d1da1 100644
--- a/include/xen/swiotlb.h
+++ b/include/xen/swiotlb.h
@@ -5,6 +5,14 @@ extern void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs);
 extern phys_addr_t xen_bus_to_phys(dma_addr_t daddr);
 extern dma_addr_t xen_phys_to_bus(phys_addr_t paddr);
 extern int xen_range_needs_mapping(phys_addr_t phys, size_t size);
+
+#ifdef CONFIG_PCI_XEN
 extern int xen_wants_swiotlb(void);
+#else
+static inline int xen_wants_swiotlb(void)
+{
+	return 0;
+}
+#endif
 
 #endif /* _XEN_SWIOTLB_H */
-- 
1.6.0.6

