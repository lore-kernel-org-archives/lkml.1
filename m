Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbYFBNe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbYFBNe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYFBNev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:34:51 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:13203 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbYFBNeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:34:50 -0400
Message-ID: <4843F6F7.9020000@de.ibm.com>
Date: Mon, 02 Jun 2008 15:34:47 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: [PATCH 6/6] gcov: architecture specific compile flag adjustments
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
 arch/powerpc/kernel/vdso32/Makefile    |    1 +
 arch/powerpc/kernel/vdso64/Makefile    |    1 +
 arch/ppc/boot/Makefile                 |    1 +
 arch/ppc/boot/common/Makefile          |    1 +
 arch/ppc/boot/simple/Makefile          |    1 +
 arch/x86/boot/Makefile                 |    1 +
 arch/x86/boot/compressed/Makefile      |    1 +
 arch/x86/kernel/acpi/realmode/Makefile |    1 +
 9 files changed, 9 insertions(+)

Index: linux-2.6.26-rc4/arch/arm/boot/compressed/Makefile
===================================================================
--- linux-2.6.26-rc4.orig/arch/arm/boot/compressed/Makefile
+++ linux-2.6.26-rc4/arch/arm/boot/compressed/Makefile
@@ -7,6 +7,7 @@
 HEAD	= head.o
 OBJS	= misc.o
 FONTC	= $(srctree)/drivers/video/console/font_acorn_8x8.c
+GCOV	:= n
 
 #
 # Architecture dependencies
Index: linux-2.6.26-rc4/arch/x86/boot/compressed/Makefile
===================================================================
--- linux-2.6.26-rc4.orig/arch/x86/boot/compressed/Makefile
+++ linux-2.6.26-rc4/arch/x86/boot/compressed/Makefile
@@ -12,6 +12,7 @@ cflags-$(CONFIG_X86_64) := -mcmodel=smal
 KBUILD_CFLAGS += $(cflags-y)
 KBUILD_CFLAGS += $(call cc-option,-ffreestanding)
 KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
+GCOV := n
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 
Index: linux-2.6.26-rc4/arch/ppc/boot/Makefile
===================================================================
--- linux-2.6.26-rc4.orig/arch/ppc/boot/Makefile
+++ linux-2.6.26-rc4/arch/ppc/boot/Makefile
@@ -16,6 +16,7 @@
 # KBUILD_CFLAGS used when building rest of boot (takes effect recursively)
 KBUILD_CFLAGS 	+= -fno-builtin -D__BOOTER__ -Iarch/$(ARCH)/boot/include
 HOSTCFLAGS	+= -Iarch/$(ARCH)/boot/include
+GCOV		:= n
 
 BOOT_TARGETS	= zImage zImage.initrd znetboot znetboot.initrd
 
Index: linux-2.6.26-rc4/arch/ppc/boot/common/Makefile
===================================================================
--- linux-2.6.26-rc4.orig/arch/ppc/boot/common/Makefile
+++ linux-2.6.26-rc4/arch/ppc/boot/common/Makefile
@@ -5,6 +5,7 @@
 # Tom Rini	January 2001
 #
 
+GCOV := n
 lib-y					:= string.o util.o misc-common.o \
 						serial_stub.o bootinfo.o
 lib-$(CONFIG_SERIAL_8250_CONSOLE)	+= ns16550.o
Index: linux-2.6.26-rc4/arch/ppc/boot/simple/Makefile
===================================================================
--- linux-2.6.26-rc4.orig/arch/ppc/boot/simple/Makefile
+++ linux-2.6.26-rc4/arch/ppc/boot/simple/Makefile
@@ -21,6 +21,7 @@
 # XXX_memory.o file for this to work, as well as editing the
 # misc-$(CONFIG_MACHINE) variable.
 
+GCOV				:= n
 boot				:= arch/ppc/boot
 common				:= $(boot)/common
 utils				:= $(boot)/utils
Index: linux-2.6.26-rc4/arch/x86/boot/Makefile
===================================================================
--- linux-2.6.26-rc4.orig/arch/x86/boot/Makefile
+++ linux-2.6.26-rc4/arch/x86/boot/Makefile
@@ -71,6 +71,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os 
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 KBUILD_CFLAGS +=   $(call cc-option,-m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV		:= n
 
 $(obj)/zImage:  IMAGE_OFFSET := 0x1000
 $(obj)/zImage:  asflags-y := $(SVGA_MODE) $(RAMDISK)
Index: linux-2.6.26-rc4/arch/x86/kernel/acpi/realmode/Makefile
===================================================================
--- linux-2.6.26-rc4.orig/arch/x86/kernel/acpi/realmode/Makefile
+++ linux-2.6.26-rc4/arch/x86/kernel/acpi/realmode/Makefile
@@ -42,6 +42,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os 
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 KBUILD_CFLAGS	+= $(call cc-option, -m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV		:= n
 
 WAKEUP_OBJS = $(addprefix $(obj)/,$(wakeup-y))
 
Index: linux-2.6.26-rc4/arch/powerpc/kernel/vdso32/Makefile
===================================================================
--- linux-2.6.26-rc4.orig/arch/powerpc/kernel/vdso32/Makefile
+++ linux-2.6.26-rc4/arch/powerpc/kernel/vdso32/Makefile
@@ -17,6 +17,7 @@ EXTRA_CFLAGS := -shared -fno-common -fno
 EXTRA_CFLAGS += -nostdlib -Wl,-soname=linux-vdso32.so.1 \
 		$(call ld-option, -Wl$(comma)--hash-style=sysv)
 EXTRA_AFLAGS := -D__VDSO32__ -s
+GCOV := n
 
 obj-y += vdso32_wrapper.o
 extra-y += vdso32.lds
Index: linux-2.6.26-rc4/arch/powerpc/kernel/vdso64/Makefile
===================================================================
--- linux-2.6.26-rc4.orig/arch/powerpc/kernel/vdso64/Makefile
+++ linux-2.6.26-rc4/arch/powerpc/kernel/vdso64/Makefile
@@ -11,6 +11,7 @@ EXTRA_CFLAGS := -shared -fno-common -fno
 EXTRA_CFLAGS += -nostdlib -Wl,-soname=linux-vdso64.so.1 \
 		$(call ld-option, -Wl$(comma)--hash-style=sysv)
 EXTRA_AFLAGS := -D__VDSO64__ -s
+GCOV := n
 
 obj-y += vdso64_wrapper.o
 extra-y += vdso64.lds



