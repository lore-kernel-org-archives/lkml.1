Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbXEFXtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbXEFXtl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 19:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbXEFXtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 19:49:24 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1673 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbXEFXtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 19:49:18 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Date: Sun, 06 May 2007 16:49:15 -0700
Subject: [patch 4/4] KMON - kmon build infrastrcuture ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.27461.1178495357.4>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adds the kmon interface to the build infrastrcuture.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


Index: linux-2.6.21.scdev/init/Kconfig
===================================================================
--- linux-2.6.21.scdev.orig/init/Kconfig	2007-05-05 18:11:26.000000000 -0700
+++ linux-2.6.21.scdev/init/Kconfig	2007-05-06 14:10:22.000000000 -0700
@@ -492,6 +492,12 @@
 	  on EMBEDDED systems.  /proc/vmstat will only show page counts
 	  if VM event counters are disabled.
 
+config KMON
+	default n
+	bool "Enable Kernel Monitor interface"
+	help
+	  Enable the kernel monitor interface through the /dev/kmon device.
+
 endmenu		# General setup
 
 config RT_MUTEXES
Index: linux-2.6.21.scdev/drivers/char/Makefile
===================================================================
--- linux-2.6.21.scdev.orig/drivers/char/Makefile	2007-05-05 18:11:26.000000000 -0700
+++ linux-2.6.21.scdev/drivers/char/Makefile	2007-05-06 14:10:22.000000000 -0700
@@ -56,6 +56,7 @@
 obj-$(CONFIG_HVCS)		+= hvcs.o
 obj-$(CONFIG_SGI_MBCS)		+= mbcs.o
 obj-$(CONFIG_BRIQ_PANEL)	+= briq_panel.o
+obj-$(CONFIG_KMON)		+= kmon-dev.o
 
 obj-$(CONFIG_PRINTER)		+= lp.o
 obj-$(CONFIG_TIPAR)		+= tipar.o
Index: linux-2.6.21.scdev/kernel/Makefile
===================================================================
--- linux-2.6.21.scdev.orig/kernel/Makefile	2007-05-05 18:11:26.000000000 -0700
+++ linux-2.6.21.scdev/kernel/Makefile	2007-05-06 14:10:22.000000000 -0700
@@ -51,6 +51,7 @@
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
+obj-$(CONFIG_KMON) += kmon.o kmon-stats.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
Index: linux-2.6.21.scdev/include/linux/Kbuild
===================================================================
--- linux-2.6.21.scdev.orig/include/linux/Kbuild	2007-05-05 18:11:26.000000000 -0700
+++ linux-2.6.21.scdev/include/linux/Kbuild	2007-05-06 14:10:22.000000000 -0700
@@ -246,6 +246,7 @@
 unifdef-y += kernelcapi.h
 unifdef-y += kernel.h
 unifdef-y += keyboard.h
+unifdef-y += kmon.h
 unifdef-y += llc.h
 unifdef-y += loop.h
 unifdef-y += lp.h

