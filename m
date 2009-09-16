Return-Path: <linux-kernel-owner+w=401wt.eu-S1759909AbZIPQqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909AbZIPQqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759826AbZIPQqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:46:51 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42144 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759751AbZIPQqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:46:50 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Geoffrey Thomas <geofft@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2] sparc: Clean up linker script using new linker script macros.
Date: Wed, 16 Sep 2009 12:46:32 -0400
Message-Id: <1253119592-19598-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253119592-19598-1-git-send-email-tabbott@ksplice.com>
References: <1253119592-19598-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geoffrey Thomas <geofft@ksplice.com>

Signed-off-by: Geoffrey Thomas <geofft@ksplice.com>
Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/vmlinux.lds.S |   75 ++++-----------------------------------
 1 files changed, 7 insertions(+), 68 deletions(-)

diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index 866390f..4e59925 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -51,70 +51,27 @@ SECTIONS
 	_etext = .;
 
 	RO_DATA(PAGE_SIZE)
-	.data :	{
-		DATA_DATA
-		CONSTRUCTORS
-	}
 	.data1 : {
 		*(.data1)
 	}
-	. = ALIGN(SMP_CACHE_BYTES);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
-	}
-	. = ALIGN(SMP_CACHE_BYTES);
-	.data.read_mostly : {
-		*(.data.read_mostly)
-	}
+	RW_DATA_SECTION(SMP_CACHE_BYTES, 0, THREAD_SIZE)
+
 	/* End of data section */
 	_edata = .;
 
-	/* init_task */
-	. = ALIGN(THREAD_SIZE);
-	.data.init_task : {
-		*(.data.init_task)
-	}
 	.fixup : {
 		__start___fixup = .;
 		*(.fixup)
 		__stop___fixup = .;
 	}
-	. = ALIGN(16);
-	__ex_table : {
-		__start___ex_table = .;
-		*(__ex_table)
-		__stop___ex_table = .;
-	}
+	EXCEPTION_TABLE(16)
 	NOTES
 
 	. = ALIGN(PAGE_SIZE);
-	.init.text : {
-		__init_begin = .;
-		_sinittext = .;
-		INIT_TEXT
-		_einittext = .;
-	}
+	__init_begin = ALIGN(PAGE_SIZE);
+	INIT_TEXT_SECTION(PAGE_SIZE)
 	__init_text_end = .;
-	.init.data : {
-		INIT_DATA
-	}
-	. = ALIGN(16);
-	.init.setup : {
-		__setup_start = .;
-		*(.init.setup)
-		__setup_end = .;
-	}
-	.initcall.init : {
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
-	}
-	.con_initcall.init : {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-	}
-	SECURITY_INIT
+	INIT_DATA_SECTION(16)
 
 	. = ALIGN(4);
 	.tsb_ldquad_phys_patch : {
@@ -146,29 +103,11 @@ SECTIONS
 		__sun4v_2insn_patch_end = .;
 	}
 
-#ifdef CONFIG_BLK_DEV_INITRD
-	. = ALIGN(PAGE_SIZE);
-	.init.ramfs : {
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-	}
-#endif
-
 	PERCPU(PAGE_SIZE)
 
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
-	__bss_start = .;
-	.sbss : {
-		*(.sbss)
-		*(.scommon)
-	}
-	.bss : {
-		*(.dynbss)
-		*(.bss)
-		*(COMMON)
-	}
+	BSS_SECTION(0, 0, 0)
 	_end = . ;
 
 	STABS_DEBUG
-- 
1.6.3.3

