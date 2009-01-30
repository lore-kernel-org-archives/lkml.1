Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbZA3KWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbZA3KWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbZA3KSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:18:02 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54384 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbZA3KRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:17:55 -0500
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, lnxninja@linux.vnet.ibm.com,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Remove setup_ioapic_ids x86_quirks hook
Date: Fri, 30 Jan 2009 11:17:19 +0100
Message-Id: <1233310639-27916-14-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233310639-27916-13-git-send-email-andi@firstfloor.org>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
 <1233310639-27916-2-git-send-email-andi@firstfloor.org>
 <1233310639-27916-3-git-send-email-andi@firstfloor.org>
 <1233310639-27916-4-git-send-email-andi@firstfloor.org>
 <1233310639-27916-5-git-send-email-andi@firstfloor.org>
 <1233310639-27916-6-git-send-email-andi@firstfloor.org>
 <1233310639-27916-7-git-send-email-andi@firstfloor.org>
 <1233310639-27916-8-git-send-email-andi@firstfloor.org>
 <1233310639-27916-9-git-send-email-andi@firstfloor.org>
 <1233310639-27916-10-git-send-email-andi@firstfloor.org>
 <1233310639-27916-11-git-send-email-andi@firstfloor.org>
 <1233310639-27916-12-git-send-email-andi@firstfloor.org>
 <1233310639-27916-13-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Was only used by NUMAQ

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/setup.h |    1 -
 arch/x86/kernel/io_apic.c    |    3 ---
 arch/x86/kernel/numaq_32.c   |    7 -------
 3 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index e0b651e..0d3fd5d 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -42,7 +42,6 @@ struct x86_quirks {
 	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
 	void (*smp_read_mpc_oem)(struct mpc_oemtable *oemtable,
 				unsigned short oemsize);
-	int (*setup_ioapic_ids)(void);
 	int (*update_genapic)(void);
 };
 
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 9a3e66f..7743890 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -2074,9 +2074,6 @@ static void __init setup_ioapic_ids_from_mpc(void)
 	unsigned char old_id;
 	unsigned long flags;
 
-	if (x86_quirks->setup_ioapic_ids && x86_quirks->setup_ioapic_ids())
-		return;
-
 	/*
 	 * Don't check I/O APIC IDs for xAPIC systems.  They have
 	 * no meaning without the serial APIC bus.
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index 6ddacbc..67d994d 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -228,12 +228,6 @@ static void __init smp_read_mpc_oem(struct mpc_oemtable *oemtable,
 	}
 }
 
-static int __init numaq_setup_ioapic_ids(void)
-{
-	/* so can skip it */
-	return 1;
-}
-
 static int __init numaq_update_genapic(void)
 {
 	return 0;
@@ -253,7 +247,6 @@ static struct x86_quirks numaq_x86_quirks __initdata = {
 	.mpc_oem_bus_info	= mpc_oem_bus_info,
 	.mpc_oem_pci_bus	= mpc_oem_pci_bus,
 	.smp_read_mpc_oem	= smp_read_mpc_oem,
-	.setup_ioapic_ids	= numaq_setup_ioapic_ids,
 	.update_genapic		= numaq_update_genapic,
 };
 
-- 
1.5.6.5

