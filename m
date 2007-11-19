Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbXKSPLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbXKSPLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbXKSPLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:11:00 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45742 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754087AbXKSPK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:10:59 -0500
Date: Mon, 19 Nov 2007 15:08:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 8250_hp300: coding style
Message-ID: <20071119150846.5a9b686c@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/serial/8250_hp300.c linux-2.6.24-rc2-mm1/drivers/serial/8250_hp300.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/serial/8250_hp300.c	2007-11-16 17:20:48.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/serial/8250_hp300.c	2007-11-16 18:35:39.000000000 +0000
@@ -36,7 +36,7 @@
 #ifdef CONFIG_HPDCA
 
 static int __devinit hpdca_init_one(struct dio_dev *d,
-                                const struct dio_device_id *ent);
+					const struct dio_device_id *ent);
 static void __devexit hpdca_remove_one(struct dio_dev *d);
 
 static struct dio_device_id hpdca_dio_tbl[] = {
@@ -85,7 +85,7 @@
 
 #ifdef CONFIG_SERIAL_8250_CONSOLE
 /*
- * Parse the bootinfo to find descriptions for headless console and 
+ * Parse the bootinfo to find descriptions for headless console and
  * debug serial ports and register them with the 8250 driver.
  * This function should be called before serial_console_init() is called
  * to make sure the serial console will be available for use. IA-64 kernel
@@ -126,13 +126,11 @@
 		printk(KERN_WARNING "Serial console is APCI but support is disabled (CONFIG_HPAPCI)!\n");
 		return 0;
 #endif
-	}
-	else {
+	} else {
 #ifdef CONFIG_HPDCA
 		unsigned long pa = dio_scodetophysaddr(scode);
-		if (!pa) {
+		if (!pa)
 			return 0;
-		}
 
 		printk(KERN_INFO "Serial console is HP DCA at select code %d\n", scode);
 
@@ -145,26 +143,23 @@
 		/* Enable board-interrupts */
 		out_8(pa + DIO_VIRADDRBASE + DCA_IC, DCA_IC_IE);
 
-		if (DIO_ID(pa + DIO_VIRADDRBASE) & 0x80) {
+		if (DIO_ID(pa + DIO_VIRADDRBASE) & 0x80)
 			add_preferred_console("ttyS", port.line, "9600n8");
-		}
 #else
 		printk(KERN_WARNING "Serial console is DCA but support is disabled (CONFIG_HPDCA)!\n");
 		return 0;
 #endif
 	}
 
-	if (early_serial_setup(&port) < 0) {
+	if (early_serial_setup(&port) < 0)
 		printk(KERN_WARNING "hp300_setup_serial_console(): early_serial_setup() failed.\n");
-	}
-
 	return 0;
 }
 #endif /* CONFIG_SERIAL_8250_CONSOLE */
 
 #ifdef CONFIG_HPDCA
 static int __devinit hpdca_init_one(struct dio_dev *d,
-                                const struct dio_device_id *ent)
+				const struct dio_device_id *ent)
 {
 	struct uart_port port;
 	int line;
@@ -210,7 +205,7 @@
 
 static int __init hp300_8250_init(void)
 {
-	static int called = 0;
+	static int called;
 #ifdef CONFIG_HPAPCI
 	int line;
 	unsigned long base;
@@ -239,13 +234,12 @@
 	 * Port 1 is either the console or the DCA.
 	 */
 	for (i = 1; i < 4; i++) {
-		/* Port 1 is the console on a 425e, on other machines it's mapped to
-		 * DCA.
+		/* Port 1 is the console on a 425e, on other machines it's
+		 * mapped to DCA.
 		 */
 #ifdef CONFIG_SERIAL_8250_CONSOLE
-		if (i == 1) {
+		if (i == 1)
 			continue;
-		}
 #endif
 
 		/* Create new serial device */
@@ -259,7 +253,8 @@
 
 		/* Memory mapped I/O */
 		uport.iotype = UPIO_MEM;
-		uport.flags = UPF_SKIP_TEST | UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF;
+		uport.flags = UPF_SKIP_TEST | UPF_SHARE_IRQ \
+			      | UPF_BOOT_AUTOCONF;
 		/* XXX - no interrupt support yet */
 		uport.irq = 0;
 		uport.uartclk = HPAPCI_BAUD_BASE * 16;
@@ -270,8 +265,8 @@
 		line = serial8250_register_port(&uport);
 
 		if (line < 0) {
-			printk(KERN_NOTICE "8250_hp300: register_serial() APCI %d"
-			       " irq %d failed\n", i, uport.irq);
+			printk(KERN_NOTICE "8250_hp300: register_serial() APCI"
+			       " %d irq %d failed\n", i, uport.irq);
 			kfree(port);
 			continue;
 		}
