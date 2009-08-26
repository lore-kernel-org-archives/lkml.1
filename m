Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbZHZGkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbZHZGkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbZHZGkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:40:20 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:43660
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756852AbZHZGkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:40:16 -0400
Subject: Subject: [PATCH 05/33] score: create head files atomic.h auxvec.h
	bitops.h bitsperlong.h byteorder.h div64.h elf.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:11:02 +0800
Message-Id: <1251267062.3073.1.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e54bfb560857f537d13bdb68179e4aca883a8076 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:04:57 +0800
Subject: [PATCH 05/33] score: create head files atomic.h auxvec.h bitops.h bitsperlong.h byteorder.h div64.h elf.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/atomic.h      |    6 ++
 arch/score/include/asm/auxvec.h      |    4 +
 arch/score/include/asm/bitops.h      |   16 +++++
 arch/score/include/asm/bitsperlong.h |    6 ++
 arch/score/include/asm/byteorder.h   |    6 ++
 arch/score/include/asm/div64.h       |    6 ++
 arch/score/include/asm/elf.h         |  103 ++++++++++++++++++++++++++++++++++
 7 files changed, 147 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/atomic.h
 create mode 100644 arch/score/include/asm/auxvec.h
 create mode 100644 arch/score/include/asm/bitops.h
 create mode 100644 arch/score/include/asm/bitsperlong.h
 create mode 100644 arch/score/include/asm/byteorder.h
 create mode 100644 arch/score/include/asm/div64.h
 create mode 100644 arch/score/include/asm/elf.h

diff --git a/arch/score/include/asm/atomic.h b/arch/score/include/asm/atomic.h
new file mode 100644
index 0000000..84eb8dd
--- /dev/null
+++ b/arch/score/include/asm/atomic.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_ATOMIC_H
+#define _ASM_SCORE_ATOMIC_H
+
+#include <asm-generic/atomic.h>
+
+#endif /* _ASM_SCORE_ATOMIC_H */
diff --git a/arch/score/include/asm/auxvec.h b/arch/score/include/asm/auxvec.h
new file mode 100644
index 0000000..f691515
--- /dev/null
+++ b/arch/score/include/asm/auxvec.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_SCORE_AUXVEC_H
+#define _ASM_SCORE_AUXVEC_H
+
+#endif /* _ASM_SCORE_AUXVEC_H */
diff --git a/arch/score/include/asm/bitops.h b/arch/score/include/asm/bitops.h
new file mode 100644
index 0000000..2763b05
--- /dev/null
+++ b/arch/score/include/asm/bitops.h
@@ -0,0 +1,16 @@
+#ifndef _ASM_SCORE_BITOPS_H
+#define _ASM_SCORE_BITOPS_H
+
+#include <asm/byteorder.h> /* swab32 */
+#include <asm/system.h> /* save_flags */
+
+/*
+ * clear_bit() doesn't provide any barrier for the compiler.
+ */
+#define smp_mb__before_clear_bit()	barrier()
+#define smp_mb__after_clear_bit()	barrier()
+
+#include <asm-generic/bitops.h>
+#include <asm-generic/bitops/__fls.h>
+
+#endif /* _ASM_SCORE_BITOPS_H */
diff --git a/arch/score/include/asm/bitsperlong.h b/arch/score/include/asm/bitsperlong.h
new file mode 100644
index 0000000..86ff337
--- /dev/null
+++ b/arch/score/include/asm/bitsperlong.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_BITSPERLONG_H
+#define _ASM_SCORE_BITSPERLONG_H
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* _ASM_SCORE_BITSPERLONG_H */
diff --git a/arch/score/include/asm/byteorder.h b/arch/score/include/asm/byteorder.h
new file mode 100644
index 0000000..88cbebc
--- /dev/null
+++ b/arch/score/include/asm/byteorder.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_BYTEORDER_H
+#define _ASM_SCORE_BYTEORDER_H
+
+#include <linux/byteorder/little_endian.h>
+
+#endif /* _ASM_SCORE_BYTEORDER_H */
diff --git a/arch/score/include/asm/div64.h b/arch/score/include/asm/div64.h
new file mode 100644
index 0000000..75fae19
--- /dev/null
+++ b/arch/score/include/asm/div64.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_DIV64_H
+#define _ASM_SCORE_DIV64_H
+
+#include <asm-generic/div64.h>
+
+#endif /* _ASM_SCORE_DIV64_H */
diff --git a/arch/score/include/asm/elf.h b/arch/score/include/asm/elf.h
new file mode 100644
index 0000000..43526d9
--- /dev/null
+++ b/arch/score/include/asm/elf.h
@@ -0,0 +1,103 @@
+#ifndef _ASM_SCORE_ELF_H
+#define _ASM_SCORE_ELF_H
+
+#include <linux/ptrace.h>
+
+#define EM_SCORE7	135
+
+/* Relocation types. */
+#define R_SCORE_NONE		0
+#define R_SCORE_HI16		1
+#define R_SCORE_LO16		2
+#define R_SCORE_BCMP		3
+#define R_SCORE_24		4
+#define R_SCORE_PC19		5
+#define R_SCORE16_11		6
+#define R_SCORE16_PC8		7
+#define R_SCORE_ABS32		8
+#define R_SCORE_ABS16		9
+#define R_SCORE_DUMMY2		10
+#define R_SCORE_GP15		11
+#define R_SCORE_GNU_VTINHERIT	12
+#define R_SCORE_GNU_VTENTRY	13
+#define R_SCORE_GOT15		14
+#define R_SCORE_GOT_LO16	15
+#define R_SCORE_CALL15		16
+#define R_SCORE_GPREL32		17
+#define R_SCORE_REL32		18
+#define R_SCORE_DUMMY_HI16	19
+#define R_SCORE_IMM30		20
+#define R_SCORE_IMM32		21
+
+/* ELF register definitions */
+typedef unsigned long	elf_greg_t;
+
+#define ELF_NGREG	(sizeof(struct pt_regs) / sizeof(elf_greg_t))
+typedef elf_greg_t	elf_gregset_t[ELF_NGREG];
+
+/* Score does not have fp regs. */
+typedef double		elf_fpreg_t;
+typedef elf_fpreg_t	elf_fpregset_t;
+
+#define elf_check_arch(x)	((x)->e_machine == EM_SCORE7)
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_CLASS	ELFCLASS32
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_DATA	ELFDATA2LSB
+#define ELF_ARCH	EM_SCORE7
+
+#define SET_PERSONALITY(ex)					\
+do {								\
+	set_personality(PER_LINUX);				\
+} while (0)
+
+struct task_struct;
+struct pt_regs;
+
+#define CORE_DUMP_USE_REGSET
+#define USE_ELF_CORE_DUMP
+#define ELF_EXEC_PAGESIZE	PAGE_SIZE
+
+/* This yields a mask that user programs can use to figure out what
+   instruction set this cpu supports.  This could be done in userspace,
+   but it's not easy, and we've already done it here.  */
+
+#define ELF_HWCAP	(0)
+
+/* This yields a string that ld.so will use to load implementation
+   specific libraries for optimization.  This is more specific in
+   intent than poking at uname or /proc/cpuinfo.
+
+   For the moment, we have only optimizations for the Intel generations,
+   but that could change... */
+
+#define ELF_PLATFORM	(NULL)
+
+#define ELF_PLAT_INIT(_r, load_addr)					\
+do {									\
+	_r->regs[1] = _r->regs[2] = _r->regs[3] = _r->regs[4] = 0;	\
+	_r->regs[5] = _r->regs[6] = _r->regs[7] = _r->regs[8] = 0;	\
+	_r->regs[9] = _r->regs[10] = _r->regs[11] = _r->regs[12] = 0;	\
+	_r->regs[13] = _r->regs[14] = _r->regs[15] = _r->regs[16] = 0;	\
+	_r->regs[17] = _r->regs[18] = _r->regs[19] = _r->regs[20] = 0;	\
+	_r->regs[21] = _r->regs[22] = _r->regs[23] = _r->regs[24] = 0;	\
+	_r->regs[25] = _r->regs[26] = _r->regs[27] = _r->regs[28] = 0;	\
+	_r->regs[30] = _r->regs[31] = 0;				\
+} while (0)
+
+/* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
+   use of this is to invoke "./ld.so someprog" to test out a new version of
+   the loader.  We need to make sure that it is out of the way of the program
+   that it will "exec", and that there is sufficient room for the brk.  */
+
+#ifndef ELF_ET_DYN_BASE
+#define ELF_ET_DYN_BASE		(TASK_SIZE / 3 * 2)
+#endif
+
+#endif /* _ASM_SCORE_ELF_H */
-- 
1.6.2



