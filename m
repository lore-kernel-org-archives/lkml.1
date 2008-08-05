Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbYHEHJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbYHEHJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758813AbYHEGrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:47:55 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:44149 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457AbYHEGrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:47:31 -0400
Date: Tue, 5 Aug 2008 00:26:37 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808050626.m756QbIv003785@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc1-git5 25/26] mdb: add Kconfig.debug sections
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centralized external definitions into include files and corrected 
the file to conform to Linux coding practices.  fixed word wrap
problems with patches.

add the sections to configure and enable the debugger

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/lib/Kconfig.debug	2008-08-04 15:53:44.000000000 -0600
+++ b/lib/Kconfig.debug	2008-08-04 15:49:51.000000000 -0600
@@ -134,6 +134,31 @@
 	  Say Y here if you are developing drivers or trying to debug and
 	  identify kernel problems.
 
+config MDB
+	bool "Merkey's Kernel Debugger"
+	depends on DEBUG_KERNEL
+	select KALLSYMS
+	select KALLSYMS_ALL
+	help
+           NetWare style kernel debugger for Linux written by Jeffrey Vernon 
+	   Merkey.
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
