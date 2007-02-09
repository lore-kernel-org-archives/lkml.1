Return-Path: <linux-kernel-owner+w=401wt.eu-S1946651AbXBIQsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946651AbXBIQsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946640AbXBIQif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:38:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51667 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946637AbXBIQi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:38:26 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] drivers/serial NULL noise removal
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYlV-0006lk-Kq@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:38:25 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/serial/uartlite.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
index db8607e..f5051cf 100644
--- a/drivers/serial/uartlite.c
+++ b/drivers/serial/uartlite.c
@@ -256,7 +256,7 @@ static void ulite_release_port(struct uart_port *port)
 {
 	release_mem_region(port->mapbase, ULITE_REGION);
 	iounmap(port->membase);
-	port->membase = 0;
+	port->membase = NULL;
 }
 
 static int ulite_request_port(struct uart_port *port)
@@ -438,7 +438,7 @@ static int __devinit ulite_probe(struct platform_device *pdev)
 	port->iotype	= UPIO_MEM;
 	port->iobase	= 1; /* mark port in use */
 	port->mapbase	= res->start;
-	port->membase	= 0;
+	port->membase	= NULL;
 	port->ops	= &ulite_ops;
 	port->irq	= res2->start;
 	port->flags	= UPF_BOOT_AUTOCONF;
@@ -462,7 +462,7 @@ static int ulite_remove(struct platform_device *pdev)
 		uart_remove_one_port(&ulite_uart_driver, port);
 
 	/* mark port as free */
-	port->membase = 0;
+	port->membase = NULL;
 
 	return 0;
 }
-- 
1.5.0-rc2.GIT


