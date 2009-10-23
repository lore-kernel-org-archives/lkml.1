Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbZJWO37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbZJWO37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZJWO37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:29:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:57116 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbZJWO36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:29:58 -0400
Date: Fri, 23 Oct 2009 07:31:01 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, esandeen@redhat.com,
       cebbert@redhat.com, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Eric Sandeen <sandeen@redhat.com>,
       Chuck Ebbert <cebbert@redhat.com>, mingo@elte.hu
Subject: Chuck Ebbert <cebbert@redhat.com>
Message-ID: <20091023073101.3dce4ebb@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 87296b9275e3561822e1322f9d9aa6c73424e672 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 23 Oct 2009 07:27:31 -0700
Subject: [PATCH] x86: remove STACKPROTECTOR_ALL

STACKPROTECTOR_ALL has a really high overhead (runtime and stack footprint)
and is not really worth it protection wise (the normal STACKPROTECTOR is
in effect for all functions with buffers already), so lets just remove
the option entirely.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/Kconfig  |    4 ----
 arch/x86/Makefile |    1 -
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 07e0114..72ace95 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1443,12 +1443,8 @@ config SECCOMP
 
 	  If unsure, say Y. Only embedded should say N here.
 
-config CC_STACKPROTECTOR_ALL
-	bool
-
 config CC_STACKPROTECTOR
 	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	select CC_STACKPROTECTOR_ALL
 	---help---
 	  This option turns on the -fstack-protector GCC feature. This
 	  feature puts, at the beginning of functions, a canary value on
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index a012ee8..d2d24c9 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -76,7 +76,6 @@ ifdef CONFIG_CC_STACKPROTECTOR
 	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
         ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(biarch)),y)
                 stackp-y := -fstack-protector
-                stackp-$(CONFIG_CC_STACKPROTECTOR_ALL) += -fstack-protector-all
                 KBUILD_CFLAGS += $(stackp-y)
         else
                 $(warning stack protector enabled but no compiler support)
-- 
1.6.2.5


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
