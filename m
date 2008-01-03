Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbYACWGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbYACWGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 17:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYACWGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 17:06:12 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54979 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbYACWGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 17:06:11 -0500
Date: Thu, 3 Jan 2008 16:04:06 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: sam@ravnborg.org
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, wd@denx.de
Subject: [PATCH 2/3] Rework arch specific Makefiles to use mkubootimg
Message-ID: <20080103160406.7ef5ecfe@zod.rchland.ibm.com>
In-Reply-To: <20080103160104.171f9aaa@zod.rchland.ibm.com>
References: <20080103160104.171f9aaa@zod.rchland.ibm.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework the architecture specific Makefiles to use the in-kernel version of
the mkubootimg tool.

Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

---
 arch/arm/boot/Makefile          |    4 ++--
 arch/avr32/boot/images/Makefile |    4 ++--
 arch/blackfin/boot/Makefile     |    4 ++--
 arch/ppc/boot/images/Makefile   |    4 ++--
 arch/sh/boot/Makefile           |    4 ++--
 5 files changed, 10 insertions(+), 10 deletions(-)

--- linux-2.6.orig/arch/arm/boot/Makefile
+++ linux-2.6/arch/arm/boot/Makefile
@@ -11,7 +11,7 @@
 # Copyright (C) 1995-2002 Russell King
 #
 
-MKIMAGE         := $(srctree)/scripts/mkuboot.sh
+MKIMAGE         := $(srctree)/scripts/mkubootimg/mkubootimg
 
 ifneq ($(MACHINE),)
 include $(srctree)/$(MACHINE)/Makefile.boot
@@ -60,7 +60,7 @@ $(obj)/zImage:	$(obj)/compressed/vmlinux
 endif
 
 quiet_cmd_uimage = UIMAGE  $@
-      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A arm -O linux -T kernel \
+      cmd_uimage = $(MKIMAGE) -A arm -O linux -T kernel \
 		   -C none -a $(ZRELADDR) -e $(ZRELADDR) \
 		   -n 'Linux-$(KERNELRELEASE)' -d $< $@
 
--- linux-2.6.orig/arch/avr32/boot/images/Makefile
+++ linux-2.6/arch/avr32/boot/images/Makefile
@@ -6,7 +6,7 @@
 # for more details.
 #
 
-MKIMAGE		:= $(srctree)/scripts/mkuboot.sh
+MKIMAGE		:= $(srctree)/scripts/mkubootimg/mkubootimg
 
 extra-y		:= vmlinux.bin vmlinux.gz
 
@@ -18,7 +18,7 @@ $(obj)/vmlinux.gz: $(obj)/vmlinux.bin FO
 	$(call if_changed,gzip)
 
 quiet_cmd_uimage = UIMAGE $@
-      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A avr32 -O linux -T kernel	\
+      cmd_uimage = $(MKIMAGE) -A avr32 -O linux -T kernel	\
 		-C gzip -a $(CONFIG_LOAD_ADDRESS) -e $(CONFIG_ENTRY_ADDRESS)	\
 		-n 'Linux-$(KERNELRELEASE)' -d $< $@
 
--- linux-2.6.orig/arch/blackfin/boot/Makefile
+++ linux-2.6/arch/blackfin/boot/Makefile
@@ -6,13 +6,13 @@
 # for more details.
 #
 
-MKIMAGE := $(srctree)/scripts/mkuboot.sh
+MKIMAGE := $(srctree)/scripts/mkubootimg/mkubootimg
 
 targets := vmImage
 extra-y += vmlinux.bin vmlinux.gz
 
 quiet_cmd_uimage = UIMAGE  $@
-      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A $(ARCH) -O linux -T kernel \
+      cmd_uimage = $(MKIMAGE) -A $(ARCH) -O linux -T kernel \
                    -C gzip -n 'Linux-$(KERNELRELEASE)' -a $(CONFIG_BOOT_LOAD) \
                    -e $(shell $(NM) vmlinux | awk '$$NF == "__start" {print $$1}') \
                    -d $< $@
--- linux-2.6.orig/arch/ppc/boot/images/Makefile
+++ linux-2.6/arch/ppc/boot/images/Makefile
@@ -2,7 +2,7 @@
 # This dir holds all of the images for PPC machines.
 # Tom Rini	January 2001
 
-MKIMAGE		:= $(srctree)/scripts/mkuboot.sh
+MKIMAGE		:= $(srctree)/scripts/mkubootimg/mkubootimg
 
 extra-y		:= vmlinux.bin vmlinux.gz
 
@@ -19,7 +19,7 @@ $(obj)/vmlinux.gz: $(obj)/vmlinux.bin FO
 	$(call if_changed,mygzip)
 
 quiet_cmd_uimage = UIMAGE  $@
-      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A ppc -O linux -T kernel \
+      cmd_uimage = $(MKIMAGE) -A ppc -O linux -T kernel \
                -C gzip -a 00000000 -e 00000000 -n 'Linux-$(KERNELRELEASE)' \
                -d $< $@
 
--- linux-2.6.orig/arch/sh/boot/Makefile
+++ linux-2.6/arch/sh/boot/Makefile
@@ -8,7 +8,7 @@
 # Copyright (C) 1999 Stuart Menefy
 #
 
-MKIMAGE := $(srctree)/scripts/mkuboot.sh
+MKIMAGE := $(srctree)/scripts/mkubootimg/mkubootimg
 
 #
 # Assign safe dummy values if these variables are not defined,
@@ -38,7 +38,7 @@ KERNEL_LOAD	:= $(shell /bin/bash -c 'pri
 			$(CONFIG_ZERO_PAGE_OFFSET)+0x1000]')
 
 quiet_cmd_uimage = UIMAGE  $@
-      cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A sh -O linux -T kernel \
+      cmd_uimage = $(MKIMAGE) -A sh -O linux -T kernel \
 		   -C none -a $(KERNEL_LOAD) -e $(KERNEL_LOAD) \
 		   -n 'Linux-$(KERNELRELEASE)' -d $< $@
 
