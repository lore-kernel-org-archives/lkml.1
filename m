Return-Path: <linux-kernel-owner+w=401wt.eu-S1763233AbZE0Hck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763233AbZE0Hck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762397AbZE0H1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:27:06 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46942 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761100AbZE0H1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:27:04 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 28/29] microblaze_mmu_v2: Kconfig update
Date: Wed, 27 May 2009 08:47:53 +0200
Message-Id: <1243406874-3917-29-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-28-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
 <1243406874-3917-3-git-send-email-monstr@monstr.eu>
 <1243406874-3917-4-git-send-email-monstr@monstr.eu>
 <1243406874-3917-5-git-send-email-monstr@monstr.eu>
 <1243406874-3917-6-git-send-email-monstr@monstr.eu>
 <1243406874-3917-7-git-send-email-monstr@monstr.eu>
 <1243406874-3917-8-git-send-email-monstr@monstr.eu>
 <1243406874-3917-9-git-send-email-monstr@monstr.eu>
 <1243406874-3917-10-git-send-email-monstr@monstr.eu>
 <1243406874-3917-11-git-send-email-monstr@monstr.eu>
 <1243406874-3917-12-git-send-email-monstr@monstr.eu>
 <1243406874-3917-13-git-send-email-monstr@monstr.eu>
 <1243406874-3917-14-git-send-email-monstr@monstr.eu>
 <1243406874-3917-15-git-send-email-monstr@monstr.eu>
 <1243406874-3917-16-git-send-email-monstr@monstr.eu>
 <1243406874-3917-17-git-send-email-monstr@monstr.eu>
 <1243406874-3917-18-git-send-email-monstr@monstr.eu>
 <1243406874-3917-19-git-send-email-monstr@monstr.eu>
 <1243406874-3917-20-git-send-email-monstr@monstr.eu>
 <1243406874-3917-21-git-send-email-monstr@monstr.eu>
 <1243406874-3917-22-git-send-email-monstr@monstr.eu>
 <1243406874-3917-23-git-send-email-monstr@monstr.eu>
 <1243406874-3917-24-git-send-email-monstr@monstr.eu>
 <1243406874-3917-25-git-send-email-monstr@monstr.eu>
 <1243406874-3917-26-git-send-email-monstr@monstr.eu>
 <1243406874-3917-27-git-send-email-monstr@monstr.eu>
 <1243406874-3917-28-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Kconfig |  112 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 109 insertions(+), 3 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index f8e0722..b50b845 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -54,11 +54,9 @@ config GENERIC_GPIO
 	def_bool y
 
 config PCI
-	depends on !MMU
 	def_bool n
 
 config NO_DMA
-	depends on !MMU
 	def_bool y
 
 source "init/Kconfig"
@@ -76,7 +74,8 @@ source "kernel/Kconfig.preempt"
 source "kernel/Kconfig.hz"
 
 config MMU
-	def_bool n
+	bool "MMU support"
+	default n
 
 config NO_MMU
 	bool
@@ -119,6 +118,113 @@ config PROC_DEVICETREE
 
 endmenu
 
+menu "Advanced setup"
+
+config ADVANCED_OPTIONS
+	bool "Prompt for advanced kernel configuration options"
+	depends on MMU
+	help
+	  This option will enable prompting for a variety of advanced kernel
+	  configuration options.  These options can cause the kernel to not
+	  work if they are set incorrectly, but can be used to optimize certain
+	  aspects of kernel memory management.
+
+	  Unless you know what you are doing, say N here.
+
+comment "Default settings for advanced configuration options are used"
+	depends on !ADVANCED_OPTIONS
+
+config HIGHMEM_START_BOOL
+	bool "Set high memory pool address"
+	depends on ADVANCED_OPTIONS && HIGHMEM
+	help
+	  This option allows you to set the base address of the kernel virtual
+	  area used to map high memory pages.  This can be useful in
+	  optimizing the layout of kernel virtual memory.
+
+	  Say N here unless you know what you are doing.
+
+config HIGHMEM_START
+	hex "Virtual start address of high memory pool" if HIGHMEM_START_BOOL
+	depends on MMU
+	default "0xfe000000"
+
+config LOWMEM_SIZE_BOOL
+	bool "Set maximum low memory"
+	depends on ADVANCED_OPTIONS
+	help
+	  This option allows you to set the maximum amount of memory which
+	  will be used as "low memory", that is, memory which the kernel can
+	  access directly, without having to set up a kernel virtual mapping.
+	  This can be useful in optimizing the layout of kernel virtual
+	  memory.
+
+	  Say N here unless you know what you are doing.
+
+config LOWMEM_SIZE
+	hex "Maximum low memory size (in bytes)" if LOWMEM_SIZE_BOOL
+	depends on MMU
+	default "0x30000000"
+
+config KERNEL_START_BOOL
+	bool "Set custom kernel base address"
+	depends on ADVANCED_OPTIONS
+	help
+	  This option allows you to set the kernel virtual address at which
+	  the kernel will map low memory (the kernel image will be linked at
+	  this address).  This can be useful in optimizing the virtual memory
+	  layout of the system.
+
+	  Say N here unless you know what you are doing.
+
+config KERNEL_START
+	hex "Virtual address of kernel base" if KERNEL_START_BOOL
+	default "0xc0000000" if MMU
+	default KERNEL_BASE_ADDR if !MMU
+
+config TASK_SIZE_BOOL
+	bool "Set custom user task size"
+	depends on ADVANCED_OPTIONS
+	help
+	  This option allows you to set the amount of virtual address space
+	  allocated to user tasks.  This can be useful in optimizing the
+	  virtual memory layout of the system.
+
+	  Say N here unless you know what you are doing.
+
+config TASK_SIZE
+	hex "Size of user task space" if TASK_SIZE_BOOL
+	depends on MMU
+	default "0x80000000"
+
+config CONSISTENT_START_BOOL
+	bool "Set custom consistent memory pool address"
+	depends on ADVANCED_OPTIONS && NOT_COHERENT_CACHE
+	help
+	  This option allows you to set the base virtual address
+	  of the the consistent memory pool.  This pool of virtual
+	  memory is used to make consistent memory allocations.
+
+config CONSISTENT_START
+	hex "Base virtual address of consistent memory pool" if CONSISTENT_START_BOOL
+	depends on MMU
+	default "0xff100000" if NOT_COHERENT_CACHE
+
+config CONSISTENT_SIZE_BOOL
+	bool "Set custom consistent memory pool size"
+	depends on ADVANCED_OPTIONS && NOT_COHERENT_CACHE
+	help
+	  This option allows you to set the size of the the
+	  consistent memory pool.  This pool of virtual memory
+	  is used to make consistent memory allocations.
+
+config CONSISTENT_SIZE
+	hex "Size of consistent memory pool" if CONSISTENT_SIZE_BOOL
+	depends on MMU
+	default "0x00200000" if NOT_COHERENT_CACHE
+
+endmenu
+
 source "mm/Kconfig"
 
 menu "Exectuable file formats"
-- 
1.5.5.1

