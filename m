Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbYJQPNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbYJQPNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbYJQPGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:06:14 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:54248 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbYJQPGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:06:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=Jz1KlpYBe96FCaYZt2SMzMJ2UbsQ64jRY9213+UBd6RUVJEiXQeenQwCvtoXqn0Hwt
         tV1qIE5RvN+rH2ryxVWlGl26d/lMwKAeHvYk4+DB/jr8Oq2xZvWe8KHJZUllYfL5EShp
         hQBkPJX7293gp2CRnUTPWZ+6wylbTyxTFquX4=
To: linux-kernel@vger.kernel.org
Subject: [patch 24/24] perfmon3:  Makefiles
From: eranian@googlemail.com
Date: Fri, 17 Oct 2008 08:06:09 -0700 (PDT)
Message-ID: <48f8a9e1.0aec660a.2af9.2714@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the makefiles for the perfmon generic
and x86 code.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o3/Makefile
===================================================================
--- o3.orig/Makefile	2008-10-16 10:22:30.000000000 +0200
+++ o3/Makefile	2008-10-16 11:23:20.000000000 +0200
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
+++ o3/perfmon/Makefile	2008-10-16 11:23:20.000000000 +0200
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
--- o3.orig/arch/x86/Kconfig	2008-10-16 10:22:30.000000000 +0200
+++ o3/arch/x86/Kconfig	2008-10-16 11:23:21.000000000 +0200
@@ -1378,6 +1378,8 @@
 
 	  If unsure, say Y.
 
+source "arch/x86/perfmon/Kconfig"
+
 endmenu
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
Index: o3/arch/x86/Makefile
===================================================================
--- o3.orig/arch/x86/Makefile	2008-10-16 10:22:30.000000000 +0200
+++ o3/arch/x86/Makefile	2008-10-16 11:23:21.000000000 +0200
@@ -150,6 +150,9 @@
 core-y += arch/x86/kernel/
 core-y += arch/x86/mm/
 
+# perfmon support
+core-$(CONFIG_PERFMON) += arch/x86/perfmon/
+
 # Remaining sub architecture files
 core-y += $(mcore-y)
 

-- 

