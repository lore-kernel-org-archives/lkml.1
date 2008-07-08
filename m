Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbYGHMLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbYGHMLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758559AbYGHMKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:10:23 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:26165 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758138AbYGHMKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:10:16 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 20/58] microblaze_v5: uaccess files
Date: Tue,  8 Jul 2008 13:59:20 +0200
Message-Id: <875ba2708f6cd3c585e4d965142e2feb07c39a0e.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
 <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
 <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
 <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/lib/uaccess.c    |   41 +++++++++++++
 include/asm-microblaze/uaccess.h |  120 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 161 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/lib/uaccess.c
 create mode 100644 include/asm-microblaze/uaccess.h

diff --git a/arch/microblaze/lib/uaccess.c b/arch/microblaze/lib/uaccess.c
new file mode 100644
index 0000000..03a3051
--- /dev/null
+++ b/arch/microblaze/lib/uaccess.c
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/string.h>
+#include <asm/uaccess.h>
+
+#include <asm/bug.h>
+
+long strnlen_user(const char __user *s, long n)
+{
+	return strlen(s) + 1;
+}
+
+#define __do_strncpy_from_user(dst, src, count, res)			\
+	do {								\
+		char *tmp;						\
+		strncpy(dst, src, count);				\
+		for (tmp = dst; *tmp && count > 0; tmp++, count--)	\
+			;						\
+		res = (tmp - dst);					\
+	} while (0)
+
+long __strncpy_from_user(char *dst, const char __user *src, long count)
+{
+	long res;
+	__do_strncpy_from_user(dst, src, count, res);
+	return res;
+}
+
+long strncpy_from_user(char *dst, const char *src, long count)
+{
+	long res = -EFAULT;
+	if (access_ok(VERIFY_READ, src, 1))
+		__do_strncpy_from_user(dst, src, count, res);
+	return res;
+}
diff --git a/include/asm-microblaze/uaccess.h b/include/asm-microblaze/uaccess.h
new file mode 100644
index 0000000..670fe06
--- /dev/null
+++ b/include/asm-microblaze/uaccess.h
@@ -0,0 +1,120 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_UACCESS_H
+#define _ASM_MICROBLAZE_UACCESS_H
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/sched.h> /* RLIMIT_FSIZE */
+
+#define VERIFY_READ	0
+#define VERIFY_WRITE	1
+
+extern int ___range_ok(unsigned long addr, unsigned long size);
+
+#define __range_ok(addr, size) \
+		___range_ok((unsigned long)(addr), (unsigned long)(size))
+
+#define access_ok(type, addr, size) (__range_ok((addr), (size)) == 0)
+#define __access_ok(add, size) (__range_ok((addr), (size)) == 0)
+
+extern inline int bad_user_access_length(void)
+{
+	return 0;
+}
+
+#define __get_user(var, ptr)						\
+	({								\
+		int __gu_err = 0;					\
+		switch (sizeof(*(ptr))) {				\
+		case 1:						\
+		case 2:						\
+		case 4:						\
+			(var) = *(ptr);				\
+			break;					\
+		case 8:						\
+			memcpy((void *) &(var), (ptr), 8);	\
+			break;					\
+		default:					\
+			(var) = 0;				\
+			__gu_err = __get_user_bad();		\
+			break;					\
+		}							\
+		__gu_err;						\
+	})
+
+#define __get_user_bad()	(bad_user_access_length(), (-EFAULT))
+
+#define __put_user(var, ptr)						\
+	({								\
+		int __pu_err = 0;					\
+		switch (sizeof(*(ptr))) {				\
+		case 1:						\
+		case 2:						\
+		case 4:						\
+			*(ptr) = (var);				\
+			break;					\
+		case 8: {					\
+			typeof(*(ptr)) __pu_val = var;		\
+			memcpy(ptr, &__pu_val, sizeof(__pu_val));\
+			}					\
+			break;					\
+		default:					\
+			__pu_err = __put_user_bad();		\
+			break;					\
+		}							\
+		__pu_err;						\
+	})
+
+#define __put_user_bad()	(bad_user_access_length(), (-EFAULT))
+
+#define put_user(x, ptr)	__put_user(x, ptr)
+#define get_user(x, ptr)	__get_user(x, ptr)
+
+#define copy_to_user(to, from, n)		(memcpy(to, from, n), 0)
+#define copy_from_user(to, from, n)		(memcpy(to, from, n), 0)
+
+#define __copy_to_user(to, from, n)		(copy_to_user(to, from, n))
+#define __copy_from_user(to, from, n)		(copy_from_user(to, from, n))
+#define __copy_to_user_inatomic(to, from, n)	(__copy_to_user(to, from, n))
+#define __copy_from_user_inatomic(to, from, n)	(__copy_from_user(to, from, n))
+
+#define __clear_user(addr, n)	(memset((void *)addr, 0, n), 0)
+
+/*
+ * The exception table consists of pairs of addresses: the first is the
+ * address of an instruction that is allowed to fault, and the second is
+ * the address at which the program should continue. No registers are
+ * modified, so it is entirely up to the continuation code to figure out
+ * what to do.
+ *
+ * All the routines below use bits of fixup code that are out of line
+ * with the main instruction path. This means when everything is well,
+ * we don't even have to jump over them. Further, they do not intrude
+ * on our cache or tlb entries.
+ */
+struct exception_table_entry {
+	unsigned long insn, fixup;
+};
+
+static inline unsigned long clear_user(void *addr, unsigned long size)
+{
+	if (access_ok(VERIFY_WRITE, addr, size))
+		size = __clear_user(addr, size);
+	return size;
+}
+
+/* Returns 0 if exception not found and fixup otherwise. */
+extern unsigned long search_exception_table(unsigned long);
+
+extern long strncpy_from_user(char *dst, const char *src, long count);
+extern long strnlen_user(const char *src, long count);
+extern long __strncpy_from_user(char *dst, const char *src, long count);
+
+#endif /* _ASM_MICROBLAZE_UACCESS_H */
-- 
1.5.4.GIT

