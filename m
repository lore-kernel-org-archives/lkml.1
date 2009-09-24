Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZIXOnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZIXOnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZIXOnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:43:12 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48240 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598AbZIXOnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:43:09 -0400
Message-Id: <20090924133359.423122076@polymtl.ca>
References: <20090924132626.485545323@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Sep 2009 09:26:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>, Adrian Bunk <bunk@stusta.de>,
       Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       akpm@osdl.org
Subject: [patch 03/12] Immediate Values - Kconfig menu in EMBEDDED
Content-Disposition: inline; filename=immediate-values-kconfig-menu-in-embedded.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 24 Sep 2009 14:07:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate values provide a way to use dynamic code patching to update variables
sitting within the instruction stream. It saves caches lines normally used by
static read mostly variables. Enable it by default, but let users disable it
through the EMBEDDED menu with the "Disable immediate values" submenu entry.

Note: Since I think that I really should let embedded systems developers using
RO memory the option to disable the immediate values, I choose to leave this
menu option there, in the EMBEDDED menu. Also, the "CONFIG_IMMEDIATE" makes
sense because we want to compile out all the immediate code when we decide not
to use optimized immediate values at all (it removes otherwise unused code).

Changelog:
- Change ARCH_SUPPORTS_IMMEDIATE for HAS_IMMEDIATE
- Turn DISABLE_IMMEDIATE into positive logic

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Christoph Hellwig <hch@infradead.org>
CC: mingo@elte.hu
CC: akpm@osdl.org
---
 init/Kconfig |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

Index: linux.trees.git/init/Kconfig
===================================================================
--- linux.trees.git.orig/init/Kconfig	2009-09-24 08:52:55.000000000 -0400
+++ linux.trees.git/init/Kconfig	2009-09-24 09:00:20.000000000 -0400
@@ -1088,6 +1088,24 @@ config SLOW_WORK
 
 	  See Documentation/slow-work.txt.
 
+config HAVE_IMMEDIATE
+	def_bool n
+
+config IMMEDIATE
+	default y
+	depends on HAVE_IMMEDIATE
+	bool "Immediate value optimization" if EMBEDDED
+	help
+	  Immediate values are used as read-mostly variables that are rarely
+	  updated. They use code patching to modify the values inscribed in the
+	  instruction stream. It provides a way to save precious cache lines
+	  that would otherwise have to be used by these variables. They can be
+	  disabled through the EMBEDDED menu.
+
+	  It consumes slightly more memory and modifies the instruction stream
+	  each time any specially-marked variable is updated. Should really be
+	  disabled for embedded systems with read-only text.
+
 endmenu		# General setup
 
 config HAVE_GENERIC_DMA_COHERENT

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
