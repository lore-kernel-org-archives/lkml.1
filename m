Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162Ab0ANWah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab0ANWah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570Ab0ANWaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:30:10 -0500
Received: from kroah.org ([198.145.64.141]:60735 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab0ANW3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:29:04 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 50/52] module: handle ppc64 relocating kcrctabs when CONFIG_RELOCATABLE=y
Date: Thu, 14 Jan 2010 14:27:29 -0800
Message-Id: <1263508051-7868-50-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-49-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
 <1263508051-7868-23-git-send-email-gregkh@suse.de>
 <1263508051-7868-24-git-send-email-gregkh@suse.de>
 <1263508051-7868-25-git-send-email-gregkh@suse.de>
 <1263508051-7868-26-git-send-email-gregkh@suse.de>
 <1263508051-7868-27-git-send-email-gregkh@suse.de>
 <1263508051-7868-28-git-send-email-gregkh@suse.de>
 <1263508051-7868-29-git-send-email-gregkh@suse.de>
 <1263508051-7868-30-git-send-email-gregkh@suse.de>
 <1263508051-7868-31-git-send-email-gregkh@suse.de>
 <1263508051-7868-32-git-send-email-gregkh@suse.de>
 <1263508051-7868-33-git-send-email-gregkh@suse.de>
 <1263508051-7868-34-git-send-email-gregkh@suse.de>
 <1263508051-7868-35-git-send-email-gregkh@suse.de>
 <1263508051-7868-36-git-send-email-gregkh@suse.de>
 <1263508051-7868-37-git-send-email-gregkh@suse.de>
 <1263508051-7868-38-git-send-email-gregkh@suse.de>
 <1263508051-7868-39-git-send-email-gregkh@suse.de>
 <1263508051-7868-40-git-send-email-gregkh@suse.de>
 <1263508051-7868-41-git-send-email-gregkh@suse.de>
 <1263508051-7868-42-git-send-email-gregkh@suse.de>
 <1263508051-7868-43-git-send-email-gregkh@suse.de>
 <1263508051-7868-44-git-send-email-gregkh@suse.de>
 <1263508051-7868-45-git-send-email-gregkh@suse.de>
 <1263508051-7868-46-git-send-email-gregkh@suse.de>
 <1263508051-7868-47-git-send-email-gregkh@suse.de>
 <1263508051-7868-48-git-send-email-gregkh@suse.de>
 <1263508051-7868-49-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

commit d4703aefdbc8f9f347f6dcefcddd791294314eb7 upstream.

powerpc applies relocations to the kcrctab.  They're absolute symbols,
but it's not completely unreasonable: other archs may too, but the
relocation is often 0.

http://lists.ozlabs.org/pipermail/linuxppc-dev/2009-November/077972.html

Inspired-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/include/asm/module.h |    5 +++++
 arch/powerpc/kernel/vmlinux.lds.S |    3 +++
 kernel/module.c                   |   28 +++++++++++++++++++++-------
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/module.h b/arch/powerpc/include/asm/module.h
index 0845488..0192a4e 100644
--- a/arch/powerpc/include/asm/module.h
+++ b/arch/powerpc/include/asm/module.h
@@ -87,5 +87,10 @@ struct exception_table_entry;
 void sort_ex_table(struct exception_table_entry *start,
 		   struct exception_table_entry *finish);
 
+#ifdef CONFIG_MODVERSIONS
+#define ARCH_RELOCATES_KCRCTAB
+
+extern const unsigned long reloc_start[];
+#endif
 #endif /* __KERNEL__ */
 #endif	/* _ASM_POWERPC_MODULE_H */
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 27735a7..dcd01c8 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -38,6 +38,9 @@ jiffies = jiffies_64 + 4;
 #endif
 SECTIONS
 {
+	. = 0;
+	reloc_start = .;
+
 	. = KERNELBASE;
 
 /*
diff --git a/kernel/module.c b/kernel/module.c
index 37caef0..dfa33e8 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1030,11 +1030,23 @@ static int try_to_force_load(struct module *mod, const char *reason)
 }
 
 #ifdef CONFIG_MODVERSIONS
+/* If the arch applies (non-zero) relocations to kernel kcrctab, unapply it. */
+static unsigned long maybe_relocated(unsigned long crc,
+				     const struct module *crc_owner)
+{
+#ifdef ARCH_RELOCATES_KCRCTAB
+	if (crc_owner == NULL)
+		return crc - (unsigned long)reloc_start;
+#endif
+	return crc;
+}
+
 static int check_version(Elf_Shdr *sechdrs,
 			 unsigned int versindex,
 			 const char *symname,
 			 struct module *mod, 
-			 const unsigned long *crc)
+			 const unsigned long *crc,
+			 const struct module *crc_owner)
 {
 	unsigned int i, num_versions;
 	struct modversion_info *versions;
@@ -1055,10 +1067,10 @@ static int check_version(Elf_Shdr *sechdrs,
 		if (strcmp(versions[i].name, symname) != 0)
 			continue;
 
-		if (versions[i].crc == *crc)
+		if (versions[i].crc == maybe_relocated(*crc, crc_owner))
 			return 1;
 		DEBUGP("Found checksum %lX vs module %lX\n",
-		       *crc, versions[i].crc);
+		       maybe_relocated(*crc, crc_owner), versions[i].crc);
 		goto bad_version;
 	}
 
@@ -1081,7 +1093,8 @@ static inline int check_modstruct_version(Elf_Shdr *sechdrs,
 	if (!find_symbol(MODULE_SYMBOL_PREFIX "module_layout", NULL,
 			 &crc, true, false))
 		BUG();
-	return check_version(sechdrs, versindex, "module_layout", mod, crc);
+	return check_version(sechdrs, versindex, "module_layout", mod, crc,
+			     NULL);
 }
 
 /* First part is kernel version, which we ignore if module has crcs. */
@@ -1099,7 +1112,8 @@ static inline int check_version(Elf_Shdr *sechdrs,
 				unsigned int versindex,
 				const char *symname,
 				struct module *mod, 
-				const unsigned long *crc)
+				const unsigned long *crc,
+				const struct module *crc_owner)
 {
 	return 1;
 }
@@ -1134,8 +1148,8 @@ static const struct kernel_symbol *resolve_symbol(Elf_Shdr *sechdrs,
 	/* use_module can fail due to OOM,
 	   or module initialization or unloading */
 	if (sym) {
-		if (!check_version(sechdrs, versindex, name, mod, crc) ||
-		    !use_module(mod, owner))
+		if (!check_version(sechdrs, versindex, name, mod, crc, owner)
+		    || !use_module(mod, owner))
 			sym = NULL;
 	}
 	return sym;
-- 
1.6.6

