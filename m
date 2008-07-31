Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbYGaMrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbYGaMrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYGaMrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:47:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbYGaMrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:47:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Wire up new system calls
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 31 Jul 2008 13:46:33 +0100
Message-ID: <20080731124633.28575.85362.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wire up for FRV the system calls that were added in the last merge window.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/entry.S  |    7 ++++++-
 include/asm-frv/unistd.h |    8 +++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/arch/frv/kernel/entry.S b/arch/frv/kernel/entry.S
index b8a4b94..99060ab 100644
--- a/arch/frv/kernel/entry.S
+++ b/arch/frv/kernel/entry.S
@@ -1519,6 +1519,11 @@ sys_call_table:
 	.long sys_fallocate
 	.long sys_timerfd_settime	/* 325 */
 	.long sys_timerfd_gettime
-
+	.long sys_signalfd4
+	.long sys_eventfd2
+	.long sys_epoll_create1
+	.long sys_dup3			/* 330 */
+	.long sys_pipe2
+	.long sys_inotify_init1
 
 syscall_table_size = (. - sys_call_table)
diff --git a/include/asm-frv/unistd.h b/include/asm-frv/unistd.h
index f184eb8..edcfaf5 100644
--- a/include/asm-frv/unistd.h
+++ b/include/asm-frv/unistd.h
@@ -333,10 +333,16 @@
 #define __NR_fallocate		324
 #define __NR_timerfd_settime	325
 #define __NR_timerfd_gettime	326
+#define __NR_signalfd4		327
+#define __NR_eventfd2		328
+#define __NR_epoll_create1	329
+#define __NR_dup3		330
+#define __NR_pipe2		331
+#define __NR_inotify_init1	332
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 325
+#define NR_syscalls 333
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 /* #define __ARCH_WANT_OLD_READDIR */

