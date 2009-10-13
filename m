Return-Path: <linux-kernel-owner+w=401wt.eu-S1758700AbZJMBdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbZJMBdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 21:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758687AbZJMBdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 21:33:49 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:41770 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758685AbZJMBdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 21:33:47 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v3 1/7] m68knommu: Don't hardcode the value of PAGE_SIZE in the linker script.
Date: Mon, 12 Oct 2009 21:30:07 -0400
Message-Id: <1255397413-4862-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1255397413-4862-1-git-send-email-tabbott@ksplice.com>
References: <4AD3BFD8.90408@snapgear.com>
 <1255397413-4862-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/m68knommu/kernel/vmlinux.lds.S |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index 2736a5e..edc20bd 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -8,6 +8,7 @@
  */
 
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
 
 #if defined(CONFIG_RAMKERNEL)
 #define	RAM_START	CONFIG_KERNELBASE
@@ -155,7 +156,7 @@ SECTIONS {
 	} > DATA
 
 	.init : {
-		. = ALIGN(4096);
+		. = ALIGN(PAGE_SIZE);
 		__init_begin = .;
 		_sinittext = .;
 		INIT_TEXT
@@ -180,7 +181,7 @@ SECTIONS {
 		*(.init.ramfs)
 		__initramfs_end = .;
 #endif
-		. = ALIGN(4096);
+		. = ALIGN(PAGE_SIZE);
 		__init_end = .;
 	} > INIT
 
-- 
1.6.4.3

