Return-Path: <linux-kernel-owner+w=401wt.eu-S936668AbXJSUis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936668AbXJSUis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765512AbXJSUij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:38:39 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:46824 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764506AbXJSUii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:38:38 -0400
Date: Fri, 19 Oct 2007 21:38:33 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] dz.c: Rename the serial console structure
Message-ID: <Pine.LNX.4.64N.0710192135440.13279@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Rename the serial console structure so that `modpost' does not complain 
about a reference to an "init" section -- "_console" is magic.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Tested with checkpatch.pl and at the run-time -- MIPS/Linux on a 
DECstation 5000/200.

 Please apply,

  Maciej

patch-mips-2.6.23-rc5-20070904-serial-dz-console-0
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/serial/dz.c linux-mips-2.6.23-rc5-20070904/drivers/serial/dz.c
--- linux-mips-2.6.23-rc5-20070904.macro/drivers/serial/dz.c	2007-05-02 04:56:10.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/drivers/serial/dz.c	2007-09-18 23:07:54.000000000 +0000
@@ -741,7 +741,7 @@ static int __init dz_console_setup(struc
 }
 
 static struct uart_driver dz_reg;
-static struct console dz_sercons = {
+static struct console dz_console = {
 	.name	= "ttyS",
 	.write	= dz_console_print,
 	.device	= uart_console_device,
@@ -755,7 +755,7 @@ static int __init dz_serial_console_init
 {
 	if (!IOASIC) {
 		dz_init_ports();
-		register_console(&dz_sercons);
+		register_console(&dz_console);
 		return 0;
 	} else
 		return -ENXIO;
@@ -763,7 +763,7 @@ static int __init dz_serial_console_init
 
 console_initcall(dz_serial_console_init);
 
-#define SERIAL_DZ_CONSOLE	&dz_sercons
+#define SERIAL_DZ_CONSOLE	&dz_console
 #else
 #define SERIAL_DZ_CONSOLE	NULL
 #endif /* CONFIG_SERIAL_DZ_CONSOLE */
