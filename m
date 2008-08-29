Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbYH2GYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbYH2GYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbYH2GQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:16:05 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59517 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbYH2GPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:15:33 -0400
Date: Thu, 28 Aug 2008 23:47:42 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808290547.m7T5lgjB016143@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc5 28/29] mdb: add Kconfig.debug sections and documentation 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add Kconfig.debug sections and documentation 

updated help sections for MAGIC_SYSRQ keyboard support.
Added X86 option restruction for X86 only features.


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/lib/Kconfig.debug	2008-08-28 14:19:32.000000000 -0600
+++ b/lib/Kconfig.debug	2008-08-28 14:20:04.000000000 -0600
@@ -134,6 +134,43 @@
 	  Say Y here if you are developing drivers or trying to debug and
 	  identify kernel problems.
 
+config MDB
+	tristate "Merkey's Kernel Debugger"
+	depends on DEBUG_KERNEL && X86
+	select MAGIC_SYSRQ
+	select KALLSYMS
+	select KALLSYMS_ALL
+	default m
+	help
+           Kernel Debugger for Linux written by Jeffrey Vernon
+           Merkey.  'echo j > /proc/sysrq-trigger' will activate the
+           debugger from the text based Linux Console, and the 'j'
+           character (alt-printscreen/sysrq + 'j') with MAGIC_SYSRQ
+           enabled to enter the debugger.  X is not supported.
+           This debugger is minimal and text based.  Excellent help can
+           be obtained from the debugger by typing "Help Help" or
+           "help" from the debugger command console.  If you compiled
+           MDB as a module you may need to load the debugger with
+           the 'modprobe mdb' before you can access the debugger
+           from the Linux Console.  To enable the MAGIC-SYSRQ key
+           type 'echo 1 > /proc/sys/kernel/sysrq'.
+
+config MDB_CONSOLE_REDIRECTION
+	bool "MDB Console Redirection Support"
+	depends on MDB
+	default y
+	help
+           Reset any Console Redirection to default system settings (0)
+           when the MDB debugger is active.  The Debugger will restore
+           the redirection to the custom settings when the debugger
+           is exited.  This feature is useful on systems which by default
+           redirect printk output and the screen debugger output to a log
+           file or system device, which can prevent the debugger screen from
+           being visible.  Enabling this feature does not affect or disable
+           remote operations via serial port.  It is recommended to enable
+           this feature by default if intensive debugging is intended for
+           the target system.
+
 config DEBUG_SHIRQ
 	bool "Debug shared IRQ handlers"
 	depends on DEBUG_KERNEL && GENERIC_HARDIRQS
