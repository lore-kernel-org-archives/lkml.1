Return-Path: <linux-kernel-owner+w=401wt.eu-S1752027AbXBDEQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbXBDEQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 23:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXBDEQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 23:16:54 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:50366 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752036AbXBDEQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 23:16:53 -0500
Date: Sat, 3 Feb 2007 23:16:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ifdef missing in arch/mips/pmc-sierra/yosemite/setup.c
Message-ID: <20070204041651.GA8732@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 23:15:02 up 1 day, 18:23,  2 users,  load average: 1.18, 1.05, 1.01
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ifdef missing in arch/mips/pmc-sierra/yosemite/setup.c

early_serial_setup is only defined when CONFIG_SERIAL_8250 is set.
Applies on 2.6.20-rc7.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/mips/pmc-sierra/yosemite/setup.c
+++ b/arch/mips/pmc-sierra/yosemite/setup.c
@@ -171,6 +171,7 @@ static void __init py_map_ocd(void)
 
 static void __init py_uart_setup(void)
 {
+#ifdef CONFIG_SERIAL_8250
 	struct uart_port up;
 
 	/*
@@ -188,6 +189,7 @@ static void __init py_uart_setup(void)
 
 	if (early_serial_setup(&up))
 		printk(KERN_ERR "Early serial init of port 0 failed\n");
+#endif //CONFIG_SERIAL_8250
 }
 
 static void __init py_rtc_setup(void)
-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 
