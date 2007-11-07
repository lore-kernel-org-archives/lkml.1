Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbXKGRcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbXKGRcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbXKGRcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:32:45 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:42688 "EHLO
	outbound4-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755001AbXKGRcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:32:43 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Wed, 7 Nov 2007 18:27:48 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix compile error if !CONFIG_ACPI
Message-ID: <20071107172748.GA6229@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 07 Nov 2007 17:27:38.0344 (UTC)
 FILETIME=[7E3C9E80:01C82163]
X-WSS-ID: 6B2F2A4C07S1758381-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch is against cleanup branch of the x86 tree.


Regards,

Andreas

--
[PATCH] x86: fix compile error if !CONFIG_ACPI

  arch/x86/kernel/setup_64.c: In setup_:
  arch/x86/kernel/setup_64.c:412: error: implicit declaration of function early_
  quirks

Move declaration of early_quirks to the corresponding PCI header file.
IMHO, this is where it really belongs to.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 include/asm-x86/acpi_32.h |    2 --
 include/asm-x86/acpi_64.h |    2 --
 include/asm-x86/pci.h     |    1 +
 3 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/acpi_32.h b/include/asm-x86/acpi_32.h
index 4f8730e..c8afeea 100644
--- a/include/asm-x86/acpi_32.h
+++ b/include/asm-x86/acpi_32.h
@@ -79,8 +79,6 @@ int __acpi_release_global_lock(unsigned int *lock);
         :"=r"(n_hi), "=r"(n_lo)     \
         :"0"(n_hi), "1"(n_lo))
 
-extern void early_quirks(void);
-
 #ifdef CONFIG_ACPI
 extern int acpi_lapic;
 extern int acpi_ioapic;
diff --git a/include/asm-x86/acpi_64.h b/include/asm-x86/acpi_64.h
index e2f3411..58114ed 100644
--- a/include/asm-x86/acpi_64.h
+++ b/include/asm-x86/acpi_64.h
@@ -78,8 +78,6 @@ int __acpi_release_global_lock(unsigned int *lock);
         :"=r"(n_hi), "=r"(n_lo)     \
         :"0"(n_hi), "1"(n_lo))
 
-extern void early_quirks(void);
-
 #ifdef CONFIG_ACPI
 extern int acpi_lapic;
 extern int acpi_ioapic;
diff --git a/include/asm-x86/pci.h b/include/asm-x86/pci.h
index e883619..7d011db 100644
--- a/include/asm-x86/pci.h
+++ b/include/asm-x86/pci.h
@@ -66,6 +66,7 @@ extern int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 
 
 #ifdef CONFIG_PCI
+extern void early_quirks(void);
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
 					unsigned long *strategy_parameter)
-- 
1.5.3.4




