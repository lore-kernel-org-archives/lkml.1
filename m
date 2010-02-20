Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab0BTAIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:08:32 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:53472 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab0BTAEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:04:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bZASrixhxyw55YM6mwveaFi1RHsB/BDAmnEGRB+ls6PZUyN0JZ4gm2e2F81uArBkQi
         a3OoRT78EieDZSPv+rgMnEdDSUlDHf3OztVOr8zp/q5P6BD5Io6cjcFuNgTCkckI7S2M
         5DScK0cVekTBxopcLXgSxuhmq6Py2tWPhDuMU=
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
Subject: [PATCH 01/24] Rename .data.cacheline_aligned to .data..cacheline_aligned.
Date: Sat, 20 Feb 2010 01:03:34 +0100
Message-Id: <1266624237-22372-2-git-send-email-vda.linux@googlemail.com>
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
 arch/powerpc/kernel/vmlinux.lds.S |    2 +-
 arch/x86/kernel/init_task.c       |    2 +-
 include/asm-generic/vmlinux.lds.h |    2 +-
 include/linux/cache.h             |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index dcd01c8..3229c06 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -231,7 +231,7 @@ SECTIONS
 		PAGE_ALIGNED_DATA(PAGE_SIZE)
 	}
 
-	.data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
+	.data..cacheline_aligned : AT(ADDR(.data..cacheline_aligned) - LOAD_OFFSET) {
 		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 	}
 
diff --git a/arch/x86/kernel/init_task.c b/arch/x86/kernel/init_task.c
index 3a54dcb..43e9ccf 100644
--- a/arch/x86/kernel/init_task.c
+++ b/arch/x86/kernel/init_task.c
@@ -34,7 +34,7 @@ EXPORT_SYMBOL(init_task);
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
  * no more per-task TSS's. The TSS size is kept cacheline-aligned
- * so they are allowed to end up in the .data.cacheline_aligned
+ * so they are allowed to end up in the .data..cacheline_aligned
  * section. Since TSS's are completely CPU-local, we want them
  * on exact cacheline boundaries, to eliminate cacheline ping-pong.
  */
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 67e6520..78450aa 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -189,7 +189,7 @@
 
 #define CACHELINE_ALIGNED_DATA(align)					\
 	. = ALIGN(align);						\
-	*(.data.cacheline_aligned)
+	*(.data..cacheline_aligned)
 
 #define INIT_TASK_DATA(align)						\
 	. = ALIGN(align);						\
diff --git a/include/linux/cache.h b/include/linux/cache.h
index 97e2488..4c57065 100644
--- a/include/linux/cache.h
+++ b/include/linux/cache.h
@@ -31,7 +31,7 @@
 #ifndef __cacheline_aligned
 #define __cacheline_aligned					\
   __attribute__((__aligned__(SMP_CACHE_BYTES),			\
-		 __section__(".data.cacheline_aligned")))
+		 __section__(".data..cacheline_aligned")))
 #endif /* __cacheline_aligned */
 
 #ifndef __cacheline_aligned_in_smp
-- 
1.6.2.4

