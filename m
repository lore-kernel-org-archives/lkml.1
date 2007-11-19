Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbXKSPIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbXKSPIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbXKSPIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:08:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45736 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752864AbXKSPIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:08:34 -0500
Date: Mon, 19 Nov 2007 15:06:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 8250_early: Coding style
Message-ID: <20071119150650.488480d9@the-village.bc.nu>
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

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/serial/8250_early.c linux-2.6.24-rc2-mm1/drivers/serial/8250_early.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/serial/8250_early.c	2007-11-16 17:54:49.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/serial/8250_early.c	2007-11-16 18:35:39.000000000 +0000
@@ -82,7 +82,8 @@
 	serial_out(port, UART_TX, c);
 }
 
-static void __init early_serial8250_write(struct console *console, const char *s, unsigned int count)
+static void __init early_serial8250_write(struct console *console,
+					const char *s, unsigned int count)
 {
 	struct uart_port *port = &early_device.port;
 	unsigned int ier;
@@ -132,7 +133,8 @@
 	serial_out(port, UART_LCR, c & ~UART_LCR_DLAB);
 }
 
-static int __init parse_options(struct early_serial8250_device *device, char *options)
+static int __init parse_options(struct early_serial8250_device *device,
+								char *options)
 {
 	struct uart_port *port = &device->port;
 	int mmio, length;
@@ -145,8 +147,10 @@
 		port->iotype = UPIO_MEM;
 		port->mapbase = simple_strtoul(options + 5, &options, 0);
 #ifdef CONFIG_FIX_EARLYCON_MEM
-		set_fixmap_nocache(FIX_EARLYCON_MEM_BASE, port->mapbase & PAGE_MASK);
-		port->membase = (void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
+		set_fixmap_nocache(FIX_EARLYCON_MEM_BASE,
+					port->mapbase & PAGE_MASK);
+		port->membase =
+			(void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
 		port->membase += port->mapbase & ~PAGE_MASK;
 #else
 		port->membase = ioremap(port->mapbase, 64);
@@ -165,7 +169,8 @@
 	} else
 		return -EINVAL;
 
-	if ((options = strchr(options, ','))) {
+	options = strchr(options, ',');
+	if (options) {
 		options++;
 		device->baud = simple_strtoul(options, NULL, 0);
 		length = min(strcspn(options, " "), sizeof(device->options));
@@ -179,7 +184,7 @@
 	printk(KERN_INFO "Early serial console at %s 0x%llx (options '%s')\n",
 		mmio ? "MMIO" : "I/O port",
 		mmio ? (unsigned long long) port->mapbase
-	             : (unsigned long long) port->iobase,
+		     : (unsigned long long) port->iobase,
 		device->options);
 	return 0;
 }
@@ -199,7 +204,8 @@
 	if (device->port.membase || device->port.iobase)
 		return 0;
 
-	if ((err = parse_options(device, options)) < 0)
+	err = parse_options(device, options);
+	if (err < 0)
 		return err;
 
 	init_port(device);
@@ -219,7 +225,8 @@
 	}
 
 	options = strchr(cmdline, ',') + 1;
-	if ((err = early_serial8250_setup(options)) < 0)
+	err = early_serial8250_setup(options);
+	if (err < 0)
 		return err;
 
 	register_console(&early_serial8250_console);
