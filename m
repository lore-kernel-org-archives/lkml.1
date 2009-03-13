Return-Path: <linux-kernel-owner+w=401wt.eu-S1759164AbZCMQrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164AbZCMQrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759554AbZCMQnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:43:24 -0400
Received: from gw.goop.org ([64.81.55.164]:57292 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759472AbZCMQnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:43:23 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 17/17] xen: disable MSI
Date: Fri, 13 Mar 2009 09:42:38 -0700
Message-Id: <1236962558-13748-18-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236962558-13748-1-git-send-email-jeremy@goop.org>
References: <1236962558-13748-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Disable MSI until we support it properly.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/apic.c |    3 +++
 drivers/pci/pci.h   |    2 --
 include/linux/pci.h |    6 ++++++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
index e9d9ea7..3f890c4 100644
--- a/arch/x86/xen/apic.c
+++ b/arch/x86/xen/apic.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/threads.h>
 #include <linux/bitmap.h>
+#include <linux/pci.h>
 
 #include <asm/io_apic.h>
 #include <asm/acpi.h>
@@ -47,6 +48,8 @@ void xen_init_apic(void)
 	if (!xen_initial_domain())
 		return;
 
+	pci_no_msi();
+
 #ifdef CONFIG_ACPI
 	/*
 	 * Pretend ACPI found our lapic even though we've disabled it,
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 07c0aa5..ac1d4ca 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -110,10 +110,8 @@ extern struct rw_semaphore pci_bus_sem;
 extern unsigned int pci_pm_d3_delay;
 
 #ifdef CONFIG_PCI_MSI
-void pci_no_msi(void);
 extern void pci_msi_init_pci_dev(struct pci_dev *dev);
 #else
-static inline void pci_no_msi(void) { }
 static inline void pci_msi_init_pci_dev(struct pci_dev *dev) { }
 #endif
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 3085ea4..e2bcd27 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1197,5 +1197,11 @@ int pci_ext_cfg_avail(struct pci_dev *dev);
 
 void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar);
 
+#ifdef CONFIG_PCI_MSI
+void pci_no_msi(void);
+#else
+static inline void pci_no_msi(void) { }
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
-- 
1.6.0.6

