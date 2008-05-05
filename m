Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbYEEP0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbYEEP0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759583AbYEEPZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:25:38 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:5128 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760072AbYEEPZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:25:36 -0400
Message-ID: <481F26C7.2090201@de.ibm.com>
Date: Mon, 05 May 2008 17:24:55 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ltp-list@lists.sourceforge.net, ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 6/6] gcov: architecture specific compile flag adjustments
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Exclude code from profiling which is not linked to the main kernel or
which is running in a context not compatible with the assumptions made
by gcc's profiling code.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 arch/arm/boot/compressed/Makefile      |    1 +
 arch/ppc/boot/Makefile                 |    1 +
 arch/ppc/boot/common/Makefile          |    1 +
 arch/ppc/boot/simple/Makefile          |    1 +
 arch/x86/boot/Makefile                 |    1 +
 arch/x86/boot/compressed/Makefile      |    1 +
 arch/x86/kernel/acpi/realmode/Makefile |    1 +
 7 files changed, 7 insertions(+)

Index: linux-2.6.26-rc1/arch/arm/boot/compressed/Makefile
===================================================================
--- linux-2.6.26-rc1.orig/arch/arm/boot/compressed/Makefile
+++ linux-2.6.26-rc1/arch/arm/boot/compressed/Makefile
@@ -7,6 +7,7 @@
 HEAD	= head.o
 OBJS	= misc.o
 FONTC	= $(srctree)/drivers/video/console/font_acorn_8x8.c
+GCOV	:= n
 
 #
 # Architecture dependencies
Index: linux-2.6.26-rc1/arch/x86/boot/compressed/Makefile
===================================================================
--- linux-2.6.26-rc1.orig/arch/x86/boot/compressed/Makefile
+++ linux-2.6.26-rc1/arch/x86/boot/compressed/Makefile
@@ -12,6 +12,7 @@ cflags-$(CONFIG_X86_64) := -mcmodel=smal
 KBUILD_CFLAGS += $(cflags-y)
 KBUILD_CFLAGS += $(call cc-option,-ffreestanding)
 KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
+GCOV := n
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 
Index: linux-2.6.26-rc1/arch/ppc/boot/Makefile
===================================================================
--- linux-2.6.26-rc1.orig/arch/ppc/boot/Makefile
+++ linux-2.6.26-rc1/arch/ppc/boot/Makefile
@@ -16,6 +16,7 @@
 # KBUILD_CFLAGS used when building rest of boot (takes effect recursively)
 KBUILD_CFLAGS 	+= -fno-builtin -D__BOOTER__ -Iarch/$(ARCH)/boot/include
 HOSTCFLAGS	+= -Iarch/$(ARCH)/boot/include
+GCOV		:= n
 
 BOOT_TARGETS	= zImage zImage.initrd znetboot znetboot.initrd
 
Index: linux-2.6.26-rc1/arch/ppc/boot/common/Makefile
===================================================================
--- linux-2.6.26-rc1.orig/arch/ppc/boot/common/Makefile
+++ linux-2.6.26-rc1/arch/ppc/boot/common/Makefile
@@ -5,6 +5,7 @@
 # Tom Rini	January 2001
 #
 
+GCOV := n
 lib-y					:= string.o util.o misc-common.o \
 						serial_stub.o bootinfo.o
 lib-$(CONFIG_SERIAL_8250_CONSOLE)	+= ns16550.o
Index: linux-2.6.26-rc1/arch/ppc/boot/simple/Makefile
===================================================================
--- linux-2.6.26-rc1.orig/arch/ppc/boot/simple/Makefile
+++ linux-2.6.26-rc1/arch/ppc/boot/simple/Makefile
@@ -21,6 +21,7 @@
 # XXX_memory.o file for this to work, as well as editing the
 # misc-$(CONFIG_MACHINE) variable.
 
+GCOV				:= n
 boot				:= arch/ppc/boot
 common				:= $(boot)/common
 utils				:= $(boot)/utils
Index: linux-2.6.26-rc1/arch/x86/boot/Makefile
===================================================================
--- linux-2.6.26-rc1.orig/arch/x86/boot/Makefile
+++ linux-2.6.26-rc1/arch/x86/boot/Makefile
@@ -71,6 +71,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os 
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 KBUILD_CFLAGS +=   $(call cc-option,-m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV		:= n
 
 $(obj)/zImage:  IMAGE_OFFSET := 0x1000
 $(obj)/zImage:  asflags-y := $(SVGA_MODE) $(RAMDISK)
Index: linux-2.6.26-rc1/arch/x86/kernel/acpi/realmode/Makefile
===================================================================
--- linux-2.6.26-rc1.orig/arch/x86/kernel/acpi/realmode/Makefile
+++ linux-2.6.26-rc1/arch/x86/kernel/acpi/realmode/Makefile
@@ -41,6 +41,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os 
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 KBUILD_CFLAGS	+= $(call cc-option, -m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV		:= n
 
 WAKEUP_OBJS = $(addprefix $(obj)/,$(wakeup-y))
 


