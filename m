Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbXISFIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbXISFIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 01:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbXISFHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 01:07:53 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:42477 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbXISFHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 01:07:52 -0400
Date: Tue, 18 Sep 2007 22:05:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: kgdb-bugreport@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Cc: jason.wessel@windriver.com, akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] kgdb: fix help text
Message-Id: <20070918220533.36ce1107.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kgdb help text typos, grammar, config symbol names, and indentation.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 lib/Kconfig.kgdb |   42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

--- linux-2.6.23-rc6-mm1.orig/lib/Kconfig.kgdb
+++ linux-2.6.23-rc6-mm1/lib/Kconfig.kgdb
@@ -27,15 +27,15 @@ config KGDB_ARCH_HAS_SHADOW_INFO
 config KGDB_CONSOLE
 	bool "KGDB: Console messages through gdb"
 	depends on KGDB
-	  help
-	    If you say Y here, console messages will appear through gdb.
-	    Other consoles such as tty or ttyS will continue to work as usual.
-	    Note, that if you use this in conjunction with KGDB_ETH, if the
-	    ethernet driver runs into an error condition during use with KGDB
-	    it is possible to hit an infinite recusrion, causing the kernel
-	    to crash, and typically reboot.  For this reason, it is preferable
-	    to use NETCONSOLE in conjunction with KGDB_ETH instead of
-	    KGDB_CONSOLE.
+	help
+	  If you say Y here, console messages will appear through gdb.
+	  Other consoles such as tty or ttyS will continue to work as usual.
+	  Note that if you use this in conjunction with KGDBOE, if the
+	  ethernet driver runs into an error condition during use with KGDB,
+	  it is possible to hit an infinite recursion, causing the kernel
+	  to crash, and typically reboot.  For this reason, it is preferable
+	  to use NETCONSOLE in conjunction with KGDBOE instead of
+	  KGDB_CONSOLE.
 
 choice
 	prompt "Method for KGDB communication"
@@ -106,7 +106,7 @@ config KGDB_TXX9
 	bool "KGDB: On TX49xx serial port"
 	depends on MIPS && CPU_TX49XX
 	help
-	  Uses TX49xx serial port to communicate with the host KGDB.
+	  Uses TX49xx serial port to communicate with the host GDB.
 
 config KGDB_SH_SCI
 	bool "KGDB: On SH SCI(F) serial port"
@@ -251,20 +251,18 @@ config KGDB_8250_CONF_STRING
 	depends on KGDB_8250_NOMODULE && !KGDB_SIMPLE_SERIAL
 	default "io,2f8,115200,3" if X86
 	help
-	  The format of this string should be <io or
-	  mmio>,<address>,<baud rate>,<irq>.  For example, to use the
-	  serial port on an i386 box located at 0x2f8 and 115200 baud
-	  on IRQ 3 at use:
-	  io,2f8,115200,3
+	  The format of this string should be <io or mmio>,
+	  <address>,<baud rate>,<irq>.  For example, on an i386 box,
+	  to use the serial port located at 0x2f8, IRQ 3, at 115200 baud
+	  use:  io,2f8,115200,3
 
 config KGDB_ATTACH_WAIT
 	bool "KGDB: Wait for debugger to attach on an unknown exception"
 	default y if KGDB_8250_NOMODULE
 	default n if !KGDB_8250_NOMODULE
-	  help
-	    If a panic occurs, or any kind of exception the kgdb will
-	    stop and wait for a debugger to attach.  This sets the
-	    default behavior for waiting for the debugger to attach.  This
-	    value can also be changed at runtime through
-	    /sys/module/kgdb/paramaters/attachwait
-
+	help
+	  If a panic occurs, or any kind of exception, the kgdb will
+	  stop and wait for a debugger to attach.  This sets the
+	  default behavior for waiting for the debugger to attach.  This
+	  value can also be changed at runtime through
+	  /sys/module/kgdb/parameters/attachwait
