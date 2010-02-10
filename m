Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab0BJAHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 19:07:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:55396 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab0BJAHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 19:07:06 -0500
Date: Wed, 10 Feb 2010 00:06:38 GMT
From: "tip-bot for Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       serue@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       serue@us.ibm.com, tglx@linutronix.de
In-Reply-To: <20100209023502.GA15408@us.ibm.com>
References: <20100209023502.GA15408@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32: Make AT_VECTOR_SIZE_ARCH=2
Message-ID: <tip-cf9db6c41f739a294286847aab1e85f39aef1781@git.kernel.org>
Git-Commit-ID: cf9db6c41f739a294286847aab1e85f39aef1781
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Feb 2010 00:06:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf9db6c41f739a294286847aab1e85f39aef1781
Gitweb:     http://git.kernel.org/tip/cf9db6c41f739a294286847aab1e85f39aef1781
Author:     Serge E. Hallyn <serue@us.ibm.com>
AuthorDate: Mon, 8 Feb 2010 20:35:02 -0600
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 9 Feb 2010 16:05:08 -0800

x86-32: Make AT_VECTOR_SIZE_ARCH=2

Both x86-32 and x86-64 with 32-bit compat use ARCH_DLINFO_IA32,
which defines two saved_auxv entries.  But system.h only defines
AT_VECTOR_SIZE_ARCH as 2 for CONFIG_IA32_EMULATION, not for
CONFIG_X86_32.  Fix that.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
LKML-Reference: <20100209023502.GA15408@us.ibm.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/system.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index ecb544e..e04740f 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -11,9 +11,9 @@
 #include <linux/irqflags.h>
 
 /* entries in ARCH_DLINFO: */
-#ifdef CONFIG_IA32_EMULATION
+#if defined(CONFIG_IA32_EMULATION) || !defined(CONFIG_X86_64)
 # define AT_VECTOR_SIZE_ARCH 2
-#else
+#else /* else it's non-compat x86-64 */
 # define AT_VECTOR_SIZE_ARCH 1
 #endif
 
