Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbZD0JyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbZD0JyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbZD0Jso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:48:44 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60685 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754525AbZD0Jsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:48:43 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 28/30] microblaze_mmu_v1: Elf update
Date: Mon, 27 Apr 2009 10:32:17 +0200
Message-Id: <1240821139-7247-29-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1240821139-7247-28-git-send-email-monstr@monstr.eu>
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>
 <1240821139-7247-2-git-send-email-monstr@monstr.eu>
 <1240821139-7247-3-git-send-email-monstr@monstr.eu>
 <1240821139-7247-4-git-send-email-monstr@monstr.eu>
 <1240821139-7247-5-git-send-email-monstr@monstr.eu>
 <1240821139-7247-6-git-send-email-monstr@monstr.eu>
 <1240821139-7247-7-git-send-email-monstr@monstr.eu>
 <1240821139-7247-8-git-send-email-monstr@monstr.eu>
 <1240821139-7247-9-git-send-email-monstr@monstr.eu>
 <1240821139-7247-10-git-send-email-monstr@monstr.eu>
 <1240821139-7247-11-git-send-email-monstr@monstr.eu>
 <1240821139-7247-12-git-send-email-monstr@monstr.eu>
 <1240821139-7247-13-git-send-email-monstr@monstr.eu>
 <1240821139-7247-14-git-send-email-monstr@monstr.eu>
 <1240821139-7247-15-git-send-email-monstr@monstr.eu>
 <1240821139-7247-16-git-send-email-monstr@monstr.eu>
 <1240821139-7247-17-git-send-email-monstr@monstr.eu>
 <1240821139-7247-18-git-send-email-monstr@monstr.eu>
 <1240821139-7247-19-git-send-email-monstr@monstr.eu>
 <1240821139-7247-20-git-send-email-monstr@monstr.eu>
 <1240821139-7247-21-git-send-email-monstr@monstr.eu>
 <1240821139-7247-22-git-send-email-monstr@monstr.eu>
 <1240821139-7247-23-git-send-email-monstr@monstr.eu>
 <1240821139-7247-24-git-send-email-monstr@monstr.eu>
 <1240821139-7247-25-git-send-email-monstr@monstr.eu>
 <1240821139-7247-26-git-send-email-monstr@monstr.eu>
 <1240821139-7247-27-git-send-email-monstr@monstr.eu>
 <1240821139-7247-28-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/elf.h |   94 +++++++++++++++++++++++++++++++++++++
 1 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/include/asm/elf.h b/arch/microblaze/include/asm/elf.h
index 81337f2..896b563 100644
--- a/arch/microblaze/include/asm/elf.h
+++ b/arch/microblaze/include/asm/elf.h
@@ -1,4 +1,6 @@
 /*
+ * Copyright (C) 2008-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2008-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -27,4 +29,96 @@
  */
 #define ELF_CLASS	ELFCLASS32
 
+#ifndef __uClinux__
+
+/*
+ * ELF register definitions..
+ */
+
+#include <asm/ptrace.h>
+#include <asm/user.h>
+#include <asm/byteorder.h>
+
+#ifndef ELF_GREG_T
+#define ELF_GREG_T
+typedef unsigned long elf_greg_t;
+#endif
+
+#ifndef ELF_NGREG
+#define ELF_NGREG (sizeof(struct pt_regs) / sizeof(elf_greg_t))
+#endif
+
+#ifndef ELF_GREGSET_T
+#define ELF_GREGSET_T
+typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+#endif
+
+#ifndef ELF_FPREGSET_T
+#define ELF_FPREGSET_T
+
+/* TBD */
+#define ELF_NFPREG	33	/* includes fsr */
+typedef unsigned long elf_fpreg_t;
+typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
+
+/* typedef struct user_fpu_struct elf_fpregset_t; */
+#endif
+
+/* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
+ * use of this is to invoke "./ld.so someprog" to test out a new version of
+ * the loader.  We need to make sure that it is out of the way of the program
+ * that it will "exec", and that there is sufficient room for the brk.
+ */
+
+#define ELF_ET_DYN_BASE         (0x08000000)
+
+#ifdef __LITTLE_ENDIAN__
+#define ELF_DATA	ELFDATA2LSB
+#else
+#define ELF_DATA	ELFDATA2MSB
+#endif
+
+#define USE_ELF_CORE_DUMP
+#define ELF_EXEC_PAGESIZE	4096
+
+
+#define ELF_CORE_COPY_REGS(_dest, _regs)			\
+	memcpy((char *) &_dest, (char *) _regs,		\
+	sizeof(struct pt_regs));
+
+/* This yields a mask that user programs can use to figure out what
+ * instruction set this CPU supports.  This could be done in user space,
+ * but it's not easy, and we've already done it here.
+ */
+#define ELF_HWCAP	(0)
+
+/* This yields a string that ld.so will use to load implementation
+ * specific libraries for optimization.  This is more specific in
+ * intent than poking at uname or /proc/cpuinfo.
+
+ * For the moment, we have only optimizations for the Intel generations,
+ * but that could change...
+ */
+#define ELF_PLATFORM  (NULL)
+
+/* Added _f parameter. Is this definition correct: TBD */
+#define ELF_PLAT_INIT(_r, _f)				\
+do {							\
+	_r->r1 =  _r->r1 =  _r->r2 =  _r->r3 =		\
+	_r->r4 =  _r->r5 =  _r->r6 =  _r->r7 =		\
+	_r->r8 =  _r->r9 =  _r->r10 = _r->r11 =		\
+	_r->r12 = _r->r13 = _r->r14 = _r->r15 =		\
+	_r->r16 = _r->r17 = _r->r18 = _r->r19 =		\
+	_r->r20 = _r->r21 = _r->r22 = _r->r23 =		\
+	_r->r24 = _r->r25 = _r->r26 = _r->r27 =		\
+	_r->r28 = _r->r29 = _r->r30 = _r->r31 =		\
+	0;						\
+} while (0)
+
+#ifdef __KERNEL__
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX_32BIT)
+#endif
+
+#endif /* __uClinux__ */
+
 #endif /* _ASM_MICROBLAZE_ELF_H */
-- 
1.5.5.1

