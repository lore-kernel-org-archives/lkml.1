Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZJXBFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZJXBFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZJXBFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:05:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:49437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbZJXBFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:05:08 -0400
Date: Sat, 24 Oct 2009 01:04:14 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       arjan@linux.intel.com, davej@redhat.com, arjan@infradead.org,
       cebbert@redhat.com, tglx@linutronix.de, mingo@elte.hu,
       sandeen@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, davej@redhat.com, arjan@infradead.org,
       cebbert@redhat.com, tglx@linutronix.de, sandeen@redhat.com,
       mingo@elte.hu
In-Reply-To: <20091023073101.3dce4ebb@infradead.org>
References: <20091023073101.3dce4ebb@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] x86: Remove STACKPROTECTOR_ALL
Message-ID: <tip-14a3f40aafacde1dfd6912327ae14df4baf10304@git.kernel.org>
Git-Commit-ID: 14a3f40aafacde1dfd6912327ae14df4baf10304
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14a3f40aafacde1dfd6912327ae14df4baf10304
Gitweb:     http://git.kernel.org/tip/14a3f40aafacde1dfd6912327ae14df4baf10304
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Fri, 23 Oct 2009 07:31:01 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Oct 2009 16:35:23 +0200

x86: Remove STACKPROTECTOR_ALL

STACKPROTECTOR_ALL has a really high overhead (runtime and stack
footprint) and is not really worth it protection wise (the
normal STACKPROTECTOR is in effect for all functions with
buffers already), so lets just remove the option entirely.

Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Eric Sandeen <sandeen@redhat.com>
LKML-Reference: <20091023073101.3dce4ebb@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
