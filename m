Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082Ab0BEWug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 17:50:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:37669 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933988Ab0BEWu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:50:29 -0500
Date: Fri, 5 Feb 2010 22:50:04 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1265380629-3212-7-git-send-email-brgerst@gmail.com>
References: <1265380629-3212-7-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/io] x86: Simplify flush_write_buffers()
Message-ID: <tip-910bf6ad0be3e1efbda0e9d358794937b52c9860@git.kernel.org>
Git-Commit-ID: 910bf6ad0be3e1efbda0e9d358794937b52c9860
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Feb 2010 22:50:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  910bf6ad0be3e1efbda0e9d358794937b52c9860
Gitweb:     http://git.kernel.org/tip/910bf6ad0be3e1efbda0e9d358794937b52c9860
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Fri, 5 Feb 2010 09:37:08 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 5 Feb 2010 13:57:38 -0800

x86: Simplify flush_write_buffers()

Always make it an inline instead of using a macro for the no-op case.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1265380629-3212-7-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/io_32.h |   10 ++--------
 arch/x86/include/asm/io_64.h |    8 +++++++-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/io_32.h b/arch/x86/include/asm/io_32.h
index 685e332..e8177f3 100644
--- a/arch/x86/include/asm/io_32.h
+++ b/arch/x86/include/asm/io_32.h
@@ -84,18 +84,12 @@ memcpy_toio(volatile void __iomem *dst, const void *src, size_t count)
  *	2. Accidentally out of order processors (PPro errata #51)
  */
 
-#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
-
 static inline void flush_write_buffers(void)
 {
+#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
 	asm volatile("lock; addl $0,0(%%esp)": : :"memory");
-}
-
-#else
-
-#define flush_write_buffers() do { } while (0)
-
 #endif
+}
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/x86/include/asm/io_64.h b/arch/x86/include/asm/io_64.h
index 1305525..6964a1c 100644
--- a/arch/x86/include/asm/io_64.h
+++ b/arch/x86/include/asm/io_64.h
@@ -83,7 +83,13 @@ memcpy_toio(volatile void __iomem *dst, const void *src, size_t count)
  *	1. Out of order aware processors
  *	2. Accidentally out of order processors (PPro errata #51)
  */
-#define flush_write_buffers() do { } while (0)
+
+static inline void flush_write_buffers(void)
+{
+#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
+	asm volatile("lock; addl $0,0(%%esp)": : :"memory");
+#endif
+}
 
 #endif /* __KERNEL__ */
 
