Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbZCEKqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbZCEKqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbZCEKqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:46:15 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:44775 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZCEKqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:46:14 -0500
Date: Thu, 5 Mar 2009 11:45:48 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Michlmayr <tbm@cyrius.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] MIPS: compat: Implement is_compat_task.
Message-ID: <20090305104548.GA20667@linux-mips.org>
References: <20090304202746.GA28981@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304202746.GA28981@deprecation.cyrius.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is merely a build fix required after
5b1017404aea6d2e552e991b3fd814d839e9cd67 was applied.  MIPS doesn't have
the issue that was fixed for x86-64 by that patch.

This also doesn't solve the N32 issue which is that N32 seccomp processes
will be treated as non-compat processes thus only have access to N64
syscalls.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/arch/mips/include/asm/compat.h b/arch/mips/include/asm/compat.h
index ac5d541..6c5b409 100644
--- a/arch/mips/include/asm/compat.h
+++ b/arch/mips/include/asm/compat.h
@@ -3,6 +3,8 @@
 /*
  * Architecture specific compatibility types
  */
+#include <linux/seccomp.h>
+#include <linux/thread_info.h>
 #include <linux/types.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
@@ -218,4 +220,9 @@ struct compat_shmid64_ds {
 	compat_ulong_t	__unused2;
 };
 
+static inline int is_compat_task(void)
+{
+	return test_thread_flag(TIF_32BIT);
+}
+
 #endif /* _ASM_COMPAT_H */
