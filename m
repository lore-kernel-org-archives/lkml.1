Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbXJXK1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbXJXK1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 06:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXJXK1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 06:27:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:41532 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbXJXK07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 06:26:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=j5/vw9NUb1CuTzQfjV60EJ4S0NibvK5ZCxP7c+5I11aC2c7h95GbK98AX6vQ/Sty4+nh5ltUw0NBuP7I54e6z2g65gvbM1uDVWaBlCvG4IrSh7i42tOVLyqIdb/pk8PaGbADNdl8D073+ozkcai2rr15KME3vHsl1k67/BfeJqc=
Message-ID: <64de5c8b0710240326q709ca7fbq4b365bcaf6e89fb9@mail.gmail.com>
Date: Wed, 24 Oct 2007 15:56:58 +0530
From: "Rajkumar S" <rajkumars@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: HIGHMEM64G Kernel (2.6.23.1) makes system crawl
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am using a Core 2 Duo E6750 CPU on an intel DG33FB mother board with
4GB Ram, running Debian Lenny.

Since the box has 4 GB ram I compiled a big mem kernel, but the
machine is very slow while running big mem kernel. It takes about 37
minutes to compile the intel e1000 driver  (e1000-7.6.5.tar.gz) from
intel site. But it's performing normally when using a non big mem
kernel. The diff of the .config between working and non working is as
follows.

--- config-nobigmem     2007-10-24 12:51:42.000000000 +0530
+++ config-bigmem       2007-10-24 12:48:56.000000000 +0530
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.23.1
-# Wed Oct 24 12:50:21 2007
+# Tue Oct 23 18:08:30 2007
 #
 CONFIG_X86_32=y
 CONFIG_GENERIC_TIME=y
@@ -189,10 +189,11 @@
 CONFIG_DELL_RBU=m
 CONFIG_DCDBAS=m
 CONFIG_DMIID=y
-CONFIG_NOHIGHMEM=y
+# CONFIG_NOHIGHMEM is not set
 # CONFIG_HIGHMEM4G is not set
-# CONFIG_HIGHMEM64G is not set
+CONFIG_HIGHMEM64G=y
 CONFIG_PAGE_OFFSET=0xC0000000
+CONFIG_HIGHMEM=y
 CONFIG_X86_PAE=y
 CONFIG_ARCH_FLATMEM_ENABLE=y
 CONFIG_ARCH_SPARSEMEM_ENABLE=y
@@ -211,6 +212,7 @@
 CONFIG_BOUNCE=y
 CONFIG_NR_QUICK=1
 CONFIG_VIRT_TO_BUS=y
+# CONFIG_HIGHPTE is not set
 # CONFIG_MATH_EMULATION is not set
 CONFIG_MTRR=y
 CONFIG_EFI=y
@@ -223,11 +225,13 @@
 # CONFIG_HZ_1000 is not set
 CONFIG_HZ=250
 CONFIG_KEXEC=y
+# CONFIG_CRASH_DUMP is not set
 CONFIG_PHYSICAL_START=0x100000
 # CONFIG_RELOCATABLE is not set
 CONFIG_PHYSICAL_ALIGN=0x100000
 CONFIG_HOTPLUG_CPU=y
 CONFIG_COMPAT_VDSO=y
+CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

 #
 # Power management options (ACPI, APM)
@@ -1283,6 +1287,7 @@
 CONFIG_I2O=m
 CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
 CONFIG_I2O_EXT_ADAPTEC=y
+CONFIG_I2O_EXT_ADAPTEC_DMA64=y
 CONFIG_I2O_CONFIG=m
 CONFIG_I2O_CONFIG_OLD_IOCTL=y
 CONFIG_I2O_BUS=m
@@ -3323,6 +3328,7 @@
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 # CONFIG_DEBUG_KOBJECT is not set
+# CONFIG_DEBUG_HIGHMEM is not set
 CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set

I was having this same issue with debian kernel also (2.6.22-2-686),
ie stock kernel will work, but big mem is slow. Which is why I tried
latest kernel.

I am posting the full .config at http://pastebin.ca/747758 dmesg while
booting big mem kernel is at http://pastebin.ca/747766

raj
