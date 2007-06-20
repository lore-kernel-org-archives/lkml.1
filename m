Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbXFTKYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbXFTKYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 06:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759008AbXFTKXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 06:23:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369AbXFTKXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 06:23:37 -0400
From: Andi Kleen <ak@suse.de>
References: <200706201223.443613000@suse.de>
In-Reply-To: <200706201223.443613000@suse.de>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH for 2.6.22] [7/10] x86: Disable KPROBES with DEBUG_RODATA for now
Message-Id: <20070620102335.ECB5914AD0@wotan.suse.de>
Date: Wed, 20 Jun 2007 12:23:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Right now Kprobes cannot write to the write protected kernel text when 
DEBUG_RODATA is enabled. Disallow this in Kconfig for now.

Temporary fix for 2.6.22. In .23 add code to temporarily
unprotect it.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/Kconfig.debug   |    1 +
 arch/x86_64/Kconfig.debug |    1 +
 2 files changed, 2 insertions(+)

Index: linux/arch/i386/Kconfig.debug
===================================================================
--- linux.orig/arch/i386/Kconfig.debug
+++ linux/arch/i386/Kconfig.debug
@@ -49,6 +49,7 @@ config DEBUG_PAGEALLOC
 config DEBUG_RODATA
 	bool "Write protect kernel read-only data structures"
 	depends on DEBUG_KERNEL
+	depends on !KPROBES # temporary for 2.6.22
 	help
 	  Mark the kernel read-only data as write-protected in the pagetables,
 	  in order to catch accidental (and incorrect) writes to such const
Index: linux/arch/x86_64/Kconfig.debug
===================================================================
--- linux.orig/arch/x86_64/Kconfig.debug
+++ linux/arch/x86_64/Kconfig.debug
@@ -9,6 +9,7 @@ source "lib/Kconfig.debug"
 config DEBUG_RODATA
        bool "Write protect kernel read-only data structures"
        depends on DEBUG_KERNEL
+       depends on !KPROBES # temporary for 2.6.22
        help
 	 Mark the kernel read-only data as write-protected in the pagetables,
 	 in order to catch accidental (and incorrect) writes to such const data.
