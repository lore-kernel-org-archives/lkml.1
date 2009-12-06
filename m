Return-Path: <linux-kernel-owner+w=401wt.eu-S933792AbZLFONd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792AbZLFONd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 09:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933674AbZLFONJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 09:13:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59041 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933637AbZLFONG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 09:13:06 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20091206313.812075626@firstfloor.org>
In-Reply-To: <20091206313.812075626@firstfloor.org>
To: x86@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/3] x86: Remove CONFIG_GBPAGES option
Message-Id: <20091206141310.CB4C9B151F@basil.firstfloor.org>
Date: Sun,  6 Dec 2009 15:13:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Support for GB pages mapped direct memory has been around for quite
some time and has not caused any problems as far as I know.

So it's time to remove the CONFIG_GBPAGES option and always enable
it by default. The option only controlled the default anyways, no
code. gbpages can be still disabled at runtime.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/Kconfig   |    9 ---------
 arch/x86/mm/init.c |    6 +-----
 2 files changed, 1 insertion(+), 14 deletions(-)

Index: linux-2.6.32-ak/arch/x86/Kconfig
===================================================================
--- linux-2.6.32-ak.orig/arch/x86/Kconfig
+++ linux-2.6.32-ak/arch/x86/Kconfig
@@ -1110,15 +1110,6 @@ config X86_PAE
 config ARCH_PHYS_ADDR_T_64BIT
 	def_bool X86_64 || X86_PAE
 
-config DIRECT_GBPAGES
-	bool "Enable 1GB pages for kernel pagetables" if EMBEDDED
-	default y
-	depends on X86_64
-	---help---
-	  Allow the kernel linear mapping to use 1GB pages on CPUs that
-	  support it. This can improve the kernel's performance a tiny bit by
-	  reducing TLB pressure. If in doubt, say "Y".
-
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support"
Index: linux-2.6.32-ak/arch/x86/mm/init.c
===================================================================
--- linux-2.6.32-ak.orig/arch/x86/mm/init.c
+++ linux-2.6.32-ak/arch/x86/mm/init.c
@@ -22,11 +22,7 @@ unsigned long __meminitdata e820_table_t
 
 int after_bootmem;
 
-int direct_gbpages
-#ifdef CONFIG_DIRECT_GBPAGES
-				= 1
-#endif
-;
+int direct_gbpages = 1;
 
 static void __init find_early_table_space(unsigned long end, int use_pse,
 					  int use_gbpages)
