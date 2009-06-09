Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbZFIGyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbZFIGyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbZFIGyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:54:45 -0400
Received: from 219-87-157-179.static.tfn.net.tw ([219.87.157.179]:53666 "EHLO
	mswedge1.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbZFIGyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:54:44 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 07/27] score: create head files elf.h emergency-restart.h errno.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF1B185198.8D225D85-ON482575D0.00235FF4-482575D0.0023D06F@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:26:53 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:26:54,
	Serialize complete at 2009/06/09 ?? 02:26:54
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 92de1d59c5c52dc1d64a9f6918b46afa4135afa3 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:08 +0800



Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/elf.h               |   99 
++++++++++++++++++++++++++++
 arch/score/include/asm/emergency-restart.h |    6 ++
 arch/score/include/asm/errno.h             |    7 ++
 3 files changed, 112 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/elf.h
 create mode 100644 arch/score/include/asm/emergency-restart.h
 create mode 100644 arch/score/include/asm/errno.h

diff --git a/arch/score/include/asm/elf.h b/arch/score/include/asm/elf.h
new file mode 100644
index 0000000..8324363
--- /dev/null
+++ b/arch/score/include/asm/elf.h
@@ -0,0 +1,99 @@
+#ifndef _ASM_SCORE_ELF_H
+#define _ASM_SCORE_ELF_H
+
+/* ELF register definitions */
+#define ELF_NGREG      45
+#define ELF_NFPREG     33
+#define EM_SCORE7      135
+
+/* Relocation types. */
+#define R_SCORE_NONE           0
+#define R_SCORE_HI16           1
+#define R_SCORE_LO16           2
+#define R_SCORE_BCMP           3
+#define R_SCORE_24             4
+#define R_SCORE_PC19           5
+#define R_SCORE16_11           6
+#define R_SCORE16_PC8          7
+#define R_SCORE_ABS32          8
+#define R_SCORE_ABS16          9
+#define R_SCORE_DUMMY2         10
+#define R_SCORE_GP15           11
+#define R_SCORE_GNU_VTINHERIT  12
+#define R_SCORE_GNU_VTENTRY    13
+#define R_SCORE_GOT15          14
+#define R_SCORE_GOT_LO16       15
+#define R_SCORE_CALL15         16
+#define R_SCORE_GPREL32                17
+#define R_SCORE_REL32          18
+#define R_SCORE_DUMMY_HI16     19
+#define R_SCORE_IMM30          20
+#define R_SCORE_IMM32          21
+
+typedef unsigned long elf_greg_t;
+typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+
+typedef double elf_fpreg_t;
+typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
+
+#define elf_check_arch(x)      ((x)->e_machine == EM_SCORE7)
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_CLASS      ELFCLASS32
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_DATA       ELFDATA2LSB
+#define ELF_ARCH       EM_SCORE7
+
+#define SET_PERSONALITY(ex)                                    \
+do {                                                           \
+       set_personality(PER_LINUX);                             \
+} while (0)
+
+struct task_struct;
+struct pt_regs;
+
+#define USE_ELF_CORE_DUMP
+#define ELF_EXEC_PAGESIZE      PAGE_SIZE
+
+/* This yields a mask that user programs can use to figure out what
+   instruction set this cpu supports.  This could be done in userspace,
+   but it's not easy, and we've already done it here.  */
+
+#define ELF_HWCAP      (0)
+
+/* This yields a string that ld.so will use to load implementation
+   specific libraries for optimization.  This is more specific in
+   intent than poking at uname or /proc/cpuinfo.
+
+   For the moment, we have only optimizations for the Intel generations,
+   but that could change... */
+
+#define ELF_PLATFORM   (NULL)
+
+#define ELF_PLAT_INIT(_r, load_addr)                                   \
+do {                                                                   \
+       _r->regs[1] = _r->regs[2] = _r->regs[3] = _r->regs[4] = 0;      \
+       _r->regs[5] = _r->regs[6] = _r->regs[7] = _r->regs[8] = 0;      \
+       _r->regs[9] = _r->regs[10] = _r->regs[11] = _r->regs[12] = 0;   \
+       _r->regs[13] = _r->regs[14] = _r->regs[15] = _r->regs[16] = 0;  \
+       _r->regs[17] = _r->regs[18] = _r->regs[19] = _r->regs[20] = 0;  \
+       _r->regs[21] = _r->regs[22] = _r->regs[23] = _r->regs[24] = 0;  \
+       _r->regs[25] = _r->regs[26] = _r->regs[27] = _r->regs[28] = 0;  \
+       _r->regs[30] = _r->regs[31] = 0;                                \
+} while (0)
+
+/* This is the location that an ET_DYN program is loaded if exec'ed. 
Typical
+   use of this is to invoke "./ld.so someprog" to test out a new version 
of
+   the loader.  We need to make sure that it is out of the way of the 
program
+   that it will "exec", and that there is sufficient room for the brk. */
+
+#ifndef ELF_ET_DYN_BASE
+#define ELF_ET_DYN_BASE                (TASK_SIZE / 3 * 2)
+#endif
+
+#endif /* _ASM_SCORE_ELF_H */
diff --git a/arch/score/include/asm/emergency-restart.h 
b/arch/score/include/asm/emergency-restart.h
new file mode 100644
index 0000000..ca31e98
--- /dev/null
+++ b/arch/score/include/asm/emergency-restart.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_EMERGENCY_RESTART_H
+#define _ASM_SCORE_EMERGENCY_RESTART_H
+
+#include <asm-generic/emergency-restart.h>
+
+#endif /* _ASM_SCORE_EMERGENCY_RESTART_H */
diff --git a/arch/score/include/asm/errno.h 
b/arch/score/include/asm/errno.h
new file mode 100644
index 0000000..7cd3e1f
--- /dev/null
+++ b/arch/score/include/asm/errno.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_SCORE_ERRNO_H
+#define _ASM_SCORE_ERRNO_H
+
+#include <asm-generic/errno.h>
+#define EMAXERRNO 1024
+
+#endif /* _ASM_SCORE_ERRNO_H */
-- 
1.6.2

