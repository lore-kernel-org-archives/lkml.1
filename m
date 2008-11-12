Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYKLWV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYKLWV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbYKLWVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:21:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59854 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbYKLWVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:21:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: Make NUMA on 32-bit depend on EXPERIMENTAL again
Date: Wed, 12 Nov 2008 23:26:14 +0100
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <20081109140726.GB1786@ucw.cz> <200811122257.50998.rjw@sisk.pl> <200811122322.36781.rjw@sisk.pl>
In-Reply-To: <200811122322.36781.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122326.16107.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: x86: Make NUMA on 32-bit depend on EXPERIMENTAL again

My previous patch to make CONFIG_NUMA on x86_32 depend on BROKEN
turned out to be unnecessary, after all, since the source of the
hibernation vs CONFIG_NUMA problem turned out to be the fact that
we didn't take the NUMA KVA remapping into account in the
hibernation code.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -957,7 +957,7 @@ config ARCH_PHYS_ADDR_T_64BIT
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
 	depends on SMP
+	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && EXPERIMENTAL)
-	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && BROKEN)
 	default n if X86_PC
 	default y if (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP)
 	help
