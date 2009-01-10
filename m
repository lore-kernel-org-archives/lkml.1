Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbZAJSLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbZAJSLi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZAJSLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:11:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:47266 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZAJSL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:11:29 -0500
Subject: [PATCH -tip] x86: module_64.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, rusty@rustcorp.com.au,
       Andi Kleen <andi@firstfloor.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 10 Jan 2009 23:39:10 +0530
Message-Id: <1231610950.3994.8.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Fix:

 ERROR: trailing whitespace
 ERROR: code indent should use tabs where possible
 WARNING: %Ld/%Lu are not-standard C, use %lld/%llu
 WARNING: printk() should include KERN_ facility level
 ERROR: spaces required around that '=' (ctx:VxW)

 total: 13 errors, 2 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/module_64.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

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
-- 
1.5.6.6



