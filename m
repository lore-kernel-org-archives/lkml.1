Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbZJBUdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbZJBUdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbZJBUdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:33:50 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55301 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758145AbZJBUdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 16:33:49 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v4 1/2] arm: convert to use __HEAD and HEAD_TEXT macros.
Date: Fri,  2 Oct 2009 16:32:46 -0400
Message-Id: <1254515567-27110-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <alpine.DEB.1.10.0910021536510.19358@dr-wily.mit.edu>
References: <alpine.DEB.1.10.0910021536510.19358@dr-wily.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the consequence of changing the section name used for head
code from ".text.head" to ".head.text".  Since this commit changes all
users in the architecture, this change should be harmless.

The .text.head output section is eliminated and the head text code is
included at the start of the .init output section.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/arm/kernel/head-nommu.S  |    2 +-
 arch/arm/kernel/head.S        |    2 +-
 arch/arm/kernel/vmlinux.lds.S |    8 +++-----
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
index e5dfc28..573b803 100644
--- a/arch/arm/kernel/head-nommu.S
+++ b/arch/arm/kernel/head-nommu.S
@@ -32,7 +32,7 @@
  * numbers for r1.
  *
  */
-	.section ".text.head", "ax"
+	__HEAD
 ENTRY(stext)
 	setmode	PSR_F_BIT | PSR_I_BIT | SVC_MODE, r9 @ ensure svc mode
 						@ and irqs disabled
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 38ccbe1..eb62bf9 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -74,7 +74,7 @@
  * crap here - that's what the boot loader (or in extreme, well justified
  * circumstances, zImage) is for.
  */
-	.section ".text.head", "ax"
+	__HEAD
 ENTRY(stext)
 	setmode	PSR_F_BIT | PSR_I_BIT | SVC_MODE, r9 @ ensure svc mode
 						@ and irqs disabled
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index aecf87d..0902f80 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -24,13 +24,11 @@ SECTIONS
 #else
 	. = PAGE_OFFSET + TEXT_OFFSET;
 #endif
-	.text.head : {
-		_stext = .;
-		_sinittext = .;
-		*(.text.head)
-	}
 
 	.init : {			/* Init code and data		*/
+		_stext = .;
+		_sinittext = .;
+			HEAD_TEXT
 			INIT_TEXT
 		_einittext = .;
 		__proc_info_begin = .;
-- 
1.6.4.3

