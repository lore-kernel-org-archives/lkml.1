Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab0BICfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 21:35:13 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:48653 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab0BICfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 21:35:10 -0500
Date: Mon, 8 Feb 2010 20:35:02 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: [PATCH RFC] Make AT_VECTOR_SIZE_ARCH 2 for x86-32
Message-ID: <20100209023502.GA15408@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both x86-32 and x86-64 with 32-bit compat use ARCH_DLINFO_IA32,
which defines two saved_auxv entries.  But system.h only defines
AT_VECTOR_SIZE_ARCH as 2 for CONFIG_IA32_EMULATION, not for
CONFIG_X86_32.  Fix that.

Am I on crack?

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
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
 
-- 
1.6.0.4

