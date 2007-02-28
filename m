Return-Path: <linux-kernel-owner+w=401wt.eu-S932468AbXB1Vui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbXB1Vui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932473AbXB1Vuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:50:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37911 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932468AbXB1VuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:50:00 -0500
Date: Wed, 28 Feb 2007 22:42:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 11/12] syslets: x86, wire up the syslet system calls
Message-ID: <20070228214215.GK2305@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228213938.GA945@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

wire up the new syslet / async system call syscalls and make it
thus available to user-space.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/i386/kernel/syscall_table.S |    6 ++++++
 include/asm-i386/unistd.h        |    8 +++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

Index: linux/arch/i386/kernel/syscall_table.S
===================================================================
--- linux.orig/arch/i386/kernel/syscall_table.S
+++ linux/arch/i386/kernel/syscall_table.S
@@ -319,3 +319,9 @@ ENTRY(sys_call_table)
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_async_exec		/* 320 */
+	.long sys_async_wait
+	.long sys_umem_add
+	.long sys_async_thread
+	.long sys_threadlet_on
+	.long sys_threadlet_off		/* 325 */
Index: linux/include/asm-i386/unistd.h
===================================================================
--- linux.orig/include/asm-i386/unistd.h
+++ linux/include/asm-i386/unistd.h
@@ -327,10 +327,16 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_async_exec		320
+#define __NR_async_wait		321
+#define __NR_umem_add		322
+#define __NR_async_thread	323
+#define __NR_threadlet_on	324
+#define __NR_threadlet_off	325
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 326
 
 #ifndef __ASSEMBLY__
 
