Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbXHULs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbXHULs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 07:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbXHULss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 07:48:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbXHULsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 07:48:47 -0400
Date: Tue, 21 Aug 2007 14:42:40 +0200
From: Andi Kleen <ak@suse.de>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: [PATCH for 2.6.23] i386: Mark NUMA support experimental
Message-ID: <20070821124240.GJ32640@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I did some testing and found quite a lot of problems (doesn't
boot at all on non NUMA and misassigns cores on Opteron systems).

Mark it as experimental and warn against its use for now.

It's still default y for SUMMIT/NUMAQ because it'll presumably
work on these systems.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/Kconfig |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux/arch/i386/Kconfig
===================================================================
--- linux.orig/arch/i386/Kconfig
+++ linux/arch/i386/Kconfig
@@ -614,10 +614,14 @@ config X86_PAE
 
 # Common NUMA Features
 config NUMA
-	bool "Numa Memory Allocation and Scheduler Support"
-	depends on SMP && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI)
+	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
+	depends on SMP && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL
 	default n if X86_PC
 	default y if (X86_NUMAQ || X86_SUMMIT)
+	help
+	  NUMA support for i386. This is currently high experimental
+	  and should be only used for kernel development. It might also
+	  cause boot failures.
 
 comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
 	depends on X86_SUMMIT && (!HIGHMEM64G || !ACPI)
