Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbYLCUAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbYLCUAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:00:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYLCTun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:43 -0500
Received: from kroah.org ([198.145.64.141]:59687 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754690AbYLCTue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:34 -0500
Date: Wed, 3 Dec 2008 11:49:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 024/104] x86: always define DECLARE_PCI_UNMAP* macros
Message-ID: <20081203194914.GY8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-always-define-declare_pci_unmap-macros.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Joerg Roedel <joerg.roedel@amd.com>

commit b627c8b17ccacba38c975bc0f69a49fc4e5261c9 upstream.

Impact: fix boot crash on AMD IOMMU if CONFIG_GART_IOMMU is off

Currently these macros evaluate to a no-op except the kernel is compiled
with GART or Calgary support. But we also need these macros when we have
SWIOTLB, VT-d or AMD IOMMU in the kernel. Since we always compile at
least with SWIOTLB we can define these macros always.

This patch is also for stable backport for the same reason the SWIOTLB
default selection patch is.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-x86/pci_64.h |   14 --------------
 1 file changed, 14 deletions(-)

--- a/include/asm-x86/pci_64.h
+++ b/include/asm-x86/pci_64.h
@@ -34,8 +34,6 @@ extern void pci_iommu_alloc(void);
  */
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
 
-#if defined(CONFIG_GART_IOMMU) || defined(CONFIG_CALGARY_IOMMU)
-
 #define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
 	dma_addr_t ADDR_NAME;
 #define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		\
@@ -49,18 +47,6 @@ extern void pci_iommu_alloc(void);
 #define pci_unmap_len_set(PTR, LEN_NAME, VAL)		\
 	(((PTR)->LEN_NAME) = (VAL))
 
-#else
-/* No IOMMU */
-
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
-#define pci_unmap_len(PTR, LEN_NAME)		(0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
-
-#endif
-
 #endif /* __KERNEL__ */
 
 #endif /* __x8664_PCI_H */

