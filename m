Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbZKGONR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbZKGONR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 09:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZKGONF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 09:13:05 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:38475 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbZKGOND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 09:13:03 -0500
Date: Sat, 7 Nov 2009 14:48:38 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH] serial: fix printk format specifiers for struct uart_port::iobase
Message-ID: <20091107134838.GA18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct uart_port::iobase is unsigned long, so use %lx as printk
format specifier.

Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index b1ae774..737b4c9 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1089,7 +1089,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 	if (!up->port.iobase && !up->port.mapbase && !up->port.membase)
 		return;
 
-	DEBUG_AUTOCONF("ttyS%d: autoconf (0x%04x, 0x%p): ",
+	DEBUG_AUTOCONF("ttyS%d: autoconf (0x%04lx, 0x%p): ",
 		       serial_index(&up->port), up->port.iobase, up->port.membase);
 
 	/*
diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index e7108e7..34b0b2b 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -2340,7 +2340,7 @@ pciserial_init_ports(struct pci_dev *dev, const struct pciserial_board *board)
 			break;
 
 #ifdef SERIAL_DEBUG_PCI
-		printk(KERN_DEBUG "Setup PCI port: port %x, irq %d, type %d\n",
+		printk(KERN_DEBUG "Setup PCI port: port %lx, irq %d, type %d\n",
 		       serial_port.iobase, serial_port.irq, serial_port.iotype);
 #endif

--
