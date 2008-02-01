Return-Path: <linux-kernel-owner+w=401wt.eu-S933683AbYBAHqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683AbYBAHqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935144AbYBAHjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:39:22 -0500
Received: from rex.snapgear.com ([203.143.235.140]:48080 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934726AbYBAHjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:39:17 -0500
Date: Fri, 1 Feb 2008 17:37:56 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010737.m117bueB022713@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU 06/06]: modify Makefiles to support common coldfire directory
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify Makefiles to support separate coldfire platform directory.

Currently the common ColdFire CPU family code sits in the
arch/m68knommu/platform/5307 directory. This is confusing, the files
containing this common code are in no way specific to the 5307 ColdFire.
Create an arch/m68knommu/platform/coldfire directory to contain this
common code. Other m68knommu CPU varients do not need use this code
though, so it doesn't make sense to move it to arch/m68knommu/kernel.

Signed-off-by: Greg Ungerer <gerg@uclinux.org


diff -Naurp linux-2.6.24/arch/m68knommu/Makefile linux-2.6.24.1/arch/m68knommu/Makefile
--- linux-2.6.24/arch/m68knommu/Makefile	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24.1/arch/m68knommu/Makefile	2008-01-31 17:04:07.000000000 +1000
@@ -61,17 +61,17 @@ MODEL := $(model-y)
 # for the selected cpu. ONLY need to define this for the non-base member
 # of the family.
 #
-cpuclass-$(CONFIG_M5206)	:= 5307
-cpuclass-$(CONFIG_M5206e)	:= 5307
-cpuclass-$(CONFIG_M520x)	:= 5307
-cpuclass-$(CONFIG_M523x)	:= 5307
-cpuclass-$(CONFIG_M5249)	:= 5307
-cpuclass-$(CONFIG_M527x)	:= 5307
-cpuclass-$(CONFIG_M5272)	:= 5307
-cpuclass-$(CONFIG_M528x)	:= 5307
-cpuclass-$(CONFIG_M5307)	:= 5307
-cpuclass-$(CONFIG_M532x)	:= 5307
-cpuclass-$(CONFIG_M5407)	:= 5307
+cpuclass-$(CONFIG_M5206)	:= coldfire
+cpuclass-$(CONFIG_M5206e)	:= coldfire
+cpuclass-$(CONFIG_M520x)	:= coldfire
+cpuclass-$(CONFIG_M523x)	:= coldfire
+cpuclass-$(CONFIG_M5249)	:= coldfire
+cpuclass-$(CONFIG_M527x)	:= coldfire
+cpuclass-$(CONFIG_M5272)	:= coldfire
+cpuclass-$(CONFIG_M528x)	:= coldfire
+cpuclass-$(CONFIG_M5307)	:= coldfire
+cpuclass-$(CONFIG_M532x)	:= coldfire
+cpuclass-$(CONFIG_M5407)	:= coldfire
 cpuclass-$(CONFIG_M68328)	:= 68328
 cpuclass-$(CONFIG_M68EZ328)	:= 68328
 cpuclass-$(CONFIG_M68VZ328)	:= 68328
diff -Naurp linux-2.6.24/arch/m68knommu/platform/5307/Makefile linux-2.6.24.1/arch/m68knommu/platform/5307/Makefile
--- linux-2.6.24/arch/m68knommu/platform/5307/Makefile	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24.1/arch/m68knommu/platform/5307/Makefile	2008-01-31 16:35:54.000000000 +1000
@@ -16,17 +16,5 @@ ifdef CONFIG_FULLDEBUG
 EXTRA_AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
 endif
 
-obj-$(CONFIG_COLDFIRE)	+= entry.o vectors.o
-obj-$(CONFIG_M5206)	+= timers.o
-obj-$(CONFIG_M5206e)	+= timers.o
-obj-$(CONFIG_M520x)	+= pit.o
-obj-$(CONFIG_M523x)	+= pit.o
-obj-$(CONFIG_M5249)	+= timers.o
-obj-$(CONFIG_M527x)     += pit.o
-obj-$(CONFIG_M5272)	+= timers.o
-obj-$(CONFIG_M5307)	+= config.o timers.o
-obj-$(CONFIG_M532x)	+= timers.o
-obj-$(CONFIG_M528x)     += pit.o
-obj-$(CONFIG_M5407)	+= timers.o
+obj-y	+= config.o
 
-extra-y := head.o
diff -Naurp linux-2.6.24/arch/m68knommu/platform/coldfire/Makefile linux-2.6.24.1/arch/m68knommu/platform/coldfire/Makefile
--- linux-2.6.24/arch/m68knommu/platform/coldfire/Makefile	1970-01-01 10:00:00.000000000 +1000
+++ linux-2.6.24.1/arch/m68knommu/platform/coldfire/Makefile	2008-01-31 16:35:13.000000000 +1000
@@ -0,0 +1,32 @@
+#
+# Makefile for the m68knommu kernel.
+#
+
+#
+# If you want to play with the HW breakpoints then you will
+# need to add define this,  which will give you a stack backtrace
+# on the console port whenever a DBG interrupt occurs. You have to
+# set up you HW breakpoints to trigger a DBG interrupt:
+#
+# EXTRA_CFLAGS += -DTRAP_DBG_INTERRUPT
+# EXTRA_AFLAGS += -DTRAP_DBG_INTERRUPT
+#
+
+ifdef CONFIG_FULLDEBUG
+AFLAGS += -DDEBUGGER_COMPATIBLE_CACHE=1
+endif
+
+obj-$(CONFIG_COLDFIRE)	+= dma.o entry.o vectors.o
+obj-$(CONFIG_M5206)	+= timers.o
+obj-$(CONFIG_M5206e)	+= timers.o
+obj-$(CONFIG_M520x)	+= pit.o
+obj-$(CONFIG_M523x)	+= pit.o
+obj-$(CONFIG_M5249)	+= timers.o
+obj-$(CONFIG_M527x)	+= pit.o
+obj-$(CONFIG_M5272)	+= timers.o
+obj-$(CONFIG_M528x)	+= pit.o
+obj-$(CONFIG_M5307)	+= timers.o
+obj-$(CONFIG_M532x)	+= timers.o
+obj-$(CONFIG_M5407)	+= timers.o
+
+extra-y := head.o
