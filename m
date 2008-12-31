Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbYLaLlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbYLaLlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 06:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbYLaLk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 06:40:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34131 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbYLaLk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 06:40:58 -0500
Subject: [PATCH] x86: mpparse.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 31 Dec 2008 17:08:53 +0530
Message-Id: <1230723533.3738.8.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problems, more readable

Fixes style problems:
WARNING: Use #include <linux/smp.h> instead of <asm/smp.h>
WARNING: Use #include <linux/acpi.h> instead of <asm/acpi.h>
WARNING: suspect code indent for conditional statements (8, 17)
WARNING: space prohibited between function name and open parenthesis '('
WARNING: line over 80 characters

total: 0 errors, 11 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/mpparse.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 45e3b69..5977fe8 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -16,14 +16,14 @@
 #include <linux/bitops.h>
 #include <linux/acpi.h>
 #include <linux/module.h>
+#include <linux/smp.h>
+#include <linux/acpi.h>
 
-#include <asm/smp.h>
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
 #include <asm/pgalloc.h>
 #include <asm/io_apic.h>
 #include <asm/proto.h>
-#include <asm/acpi.h>
 #include <asm/bios_ebda.h>
 #include <asm/e820.h>
 #include <asm/trampoline.h>
@@ -95,8 +95,8 @@ static void __init MP_bus_info(struct mpc_config_bus *m)
 #endif
 
 	if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
-		 set_bit(m->mpc_busid, mp_bus_not_pci);
-#if defined(CONFIG_EISA) || defined (CONFIG_MCA)
+		set_bit(m->mpc_busid, mp_bus_not_pci);
+#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_ISA;
 #endif
 	} else if (strncmp(str, BUSTYPE_PCI, sizeof(BUSTYPE_PCI) - 1) == 0) {
@@ -104,7 +104,7 @@ static void __init MP_bus_info(struct mpc_config_bus *m)
 			x86_quirks->mpc_oem_pci_bus(m);
 
 		clear_bit(m->mpc_busid, mp_bus_not_pci);
-#if defined(CONFIG_EISA) || defined (CONFIG_MCA)
+#if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_PCI;
 	} else if (strncmp(str, BUSTYPE_EISA, sizeof(BUSTYPE_EISA) - 1) == 0) {
 		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_EISA;
@@ -314,7 +314,9 @@ static int __init smp_read_mpc(struct mp_config_table *mpc, unsigned early)
 		return 1;
 
 	if (mpc->mpc_oemptr && x86_quirks->smp_read_mpc_oem) {
-		struct mp_config_oemtable *oem_table = (struct mp_config_oemtable *)(unsigned long)mpc->mpc_oemptr;
+		struct mp_config_oemtable *oem_table;
+		oem_table = (struct mp_config_oemtable *)
+			     (unsigned long)mpc->mpc_oemptr;
 		x86_quirks->smp_read_mpc_oem(oem_table, mpc->mpc_oemsize);
 	}
 
@@ -464,9 +466,10 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 
 		if (ELCR_fallback) {
 			/*
-			 *  If the ELCR indicates a level-sensitive interrupt, we
-			 *  copy that information over to the MP table in the
-			 *  irqflag field (level sensitive, active high polarity).
+			 *  If the ELCR indicates a level-sensitive interrupt,
+			 *  we copy that information over to the MP table in
+			 *  the irqflag field
+			 *  (level sensitive, active high polarity).
 			 */
 			if (ELCR_trigger(i))
 				intsrc.mpc_irqflag = 13;
@@ -948,12 +951,17 @@ static int  __init replace_intsrc_all(struct mp_config_table *mpc,
 			    (struct mpc_config_intsrc *)mpt;
 			count += sizeof(struct mpc_config_intsrc);
 			if (!mpc_new_phys) {
-				printk(KERN_INFO "No spare slots, try to append...take your risk, new mpc_length %x\n", count);
+				printk(KERN_INFO "No spare slots, try to append"
+				       "...take your risk, new mpc_length %x\n",
+				       count);
 			} else {
 				if (count <= mpc_new_length)
-					printk(KERN_INFO "No spare slots, try to append..., new mpc_length %x\n", count);
+					printk(KERN_INFO "No spare slots, "
+					       "try to append..., "
+					       "new mpc_length %x\n", count);
 				else {
-					printk(KERN_ERR "mpc_new_length %lx is too small\n", mpc_new_length);
+					printk(KERN_ERR "mpc_new_length %lx is"
+					       " too small\n", mpc_new_length);
 					goto out;
 				}
 			}
-- 
1.5.5.1



