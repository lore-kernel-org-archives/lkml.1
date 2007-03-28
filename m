Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbXC1MLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbXC1MLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 08:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbXC1MLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 08:11:33 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36839 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753051AbXC1MLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 08:11:32 -0400
Date: Wed, 28 Mar 2007 14:11:31 +0200
From: Adrian Bunk <bunk@stusta.de>
To: ak@suse.de, mingo@redhat.com
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] i386/x86_64: remove UNEXPECTED_IO_APIC()
Message-ID: <20070328121131.GO16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Many years ago, UNEXPECTED_IO_APIC() contained printk()'s (but nothing more).

Now that it's completely empty for years, we can as well remove it.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/i386/kernel/io_apic.c   |   30 ------------------------------
 arch/x86_64/kernel/io_apic.c |   28 ----------------------------
 2 files changed, 58 deletions(-)

--- linux-2.6.21-rc4-mm1/arch/i386/kernel/io_apic.c.old	2007-03-27 04:18:36.000000000 +0200
+++ linux-2.6.21-rc4-mm1/arch/i386/kernel/io_apic.c	2007-03-27 04:19:49.000000000 +0200
@@ -1403,10 +1403,6 @@ static void __init setup_ExtINT_IRQ0_pin
 	enable_8259A_irq(0);
 }
 
-static inline void UNEXPECTED_IO_APIC(void)
-{
-}
-
 void __init print_IO_APIC(void)
 {
 	int apic, i;
@@ -1446,34 +1442,12 @@ void __init print_IO_APIC(void)
 	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
 	printk(KERN_DEBUG ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
 	printk(KERN_DEBUG ".......    : LTS          : %X\n", reg_00.bits.LTS);
-	if (reg_00.bits.ID >= get_physical_broadcast())
-		UNEXPECTED_IO_APIC();
-	if (reg_00.bits.__reserved_1 || reg_00.bits.__reserved_2)
-		UNEXPECTED_IO_APIC();
 
 	printk(KERN_DEBUG ".... register #01: %08X\n", reg_01.raw);
 	printk(KERN_DEBUG ".......     : max redirection entries: %04X\n", reg_01.bits.entries);
-	if (	(reg_01.bits.entries != 0x0f) && /* older (Neptune) boards */
-		(reg_01.bits.entries != 0x17) && /* typical ISA+PCI boards */
-		(reg_01.bits.entries != 0x1b) && /* Compaq Proliant boards */
-		(reg_01.bits.entries != 0x1f) && /* dual Xeon boards */
-		(reg_01.bits.entries != 0x22) && /* bigger Xeon boards */
-		(reg_01.bits.entries != 0x2E) &&
-		(reg_01.bits.entries != 0x3F)
-	)
-		UNEXPECTED_IO_APIC();
 
 	printk(KERN_DEBUG ".......     : PRQ implemented: %X\n", reg_01.bits.PRQ);
 	printk(KERN_DEBUG ".......     : IO APIC version: %04X\n", reg_01.bits.version);
-	if (	(reg_01.bits.version != 0x01) && /* 82489DX IO-APICs */
-		(reg_01.bits.version != 0x10) && /* oldest IO-APICs */
-		(reg_01.bits.version != 0x11) && /* Pentium/Pro IO-APICs */
-		(reg_01.bits.version != 0x13) && /* Xeon IO-APICs */
-		(reg_01.bits.version != 0x20)    /* Intel P64H (82806 AA) */
-	)
-		UNEXPECTED_IO_APIC();
-	if (reg_01.bits.__reserved_1 || reg_01.bits.__reserved_2)
-		UNEXPECTED_IO_APIC();
 
 	/*
 	 * Some Intel chipsets with IO APIC VERSION of 0x1? don't have reg_02,
@@ -1483,8 +1457,6 @@ void __init print_IO_APIC(void)
 	if (reg_01.bits.version >= 0x10 && reg_02.raw != reg_01.raw) {
 		printk(KERN_DEBUG ".... register #02: %08X\n", reg_02.raw);
 		printk(KERN_DEBUG ".......     : arbitration: %02X\n", reg_02.bits.arbitration);
-		if (reg_02.bits.__reserved_1 || reg_02.bits.__reserved_2)
-			UNEXPECTED_IO_APIC();
 	}
 
 	/*
@@ -1496,8 +1468,6 @@ void __init print_IO_APIC(void)
 	    reg_03.raw != reg_01.raw) {
 		printk(KERN_DEBUG ".... register #03: %08X\n", reg_03.raw);
 		printk(KERN_DEBUG ".......     : Boot DT    : %X\n", reg_03.bits.boot_DT);
-		if (reg_03.bits.__reserved_1)
-			UNEXPECTED_IO_APIC();
 	}
 
 	printk(KERN_DEBUG ".... IRQ redirection table:\n");
--- linux-2.6.21-rc4-mm1/arch/x86_64/kernel/io_apic.c.old	2007-03-27 04:20:22.000000000 +0200
+++ linux-2.6.21-rc4-mm1/arch/x86_64/kernel/io_apic.c	2007-03-27 04:20:51.000000000 +0200
@@ -907,10 +907,6 @@ static void __init setup_ExtINT_IRQ0_pin
 	enable_8259A_irq(0);
 }
 
-void __init UNEXPECTED_IO_APIC(void)
-{
-}
-
 void __apicdebuginit print_IO_APIC(void)
 {
 	int apic, i;
@@ -946,40 +942,16 @@ void __apicdebuginit print_IO_APIC(void)
 	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].mpc_apicid);
 	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
 	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
-	if (reg_00.bits.__reserved_1 || reg_00.bits.__reserved_2)
-		UNEXPECTED_IO_APIC();
 
 	printk(KERN_DEBUG ".... register #01: %08X\n", *(int *)&reg_01);
 	printk(KERN_DEBUG ".......     : max redirection entries: %04X\n", reg_01.bits.entries);
-	if (	(reg_01.bits.entries != 0x0f) && /* older (Neptune) boards */
-		(reg_01.bits.entries != 0x17) && /* typical ISA+PCI boards */
-		(reg_01.bits.entries != 0x1b) && /* Compaq Proliant boards */
-		(reg_01.bits.entries != 0x1f) && /* dual Xeon boards */
-		(reg_01.bits.entries != 0x22) && /* bigger Xeon boards */
-		(reg_01.bits.entries != 0x2E) &&
-		(reg_01.bits.entries != 0x3F) &&
-		(reg_01.bits.entries != 0x03) 
-	)
-		UNEXPECTED_IO_APIC();
 
 	printk(KERN_DEBUG ".......     : PRQ implemented: %X\n", reg_01.bits.PRQ);
 	printk(KERN_DEBUG ".......     : IO APIC version: %04X\n", reg_01.bits.version);
-	if (	(reg_01.bits.version != 0x01) && /* 82489DX IO-APICs */
-		(reg_01.bits.version != 0x02) && /* 82801BA IO-APICs (ICH2) */
-		(reg_01.bits.version != 0x10) && /* oldest IO-APICs */
-		(reg_01.bits.version != 0x11) && /* Pentium/Pro IO-APICs */
-		(reg_01.bits.version != 0x13) && /* Xeon IO-APICs */
-		(reg_01.bits.version != 0x20)    /* Intel P64H (82806 AA) */
-	)
-		UNEXPECTED_IO_APIC();
-	if (reg_01.bits.__reserved_1 || reg_01.bits.__reserved_2)
-		UNEXPECTED_IO_APIC();
 
 	if (reg_01.bits.version >= 0x10) {
 		printk(KERN_DEBUG ".... register #02: %08X\n", reg_02.raw);
 		printk(KERN_DEBUG ".......     : arbitration: %02X\n", reg_02.bits.arbitration);
-		if (reg_02.bits.__reserved_1 || reg_02.bits.__reserved_2)
-			UNEXPECTED_IO_APIC();
 	}
 
 	printk(KERN_DEBUG ".... IRQ redirection table:\n");

