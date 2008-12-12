Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbYLLVPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbYLLVPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbYLLVPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:15:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:55657 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbYLLVO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:14:59 -0500
Message-ID: <4942D42A.9060303@kernel.org>
Date: Fri, 12 Dec 2008 13:14:18 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] sparseirq: fix !SMP building #2
References: <49397CD0.9030301@kernel.org> <20081208142307.GE14856@elte.hu> <20081208150129.GA21496@elte.hu> <20081208174506.GA30398@elte.hu> <20081209031351.GA9092@elte.hu> <493EBECB.4020106@kernel.org> <20081209192622.GA8595@elte.hu> <493ECD64.5060508@kernel.org> <20081209200317.GA16787@elte.hu> <493EDA86.8030702@kernel.org> <20081212113514.GI32640@elte.hu>
In-Reply-To: <20081212113514.GI32640@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix compiling

make intr_remapping.c to include smp.h, so could use boot_cpu_id there

also remove old change that disabling sparseirq with !SMP

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig             |    2 +-
 drivers/pci/intr_remapping.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/intr_remapping.c
===================================================================
--- linux-2.6.orig/drivers/pci/intr_remapping.c
+++ linux-2.6/drivers/pci/intr_remapping.c
@@ -5,6 +5,7 @@
 #include <linux/pci.h>
 #include <linux/irq.h>
 #include <asm/io_apic.h>
+#include <asm/smp.h>
 #include <linux/intel-iommu.h>
 #include "intr_remapping.h"
 
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -245,7 +245,7 @@ config X86_HAS_BOOT_CPU_ID
 
 config SPARSE_IRQ
 	bool "Support sparse irq numbering"
-	depends on (PCI_MSI || HT_IRQ) && SMP
+	depends on PCI_MSI || HT_IRQ
 	default y
 	help
 	  This enables support for sparse irq, esp for msi/msi-x. You may need

