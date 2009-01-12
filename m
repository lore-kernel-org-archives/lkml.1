Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbZALJmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbZALJmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 04:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZALJmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 04:42:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:43247 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZALJma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 04:42:30 -0500
Subject: [PULL -tip] x86: fix style problems in microcode_intel.c, msr.c
	and module_XX.c
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       tigran@aivazian.fsnet.co.uk, shaohua.li@intel.com,
       rusty@rustcorp.com.au, Andi Kleen <andi@firstfloor.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 15:09:29 +0530
Message-Id: <1231753169.7087.5.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

These are safe cleanup patches, please pull them.

The following changes since commit bb3d7f3c5e418992c9012a850d16d2e11fe43f7e:
  Ingo Molnar (1):
        Merge branch 'linus'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tiptop.git master

Jaswinder Singh Rajput (4):
      x86: microcode_intel.c fix style problems
      x86: msr.c fix style problems
      x86: module_32.c fix style problems
      x86: module_64.c fix style problems

 arch/x86/kernel/microcode_intel.c |   10 +++++-----
 arch/x86/kernel/module_32.c       |    6 +++---
 arch/x86/kernel/module_64.c       |   32 ++++++++++++++++----------------
 arch/x86/kernel/msr.c             |    2 +-
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index b7f4c92..5e9f4fc 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -87,9 +87,9 @@
 #include <linux/cpu.h>
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
+#include <linux/uaccess.h>
 
 #include <asm/msr.h>
-#include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <asm/microcode.h>
 
@@ -196,7 +196,7 @@ static inline int update_match_cpu(struct cpu_signature *csig, int sig, int pf)
 	return (!sigmatch(sig, csig->sig, pf, csig->pf)) ? 0 : 1;
 }
 
-static inline int 
+static inline int
 update_match_revision(struct microcode_header_intel *mc_header,	int rev)
 {
 	return (mc_header->rev <= rev) ? 0 : 1;
@@ -442,8 +442,8 @@ static int request_microcode_fw(int cpu, struct device *device)
 		return ret;
 	}
 
-	ret = generic_load_microcode(cpu, (void*)firmware->data, firmware->size,
-			&get_ucode_fw);
+	ret = generic_load_microcode(cpu, (void *)firmware->data,
+				     firmware->size, &get_ucode_fw);
 
 	release_firmware(firmware);
 
@@ -460,7 +460,7 @@ static int request_microcode_user(int cpu, const void __user *buf, size_t size)
 	/* We should bind the task to the CPU */
 	BUG_ON(cpu != raw_smp_processor_id());
 
-	return generic_load_microcode(cpu, (void*)buf, size, &get_ucode_user);
+	return generic_load_microcode(cpu, (void *)buf, size, &get_ucode_user);
 }
 
 static void microcode_fini_cpu(int cpu)
diff --git a/arch/x86/kernel/module_32.c b/arch/x86/kernel/module_32.c
index 3db0a54..0edd819 100644
--- a/arch/x86/kernel/module_32.c
+++ b/arch/x86/kernel/module_32.c
@@ -42,7 +42,7 @@ void module_free(struct module *mod, void *module_region)
 {
 	vfree(module_region);
 	/* FIXME: If module_region == mod->init_region, trim exception
-           table entries. */
+	   table entries. */
 }
 
 /* We don't need anything special. */
@@ -113,13 +113,13 @@ int module_finalize(const Elf_Ehdr *hdr,
 		*para = NULL;
 	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
 
-	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) { 
+	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
 		if (!strcmp(".text", secstrings + s->sh_name))
 			text = s;
 		if (!strcmp(".altinstructions", secstrings + s->sh_name))
 			alt = s;
 		if (!strcmp(".smp_locks", secstrings + s->sh_name))
-			locks= s;
+			locks = s;
 		if (!strcmp(".parainstructions", secstrings + s->sh_name))
 			para = s;
 	}
diff --git a/arch/x86/kernel/module_64.c b/arch/x86/kernel/module_64.c
index 6ba8783..c23880b 100644
--- a/arch/x86/kernel/module_64.c
+++ b/arch/x86/kernel/module_64.c
@@ -30,14 +30,14 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
-#define DEBUGP(fmt...) 
+#define DEBUGP(fmt...)
 
 #ifndef CONFIG_UML
 void module_free(struct module *mod, void *module_region)
 {
 	vfree(module_region);
 	/* FIXME: If module_region == mod->init_region, trim exception
-           table entries. */
+	   table entries. */
 }
 
 void *module_alloc(unsigned long size)
@@ -77,7 +77,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
 	Elf64_Sym *sym;
 	void *loc;
-	u64 val; 
+	u64 val;
 
 	DEBUGP("Applying relocate section %u to %u\n", relsec,
 	       sechdrs[relsec].sh_info);
@@ -91,11 +91,11 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 		sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
 			+ ELF64_R_SYM(rel[i].r_info);
 
-	        DEBUGP("type %d st_value %Lx r_addend %Lx loc %Lx\n",
-		       (int)ELF64_R_TYPE(rel[i].r_info), 
-		       sym->st_value, rel[i].r_addend, (u64)loc);
+		DEBUGP("type %d st_value %Lx r_addend %Lx loc %Lx\n",
+			(int)ELF64_R_TYPE(rel[i].r_info),
+			sym->st_value, rel[i].r_addend, (u64)loc);
 
-		val = sym->st_value + rel[i].r_addend; 
+		val = sym->st_value + rel[i].r_addend;
 
 		switch (ELF64_R_TYPE(rel[i].r_info)) {
 		case R_X86_64_NONE:
@@ -113,16 +113,16 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 			if ((s64)val != *(s32 *)loc)
 				goto overflow;
 			break;
-		case R_X86_64_PC32: 
+		case R_X86_64_PC32:
 			val -= (u64)loc;
 			*(u32 *)loc = val;
 #if 0
 			if ((s64)val != *(s32 *)loc)
-				goto overflow; 
+				goto overflow;
 #endif
 			break;
 		default:
-			printk(KERN_ERR "module %s: Unknown rela relocation: %Lu\n",
+			printk(KERN_ERR "module %s: Unknown rela relocation: %llu\n",
 			       me->name, ELF64_R_TYPE(rel[i].r_info));
 			return -ENOEXEC;
 		}
@@ -130,7 +130,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 	return 0;
 
 overflow:
-	printk(KERN_ERR "overflow in relocation type %d val %Lx\n", 
+	printk(KERN_ERR "overflow in relocation type %d val %Lx\n",
 	       (int)ELF64_R_TYPE(rel[i].r_info), val);
 	printk(KERN_ERR "`%s' likely not compiled with -mcmodel=kernel\n",
 	       me->name);
@@ -143,13 +143,13 @@ int apply_relocate(Elf_Shdr *sechdrs,
 		   unsigned int relsec,
 		   struct module *me)
 {
-	printk("non add relocation not supported\n");
+	printk(KERN_ERR "non add relocation not supported\n");
 	return -ENOSYS;
-} 
+}
 
 int module_finalize(const Elf_Ehdr *hdr,
-                    const Elf_Shdr *sechdrs,
-                    struct module *me)
+		    const Elf_Shdr *sechdrs,
+		    struct module *me)
 {
 	const Elf_Shdr *s, *text = NULL, *alt = NULL, *locks = NULL,
 		*para = NULL;
@@ -161,7 +161,7 @@ int module_finalize(const Elf_Ehdr *hdr,
 		if (!strcmp(".altinstructions", secstrings + s->sh_name))
 			alt = s;
 		if (!strcmp(".smp_locks", secstrings + s->sh_name))
-			locks= s;
+			locks = s;
 		if (!strcmp(".parainstructions", secstrings + s->sh_name))
 			para = s;
 	}
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 7262666..3cf3413 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -35,10 +35,10 @@
 #include <linux/device.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
+#include <linux/uaccess.h>
 
 #include <asm/processor.h>
 #include <asm/msr.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 static struct class *msr_class;


