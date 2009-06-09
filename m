Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbZFIGip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbZFIGip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbZFIGig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:38:36 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:58426 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbZFIGif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:38:35 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 18/27] score: create head files uaccess.h unaligned.h unistd.h
 user.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF596C037E.9CF83913-ON482575D0.0024055D-482575D0.002476E7@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:34:00 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:34:00,
	Serialize complete at 2009/06/09 ?? 02:34:00
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From dccb8b53daf3a5a6e312aabcabdab42b558f95e6 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:15 +0800
Subject: [PATCH 18/27] score: create head files uaccess.h unaligned.h 
unistd.h user.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/uaccess.h   |   27 +++++++++++++++++++++++++++
 arch/score/include/asm/unaligned.h |   11 +++++++++++
 arch/score/include/asm/unistd.h    |   12 ++++++++++++
 arch/score/include/asm/user.h      |    4 ++++
 4 files changed, 54 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/uaccess.h
 create mode 100644 arch/score/include/asm/unaligned.h
 create mode 100644 arch/score/include/asm/unistd.h
 create mode 100644 arch/score/include/asm/user.h

diff --git a/arch/score/include/asm/uaccess.h 
b/arch/score/include/asm/uaccess.h
new file mode 100644
index 0000000..43ce28a
--- /dev/null
+++ b/arch/score/include/asm/uaccess.h
@@ -0,0 +1,27 @@
+#ifndef _ASM_SCORE_UACCESS_H
+#define _ASM_SCORE_UACCESS_H
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General 
Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+struct pt_regs;
+extern int fixup_exception(struct pt_regs *regs);
+
+#ifndef __ASSEMBLY__
+
+#define __range_ok(addr, size)                                 \
+       ((((unsigned long)(addr) >= 0x80000000)                 \
+       || ((unsigned long)(size) > 0x80000000)                 \
+       || (((unsigned long)(addr) + (unsigned long)(size)) > 
0x80000000)))
+
+#define __access_ok(addr, size) \
+       (__range_ok((addr), (size)) == 0)
+
+#include <asm-generic/uaccess.h>
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_SCORE_UACCESS_H */
diff --git a/arch/score/include/asm/unaligned.h 
b/arch/score/include/asm/unaligned.h
new file mode 100644
index 0000000..4b8fec0
--- /dev/null
+++ b/arch/score/include/asm/unaligned.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_SCORE_UNALIGNED_H
+#define _ASM_SCORE_UNALIGNED_H
+
+#include <linux/unaligned/le_struct.h>
+#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/generic.h>
+
+#define get_unaligned  __get_unaligned_le
+#define put_unaligned  __put_unaligned_le
+
+#endif /* _ASM_SCORE_UNALIGNED_H */
diff --git a/arch/score/include/asm/unistd.h 
b/arch/score/include/asm/unistd.h
new file mode 100644
index 0000000..0cbfef8
--- /dev/null
+++ b/arch/score/include/asm/unistd.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_SCORE_UNISTD_H
+#define _ASM_SCORE_UNISTD_H
+
+#define __ARCH_HAVE_MMU
+#define __ARCH_WANT_SYSCALL_NO_AT
+#define __ARCH_WANT_SYSCALL_NO_FLAGS
+#define __ARCH_WANT_SYSCALL_OFF_T
+#define __ARCH_WANT_SYSCALL_DEPRECATED
+
+#include <asm-generic/unistd.h>
+
+#endif /* _ASM_SCORE_UNISTD_H */
diff --git a/arch/score/include/asm/user.h b/arch/score/include/asm/user.h
new file mode 100644
index 0000000..3cf7572
--- /dev/null
+++ b/arch/score/include/asm/user.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_SCORE_USER_H
+#define _ASM_SCORE_USER_H
+
+#endif /* _ASM_SCORE_USER_H */
-- 
1.6.2

