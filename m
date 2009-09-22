Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbZIVO0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbZIVO0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbZIVO0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:26:13 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58176 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756443AbZIVOZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:25:59 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH 06/13] m32r: Move the spi_stack_top and spu_stack_top into .init.data section.
Date: Tue, 22 Sep 2009 10:22:20 -0400
Message-Id: <1253629347-23119-7-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253629347-23119-1-git-send-email-tabbott@ksplice.com>
References: <1253629347-23119-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since these get squashed into the .data output section by the m32r
linker script, it seems likely that they don't need their own input
sections.

At Hirokazu Takata's suggestion, we place these structures in
.init.data rather than just placing them in .data (since they are only
used at init time).

This patch is preparation for cleaning up the m32r architecture to use
the new macros in vmlinux.lds.h; if these sections are indeed not
needed, then we can use the RW_DATA_SECTION macro for m32r and save a
bunch of redundant code.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/m32r/kernel/head.S        |    4 ++--
 arch/m32r/kernel/vmlinux.lds.S |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/m32r/kernel/head.S b/arch/m32r/kernel/head.S
index 0a71944..a46652d 100644
--- a/arch/m32r/kernel/head.S
+++ b/arch/m32r/kernel/head.S
@@ -268,13 +268,13 @@ ENTRY(empty_zero_page)
 /*------------------------------------------------------------------------
  * Stack area
  */
-	.section .spi
+	.section .init.data, "aw"
 	ALIGN
 	.global spi_stack_top
 	.zero	1024
 spi_stack_top:
 
-	.section .spu
+	.section .init.data, "aw"
 	ALIGN
 	.global spu_stack_top
 	.zero	1024
diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index a8aa4a8..aadb24e 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -49,8 +49,6 @@ SECTIONS
 
   /* writeable */
   .data : {			/* Data */
-	*(.spu)
-	*(.spi)
 	DATA_DATA
 	CONSTRUCTORS
 	}
-- 
1.6.3.3

