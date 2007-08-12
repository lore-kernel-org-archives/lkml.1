Return-Path: <linux-kernel-owner+w=401wt.eu-S937093AbXHLPPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937093AbXHLPPB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936295AbXHLPJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:09:11 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47636 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936280AbXHLPJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:09:07 -0400
Message-Id: <20070812150814.802764862@polymtl.ca>
References: <20070812150702.769065566@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:07:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [patch 3/8] Immediate Values - Kconfig menu in EMBEDDED
Content-Disposition: inline; filename=immediate-values-kconfig-embedded.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:08:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate values provide a way to use dynamic code patching to update variables
sitting within the instruction stream. It saves caches lines normally used by
static read mostly variables. Enable it by default, but let users disable it
through the EMBEDDED menu with the "Disable immediate values" submenu entry.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>
---
 init/Kconfig |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: linux-2.6-lttng/init/Kconfig
===================================================================
--- linux-2.6-lttng.orig/init/Kconfig	2007-08-07 16:36:20.000000000 -0400
+++ linux-2.6-lttng/init/Kconfig	2007-08-07 16:44:26.000000000 -0400
@@ -411,6 +411,17 @@ config CC_OPTIMIZE_FOR_SIZE
 config SYSCTL
 	bool
 
+config IMMEDIATE
+	default y if !DISABLE_IMMEDIATE
+	depends on X86_32 || PPC || PPC64
+	bool
+	help
+	  Immediate values are used as read mostly variables that are rarely
+	  updated. They use code patching to modify the values inscribed in the
+	  instruction stream. It provides a way to save precious cache lines
+	  that would otherwise have to be used by these variables. Can be
+	  disabled through the EMBEDDED menu.
+
 menuconfig EMBEDDED
 	bool "Configure standard kernel features (for small systems)"
 	help
@@ -649,6 +660,16 @@ config PROC_KPAGEMAP
           information on page-level memory usage. Disabling this interface
           will reduce the size of the kernel by around 600 bytes.
 
+config DISABLE_IMMEDIATE
+	default y if EMBEDDED
+	bool "Disable immediate values" if EMBEDDED
+	depends on X86_32 || PPC || PPC64
+	help
+	  Disable code patching based immediate values for embedded systems. It
+	  consumes slightly more memory and requires to modify the instruction
+	  stream each time a variable is updated. Should really be disabled for
+	  embedded systems with read-only text.
+
 endmenu		# General setup
 
 config RT_MUTEXES

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
