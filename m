Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYKJUsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYKJUsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 15:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYKJUsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 15:48:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50235 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYKJUsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 15:48:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: Make NUMA on 32-bit depend on BROKEN
Date: Mon, 10 Nov 2008 21:52:47 +0100
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Pavel Machek <pavel@suse.cz>, Peter Zijlstra <peterz@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811102152.47901.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: x86: Make NUMA on 32-bit depend on BROKEN

While investigating the failure of hibernation on 32-bit x86 with
CONFIG_NUMA set, as described in this message
http://marc.info/?l=linux-kernel&m=122634118116226&w=4
I asked some people for help and I was told that it wasn't really
worth the effort, because CONFIG_NUMA was generally broken on 32-bit
x86 systems and it shouldn't be used in such configs.  For this
reason, make CONFIG_NUMA depend on BROKEN instead of EXPERIMENTAL on
x86-32.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
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
-	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && EXPERIMENTAL)
+	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && BROKEN)
 	default n if X86_PC
 	default y if (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP)
 	help
