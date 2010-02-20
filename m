Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0BTAE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:04:27 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:53472 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab0BTAEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:04:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OlHi2xaYdrqXONVR7jXgtjlx+83eNYPZgnqFUMf4Kq4KSU/pzwAo/rbiVeSKljlNBK
         H1EFj3F8zT0qt8S4OkoYurLDANeLWUZ4Rd1CkEVLiK0yoJ/ALkva9oVNvLyYh/HIFfhw
         YXXGiRbZhlCDArxGk9WkzfzhPqIAvLWNI1VJI=
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
Subject: [PATCH 05/24] Rename .bss.page_aligned to .bss..page_aligned.
Date: Sat, 20 Feb 2010 01:03:38 +0100
Message-Id: <1266624237-22372-6-git-send-email-vda.linux@googlemail.com>
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
 arch/x86/kernel/vmlinux.lds.S     |    2 +-
 include/asm-generic/vmlinux.lds.h |    2 +-
 include/linux/linkage.h           |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index f92a0da..8b6bb4e 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -305,7 +305,7 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 		__bss_start = .;
-		*(.bss.page_aligned)
+		*(.bss..page_aligned)
 		*(.bss)
 		. = ALIGN(4);
 		__bss_stop = .;
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 569c25a..32cddc1 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -499,7 +499,7 @@
 #define BSS(bss_align)							\
 	. = ALIGN(bss_align);						\
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {				\
-		*(.bss.page_aligned)					\
+		*(.bss..page_aligned)					\
 		*(.dynbss)						\
 		*(.bss)							\
 		*(COMMON)						\
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 05f4406..7135ebc 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -19,7 +19,7 @@
 #endif
 
 #define __page_aligned_data	__section(.data..page_aligned) __aligned(PAGE_SIZE)
-#define __page_aligned_bss	__section(.bss.page_aligned) __aligned(PAGE_SIZE)
+#define __page_aligned_bss	__section(.bss..page_aligned) __aligned(PAGE_SIZE)
 
 /*
  * For assembly routines.
@@ -28,7 +28,7 @@
  * alignment directives yourself
  */
 #define __PAGE_ALIGNED_DATA	.section ".data..page_aligned", "aw"
-#define __PAGE_ALIGNED_BSS	.section ".bss.page_aligned", "aw"
+#define __PAGE_ALIGNED_BSS	.section ".bss..page_aligned", "aw"
 
 /*
  * This is used by architectures to keep arguments on the stack
-- 
1.6.2.4

