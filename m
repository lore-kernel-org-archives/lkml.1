Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbZGaVB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbZGaVB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZGaVBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:01:55 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54574 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752971AbZGaVBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:01:53 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH 2/3] m32r: Move the spi_stack_top and spu_stack_top into .data section.
Date: Fri, 31 Jul 2009 16:58:06 -0400
Message-Id: <1249073887-30086-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249073887-30086-1-git-send-email-tabbott@ksplice.com>
References: <1249073887-30086-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since these get squashed into the .data output section by the m32r
linker script, it seems likely that they don't need their own input
sections.

I'd like an explicit confirmation from Hirokazu Takata that this is
correct (in particular, that there isn't some hidden reason why there
two structures need to be at the start of the .data output section).

This patch is preparation for cleaning up the m32r architecture to use
the new macros in vmlinux.lds.h; if these sections are indeed not
needed, then we can use the RW_DATA_SECTION macro for m32r and save a
bunch of redundant code.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/kernel/head.S        |    4 ++--
 arch/m32r/kernel/vmlinux.lds.S |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/m32r/kernel/head.S b/arch/m32r/kernel/head.S
index 0a71944..fc4d769 100644
--- a/arch/m32r/kernel/head.S
+++ b/arch/m32r/kernel/head.S
@@ -268,13 +268,13 @@ ENTRY(empty_zero_page)
 /*------------------------------------------------------------------------
  * Stack area
  */
-	.section .spi
+	.section .data
 	ALIGN
 	.global spi_stack_top
 	.zero	1024
 spi_stack_top:
 
-	.section .spu
+	.section .data
 	ALIGN
 	.global spu_stack_top
 	.zero	1024
diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index eb3e425..1984b9f 100644
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

