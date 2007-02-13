Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbXBMOYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbXBMOYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932139AbXBMOYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:24:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33143 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbXBMOXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:23:50 -0500
Date: Tue, 13 Feb 2007 15:21:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 09/11] syslets: x86, wire up the syslet system calls
Message-ID: <20070213142126.GJ638@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

wire up the new syslet / async system call syscalls and make it
thus available to user-space.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/i386/kernel/syscall_table.S |    5 +++++
 include/asm-i386/unistd.h        |    7 ++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

Index: linux/arch/i386/kernel/syscall_table.S
===================================================================
--- linux.orig/arch/i386/kernel/syscall_table.S
+++ linux/arch/i386/kernel/syscall_table.S
@@ -319,3 +319,8 @@ ENTRY(sys_call_table)
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_async_register	/* 320 */
+	.long sys_async_exec
+	.long sys_async_wait
+	.long sys_async_unregister
+	.long sys_umem_add
Index: linux/include/asm-i386/unistd.h
===================================================================
--- linux.orig/include/asm-i386/unistd.h
+++ linux/include/asm-i386/unistd.h
@@ -325,10 +325,15 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_async_register	320
+#define __NR_async_exec		321
+#define __NR_async_wait		322
+#define __NR_async_unregister	323
+#define __NR_umem_add		324
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 325
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
