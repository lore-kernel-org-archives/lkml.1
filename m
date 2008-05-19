Return-Path: <linux-kernel-owner+w=401wt.eu-S1762146AbYESPsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762146AbYESPsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760885AbYESPrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:47:13 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:41314 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760189AbYESPrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:47:12 -0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] x86: move mp_bus_not_pci from mpparse.c
Date: Mon, 19 May 2008 19:47:16 +0400
Message-ID: <20080519154715.15071.44328.stgit@thinkpad>
In-Reply-To: <20080519154656.15071.96979.stgit@thinkpad>
References: <20080519154656.15071.96979.stgit@thinkpad>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 arch/x86/kernel/io_apic_32.c |    6 ++++++
 arch/x86/kernel/io_apic_64.c |    2 ++
 arch/x86/kernel/mpparse.c    |   10 ----------
 3 files changed, 8 insertions(+), 10 deletions(-)


diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 01dfe7c..f848ec0 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -81,6 +81,12 @@ struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
 /* # of MP IRQ source entries */
 int mp_irq_entries;
 
+#if defined (CONFIG_MCA) || defined (CONFIG_EISA)
+int mp_bus_id_to_type[MAX_MP_BUSSES];
+#endif
+
+DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
+
 static int disable_timer_pin_1 __initdata;
 
 /*
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index e7f7ea7..27842b0 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -117,6 +117,8 @@ struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
 /* # of MP IRQ source entries */
 int mp_irq_entries;
 
+DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
+
 /*
  * Rough estimation of how many shared IRQs there are, can
  * be changed anytime.
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 83dfd66..e8e041e 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -33,16 +33,6 @@
 #endif
 
 /*
- * Various Linux-internal data structures created from the
- * MP-table.
- */
-#if defined (CONFIG_MCA) || defined (CONFIG_EISA)
-int mp_bus_id_to_type[MAX_MP_BUSSES];
-#endif
-
-DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
-
-/*
  * Checksum an MP configuration block.
  */
 

