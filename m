Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbZEKPLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbZEKPLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757508AbZEKPLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:11:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:36238 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069AbZEKPLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:11:19 -0400
Date: Mon, 11 May 2009 15:09:30 GMT
From: tip-bot for Alexey Dobriyan <adobriyan@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, adobriyan@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, adobriyan@gmail.com, mingo@elte.hu
In-Reply-To: <20090503232952.GI16631@x200.localdomain>
References: <20090503232952.GI16631@x200.localdomain>
Subject: [tip:x86/asm] x86, 32-bit: ifdef out struct thread_struct::fs
Message-ID: <tip-d756f4adb9d8a86e347a2d5435bb5cc95744733e@git.kernel.org>
Git-Commit-ID: d756f4adb9d8a86e347a2d5435bb5cc95744733e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 15:09:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d756f4adb9d8a86e347a2d5435bb5cc95744733e
Gitweb:     http://git.kernel.org/tip/d756f4adb9d8a86e347a2d5435bb5cc95744733e
Author:     Alexey Dobriyan <adobriyan@gmail.com>
AuthorDate: Mon, 4 May 2009 03:29:52 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 16:23:54 +0200

x86, 32-bit: ifdef out struct thread_struct::fs

After commit 464d1a78fbf8cf6c7fd970e7b3e2db50a320ce28 aka
"[PATCH] i386: Convert i386 PDA code to use %fs"
%fs saved during context switch moved from thread_struct to pt_regs
and value on thread_struct became unused.

[ Impact: reduce thread_struct size on 32-bit ]

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: containers@lists.linux-foundation.org
LKML-Reference: <20090503232952.GI16631@x200.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/processor.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c2cceae..a6732ff 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -428,7 +428,9 @@ struct thread_struct {
 	unsigned short		gsindex;
 #endif
 	unsigned long		ip;
+#ifdef CONFIG_X86_64
 	unsigned long		fs;
+#endif
 	unsigned long		gs;
 	/* Hardware debugging registers: */
 	unsigned long		debugreg0;
@@ -874,7 +876,6 @@ static inline void spin_lock_prefetch(const void *x)
 	.vm86_info		= NULL,					  \
 	.sysenter_cs		= __KERNEL_CS,				  \
 	.io_bitmap_ptr		= NULL,					  \
-	.fs			= __KERNEL_PERCPU,			  \
 }
 
 /*
