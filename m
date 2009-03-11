Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbZCKNwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbZCKNwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbZCKNwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:52:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:55112 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849AbZCKNwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:52:04 -0400
Date: Wed, 11 Mar 2009 13:51:25 GMT
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, gorcunov@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, gorcunov@gmail.com,
       mingo@elte.hu
In-Reply-To: <20090309171951.GE9945@localhost>
References: <20090309171951.GE9945@localhost>
Subject: [tip:x86/asm] x86: shrink __ALIGN and __ALIGN_STR definitions
Message-ID: <tip-bb7f5f6c26d0a304fb3af92591a1dddd39b6ac61@git.kernel.org>
Git-Commit-ID: bb7f5f6c26d0a304fb3af92591a1dddd39b6ac61
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Mar 2009 13:51:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb7f5f6c26d0a304fb3af92591a1dddd39b6ac61
Gitweb:     http://git.kernel.org/tip/bb7f5f6c26d0a304fb3af92591a1dddd39b6ac61
Author:     "Cyrill Gorcunov" <gorcunov@gmail.com>
AuthorDate: Mon, 9 Mar 2009 20:19:51 +0300
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Mar 2009 12:39:28 +0100

x86: shrink __ALIGN and __ALIGN_STR definitions

Impact: cleanup

1) .p2align 4 and .align 16 are the same meaning
   (until a.out format for i386 is used which is
    not our case for CONFIG_X86_ALIGNMENT_16 anyway)

2) having 15 as max allowed bytes to be skipped
   does not make sense on modulo 16

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <20090309171951.GE9945@localhost>
[ small cleanup, use __stringify(), etc. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/linkage.h |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index a0d70b4..12d55e7 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_LINKAGE_H
 #define _ASM_X86_LINKAGE_H
 
+#include <linux/stringify.h>
+
 #undef notrace
 #define notrace __attribute__((no_instrument_function))
 
@@ -53,14 +55,9 @@
 	.globl name;	\
 	name:
 
-#ifdef CONFIG_X86_64
-#define __ALIGN .p2align 4,,15
-#define __ALIGN_STR ".p2align 4,,15"
-#endif
-
-#ifdef CONFIG_X86_ALIGNMENT_16
-#define __ALIGN .align 16,0x90
-#define __ALIGN_STR ".align 16,0x90"
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_ALIGNMENT_16)
+#define __ALIGN		.p2align 4, 0x90
+#define __ALIGN_STR	__stringify(__ALIGN)
 #endif
 
 #endif /* __ASSEMBLY__ */
