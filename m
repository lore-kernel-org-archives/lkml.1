Return-Path: <linux-kernel-owner+w=401wt.eu-S937955AbXGSOAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937955AbXGSOAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764831AbXGSNs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:57 -0400
Received: from ns1.suse.de ([195.135.220.2]:54553 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762287AbXGSNsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:55 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: Yinghai.Lu@Sun.COM, ak@suse.de, alan@lxorguk.ukuu.org.uk,
       ebiederm@xmission.com, muli@il.ibm.com, vgoyal@in.ibm.com,
       davej@codemonkey.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [24/48] x86_64: move iommu declaration from proto to iommu.h
Message-Id: <20070719134854.1DD8E14E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Yinghai Lu <Yinghai.Lu@Sun.COM>

[akpm@linux-foundation.org: build fix]
Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/aperture.c     |    2 +-
 arch/x86_64/kernel/early-quirks.c |    1 +
 arch/x86_64/kernel/pci-calgary.c  |    2 +-
 arch/x86_64/kernel/pci-dma.c      |    2 +-
 arch/x86_64/kernel/pci-gart.c     |    1 +
 arch/x86_64/kernel/pci-nommu.c    |    2 +-
 arch/x86_64/kernel/pci-swiotlb.c  |    2 +-
 arch/x86_64/kernel/reboot.c       |    2 +-
 include/asm-x86_64/iommu.h        |   29 +++++++++++++++++++++++++++++
 include/asm-x86_64/proto.h        |   25 -------------------------
 10 files changed, 37 insertions(+), 31 deletions(-)

Index: linux/arch/x86_64/kernel/aperture.c
===================================================================
--- linux.orig/arch/x86_64/kernel/aperture.c
+++ linux/arch/x86_64/kernel/aperture.c
@@ -20,7 +20,7 @@
 #include <linux/ioport.h>
 #include <asm/e820.h>
 #include <asm/io.h>
-#include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/pci-direct.h>
 #include <asm/dma.h>
 #include <asm/k8.h>
Index: linux/arch/x86_64/kernel/early-quirks.c
===================================================================
--- linux.orig/arch/x86_64/kernel/early-quirks.c
+++ linux/arch/x86_64/kernel/early-quirks.c
@@ -14,6 +14,7 @@
 #include <linux/pci_ids.h>
 #include <asm/pci-direct.h>
 #include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/dma.h>
 
 static void __init via_bugs(void)
Index: linux/arch/x86_64/kernel/pci-calgary.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-calgary.c
+++ linux/arch/x86_64/kernel/pci-calgary.c
@@ -35,7 +35,7 @@
 #include <linux/pci_ids.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/calgary.h>
 #include <asm/tce.h>
 #include <asm/pci-direct.h>
Index: linux/arch/x86_64/kernel/pci-dma.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-dma.c
+++ linux/arch/x86_64/kernel/pci-dma.c
@@ -8,7 +8,7 @@
 #include <linux/pci.h>
 #include <linux/module.h>
 #include <asm/io.h>
-#include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/calgary.h>
 
 int iommu_merge __read_mostly = 0;
Index: linux/arch/x86_64/kernel/pci-gart.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-gart.c
+++ linux/arch/x86_64/kernel/pci-gart.c
@@ -28,6 +28,7 @@
 #include <asm/mtrr.h>
 #include <asm/pgtable.h>
 #include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/cacheflush.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
Index: linux/arch/x86_64/kernel/pci-nommu.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-nommu.c
+++ linux/arch/x86_64/kernel/pci-nommu.c
@@ -6,7 +6,7 @@
 #include <linux/string.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/processor.h>
 #include <asm/dma.h>
 
Index: linux/arch/x86_64/kernel/pci-swiotlb.c
===================================================================
--- linux.orig/arch/x86_64/kernel/pci-swiotlb.c
+++ linux/arch/x86_64/kernel/pci-swiotlb.c
@@ -5,7 +5,7 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
 
Index: linux/arch/x86_64/kernel/reboot.c
===================================================================
--- linux.orig/arch/x86_64/kernel/reboot.c
+++ linux/arch/x86_64/kernel/reboot.c
@@ -16,7 +16,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/apic.h>
-#include <asm/proto.h>
+#include <asm/iommu.h>
 
 /*
  * Power off function, if any
Index: linux/include/asm-x86_64/iommu.h
===================================================================
--- /dev/null
+++ linux/include/asm-x86_64/iommu.h
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
Index: linux/include/asm-x86_64/proto.h
===================================================================
--- linux.orig/include/asm-x86_64/proto.h
+++ linux/include/asm-x86_64/proto.h
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
 
