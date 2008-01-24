Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbYAZQDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbYAZQDb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbYAZPzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:55:54 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756653AbYAZPzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:55:51 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 11/52] [microblaze] kernel modules support
Date: Thu, 24 Jan 2008 16:02:46 +0100
Message-Id: <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/microblaze_ksyms.c |  129 +++++++++++++++++++++++++
 arch/microblaze/kernel/module.c           |  149 +++++++++++++++++++++++++++++
 include/asm-microblaze/module.h           |   41 ++++++++
 3 files changed, 319 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/microblaze_ksyms.c
 create mode 100644 arch/microblaze/kernel/module.c
 create mode 100644 include/asm-microblaze/module.h

diff --git a/arch/microblaze/kernel/microblaze_ksyms.c b/arch/microblaze/kernel/microblaze_ksyms.c
new file mode 100644
index 0000000..7ce8b36
--- /dev/null
+++ b/arch/microblaze/kernel/microblaze_ksyms.c
@@ -0,0 +1,129 @@
+/*
+ * linux/arch/microblaze/kernel/microblazeksyms.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/cryptohash.h>
+#include <linux/delay.h>
+#include <linux/in6.h>
+#include <linux/syscalls.h>
+
+#include <asm/checksum.h>
+#include <asm/io.h>
+#include <asm/page.h>
+#include <asm/system.h>
+#include <asm/uaccess.h>
+
+/* module handling */
+EXPORT_SYMBOL(PAGE_OFFSET);
+
+/*
+ * floating point math emulator support.
+ * These symbols will never change their calling convention...
+ */
+/* EXPORT_SYMBOL_ALIAS(kern_fp_enter,fp_enter);
+EXPORT_SYMBOL_ALIAS(fp_printk,printk);
+EXPORT_SYMBOL_ALIAS(fp_send_sig,send_sig);
+
+EXPORT_SYMBOL(__backtrace); */
+
+	/* platform dependent support */
+/* EXPORT_SYMBOL(__udelay);
+EXPORT_SYMBOL(__const_udelay); */
+
+	/* networking */
+EXPORT_SYMBOL(csum_partial);
+EXPORT_SYMBOL(csum_partial_copy);
+EXPORT_SYMBOL(csum_partial_copy_from_user);
+EXPORT_SYMBOL(ip_compute_csum);
+
+	/* io */
+/*#ifndef __raw_readsb
+EXPORT_SYMBOL(__raw_readsb);
+#endif
+#ifndef __raw_readsw
+EXPORT_SYMBOL(__raw_readsw);
+#endif
+#ifndef __raw_readsl
+EXPORT_SYMBOL(__raw_readsl);
+#endif
+#ifndef __raw_writesb
+EXPORT_SYMBOL(__raw_writesb);
+#endif
+#ifndef __raw_writesw
+EXPORT_SYMBOL(__raw_writesw);
+#endif
+#ifndef __raw_writesl
+EXPORT_SYMBOL(__raw_writesl);
+#endif*/
+
+	/* string / mem functions */
+/*EXPORT_SYMBOL(strchr);
+EXPORT_SYMBOL(strrchr);*/
+
+#ifdef __HAVE_ARCH_MEMSET
+EXPORT_SYMBOL(memset);
+#endif
+
+#ifdef __HAVE_ARCH_MEMCPY
+EXPORT_SYMBOL(memcpy);
+#endif
+
+#ifdef __HAVE_ARCH_MEMMOVE
+EXPORT_SYMBOL(memmove);
+#endif
+
+/* EXPORT_SYMBOL(memchr);
+EXPORT_SYMBOL(__memzero); */
+
+	/* user mem (segment) */
+/* EXPORT_SYMBOL(__strnlen_user);
+EXPORT_SYMBOL(__strncpy_from_user); */
+
+	/* crypto hash */
+/* EXPORT_SYMBOL(sha_transform); */
+
+
+/*
+ * libgcc functions - functions that are used internally by the
+ * compiler... (prototypes are not correct though, but that
+ * doesn't really matter since they're not versioned).
+ */
+extern void __ashldi3(void);
+EXPORT_SYMBOL(__ashldi3);
+extern void __ashrdi3(void);
+EXPORT_SYMBOL(__ashrdi3);
+extern void __divsi3(void);
+EXPORT_SYMBOL(__divsi3);
+extern void __lshrdi3(void);
+EXPORT_SYMBOL(__lshrdi3);
+extern void __modsi3(void);
+EXPORT_SYMBOL(__modsi3);
+extern void __mulsi3(void);
+EXPORT_SYMBOL(__mulsi3);
+extern void __muldi3(void);
+EXPORT_SYMBOL(__muldi3);
+extern void __ucmpdi2(void);
+EXPORT_SYMBOL(__ucmpdi2);
+extern void __udivsi3(void);
+EXPORT_SYMBOL(__udivsi3);
+extern void __umodsi3(void);
+EXPORT_SYMBOL(__umodsi3);
+/*extern void fpundefinstr(void);
+extern void fp_enter(void);*/
+
+	/* bitops */
+/* EXPORT_SYMBOL(_set_bit_le);
+EXPORT_SYMBOL(_test_and_set_bit_le);
+EXPORT_SYMBOL(_clear_bit_le);
+EXPORT_SYMBOL(_test_and_clear_bit_le);
+EXPORT_SYMBOL(_change_bit_le);
+EXPORT_SYMBOL(_test_and_change_bit_le);
+EXPORT_SYMBOL(_find_first_zero_bit_le);
+EXPORT_SYMBOL(_find_next_zero_bit_le);
+EXPORT_SYMBOL(_find_first_bit_le);
+EXPORT_SYMBOL(_find_next_bit_le); */
diff --git a/arch/microblaze/kernel/module.c b/arch/microblaze/kernel/module.c
new file mode 100644
index 0000000..d2befac
--- /dev/null
+++ b/arch/microblaze/kernel/module.c
@@ -0,0 +1,149 @@
+/*
+ * linux/arch/microblaze/kernel/module.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/module.h>
+#include <linux/moduleloader.h>
+#include <linux/kernel.h>
+#include <linux/elf.h>
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+
+#include <asm/pgtable.h>
+
+#if 0
+#define DBPRINTK(...) printk(__VA_ARGS__)
+#else
+#define DBPRINTK(...)
+#endif
+
+void *module_alloc(unsigned long size)
+{
+	void *ret;
+	ret = (size == 0) ? NULL : vmalloc(size);
+	DBPRINTK("module_alloc (%08lx@%08lx)\n", size, (unsigned long int)ret);
+	return ret;
+}
+
+void module_free(struct module *module, void *region)
+{
+	DBPRINTK("module_free(%s,%08lx)\n", module->name, region);
+	vfree(region);
+}
+
+int module_frob_arch_sections(Elf_Ehdr *hdr,
+				Elf_Shdr *sechdrs,
+				char *secstrings,
+				struct module *mod)
+{
+	return 0;
+}
+
+int
+apply_relocate(Elf32_Shdr * sechdrs, const char *strtab, unsigned int symindex,
+		unsigned int relsec, struct module *module)
+{
+
+	printk(KERN_ERR "module %s: ADD RELOCATION unsupported\n",
+		module->name);
+	return -ENOEXEC;
+
+}
+
+int
+apply_relocate_add(Elf32_Shdr * sechdrs, const char *strtab,
+	unsigned int symindex, unsigned int relsec, struct module *module)
+{
+
+	unsigned int i;
+	Elf32_Rela *rela = (void *)sechdrs[relsec].sh_addr;
+	Elf32_Sym *sym;
+	unsigned long int *location;
+	unsigned long int locoffs;
+	unsigned long int value;
+	unsigned long int old_value;
+
+	DBPRINTK("Applying add relocation section %u to %u\n",
+		relsec, sechdrs[relsec].sh_info);
+
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
+
+		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr +
+				rela[i].r_offset;
+		sym = (Elf32_Sym *)sechdrs[symindex].sh_addr +
+			ELF32_R_SYM(rela[i].r_info);
+		value = sym->st_value + rela[i].r_addend;
+
+		switch (ELF32_R_TYPE(rela[i].r_info)) {
+
+		/*
+		 * Be careful! mb-gcc / mb-ld splits the relocs between the
+		 * text and the reloc table. In general this means we must
+		 * read the current contents of (*location), add any offset
+		 * then store the result back in
+		 */
+
+		case R_MICROBLAZE_32:
+			old_value = *location;
+			*location = value + old_value;
+			DBPRINTK("R_MICROBLAZE_32 (%08lx->%08lx)\n",
+				old_value, value);
+			break;
+
+		case R_MICROBLAZE_64:
+			old_value = ((location[0] & 0x0000FFFF) << 16) |
+				((location[1] & 0x0000FFFF));
+			value += old_value;
+			location[0] = (location[0] & 0xFFFF0000) |
+					(value >> 16);
+			location[1] = (location[1] & 0xFFFF0000) |
+					(value & 0xFFFF);
+			DBPRINTK("R_MICROBLAZE_64 (%08lx->%08lx)\n",
+				old_value, value);
+			break;
+
+		case R_MICROBLAZE_64_PCREL:
+			locoffs = (location[0] & 0xFFFF) << 16 |
+				(location[1] & 0xFFFF);
+			value -= (unsigned long int)(location) + 4 +
+				locoffs;
+			location[0] = (location[0] & 0xFFFF0000) |
+					(value >> 16);
+			location[1] = (location[1] & 0xFFFF0000) |
+					(value & 0xFFFF);
+			DBPRINTK("R_MICROBLAZE_64_PCREL (%08lx)\n",
+				value);
+			break;
+
+		case R_MICROBLAZE_NONE:
+			DBPRINTK("R_MICROBLAZE_NONE\n");
+			break;
+
+		default:
+			printk(KERN_ERR "module %s: "
+				"Unknown relocation: %u\n",
+				module->name,
+				ELF32_R_TYPE(rela->r_info));
+			return -ENOEXEC;
+		}
+	}
+	return 0;
+}
+
+int
+module_finalize(const Elf32_Ehdr * hdr, const Elf_Shdr *sechdrs,
+		struct module *module)
+{
+	return 0;
+}
+
+void
+module_arch_cleanup(struct module *mod)
+{
+}
diff --git a/include/asm-microblaze/module.h b/include/asm-microblaze/module.h
new file mode 100644
index 0000000..97416e0
--- /dev/null
+++ b/include/asm-microblaze/module.h
@@ -0,0 +1,41 @@
+/*
+ * include/asm-microblaze/module.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MODULE_H
+#define _ASM_MODULE_H
+
+#define EM_XILINX_MICROBLAZE 0xbaab
+
+/* Microblaze Relocations */
+#define R_MICROBLAZE_NONE 0
+#define R_MICROBLAZE_32 1
+#define R_MICROBLAZE_32_PCREL 2
+#define R_MICROBLAZE_64_PCREL 3
+#define R_MICROBLAZE_32_PCREL_LO 4
+#define R_MICROBLAZE_64 5
+#define R_MICROBLAZE_32_LO 6
+#define R_MICROBLAZE_SRO32 7
+#define R_MICROBLAZE_SRW32 8
+#define R_MICROBLAZE_64_NONE 9
+#define R_MICROBLAZE_32_SYM_OP_SYM 10
+/* Keep this the last entry. */
+#define R_MICROBLAZE_NUM 11
+
+struct mod_arch_specific {
+	int foo;
+};
+
+#define Elf_Shdr	Elf32_Shdr
+#define Elf_Sym		Elf32_Sym
+#define Elf_Ehdr	Elf32_Ehdr
+
+typedef struct { volatile int counter; } module_t;
+
+#endif /* _ASM_MODULE_H */
-- 
1.5.4.rc4.14.g6fc74

