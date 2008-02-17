Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbYBQRXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbYBQRXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYBQRXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:23:15 -0500
Received: from vsmtp3.tin.it ([212.216.176.223]:56193 "EHLO vsmtp3.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbYBQRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:23:14 -0500
From: Leonardo Potenza <lpotenza@inwind.it>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/net/cs89x0.c: compilation warning fix
Date: Sun, 17 Feb 2008 18:23:15 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802171823.15759.lpotenza@inwind.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leonardo Potenza <lpotenza@inwind.it>

Suppress the warning message about the 'netcard_portlist' defined but not used.

Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
---

When building cs89x0 as a module, the following warning message is generated:
drivers/net/cs89x0.c:198: warning: 'netcard_portlist' defined but not used

Since the netcard_portlist is not so big, I just marked the array as __used.

--- linux-2.6.orig/drivers/net/cs89x0.c
+++ linux-2.6/drivers/net/cs89x0.c
@@ -172,30 +172,30 @@ static char version[] __initdata =
    them to system IRQ numbers. This mapping is card specific and is set to
    the configuration of the Cirrus Eval board for this chip. */
 #ifdef CONFIG_ARCH_CLPS7500
-static unsigned int netcard_portlist[] __initdata =
+static unsigned int netcard_portlist[] __used __initdata =
    { 0x80090303, 0x300, 0x320, 0x340, 0x360, 0x200, 0x220, 0x240, 0x260, 0x280, 0x2a0, 0x2c0, 0x2e0, 0};
 static unsigned int cs8900_irq_map[] = {12,0,0,0};
 #elif defined(CONFIG_SH_HICOSH4)
-static unsigned int netcard_portlist[] __initdata =
+static unsigned int netcard_portlist[] __used __initdata =
    { 0x0300, 0};
 static unsigned int cs8900_irq_map[] = {1,0,0,0};
 #elif defined(CONFIG_MACH_IXDP2351)
-static unsigned int netcard_portlist[] __initdata = {IXDP2351_VIRT_CS8900_BASE, 0};
+static unsigned int netcard_portlist[] __used __initdata = {IXDP2351_VIRT_CS8900_BASE, 0};
 static unsigned int cs8900_irq_map[] = {IRQ_IXDP2351_CS8900, 0, 0, 0};
 #include <asm/irq.h>
 #elif defined(CONFIG_ARCH_IXDP2X01)
 #include <asm/irq.h>
-static unsigned int netcard_portlist[] __initdata = {IXDP2X01_CS8900_VIRT_BASE, 0};
+static unsigned int netcard_portlist[] __used __initdata = {IXDP2X01_CS8900_VIRT_BASE, 0};
 static unsigned int cs8900_irq_map[] = {IRQ_IXDP2X01_CS8900, 0, 0, 0};
 #elif defined(CONFIG_ARCH_PNX010X)
 #include <asm/irq.h>
 #include <asm/arch/gpio.h>
 #define CIRRUS_DEFAULT_BASE	IO_ADDRESS(EXT_STATIC2_s0_BASE + 0x200000)	/* = Physical address 0x48200000 */
 #define CIRRUS_DEFAULT_IRQ	VH_INTC_INT_NUM_CASCADED_INTERRUPT_1 /* Event inputs bank 1 - ID 35/bit 3 */
-static unsigned int netcard_portlist[] __initdata = {CIRRUS_DEFAULT_BASE, 0};
+static unsigned int netcard_portlist[] __used __initdata = {CIRRUS_DEFAULT_BASE, 0};
 static unsigned int cs8900_irq_map[] = {CIRRUS_DEFAULT_IRQ, 0, 0, 0};
 #else
-static unsigned int netcard_portlist[] __initdata =
+static unsigned int netcard_portlist[] __used __initdata =
    { 0x300, 0x320, 0x340, 0x360, 0x200, 0x220, 0x240, 0x260, 0x280, 0x2a0, 0x2c0, 0x2e0, 0};
 static unsigned int cs8900_irq_map[] = {10,11,12,5};
 #endif
