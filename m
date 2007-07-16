Return-Path: <linux-kernel-owner+w=401wt.eu-S1764311AbXGPAeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764311AbXGPAeW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757975AbXGPAeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:34:13 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:55317 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757755AbXGPAeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:34:12 -0400
Date: Sun, 15 Jul 2007 20:34:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] Immediate Value - Kconfig menu in EMBEDDED
Message-ID: <20070716003410.GB26411@Krystal>
References: <20070714012439.285079881@polymtl.ca> <20070714012623.839969254@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714012623.839969254@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:32:36 up 8 days, 14:37,  3 users,  load average: 0.19, 0.28, 0.29
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate Values - Kconfig menu in EMBEDDED

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
--- linux-2.6-lttng.orig/init/Kconfig	2007-07-15 20:09:53.000000000 -0400
+++ linux-2.6-lttng/init/Kconfig	2007-07-15 20:23:16.000000000 -0400
@@ -410,6 +410,17 @@ config CC_OPTIMIZE_FOR_SIZE
 config SYSCTL
 	bool
 
+config IMMEDIATE
+	default y if !DISABLE_IMMEDIATE
+	depends on X86_32 || PPC
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
@@ -672,6 +683,16 @@ config PROC_KPAGEMAP
           information on page-level memory usage. Disabling this interface
           will reduce the size of the kernel for small machines.
 
+config DISABLE_IMMEDIATE
+	default y if EMBEDDED
+	bool "Disable immediate values" if EMBEDDED
+	depends on X86_32 || PPC
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
