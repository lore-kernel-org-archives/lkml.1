Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYKZIuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYKZIuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYKZInJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:43:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:43331 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbYKZInE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:43:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:from:date:message-id;
        b=iXS5SBXzO4XWVAub9IoLTSVLy4XrfpSpgccD+JX7ciU8qfOI6FK7hDABjhUoobdjya
         xT7OOQ2SSJsUcJkN40t22i1Q7cE6n6k3oPqwHHck65UuDhNsBlUzTBG9CHLFhCW/QXxU
         VXiP9Y8L5QxunpeeE1ZTKJz3UBn26t+qu2YaY=
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: [patch 24/24] perfmon: Makefiles
From: eranian@googlemail.com
Date: Wed, 26 Nov 2008 00:43:02 -0800 (PST)
Message-ID: <492d0c16.07a0660a.19c5.fffff9fd@mx.google.com>
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

