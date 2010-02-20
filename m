Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab0BTAEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:04:42 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:41685 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335Ab0BTAEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:04:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Cd49acf0Zd8pdYljZiDmSgHMOl3sXXaN87Fb94kt6IIKxm1v/7sUEUo14GXXxGqsn+
         7QC7qqPR7HoynKvJF5Mv0gTg5i3rw/jh3OsZG++zjEKfG2s/2tFd7OGdYXNlddXYuvym
         WLObg546NjN5umABtBB4llIMPtZXXQXeCjuEs=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Wesen <bjornw@axis.com>,
       Tim Bird <tim.bird@am.sony.com>, Tim Abbott <tabbott@ksplice.com>,
       Anders Kaseorg <andersk@ksplice.com>, Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 11/24] Rename .data.read_mostly to .data..read_mostly.
Date: Sat, 20 Feb 2010 01:03:44 +0100
Message-Id: <1266624237-22372-12-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/ia64/include/asm/cache.h     |    2 +-
 arch/ia64/kernel/paravirtentry.S  |    2 +-
 arch/ia64/xen/xensetup.S          |    2 +-
 arch/parisc/include/asm/cache.h   |    2 +-
 arch/parisc/kernel/head.S         |    2 +-
 arch/powerpc/include/asm/cache.h  |    2 +-
 arch/powerpc/kernel/vmlinux.lds.S |    2 +-
 arch/s390/include/asm/cache.h     |    2 +-
 arch/sh/include/asm/cache.h       |    2 +-
 arch/sparc/include/asm/cache.h    |    2 +-
 arch/x86/include/asm/cache.h      |    2 +-
 include/asm-generic/vmlinux.lds.h |    2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/ia64/include/asm/cache.h b/arch/ia64/include/asm/cache.h
index e7482bd..988254a 100644
--- a/arch/ia64/include/asm/cache.h
+++ b/arch/ia64/include/asm/cache.h
@@ -24,6 +24,6 @@
 # define SMP_CACHE_BYTES	(1 << 3)
 #endif
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".data..read_mostly")))
 
 #endif /* _ASM_IA64_CACHE_H */
diff --git a/arch/ia64/kernel/paravirtentry.S b/arch/ia64/kernel/paravirtentry.S
index 6158560..92d880c 100644
--- a/arch/ia64/kernel/paravirtentry.S
+++ b/arch/ia64/kernel/paravirtentry.S
@@ -28,7 +28,7 @@
 #include "entry.h"
 
 #define DATA8(sym, init_value)			\
-	.pushsection .data.read_mostly ;	\
+	.pushsection .data..read_mostly ;	\
 	.align 8 ;				\
 	.global sym ;				\
 	sym: ;					\
diff --git a/arch/ia64/xen/xensetup.S b/arch/ia64/xen/xensetup.S
index aff8346..b820ed0 100644
--- a/arch/ia64/xen/xensetup.S
+++ b/arch/ia64/xen/xensetup.S
@@ -14,7 +14,7 @@
 #include <linux/init.h>
 #include <xen/interface/elfnote.h>
 
-	.section .data.read_mostly
+	.section .data..read_mostly
 	.align 8
 	.global xen_domain_type
 xen_domain_type:
diff --git a/arch/parisc/include/asm/cache.h b/arch/parisc/include/asm/cache.h
index 32c2cca..45effe6 100644
--- a/arch/parisc/include/asm/cache.h
+++ b/arch/parisc/include/asm/cache.h
@@ -28,7 +28,7 @@
 
 #define SMP_CACHE_BYTES L1_CACHE_BYTES
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".data..read_mostly")))
 
 void parisc_cache_init(void);	/* initializes cache-flushing */
 void disable_sr_hashing_asm(int); /* low level support for above */
diff --git a/arch/parisc/kernel/head.S b/arch/parisc/kernel/head.S
index 0e3d9f9..4dbdf0e 100644
--- a/arch/parisc/kernel/head.S
+++ b/arch/parisc/kernel/head.S
@@ -345,7 +345,7 @@ smp_slave_stext:
 ENDPROC(stext)
 
 #ifndef CONFIG_64BIT
-	.section .data.read_mostly
+	.section .data..read_mostly
 
 	.align	4
 	.export	$global$,data
diff --git a/arch/powerpc/include/asm/cache.h b/arch/powerpc/include/asm/cache.h
index 81de6eb..3f41ab9 100644
--- a/arch/powerpc/include/asm/cache.h
+++ b/arch/powerpc/include/asm/cache.h
@@ -38,7 +38,7 @@ extern struct ppc64_caches ppc64_caches;
 #endif /* __powerpc64__ && ! __ASSEMBLY__ */
 
 #if !defined(__ASSEMBLY__)
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".data..read_mostly")))
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 951e6c5..8a0deef 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -233,7 +233,7 @@ SECTIONS
 		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 	}
 
-	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
+	.data..read_mostly : AT(ADDR(.data..read_mostly) - LOAD_OFFSET) {
 		READ_MOSTLY_DATA(L1_CACHE_BYTES)
 	}
 
diff --git a/arch/s390/include/asm/cache.h b/arch/s390/include/asm/cache.h
index 9b86681..24aafa6 100644
--- a/arch/s390/include/asm/cache.h
+++ b/arch/s390/include/asm/cache.h
@@ -14,6 +14,6 @@
 #define L1_CACHE_BYTES     256
 #define L1_CACHE_SHIFT     8
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".data..read_mostly")))
 
 #endif
diff --git a/arch/sh/include/asm/cache.h b/arch/sh/include/asm/cache.h
index 02df18e..455a9a9 100644
--- a/arch/sh/include/asm/cache.h
+++ b/arch/sh/include/asm/cache.h
@@ -14,7 +14,7 @@
 
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".data..read_mostly")))
 
 #ifndef __ASSEMBLY__
 struct cache_info {
diff --git a/arch/sparc/include/asm/cache.h b/arch/sparc/include/asm/cache.h
index 41f85ae..2909f0a 100644
--- a/arch/sparc/include/asm/cache.h
+++ b/arch/sparc/include/asm/cache.h
@@ -19,7 +19,7 @@
 
 #define SMP_CACHE_BYTES (1 << SMP_CACHE_BYTES_SHIFT)
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".data..read_mostly")))
 
 #ifdef CONFIG_SPARC32
 #include <asm/asi.h>
diff --git a/arch/x86/include/asm/cache.h b/arch/x86/include/asm/cache.h
index 2f9047c..48f99f1 100644
--- a/arch/x86/include/asm/cache.h
+++ b/arch/x86/include/asm/cache.h
@@ -7,7 +7,7 @@
 #define L1_CACHE_SHIFT	(CONFIG_X86_L1_CACHE_SHIFT)
 #define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+#define __read_mostly __attribute__((__section__(".data..read_mostly")))
 
 #define INTERNODE_CACHE_SHIFT CONFIG_X86_INTERNODE_CACHE_SHIFT
 #define INTERNODE_CACHE_BYTES (1 << INTERNODE_CACHE_SHIFT)
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index e304fcd..6f6da4f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -185,7 +185,7 @@
 
 #define READ_MOSTLY_DATA(align)						\
 	. = ALIGN(align);						\
-	*(.data.read_mostly)
+	*(.data..read_mostly)
 
 #define CACHELINE_ALIGNED_DATA(align)					\
 	. = ALIGN(align);						\
-- 
1.6.2.4

