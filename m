Return-Path: <linux-kernel-owner+w=401wt.eu-S1763238AbZEHA0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763238AbZEHA0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZEHAKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:38 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52703
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755756AbZEHAKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:10:06 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 11/11] xen: checkpatch cleanups
Date: Thu,  7 May 2009 14:45:37 -0700
Message-Id: <1241732737-7669-12-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241732737-7669-1-git-send-email-jeremy@goop.org>
References: <1241732737-7669-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Mostly whitespace cleanups; one .c extern moved into a header.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/io.h      |    2 ++
 arch/x86/pci/common.c          |    2 +-
 arch/x86/pci/xen.c             |    3 +--
 include/xen/interface/memory.h |    4 ++--
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index e5383e3..0bb9e13 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -7,6 +7,8 @@
 #include <asm-generic/int-ll64.h>
 #include <asm/page.h>
 
+extern int isapnp_disable;
+
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
 { type ret; asm volatile("mov" size " %1,%0":reg (ret) \
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 171accb..ccad323 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -22,7 +22,7 @@ unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
 unsigned int pci_early_dump_regs;
 static int pci_bf_sort;
 int pci_routeirq;
-int pci_scan_all_fns = 0;
+int pci_scan_all_fns;
 int noioapicquirk;
 #ifdef CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 int noioapicreroute = 0;
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 76f803f..e134fb8 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -10,6 +10,7 @@
 #include <linux/acpi.h>
 
 #include <asm/pci_x86.h>
+#include <asm/io.h>
 
 #include <asm/xen/hypervisor.h>
 
@@ -18,8 +19,6 @@ static int xen_pcifront_enable_irq(struct pci_dev *dev)
 	return 0;
 }
 
-extern int isapnp_disable;
-
 int __init pci_xen_init(void)
 {
 	if (!xen_pv_domain() || xen_initial_domain())
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index 63abbb2..48fc968 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -229,8 +229,8 @@ DEFINE_GUEST_HANDLE_STRUCT(xen_memory_map);
 #define XENMEM_machine_memory_map   10
 
 /*
- * Prevent the balloon driver from changing the memory reservation during a driver
- * critical region.
+ * Prevent the balloon driver from changing the memory reservation
+ * during a driver critical region.
  */
 extern spinlock_t xen_reservation_lock;
 
-- 
1.6.0.6

