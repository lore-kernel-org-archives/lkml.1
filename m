Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbZIPVDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbZIPVDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760082AbZIPVDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:03:12 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57118 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760081AbZIPVDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:03:11 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v3 5/5] x86: Cleanup linker script using new linker script macros.
Date: Wed, 16 Sep 2009 16:44:30 -0400
Message-Id: <1253133870-25140-6-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253133870-25140-1-git-send-email-tabbott@ksplice.com>
References: <1253133870-25140-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/x86/kernel/vmlinux.lds.S |   47 ++--------------------------------------
 1 files changed, 3 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 7d6cef3..8d2d0a2 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -88,13 +88,7 @@ SECTIONS
 
 	NOTES :text :note
 
-	/* Exception table */
-	. = ALIGN(16);
-	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
-		__start___ex_table = .;
-		*(__ex_table)
-		__stop___ex_table = .;
-	} :text = 0x9090
+	EXCEPTION_TABLE(16) :text = 0x9090
 
 	RO_DATA(PAGE_SIZE)
 
@@ -207,36 +201,12 @@ SECTIONS
 	PERCPU_VADDR(0, :percpu)
 #endif
 
-	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
-		_sinittext = .;
-		INIT_TEXT
-		_einittext = .;
-	}
+	INIT_TEXT_SECTION(PAGE_SIZE)
 #ifdef CONFIG_X86_64
 	:init
 #endif
 
-	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
-		INIT_DATA
-	}
-
-	. = ALIGN(16);
-	.init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
-		__setup_start = .;
-		*(.init.setup)
-		__setup_end = .;
-	}
-	.initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
-	}
-
-	.con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-	}
+	INIT_DATA_SECTION(16)
 
 	.x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
 		__x86_cpu_dev_start = .;
@@ -244,8 +214,6 @@ SECTIONS
 		__x86_cpu_dev_end = .;
 	}
 
-	SECURITY_INIT
-
 	. = ALIGN(8);
 	.parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
 		__parainstructions = .;
@@ -276,15 +244,6 @@ SECTIONS
 		EXIT_DATA
 	}
 
-#ifdef CONFIG_BLK_DEV_INITRD
-	. = ALIGN(PAGE_SIZE);
-	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-	}
-#endif
-
 #if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
 	PERCPU(PAGE_SIZE)
 #endif
-- 
1.6.3.3

