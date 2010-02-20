Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab0BTAEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:04:25 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:46309 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab0BTAEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:04:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Mz/ZPDVrL1vSdVYptJtQlzuygCMJ0LYMXRbFsITFqv40rNm2T30AGI9gbxOFB3Yb/y
         huYRg1t9lJkqGEPtzUYFYb76fUpXfEwRvoMvsGdqRGqviuEu7hLKUwHgiCzb5Qy6UeAN
         fIlErF8biA4zp2w9zNcIKx+S7ILWrX2NvkDL8=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Wesen <bjornw@axis.com>,
       Tim Bird <tim.bird@am.sony.com>, Tim Abbott <tabbott@ksplice.com>,
       Anders Kaseorg <andersk@ksplice.com>, Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 04/24] Rename .data.page_aligned to .data..page_aligned.
Date: Sat, 20 Feb 2010 01:03:37 +0100
Message-Id: <1266624237-22372-5-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@ksplice.com>

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/ia64/kernel/vmlinux.lds.S    |    2 +-
 arch/powerpc/kernel/vmlinux.lds.S |    2 +-
 include/asm-generic/vmlinux.lds.h |    2 +-
 include/linux/linkage.h           |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 1295ba3..7fb1198 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -175,7 +175,7 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
 
-  .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET)
+  .data..page_aligned : AT(ADDR(.data..page_aligned) - LOAD_OFFSET)
         {
 	PAGE_ALIGNED_DATA(PAGE_SIZE)
 	  . = ALIGN(PAGE_SIZE);
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 136dcf3..951e6c5 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -225,7 +225,7 @@ SECTIONS
 	/* The initial task and kernel stack */
 	INIT_TASK_DATA_SECTION(THREAD_SIZE)
 
-	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
+	.data..page_aligned : AT(ADDR(.data..page_aligned) - LOAD_OFFSET) {
 		PAGE_ALIGNED_DATA(PAGE_SIZE)
 	}
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 9cb9a90..569c25a 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -181,7 +181,7 @@
 
 #define PAGE_ALIGNED_DATA(page_align)					\
 	. = ALIGN(page_align);						\
-	*(.data.page_aligned)
+	*(.data..page_aligned)
 
 #define READ_MOSTLY_DATA(align)						\
 	. = ALIGN(align);						\
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 5126cce..05f4406 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -18,7 +18,7 @@
 # define asmregparm
 #endif
 
-#define __page_aligned_data	__section(.data.page_aligned) __aligned(PAGE_SIZE)
+#define __page_aligned_data	__section(.data..page_aligned) __aligned(PAGE_SIZE)
 #define __page_aligned_bss	__section(.bss.page_aligned) __aligned(PAGE_SIZE)
 
 /*
@@ -27,7 +27,7 @@
  * Note when using these that you must specify the appropriate
  * alignment directives yourself
  */
-#define __PAGE_ALIGNED_DATA	.section ".data.page_aligned", "aw"
+#define __PAGE_ALIGNED_DATA	.section ".data..page_aligned", "aw"
 #define __PAGE_ALIGNED_BSS	.section ".bss.page_aligned", "aw"
 
 /*
-- 
1.6.2.4

