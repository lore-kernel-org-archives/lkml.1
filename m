Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbZJRR1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbZJRR1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 13:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbZJRR1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 13:27:45 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:47360 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754937AbZJRR1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 13:27:44 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v4 4/7] m68knommu: Use more macros inside the .init section.
Date: Sun, 18 Oct 2009 13:23:52 -0400
Message-Id: <1255886635-17371-4-git-send-email-tabbott@ksplice.com>
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
 arch/m68knommu/kernel/vmlinux.lds.S |   24 +++++-------------------
 1 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index 153569b..ac7e785 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -161,25 +161,11 @@ SECTIONS {
 		INIT_TEXT
 		_einittext = .;
 		INIT_DATA
-		. = ALIGN(16);
-		__setup_start = .;
-		*(.init.setup)
-		__setup_end = .;
-		__initcall_start = .;
-		INITCALLS
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
+		INIT_SETUP(16)
+		INIT_CALLS
+		CON_INITCALL
+		SECURITY_INITCALL
+		INIT_RAM_FS
 		. = ALIGN(PAGE_SIZE);
 		__init_end = .;
 	} > INIT
-- 
1.6.4.3

