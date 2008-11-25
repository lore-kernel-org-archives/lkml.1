Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbYKYVov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbYKYVov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbYKYVg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:36:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:48603 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbYKYVg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:36:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=ijCdaWD0WE+G/RY/eQmGt8LVru5rHlvmUL6sWQmQjYgSMFHZArWHudxQmDklVPievE
         ioNND73VnFMqUxnnsu/r4bwxtYhlHlBqEmDIzwBWYvzuu9KbZpv3/JYG09nkCIY7/z4c
         M3uXK8Bmomzbss2lcCF5iWHWswXvYMRfHi2oU=
To: linux-kernel@vger.kernel.org
Subject: [patch 24/24] perfmon: Makefiles
From: eranian@googlemail.com
Date: Tue, 25 Nov 2008 13:36:46 -0800 (PST)
Message-ID: <492c6fee.0b38560a.4ae6.0d16@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the makefiles for the perfmon generic
and x86 code.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/Makefile
===================================================================
--- o3.orig/Makefile	2008-11-25 18:09:47.000000000 +0100
+++ o3/Makefile	2008-11-25 18:15:34.000000000 +0100
@@ -621,6 +621,8 @@
 ifeq ($(KBUILD_EXTMOD),)
 core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
 
+core-$(CONFIG_PERFMON) += perfmon/
+
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
 		     $(net-y) $(net-m) $(libs-y) $(libs-m)))
Index: o3/perfmon/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ o3/perfmon/Makefile	2008-11-25 18:15:34.000000000 +0100
@@ -0,0 +1,10 @@
+#
+# Copyright (c) 2005-2006 Hewlett-Packard Development Company, L.P.
+# Contributed by Stephane Eranian <eranian@gmail.com>
+#
+obj-y =	perfmon_ctx.o perfmon_file.o      \
+	perfmon_attach.o perfmon_res.o    \
+	perfmon_init.o perfmon_activate.o \
+	perfmon_intr.o perfmon_rw.o	  \
+	perfmon_ctxsw.o perfmon_pmu.o	  \
+	perfmon_syscalls.o perfmon_sysfs.o
Index: o3/arch/x86/Kconfig
===================================================================
--- o3.orig/arch/x86/Kconfig	2008-11-25 18:09:47.000000000 +0100
+++ o3/arch/x86/Kconfig	2008-11-25 18:15:34.000000000 +0100
@@ -1487,6 +1487,8 @@
 	  This is used to work around broken boot loaders.  This should
 	  be set to 'N' under normal conditions.
 
+source "arch/x86/perfmon/Kconfig"
+
 endmenu
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
Index: o3/arch/x86/Makefile
===================================================================
--- o3.orig/arch/x86/Makefile	2008-11-25 18:09:47.000000000 +0100
+++ o3/arch/x86/Makefile	2008-11-25 18:15:34.000000000 +0100
@@ -150,6 +150,9 @@
 core-y += arch/x86/kernel/
 core-y += arch/x86/mm/
 
+# perfmon support
+core-$(CONFIG_PERFMON) += arch/x86/perfmon/
+
 # Remaining sub architecture files
 core-y += $(mcore-y)
 

-- 

