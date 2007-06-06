Return-Path: <linux-kernel-owner+w=401wt.eu-S966007AbXFFXoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966007AbXFFXoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965830AbXFFXlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:41:49 -0400
Received: from 8.sub-75-209-226.myvzw.com ([75.209.226.8]:59411 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965832AbXFFXlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:41:47 -0400
Message-Id: <20070606230922.257728963@goop.org>
References: <20070606225837.654272428@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 Jun 2007 15:58:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC 3/7] allow linux/elf.h to be included in assembler
Content-Disposition: inline; filename=asm-elf_h.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 include/linux/elf.h |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

===================================================================
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -1,9 +1,10 @@
 #ifndef _LINUX_ELF_H
 #define _LINUX_ELF_H
 
+#include <linux/elf-em.h>
+#ifndef __ASSEMBLY__
 #include <linux/types.h>
 #include <linux/auxvec.h>
-#include <linux/elf-em.h>
 #include <asm/elf.h>
 
 struct file;
@@ -31,6 +32,7 @@ typedef __u32	Elf64_Word;
 typedef __u32	Elf64_Word;
 typedef __u64	Elf64_Xword;
 typedef __s64	Elf64_Sxword;
+#endif	/* __ASSEMBLY__ */
 
 /* These constants are for the segment types stored in the image headers */
 #define PT_NULL    0
@@ -123,6 +125,7 @@ typedef __s64	Elf64_Sxword;
 #define ELF64_ST_BIND(x)	ELF_ST_BIND(x)
 #define ELF64_ST_TYPE(x)	ELF_ST_TYPE(x)
 
+#ifndef __ASSEMBLY__
 typedef struct dynamic{
   Elf32_Sword d_tag;
   union{
@@ -138,6 +141,7 @@ typedef struct {
     Elf64_Addr d_ptr;
   } d_un;
 } Elf64_Dyn;
+#endif	/* __ASSEMBLY__ */
 
 /* The following are used with relocations */
 #define ELF32_R_SYM(x) ((x) >> 8)
@@ -146,6 +150,7 @@ typedef struct {
 #define ELF64_R_SYM(i)			((i) >> 32)
 #define ELF64_R_TYPE(i)			((i) & 0xffffffff)
 
+#ifndef __ASSEMBLY__
 typedef struct elf32_rel {
   Elf32_Addr	r_offset;
   Elf32_Word	r_info;
@@ -185,11 +190,12 @@ typedef struct elf64_sym {
   Elf64_Addr st_value;		/* Value of the symbol */
   Elf64_Xword st_size;		/* Associated symbol size */
 } Elf64_Sym;
-
+#endif	/* __ASSEMBLY__ */
 
 #define EI_NIDENT	16
 
-typedef struct elf32_hdr{
+#ifndef __ASSEMBLY__
+typedef struct elf32_hdr {
   unsigned char	e_ident[EI_NIDENT];
   Elf32_Half	e_type;
   Elf32_Half	e_machine;
@@ -222,6 +228,7 @@ typedef struct elf64_hdr {
   Elf64_Half e_shnum;
   Elf64_Half e_shstrndx;
 } Elf64_Ehdr;
+#endif	/* __ASSEMBLY__ */
 
 /* These constants define the permissions on sections in the program
    header, p_flags. */
@@ -229,7 +236,8 @@ typedef struct elf64_hdr {
 #define PF_W		0x2
 #define PF_X		0x1
 
-typedef struct elf32_phdr{
+#ifndef __ASSEMBLY__
+typedef struct elf32_phdr {
   Elf32_Word	p_type;
   Elf32_Off	p_offset;
   Elf32_Addr	p_vaddr;
@@ -250,6 +258,7 @@ typedef struct elf64_phdr {
   Elf64_Xword p_memsz;		/* Segment size in memory */
   Elf64_Xword p_align;		/* Segment alignment, file & memory */
 } Elf64_Phdr;
+#endif	/* __ASSEMBLY__ */
 
 /* sh_type */
 #define SHT_NULL	0
@@ -284,7 +293,8 @@ typedef struct elf64_phdr {
 #define SHN_ABS		0xfff1
 #define SHN_COMMON	0xfff2
 #define SHN_HIRESERVE	0xffff
- 
+
+#ifndef __ASSEMBLY__
 typedef struct {
   Elf32_Word	sh_name;
   Elf32_Word	sh_type;
@@ -310,6 +320,7 @@ typedef struct elf64_shdr {
   Elf64_Xword sh_addralign;	/* Section alignment */
   Elf64_Xword sh_entsize;	/* Entry size if section holds table */
 } Elf64_Shdr;
+#endif	/* __ASSEMBLY__ */
 
 #define	EI_MAG0		0		/* e_ident[] indexes */
 #define	EI_MAG1		1
@@ -343,6 +354,7 @@ typedef struct elf64_shdr {
 
 #define ELFOSABI_NONE	0
 #define ELFOSABI_LINUX	3
+#define ELFOSABI_STANDALONE	255
 
 #ifndef ELF_OSABI
 #define ELF_OSABI ELFOSABI_NONE
@@ -357,6 +369,7 @@ typedef struct elf64_shdr {
 #define NT_PRXFPREG     0x46e62b7f      /* copied from gdb5.1/include/elf/common.h */
 
 
+#ifndef __ASSEMBLY__
 /* Note header in a PT_NOTE section */
 typedef struct elf32_note {
   Elf32_Word	n_namesz;	/* Name size */
@@ -396,5 +409,6 @@ static inline void arch_write_notes(stru
 #define ELF_CORE_EXTRA_NOTES_SIZE arch_notes_size()
 #define ELF_CORE_WRITE_EXTRA_NOTES arch_write_notes(file)
 #endif /* ARCH_HAVE_EXTRA_ELF_NOTES */
+#endif	/* __ASSEMBLY__ */
 
 #endif /* _LINUX_ELF_H */

-- 

