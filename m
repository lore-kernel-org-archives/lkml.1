Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab0CAT7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:59:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:37727 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294Ab0CAT7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:59:46 -0500
Date: Mon, 1 Mar 2010 19:59:23 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       luca@luca-barbieri.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       luca@luca-barbieri.com, tglx@linutronix.de
In-Reply-To: <1267005265-27958-4-git-send-email-luca@luca-barbieri.com>
References: <1267005265-27958-4-git-send-email-luca@luca-barbieri.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/atomic] x86, atomic64: In selftest, distinguish x86-64 from 586+
Message-ID: <tip-a5c9161f27c3e1ae6c0094d262f03a7e98262181@git.kernel.org>
Git-Commit-ID: a5c9161f27c3e1ae6c0094d262f03a7e98262181
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 19:59:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5c9161f27c3e1ae6c0094d262f03a7e98262181
Gitweb:     http://git.kernel.org/tip/a5c9161f27c3e1ae6c0094d262f03a7e98262181
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 1 Mar 2010 11:49:23 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 1 Mar 2010 11:51:56 -0800

x86, atomic64: In selftest, distinguish x86-64 from 586+

The x86-64 implementation of the atomics is totally different from the
i586+ implementation, which makes it quite confusing to call it
"586+".  Also fix indentation, and add "i" for "i386" and "i586" as
used elsewhere in the kernel.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Luca Barbieri <luca@luca-barbieri.com>
LKML-Reference: <1267005265-27958-4-git-send-email-luca@luca-barbieri.com>
---
 lib/atomic64_test.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
index f7bb706..65e482c 100644
--- a/lib/atomic64_test.c
+++ b/lib/atomic64_test.c
@@ -144,14 +144,16 @@ static __init int test_atomic64(void)
 	BUG_ON(v.counter != r);
 
 #ifdef CONFIG_X86
-	printk(KERN_INFO "atomic64 test passed for %s+ platform %s CX8 and %s SSE\n",
-#ifdef CONFIG_X86_CMPXCHG64
-			"586",
+	printk(KERN_INFO "atomic64 test passed for %s platform %s CX8 and %s SSE\n",
+#ifdef CONFIG_X86_64
+	       "x86-64",
+#elif defined(CONFIG_X86_CMPXCHG64)
+	       "i586+",
 #else
-			"386",
+	       "i386+",
 #endif
-			boot_cpu_has(X86_FEATURE_CX8) ? "with" : "without",
-			boot_cpu_has(X86_FEATURE_XMM) ? "with" : "without");
+	       boot_cpu_has(X86_FEATURE_CX8) ? "with" : "without",
+	       boot_cpu_has(X86_FEATURE_XMM) ? "with" : "without");
 #else
 	printk(KERN_INFO "atomic64 test passed\n");
 #endif
