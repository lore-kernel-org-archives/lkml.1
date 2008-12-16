Return-Path: <linux-kernel-owner+w=401wt.eu-S1757838AbYLPUTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbYLPUTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbYLPUSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:18:47 -0500
Received: from gw.goop.org ([64.81.55.164]:45904 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbYLPUSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:18:46 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 03 of 14] swiotlb: move some definitions to header
X-Mercurial-Node: 99fd4f3f460fd86932a7ad346993724cb5c87cd0
Message-Id: <99fd4f3f460fd86932a7.1229458647@abulafia.goop.org>
In-Reply-To: <patchbomb.1229458644@abulafia.goop.org>
Date: Tue, 16 Dec 2008 12:17:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jan Beulich <jbeulich@novell.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/linux/swiotlb.h |   14 ++++++++++++++
 lib/swiotlb.c           |   14 +-------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -7,6 +7,20 @@
 struct dma_attrs;
 struct scatterlist;
 
+/*
+ * Maximum allowable number of contiguous slabs to map,
+ * must be a power of 2.  What is the appropriate value ?
+ * The complexity of {map,unmap}_single is linearly dependent on this value.
+ */
+#define IO_TLB_SEGSIZE	128
+
+
+/*
+ * log of the size of each IO TLB slab.  The number of slabs is command line
+ * controllable.
+ */
+#define IO_TLB_SHIFT 11
+
 extern void
 swiotlb_init(void);
 
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -23,6 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/swiotlb.h>
 #include <linux/string.h>
+#include <linux/swiotlb.h>
 #include <linux/types.h>
 #include <linux/ctype.h>
 
@@ -40,19 +41,6 @@
 #define SG_ENT_VIRT_ADDRESS(sg)	(sg_virt((sg)))
 #define SG_ENT_PHYS_ADDRESS(sg)	virt_to_bus(SG_ENT_VIRT_ADDRESS(sg))
 
-/*
- * Maximum allowable number of contiguous slabs to map,
- * must be a power of 2.  What is the appropriate value ?
- * The complexity of {map,unmap}_single is linearly dependent on this value.
- */
-#define IO_TLB_SEGSIZE	128
-
-/*
- * log of the size of each IO TLB slab.  The number of slabs is command line
- * controllable.
- */
-#define IO_TLB_SHIFT 11
-
 #define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
 
 /*


