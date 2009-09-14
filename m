Return-Path: <linux-kernel-owner+w=401wt.eu-S933552AbZINUIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552AbZINUIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933526AbZINUIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:37 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54033 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933216AbZINUI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:28 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 18/72] Blackfin: cleanup printk() usage in module code
Date: Mon, 14 Sep 2009 16:07:22 -0400
Message-Id: <1252958896-25150-19-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all printk() statements to use the common pr_xxx() funcs and use
the new pr_fmt() function to standardize all of the output.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/module.c |   59 +++++++++++++++++-----------------------
 1 files changed, 25 insertions(+), 34 deletions(-)

diff --git a/arch/blackfin/kernel/module.c b/arch/blackfin/kernel/module.c
index bb94078..b8f4c67 100644
--- a/arch/blackfin/kernel/module.c
+++ b/arch/blackfin/kernel/module.c
@@ -27,6 +27,7 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#define pr_fmt(fmt) "module %s: " fmt
 
 #include <linux/moduleloader.h>
 #include <linux/elf.h>
@@ -72,9 +73,8 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 			dest = l1_inst_sram_alloc(s->sh_size);
 			mod->arch.text_l1 = dest;
 			if (dest == NULL) {
-				printk(KERN_ERR
-				       "module %s: L1 instruction memory allocation failed\n",
-				       mod->name);
+				pr_err("L1 inst memory allocation failed\n",
+					mod->name);
 				return -1;
 			}
 			dma_memcpy(dest, (void *)s->sh_addr, s->sh_size);
@@ -87,8 +87,7 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 			dest = l1_data_sram_alloc(s->sh_size);
 			mod->arch.data_a_l1 = dest;
 			if (dest == NULL) {
-				printk(KERN_ERR
-					"module %s: L1 data memory allocation failed\n",
+				pr_err("L1 data memory allocation failed\n",
 					mod->name);
 				return -1;
 			}
@@ -102,8 +101,7 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 			dest = l1_data_sram_alloc(s->sh_size);
 			mod->arch.bss_a_l1 = dest;
 			if (dest == NULL) {
-				printk(KERN_ERR
-					"module %s: L1 data memory allocation failed\n",
+				pr_err("L1 data memory allocation failed\n",
 					mod->name);
 				return -1;
 			}
@@ -115,8 +113,7 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 			dest = l1_data_B_sram_alloc(s->sh_size);
 			mod->arch.data_b_l1 = dest;
 			if (dest == NULL) {
-				printk(KERN_ERR
-					"module %s: L1 data memory allocation failed\n",
+				pr_err("L1 data memory allocation failed\n",
 					mod->name);
 				return -1;
 			}
@@ -128,8 +125,7 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 			dest = l1_data_B_sram_alloc(s->sh_size);
 			mod->arch.bss_b_l1 = dest;
 			if (dest == NULL) {
-				printk(KERN_ERR
-					"module %s: L1 data memory allocation failed\n",
+				pr_err("L1 data memory allocation failed\n",
 					mod->name);
 				return -1;
 			}
@@ -143,9 +139,8 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 			dest = l2_sram_alloc(s->sh_size);
 			mod->arch.text_l2 = dest;
 			if (dest == NULL) {
-				printk(KERN_ERR
-				       "module %s: L2 SRAM allocation failed\n",
-				       mod->name);
+				pr_err("L2 SRAM allocation failed\n",
+					mod->name);
 				return -1;
 			}
 			memcpy(dest, (void *)s->sh_addr, s->sh_size);
@@ -158,8 +153,7 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 			dest = l2_sram_alloc(s->sh_size);
 			mod->arch.data_l2 = dest;
 			if (dest == NULL) {
-				printk(KERN_ERR
-					"module %s: L2 SRAM allocation failed\n",
+				pr_err("L2 SRAM allocation failed\n",
 					mod->name);
 				return -1;
 			}
@@ -173,8 +167,7 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 			dest = l2_sram_alloc(s->sh_size);
 			mod->arch.bss_l2 = dest;
 			if (dest == NULL) {
-				printk(KERN_ERR
-					"module %s: L2 SRAM allocation failed\n",
+				pr_err("L2 SRAM allocation failed\n",
 					mod->name);
 				return -1;
 			}
@@ -190,7 +183,7 @@ int
 apply_relocate(Elf_Shdr * sechdrs, const char *strtab,
 	       unsigned int symindex, unsigned int relsec, struct module *me)
 {
-	printk(KERN_ERR "module %s: .rel unsupported\n", me->name);
+	pr_err(".rel unsupported\n", me->name);
 	return -ENOEXEC;
 }
 
@@ -217,8 +210,8 @@ apply_relocate_add(Elf_Shdr * sechdrs, const char *strtab,
 	uint16_t *location16;
 	uint32_t value;
 
-	pr_debug("Applying relocate section %u to %u\n", relsec,
-	       sechdrs[relsec].sh_info);
+	pr_debug("applying relocate section %u to %u\n", mod->name,
+		relsec, sechdrs[relsec].sh_info);
 	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
 		/* This is where to make the change */
 		location16 =
@@ -231,21 +224,22 @@ apply_relocate_add(Elf_Shdr * sechdrs, const char *strtab,
 		    + ELF32_R_SYM(rel[i].r_info);
 		value = sym->st_value;
 		value += rel[i].r_addend;
-		pr_debug("location is %x, value is %x type is %d \n",
-			 (unsigned int) location32, value,
-			 ELF32_R_TYPE(rel[i].r_info));
+
 #ifdef CONFIG_SMP
 		if ((unsigned long)location16 >= COREB_L1_DATA_A_START) {
-			printk(KERN_ERR "module %s: cannot relocate in L1: %u (SMP kernel)",
-				       mod->name, ELF32_R_TYPE(rel[i].r_info));
+			pr_err("cannot relocate in L1: %u (SMP kernel)",
+				mod->name, ELF32_R_TYPE(rel[i].r_info));
 			return -ENOEXEC;
 		}
 #endif
+
+		pr_debug("location is %lx, value is %x type is %d\n",
+			mod->name, (unsigned long)location32, value,
+			ELF32_R_TYPE(rel[i].r_info));
+
 		switch (ELF32_R_TYPE(rel[i].r_info)) {
 
 		case R_BFIN_LUIMM16:
-			pr_debug("before %x after %x\n", *location16,
-				       (value & 0xffff));
 			tmp = (value & 0xffff);
 			if ((unsigned long)location16 >= L1_CODE_START) {
 				dma_memcpy(location16, &tmp, 2);
@@ -253,8 +247,6 @@ apply_relocate_add(Elf_Shdr * sechdrs, const char *strtab,
 				*location16 = tmp;
 			break;
 		case R_BFIN_HUIMM16:
-			pr_debug("before %x after %x\n", *location16,
-				       ((value >> 16) & 0xffff));
 			tmp = ((value >> 16) & 0xffff);
 			if ((unsigned long)location16 >= L1_CODE_START) {
 				dma_memcpy(location16, &tmp, 2);
@@ -265,7 +257,6 @@ apply_relocate_add(Elf_Shdr * sechdrs, const char *strtab,
 			*location16 = (value & 0xffff);
 			break;
 		case R_BFIN_BYTE4_DATA:
-			pr_debug("before %x after %x\n", *location32, value);
 			*location32 = value;
 			break;
 		case R_BFIN_PCREL24:
@@ -273,12 +264,12 @@ apply_relocate_add(Elf_Shdr * sechdrs, const char *strtab,
 		case R_BFIN_PCREL12_JUMP:
 		case R_BFIN_PCREL12_JUMP_S:
 		case R_BFIN_PCREL10:
-			printk(KERN_ERR "module %s: Unsupported relocation: %u (no -mlong-calls?)\n"
+			pr_err("unsupported relocation: %u (no -mlong-calls?)\n",
 				mod->name, ELF32_R_TYPE(rel[i].r_info));
 			return -ENOEXEC;
 		default:
-			printk(KERN_ERR "module %s: Unknown relocation: %u\n",
-			       mod->name, ELF32_R_TYPE(rel[i].r_info));
+			pr_err("unknown relocation: %u\n", mod->name,
+				ELF32_R_TYPE(rel[i].r_info));
 			return -ENOEXEC;
 		}
 	}
-- 
1.6.4.2

