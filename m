Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbZJMBeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbZJMBeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 21:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758718AbZJMBeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 21:34:31 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:41932 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758691AbZJMBe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 21:34:29 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v3 4/7] m68knommu: Use more macros inside the .init section.
Date: Mon, 12 Oct 2009 21:30:10 -0400
Message-Id: <1255397413-4862-5-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1255397413-4862-4-git-send-email-tabbott@ksplice.com>
References: <4AD3BFD8.90408@snapgear.com>
 <1255397413-4862-1-git-send-email-tabbott@ksplice.com>
 <1255397413-4862-2-git-send-email-tabbott@ksplice.com>
 <1255397413-4862-3-git-send-email-tabbott@ksplice.com>
 <1255397413-4862-4-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/m68knommu/kernel/vmlinux.lds.S |   23 +++++------------------
 1 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index 153569b..f7df82a 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -161,25 +161,12 @@ SECTIONS {
 		INIT_TEXT
 		_einittext = .;
 		INIT_DATA
-		. = ALIGN(16);
-		__setup_start = .;
-		*(.init.setup)
-		__setup_end = .;
-		__initcall_start = .;
+		INIT_SETUP(16)
+		INIT_CALL
 		INITCALLS
-		__initcall_end = .;
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-		__security_initcall_start = .;
-		*(.security_initcall.init)
-		__security_initcall_end = .;
-#ifdef CONFIG_BLK_DEV_INITRD
-		. = ALIGN(4);
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-#endif
+		CON_INITCALL
+		SECURITY_INITCALL
+		INIT_RAM_FS
 		. = ALIGN(PAGE_SIZE);
 		__init_end = .;
 	} > INIT
-- 
1.6.4.3

