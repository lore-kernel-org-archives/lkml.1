Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbYGJRBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbYGJRBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbYGJRBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:01:08 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:10287 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbYGJRBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:01:06 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3SV9B-01-VJ1-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/5] x86/pci merge: Fixing numaq initialization
Date: Thu, 10 Jul 2008 18:58:24 +0200
Message-ID: <1215709106-9182-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215709106-9182-1-git-send-email-robert.richter@amd.com>
References: <1215709106-9182-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 10 Jul 2008 17:00:50.0664 (UTC) FILETIME=[819A9E80:01C8E2AE]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch d49c4288 (tip/x86/mpparse) introduced some changes in calling
subsys_init calls if CONFIG_X86_NUMAQ option is set. This patch
updates subsystem initalization according to this changes.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/legacy.c |    3 +++
 arch/x86/pci/numa.c   |   10 +---------
 arch/x86/pci/pci.h    |    1 +
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index 3c1d795..d8b6e92 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -62,6 +62,9 @@ int __init pci_subsys_init(void)
 #endif
 	pci_legacy_init();
 	pcibios_irq_init();
+#ifdef CONFIG_X86_NUMAQ
+	pci_numa_init();
+#endif
 	pcibios_init();
 }
 subsys_initcall(pci_subsys_init);
diff --git a/arch/x86/pci/numa.c b/arch/x86/pci/numa.c
index e1620dc..8b5ca19 100644
--- a/arch/x86/pci/numa.c
+++ b/arch/x86/pci/numa.c
@@ -151,7 +151,7 @@ static void __devinit pci_fixup_i450nx(struct pci_dev *d)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82451NX, pci_fixup_i450nx);
 
-static int __init pci_numa_init(void)
+int __init pci_numa_init(void)
 {
 	int quad;
 
@@ -176,11 +176,3 @@ static int __init pci_numa_init(void)
 		}
 	return 0;
 }
-
-static __init int pci_subsys_init(void)
-{
-	pci_numa_init();
-	pcibios_irq_init();
-	pcibios_init();
-}
-subsys_initcall(pci_subsys_init);
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index 5824174..b2270a5 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -107,6 +107,7 @@ extern void __init dmi_check_skip_isa_align(void);
 /* some common used subsys_initcalls */
 extern int __init pci_acpi_init(void);
 extern int __init pcibios_irq_init(void);
+extern int __init pci_numa_init(void);
 extern int __init pcibios_init(void);
 
 /* pci-mmconfig.c */
-- 
1.5.5.4


