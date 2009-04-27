Return-Path: <linux-kernel-owner+w=401wt.eu-S1759055AbZD0SHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbZD0SHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758939AbZD0SHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:07:24 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63143 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758906AbZD0SHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:07:22 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3/8] arm: Use __INIT macro instead of .text.init.
Date: Mon, 27 Apr 2009 14:02:22 -0400
Message-Id: <1240855347-19316-4-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240855347-19316-3-git-send-email-tabbott@mit.edu>
References: <1240855347-19316-1-git-send-email-tabbott@mit.edu>
 <1240855347-19316-2-git-send-email-tabbott@mit.edu>
 <1240855347-19316-3-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arm is placing some code in the .text.init section, but it does not
reference that section in its linker scripts.

This change moves this code from the .text.init section to the
.init.text section, which is presumably where it belongs.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/mm/proc-v6.S |    3 ++-
 arch/arm/mm/proc-v7.S |    3 ++-
 arch/arm/mm/tlb-v6.S  |    3 ++-
 arch/arm/mm/tlb-v7.S  |    3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/proc-v6.S b/arch/arm/mm/proc-v6.S
index f0cc599..087e239 100644
--- a/arch/arm/mm/proc-v6.S
+++ b/arch/arm/mm/proc-v6.S
@@ -10,6 +10,7 @@
  *
  *  This is the "shell" of the ARMv6 processor support.
  */
+#include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
@@ -132,7 +133,7 @@ cpu_v6_name:
 	.asciz	"ARMv6-compatible processor"
 	.align
 
-	.section ".text.init", #alloc, #execinstr
+	__INIT
 
 /*
  *	__v6_setup
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index d1ebec4..c221e26 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -9,6 +9,7 @@
  *
  *  This is the "shell" of the ARMv7 processor support.
  */
+#include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
@@ -153,7 +154,7 @@ cpu_v7_name:
 	.ascii	"ARMv7 Processor"
 	.align
 
-	.section ".text.init", #alloc, #execinstr
+	__INIT
 
 /*
  *	__v7_setup
diff --git a/arch/arm/mm/tlb-v6.S b/arch/arm/mm/tlb-v6.S
index 20f84bb..73d7d89 100644
--- a/arch/arm/mm/tlb-v6.S
+++ b/arch/arm/mm/tlb-v6.S
@@ -10,6 +10,7 @@
  *  ARM architecture version 6 TLB handling functions.
  *  These assume a split I/D TLB.
  */
+#include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
 #include <asm/page.h>
@@ -87,7 +88,7 @@ ENTRY(v6wbi_flush_kern_tlb_range)
 	mcr	p15, 0, r2, c7, c5, 4		@ prefetch flush
 	mov	pc, lr
 
-	.section ".text.init", #alloc, #execinstr
+	__INIT
 
 	.type	v6wbi_tlb_fns, #object
 ENTRY(v6wbi_tlb_fns)
diff --git a/arch/arm/mm/tlb-v7.S b/arch/arm/mm/tlb-v7.S
index 24ba510..b637e73 100644
--- a/arch/arm/mm/tlb-v7.S
+++ b/arch/arm/mm/tlb-v7.S
@@ -11,6 +11,7 @@
  *  ARM architecture version 6 TLB handling functions.
  *  These assume a split I/D TLB.
  */
+#include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
 #include <asm/page.h>
@@ -80,7 +81,7 @@ ENTRY(v7wbi_flush_kern_tlb_range)
 	mov	pc, lr
 ENDPROC(v7wbi_flush_kern_tlb_range)
 
-	.section ".text.init", #alloc, #execinstr
+	__INIT
 
 	.type	v7wbi_tlb_fns, #object
 ENTRY(v7wbi_tlb_fns)
-- 
1.6.2.1

