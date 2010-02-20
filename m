Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab0BTAhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:37:43 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:50952 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab0BTAhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:37:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=K5heZcqLld8ukPlpPu0pXWbs3Dx6ynKaz15sWZAUvxSynr09x8r2SCCF9cHCDOCDio
         JuYLrdSfCuz5ZW87iNPgU0+frtKDiKSqA7+nHbrQFvrnT9hNP5CyselLFVUntPhR/Nqa
         zfh1Mz0cH4ZvoRD5JkObWWH5KZH5xs2lAec5c=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 10/24] Rename .data[.percpu][.xxx] to .data[..percpu][..xxx].
Date: Sat, 20 Feb 2010 01:37:12 +0100
Message-Id: <1266626233-25658-2-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 arch/ia64/include/asm/percpu.h    |    2 +-
 include/asm-generic/percpu.h      |   10 +++++-----
 include/asm-generic/vmlinux.lds.h |   24 ++++++++++++------------
 include/linux/percpu-defs.h       |    4 ++--
 kernel/module.c                   |    2 +-
 5 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/ia64/include/asm/percpu.h b/arch/ia64/include/asm/percpu.h
index 30cf465..35d9aeb 100644
--- a/arch/ia64/include/asm/percpu.h
+++ b/arch/ia64/include/asm/percpu.h
@@ -31,7 +31,7 @@ extern void *per_cpu_init(void);
 
 #endif	/* SMP */
 
-#define PER_CPU_BASE_SECTION ".data.percpu"
+#define PER_CPU_BASE_SECTION ".data..percpu"
 
 /*
  * Be extremely careful when taking the address of this variable!  Due to virtual
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index 8087b90..1202a15 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -76,7 +76,7 @@ extern void setup_per_cpu_areas(void);
 
 #ifndef PER_CPU_BASE_SECTION
 #ifdef CONFIG_SMP
-#define PER_CPU_BASE_SECTION ".data.percpu"
+#define PER_CPU_BASE_SECTION ".data..percpu"
 #else
 #define PER_CPU_BASE_SECTION ".data"
 #endif
@@ -88,15 +88,15 @@ extern void setup_per_cpu_areas(void);
 #define PER_CPU_SHARED_ALIGNED_SECTION ""
 #define PER_CPU_ALIGNED_SECTION ""
 #else
-#define PER_CPU_SHARED_ALIGNED_SECTION ".shared_aligned"
-#define PER_CPU_ALIGNED_SECTION ".shared_aligned"
+#define PER_CPU_SHARED_ALIGNED_SECTION "..shared_aligned"
+#define PER_CPU_ALIGNED_SECTION "..shared_aligned"
 #endif
-#define PER_CPU_FIRST_SECTION ".first"
+#define PER_CPU_FIRST_SECTION "..first"
 
 #else
 
 #define PER_CPU_SHARED_ALIGNED_SECTION ""
-#define PER_CPU_ALIGNED_SECTION ".shared_aligned"
+#define PER_CPU_ALIGNED_SECTION "..shared_aligned"
 #define PER_CPU_FIRST_SECTION ""
 
 #endif
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 32cddc1..e304fcd 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -666,16 +666,16 @@
  */
 #define PERCPU_VADDR(vaddr, phdr)					\
 	VMLINUX_SYMBOL(__per_cpu_load) = .;				\
-	.data.percpu vaddr : AT(VMLINUX_SYMBOL(__per_cpu_load)		\
+	.data..percpu vaddr : AT(VMLINUX_SYMBOL(__per_cpu_load)		\
 				- LOAD_OFFSET) {			\
 		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
-		*(.data.percpu.first)					\
-		*(.data.percpu.page_aligned)				\
-		*(.data.percpu)						\
-		*(.data.percpu.shared_aligned)				\
+		*(.data..percpu..first)					\
+		*(.data..percpu..page_aligned)				\
+		*(.data..percpu)					\
+		*(.data..percpu..shared_aligned)			\
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
 	} phdr								\
-	. = VMLINUX_SYMBOL(__per_cpu_load) + SIZEOF(.data.percpu);
+	. = VMLINUX_SYMBOL(__per_cpu_load) + SIZEOF(.data..percpu);
 
 /**
  * PERCPU - define output section for percpu area, simple version
@@ -687,18 +687,18 @@
  *
  * This macro is equivalent to ALIGN(align); PERCPU_VADDR( , ) except
  * that __per_cpu_load is defined as a relative symbol against
- * .data.percpu which is required for relocatable x86_32
+ * .data..percpu which is required for relocatable x86_32
  * configuration.
  */
 #define PERCPU(align)							\
 	. = ALIGN(align);						\
-	.data.percpu	: AT(ADDR(.data.percpu) - LOAD_OFFSET) {	\
+	.data..percpu	: AT(ADDR(.data..percpu) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__per_cpu_load) = .;			\
 		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
-		*(.data.percpu.first)					\
-		*(.data.percpu.page_aligned)				\
-		*(.data.percpu)						\
-		*(.data.percpu.shared_aligned)				\
+		*(.data..percpu..first)					\
+		*(.data..percpu..page_aligned)				\
+		*(.data..percpu)					\
+		*(.data..percpu..shared_aligned)			\
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
 	}
 
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 5a5d6ce..2351191 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -127,11 +127,11 @@
  * Declaration/definition used for per-CPU variables that must be page aligned.
  */
 #define DECLARE_PER_CPU_PAGE_ALIGNED(type, name)			\
-	DECLARE_PER_CPU_SECTION(type, name, ".page_aligned")		\
+	DECLARE_PER_CPU_SECTION(type, name, "..page_aligned")		\
 	__aligned(PAGE_SIZE)
 
 #define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)				\
-	DEFINE_PER_CPU_SECTION(type, name, ".page_aligned")		\
+	DEFINE_PER_CPU_SECTION(type, name, "..page_aligned")		\
 	__aligned(PAGE_SIZE)
 
 /*
diff --git a/kernel/module.c b/kernel/module.c
index f82386b..5daf0ab 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -397,7 +397,7 @@ static unsigned int find_pcpusec(Elf_Ehdr *hdr,
 				 Elf_Shdr *sechdrs,
 				 const char *secstrings)
 {
-	return find_sec(hdr, sechdrs, secstrings, ".data.percpu");
+	return find_sec(hdr, sechdrs, secstrings, ".data..percpu");
 }
 
 static void percpu_modcopy(void *pcpudest, const void *from, unsigned long size)
-- 
1.6.2.4

