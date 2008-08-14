Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbYHNGqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbYHNGqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYHNGij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:38:39 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38144 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbYHNGiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:38:03 -0400
Date: Thu, 14 Aug 2008 00:14:39 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808140614.m7E6EdN2006266@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 28/29] mdb: change mdb name to "Merkey's Linux Kernel Debugger"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change mdb name to "Merkey's Linux Kernel Debugger".  update description
to add very simple and minimal instructions on entering the debugger and
access to the internal help panels.


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/lib/Kconfig.debug	2008-08-13 14:22:32.000000000 -0600
+++ b/lib/Kconfig.debug	2008-08-13 11:56:03.000000000 -0600
@@ -134,6 +134,39 @@
 	  Say Y here if you are developing drivers or trying to debug and
 	  identify kernel problems.
 
+config MDB
+	tristate "Merkey's Kernel Debugger"
+	depends on DEBUG_KERNEL
+	select KALLSYMS
+	select KALLSYMS_ALL
+	default m
+	help
+           Kernel Debugger for Linux written by Jeffrey Vernon
+	    Merkey.  The [Pause/Break] keystroke will activate the debugger
+           from the text based Linux Console, X is not supported.  
+           This debugger is minimal and text based.  Excellent help can 
+           be obtained from the debugger by typing "Help Help" or 
+           "help" from the debugger command console.  If you compiled 
+           MDB as a module you may need to load the debugger with 
+           the 'modprobe mdb' before you can access the debugger 
+           from the Linux Console.  
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
