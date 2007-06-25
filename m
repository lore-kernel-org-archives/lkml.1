Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbXFYVss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbXFYVss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbXFYVs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:48:27 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63576 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbXFYVs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:48:26 -0400
Date: Mon, 25 Jun 2007 14:49:26 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 2/2] x86_84: move iommu declaration from proto to iommu.h
In-reply-to: <200706251234.04548.yinghai.lu@sun.com>
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200706251449.27260.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200706221219.16243.yinghai.lu@sun.com>
 <200706221934.59966.yinghai.lu@sun.com> <200706251234.04548.yinghai.lu@sun.com>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 2/2] x86_84: move iommu declaration from proto to iommu.h

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

 arch/x86_64/kernel/aperture.c     |    2 +-
 arch/x86_64/kernel/early-quirks.c |    1 +
 arch/x86_64/kernel/pci-dma.c      |    2 +-
 arch/x86_64/kernel/pci-gart.c     |    1 +
 arch/x86_64/kernel/pci-nommu.c    |    2 +-
 arch/x86_64/kernel/pci-swiotlb.c  |    2 +-
 arch/x86_64/kernel/reboot.c       |    2 +-
 include/asm-x86_64/iommu.h        |   29 +++++++++++++++++++++++++++++
 include/asm-x86_64/proto.h        |   25 -------------------------
 9 files changed, 36 insertions(+), 30 deletions(-)
diff --git a/arch/x86_64/kernel/aperture.c b/arch/x86_64/kernel/aperture.c
index a3d450d..3b443c8 100644
--- a/arch/x86_64/kernel/aperture.c
+++ b/arch/x86_64/kernel/aperture.c
@@ -20,7 +20,7 @@
 #include <linux/ioport.h>
 #include <asm/e820.h>
 #include <asm/io.h>
-#include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/pci-direct.h>
 #include <asm/dma.h>
 #include <asm/k8.h>
diff --git a/arch/x86_64/kernel/early-quirks.c b/arch/x86_64/kernel/early-quirks.c
index 990d9c2..13aa4fd 100644
--- a/arch/x86_64/kernel/early-quirks.c
+++ b/arch/x86_64/kernel/early-quirks.c
@@ -14,6 +14,7 @@
 #include <linux/pci_ids.h>
 #include <asm/pci-direct.h>
 #include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/dma.h>
 
 static void __init via_bugs(void)
diff --git a/arch/x86_64/kernel/pci-dma.c b/arch/x86_64/kernel/pci-dma.c
index 9f80aad..46c1a57 100644
--- a/arch/x86_64/kernel/pci-dma.c
+++ b/arch/x86_64/kernel/pci-dma.c
@@ -8,7 +8,7 @@
 #include <linux/pci.h>
 #include <linux/module.h>
 #include <asm/io.h>
-#include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/calgary.h>
 
 int iommu_merge __read_mostly = 0;
diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
index ae091cd..6e44fc5 100644
--- a/arch/x86_64/kernel/pci-gart.c
+++ b/arch/x86_64/kernel/pci-gart.c
@@ -28,6 +28,7 @@
 #include <asm/mtrr.h>
 #include <asm/pgtable.h>
 #include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/cacheflush.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
diff --git a/arch/x86_64/kernel/pci-nommu.c b/arch/x86_64/kernel/pci-nommu.c
index 6dade0c..617949e 100644
--- a/arch/x86_64/kernel/pci-nommu.c
+++ b/arch/x86_64/kernel/pci-nommu.c
@@ -6,7 +6,7 @@
 #include <linux/string.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/processor.h>
 #include <asm/dma.h>
 
diff --git a/arch/x86_64/kernel/pci-swiotlb.c b/arch/x86_64/kernel/pci-swiotlb.c
index 4b4569a..b2f405e 100644
--- a/arch/x86_64/kernel/pci-swiotlb.c
+++ b/arch/x86_64/kernel/pci-swiotlb.c
@@ -5,7 +5,7 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
 
diff --git a/arch/x86_64/kernel/reboot.c b/arch/x86_64/kernel/reboot.c
index 7503068..368db2b 100644
--- a/arch/x86_64/kernel/reboot.c
+++ b/arch/x86_64/kernel/reboot.c
@@ -16,7 +16,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/apic.h>
-#include <asm/proto.h>
+#include <asm/iommu.h>
 
 /*
  * Power off function, if any
diff --git a/include/asm-x86_64/proto.h b/include/asm-x86_64/proto.h
index b70aa0c..d6e3225 100644
--- a/include/asm-x86_64/proto.h
+++ b/include/asm-x86_64/proto.h
@@ -85,31 +85,6 @@ extern int exception_trace;
 extern unsigned cpu_khz;
 extern unsigned tsc_khz;
 
-extern void pci_iommu_shutdown(void);
-extern void no_iommu_init(void);
-extern int force_iommu, no_iommu;
-extern int iommu_detected;
-#ifdef CONFIG_IOMMU
-extern void gart_iommu_init(void);
-extern void gart_iommu_shutdown(void);
-extern void __init gart_parse_options(char *);
-extern void iommu_hole_init(void);
-extern int fallback_aper_order;
-extern int fallback_aper_force;
-extern int iommu_aperture;
-extern int iommu_aperture_allowed;
-extern int iommu_aperture_disabled;
-extern int fix_aperture;
-#else
-#define iommu_aperture 0
-#define iommu_aperture_allowed 0
-
-static inline void gart_iommu_shutdown(void)
-{
-}
-
-#endif
-
 extern int reboot_force;
 extern int notsc_setup(char *);
 

diff --git a/include/asm-x86_64/iommu.h b/include/asm-x86_64/iommu.h
new file mode 100644
index 0000000..5af471f
--- /dev/null
+++ b/include/asm-x86_64/iommu.h
@@ -0,0 +1,29 @@
+#ifndef _ASM_X8664_IOMMU_H
+#define _ASM_X8664_IOMMU_H 1
+
+extern void pci_iommu_shutdown(void);
+extern void no_iommu_init(void);
+extern int force_iommu, no_iommu;
+extern int iommu_detected;
+#ifdef CONFIG_IOMMU
+extern void gart_iommu_init(void);
+extern void gart_iommu_shutdown(void);
+extern void __init gart_parse_options(char *);
+extern void iommu_hole_init(void);
+extern int fallback_aper_order;
+extern int fallback_aper_force;
+extern int iommu_aperture;
+extern int iommu_aperture_allowed;
+extern int iommu_aperture_disabled;
+extern int fix_aperture;
+#else
+#define iommu_aperture 0
+#define iommu_aperture_allowed 0
+
+static inline void gart_iommu_shutdown(void)
+{
+}
+
+#endif
+
+#endif
