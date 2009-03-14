Return-Path: <linux-kernel-owner+w=401wt.eu-S1765814AbZCNCEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765814AbZCNCEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 22:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbZCNBWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:22:12 -0400
Received: from kroah.org ([198.145.64.141]:35870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754149AbZCNBVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:37 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:48 2009
Message-Id: <20090314011048.190348139@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ralf Baechle <ralf@linux-mips.org>
Subject: [patch 113/114] MIPS: compat: Implement is_compat_task.
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=mips-compat-implement-is_compat_task.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ralf Baechle <ralf@linux-mips.org>

commit 4302e5d53b9166d45317e3ddf0a7a9dab3efd43b upstream.

This is a build fix required after "x86-64: seccomp: fix 32/64 syscall
hole" (commit 5b1017404aea6d2e552e991b3fd814d839e9cd67).  MIPS doesn't
have the issue that was fixed for x86-64 by that patch.

This also doesn't solve the N32 issue which is that N32 seccomp processes
will be treated as non-compat processes thus only have access to N64
syscalls.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/mips/include/asm/compat.h |    7 +++++++
 1 file changed, 7 insertions(+)

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


