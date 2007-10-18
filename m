Return-Path: <linux-kernel-owner+w=401wt.eu-S933297AbXJRT1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297AbXJRT1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758087AbXJRT0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:26:54 -0400
Received: from mail.queued.net ([207.210.101.209]:1619 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757558AbXJRT0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:26:53 -0400
Date: Thu, 18 Oct 2007 15:26:51 -0400
From: Andres Salomon <dilinger@queued.net>
To: linux-kernel@vger.kernel.org
Cc: "Jordan Crouse" <jordan.crouse@amd.com>, info-linux@geode.amd.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] GEODE: use symbolic constant in cs5536 reboot fixup
Message-ID: <20071018152651.4d218be9@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simple cosmetic update for the cs5536 reboot fixup; define the MSR that's used
for rebooting in geode.h, and use the define.

Signed-off-by: Andres Salomon <dilinger@debian.org>

diff --git a/arch/x86/kernel/reboot_fixups_32.c b/arch/x86/kernel/reboot_fixups_32.c
index 8b30b26..1a07bbe 100644
--- a/arch/x86/kernel/reboot_fixups_32.c
+++ b/arch/x86/kernel/reboot_fixups_32.c
@@ -12,6 +12,7 @@
 #include <linux/interrupt.h>
 #include <asm/reboot_fixups.h>
 #include <asm/msr.h>
+#include <asm/geode.h>
 
 static void cs5530a_warm_reset(struct pci_dev *dev)
 {
@@ -24,11 +25,8 @@ static void cs5530a_warm_reset(struct pci_dev *dev)
 
 static void cs5536_warm_reset(struct pci_dev *dev)
 {
-	/*
-	 * 6.6.2.12 Soft Reset (DIVIL_SOFT_RESET)
-	 * writing 1 to the LSB of this MSR causes a hard reset.
-	 */
-	wrmsrl(0x51400017, 1ULL);
+	/* writing 1 to the LSB of this MSR causes a hard reset */
+	wrmsrl(MSR_DIVIL_SOFT_RESET, 1ULL);
 	udelay(50); /* shouldn't get here but be safe and spin a while */
 }
 
diff --git a/include/asm-x86/geode.h b/include/asm-x86/geode.h
index d948988..771af33 100644
--- a/include/asm-x86/geode.h
+++ b/include/asm-x86/geode.h
@@ -38,6 +38,8 @@ extern int geode_get_dev_base(unsigned int dev);
 #define MSR_LBAR_ACPI		0x5140000E
 #define MSR_LBAR_PMS		0x5140000F
 
+#define MSR_DIVIL_SOFT_RESET	0x51400017
+
 #define MSR_PIC_YSEL_LOW	0x51400020
 #define MSR_PIC_YSEL_HIGH	0x51400021
 #define MSR_PIC_ZSEL_LOW	0x51400022
