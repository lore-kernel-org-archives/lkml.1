Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbZKZJ4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbZKZJ4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759136AbZKZJ4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:56:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:41445 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759124AbZKZJ4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:56:51 -0500
Date: Thu, 26 Nov 2009 09:56:10 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1259176706-5908-1-git-send-email-brgerst@gmail.com>
References: <1259176706-5908-1-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Clean up the loadsegment() macro
Message-ID: <tip-64b028b22616946a05bf9580f7f7f7ee2ac070b4@git.kernel.org>
Git-Commit-ID: 64b028b22616946a05bf9580f7f7f7ee2ac070b4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  64b028b22616946a05bf9580f7f7f7ee2ac070b4
Gitweb:     http://git.kernel.org/tip/64b028b22616946a05bf9580f7f7f7ee2ac070b4
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 26 Nov 2009 10:37:55 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 10:38:52 +0100

x86: Clean up the loadsegment() macro

Make it readable in the source too, not just in the assembly output.
No change in functionality.

Cc: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1259176706-5908-1-git-send-email-brgerst@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/system.h |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 537395a..022a843 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -155,19 +155,21 @@ extern void native_load_gs_index(unsigned);
  * Load a segment. Fall back on loading the zero
  * segment if something goes wrong..
  */
-#define loadsegment(seg, value)			\
-do {						\
-	unsigned short __val = value;		\
-	asm volatile("\n"			\
-		     "1:\t"			\
-		     "movl %k0,%%" #seg "\n"	\
-		     ".section .fixup,\"ax\"\n"	\
-		     "2:\t"			\
-		     "xorl %k0,%k0\n\t"		\
-		     "jmp 1b\n"			\
-		     ".previous\n"		\
-		     _ASM_EXTABLE(1b, 2b)	\
-		     : "+r" (__val) : : "memory"); \
+#define loadsegment(seg, value)						\
+do {									\
+	unsigned short __val = (value);					\
+									\
+	asm volatile("						\n"	\
+		     "1:	movl %k0,%%" #seg "		\n"	\
+									\
+		     ".section .fixup,\"ax\"			\n"	\
+		     "2:	xorl %k0,%k0			\n"	\
+		     "		jmp 1b				\n"	\
+		     ".previous					\n"	\
+									\
+		     _ASM_EXTABLE(1b, 2b)				\
+									\
+		     : "+r" (__val) : : "memory");			\
 } while (0)
 
 /*
