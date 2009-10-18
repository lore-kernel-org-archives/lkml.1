Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbZJRRYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbZJRRYH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 13:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZJRRYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 13:24:05 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46721 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754692AbZJRRYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 13:24:01 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v4 1/7] m68knommu: Don't hardcode the value of PAGE_SIZE in the linker script.
Date: Sun, 18 Oct 2009 13:23:49 -0400
Message-Id: <1255886635-17371-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu>
References: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu>
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

