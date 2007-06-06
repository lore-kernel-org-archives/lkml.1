Return-Path: <linux-kernel-owner+w=401wt.eu-S936637AbXFFWcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936637AbXFFWcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935658AbXFFWau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:30:50 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1345 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935639AbXFFWas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:30:48 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Date: Wed, 06 Jun 2007 15:30:31 -0700
Subject: [patch 6/8] fdmap v2 - wire sys_nonseqfd to x86-64
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.4625.1181169040.6>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wire the new sys_nonseqfd system call to the x86-64 architecture.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


Index: linux-2.6.mod/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux-2.6.mod.orig/arch/x86_64/ia32/ia32entry.S	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/arch/x86_64/ia32/ia32entry.S	2007-06-06 12:48:39.000000000 -0700
@@ -719,4 +719,5 @@
 	.quad compat_sys_signalfd
 	.quad compat_sys_timerfd
 	.quad sys_eventfd
+	.quad sys_nonseqfd
 ia32_syscall_end:
Index: linux-2.6.mod/include/asm-x86_64/unistd.h
===================================================================
--- linux-2.6.mod.orig/include/asm-x86_64/unistd.h	2007-06-06 12:38:27.000000000 -0700
+++ linux-2.6.mod/include/asm-x86_64/unistd.h	2007-06-06 12:48:39.000000000 -0700
@@ -630,6 +630,8 @@
 __SYSCALL(__NR_timerfd, sys_timerfd)
 #define __NR_eventfd		283
 __SYSCALL(__NR_eventfd, sys_eventfd)
+#define __NR_nonseqfd		284
+__SYSCALL(__NR_nonseqfd, sys_nonseqfd)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR

