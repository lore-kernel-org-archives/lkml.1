Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZD0Jxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZD0Jxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbZD0Jsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:48:40 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60685 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754737AbZD0Jsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:48:39 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 02/30] microblaze_mmu_v1: Kconfig update
Date: Mon, 27 Apr 2009 10:31:51 +0200
Message-Id: <1240821139-7247-3-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1240821139-7247-2-git-send-email-monstr@monstr.eu>
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>
 <1240821139-7247-2-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Kconfig |  110 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 109 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 8cc312b..52fcad0 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -72,7 +72,8 @@ source "kernel/Kconfig.preempt"
 source "kernel/Kconfig.hz"
 
 config MMU
-	def_bool n
+	bool "MMU support"
+	default n
 
 config NO_MMU
 	bool
@@ -118,6 +119,113 @@ config PROC_DEVICETREE
 
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
+	depends on MMU
+	default "0xc0000000"
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

